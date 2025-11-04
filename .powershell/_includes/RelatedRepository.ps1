function Get-RelatedResourceFileName {
    param (
        [HugoMarkdown]$HugoMarkdown
    )
    return $HugoMarkdown.FrontMatter.ItemKind + "-" + $HugoMarkdown.FrontMatter.ItemType + "-" + $HugoMarkdown.FrontMatter.ItemId + ".related.json"
    #return $HugoMarkdown.ReferencePath.Replace("\", "-").Replace("/", "-") + ".related.json"
}

function Update-RelatedRepository {
    param (
        [array]$HugoMarkdownObjects,
        [string]$ContainerName = "content-related",
        [string]$LocalPath = "./.data/content-related/",
        [string]$EmbeddingPath = "./.data/content-embeddings/",
        [string]$StorageAccountName = "nkdagilityblobs",
        [string]$SASToken = $Env:AZURE_BLOB_STORAGE_SAS_TOKEN,
        [int]$TopN = 5000,
        [int]$ThrottleLimit = 1
    )
    

    if ($ThrottleLimit -lt 1) {
        foreach ($hugoMarkdown in $HugoMarkdownObjects) {
            if ($hugoMarkdown.FrontMatter.ignore) {
                continue
            }
            $result = Get-RelatedFromHugoMarkdown -HugoMarkdown $hugoMarkdown
        }
        Write-InformationLog "Completed building related content cache"
        return 
    }


    Write-InformationLog "Building related content cache for all HugoMarkdown objects using parallel processing (ThrottleLimit: $ThrottleLimit)..."
    $count = $HugoMarkdownObjects.Count
    
    
    # Import required scripts and variables for parallel execution
    $scriptPaths = @(
        "./.powershell/_includes/IncludesForAll.ps1"
    )

    $indexedItems = @()
    for ($i = 0; $i -lt $HugoMarkdownObjects.Count; $i++) {
        $indexedItems += [PSCustomObject]@{
            HugoMarkdown = $HugoMarkdownObjects[$i]
            JobId        = $i
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

        if ($hugoMarkdown.FrontMatter.ignore) {
            continue
        }
        
        try {
            $result = Get-RelatedFromHugoMarkdown -HugoMarkdown $hugoMarkdown -ContainerName $using:ContainerName -LocalPath $using:LocalPath -EmbeddingPath $using:EmbeddingPath -StorageAccountName $using:StorageAccountName -SASToken $using:SASToken -TopN $using:TopN -JobId $jobId
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
    
    Write-InformationLog "Completed building related content cache: $successCount successful, $errorCount errors out of $count total"
    
    # Log any errors
    $results | Where-Object { -not $_.Success } | ForEach-Object {
        Write-Warning "Failed to build related cache for '$($_.Title)' (JobId: $($_.JobId)): $($_.Error)"
    }
}



function Get-RelatedFromHugoMarkdown {
    param (
        [HugoMarkdown]$HugoMarkdown,
        [string]$ContainerName = "content-related",
        [string]$LocalPath = "./.data/content-related/",
        [string]$EmbeddingPath = "./.data/content-embeddings/",
        [string]$StorageAccountName = "nkdagilityblobs",
        [string]$SASToken = $Env:AZURE_BLOB_STORAGE_SAS_TOKEN,
        [bool]$checkEachRelatedEntry = $false,
        [int]$TopN = 5000,
        [int]$JobId = 1
    )
    
    if (-not $HugoMarkdown) {
        throw "HugoMarkdown object is required."
    }

    Write-DebugLog "Building related content cache for $($HugoMarkdown.ReferencePath) (JobId: $JobId)..."
    
    $relatedFileName = Get-RelatedResourceFileName -HugoMarkdown $HugoMarkdown
    $localFilePath = Join-Path $LocalPath $relatedFileName
    $context = $null
    
    # Ensure local directories exist
    if (-not (Test-Path $LocalPath)) {
        New-Item -ItemType Directory -Path $LocalPath -Force | Out-Null
    }
    if (-not (Test-Path $EmbeddingPath)) {
        throw "Embedding path does not exist: $EmbeddingPath. Please ensure the embedding files are generated first."
    }

    # 1. Check if local file already exists and is current
    if (Test-Path $localFilePath) {
        try {
            $existingData = Get-Content $localFilePath | ConvertFrom-Json
            # If we have valid data, check if we need to checkEachRelatedEntry based on embedding timestamps
            if ($existingData -and $existingData.related) {
                $embeddingFileName = Get-EmbeddingResourceFileName -HugoMarkdown $HugoMarkdown
                $targetEmbeddingFile = Join-Path $EmbeddingPath $embeddingFileName
                
                if (Test-Path $targetEmbeddingFile) {
                    $targetEmbeddingData = Get-Content $targetEmbeddingFile | ConvertFrom-Json
                    $localFileTime = (Get-Item $localFilePath).LastWriteTime
                    $embeddingTime = $targetEmbeddingData.generatedAt
                    
                    # If local file is newer than embedding, return it
                    if ($localFileTime -gt $embeddingTime) {
                        $thirtyDaysAgo = (Get-Date).AddDays(-30)
                        if ($localFileTime -gt $thirtyDaysAgo) {
                            Write-DebugLog "  | -- Using existing local related file for $($HugoMarkdown.ReferencePath)"
                            return $existingData
                        }
                        else {
                            $checkEachRelatedEntry = $true
                            Write-DebugLog "  | -- Local related file is older than 30 days, will checkEachRelatedEntry for $($HugoMarkdown.ReferencePath)"
                        }
                    }
                    else {
                        $checkEachRelatedEntry = $true
                    }
                }
            }
        }
        catch {
            Write-DebugLog "  | -- Error reading existing local file, will checkEachRelatedEntry: $_"
        }
    }

    # Initialize storage context if we have credentials
    if ($StorageAccountName -and $SASToken) {
        try {
            $context = New-AzStorageContext -StorageAccountName $StorageAccountName -SasToken $SASToken
        }
        catch {
            Write-WarningLog "Failed to create storage context: $_"
            $context = $null
        }
    }

    # 2. Try to download from blob storage if we have credentials
    if ($context) {
        try {
            $blob = Get-AzStorageBlob -Container $ContainerName -Blob $relatedFileName -Context $context -ErrorAction SilentlyContinue
            if ($blob) {
                Get-AzStorageBlobContent -Container $ContainerName -Blob $relatedFileName -Destination $localFilePath -Context $context -Force | Out-Null
                if (Test-Path $localFilePath) {
                    Write-DebugLog "  | -- Downloaded related file from blob storage for $($HugoMarkdown.ReferencePath)"
                    $downloadedData = Get-Content $localFilePath | ConvertFrom-Json
                    if (-not $checkEachRelatedEntry) {
                        return $downloadedData
                    }
                }
            }
        }
        catch {
            Write-DebugLog "  | -- Failed to download from blob storage: $_"
        }
    }

    # 4. Generate new related content cache
    Write-DebugLog "  | -- Generating new related content for $($HugoMarkdown.ReferencePath)"
    
    # Get the target embedding
    $embeddingFileName = Get-EmbeddingResourceFileName -HugoMarkdown $HugoMarkdown
    $targetEmbeddingFile = Join-Path $EmbeddingPath $embeddingFileName
    if (-not (Test-Path $targetEmbeddingFile)) {
        Write-Warning "Embedding file not found for $($HugoMarkdown.ReferencePath): $targetEmbeddingFile"
        return @{ related = @() }
    }
    
    $targetEmbeddingData = Get-Content $targetEmbeddingFile | ConvertFrom-Json
    $targetEmbedding = $targetEmbeddingData.embedding

    # Load existing cache if it exists to preserve calculations
    $existingCache = $null
    $existingRelatedLookup = @{}
    if (Test-Path $localFilePath) {
        try {
            $existingCache = Get-Content $localFilePath | ConvertFrom-Json
            # Create a lookup table for existing related items by their EntryId or Reference
            foreach ($item in $existingCache.related) {
                $key = if ($item.EntryId) { $item.EntryId } else { $item.Reference }
                if ($key) {
                    $existingRelatedLookup[$key] = $item
                }
            }
            Write-DebugLog "  | -- Found existing cache for $($HugoMarkdown.ReferencePath) with $($existingCache.related.Count) items"
        }
        catch {
            Write-DebugLog "  | -- Error reading existing cache: $_"
        }
    }

    # Process all embedding files
    $allFiles = Get-ChildItem -Path $EmbeddingPath -Filter *.embedding.json
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
       
        if ($percent -ge ($lastPercent + 10) -or $percent -eq 100) {
            if (Get-IsDebug) {
                Write-InformationLog "  | -- $progress $percent % complete (Building related cache for $($HugoMarkdown.ReferencePath))"
            }
            else {
                Write-Progress -Activity "Building related cache for $($HugoMarkdown.ReferencePath)" -Status "$progress $percent% complete" -PercentComplete $percent -Id $JobId
            }
            $lastPercent = [math]::Floor($percent / 10) * 10
        }       
        
        # Skip self
        if ($file.Name -eq $embeddingFileName) { continue }
        
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
                        Write-DebugLog "  | -- Preserving existing similarity for $($embeddingData.title) (embedding not newer)"
                    }
                }
                catch {
                    Write-ErrorLog "  | -- Error comparing generatedAt timestamps for $($embeddingData.title): $_"
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
                Write-DebugLog "  | -- Recalculated similarity for $($embeddingData.title)"
            }
        }
    }   
    
    $topRelated = $similarities | Sort-Object Similarity -Descending | Select-Object -First $TopN
    $output = @{
        related = $topRelated
    }
    
    # Save locally
    $output | ConvertTo-Json -Depth 10 | Set-Content $localFilePath
    Write-DebugLog "  | -- Saved to $localFilePath (Recalculated: $recalculatedCount, Preserved: $preservedCount)"

    # Upload to blob storage if possible
    if ($context) {
        try {
            Set-AzStorageBlobContent -File $localFilePath -Container $ContainerName -Blob $relatedFileName -Context $context -Force | Out-Null
            Write-DebugLog "  | -- Uploaded to blob storage: $relatedFileName"
        }
        catch {
            Write-DebugLog "  | -- Failed to upload to blob storage: $_"
        }
    }

    # Clear progress bar when not in debug mode
    if (-not (Get-IsDebug)) {
        Write-Progress -Activity "Building related cache for $($HugoMarkdown.ReferencePath)" -Completed -Id $JobId
    }
    
    return $output
}

