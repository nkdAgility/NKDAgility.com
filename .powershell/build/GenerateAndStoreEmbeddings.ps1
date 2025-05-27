# Helpers (existing wrappers)
. ./.powershell/_includes/LoggingHelper.ps1
. ./.powershell/_includes/TokenServer.ps1
. ./.powershell/_includes/OpenAI.ps1
. ./.powershell/_includes/HugoHelpers.ps1
. ./.powershell/_includes/ResourceHelpers.ps1
. ./.powershell/_includes/ClassificationHelpers.ps1
. ./.powershell/_includes/AzureBlobHelpers.ps1

Import-Module Az.Storage

$ErrorActionPreference = 'Stop'
$levelSwitch.MinimumLevel = 'Information'

# Parameters
$containerName = "content-embeddings"
$embeddingModel = "text-embedding-3-large"
Start-TokenServer

function Get-CosineSimilarity {
    param (
        [float[]]$VectorA,
        [float[]]$VectorB
    )

    $dotProduct = 0
    $magnitudeA = 0
    $magnitudeB = 0

    for ($i = 0; $i -lt $VectorA.Length; $i++) {
        $dotProduct += $VectorA[$i] * $VectorB[$i]
        $magnitudeA += [Math]::Pow($VectorA[$i], 2)
        $magnitudeB += [Math]::Pow($VectorB[$i], 2)
    }

    if ($magnitudeA -eq 0 -or $magnitudeB -eq 0) {
        return 0
    }

    return $dotProduct / ([Math]::Sqrt($magnitudeA) * [Math]::Sqrt($magnitudeB))
}

function Generate-AndStoreEmbedding {
    param ([HugoMarkdown]$hugoMarkdown)

    $contentText = Get-Content -Path $hugoMarkdown.FilePath -Raw
    $contentHash = Get-ContentHash $contentText
    $embeddingBlobName = "$($hugoMarkdown.FrontMatter.slug).embedding.json"

    $existingEmbedding = Get-BlobContentAsJson -Container $containerName -Blob $embeddingBlobName

    if ($existingEmbedding -and $existingEmbedding.contentHash -eq $contentHash) {
        Write-InformationLog "No content changes for '{Title}', skipping embedding." -PropertyValues $hugoMarkdown.FrontMatter.title
        return
    }

    Write-InformationLog "Generating embedding for '{Title}'." -PropertyValues $hugoMarkdown.FrontMatter.title

    $embedding = Get-OpenAIEmbedding -Content $contentText -Model $embeddingModel

    $embeddingData = @{
        fileName      = $hugoMarkdown.FileName
        title         = $hugoMarkdown.FrontMatter.title
        slug          = $hugoMarkdown.FrontMatter.slug
        referencePath = $hugoMarkdown.ReferencePath
        generatedAt   = (Get-Date).ToUniversalTime()
        contentHash   = $contentHash
        embedding     = $embedding
    }

    Set-BlobContentAsJson -Container $containerName -Blob $embeddingBlobName -Content $embeddingData

    Write-InformationLog "Embedding updated successfully for '{Title}'." -PropertyValues $hugoMarkdown.FrontMatter.title
}

function Get-RelatedItemsForPost {
    param (
        [HugoMarkdown]$hugoMarkdown,
        [int]$TopN = 5
    )

    $targetEmbeddingData = Get-BlobContentAsJson -Container $containerName -Blob "$($hugoMarkdown.FrontMatter.slug).embedding.json"
    if (-not $targetEmbeddingData) {
        throw "Embedding for target '$($hugoMarkdown.FrontMatter.slug)' not found."
    }

    $targetEmbedding = $targetEmbeddingData.embedding

    $allBlobs = Get-AzStorageBlob -Container $containerName -Context $storageContext
    $similarities = @()

    foreach ($blob in $allBlobs) {
        if ($blob.Name -eq "$($hugoMarkdown.FrontMatter.slug).embedding.json") {
            continue
        }

        $embeddingData = Get-BlobContentAsJson -Container $containerName -Blob $blob.Name
        if ($embeddingData -and $embeddingData.embedding) {
            $similarity = Get-CosineSimilarity -VectorA $targetEmbedding -VectorB $embeddingData.embedding
            $similarities += [PSCustomObject]@{
                BlobName   = $blob.Name
                Similarity = $similarity
            }
        }
    }

    return $similarities | Sort-Object Similarity -Descending | Select-Object -First $TopN
}

