# Define variables
$apiKey = $env:google_apiKey
$channelId = "UCkYqhFNmhCzkefHsHS652hw"
$outputDir = "site\content\resources\videos"

$maxResults = 50

# Create the output directory if it doesn't exist
if (-not (Test-Path $outputDir)) {
    New-Item -Path $outputDir -ItemType Directory
}

# Function to fetch video details from YouTube API and update data.json files
function Update-YoutubeDataFiles {
    param ()

    $nextPageToken = $null

    do {
        # YouTube API endpoint to get videos from a channel, including nextPageToken
        $searchApiUrl = "https://www.googleapis.com/youtube/v3/search?key=$apiKey&channelId=$channelId&type=video&maxResults=$maxResults&pageToken=$nextPageToken"

        # Fetch video list
        $searchResponse = Invoke-RestMethod -Uri $searchApiUrl -Method Get

        foreach ($video in $searchResponse.items) {
            $videoId = $video.id.videoId
            $etag = $video.etag

            # Create the directory named after the video ID
            $videoDir = Join-Path $outputDir $videoId
            if (-not (Test-Path $videoDir)) {
                New-Item -Path $videoDir -ItemType Directory
            }

            # File path for data.json
            $jsonFilePath = Join-Path $videoDir "data.json"

            # Fetch full video details from YouTube API
            $videoDetailsUrl = "https://www.googleapis.com/youtube/v3/videos?key=$apiKey&id=$videoId&part=snippet,contentDetails"
            $videoDetails = Invoke-RestMethod -Uri $videoDetailsUrl -Method Get
            $videoData = $videoDetails.items[0]

            # Save updated video data to data.json
            $videoData | ConvertTo-Json -Depth 10 | Set-Content -Path $jsonFilePath
            Write-Host "Updated data.json for video: $videoId"
        }

        # Get the nextPageToken to continue fetching more videos
        $nextPageToken = $searchResponse.nextPageToken

    } while ($nextPageToken)

    Write-Host "All video data files updated."
}

# Function to generate markdown files from existing data.json files
function Update-YoutubeMarkdownFiles {
    param ()

    # Iterate through each video folder
    Get-ChildItem -Path $outputDir -Directory | ForEach-Object {
        $videoDir = $_.FullName
        $jsonFilePath = Join-Path $videoDir "data.json"

        if (Test-Path $jsonFilePath) {
            # Load the video data from data.json
            $videoData = Get-Content -Path $jsonFilePath | ConvertFrom-Json
            $videoId = $videoData.id
            $etag = $videoData.etag

            # Generate markdown content
            $markdownContent = Get-NewMarkdownContents -videoData $videoData -videoId $videoId -etag $etag

            # Markdown file path inside the video ID folder
            $filePath = Join-Path $videoDir "index.md"

            # Write the markdown content
            Set-Content -Path $filePath -Value $markdownContent
            Write-Host "Markdown created for video: $($videoData.snippet.title)"
        }
    }

    Write-Host "All markdown files updated."
}

# Function to generate markdown content for a video
function Get-NewMarkdownContents {
    param (
        [pscustomobject]$videoData,
        [string]$videoId,
        [string]$etag
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

    # Format the title to be URL-safe and remove invalid characters like ':', '/', etc.
    $title = $videoSnippet.title
    $publishedAt = $videoSnippet.publishedAt
    $urlSafeTitle = ($title -replace '[:\/\\*?"<>|]', '-' -replace '\s+', '-').ToLower()

    # Create the external URL for the original video
    $externalUrl = "https://www.youtube.com/watch?v=$videoId"

    # Return the markdown content
    return @"
---
title: "$title"
date: $publishedAt
videoId: $videoId
url: /resources/videos/$urlSafeTitle
external_url: $externalUrl
coverImage: $thumbnailUrl
duration: $durationInSeconds
isShort: $isShort
---

# $title

$fullDescription

[Watch on YouTube]($externalUrl)
"@
}

# Main calls
#Update-YoutubeDataFiles   # Call this to update data.json files from YouTube API
Update-YoutubeMarkdownFiles  # Call this to update markdown files from existing data.json files
