. ./.powershell/_includes/OpenAI.ps1
function Get-CatalogHashtable {
    param (
        [string]$FolderPath = "site\content",
        [string]$Classification
    )

    # Get the metadata (assumed to be an array of objects)
    $catalog = Get-MarkdownMetadata -FolderPath "$FolderPath\$Classification" | ConvertFrom-Json 

    # Initialize an empty hashtable
    $catalogHash = @{}

    # Loop through each object and store the Title-Description pair in the hashtable
    foreach ($item in $catalog) {
        if ($item.Title -and $item.Description) {
            $catalogHash[$item.Title] = $item.Description
        }
    }

    return $catalogHash
}

function Get-CategoryConfidenceWithChecksum {
    param (
        [string]$ResourceContent,
        [string]$ResourceTitle,
        [hashtable]$Catalog,
        [string]$CacheFolder,
        [string]$ClassificationType = "classification",
        [int]$MinConfidence = 50,
        [int]$MaxCategories = 5
    )

    if (!(Test-Path $CacheFolder)) {
        New-Item -ItemType Directory -Path $CacheFolder -Force | Out-Null
    }

    $cacheFile = Join-Path $CacheFolder "data.index.$ClassificationType.json"

    $cachedData = @{}
    if (Test-Path $cacheFile) {
        try {
            $cachedData = Get-Content $cacheFile | ConvertFrom-Json -ErrorAction Stop
        }
        catch {
            Write-Debug "Warning: Cache file corrupted. Resetting cache."
            $cachedData = @{}
        }
    }

    $categoryScores = @{}
    $count = 0;
    $total = $Catalog.Keys.Count
    foreach ($category in $Catalog.Keys) {
        Write-Progress -Id 2 -ParentId 1 -Activity "Classification of $ClassificationType" -Status "Processing classification $count of $total '$category'" -PercentComplete (($count / $total) * 100)
        $count++
        if ($cachedData.PSObject.Properties[$category]) {
            $categoryScores[$category] = $cachedData.$category
            continue
        }

        $prompt = @"
You are an AI expert in content classification. Evaluate how well the given content aligns with the category **"$category"**. With that classification meaning "$($Catalog[$category])"

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
  "confidence": 92,
  "reasoning": "Content heavily discusses Scrum roles and events."
}

do not wrap the json in anything else, just return the json object.

**Content Title:** "$ResourceTitle"  
**Content:** "$ResourceContent"
"@

        $aiResponse = Get-OpenAIResponse -Prompt $prompt
        $aiResponseJson = $aiResponse | ConvertFrom-Json

        $aiConfidence = if ($aiResponseJson.PSObject.Properties["confidence"]) { $aiResponseJson.confidence } else { 0 }

        $nonAiConfidence = 0
        $categoryWords = $category -split '\s+'
        $contentWords = ($ResourceTitle + " " + $ResourceContent) -split '\s+'
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

        $finalScore = [math]::Round(($aiConfidence * 0.7) + ($nonAiConfidence * 0.3))

        $categoryScores[$category] = [PSCustomObject]@{
            "category"          = $category
            "ai_confidence"     = $aiConfidence
            "non_ai_confidence" = $nonAiConfidence
            "final_score"       = $finalScore
            "reasoning"         = $aiResponseJson.reasoning
            "level"             = if ($finalScore -ge 80) { "Primary" } elseif ($finalScore -ge 50) { "Secondary" } else { "Ignored" }
        }

        $cachedData | Add-Member -MemberType NoteProperty -Name $category -Value $categoryScores[$category] -Force

        # Save cache after each API call
        $cachedData | ConvertTo-Json -Depth 2 | Set-Content -Path $cacheFile -Force
    }

    Write-Progress -Id 2 -Activity "All Tasks Complete" -Completed

    $finalSelection = $categoryScores.Values | Where-Object { $_.level -ne "Ignored" } | Sort-Object final_score -Descending | Select-Object -First $MaxCategories
    return $finalSelection | ConvertTo-Json -Depth 1
}

