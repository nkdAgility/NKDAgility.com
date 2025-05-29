. ./.powershell/_includes/LoggingHelper.ps1
. ./.powershell/_includes/HugoHelpers.ps1
. ./.powershell/_includes/AzureBlobHelpers.ps1

Import-Module Az.Storage

$containerName = "content-embeddings"
$embeddingModel = "text-embedding-3-large"

function Get-EmbeddingResourceFileName {
    param (
        [HugoMarkdown]$HugoMarkdown
    )
    return $HugoMarkdown.ReferencePath.Replace("\", "-").Replace("/", "-") + ".embedding.json"
}

# function Update-EmbeddingRepository {
#     param (
#         [array]$HugoMarkdownObjects,
#         [string]$ContainerName = $containerName,
#         [string]$LocalPath = "./.data/content-embeddings/",
#         [string]$StorageAccountName = "nkdagilityblobs",
#         [string]$SASToken = $Env:AZURE_BLOB_STORAGE_SAS_TOKEN
#     )

#     if (-not (Test-Path $LocalPath)) {
#         Write-InformationLog "Creating local path: $LocalPath"
#         New-Item -ItemType Directory -Path $LocalPath | Out-Null
#     }
#     # 1. Download all blobs to local cache
#     Write-InformationLog "Syncing embeddings from Azure Blob to $LocalPath..."
#     $parentPath = Split-Path $LocalPath -Parent
#     azcopy copy "https://$StorageAccountName.blob.core.windows.net/$ContainerName`?$SASToken" "$parentPath" --recursive=true --overwrite=true

#     # 2. Regenerate changed/expired items for each HugoMarkdown
#     $count = $HugoMarkdownObjects.Count
#     $i = 0
#     $lastPercent = -10
#     foreach ($hugoMarkdown in $HugoMarkdownObjects) {
#         $i++
#         $progress = "[{0}/{1}]" -f $i, $count
#         $percent = [math]::Round(($i / $count) * 100, 1)
#         if ($percent -ge ($lastPercent + 10) -or $percent -eq 100) {
#             Write-InformationLog "$progress $percent% complete"
#             $lastPercent = [math]::Floor($percent / 10) * 10
#         }

#         $embeddingFile = Join-Path $LocalPath (Get-EmbeddingResourceFileName -HugoMarkdown $hugoMarkdown)
#         $contentText = Get-Content -Path $hugoMarkdown.FilePath -Raw
#         $contentHash = Get-ContentHash $contentText
#         $needsUpdate = $true
#         if (Test-Path $embeddingFile) {
#             $embeddingData = Get-Content $embeddingFile | ConvertFrom-Json
#             if ($embeddingData.contentHash -eq $contentHash) {
#                 $needsUpdate = $false
#             }
#         }
#         if ($needsUpdate) {
#             Write-InformationLog "$progress Regenerating embedding for $($hugoMarkdown.ReferencePath) due to content change or missing embedding."
#             $embedding = Get-OpenAIEmbedding -Content $contentText -Model $embeddingModel
#             $embeddingData = @{
#                 title         = $hugoMarkdown.FrontMatter.title
#                 slug          = $hugoMarkdown.FrontMatter.slug
#                 resourceId    = $hugoMarkdown.FrontMatter.ResourceId
#                 resourceType  = $hugoMarkdown.FrontMatter.resourceType
#                 referencePath = $hugoMarkdown.ReferencePath
#                 generatedAt   = (Get-Date).ToUniversalTime()
#                 contentHash   = $contentHash
#                 embedding     = $embedding
#             }
            
#             $embeddingData | ConvertTo-Json -Depth 10 | Set-Content $embeddingFile
#         }
#         else {
#             Write-DebugLog "$progress Skipping embedding for $($hugoMarkdown.FrontMatter.title) (no change)."
#         }
#     }

#     # 3. Sync local changes back to blob
#     Write-InformationLog "Syncing updated embeddings back to Azure Blob..."
#     azcopy sync "$LocalPath" "https://$StorageAccountName.blob.core.windows.net/$ContainerName`?$SASToken" --recursive=true
# }

function Update-EmbeddingRepository2 {
    param (
        [array]$HugoMarkdownObjects,
        [string]$ContainerName = $containerName,
        [string]$LocalPath = "./.data/content-embeddings/",
        [string]$StorageAccountName = "nkdagilityblobs",
        [string]$SASToken = $Env:AZURE_BLOB_STORAGE_SAS_TOKEN
    )

    $count = $HugoMarkdownObjects.Count
    $i = 0
    $lastPercent = -10
    foreach ($hugoMarkdown in $HugoMarkdownObjects) {
        $i++
        $progress = "[{0}/{1}]" -f $i, $count
        $percent = [math]::Round(($i / $count) * 100, 1)
        if (-not (Get-IsDebug)) {
            Write-Progress -Activity "Updating Embedding Repository" -Status "$progress $percent% complete" -PercentComplete $percent
        }
        else {
            Write-DebugLog "Updating Embedding Repository $progress $percent% complete"
        }
        if ($percent -ge ($lastPercent + 10) -or $percent -eq 100) {
            Write-DebugLog "$progress $percent% complete"
            $lastPercent = [math]::Floor($percent / 10) * 10
        }
        $embedding = Get-EmbeddingFromHugoMarkdown -HugoMarkdown $hugoMarkdown
    }
    if (-not (Get-IsDebug)) {
        Write-Progress -Activity "Updating Embedding Repository" -Completed
    }
    else {
        Write-DebugLog "Updating Embedding Repository complete."
    }
}

function Get-EmbeddingCosineSimilarityFromHugoMarkdown {
    param (
        [HugoMarkdown]$Source,
        [HugoMarkdown]$Target
    )
    $sourceEmbedding = Get-EmbeddingFromHugoMarkdown -HugoMarkdown $Source
    $targetEmbedding = Get-EmbeddingFromHugoMarkdown -HugoMarkdown $Target
    return Get-EmbeddingCosineSimilarity -VectorA $sourceEmbedding -VectorB $targetEmbedding
}

function Get-EmbeddingCosineSimilarity {
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

function Get-EmbeddingFromHugoMarkdown {
    param (
        [HugoMarkdown]$HugoMarkdown,
        [string]$ContainerName = $containerName,
        [string]$LocalPath = "./.data/content-embeddings/",
        [string]$StorageAccountName = "nkdagilityblobs",
        [string]$SASToken = $Env:AZURE_BLOB_STORAGE_SAS_TOKEN
    )
    $embeddingFileName = Get-EmbeddingResourceFileName -HugoMarkdown $HugoMarkdown
    $localFilePath = Join-Path $LocalPath $embeddingFileName

    if (-not (Test-Path $LocalPath)) {
        New-Item -ItemType Directory -Path $LocalPath | Out-Null
    }

    # 1. Return local file if it exists
    if (Test-Path $localFilePath) {
        return Get-Content $localFilePath | ConvertFrom-Json
    }

    # 2. Try to download the file from blob storage
    $context = New-AzStorageContext -StorageAccountName $StorageAccountName -SasToken $SASToken
    $downloaded = $false
    try {
        $blob = Get-AzStorageBlob -Container $ContainerName -Blob $embeddingFileName -Context $context -ErrorAction SilentlyContinue
        if ($blob) {
            Get-AzStorageBlobContent -Container $ContainerName -Blob $embeddingFileName -Destination $localFilePath -Context $context -Force | Out-Null
            if (Test-Path $localFilePath) {
                $downloaded = $true
            }
        }
    }
    catch {
        $downloaded = $false
    }

    if ($downloaded) {
        return Get-Content $localFilePath | ConvertFrom-Json
    }

    # 3. Generate embedding and upload
    $contentText = Get-Content -Path $HugoMarkdown.FilePath -Raw
    $contentHash = Get-ContentHash $contentText
    $embedding = Get-OpenAIEmbedding -Content $contentText -Model $embeddingModel
    $embeddingData = @{
        title         = $HugoMarkdown.FrontMatter.title
        slug          = $HugoMarkdown.FrontMatter.slug
        resourceId    = $HugoMarkdown.FrontMatter.ResourceId
        resourceType  = $HugoMarkdown.FrontMatter.resourceType
        referencePath = $HugoMarkdown.ReferencePath
        generatedAt   = (Get-Date).ToUniversalTime()
        contentHash   = $contentHash
        embedding     = $embedding
    }
    $embeddingData | ConvertTo-Json -Depth 10 | Set-Content $localFilePath
    Set-AzStorageBlobContent -File $localFilePath -Container $ContainerName -Blob $embeddingFileName -Context $context -Force | Out-Null
    return $embeddingData
}

if ($RefreshEmbeddingRepository -eq $true) {
    $levelSwitch.MinimumLevel = 'Information'

    Write-DebugLog "--------------------------------------------------------"
    Write-DebugLog "--------------------------------------------------------"
    $hugoMarkdownObjects = Get-RecentHugoMarkdownResources -Path ".\site\content\resources\" -YearsBack 20
    $hugoMarkdownObjects += Get-RecentHugoMarkdownResources -Path ".\site\content\tags\" -YearsBack 10
    $hugoMarkdownObjects += Get-RecentHugoMarkdownResources -Path ".\site\content\categories\" -YearsBack 10
    $hugoMarkdownObjects += Get-RecentHugoMarkdownResources -Path ".\site\content\concepts\" -YearsBack 10
    Write-DebugLog "--------------------------------------------------------"
    Write-DebugLog "--------------------------------------------------------"
    Update-EmbeddingRepository2 -HugoMarkdownObjects $hugoMarkdownObjects
    $hugoMarkdownObjects = $null;
    Write-DebugLog "--------------------------------------------------------"
    Write-DebugLog "--------------------------------------------------------"
   
}
else {
    Write-Host "Skipping embedding repository update as RefreshEmbeddingRepository is set to false."
}

