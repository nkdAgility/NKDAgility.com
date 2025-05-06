. ./.powershell/_includes/LoggingHelper.ps1
. ./.powershell/_includes/TokenServer.ps1
. ./.powershell/_includes/OpenAI.ps1
. ./.powershell/_includes/PromptManager.ps1
. ./.powershell/_includes/HugoHelpers.ps1

$batchesInProgress = $null;
$batchesInProgressMax = 40;
$watermarkAgeLimit = (New-TimeSpan -Start (Get-Date "2025-02-18T09:00:00") -End (Get-Date)).Days # Wattermark for calculation algorythem Change.
$watermarkScoreLimit = 10
$watermarkCount = 0

function Get-CatalogHashtable {
    param (
        [string]$FolderPath = "site\content",
        [string]$Classification
    )

    # Get the metadata (assumed to be an array of objects)
    $catalog = Get-HugoMarkdownList -FolderPath "$FolderPath\$Classification"

    # Initialize an empty hashtable
    $catalogHash = @{}

    # Loop through each object and store the Title-Description pair in the hashtable
    foreach ($markdownMeta in $catalog) {
        if ($markdownMeta.FrontMatter -eq $null) {
            Write-WarningLog "FrontMatter is null for $($markdownMeta.FilePath). Skipping."
            continue
        }
        $catalogHash[$markdownMeta.FrontMatter.Title] = $markdownMeta.FrontMatter
    }

    return $catalogHash
}


$catalogues = @{}
$catalogues["catalog"] = @{}
$catalogues["catalog"]["categories"] = Get-CatalogHashtable -Classification "categories"
$catalogues["catalog"]["tags"] = Get-CatalogHashtable -Classification "tags"
$catalogues["catalog"]["concepts"] = Get-CatalogHashtable -Classification "concepts"
$catalogues["catalog_full"] = $catalogues["catalog"]["categories"] + $catalogues["catalog"]["tags"] + $catalogues["catalog"]["concepts"]
$catalogues["marketing"] = Get-CatalogHashtable -Classification "marketing"

