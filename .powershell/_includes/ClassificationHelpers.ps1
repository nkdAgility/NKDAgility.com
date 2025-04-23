. ./.powershell/_includes/LoggingHelper.ps1
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


function Get-ClassificationCache {
    param (
        [Parameter(Mandatory = $true)]
        [string]$CacheFolder,
        [string]$ClassificationType = "classification"
    )

    $cacheFile = Join-Path $CacheFolder "data.index.classifications.$ClassificationType.json"
    if (Test-Path $cacheFile) {
        # Load from cache
        try {
            $cachedData = Get-Content $cacheFile | ConvertFrom-Json -AsHashtable -ErrorAction Stop
        }
        catch {
            Write-WarningLog "Warning: Cache file corrupted. Resetting cache."
            $cachedData = @{}
        }
    }
    return  $cachedData
}

function Remove-ClassificationCacheExpired {
    param (
        [Parameter(Mandatory = $true)]
        [hashtable]$cachedData,
        [Parameter(Mandatory = $true)]
        [hashtable]$catalog
    )
    $keysToRemove = $cachedData.keys | Where-Object { $_ -notin $catalog.Keys }
    if ( $keysToRemove.Count -gt 0) {
        # If there are keys to remove, remove them and update the cache
        Write-DebugLog "     Remove: $($keysToRemove.Count) items not found in catalog"
        foreach ($key in $keysToRemove) {
            $cachedData.Remove($key)
        }
        Write-DebugLog "  Removed {expiredCount} Invalid Items" -PropertyValues $keysToRemove.Count
        $cachedData | ConvertTo-Json -Depth 10 | Set-Content -Path $cacheFile -Force
    }  
}

function Update-ClassificationCacheCalculations {
    param (
        [Parameter(Mandatory = $true)]
        [hashtable]$cachedData
    )
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
        $cachedData | ConvertTo-Json -Depth 2 | Set-Content -Path $cacheFile -Force            
    }
}

function Update-ClassificationFromBatch {
    param (
        [Parameter(Mandatory = $true)]
        [HugoMarkdown]$hugoMarkdown,
        [string]$batchFile
    )
    
    # If the batch file exists, check the status
    $batchStatus = $null
    if (Test-Path $batchFile) {
        $batchId = Get-Content $batchFile
        $batchStatus = Get-OpenAIBatchStatus -BatchId $batchId

        switch ($batchStatus) {
            "completed" {
                Write-InfoLog "Batch completed. Processing results..."
                # Process batch results into cache format
                $batchResults = Get-OpenAIBatchResults -BatchId $batchId -OutputFile $batchJsonlOutout
                foreach ($result in $batchResults) {
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
                    $newEntry = Get-ConfidenceFromAIResponse -AIResponseJson $aiResponseJson -ResourceTitle $hugoMarkdown.FrontMatter.title -ResourceContent $hugoMarkdown.BodyContent
                    if ($cachedData.ContainsKey($newEntry.category)) {
                        $oldEntry = $cachedData.($newEntry.category)
                        if ([System.DateTimeOffset]$oldEntry.calculated_at -gt $newEntry.calculated_at) {
                            $cachedData[$newEntry.category] = $newEntry
                        }
                    }
                    else {
                        $cachedData.Add($newEntry.category, $newEntry )
                    }
                }

                # Save updated cache
                $cachedData | ConvertTo-Json -Depth 4 | Set-Content -Path $cacheFile -Force

                # Cleanup batch file after processing
                Remove-Item $batchFile -Force
                Remove-Item $batchJsonlInput -Force
                Remove-Item $batchJsonlOutout -Force
                $batchStatus = $null
            }
            "in_progress" {
                Write-WarningLog "Batch still in progress. Please wait for completion."
            }
            "failed" {
                Write-ErrorLog "Batch failed for $batchId. Please try again."
                Remove-Item $batchFile -Force
                Remove-Item $batchJsonlInput -Force
                $batchStatus = $null
                exit
            }
            default {
                Write-WarningLog $batchStatus
            }
        }
    }
}


