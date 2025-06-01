

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
        [int]$TopN = 5000,
        [int]$ThrottleLimit = 1,
        [switch]$UseSequential
    )
    
    if ($UseSequential) {
        Write-InformationLog "Building embedding cache for all HugoMarkdown objects (sequential processing)..."
        Build-ResourcesRelatedCache-Sequential -HugoMarkdownObjects $HugoMarkdownObjects -LocalPath $LocalPath -TopN $TopN
        return
    }
    
    Write-InformationLog "Building embedding cache for all HugoMarkdown objects using parallel processing (ThrottleLimit: $ThrottleLimit)..."
    $count = $HugoMarkdownObjects.Count
    
    # Import required scripts and variables for parallel execution
    $scriptPaths = @(
        "./.powershell/_includes/IncludesForAll.ps1"
    )

    $indexedItems = @()
    for ($i = 0; $i -lt $HugoMarkdownObjects.Count; $i++) {
        $indexedItems += [PSCustomObject]@{
            HugoMarkdown = $HugoMarkdownObjects[$i]
            JobId        = $jobIdBase + $i
            Index        = $i
        }
    }
    

    # Process items in parallel and collect results
    $results = $indexedItems | ForEach-Object -Parallel {
        # Import all required scripts in each parallel runspace
        foreach ($scriptPath in $using:scriptPaths) {
            . $scriptPath
        }
        
        $item = $_
        $hugoMarkdown = $item.HugoMarkdown
        $jobId = $item.JobId
        
        try {
            Build-ResourceRelatedCache -hugoMarkdown $hugoMarkdown -LocalPath $using:LocalPath -TopN $using:TopN -jobId $jobId
            # Return success result
            [PSCustomObject]@{
                Success = $true
                Title   = $hugoMarkdown.FrontMatter.title
                JobId   = $jobId
                Error   = $null
            }
        }
        catch {
            # Return error result
            [PSCustomObject]@{
                Success = $false
                Title   = $hugoMarkdown.FrontMatter.title
                JobId   = $jobId
                Error   = $_.Exception.Message
            }
        }
    } -ThrottleLimit $ThrottleLimit
    
    # Report results
    $successCount = ($results | Where-Object { $_.Success }).Count
    $errorCount = ($results | Where-Object { -not $_.Success }).Count
    
    Write-InformationLog "Completed building embedding cache: $successCount successful, $errorCount errors out of $count total"
    
    # Log any errors
    $results | Where-Object { -not $_.Success } | ForEach-Object {
        Write-Warning "Failed to build cache for '$($_.Title)' (JobId: $($_.JobId)): $($_.Error)"
    }
}

function Build-ResourceRelatedCache {
    param (
        [HugoMarkdown]$hugoMarkdown,
        [string]$LocalPath = "./.data/content-embeddings/",
        [int]$TopN = 5000,
        [int]$jobId = 1
    )
    Write-InfoLog "Building embedding cache for $($hugoMarkdown.ReferencePath) (JobId: $jobId)..."
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
    $similarities = @()
    $count = $allFiles.Count
    $i = 0
    $lastPercent = -10
    $recalculatedCount = 0
    $preservedCount = 0
    foreach ($file in $allFiles) {
        $i++
        $progress = "[{0}/{1}]" -f $i, $count
        $percent = [math]::Round(($i / $count) * 100, 1)
        
        # Use Write-Progress when not in debug mode, otherwise use logging
        if (Get-IsDebug) {
            if ($percent -ge ($lastPercent + 10) -or $percent -eq 100) {
                Write-InformationLog "  |-- $progress $percent% complete (Build-EmbeddingCache for $($hugoMarkdown.ReferencePath))"
                $lastPercent = [math]::Floor($percent / 10) * 10
            }
        }
        else {
            Write-Progress -Activity "Building embedding cache for $($hugoMarkdown.ReferencePath)" -Status "$progress $percent% complete" -PercentComplete $percent -Id $jobId
        }
        
        if ($file.Name -eq (Get-EmbeddingResourceFileName -HugoMarkdown $hugoMarkdown)) { continue }
        
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
                        $similarities += $existingItem
                        $preservedCount++
                        $needsRecalculation = $false
                        Write-DebugLog "  |-- Preserving existing similarity for $($embeddingData.title) (embedding not newer)"
                    }
                }
                catch {
                    <#Do this if a terminating exception happens#>
                    Write-ErrorLog "  |-- Error comparing generatedAt timestamps for $($embeddingData.title): $_"
                }
                
                
               
            }
            
            if ($needsRecalculation) {
                $similarity = Get-EmbeddingCosineSimilarity -VectorA $targetEmbedding -VectorB $embeddingData.embedding
                $similarities += [PSCustomObject]@{
                    Title      = $embeddingData.title
                    Slug       = $embeddingData.slug
                    Reference  = $embeddingData.referencePath 
                    EntryId    = $embeddingData.entryId
                    EntryKind  = $embeddingData.entryKind
                    EntryType  = $embeddingData.entryType
                    EntryGenAt = $embeddingData.generatedAt
                    Similarity = $similarity
                }
                $recalculatedCount++
                Write-DebugLog "  |-- Recalculated similarity for $($embeddingData.title)"
            }
        }
    }   
    $topRelated = $similarities | Sort-Object Similarity -Descending | Select-Object -First $TopN
    $output = @{
        #calculatedAt = (Get-Date).ToUniversalTime().ToString('o')
        related = $topRelated
    }
    $output | ConvertTo-Json -Depth 10 | Set-Content $cachePath
    Write-DebugLog "  |-- Saved to $cachePath (Recalculated: $recalculatedCount, Preserved: $preservedCount)"

    # Clear progress bar when not in debug mode
    if (-not (Get-IsDebug)) {
        Write-Progress -Activity "Building embedding cache for $($hugoMarkdown.ReferencePath)" -Completed -Id $jobId
    }
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

function Build-ResourcesRelatedCache-Sequential {
    param (
        [array]$HugoMarkdownObjects,
        [string]$LocalPath = "./.data/content-embeddings/",
        [int]$TopN = 5000
    )
    Write-InformationLog "Building embedding cache for all HugoMarkdown objects (sequential processing)..."
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
