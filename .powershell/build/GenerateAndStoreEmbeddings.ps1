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
        resourceType  = $hugoMarkdown.FrontMatter.resourceType
        ResourceId    = $hugoMarkdown.FrontMatter.ResourceId
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
        [array]$HugoMarkdownObjects,
        [string]$ContainerName = $containerName,
        [string]$LocalPath = "./.data/content-embeddings/",
        [string]$StorageAccountName = "nkdagilityblobs",
        [string]$SASToken = $Env:AZURE_BLOB_STORAGE_SAS_TOKEN
    )

    if (-not (Test-Path $LocalPath)) {
        Write-InformationLog "Creating local path: $LocalPath"
        New-Item -ItemType Directory -Path $LocalPath | Out-Null
    }
    # 1. Download all blobs to local cache
    Write-InformationLog "Syncing embeddings from Azure Blob to $LocalPath..."
    $parentPath = Split-Path $LocalPath -Parent
    azcopy copy "https://$StorageAccountName.blob.core.windows.net/$ContainerName`?$SASToken" "$parentPath" --recursive=true --overwrite=true

    # 2. Regenerate changed/expired items for each HugoMarkdown
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
        if ([string]::IsNullOrEmpty($hugoMarkdown.FrontMatter.slug)) {
            Write-WarningLog "$progress $($hugoMarkdown.ReferencePath) (no slug found)."
            continue
        }
        $embeddingFile = Join-Path $LocalPath ("$($hugoMarkdown.FrontMatter.slug).embedding.json")
        $contentText = Get-Content -Path $hugoMarkdown.FilePath -Raw
        $contentHash = Get-ContentHash $contentText
        $needsUpdate = $true
        if (Test-Path $embeddingFile) {
            $embeddingData = Get-Content $embeddingFile | ConvertFrom-Json
            if ($embeddingData.contentHash -eq $contentHash) {
                $needsUpdate = $false
            }
        }
        if ($needsUpdate) {
            Write-InformationLog "$progress Regenerating embedding for $($hugoMarkdown.ReferencePath) due to content change or missing embedding."
            $embedding = Get-OpenAIEmbedding -Content $contentText -Model $embeddingModel
            $embeddingData = @{
                title         = $hugoMarkdown.FrontMatter.title
                slug          = $hugoMarkdown.FrontMatter.slug
                resourceId    = $hugoMarkdown.FrontMatter.ResourceId
                resourceType  = $hugoMarkdown.FrontMatter.resourceType
                referencePath = $hugoMarkdown.ReferencePath
                generatedAt   = (Get-Date).ToUniversalTime()
                contentHash   = $contentHash
                embedding     = $embedding
            }
            
            $embeddingData | ConvertTo-Json -Depth 10 | Set-Content $embeddingFile
        }
        else {
            Write-DebugLog "$progress Skipping embedding for $($hugoMarkdown.FrontMatter.title) (no change)."
        }
    }

    # 3. Sync local changes back to blob
    Write-InformationLog "Syncing updated embeddings back to Azure Blob..."
    azcopy sync "$LocalPath" "https://$StorageAccountName.blob.core.windows.net/$ContainerName`?$SASToken" --recursive=true
}


function Build-AllEmbeddingCache {
    param (
        [array]$HugoMarkdownObjects,
        [string]$LocalPath = "./.data/content-embeddings/",
        [int]$TopN = 50
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
        Build-EmbeddingCache -hugoMarkdown $hugoMarkdown -LocalPath $LocalPath -TopN $TopN
    }

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
            $similarity = Get-CosineSimilarity -VectorA $targetEmbedding -VectorB $embeddingData.embedding
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
    $topRelated = $similarities | Where-Object { $_.Similarity -gt 0.7 } | Sort-Object Similarity -Descending | Select-Object -First $TopN
    $cachePath = Join-Path (Split-Path $hugoMarkdown.FilePath) 'data.index.related.json'
    $topRelated | ConvertTo-Json -Depth 10 | Set-Content $cachePath
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
$containerName = "content-embeddings"
$embeddingModel = "text-embedding-3-large"
Start-TokenServer
$storageContext = New-AzStorageContext -SasToken $Env:AZURE_BLOB_STORAGE_SAS_TOKEN -StorageAccountName "nkdagilityblobs"
Write-DebugLog "--------------------------------------------------------"
Write-DebugLog "--------------------------------------------------------"
$hugoMarkdownObjects = Get-RecentHugoMarkdownResources -Path ".\site\content\resources\" -YearsBack 10
Write-DebugLog "--------------------------------------------------------"
Write-DebugLog "--------------------------------------------------------"
Rebuild-EmbeddingRepository -HugoMarkdownObjects $hugoMarkdownObjects -ContainerName $containerName -LocalPath "./.data/content-embeddings/"
Write-DebugLog "--------------------------------------------------------"
Write-DebugLog "--------------------------------------------------------"
Build-AllEmbeddingCache -HugoMarkdownObjects $hugoMarkdownObjects -LocalPath "./.data/content-embeddings/" -TopN 50
Write-DebugLog "--------------------------------------------------------"
Write-DebugLog "--------------------------------------------------------"
# Process embeddings

#Write-InformationLog "Processing ({count}) HugoMarkdown Objects." -PropertyValues ($hugoMarkdownObjects.Count)

# foreach ($hugoMarkdown in $hugoMarkdownObjects) {
#     Generate-AndStoreEmbedding -hugoMarkdown $hugoMarkdown
# }

Write-DebugLog "All files checked."


#Get-RelatedItemsForPost -Slug "scrum-masters-enabling-teams-fostering-agility-removing-blockers"
 
# foreach ($hugoMarkdown in $hugoMarkdownObjects) {
#     Write-DebugLog "Processing HugoMarkdown: {Title}" -PropertyValues $hugoMarkdown.FrontMatter.title
#     $related = Get-RelatedItemsForPost -Slug $hugoMarkdown.FrontMatter.slug

# }
