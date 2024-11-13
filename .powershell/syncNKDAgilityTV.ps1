# Define variables
$apiKey = $env:google_apiKey
$channelId = "UCkYqhFNmhCzkefHsHS652hw"
$outputDir = "site\content\resources\videos\youtube"
$dataDirectory = ".\site\data"
$refreshData = $false

$maxResults = 800

# Create the output directory if it doesn't exist
if (-not (Test-Path $outputDir)) {
    New-Item -Path $outputDir -ItemType Directory
}

# Function to generate markdown files from existing data.json files
# Function to fetch video details from YouTube API and update data.json files for all videos
function Update-YoutubeDataFiles {
    param ()

    $nextPageToken = $null
    $page = 1;
    do {
        # YouTube API endpoint to get videos from a channel, including nextPageToken
        $searchApiUrl = "https://www.googleapis.com/youtube/v3/search?key=$apiKey&part=snippet&channelId=$channelId&type=video&maxResults=$maxResults&pageToken=$nextPageToken"

        # Fetch video list
        $searchResponse = Invoke-RestMethod -Uri $searchApiUrl -Method Get

        $dataFilePath = Join-Path $dataDirectory "youtube-$page.json"
        $searchResponse | ConvertTo-Json -Depth 10 | Set-Content -Path $dataFilePath

        foreach ($video in $searchResponse.items) {
            $videoId = $video.id.videoId

            # Call the new function to update the data for a single video
            Update-YoutubeDataFile -videoId $videoId -outputDir $outputDir -refreshData $refreshData
        }

        # Get the nextPageToken to continue fetching more videos
        $nextPageToken = $searchResponse.nextPageToken
        $page++
    } while ($nextPageToken)

    Write-Host "All video data files updated."
}

# Function to update data.json for a single video
function Update-YoutubeDataFile {
    param (
        [string]$videoId

    )

    # Create the directory named after the video ID
    $videoDir = Join-Path $outputDir $videoId
    if (-not (Test-Path $videoDir)) {
        New-Item -Path $videoDir -ItemType Directory
    }

    # File path for data.json
    $jsonFilePath = Join-Path $videoDir "data.json"
    if ($videoId -eq "xo4jMxupIM0") {
        Write-Host "Updating data.json for video: $videoId"
    }
    # Only update if $refreshData is true or data.json doesn't exist
    if ($refreshData -or -not (Test-Path $jsonFilePath)) {
        # Fetch full video details from YouTube API
        $videoDetailsUrl = "https://www.googleapis.com/youtube/v3/videos?key=$apiKey&id=$videoId&part=snippet,contentDetails"
        $videoDetails = Invoke-RestMethod -Uri $videoDetailsUrl -Method Get
        $videoData = $videoDetails.items[0]

        if ($videoData) {
            # Save updated video data to data.json
            $videoData | ConvertTo-Json -Depth 10 | Set-Content -Path $jsonFilePath
            Write-Host "Updated data.json for video: $videoId"
        }
        else {
            Write-Host "No data found for video: $videoId"
        }
    }
    else {
        Write-Host "Data for video $videoId is already up to date."
    }
}



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
url: /resources/videos/$urlSafeTitle
canonicalUrl: $externalUrl
preview: $thumbnailUrl
duration: $durationInSeconds
isShort: $isShort
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
                Write-Host "Markdown file for video $($videoDir) has been customised. Skipping."
                continue
            }
        }
        Write-Host "Testing needed!"
        exit # The above code needs tested!
        
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

    Write-Host "All markdown files updated."
}


Update-YoutubeDataFiles   # Call this to update data.json files from YouTube API
Update-YoutubeMarkdownFiles  # Call this to update markdown files from existing data.json files