function Update-ClassificationCache {
    param (
        [Parameter(Mandatory = $true)]
        [HugoMarkdown[]]$hugoMarkdowns
    )

    foreach ($hugoMarkdown in $hugoMarkdowns) {
       
    }
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

    $batchFile = Join-Path $CacheFolder "data.index.classifications.$ClassificationType.batch"
    $batchJsonlOutout = Join-Path $CacheFolder "data.index.classifications.$ClassificationType-output.jsonl"
    $batchJsonlInput = Join-Path $CacheFolder "data.index.classifications.$ClassificationType-input.jsonl"

    # Populate Catalogues
    Write-InfoLog "   Populating Catalogues"
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

    # Load from Cache and validate its contents
    #==========================================
    #=================CACHE====================
    #==========================================
    $cachedData = @{}
    Write-InfoLog "   Populating Cache"
    $cachedData = Get-ClassificationCache -CacheFolder $CacheFolder -ClassificationType $ClassificationType
    $cachedData = Remove-ClassificationCacheExpired -cachedData $cachedData -catalog $catalog_full
    $cachedData = Update-ClassificationCacheCalculations -cachedData $cachedData
    # Bring Batch results into Cache file
    # If the batch file exists, check the status
    Update-ClassificationFromBatch -hugoMarkdown $hugoMarkdown -batchFile $batchFile
    #==========================================
    #================/CACHE====================
    #==========================================

    #Find items from the catalogue that we have.
    $CatalogFromCache = @{}; $cachedData.Keys | Where-Object { $catalog.ContainsKey($_) } | ForEach-Object { $CatalogFromCache[$_] = $cachedData[$_] }

    # Find items from the catalogue that we don't have.
    $CatalogItemsToRefreshOrGet = @($catalog.Keys | Where-Object { $_ -notin $cachedData.Keys })
    # Find items from the CatalogFromCache that are out of date.
    $CatalogItemsToRefreshOrGet = @($CatalogItemsToRefreshOrGet) + @(
        $CatalogFromCache.Values | Where-Object {
            if (-not $_.calculated_at) {
                ,
                $true
            }
            elseif (
                $catalog_full.ContainsKey($_.category) -and
                $_.calculated_at -and
                $catalog_full[$_.category].datebatch
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
    Write-InformationLog "   Refreshing {CatalogItemsToRefreshOrGet} items from the Catalogue" -PropertyValues $CatalogItemsToRefreshOrGet.Count

    if ($CatalogItemsToRefreshOrGet.Count -gt 0 -and $batchStatus -eq $null -and $updateMissing) {
      
        # Build prompts for missing items
        $prompts = @()
        foreach ($category in $CatalogItemsToRefreshOrGet) {
            $prompt = Get-Prompt -PromptName "classification-analysis.md" -Parameters @{
                category     = $category
                Instructions = $Catalog[$category].Instructions
                title        = $hugoMarkdown.FrontMatter.Title
                abstract     = $hugoMarkdown.FrontMatter.Description
                content      = $hugoMarkdown.BodyContent
            }
            $prompts += $prompt
        }

        # Check number of batches in progress
        if ($batch -and $prompts.Count -gt 40 -and (-not $batchesInProgress)) {
            # Get current batches in progress
            $batchesInProgress = Get-OpenAIBatchesInProgress -ApiKey $OPEN_AI_KEY
        }

        if ($batch -and $prompts.Count -gt 40 -and $batchesInProgress -lt $batchesInProgressMax) {
            # Batch processing
            $batchId = Submit-OpenAIBatch -Prompts $prompts -OutputFile $batchJsonlInput
            if ($batchId) {
                $batchesInProgress++
                $batchId | Set-Content -Path $batchFile -Force
                Write-WarningLog "Batch submitted. Processing..."
            }
            else {
                Write-WarningLog "Batch not submitted. Too many tokens in progress. try again later."
            }
        }
        else {
            $count = 0
            foreach ($prompt in $prompts) {
                $count++
                Write-DebugLog "Processing Prompt [$count/$($prompts.Count)] | $(($count / $prompts.Count) * 100)%"
                #Write-Progress -Id 2 -Activity "Classification of $ClassificationType" -Status "Processing prompt [$count/$($prompts.count)]" -PercentComplete (($count / $prompts.count) * 100)
                # Calls processing
                $aiResponseJson = Get-OpenAIResponse -Prompt $prompt
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
                    
                    Write-InformationLog "Updating {category} confidence {diff}! The old confidence of {old} was calculated {daysago} days ago. The new confidence is {confidence}!" -PropertyValues $result.category, $confidenceDiff, $oldConfidence, $DaysAgo, $result.ai_confidence
                    $CatalogFromCache[$result.category] = $result
                    $cachedData[$result.category] = $result
                    # Save cache after each API call
                    $cachedData | ConvertTo-Json -Depth 2 | Set-Content -Path $cacheFile -Force
                }
                else {
                    Write-ErrorLog "Error processing AI response for $($result.category). Reasoning is Null!"
                    exit
                }               
            }
            # Write-Progress -Id 2 -Activity "All Tasks Complete" -Completed
        }
    }

   
    #==========================================
    #=================return===================
    #==========================================
    return $CatalogFromCache.Values | Sort-Object final_score -Descending
    #==========================================
    #================/return===================
    #==========================================
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
        [Parameter(Mandatory = $true)]
        [HugoMarkdown]$hugoMarkdown,
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
            $aiConfidence = [math]::Round($aiConfidence * 100)
        }
        $aiMentions = if ($AIResponse.PSObject.Properties["mentions"]) { $AIResponse.mentions } else { 0 }
        if ($aiMentions -le 1 -and $aiMentions -gt 0) {
            $aiMentions = [math]::Round($aiMentions * 100)
        }
        $aiAlignment = if ($AIResponse.PSObject.Properties["alignment"]) { $AIResponse.alignment } else { 0 }
        if ($aiAlignment -le 1 -and $aiAlignment -gt 0) {
            $aiAlignment = [math]::Round($aiAlignment * 100)
        }
        $aiDepth = if ($AIResponse.PSObject.Properties["depth"]) { $AIResponse.depth } else { 0 }
        if ($aiDepth -le 1 -and $aiDepth -gt 0) {
            $aiDepth = [math]::Round($aiDepth * 100)
        }
       
        # Detect if confidence is a float in the 0-1 range
       
        $category = if ($AIResponse.PSObject.Properties["category"]) { $AIResponse.category } else { "unknown" }
    }
    
    # Non-AI Confidence Calculation
    $nonAiConfidence = 0
    $categoryWords = $category -split '\s+'
    $contentWords = ($hugoMarkdown.FrontMatter.title + " " + $hugoMarkdown.BodyContent) -split '\s+'
    $escapedCategory = [Regex]::Escape($category)

    if ($category -in $contentWords) {
        $nonAiConfidence += 50
    }
    elseif ($contentWords | Where-Object { $_ -match $escapedCategory }) {
        $nonAiConfidence += 30
    }
    else {
        foreach ($word in $categoryWords) {
            if ($contentWords -contains $word) {
                $nonAiConfidence += 10
            }
        }
    }

    $finalScore = Get-ComputedConfidence -aiConfidence $aiConfidence -nonAiConfidence $nonAiConfidence

    return [PSCustomObject]@{
        "category"          = $category
        "calculated_at"     = if ($responceOK) { (Get-Date).ToUniversalTime().ToString("s") } else { (Get-Date).AddDays(-365).ToUniversalTime().ToString("s") }
        "ai_confidence"     = $aiConfidence
        "ai_mentions"       = $aiMentions
        "ai_alignment"      = $aiAlignment
        "ai_depth"          = $aiDepth
        "non_ai_confidence" = $nonAiConfidence
        "final_score"       = $finalScore
        "reasoning"         = $AIResponse.reasoning
        "level"             = Get-ComputedLevel -confidence $finalScore
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
                    $cachedData | ConvertTo-Json -Depth 2 | Set-Content -Path $cacheFile -Force
                    Write-Host "Cache file updated successfully with $removedCount removals."
                }
                else {
                    Write-WarningLog "No classifications were removed. Cache remains unchanged."
                }
            }


            if ($removedCount -gt 0) {
                $cachedData | ConvertTo-Json -Depth 2 | Set-Content -Path $cacheFile -Force
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


Write-InfoLog "ClassificationHelpers.ps1 loaded"