function Get-RelatedItems {
    param (
        [HugoMarkdown]$HugoMarkdown,
        [string]$LocalPath = "./.data/content-related/",
        [string]$ContainerName = "content-related",
        [string]$StorageAccountName = "nkdagilityblobs",
        [string]$SASToken = $Env:AZURE_BLOB_STORAGE_SAS_TOKEN
    )
    
    $relatedFileName = Get-RelatedResourceFileName -HugoMarkdown $HugoMarkdown
    $localFilePath = Join-Path $LocalPath $relatedFileName
    
    # 1. Check local cache first
    if (Test-Path $localFilePath) {
        try {
            return Get-Content $localFilePath | ConvertFrom-Json
        }
        catch {
            Write-DebugLog "Error reading local related cache: $_"
        }
    }
    
    # 3. Try to download from blob storage
    if ($StorageAccountName -and $SASToken) {
        try {
            $context = New-AzStorageContext -StorageAccountName $StorageAccountName -SasToken $SASToken
            $blob = Get-AzStorageBlob -Container $ContainerName -Blob $relatedFileName -Context $context -ErrorAction SilentlyContinue
            if ($blob) {
                # Ensure local directory exists
                if (-not (Test-Path $LocalPath)) {
                    New-Item -ItemType Directory -Path $LocalPath -Force | Out-Null
                }
                Get-AzStorageBlobContent -Container $ContainerName -Blob $relatedFileName -Destination $localFilePath -Context $context -Force | Out-Null
                if (Test-Path $localFilePath) {
                    return Get-Content $localFilePath | ConvertFrom-Json
                }
            }
        }
        catch {
            Write-DebugLog "Failed to download related items from blob storage: $_"
        }
    }
    
    Write-Warning "No related items cache found for $($HugoMarkdown.ReferencePath)"
    return @{ related = @() }
}