function Update-ClassificationsForHugoMarkdownList {
    param (
        [Parameter(Mandatory = $true)]
        [Array]$hugoMarkdownList
    )
    $catalog = $catalogues["catalog_full"]
    $CacheFolder = "./.data/"
    $batchFile = Join-Path $CacheFolder "classifications.json"
    $batchStatus = $null
    if ((Test-Path $batchFile) -and (Get-Content -Path $batchFile -Raw).Trim()) {
        $batches = Get-Content -Raw -Path $batchFile | ConvertFrom-Json

        if ($batches -isnot [System.Collections.IEnumerable]) {
            $batches = @($batches)
        }
        $count = 1
        $countOfResults = 0
        $countOfResultsThatAreBad = 0
        foreach ($batch in $batches) {
            $countOfBatchResults = 0
            $countOfBatchResultsThatAreBad = 0
            $batchId = $batch.BatchId
            $batchJsonlOutout = Join-Path $CacheFolder "$batchId-output.jsonl"
            $batchStatus = Get-OpenAIBatchStatus -BatchId $batchId
            switch ($batchStatus) {
                { $_ -in @("completed", "expired") } {
                    Write-InformationLog "Batch $count [$batchId] {$_}. Processing Results."
                    $HugoLookup = Get-HugoMarkdownListAsHashTable -hugoMarkdownList $hugoMarkdownList
                    # Process batch results into cache format
                    $batchResults = Get-OpenAIBatchResults -BatchId $batchId -OutputFile $batchJsonlOutout
                    Write-InformationLog "|- returned {count} results to process" -PropertyValues $batchResults.count
                    $total = $batchResults.Count
                    $currentIndex = 0
                    $lastReportedPercent = 0
                    foreach ($result in $batchResults) {
                        $countOfBatchResults++
                        $countOfResults++
                        $currentIndex++
                        $rawAiBatchResult = $result | ConvertFrom-Json
                        try {
                            if ($rawAiBatchResult.response.body.choices[0].message.content -match '(?s)```json\s*(.*?)\s*```') {
                                $jsonContent = $matches[1] # Extracted JSON content 
                                $aiResponseJson = $jsonContent
                            }
                            else {
                                $aiResponseJson = $rawAiBatchResult.response.body.choices[0].message.content 
                            }
                        }
                        catch {
                            Write-ErrorLog "Error parsing AI response for $CacheFolder. Skipping."
                            continue
                        }
                        $newEntry = $null
                        $newEntry = Get-ConfidenceFromAIResponse -AIResponseJson $aiResponseJson
                        if ($newEntry -eq $null) {
                            $countOfBatchResultsThatAreBad++
                            $countOfResultsThatAreBad++
                            Write-WarningLog "|- AI response is null for resourceId $($rawAiBatchResult.resourceId). Skipping."
                            $newEntry = $null
                            continue
                        }
                        if ($newEntry.resourceId -eq $null) {
                            $countOfBatchResultsThatAreBad++
                            $countOfResultsThatAreBad++
                            Write-WarningLog "|- resourceId mismatch for $($rawAiBatchResult.resourceId). Skipping."
                            $newEntry = $null
                            continue
                        }
                        if ($HugoLookup.ContainsKey($newEntry.resourceId)) {
                            $hugoMarkdown = $HugoLookup[$newEntry.resourceId]
                        }                        
                        if ($hugoMarkdown -eq $null) {
                            $countOfResultsThatAreBad++
                            $countOfBatchResultsThatAreBad++
                            Write-WarningLog "|- HugoMarkdown not found for resourceId $($newEntry.resourceId). Skipping."
                            continue
                        }
                        # Get items from the cache
                        $cachedData = Get-ClassificationsFromCache -hugoMarkdown $hugoMarkdown
                        if ($cachedData.ContainsKey($newEntry.category)) {
                            $oldEntry = $cachedData.($newEntry.category)
                            if ([System.DateTimeOffset]$oldEntry.calculated_at -gt $newEntry.calculated_at) {
                                $cachedData[$newEntry.category] = $newEntry
                            }
                        }
                        else {
                            $cachedData.Add($newEntry.category, $newEntry )
                        }
                        Set-ClassificationsFromCache -hugoMarkdown $hugoMarkdown -cachedData $cachedData
                        Write-DebugLog "|- Updated {category} for {resourceId} with {confidence}" -PropertyValues $newEntry.category, $newEntry.resourceId, $newEntry.ai_confidence
                        $percentComplete = [math]::Floor(($currentIndex / $total) * 100)
                        if ($percentComplete -ge $lastReportedPercent + 10) {
                            Write-InformationLog "|- ⏳ Batch Progress: {percentComplete}% complete with {countOfBatchResults} results, {countOfBatchResultsThatAreBad} of which were bad" -PropertyValues $percentComplete, $countOfBatchResults, $countOfBatchResultsThatAreBad
                            $lastReportedPercent = $percentComplete - ($percentComplete % 10)
                        }
                    }
                    Write-InformationLog "Outcome: Complete with {countOfBatchResults} results, {countOfBatchResultsThatAreBad} of which were bad" -PropertyValues $countOfBatchResults, $countOfResultsThatAreBad
                    # Cleanup batch file after processing
                    # Filter out the batch with the matching ID
                    $batchesFromFile = Get-Content $BatchFile | ConvertFrom-Json
                    $batchesForFile = $batchesFromFile | Where-Object { $_.batchId -ne $batchId }
                    if ($batchesForFile.Count -eq 0) {
                        Remove-Item $BatchFile -Force
                    }
                    else {
                        # Save the updated list back to the file
                        $batchesForFile | ConvertTo-Json -Depth 10 | Set-Content -Path $batchFile -Force
                    }                
                    
                    ## Clean up
                    $inputFile = Join-Path $CacheFolder $batch.inputFile
                    if (Test-Path $inputFile) {
                        Remove-Item $inputFile -Force
                    }
                    if (Test-Path $batchJsonlOutout) {
                        Remove-Item $batchJsonlOutout -Force
                    }
                    $batchStatus = $null
                }
                "in_progress" {
                    Write-WarningLog "Batch $count [$batchId] still in progress. Please wait for completion."
                }
                "failed" {
                    Write-ErrorLog "Batch failed for $batchId. Please try again."
                    $batchesFromFile = Get-Content $BatchFile | ConvertFrom-Json
                    $batchesForFile = $batchesFromFile | Where-Object { $_.batchId -ne $batchId }
                    if ($batchesForFile.Count -eq 0) {
                        Remove-Item $BatchFile -Force
                    }
                    else {
                        # Save the updated list back to the file
                        $batchesForFile | ConvertTo-Json -Depth 10 | Set-Content -Path $batchFile -Force
                    }                
                    $inputFile = Join-Path $CacheFolder $batch.inputFile
                    if (Test-Path $inputFile) {
                        Remove-Item $inputFile -Force
                    }
                    if (Test-Path $batchJsonlOutout) {
                        Remove-Item $batchJsonlOutout -Force
                    }
                    $batchStatus = $null
                    exit
                }
                default {
                    Write-WarningLog $batchStatus
                }
            }
            $count++
        }
    }
    else {
        $batches = @()
    }

    if ($batches.Count -gt 0) {
        return
    }

    $prompts = @();
    $total = $hugoMarkdownList.Count
    $counter = 0
    $nextPercent = 5
    foreach ($hugoMarkdown in $hugoMarkdownList) {
        $newPrompts = Get-PromptsForHugoMarkdown -hugoMarkdown $hugoMarkdown -catalog $catalog
        Write-DebugLog "For {ResourceId} we need to update {count}" -PropertyValues $hugoMarkdown.FrontMatter.ResourceId, $CatalogItemsToRefreshOrGet.Count
        if ($newPrompts.Count -gt 0) {
            $prompts += $newPrompts
        }       
        $counter++
        $percent = [math]::Floor(($counter / $total) * 100)
        if ($percent -ge $nextPercent) {
            Write-InfoLog "{count} prompts Built for {done} of {total} markdown files ({percent}%)" -PropertyValues $prompts.count, $counter, $total, $percent
            $nextPercent += 5
        }
    }

    ######
    Write-InfoLog "We have {count} prompts to batch" -PropertyValues $prompts.Count

    $maxItemsPerBatch = 50000
    $maxBatchFileSizeMB = 200
    $maxBatchFileSizeBytes = $maxBatchFileSizeMB * 1MB
    $maxDailyTokens = 40000000
    
    $totalTokens = ($prompts | Measure-Object -Property TokenEstimate -Sum).Sum
    Write-WarningLog "Total tokens: $totalTokens"
    
    if ($totalTokens -gt $maxDailyTokens) {
        Write-WarningLog "Total token estimate exceeds daily limit of $maxDailyTokens. Exiting."
        return
    }
    
    $batchesInProgress = 0
    $currentIndex = 0
    $batches = @()
    
    while ($currentIndex -lt $prompts.Count) {
        $currentBatch = @()
        $currentTokenSum = 0
        $currentSizeBytes = 0
    
        while ($currentIndex -lt $prompts.Count -and 
            $currentBatch.Count -lt $maxItemsPerBatch -and
            $currentSizeBytes -lt $maxBatchFileSizeBytes) {
    
            $prompt = $prompts[$currentIndex]
            $promptString = $prompt.Prompt
            $promptSizeBytes = [Text.Encoding]::UTF8.GetByteCount($promptString)
            
            if (($currentSizeBytes + $promptSizeBytes) -gt $maxBatchFileSizeBytes) {
                break  # adding this prompt would exceed the batch size, so stop
            }
    
            $currentBatch += $promptString
            $currentTokenSum += $prompt.TokenEstimate
            $currentSizeBytes += $promptSizeBytes
    
            $currentIndex++
        }
    
        $batchJsonlInput = Join-Path $CacheFolder "batch-$currentIndex.jsonl"
        $result = Submit-OpenAIBatch -Prompts $currentBatch -OutputFile $batchJsonlInput
    
        if ($result.batchId) {
            $batchesInProgress++
    
            $newBatch = [PSCustomObject]@{
                batchId       = $result.batchId
                status        = "submitted"
                submittedAt   = (Get-Date).ToString("o")
                promptCount   = $currentBatch.Count
                inputFile     = $batchJsonlInput
                tokenEstimate = $currentTokenSum
                errors        = $null
            }
    
            $batches += $newBatch
            $batches | ConvertTo-Json -Depth 10 | Set-Content -Path $batchFile -Force
            Write-InformationLog "Batch submitted: $($result.batchId) with $($currentBatch.Count) prompts."
            
            if ($result.BatchesInProgress -ge $result.BatchesInProgressMax) {
                Write-WarningLog "Reached maximum batches in progress ($batchesInProgressMax). Stopping submission."
                break
            }
        }
        else {
            Write-WarningLog "Batch not submitted. Too many tokens in progress. Try again later."
        }
    }
    

}

