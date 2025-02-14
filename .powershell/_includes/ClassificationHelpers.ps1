. ./.powershell/_includes/LoggingHelper.ps1
. ./.powershell/_includes/OpenAI.ps1

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
        $catalogHash[$markdownMeta.FrontMatter.Title] = $markdownMeta.FrontMatter
    }

    return $catalogHash
}

$catalogues = @{}
$catalogues["catalog"] = @{}
$catalogues["catalog"]["categories"] = Get-CatalogHashtable -Classification "categories"
$catalogues["catalog"]["tags"] = Get-CatalogHashtable -Classification "tags"
$catalogues["catalog_full"] = $catalogues["catalog"]["categories"] + $catalogues["catalog"]["tags"]

function Get-CategoryConfidenceWithChecksum {
    param (
        [string]$ResourceContent,
        [string]$ResourceTitle,
        [string]$CacheFolder,
        [string]$ClassificationType = "classification",
        [int]$MinConfidence = 50,
        [int]$MaxCategories = 5,
        [switch]$batch
    )

    if (!(Test-Path $CacheFolder)) {
        New-Item -ItemType Directory -Path $CacheFolder -Force | Out-Null
    }

    # Populate Catalogues
    Write-InfoLog "   Populating Catalogues"
    $catalog = @{}    
    switch ($ClassificationType) {
        { $_ -in "categories", "tags" } {
            $catalog = $catalogues["catalog"][$ClassificationType]
            $catalog_full = $catalogues["catalog_full"]
            $cacheFile = Join-Path $CacheFolder "data.index.classifications.json"
        }
        "catalog_full" {
            $catalog = $catalogues["catalog_full"]
            $catalog_full = $catalogues["catalog_full"]
            $cacheFile = Join-Path $CacheFolder "data.index.classifications.json"
        }
        "marketing" {
            $catalog = $catalogues["marketing"]
            $catalog_full = $catalog
            $cacheFile = Join-Path $CacheFolder "data.index.classifications.json"
        }
        default {
            Write-ErrorLog "Invalid classification type. Please use 'categories', 'tags', or 'marketing'."
            return @()
        }
    }

    # Load from Cache and validate its contents
    $cachedData = @{}
    Write-InfoLog "   Populating Cache"
    if (Test-Path $cacheFile) {
        # Load from cache
        try {
            $cachedData = Get-Content $cacheFile | ConvertFrom-Json -ErrorAction Stop
        }
        catch {
            Write-WarningLog "Warning: Cache file corrupted. Resetting cache."
            $cachedData = @{}
        }
        Write-DebugLog "Cache Contains: $(($cachedData.PSObject.Properties.Count | Measure-Object).count) items"
        # Remove items that are not in catalogue            
        $keysToRemove = $cachedData.PSObject.Properties.Name | Where-Object { $_ -notin $catalog_full.Keys }
        if ( $keysToRemove.Count -gt 0) {
            # If there are keys to remove, remove them and update the cache
            Write-DebugLog "     Remove: $($keysToRemove.Count) items not found in catalog"
            foreach ($key in $keysToRemove) {
                $cachedData.PSObject.Properties.Remove($key)
            }
            Write-DebugLog "     After: $(($cachedData.PSObject.Properties.Count | Measure-Object).count) items"
            $cachedData | ConvertTo-Json -Depth 2 | Set-Content -Path $cacheFile -Force
            Write-DebugLog "  Removed {expiredCount} Invalid Items" -PropertyValues $keysToRemove.Count
        }           
        # Check if the cache is up to date
        $expiredCount = 0
        foreach ($key in $cachedData.PSObject.Properties) {
            $entry = $key.Value
            if (([DateTimeOffset]$entry.calculated_at) -lt ([DateTimeOffset]$catalog_full[$key.Name].date)) {
                Write-DebugLog "Cache is out of date for $key"
                $cachedData.PSObject.Properties.Remove($key)
                $expiredCount++
            }
        }
        if ($expiredCount -gt 0) {
            Write-DebugLog "  Removed {expiredCount} Expired Items" -PropertyValues $expiredCount
            $cachedData | ConvertTo-Json -Depth 2 | Set-Content -Path $cacheFile -Force
        }
        # Check if the cache uses the latest calculations
        $recalculatedCount = 0
        foreach ($key in $cachedData.PSObject.Properties) {
            $entry = $key.Value
            $finalScore = Get-ComputedConfidence -aiConfidence $entry.ai_confidence -nonAiConfidence $entry.non_ai_confidence
            $level = if ($finalScore -ge 80) { "Primary" } elseif ($finalScore -ge 50) { "Secondary" } else { "Ignored" }
            if ($entry.final_score -ne $finalScore -or $entry.level -ne $level) {
                $entry.final_score = $finalScore
                $entry.level = $level
                $entry.calculated_at = (Get-Date).ToUniversalTime().ToString("s")                
                # Update cache
                $cachedData.($key.name) = $entry
                $recalculatedCount++
            }
        }
        if ($recalculatedCount -gt 0) {
            $cachedData | ConvertTo-Json -Depth 2 | Set-Content -Path $cacheFile -Force
            Write-DebugLog "  Recalculated for {recalculatedCount} Items" -PropertyValues $recalculatedCount
        }
    }

    # Build Scores from cache and missings
    $categoryScores = @{}
    $categoryMissing = @{}
    $count = 0;
    $total = $catalog.Keys.Count
    foreach ($category in $catalog.Keys) {
        Write-Progress -Id 2 -ParentId 1 -Activity "Classification of $ClassificationType" -Status "Processing classification $count of $total '$category'" -PercentComplete (($count / $total) * 100)
        $count++
        if ($cachedData.PSObject.Properties[$category]) {            
            $categoryScores[$category] = $cachedData.$category      
        }
        else {
            $categoryMissing[$category] = $category
        }
    }
    # Return if good to go
    if ($categoryMissing.Count -eq 0) {
        $finalSelection = $categoryScores.Values | Where-Object { $_.level -ne "Ignored" } | Sort-Object final_score -Descending | Select-Object -First $MaxCategories
        return $finalSelection | ConvertTo-Json -Depth 1
    }

    # Get new data for missing items


    $batchJsonlOutout = Join-Path $CacheFolder "data.index.classifications.$ClassificationType-output.jsonl"
    $batchJsonlInput = Join-Path $CacheFolder "data.index.classifications.$ClassificationType-input.jsonl"
    $batchFile = Join-Path $CacheFolder "data.index.classifications.$ClassificationType.batch"

    # If the batch file exists, check the status
    if (Test-Path $batchFile) {
        $batchId = Get-Content $batchFile
        $batchStatus = Get-OpenAIBatchStatus -BatchId $batchId

        switch ($batchStatus) {
            "completed" {
                # Process batch results into cache format
                $batchResults = Get-OpenAIBatchResults -BatchId $batchId -OutputFile $batchJsonlOutout
                $categoryScores = @{}

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
                    $categoryScores[$category] = Get-ConfidenceFromAIResponse -Category $category -AIResponseJson $aiResponseJson -ResourceTitle $ResourceTitle -ResourceContent $ResourceContent
                }

                # Save updated cache
                $categoryScores | ConvertTo-Json -Depth 2 | Set-Content -Path $cacheFile -Force

                # Cleanup batch file after processing
                Remove-Item $batchFile -Force
                Remove-Item $batchJsonlInput -Force
                Remove-Item $batchJsonlOutout -Force
            }
            "in_progress" {
                Write-WarningLog "Batch still in progress. Please wait for completion."
                return @()
            }
            "failed" {
                Write-ErrorLog "Batch failed. Please try again."
                Remove-Item $batchFile -Force
                Remove-Item $batchJsonlInput -Force
                return @()
            }
            default {
                Write-WarningLogLog $batchStatus
                return @()
            }
        }
    }


    $categoryScores = @{}
    $count = 0;
    $total = $Catalog.Keys.Count
    $prompts = @()
    foreach ($category in $Catalog.Keys) {
        Write-Progress -Id 2 -ParentId 1 -Activity "Classification of $ClassificationType" -Status "Processing classification $count of $total '$category'" -PercentComplete (($count / $total) * 100)
        $count++
        if ($cachedData.PSObject.Properties[$category]) {            
            $cachedCategory = $cachedData.$category
            # If the cache is up to date, skip the API call
            if (($cachedCategory.calculated_at) -and (([DateTimeOffset]$cachedCategory.calculated_at) -gt ([DateTimeOffset]$Catalog[$category].date))) {
                # Recalculate final_score and level
                $finalScore = = Get-ComputedConfidence -aiConfidence $cachedCategory.ai_confidence -nonAiConfidence $cachedCategory.non_ai_confidence
                $level = if ($finalScore -ge 80) { "Primary" } elseif ($finalScore -ge 50) { "Secondary" } else { "Ignored" }
            
                if ($cachedCategory.final_score -ne $finalScore -or $cachedCategory.level -ne $level) {
                    $cachedCategory.final_score = $finalScore
                    $cachedCategory.level = $level
                    $cachedCategory.calculated_at = (Get-Date).ToUniversalTime().ToString("s")
                
                    # Update cache
                    $cachedData.$category = $cachedCategory
                    $cachedData | ConvertTo-Json -Depth 2 | Set-Content -Path $cacheFile -Force
                    Write-DebugLog "Updated cache for $category"    
                }
            
                $categoryScores[$category] = $cachedCategory
                continue
            }           
        }
        $prompt = @"
You are an AI expert in content classification. Evaluate how well the given content aligns with the category **"$category"**. 

With that classification meaning:

"$($Catalog[$category].Instructions)"

Rules:
1. **Only classify the content into this category if it is a clear, primary topic.**
   - If the category is **only briefly mentioned**, **do not classify it**.
   - If the content is **mostly about something else**, return `"confidence": 0`.
2. **Confidence Levels:**
   - **80-100:** The content is **primarily about this category**.
   - **50-79:** The category is **a major but secondary theme**.
   - **Below 50:** The category **is not relevant enough**.
3. **Do not classify based on loose associations.** The category must be **central to the content.**

return format should be valid json that looks like this:
{
  "category": "$category",
  "confidence": 0,
  "reasoning": "Content heavily discusses Scrum roles and events."
}

do not wrap the json in anything else, just return the json object.

**Content Title:** "$ResourceTitle"  
**Content:** "$ResourceContent"
"@

        if ($batch) {
            $prompts += $prompt
        }
        else {
            $aiResponseJson = Get-OpenAIResponse -Prompt $prompt

            $categoryScores[$category] = Get-ConfidenceFromAIResponse -Category $category -AIResponseJson $aiResponseJson -ResourceTitle $ResourceTitle -ResourceContent $ResourceContent

            if ($categoryScores[$category].reasoning -ne $null) {
                $cachedData | Add-Member -MemberType NoteProperty -Name $category -Value $categoryScores[$category] -Force
            }
            # Save cache after each API call
            $cachedData | ConvertTo-Json -Depth 2 | Set-Content -Path $cacheFile -Force
        }
       
    }

    if ($batch) {
        if ($prompts.Count -gt 0) {
            # Submit batch and save batch ID
            $batchId = Submit-OpenAIBatch -Prompts $prompts -OutputFile $batchJsonlInput
            if ($batchId) {
                $batchId | Set-Content -Path $batchFile -Force
                Write-WarningLog "Batch submitted. Processing..."
            }
            else {
                Write-WarningLog "Batch not submitted. Too many tokens in progress. try again later."
            }
            return @()
        }
    }
    else {
        Write-Progress -Id 2 -Activity "All Tasks Complete" -Completed

        $finalSelection = $categoryScores.Values | Where-Object { $_.level -ne "Ignored" } | Sort-Object final_score -Descending | Select-Object -First $MaxCategories
        return $finalSelection | ConvertTo-Json -Depth 1
    }
}

