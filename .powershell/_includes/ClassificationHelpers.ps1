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
            Write-Host "Warning: Cache file corrupted. Resetting cache."
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
You are an AI expert in content classification. Evaluate how well the given content aligns with the category **"$category"**.

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

    $sortedCategories = $categoryScores.Values | Where-Object { $_.Level -ne "Ignored" } | Sort-Object final_score -Descending | Select-Object -First $MaxCategories

    return $sortedCategories | ConvertTo-Json -Depth 1
}



# $hugoMarkdown = Get-HugoMarkdown -Path "site\content\resources\blog\2006\2006-06-22-ahaaaa\index.md"
# $cacheFolder = "site\content\resources\blog\2006\2006-06-22-ahaaaa\"

# $classification = "tags"
# $catalogHash = Get-CatalogHashtable -Classification $classification
# $class = Get-CategoryConfidenceWithChecksum -ClassificationType "$classification" -Catalog $catalogHash -CacheFolder $cacheFolder -ResourceContent $hugoMarkdown.BodyContent -ResourceTitle $hugoMarkdown.FrontMatter.title


# $class.Count
# $class