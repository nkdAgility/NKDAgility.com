# Define variables
$outputDir = "site\content\resources\videos\youtube"
$excludedTags = @("martin hinshelwood", "nkd agility")  # List of tags to exclude

# Function to add tags to existing markdown front matter using an ordered hash table
function Add-TagsToMarkdown {
    param (
        [string]$markdownPath,
        [pscustomobject]$videoData,
        [string[]]$excludedTags
    )

    # Load the existing content
    $content = Get-Content -Path $markdownPath -Raw

    # Extract front matter and body content
    if ($content -match '(?ms)^---\s*(.*?)---\s*(.*)$') {
        $frontMatterContent = $matches[1]
        $bodyContent = $matches[2]

        # Convert front matter content to ordered hash table
        $frontMatter = ConvertFrom-Yaml $frontMatterContent -Ordered

        # Parse the tags from video data
        $videoTags = @()
        if ($videoData.snippet.tags) {
            $videoTags = $videoData.snippet.tags | Where-Object { -not ($excludedTags -contains $_.ToLower()) }
        }

        # Add or merge tags into the front matter
        if ($frontMatter.Contains("tags")) {
            $existingTags = $frontMatter["tags"]
            $mergedTags = ($existingTags + $videoTags) | Sort-Object -Unique
            $frontMatter["tags"] = $mergedTags
        }
        else {
            $frontMatter.Add("tags", $videoTags)
        }

        # Convert the updated front matter back to YAML
        $updatedFrontMatter = ConvertTo-Yaml $frontMatter

        # Combine updated front matter and body content
        $updatedContent = "---`n$updatedFrontMatter`n---`n$bodyContent"

        # Write updated content back to file
        Set-Content -Path $markdownPath -Value $updatedContent
        Write-Host "Tags updated for file: $markdownPath"
    }
    else {
        Write-Host "Failed to parse front matter for file: $markdownPath"
    }
}

# Iterate through each video folder and update tags in markdown files
Get-ChildItem -Path $outputDir -Directory | ForEach-Object {
    $videoDir = $_.FullName
    $markdownFile = Join-Path $videoDir "index.md"
    $jsonFilePath = Join-Path $videoDir "data.json"

    if ((Test-Path $markdownFile) -and (Test-Path $jsonFilePath)) {
        # Load the video data from data.json
        $videoData = Get-Content -Path $jsonFilePath | ConvertFrom-Json

        # Update the tags in the existing markdown file
        Add-TagsToMarkdown -markdownPath $markdownFile -videoData $videoData -excludedTags $excludedTags
    }
    else {
        Write-Host "Skipping folder: $videoDir (missing index.md or data.json)"
    }
}

Write-Host "All markdown files processed."