class PromptForHugoMarkdown {
    [string]$Prompt
    [int]$TokenEstimate

    PromptForHugoMarkdown([string]$prompt, [int]$tokenEstimate) {
        $this.Prompt = $Prompt
        $this.TokenEstimate = $TokenEstimate
    }
}

function Get-PromptsForHugoMarkdown {
    param (
        [Parameter(Mandatory = $true)]
        [HugoMarkdown]$hugoMarkdown,
        [Parameter(Mandatory = $true)]
        [hashtable]$catalog
    )
    $cachedData = Get-ClassificationsFromCache -hugoMarkdown $hugoMarkdown

    $CatalogFromCache = @{}
    $cachedData.Keys | Where-Object { $catalog.ContainsKey($_) } |
    ForEach-Object { $CatalogFromCache[$_] = $cachedData[$_] }

    $CatalogItemsToRefreshOrGet = Get-CatalogItemsToRefreshOrGet -cachedData $cachedData -Catalog $catalog -CatalogFromCache $CatalogFromCache
    $prompts = @()
    foreach ($category in $CatalogItemsToRefreshOrGet) {
        $promptText = Get-Prompt -PromptName "classification-analysis.md" -Parameters @{
            resourceId   = $hugoMarkdown.FrontMatter.ResourceId
            category     = $category
            Instructions = $Catalog[$category].Instructions
            title        = $hugoMarkdown.FrontMatter.Title
            abstract     = $hugoMarkdown.FrontMatter.Description
            content      = $hugoMarkdown.BodyContent
        }

        $tokenEstimate = Get-TokenCountFromServer -Content $promptText

        $promptObject = [PromptForHugoMarkdown]::new($promptText, [int]$tokenEstimate)


        $prompts += $promptObject
    }
    return $prompts;
}

