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
        if ($percent -ge ($lastPercent + 10) -or $percent -eq 100) {
            Write-InformationLog "$progress $percent% complete"
            $lastPercent = [math]::Floor($percent / 10) * 10
        }
        Write-DebugLog "$progress Building cache for $($hugoMarkdown.FrontMatter.title)"
        Build-ResourceRelatedCache -hugoMarkdown $hugoMarkdown -LocalPath $LocalPath -TopN $TopN
    }

}

function Build-ResourceRelatedCache {
    param (
        [HugoMarkdown]$hugoMarkdown,
        [string]$LocalPath = "./.data/content-embeddings/",
        [int]$TopN = 5000
    )
    $targetEmbeddingFile = Join-Path $LocalPath ("$($hugoMarkdown.FrontMatter.slug).embedding.json")
    if (-not (Test-Path $targetEmbeddingFile)) { return }
    $targetEmbeddingData = Get-Content $targetEmbeddingFile | ConvertFrom-Json
    $targetEmbedding = $targetEmbeddingData.embedding
    $cachePath = Join-Path (Split-Path $hugoMarkdown.FilePath) 'data.index.related.json'
    if (Test-Path $cachePath) {
        Write-InformationLog "  |-- Cache already exists for $($hugoMarkdown.ReferencePath), skipping."
        return
    }
    $allFiles = Get-ChildItem -Path $LocalPath -Filter *.embedding.json
    $similarities = @()
    $count = $allFiles.Count
    $i = 0
    $lastPercent = -10
    foreach ($file in $allFiles) {
        $i++
        $progress = "[{0}/{1}]" -f $i, $count
        $percent = [math]::Round(($i / $count) * 100, 1)
        if ($percent -ge ($lastPercent + 10) -or $percent -eq 100) {
            Write-InformationLog "  |-- $progress $percent% complete (Build-EmbeddingCache for $($hugoMarkdown.ReferencePath))"
            $lastPercent = [math]::Floor($percent / 10) * 10
        }
        if ($file.Name -eq "$($hugoMarkdown.FrontMatter.slug).embedding.json") { continue }
        $embeddingData = Get-Content $file.FullName | ConvertFrom-Json
        if ($embeddingData.embedding) {
            $similarity = Get-EmbeddingCosineSimilarity -VectorA $targetEmbedding -VectorB $embeddingData.embedding
            $similarities += [PSCustomObject]@{
                Title        = $embeddingData.title
                Slug         = $embeddingData.slug
                Reference    = $embeddingData.referencePath
                ResourceType = $embeddingData.resourceType
                ResourceId   = $embeddingData.ResourceId
                Similarity   = $similarity
            }
        }
    }
    $topRelated = $similarities | Sort-Object Similarity -Descending | Select-Object -First $TopN
    $output = @{
        calculatedAt = (Get-Date).ToUniversalTime().ToString('o')
        related      = $topRelated
    }
    $output | ConvertTo-Json -Depth 10 | Set-Content $cachePath
    Write-InformationLog "  |-- Saved to $cachePath"
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

#Build-ResourcesRelatedCache -HugoMarkdownObjects $hugoMarkdownObjects -LocalPath "./.data/content-embeddings/"
Write-DebugLog "--------------------------------------------------------"
Write-DebugLog "--------------------------------------------------------"


Write-DebugLog "All files checked."
