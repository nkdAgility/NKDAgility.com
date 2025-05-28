Import-Module Az.Storage

$containerName = "content-embeddings"
$embeddingModel = "text-embedding-3-large"
function Update-EmbeddingRepository {
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