function Get-ClassificationsForType {
    param (
        [Parameter(Mandatory = $true)]
        [HugoMarkdown]$hugoMarkdown,
        [string]$ClassificationType = "classification",
        [switch]$batch,
        [switch]$updateMissing
    )

    $CacheFolder = $hugoMarkdown.FolderPath
    # Populate Catalogues
    Write-DebugLog "   Populating Catalogues"
    $catalog = @{}    
    switch ($ClassificationType) {
        { $_ -in "categories", "tags", "concepts" } {
            $catalog = $catalogues["catalog"][$ClassificationType]
            $catalog_full = $catalogues["catalog_full"]
            $cacheFile = Join-Path $CacheFolder "data.index.classifications.json"
        }
        { $_ -in "catalog_full", "classification" } {
            $catalog = $catalogues["catalog_full"]
            $catalog_full = $catalogues["catalog_full"]
            $cacheFile = Join-Path $CacheFolder "data.index.classifications.json"
        }
        "marketing" {
            $catalog = $catalogues["marketing"]
            $catalog_full = $catalog
            $cacheFile = Join-Path $CacheFolder "data.index.classifications.marketing.json"
        }
        default {
            Write-ErrorLog "Invalid classification type. Please use 'categories', 'tags', or 'marketing'."
            return @()
        }
    }

    if ([datetime]$hugoMarkdown.FrontMatter.date -gt [datetime](Get-Date)) {
        Update-MissingClassificationsLive -hugoMarkdown $hugoMarkdown -catalog $catalog

    }
    # Load from Cache and validate its contents
    $cachedData = Get-ClassificationsFromCache -hugoMarkdown $hugoMarkdown
    #Find items from the catalogue that we have.
    $CatalogFromCache = @{}; $cachedData.Keys | Where-Object { $catalog.ContainsKey($_) } | ForEach-Object { $CatalogFromCache[$_] = $cachedData[$_] }

 
    # Return the items
    return $CatalogFromCache.Keys | ForEach-Object { $CatalogFromCache[$_] } | Sort-Object final_score -Descending
}

function Update-MissingClassificationsLive {
    param (
        [Parameter(Mandatory = $true)]
        [HugoMarkdown]$hugoMarkdown,
        [Parameter(Mandatory = $true)]
        [hashtable]$catalog
    )
    $prompts = Get-PromptsForHugoMarkdown -hugoMarkdown $hugoMarkdown -catalog $catalog
    $cachedData = Get-ClassificationsFromCache -hugoMarkdown $hugoMarkdown
    Write-InformationLog "Updating {count} missing classifications for {resourceId}" -PropertyValues $prompts.count, $hugoMarkdown.FrontMatter.ResourceId
    $count = 0;
    foreach ($prompt in $prompts) {
        $count++
        # Calls processing
        $aiResponseJson = Get-OpenAIResponse -Prompt $prompt.Prompt
        $result = Get-ConfidenceFromAIResponse -AIResponseJson $aiResponseJson -hugoMarkdown $hugoMarkdown
        if ($result.reasoning -ne $null -and $result.category -ne "unknown") {
            $oldConfidence = $cachedData[$result.category]?.ai_confidence ?? 0
            $confidenceDiff = "{0}{1}" -f ($(if (($result.ai_confidence - $oldConfidence) -ge 0) { '+' } else { '-' }), [math]::Abs($result.ai_confidence - $oldConfidence))
            if ($cachedData[$result.category] -and $cachedData[$result.category].calculated_at) {
                $DaysAgo = [math]::Round(([DateTimeOffset]::Now - [DateTimeOffset]$cachedData[$result.category].calculated_at).TotalDays)
            }
            else {
                $DaysAgo = -1  # Or a default value like 0, depending on your needs
            }
            $percentage = [math]::Round( ($count / [double]$prompts.Count) * 100 )
            Write-InformationLog "Updating [$count/$($prompts.Count)|$percentage%] {category} confidence {diff}! The old confidence of {old} was calculated {daysago} days ago. The new confidence is {confidence}!" -PropertyValues $result.category, $confidenceDiff, $oldConfidence, $DaysAgo, $result.ai_confidence
            $cachedData[$result.category] = $result
            # Save cache after each API call
            Set-ClassificationsFromCache -hugoMarkdown $hugoMarkdown -cachedData $cachedData
        }
        else {
            Write-ErrorLog "Error processing AI response for $($result.category). Reasoning is Null!"
            exit
        }               
    }
}