function Get-BatchCategoryConfidenceWithChecksum {
    param (
        [string]$ResourceContent,
        [string]$ResourceTitle,
        [hashtable]$Catalog,
        [string]$CacheFolder,
        [string]$ClassificationType = "classification",
        [int]$MinConfidence = 50,
        [int]$MaxCategories = 5
    )

    if (!(Test-Path $CacheFolder)) {
        New-Item -ItemType Directory -Path $CacheFolder -Force | Out-Null
    }

    $batchJsonlOutout = Join-Path $CacheFolder "data.index.$ClassificationType-output.jsonl"
    $batchJsonlInput = Join-Path $CacheFolder "data.index.$ClassificationType-input.jsonl"
    $batchFile = Join-Path $CacheFolder "data.index.$ClassificationType.batch"
    $cacheFile = Join-Path $CacheFolder "data.index.$ClassificationType.json"

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
                            $aiResponseJson = $jsonContent | ConvertFrom-Json
                        }
                        else {
                            $aiResponseJson = $rawAiBatchResult.response.body.choices[0].message.content | ConvertFrom-Json 
                        }
                    }
                    catch {
                        Write-ErrorLog "Error parsing AI response for $CacheFolder. Skipping."
                        continue
                    }
                   
                    $category = $aiResponseJson.category
                    $aiConfidence = if ($aiResponseJson.PSObject.Properties["confidence"]) { $aiResponseJson.confidence } else { 0 }

                    # Non-AI Confidence Calculation
                    $nonAiConfidence = 0
                    $categoryWords = $category -split '\s+'
                    $contentWords = ($ResourceTitle + " " + $ResourceContent) -split '\s+'
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

                    $finalScore = [math]::Round(($aiConfidence * 0.7) + ($nonAiConfidence * 0.3))

                    $categoryScores[$category] = [PSCustomObject]@{
                        "category"          = $category
                        "ai_confidence"     = $aiConfidence
                        "non_ai_confidence" = $nonAiConfidence
                        "final_score"       = $finalScore
                        "reasoning"         = $aiResponseJson.reasoning
                        "level"             = if ($finalScore -ge 80) { "Primary" } elseif ($finalScore -ge 50) { "Secondary" } else { "Ignored" }
                    }
                }

                # Save updated cache
                $categoryScores | ConvertTo-Json -Depth 2 | Set-Content -Path $cacheFile -Force

                # Cleanup batch file after processing
                Remove-Item $batchFile -Force
                Remove-Item $batchJsonlInput -Force
                Remove-Item $batchJsonlOutout -Force
            }
            "in_progress" {
                Write-Warning "Batch still in progress. Please wait for completion."
                return @()
            }
            "failed" {
                Write-ErrorLog "Batch failed. Please try again."
                Remove-Item $batchFile -Force
                Remove-Item $batchJsonlInput -Force
                return @()
            }
            default {
                Write-WarningLog $batchStatus
                return @()
            }
        }
    }

    # If cache exists, use it
    if (Test-Path $cacheFile) {
        try {
            $cachedData = Get-Content $cacheFile | ConvertFrom-Json -Depth 10 -ErrorAction Stop

            $categoryScores = @{}
            foreach ($category in $Catalog.Keys) {
                if ($cachedData.PSObject.Properties[$category]) {
                    $categoryScores[$category] = $cachedData.$category
                }
            }        

            $finalSelection = $categoryScores.Values | Where-Object { $_.level -ne "Ignored" } | Sort-Object final_score -Descending | Select-Object -First $MaxCategories
            return $finalSelection | ConvertTo-Json -Depth 1
        }
        catch {
            Write-Debug "Warning: Cache file corrupted. Resetting cache."
            Remove-Item $cacheFile -Force
        }
    }

    # If batch file does not exist, create a new batch
    $prompts = @()
    $categoryMap = @{}

    foreach ($category in $Catalog.Keys) {
        $prompt = @"
You are an AI expert in content classification. Evaluate how well the given content aligns with the category **"$category"**.

Rules:
1. **Only classify the content into this category if it is a clear, primary topic.**
   - If the category is **only briefly mentioned**, **do not classify it**.
   - If the content is **mostly about something else**, return `"confidence": 0` .
2. **Confidence Levels:**
   - **80-100:** The content is **primarily about this category**.
   - **50-79:** The category is **a major but secondary theme**.
   - **Below 50:** The category **is not relevant enough**.
3. **Do not classify based on loose associations.** The category must be **central to the content.**

return format should be valid json that looks like this:
{
  "category": "$category",
  "confidence": 92,
  "reasoning": "Content heavily discusses Scrum roles and events."
}

do not wrap the json in anything else, just return the json object.

**Content Title:** "$ResourceTitle"  
**Content:** "$ResourceContent"
"@
        $prompts += $prompt
        $categoryMap[$prompts.Count - 1] = $category
    }

    if ($prompts.Count -gt 0) {
        # Submit batch and save batch ID
        $batchId = Submit-OpenAIBatch -Prompts $prompts -OutputFile $batchJsonlInput
        $batchId | Set-Content -Path $batchFile -Force
        Write-Warning "Batch submitted. Processing..."
        else {
            Write-Warning "Batch not submitted. Too many tokens in progress. try again later."
        }
        return @()
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
        Write-Warning "Cache file does not exist. No action needed."
        return
    }

    # Load the cache data
    try {
        $cachedData = Get-Content $cacheFile | ConvertFrom-Json -ErrorAction Stop
    }
    catch {
        Write-Warning "Cache file is corrupted or unreadable. Unable to process."
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
            Write-Warning "Classification '$classification' not found in cache. Skipping."
        }
    }

    # Save the updated cache if any classifications were removed
    if ($removedCount -gt 0) {
        $cachedData | ConvertTo-Json -Depth 2 | Set-Content -Path $cacheFile -Force
        Write-Host "Cache file updated successfully with $removedCount removals."
    }
    else {
        Write-Warning "No classifications were removed. Cache remains unchanged."
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
        Write-Warning "Cache file does not exist. No action needed."
        return
    }

    # Load the cache data
    try {
        $cachedData = Get-Content $cacheFile | ConvertFrom-Json -ErrorAction Stop
    }
    catch {
        Write-Warning "Cache file is corrupted or unreadable. Unable to process."
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
            Write-Warning "Classification '$classification' not found in cache. Skipping."
        }
    }

    # Save the updated cache if any classifications were removed
    if ($removedCount -gt 0) {
        $cachedData | ConvertTo-Json -Depth 2 | Set-Content -Path $cacheFile -Force
        Write-Host "Cache file updated successfully with $removedCount removals."
    }
    else {
        Write-Warning "No classifications were removed. Cache remains unchanged."
    }
}
