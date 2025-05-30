. ./.powershell/_includes/LoggingHelper.ps1
. ./.powershell/_includes/TokenServer.ps1
. ./.powershell/_includes/OpenAI.ps1
. ./.powershell/_includes/HugoHelpers.ps1
. ./.powershell/_includes/ResourceHelpers.ps1
. ./.powershell/_includes/ClassificationHelpers.ps1
. ./.powershell/_includes/AzureBlobHelpers.ps1
. ./.powershell/_includes/EmbeddingRepository.ps1

function Get-ResourceRelatedItems {
    param (
        [HugoMarkdown]$hugoMarkdown,
        [int]$TopN = 5
    )
    $embeddingFilename = Get-EmbeddingResourceFileName -HugoMarkdown $hugoMarkdown
    $targetEmbeddingData = Get-BlobContentAsJson -Container $containerName -Blob $embeddingFilename
    if (-not $targetEmbeddingData) {
        throw "Embedding for target '$($hugoMarkdown.FrontMatter.slug)' not found."
    }

    $targetEmbedding = $targetEmbeddingData.embedding

    $allBlobs = Get-AzStorageBlob -Container $containerName -Context $storageContext
    $similarities = @()

    foreach ($blob in $allBlobs) {
        if ($blob.Name -eq $embeddingFilename) {
            continue
        }

        $embeddingData = Get-BlobContentAsJson -Container $containerName -Blob $blob.Name
        if ($embeddingData -and $embeddingData.embedding) {
            $similarity = Get-EmbeddingCosineSimilarity -VectorA $targetEmbedding -VectorB $embeddingData.embedding
            $similarities += [PSCustomObject]@{
                BlobName   = $blob.Name
                Similarity = $similarity
            }
        }
    }

    return $similarities | Sort-Object Similarity -Descending | Select-Object -First $TopN
}

function Build-ResourcesRelatedCache {
    param (
        [array]$HugoMarkdownObjects,
        [string]$LocalPath = "./.data/content-embeddings/",
        [int]$TopN = 5000
    )
    Write-InformationLog "Building embedding cache for all HugoMarkdown objects..."
    $count = $HugoMarkdownObjects.Count
    $i = 0
    $lastPercent = -10
    foreach ($hugoMarkdown in $HugoMarkdownObjects) {
        $i++
        $progress = "[{0}/{1}]" -f $i, $count
        $percent = [math]::Round(($i / $count) * 100, 1)
        
        # Use Write-Progress when not in debug mode, otherwise use logging
        if (Get-IsDebug) {
            if ($percent -ge ($lastPercent + 10) -or $percent -eq 100) {
                Write-InformationLog "$progress $percent% complete"
                $lastPercent = [math]::Floor($percent / 10) * 10
            }
            Write-DebugLog "$progress Building cache for $($hugoMarkdown.FrontMatter.title)"
        }
        else {
            Write-Progress -Activity "Building embedding cache for all HugoMarkdown objects" -Status "$progress $percent% complete - Processing: $($hugoMarkdown.FrontMatter.title)" -PercentComplete $percent -Id 0
        }
        Build-ResourceRelatedCache -hugoMarkdown $hugoMarkdown -LocalPath $LocalPath -TopN $TopN
    }

    # Clear progress bars when not in debug mode
    if (-not (Get-IsDebug)) {
        Write-Progress -Activity "Building embedding cache for all HugoMarkdown objects" -Completed -Id 0
    }
}