function Get-Classification {
    param (
        [string]$CacheFolder,
        [string]$ClassificationName
    )
    $cacheFile = Join-Path $CacheFolder "data.index.classifications.json"
    if (Test-Path $cacheFile) {
        # Load from cache
        try {
            $cachedData = Get-Content $cacheFile | ConvertFrom-Json -ErrorAction Stop
        }
        catch {
            Write-WarningLog "Warning: Cache file corrupted. Resetting cache."
            $cachedData = @{}
        }
    }
    Return $cachedData.$ClassificationName
}

function Get-ClassificationOrderedList { 
    param (
        [array]$Classifications,
        [int] $minScore = 40,
        [string[]]$levels = @("Primary", "Secondary", "Tertiary"),
        [switch]$byLevel
    )

    $filtered = $Classifications | Where-Object { $_.final_score -ge $minScore }
    $selected = @()
    if ($byLevel) {
        foreach ($level in $levels) {
            $currentSelection = $filtered | Where-Object { $_.level -eq $level } | Sort-Object final_score -Descending
            if ($currentSelection.Count -gt 0) {
                $selected += $currentSelection
                break
            }
        }    
    }
    else {
        $selected = $filtered | Sort-Object final_score -Descending
    }
    return $selected | Sort-Object -Property @{Expression = "final_score"; Descending = $true }, @{Expression = "ai_alignment"; Descending = $true }, @{Expression = "ai_depth"; Descending = $true }, @{Expression = "category"; Descending = $false }
}

function Get-ComputedConfidence {
    param (
        [int]$aiConfidence,
        [int]$nonAiConfidence
    )
    return [math]::Round($aiConfidence ) # [math]::Round(($aiConfidence * 0.9) + ($nonAiConfidence * 0.1))
}

function Get-ComputedLevel {
    param ([int]$confidence)

    switch ($confidence) {
        { $_ -gt 80 } { return "Primary" }
        { $_ -gt 60 } { return "Secondary" }
        { $_ -gt 40 } { return "Tertiary" }
        default { return "Ignored" }
    }
}


