. ./.powershell/_includes/OpenAI.ps1

function Get-MarkdownMetadata {
    param (
        [string]$FolderPath
    )

    $mdFiles = Get-ChildItem -Path $FolderPath -Filter "*.md" -File
    $metadataList = @()

    foreach ($markdownFile in $mdFiles) {
        # Load Markdown data using Get-HugoMarkdown
        $hugoMarkdown = Get-HugoMarkdown -Path $markdownFile.FullName
        
        # Extract title and description if available
        $title = $hugoMarkdown.FrontMatter.title
        $description = $hugoMarkdown.FrontMatter.description

        # Fallback if title or description is missing
        if (-not $title -or $title -eq '') {
            $title = "Untitled"
        }
        if (-not $description -or $description -eq '') {
            $description = "No description available"
        }

        # Create a structured object
        $metadataList += [PSCustomObject]@{
            Title       = $title
            Description = $description
        }
    }

    return $metadataList | ConvertTo-Json -Depth 1
}

function Get-CategoryConfidenceWithChecksum {
    param (
        [string]$ResourceContent,
        [string]$ResourceTitle,
        [hashtable]$Catalog,
        [string]$CacheFolder,
        [int]$MinConfidence = 50,
        [int]$MaxCategories = 5
    )

    if (!(Test-Path $CacheFolder)) {
        New-Item -ItemType Directory -Path $CacheFolder -Force | Out-Null
    }

    $cacheFile = Join-Path $CacheFolder "data.index.categories.json"

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

    foreach ($category in $Catalog.Keys) {
        if ($cachedData.PSObject.Properties[$category]) {
            $categoryScores[$category] = $cachedData.$category
            continue
        }

        $prompt = @"
You are an AI expert in content classification. Evaluate how well the given content aligns with the category **"$category"**.

### **Instructions:**
1. **Assess relevance** (Strong, Moderate, Weak).
2. **Score confidence (0-100):**
   - **80-100:** Primary Category (Strong match)
   - **50-79:** Secondary Category (Moderate match)
   - **Below 50:** Ignore
3. **Provide a short reasoning**.

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

    $sortedCategories = $categoryScores.Values | Sort-Object final_score -Descending | Select-Object -First $MaxCategories

    return $sortedCategories | ConvertTo-Json -Depth 1
}



$classification = "categories"
# Test Data
$catalog = Get-MarkdownMetadata -FolderPath "site\content\$classification" | ConvertFrom-Json 
# Convert object to a hashtable
$catalogHash = @{}
# Loop through each object and store the Title-Description pair in the hashtable
foreach ($item in $catalog) {
    if ($item.Title -and $item.Description) {
        $catalogHash[$item.Title] = $item.Description
    }
}


$hugoMarkdown = Get-HugoMarkdown -Path "site\content\resources\blog\2006\2006-06-22-ahaaaa\index.md"
$cacheFolder = "site\content\resources\blog\2006\2006-06-22-ahaaaa\"

$class = Get-CategoryConfidenceWithChecksum -ClassificationType "$classification" -Catalog $catalogHash -CacheFolder $cacheFolder -ResourceContent $hugoMarkdown.BodyContent -ResourceTitle $hugoMarkdown.FrontMatter.title