function Build-ResourceRelatedCache {
    param (
        [HugoMarkdown]$hugoMarkdown,
        [string]$LocalPath = "./.data/content-embeddings/",
        [int]$TopN = 5000
    )
    
    # Get function definitions to pass to parallel runspaces
    $getEmbeddingCosineSimilarityDef = ${function:Get-EmbeddingCosineSimilarity}
    $getEmbeddingResourceFileNameDef = ${function:Get-EmbeddingResourceFileName}
    $writeDebugLogDef = ${function:Write-DebugLog}
    $writeErrorLogDef = ${function:Write-ErrorLog}
    
    $targetEmbeddingFile = Join-Path $LocalPath (Get-EmbeddingResourceFileName -HugoMarkdown $hugoMarkdown)
    if (-not (Test-Path $targetEmbeddingFile)) { return }
    $targetEmbeddingData = Get-Content $targetEmbeddingFile | ConvertFrom-Json
    $targetEmbedding = $targetEmbeddingData.embedding
    $cachePath = Join-Path (Split-Path $hugoMarkdown.FilePath) 'data.index.related.json'
    
    # Load existing cache if it exists
    $existingCache = $null
    $existingRelatedLookup = @{}
    if (Test-Path $cachePath) {
        $existingCache = Get-Content $cachePath | ConvertFrom-Json
        # Create a lookup table for existing related items by their EntryId or Reference
        foreach ($item in $existingCache.related) {
            $key = if ($item.EntryId) { $item.EntryId } else { $item.Reference }
            if ($key) {
                $existingRelatedLookup[$key] = $item
            }
        }
        Write-DebugLog "  |-- Found existing cache for $($hugoMarkdown.ReferencePath) with $($existingCache.related.Count) items"
    }
    
    $allFiles = Get-ChildItem -Path $LocalPath -Filter *.embedding.json
    $count = $allFiles.Count
    
    # Thread-safe collections for parallel processing
    $threadSafeSimilarities = [System.Collections.Concurrent.ConcurrentBag[PSCustomObject]]::new()
    $threadSafeRecalculated = [System.Collections.Concurrent.ConcurrentBag[int]]::new()
    $threadSafePreserved = [System.Collections.Concurrent.ConcurrentBag[int]]::new()
    
    Write-DebugLog "  |-- Processing $count files in parallel for $($hugoMarkdown.ReferencePath)"
    
    $allFiles | ForEach-Object -Parallel {
        # Import function definitions into parallel runspace
        ${function:Get-EmbeddingCosineSimilarity} = $using:getEmbeddingCosineSimilarityDef
        ${function:Get-EmbeddingResourceFileName} = $using:getEmbeddingResourceFileNameDef
        ${function:Write-DebugLog} = $using:writeDebugLogDef
        ${function:Write-ErrorLog} = $using:writeErrorLogDef
        
        $file = $_
        $targetEmbedding = $using:targetEmbedding
        $hugoMarkdown = $using:hugoMarkdown
        $existingRelatedLookup = $using:existingRelatedLookup
        $threadSafeSimilarities = $using:threadSafeSimilarities
        $threadSafeRecalculated = $using:threadSafeRecalculated
        $threadSafePreserved = $using:threadSafePreserved
        
        if ($file.Name -eq (Get-EmbeddingResourceFileName -HugoMarkdown $hugoMarkdown)) { return }
        
        $embeddingData = Get-Content $file.FullName | ConvertFrom-Json
        if ($embeddingData.embedding) {
            $key = if ($embeddingData.entryId) { $embeddingData.entryId } else { $embeddingData.referencePath }
            $existingItem = $existingRelatedLookup[$key]
            
            $needsRecalculation = $true
            if ($existingItem -and $existingItem.EntryGenAt -and $embeddingData.generatedAt) {
                try {
                    # Compare timestamps - only recalculate if embedding is newer
                    $existingGenAt = $existingItem.EntryGenAt
                    $embeddingGenAt = $embeddingData.generatedAt
                    if ($embeddingGenAt -le $existingGenAt) {
                        # Preserve existing calculation
                        $threadSafeSimilarities.Add($existingItem)
                        $threadSafePreserved.Add(1)
                        $needsRecalculation = $false
                        Write-DebugLog "  |-- Preserving existing similarity for $($embeddingData.title) (embedding not newer)"
                    }
                }
                catch {
                    Write-ErrorLog "  |-- Error comparing generatedAt timestamps for $($embeddingData.title): $_"
                }
            }
            
            if ($needsRecalculation) {
                $similarity = Get-EmbeddingCosineSimilarity -VectorA $targetEmbedding -VectorB $embeddingData.embedding
                $similarityObject = [PSCustomObject]@{
                    Title      = $embeddingData.title
                    Slug       = $embeddingData.slug
                    Reference  = $embeddingData.referencePath 
                    EntryId    = $embeddingData.entryId
                    EntryKind  = $embeddingData.entryKind
                    EntryType  = $embeddingData.entryType
                    EntryGenAt = $embeddingData.generatedAt
                    Similarity = $similarity
                }
                $threadSafeSimilarities.Add($similarityObject)
                $threadSafeRecalculated.Add(1)
                Write-DebugLog "  |-- Recalculated similarity for $($embeddingData.title)"
            }
        }
    } -ThrottleLimit 80
    
    # Convert thread-safe collections back to arrays
    $similarities = $threadSafeSimilarities.ToArray()
    $recalculatedCount = $threadSafeRecalculated.Count
    $preservedCount = $threadSafePreserved.Count
    
    $topRelated = $similarities | Sort-Object Similarity -Descending | Select-Object -First $TopN
    $output = @{
        #calculatedAt = (Get-Date).ToUniversalTime().ToString('o')
        related = $topRelated
    }
    $output | ConvertTo-Json -Depth 10 | Set-Content $cachePath
    Write-DebugLog "  |-- Saved to $cachePath (Recalculated: $recalculatedCount, Preserved: $preservedCount)"
}

function Get-RelatedItems {
    param (
        [HugoMarkdown]$hugoMarkdown
    )
    $cachePath = Join-Path (Split-Path $hugoMarkdown.FolderPath) 'data.index.related.json'
    if (Test-Path $cachePath) {
        return Get-Content $cachePath | ConvertFrom-Json
    }
    else {
        Write-Warning "No related items cache found for $($hugoMarkdown.FolderPath)"
        return @()
    }
}