function Get-ComputedConfidence {
    param (
        [int]$aiConfidence,
        [int]$nonAiConfidence
    )
    return [math]::Round(($aiConfidence * 0.9) + ($nonAiConfidence * 0.1))
}

function Get-ConfidenceFromAIResponse {
    param (
        [string]$Category,
        [string]$AIResponseJson,
        [string]$ResourceTitle,
        [string]$ResourceContent
    )
    try {
        if ($AIResponseJson -match '(?s)```json\s*(.*?)\s*```') {
            $AIResponseJson = $matches[1] # Extracted JSON content 
        
        }
        $AIResponse = $AIResponseJson | ConvertFrom-Json -ErrorAction Stop
    }
    catch {
        Write-ErrorLog "Error parsing AI response for $Category. Skipping. Error: $_"
        Write-ErrorLog "AI Response Json: {AIResponseJson}" -PropertyValues $AIResponseJson
        exit
    }
   
    try {
        $aiConfidence = if ($AIResponse.PSObject.Properties["confidence"]) { $AIResponse.confidence } else { 0 }
    }
    catch {
        Write-ErrorLog "Error parsing AI response for $Category. Skipping. Error: $_"
        Write-ErrorLog "AI Response Json: {AIResponseJson}" -PropertyValues $AIResponseJson
        exit
    }
    
    # Non-AI Confidence Calculation
    $nonAiConfidence = 0
    $categoryWords = $Category -split '\s+'
    $contentWords = ($ResourceTitle + " " + $ResourceContent) -split '\s+'
    $escapedCategory = [Regex]::Escape($Category)

    if ($Category -in $contentWords) {
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
        "category"          = $Category
        "calculated_at"     = (Get-Date).ToUniversalTime().ToString("s")
        "ai_confidence"     = $aiConfidence
        "non_ai_confidence" = $nonAiConfidence
        "final_score"       = $finalScore
        "reasoning"         = $AIResponse.reasoning
        "level"             = if ($finalScore -ge 80) { "Primary" } elseif ($finalScore -ge 50) { "Secondary" } else { "Ignored" }
    }
}


