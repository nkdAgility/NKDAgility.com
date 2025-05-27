# Helpers (existing wrappers)
. ./.powershell/_includes/LoggingHelper.ps1
. ./.powershell/_includes/TokenServer.ps1
. ./.powershell/_includes/OpenAI.ps1
. ./.powershell/_includes/HugoHelpers.ps1
. ./.powershell/_includes/ResourceHelpers.ps1
. ./.powershell/_includes/ClassificationHelpers.ps1

Import-Module Az.Storage

$ErrorActionPreference = 'Stop'
$levelSwitch.MinimumLevel = 'Information'

# Parameters
$containerName = "content-embeddings"
$embeddingModel = "text-embedding-3-large"
$storageContext = New-AzStorageContext -SasToken $Env:AZURE_BLOB_STORAGE_SAS_TOKEN -StorageAccountName "nkdagilityblobs"

Start-TokenServer

# Azure Blob Storage Helpers
function Get-BlobContentAsJson {
    param (
        [string]$Container,
        [string]$Blob
    )
    try {
        $tempPath = Join-Path $env:TEMP ([System.IO.Path]::GetRandomFileName())
        Get-AzStorageBlobContent -Container $Container -Blob $Blob -Destination $tempPath -Context $storageContext -Force -ErrorAction Stop | Out-Null
        if (Test-Path $tempPath) {
            $content = Get-Content -Raw -Path $tempPath | ConvertFrom-Json
            Remove-Item $tempPath
            return $content
        }
    }
    catch {
        return $null
    }
    return $null
}

function Set-BlobContentAsJson {
    param (
        [string]$Container,
        [string]$Blob,
        [object]$Content
    )
    $tempPath = Join-Path $env:TEMP ([System.IO.Path]::GetRandomFileName())
    $Content | ConvertTo-Json -Depth 10 | Set-Content -Path $tempPath -Force
    Set-AzStorageBlobContent -Container $Container -Blob $Blob -File $tempPath -Context $storageContext -Force | Out-Null
    Remove-Item $tempPath
}

function Get-ContentHash {
    param (
        [Parameter(Mandatory)]
        [string]$Content
    )

    $sha256 = [System.Security.Cryptography.SHA256]::Create()
    $contentBytes = [System.Text.Encoding]::UTF8.GetBytes($Content)
    $hashBytes = $sha256.ComputeHash($contentBytes)
    return ([System.BitConverter]::ToString($hashBytes)).Replace("-", "").ToLower()
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
        fileName    = $hugoMarkdown.FilePath
        postTitle   = $hugoMarkdown.FrontMatter.title
        postSlug    = $hugoMarkdown.FrontMatter.slug
        generatedAt = (Get-Date).ToUniversalTime()
        contentHash = $contentHash
        embedding   = $embedding
    }

    Set-BlobContentAsJson -Container $containerName -Blob $embeddingBlobName -Content $embeddingData

    Write-InformationLog "Embedding updated successfully for '{Title}'." -PropertyValues $hugoMarkdown.FrontMatter.title
}

function Get-RelatedItemsForPost {
    param (
        [string]$Slug,
        [int]$TopN = 5
    )

    $targetEmbeddingData = Get-BlobContentAsJson -Container $containerName -Blob "$Slug.embedding.json"
    if (-not $targetEmbeddingData) {
        throw "Embedding for target '$Slug' not found."
    }

    $targetEmbedding = $targetEmbeddingData.embedding

    $allBlobs = Get-AzStorageBlob -Container $containerName -Context $storageContext
    $similarities = @()

    foreach ($blob in $allBlobs) {
        if ($blob.Name -eq "$Slug.embedding.json") {
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

# Process embeddings
$hugoMarkdownObjects = Get-RecentHugoMarkdownResources -Path ".\site\content\resources\blog\2025" -YearsBack 10
Write-InformationLog "Processing ({count}) HugoMarkdown Objects." -PropertyValues ($hugoMarkdownObjects.Count)

foreach ($hugoMarkdown in $hugoMarkdownObjects) {
    Generate-AndStoreEmbedding -hugoMarkdown $hugoMarkdown
}

Write-DebugLog "All markdown files processed."
Write-DebugLog "--------------------------------------------------------"