function Get-ConfidenceFromAIResponse {
    param (
        [string]$AIResponseJson
    )
    $responceOK = $true
    try {
        if ($AIResponseJson -match '(?s)```json\s*(.*?)\s*```') {
            $AIResponseJson = $matches[1] # Extracted JSON content 
        
        }
        $AIResponse = $AIResponseJson | ConvertFrom-Json -ErrorAction Stop
    }
    catch {

        Write-ErrorLog "Error parsing AI response.. Skipping. Error: $_"
        Write-ErrorLog "AI Response Json: {AIResponseJson}" -PropertyValues $AIResponseJson
        $AIResponse = $null
        $responceOK = $false
    }
   
    if ($responceOK) {
        $aiConfidence = if ($AIResponse.PSObject.Properties["confidence"]) { $AIResponse.confidence } else { 0 }
        if ($aiConfidence -le 1 -and $aiConfidence -gt 0) {
            $aiConfidence = [math]::Round($aiConfidence * 10)
        }
        $aiMentions = if ($AIResponse.PSObject.Properties["mentions"]) { $AIResponse.mentions } else { 0 }
        $aiAlignment = if ($AIResponse.PSObject.Properties["alignment"]) { $AIResponse.alignment } else { 0 }
        $aiDepth = if ($AIResponse.PSObject.Properties["depth"]) { $AIResponse.depth } else { 0 }
        $aiIntent = if ($AIResponse.PSObject.Properties["intent"]) { $AIResponse.intent } else { 0 }
        $aiaudience = if ($AIResponse.PSObject.Properties["audience"]) { $AIResponse.audience } else { 0 }
        $aisignal = if ($AIResponse.PSObject.Properties["signal"]) { $AIResponse.signal } else { 0 }
        $aipenalties_applied = if ($AIResponse.PSObject.Properties["penalties_applied"]) { $AIResponse.penalties_applied } else { $false }
        $aitotal_penalty_points = if ($AIResponse.PSObject.Properties["total_penalty_points"]) { $AIResponse.total_penalty_points } else { 0 }
        $aipenalty_details = if ($AIResponse.PSObject.Properties["penalty_details"]) { $AIResponse.penalty_details } else { $null }
        # Detect if confidence is a float in the 0-1 range
       
        $category = if ($AIResponse.PSObject.Properties["category"]) { $AIResponse.category } else { "unknown" }
        $resourceId = if ($AIResponse.PSObject.Properties["resourceId"]) { $AIResponse.resourceId } else { "unknown" }
    }
    
    $finalScore = Get-ComputedConfidence -aiConfidence $aiConfidence -nonAiConfidence 0

    return [PSCustomObject]@{
        "resourceId"           = $resourceId
        "category"             = $category
        "calculated_at"        = if ($responceOK) { (Get-Date).ToUniversalTime().ToString("s") } else { (Get-Date).AddDays(-365).ToUniversalTime().ToString("s") }
        "ai_confidence"        = $aiConfidence
        "ai_mentions"          = $aiMentions
        "ai_alignment"         = $aiAlignment
        "ai_depth"             = $aiDepth
        "ai_intent"            = $aiIntent
        "ai_audience"          = $aiaudience
        "ai_signal"            = $aisignal
        "ai_penalties_applied" = $aipenalties_applied
        "ai_penalty_points"    = $aitotal_penalty_points
        "ai_penalty_details"   = $aipenalty_details
        "final_score"          = $finalScore
        "reasoning"            = $AIResponse.reasoning
        "level"                = Get-ComputedLevel -confidence $finalScore
    }
}


function Remove-ClassificationsFromCache {
    param (
        [string[]]$ClassificationsToRemove,
        [string]$CacheFolder
    )

    # Construct the cache file path
    $cacheFile = Join-Path $CacheFolder "data.index.classifications.json"

    # Check if the cache file exists
    if (!(Test-Path $cacheFile)) {
        Write-WarningLog "Cache file does not exist. No action needed."
        return
    }

    # Load the cache data
    try {
        $cachedData = Get-Content $cacheFile | ConvertFrom-Json -AsHashtable -ErrorAction Stop
    }
    catch {
        Write-WarningLog "Cache file is corrupted or unreadable. Unable to process."
        return
    }

    $removedCount = 0

    # Iterate through each classification to remove
    foreach ($classification in $ClassificationsToRemove) {
        if ($cachedData.ContainsKey($classification)) {
            # Remove the classification from cache
            $cachedData.Remove($classification)
            $removedCount++
            Write-Host "Removed classification '$classification' from cache."
        }
        else {
            Write-WarningLog "Classification '$classification' not found in cache. Skipping."
        }
    }

    # Save the updated cache if any classifications were removed
    if ($removedCount -gt 0) {
        $cachedData | ConvertTo-Json -Depth 10 | Set-Content -Path $cacheFile -Force
        Write-Host "Cache file updated successfully with $removedCount removals."
    }
    else {
        Write-WarningLog "No classifications were removed. Cache remains unchanged."
    }
}

function Remove-ClassificationsFromCacheThatLookBroken {
    param (
        [hashtable]$ClassificationCatalog,
        [string]$CacheFolder,
        [string]$ClassificationType = "classification"
    )

    # Construct the cache file path
    $cacheFile = Join-Path $CacheFolder "data.index.$ClassificationType.json"

    # Check if the cache file exists
    if (!(Test-Path $cacheFile)) {
        Write-WarningLog "Cache file does not exist. No action needed."
        return
    }

    # Load the cache data
    try {
        $cachedData = Get-Content $cacheFile | ConvertFrom-Json -AsHashtable -ErrorAction Stop
    }
    catch {
        Write-WarningLog "Cache file is corrupted or unreadable. Unable to process."
        return
    }

    $removedCount = 0

    # Iterate through each classification to remove
    foreach ($classification in $ClassificationCatalog.Keys) {
        if ($cachedData.ContainsKey($classification)) {
            $classificationData = $cachedData[$classification]
            if ($classificationData.reasoning -eq $null) {
                # Remove the classification from cache
                $cachedData.Remove($classification)
                if ($removedCount -gt 0) {
                    Set-ClassificationsFromCache -hugoMarkdown $hugoMarkdown -cachedData $cachedData
                    Write-Host "Cache file updated successfully with $removedCount removals."
                }
                else {
                    Write-WarningLog "No classifications were removed. Cache remains unchanged."
                }
            }


            if ($removedCount -gt 0) {
                Set-ClassificationsFromCache -hugoMarkdown $hugoMarkdown -cachedData $cachedData
                Write-Host "Cache file updated successfully with $removedCount removals."
            }
            else {
                Write-WarningLog "No classifications were removed. Cache remains unchanged."
            }
        }

    }
}

