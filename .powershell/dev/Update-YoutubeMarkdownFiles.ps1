# Define variables
$outputDir = "site\content\resources\videos\youtube"
$excludedTags = @("martin hinshelwood", "nkd agility")  # List of tags to exclude

# Function to generate markdown content for a video
function Get-NewMarkdownContents {
    param (
        [pscustomobject]$videoData,
        [string]$videoId,
        [string[]]$excludedTags
    )

    $videoSnippet = $videoData.snippet
    $fullDescription = $videoSnippet.description
    $durationISO = $videoData.contentDetails.duration

    # Convert duration to seconds
    $timeSpan = [System.Xml.XmlConvert]::ToTimeSpan($durationISO)
    $durationInSeconds = $timeSpan.TotalSeconds

    # Check if the video is a short (60 seconds or less)
    $isShort = $durationInSeconds -le 60

    # Get the highest resolution thumbnail
    $thumbnails = $videoSnippet.thumbnails
    $thumbnailUrl = $thumbnails.maxres.url
    if (-not $thumbnailUrl) {
        $thumbnailUrl = $thumbnails.high.url  # Fallback to high resolution
    }

    # Format the title to be URL-safe and remove invalid characters
    $title = $videoSnippet.title -replace '[#"]', ' ' -replace ':', ' - ' -replace '\s+', ' '  # Ensure only one space in a row
    $publishedAt = Get-Date $videoSnippet.publishedAt -Format "yyyy-MM-ddTHH:mm:ssZ"
    $urlSafeTitle = ($title -replace '[:\/\\*?"<>|#%.]', '-' -replace '\s+', '-').ToLower()

    # Remove consecutive dashes
    $urlSafeTitle = $urlSafeTitle -replace '-+', '-'

    # Create the external URL for the original video
    $externalUrl = "https://www.youtube.com/watch?v=$videoId"

    # Get the tags from the snippet and filter out excluded tags
    $tags = @()
    if ($videoSnippet.tags) {
        $tags = $videoSnippet.tags | Where-Object { -not ($excludedTags -contains $_.ToLower()) }
    }
    $tagsString = $tags -join ", "

    # Return the markdown content without etag and with properly formatted title
    return @"
---
title: "$title"
date: $publishedAt
videoId: $videoId
url: /resources/videos/:slug
slug: $urlSafeTitle
canonicalUrl: $externalUrl
aliases:
 - /resources/videos/$videoId
# - /resources/videos/$urlSafeTitle
preview: $thumbnailUrl
duration: $durationInSeconds
isShort: $isShort
tags: [$tagsString]
sitemap:
  filename: sitemap.xml
  priority: 0.4
---

{{< youtube $videoId >}}

# $title

$fullDescription

[Watch on YouTube]($externalUrl)
"@
}

# Function to generate markdown files from existing data.json files
function Update-YoutubeMarkdownFiles {
    param ()

    # Iterate through each video folder
    Get-ChildItem -Path $outputDir -Directory | ForEach-Object {
        $videoDir = $_.FullName
        $markdownFile = Join-Path $videoDir "index.md"
        $jsonFilePath = Join-Path $videoDir "data.json"

        # Check if index.md exists and if it contains 'canonicalUrl'
        $shouldUpdate = $false
        if (-not (Test-Path $markdownFile)) {
            # If index.md does not exist, we should create it
            $shouldUpdate = $true
        }
        elseif ((Test-Path $markdownFile) -and (Get-Content -Path $markdownFile -Raw) -match 'canonicalUrl:') {
            # If index.md exists and contains 'canonicalUrl', we should update it
            $shouldUpdate = $true
        }
        else {
            Write-Host "Markdown file for video $($videoDir) has been customised. Skipping."
        }

        # Proceed to update or create the markdown file if necessary
        if ($shouldUpdate -and (Test-Path $jsonFilePath)) {
            # Load the video data from data.json
            $videoData = Get-Content -Path $jsonFilePath | ConvertFrom-Json
            $videoId = $videoData.id

            # Generate markdown content
            $markdownContent = Get-NewMarkdownContents -videoData $videoData -videoId $videoId -excludedTags $excludedTags

            # Write the markdown content to index.md
            Set-Content -Path $markdownFile -Value $markdownContent
            Write-Host "Markdown created or updated for video: $($videoData.snippet.title)"
        }
    }

    Write-Host "All markdown files processed."
}

Update-YoutubeMarkdownFiles  # Call this to update markdown files from existing data.json files
