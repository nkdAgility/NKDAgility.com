# Define variables
$outputDir = "site\content\resources\videos\youtube"

# Function to generate markdown content for a video
function Get-NewMarkdownContents {
    param (
        [pscustomobject]$videoData,
        [string]$videoId
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
        if (Test-Path $markdownFile) {
            $content = Get-Content -Path $markdownFile
            if ($content -match 'canonicalUrl:') {
  
                $jsonFilePath = Join-Path $videoDir "data.json"

                if (Test-Path $jsonFilePath) {
                    # Load the video data from data.json
                    $videoData = Get-Content -Path $jsonFilePath | ConvertFrom-Json
                    $videoId = $videoData.id
        
                    # Generate markdown content
                    $markdownContent = Get-NewMarkdownContents -videoData $videoData -videoId $videoId
        
                    # Markdown file path inside the video ID folder
                    $filePath = Join-Path $videoDir "index.md"
        
                    # Write the markdown content
                    Set-Content -Path $filePath -Value $markdownContent
                    Write-Host "Markdown created for video: $($videoData.snippet.title)"
                }

            }
            else {
                Write-Host "Markdown file for video $($videoDir) has been customised. Skipping."
            }
        }
       
      
    }

    Write-Host "All markdown files updated."
}

Update-YoutubeMarkdownFiles  # Call this to update markdown files from existing data.json files
