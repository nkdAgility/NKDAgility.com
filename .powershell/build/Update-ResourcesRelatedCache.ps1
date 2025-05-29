# Helpers (existing wrappers)
. ./.powershell/_includes/LoggingHelper.ps1
. ./.powershell/_includes/TokenServer.ps1
. ./.powershell/_includes/OpenAI.ps1
. ./.powershell/_includes/HugoHelpers.ps1
. ./.powershell/_includes/ResourceHelpers.ps1
. ./.powershell/_includes/ClassificationHelpers.ps1
. ./.powershell/_includes/AzureBlobHelpers.ps1
. ./.powershell/_includes/EmbeddingRepository.ps1

$ErrorActionPreference = 'Stop'
$levelSwitch.MinimumLevel = 'Information'

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
            Write-Progress -Activity "Building embedding cache for $($hugoMarkdown.ReferencePath)" -Status "$progress $percent% complete" -PercentComplete $percent -Id 1 
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
    }    $topRelated = $similarities | Sort-Object Similarity -Descending | Select-Object -First $TopN
    $output = @{
        #calculatedAt = (Get-Date).ToUniversalTime().ToString('o')
        related = $topRelated
    }
    $output | ConvertTo-Json -Depth 10 | Set-Content $cachePath
    Write-DebugLog "  |-- Saved to $cachePath (Recalculated: $recalculatedCount, Preserved: $preservedCount)"

    # Clear progress bar when not in debug mode
    if (-not (Get-IsDebug)) {
        Write-Progress -Activity "Building embedding cache for $($hugoMarkdown.ReferencePath)" -Completed -Id 1
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


###### TEST CODE BELOW HERE ######
# Parameters

Start-TokenServer
#$storageContext = New-AzStorageContext -SasToken $Env:AZURE_BLOB_STORAGE_SAS_TOKEN -StorageAccountName "nkdagilityblobs"
$hugoMarkdownObjects = Get-RecentHugoMarkdownResources -Path ".\site\content\resources\" -YearsBack 20
$hugoMarkdownObjects += Get-RecentHugoMarkdownResources -Path ".\site\content\tags\" -YearsBack 10
$hugoMarkdownObjects += Get-RecentHugoMarkdownResources -Path ".\site\content\categories\" -YearsBack 10
$hugoMarkdownObjects += Get-RecentHugoMarkdownResources -Path ".\site\content\concepts\" -YearsBack 10
#Update-EmbeddingRepository2 -HugoMarkdownObjects $hugoMarkdownObjects
Build-ResourcesRelatedCache -HugoMarkdownObjects $hugoMarkdownObjects -LocalPath "./.data/content-embeddings/"
Write-DebugLog "--------------------------------------------------------"
Write-DebugLog "--------------------------------------------------------"


Write-DebugLog "All files checked."