function Remove-ClassificationsFromCache {
    param (
        [string[]]$ClassificationsToRemove,
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
        $cachedData = Get-Content $cacheFile | ConvertFrom-Json -ErrorAction Stop
    }
    catch {
        Write-WarningLog "Cache file is corrupted or unreadable. Unable to process."
        return
    }

    $removedCount = 0

    # Iterate through each classification to remove
    foreach ($classification in $ClassificationsToRemove) {
        if ($cachedData.PSObject.Properties[$classification]) {
            # Remove the classification from cache
            $cachedData.PSObject.Properties.Remove($classification)
            $removedCount++
            Write-Host "Removed classification '$classification' from cache."
        }
        else {
            Write-WarningLog "Classification '$classification' not found in cache. Skipping."
        }
    }

    # Save the updated cache if any classifications were removed
    if ($removedCount -gt 0) {
        $cachedData | ConvertTo-Json -Depth 2 | Set-Content -Path $cacheFile -Force
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
        $cachedData = Get-Content $cacheFile | ConvertFrom-Json -ErrorAction Stop
    }
    catch {
        Write-WarningLog "Cache file is corrupted or unreadable. Unable to process."
        return
    }

    $removedCount = 0

    # Iterate through each classification to remove
    foreach ($classification in $ClassificationCatalog.Keys) {
        if ($cachedData.PSObject.Properties[$classification]) {
            $classificationData = $cachedData.PSObject.Properties[$classification].Value
            if ($classificationData.reasoning -eq $null) {
                # Remove the classification from cache
                $cachedData.PSObject.Properties.Remove($classification)
                $removedCount++
                Write-Host "Removed classification '$classification' from cache."
            } 
        }
        else {
            Write-WarningLog "Classification '$classification' not found in cache. Skipping."
        }
    }

    # Save the updated cache if any classifications were removed
    if ($removedCount -gt 0) {
        $cachedData | ConvertTo-Json -Depth 2 | Set-Content -Path $cacheFile -Force
        Write-Host "Cache file updated successfully with $removedCount removals."
    }
    else {
        Write-WarningLog "No classifications were removed. Cache remains unchanged."
    }
}