function Update-ClassificationLinksInBodyContent {
    param (
        [string]$ClassificationType,
        [object]$hugoMarkdown
    )

    $catalog = $catalogues["catalog"][$ClassificationType]

    foreach ($classification in $catalog.Keys) {
        $classificationData = $catalog[$classification]
        if ($classificationData.CrossLinkingInContent -eq $false) {
            Write-WarningLog "Classification $classification. Skipping."
            continue
        }
        $classificationTitle = $classificationData.Title
        $classificationSlug = $classificationTitle.ToLowerInvariant() -replace ' ', '-'
        $classificationEscaped = [regex]::Escape($classificationTitle)

        # Skip if already linked using the correct shortcode
        $linkedPattern = "\[.*?\]\(\{\{< ref ""/$ClassificationType/$classificationSlug"" >\}\}\)"
        if ($hugoMarkdown.BodyContent -match $linkedPattern) {
            continue
        }

        # Phase 1: Find all ranges of markdown links to exclude
        $excludedRanges = [System.Collections.Generic.List[System.Tuple[int, int]]]::new()
        $linkRegex = [regex]'\[.*?\]\(.*?\)'
        foreach ($match in $linkRegex.Matches($hugoMarkdown.BodyContent)) {
            $excludedRanges.Add([Tuple]::Create($match.Index, $match.Index + $match.Length))
        }

        # Phase 2: Find the first occurrence of the tag not inside any excluded range
        $simpleRegex = [regex]::new("\b($classificationEscaped)\b", [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
        foreach ($match in $simpleRegex.Matches($hugoMarkdown.BodyContent)) {
            $index = $match.Index

            $inExcluded = $false
            foreach ($range in $excludedRanges) {
                if ($index -ge $range.Item1 -and $index -lt $range.Item2) {
                    $inExcluded = $true
                    break
                }
            }

            if (-not $inExcluded) {
                # Inject Hugo ref-style link, preserving matched casing
                $MatchValue = $match.Value
                $replacement = "[$MatchValue]({{< ref `"/$ClassificationType/$classificationSlug`" >}})"
                $hugoMarkdown.BodyContent = $hugoMarkdown.BodyContent.Substring(0, $index) + $replacement + $hugoMarkdown.BodyContent.Substring($index + $match.Length)
                break
            }
        }
    }

    Write-InfoLog "Updated body content for classification type '$ClassificationType'."
    return $hugoMarkdown.BodyContent
}

function Get-CatalogItemsToRefreshOrGet {
    param (
        [Parameter(Mandatory = $true)]
        [Hashtable]$cachedData,
        [Parameter(Mandatory = $true)]
        [Hashtable]$Catalog,
        [Parameter(Mandatory = $true)]
        [Hashtable]$CatalogFromCache

    )

    $catalog_full = $catalogues["catalog_full"]
    # Find items from the catalogue that we don't have.
    $CatalogItemsToRefreshOrGet = @($Catalog.Keys | Where-Object { $_ -notin $cachedData.Keys })
    # Find items from the CatalogFromCache that are out of date.
    $CatalogItemsToRefreshOrGet = @($CatalogItemsToRefreshOrGet) + @(
        $CatalogFromCache.Values | Where-Object {
            if (-not $_.calculated_at) {
                $true
            }
            elseif (
                $catalog_full.ContainsKey($_.category) -and
                $_.calculated_at -and
                $catalog_full[$_.category].date
            ) {
                [DateTimeOffset]$_.calculated_at -lt [DateTimeOffset]$catalog_full[$_.category].date
            }
            else {
                $false
            }
        } | Select-Object -ExpandProperty category
    )

    $watermarkCount = $CatalogItemsToRefreshOrGet.Count
    $waterMarkRefresh = $CatalogItemsToRefreshOrGet.Count - $watermarkCount
    if ($waterMarkRefresh -le 0) {
        $waterMarkRefresh = [math]::Abs($waterMarkRefresh)
        # Find items from CatalogFromCache that are older than the watermark date and have a final_score > watermarkScoreLimit
        $CatalogItemsToRefreshOrGet = @($CatalogItemsToRefreshOrGet) + @(
            $CatalogFromCache.Values |
            Where-Object { 
                $_.final_score -gt $watermarkScoreLimit -and 
                [DateTimeOffset]$_.calculated_at -lt [DateTimeOffset]::Now.AddDays(-$watermarkAgeLimit)
            } |
            Sort-Object { [DateTimeOffset]$_.calculated_at } |
            Select-Object -ExpandProperty category |
            Select-Object -First $waterMarkRefresh
        )
    }
    # And invalidate the 
    Write-DebugLog "   Refreshing {CatalogItemsToRefreshOrGet} items from the Catalogue" -PropertyValues $CatalogItemsToRefreshOrGet.Count
    return $CatalogItemsToRefreshOrGet
}

function Set-ClassificationsFromCache {
    param (
        [Parameter(Mandatory = $true)]
        [HugoMarkdown]$hugoMarkdown,
        [Parameter(Mandatory = $true)]
        [hashtable]$cachedData
    )
    $CacheFolder = $hugoMarkdown.FolderPath
    $cacheFile = Join-Path $CacheFolder "data.index.classifications.json"
    $cachedData | ConvertTo-Json -Depth 2 | Set-Content -Path $cacheFile -Force

}


function Get-ClassificationsFromCache {
    param (
        [Parameter(Mandatory = $true)]
        [HugoMarkdown]$hugoMarkdown
    )

    $CacheFolder = $hugoMarkdown.FolderPath
    $catalog_full = $catalogues["catalog_full"]
    $cacheFile = Join-Path $CacheFolder "data.index.classifications.json"
   
    # Load from Cache and validate its contents
    #==========================================
    #=================CACHE====================
    #==========================================
    $cachedData = @{}
    Write-DebugLog "   Populating Cache"
    if (Test-Path $cacheFile) {
        # Load from cache
        try {
            $cachedData = Get-Content $cacheFile | ConvertFrom-Json -AsHashtable -ErrorAction Stop
        }
        catch {
            Write-WarningLog "Warning: Cache file corrupted. Resetting cache."
            $cachedData = @{}
        }
        Write-DebugLog "Cache Contains: $($cachedData.count) items"
        # Remove items that are not in catalogue            
        $keysToRemove = $cachedData.keys | Where-Object { $_ -notin $catalog_full.Keys }
        if ( $keysToRemove.Count -gt 0) {
            # If there are keys to remove, remove them and update the cache
            Write-DebugLog "     Remove: $($keysToRemove.Count) items not found in catalog"
            foreach ($key in $keysToRemove) {
                $cachedData.Remove($key)
            }
            Write-DebugLog "  Removed {expiredCount} Invalid Items" -PropertyValues $keysToRemove.Count
            $cachedData | ConvertTo-Json -Depth 10 | Set-Content -Path $cacheFile -Force
        }           
        # Check if the cache uses the latest calculations
        $recalculatedCount = 0
        $keysToCheck = $cachedData.keys | ForEach-Object { $_ }
        foreach ($key in  $keysToCheck ) {
            $entry = $cachedData[$key]
            $finalScore = Get-ComputedConfidence -aiConfidence $entry.ai_confidence -nonAiConfidence $entry.non_ai_confidence
            $level = Get-ComputedLevel -confidence $finalScore

            if ($entry.final_score -ne $finalScore -or $entry.level -ne $level) {
                $entry.final_score = $finalScore
                $entry.level = $level
                # Add calculated_at if it doesn't exist
                if (-not ($entry.ContainsKey('calculated_at'))) {
                    $entry.Insert(1, 'calculated_at', (Get-Date).ToUniversalTime().ToString("s"))
                }
                $entry.calculated_at = (Get-Date).ToUniversalTime().ToString("s")                
                # Update cache
                $cachedData[$key] = $entry
                $recalculatedCount++
            }
        }
        if ($recalculatedCount -gt 0) {
            Write-DebugLog "  Recalculated for {recalculatedCount} Items" -PropertyValues $recalculatedCount
            Set-ClassificationsFromCache -hugoMarkdown $hugoMarkdown -cachedData $cachedData            
        }
    }

    return $cachedData
    #==========================================
}


Write-InfoLog "ClassificationHelpers.ps1 loaded"