function Rebuild-EmbeddingRepository {
    param (
        [string]$ContainerName = $containerName,
        [string]$LocalPath = "./.data/content-embeddings/"
    )
    # 1. Download all blobs to local cache
    Write-InformationLog "Syncing embeddings from Azure Blob to $LocalPath..."
    azcopy copy "https://$($storageContext.StorageAccountName).blob.core.windows.net/$ContainerName?$($storageContext.SASToken)" "$LocalPath" --recursive=true --overwrite=true

    # 2. Regenerate changed/expired items (compare contentHash or timestamp)
    $localFiles = Get-ChildItem -Path $LocalPath -Filter *.embedding.json
    foreach ($file in $localFiles) {
        $embeddingData = Get-Content $file.FullName | ConvertFrom-Json
        $mdPath = $embeddingData.referencePath
        if (Test-Path $mdPath) {
            $contentText = Get-Content -Path $mdPath -Raw
            $contentHash = Get-ContentHash $contentText
            if ($embeddingData.contentHash -ne $contentHash) {
                Write-InformationLog "Regenerating embedding for $($embeddingData.title) due to content change."
                $newEmbedding = Get-OpenAIEmbedding -Content $contentText -Model $embeddingModel
                $embeddingData.embedding = $newEmbedding
                $embeddingData.contentHash = $contentHash
                $embeddingData.generatedAt = (Get-Date).ToUniversalTime()
                $embeddingData | ConvertTo-Json -Depth 10 | Set-Content $file.FullName
            }
        }
    }

    # 3. Sync local changes back to blob
    Write-InformationLog "Syncing updated embeddings back to Azure Blob..."
    azcopy sync "$LocalPath" "https://$($storageContext.StorageAccountName).blob.core.windows.net/$ContainerName?$($storageContext.SASToken)" --recursive=true
}

function Build-EmbeddingCache {
    param (
        [HugoMarkdown]$hugoMarkdown,
        [string]$LocalPath = "./.data/content-embeddings/",
        [int]$TopN = 50
    )
    $targetEmbeddingFile = Join-Path $LocalPath ("$($hugoMarkdown.FrontMatter.slug).embedding.json")
    if (-not (Test-Path $targetEmbeddingFile)) { return }
    $targetEmbeddingData = Get-Content $targetEmbeddingFile | ConvertFrom-Json
    $targetEmbedding = $targetEmbeddingData.embedding

    $allFiles = Get-ChildItem -Path $LocalPath -Filter *.embedding.json
    $similarities = @()
    foreach ($file in $allFiles) {
        if ($file.Name -eq "$($hugoMarkdown.FrontMatter.slug).embedding.json") { continue }
        $embeddingData = Get-Content $file.FullName | ConvertFrom-Json
        if ($embeddingData.embedding) {
            $similarity = Get-CosineSimilarity -VectorA $targetEmbedding -VectorB $embeddingData.embedding
            $similarities += [PSCustomObject]@{
                FileName   = $embeddingData.fileName
                Title      = $embeddingData.title
                Slug       = $embeddingData.slug
                Reference  = $embeddingData.referencePath
                Similarity = $similarity
            }
        }
    }
    $topRelated = $similarities | Sort-Object Similarity -Descending | Select-Object -First $TopN
    $cachePath = Join-Path (Split-Path $hugoMarkdown.FilePath) 'data.index.related.json'
    $topRelated | ConvertTo-Json -Depth 10 | Set-Content $cachePath
}

function Get-RelatedItems {
    param (
        [HugoMarkdown]$hugoMarkdown
    )
    $cachePath = Join-Path (Split-Path $hugoMarkdown.FilePath) 'data.index.related.json'
    if (Test-Path $cachePath) {
        return Get-Content $cachePath | ConvertFrom-Json
    } else {
        Write-Warning "No related items cache found for $($hugoMarkdown.FilePath)"
        return @()
    }
}

# Process embeddings
#$hugoMarkdownObjects = Get-RecentHugoMarkdownResources -Path ".\site\content\resources\" -YearsBack 10
#Write-InformationLog "Processing ({count}) HugoMarkdown Objects." -PropertyValues ($hugoMarkdownObjects.Count)

# foreach ($hugoMarkdown in $hugoMarkdownObjects) {
#     Generate-AndStoreEmbedding -hugoMarkdown $hugoMarkdown
# }

Write-DebugLog "All files checked."
Write-DebugLog "--------------------------------------------------------"

Get-RelatedItemsForPost -Slug "scrum-masters-enabling-teams-fostering-agility-removing-blockers"
 
# foreach ($hugoMarkdown in $hugoMarkdownObjects) {
#     Write-DebugLog "Processing HugoMarkdown: {Title}" -PropertyValues $hugoMarkdown.FrontMatter.title
#     $related = Get-RelatedItemsForPost -Slug $hugoMarkdown.FrontMatter.slug

# }
