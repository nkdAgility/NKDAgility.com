
function Get-EmbeddingResourceFileName {
    param (
        [HugoMarkdown]$HugoMarkdown
    )
    return $HugoMarkdown.ReferencePath.Replace("\", "-").Replace("/", "-") + ".embedding.json"
}
function Update-EmbeddingRepository {
    param (
        [array]$HugoMarkdownObjects,
        [string]$ContainerName = "content-embeddings",
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
    if (-not $sourceEmbedding) {
        Write-WarningLog "Source embedding not found for $($Source.ReferencePath)"
        return 0
    }
    $targetEmbedding = Get-EmbeddingFromHugoMarkdown -HugoMarkdown $Target
    if (-not $targetEmbedding) {
        Write-WarningLog "Target embedding not found for $($Target.ReferencePath)"
        return 0
    }
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
        [string]$ContainerName = "content-embeddings",
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

    $contentText = $HugoMarkdown.BodyContent
    # 3. Generate embedding and upload
    If (-not $contentText) {
        $contentText = Get-Content -Raw $HugoMarkdown.FilePath
    }
    
    $contentHash = Get-ContentHash $contentText
    $tokens = Get-TokenCountFromServer -Content $contentText
    if ($tokens -gt 8192) {
        Write-WarningLog "Content exceeds token limit: $($HugoMarkdown.ReferencePath) - $tokens tokens"
        return $null
    }
    $embedding = Get-OpenAIEmbedding -Content $contentText -Model "text-embedding-3-large"
    if (-not $embedding) {
        Write-WarningLog "Failed to generate embedding for $($HugoMarkdown.ReferencePath)"
        return $null
    }
    $entryType = "unknown"
    $entryKind = "unknown"
    $entryId = "unknown"
    If ($HugoMarkdown.FrontMatter.resourceType) {
        $entryKind = "resource"
        $entryType = $HugoMarkdown.FrontMatter.resourceType
        $entryId = $HugoMarkdown.FrontMatter.ItemId
    }
    If ($HugoMarkdown.FrontMatter.ClassificationType) {
        $entryKind = "classification"
        $entryType = $HugoMarkdown.FrontMatter.ClassificationType
        $entryId = Get-HugoMarkdownSlug -hugoMarkdown $HugoMarkdown
    }
    If ($HugoMarkdown.FrontMatter.type -eq "course" -OR $HugoMarkdown.FrontMatter.type -eq "mentor-program") {
        $entryKind = "program"
        $entryType = $HugoMarkdown.FrontMatter.type
        $entryId = Get-HugoMarkdownSlug -hugoMarkdown $HugoMarkdown
    }

    if ($entryType -eq "unknown") {
        Write-WarningLog "Unknown entry type for $($HugoMarkdown.ReferencePath)"
    }

    $embeddingData = @{
        title         = $HugoMarkdown.FrontMatter.title
        slug          = Get-HugoMarkdownSlug -hugoMarkdown $HugoMarkdown
        entryKind     = $entryKind
        entryId       = $entryId
        entryType     = $entryType
        referencePath = $HugoMarkdown.ReferencePath
        generatedAt   = (Get-Date).ToUniversalTime()
        contentHash   = $contentHash
        embedding     = $embedding
    }
    $embeddingData | ConvertTo-Json -Depth 10 | Set-Content $localFilePath
    Set-AzStorageBlobContent -File $localFilePath -Container $ContainerName -Blob $embeddingFileName -Context $context -Force | Out-Null
    return $embeddingData
}

Write-DebugLog "ResourceHelpers.ps1 run 'Update-EmbeddingRepository2 -HugoMarkdownObjects `$hugoMarkdownObjects' to rebuild repository."

if ($RefreshEmbeddingRepository -eq $true) {
    $levelSwitch.MinimumLevel = 'Information'
    Start-TokenServer
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
    Write-InformationLog "Embedding repository update completed."
   
}

 