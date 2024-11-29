# Helpers
. ./.powershell/_includes/YoutubeAPI.ps1

Write-Host "Running v3"


# Function to get captions for a video
function Get-YouTubeCaptions {
    param (
        [Parameter(Mandatory = $true)]
        [string]$videoId,
        [string]$accessToken
    )

    $captionsApiUrl = "https://www.googleapis.com/youtube/v3/captions?part=id,snippet&videoId=$videoId"
    $headers = @{"Authorization" = "Bearer $accessToken" }

    $response = Invoke-RestMethod -Uri $captionsApiUrl -Headers $headers -Method Get
    return $response.items
}

# Function to download a caption file with a check if $captionContent is empty
function Get-YouTubeCaption {
    param (
        [Parameter(Mandatory = $true)]
        [string]$captionId,
        [Parameter(Mandatory = $true)]
        [string]$accessToken
    )

    # Specify the format as SRT by adding 'tfmt=srt' to the URL
    $downloadUrl = "https://www.googleapis.com/youtube/v3/captions/$captionId/?tfmt=srt"
    $headers = @{"Authorization" = "Bearer $accessToken" }

    # Use Invoke-WebRequest for binary or non-JSON/XML responses
    $response = Invoke-WebRequest -Uri $downloadUrl -Headers $headers -Method Get

    return $response.Content
}

# Define variables
$channelId = "UCkYqhFNmhCzkefHsHS652hw"
$outputDir = "site\content\resources\videos\youtube"
$dataDirectory = ".\site\data"
$refreshData = $false
$captionsDownloadLimit = 0
$videoUpdateLimit = 50
$captionsManafestUpdateLimit = 10
$maxYoutubeSearchResults = 1000
$maxYoutubeDataAgeHours = 1

# Create the output directory if it doesn't exist
if (-not (Test-Path $outputDir)) {
    New-Item -Path $outputDir -ItemType Directory
}


# 0. Get Youtube Video List
$dataFilePath = Join-Path $dataDirectory "youtube.json"
$fetchYoutubeChannelVideos = $false
if (Test-Path $dataFilePath) {
    # Load existing data
    $existingData = Get-Content -Path $dataFilePath | ConvertFrom-Json

    # Check SearchDate from existing data
    $lastSearchDate = Get-Date $existingData.SearchDate
    $fileAgeHours = (Get-Date) - $lastSearchDate
    if ($fileAgeHours.TotalHours -lt $maxFileAgeHours) {
        Write-Host "$dataFilePath is up to date (Last search: $lastSearchDate)." -ForegroundColor Yellow
    }
    else {
        Write-Host "$dataFilePath is outdated (Last search: $lastSearchDate)." -ForegroundColor Cyan
        $fetchYoutubeChannelVideos = $true
    }
}
else {
    Write-Host "$dataFilePath does not exist. Fetching data..." -ForegroundColor Magenta
    $fetchYoutubeChannelVideos = $true
}


if ($fetchYoutubeChannelVideos) {
    $searchResults = Get-YoutubeChannelVideos -channelId $channelId -authType AccessToken -maxResults $maxYoutubeSearchResults -token $env:GOOGLE_ACCESS_TOKEN  # Call this to fetch video list and save to youtube.json
    #$searchResults = Get-YoutubeChannelVideos -channelId $channelId -authType ApiKey -maxResults $maxYoutubeSearchResults -token $env:YOUTUBE_API_KEY
    # Save all video data to a single youtube.json file
    if ($searchResults -eq $null) {
        Write-Host "ERROR No videos found. Exiting." -ForegroundColor Red
        exit
    }
    $searchResults | ConvertTo-Json -Depth 10 | Set-Content -Path $dataFilePath
    Write-Host "$dataFilePath  saved with $($searchResults.Videos.Count) videos."  -ForegroundColor Green
}
else {
    Write-Host "$dataFilePath  is up to date."  -ForegroundColor Yellow
}


$videoUpdateCount = 0
$captionsManafestUpdateCount = 0
$captionsDownloadCount = 0
foreach ($video in $allVideosData) {
    
    Write-Host "Processing $($video.id.videoId)"  -ForegroundColor Green

    $videoId = $video.id.videoId
    # Create the directory named after the video ID
    $videoDir = Join-Path $outputDir $videoId
    if (-not (Test-Path $videoDir)) {
        New-Item -Path $videoDir -ItemType Directory
    }

    # 1. Get Youtube Video Data
    $jsonFilePathVideos = Join-Path $videoDir "data.json"
    if ($refreshData -or -not (Test-Path $jsonFilePathVideos)) {
        if ($videoUpdateCount -lt $videoUpdateLimit) {
            # Call the function to update the data for a single video
            $videoData = Get-YoutubeVideoData -videoId $videoId -apiKey $env:YOUTUBE_API_KEY
            # Save updated video data to data.json
            if ($videoData) {
                $videoData | ConvertTo-Json -Depth 10 | Set-Content -Path $jsonFilePathVideos
                Write-Host "  Updated data.json for video: $videoId"
                $videoUpdateCount++;
            }        
        }
        else {
            Write-Host "  Reached video update limit of $videoUpdateLimit. skipping."
        }       
    }

    # 2. Get Youtube Captions List
    $jsonFilePathCaptions = Join-Path $videoDir "data.captions.json"
    if ($refreshData -or -not (Test-Path $jsonFilePathCaptions)) {
        if ($captionsManafestUpdateCount -lt $captionsManafestUpdateLimit) {
            # Call the function to update the data for a single video
            $captionListData = Get-YouTubeCaptionsData -videoId $videoId -apiKey $env:YOUTUBE_API_KEY
            # Save updated video data to data.json
            if ($captionListData) {
                $captionListData | ConvertTo-Json -Depth 10 | Set-Content -Path $jsonFilePathCaptions
                Write-Host "  Updated data.captions.json for video: $videoId"
                $captionsManafestUpdateCount++;
            }        
        }
        else {
            Write-Host "  Reached capations manafest update limit of $captionsManafestUpdateLimit. skipping."
        }
       
    }

    # 3. Download Captions
    if (Test-Path $jsonFilePathCaptions) {
        $captionsData = Get-Content -Path $jsonFilePathCaptions | ConvertFrom-Json
        foreach ($caption in $captionsData) {
            $captionId = $caption.captionId
            $language = $caption.language
            $captionsFileName = "data.captions.$language.srt"
            $captionFilePath = Join-Path $videoDir $captionsFileName
            if (-not (Test-Path $captionFilePath)) {
                if ($captionsDownloadCount -lt $captionsDownloadLimit) {
                    $captionData = Get-YouTubeCaption -captionId $captionId -accessToken $env:GOOGLE_ACCESS_TOKEN
                    $captionData | Set-Content -Path $captionFilePath
                    Write-Host "  Updated $captionsFileName for video: $videoId"
                    $captionsDownloadCount++
                }
                else {
                    Write-Host "  Reached capations download limit of $captionsDownloadLimit. skipping."
                }
               
            }
        }

    }
    else {
        Write-Host "  No caption list data manafest. skipping."
    }
}




# Update-YoutubeDataFilesFromJson # Call this to update data.json files from youtube.json

#   # Set a limit for the number of transcripts to download

# Download-AllYouTubeCaptions -accessToken $env:GOOGLE_ACCESS_TOKEN