# Helpers
. ./.powershell/_includes/YoutubeAPI.ps1

Write-Host "Running v4"

# Define variables
$channelId = "UCkYqhFNmhCzkefHsHS652hw"
$outputDir = "site\content\resources\videos\youtube"
$dataDirectory = ".\site\data"
$refreshData = $false

$videoUpdateLimit = 50
$maxYoutubeSearchResults = 1000
$maxYoutubeDataAgeHours = 8

$captionsManafestUpdateLimit = 50
$captionsDownloadLimit = 25

$accessToken = Get-OAuthTokenFromRefreshToken -clientId $env:GOOGLE_CLINET_ID -clientSecret $env:GOOGLE_CLINET_SECRET -refreshToken $env:GOOGLE_REFRESH_TOKEN

if (-not $accessToken) {
    Write-Host "ERROR: Access token not found. Exiting." -ForegroundColor Red
    exit 1
}

# Create the output directory if it doesn't exist
if (-not (Test-Path $outputDir)) {
    New-Item -Path $outputDir -ItemType Directory
}


# 0. Get Youtube Video List
$dataFilePath = Join-Path $dataDirectory "youtube.json"
$fetchYoutubeChannelVideos = $false
$videoData = $null
if (Test-Path $dataFilePath) {
    # Load existing data
    $videoData = Get-Content -Path $dataFilePath | ConvertFrom-Json

    # Check SearchDate from existing data
    $lastSearchDate = Get-Date $videoData.SearchDate
    $fileAgeHours = (Get-Date) - $lastSearchDate
    if ($fileAgeHours.TotalHours -lt $maxYoutubeDataAgeHours) {
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
    $videoData = Get-YoutubeChannelVideos -channelId $channelId -authType AccessToken -maxResults $maxYoutubeSearchResults -token $accessToken
    # Save all video data to a single youtube.json file
    if ($videoData -eq $null) {
        Write-Host "ERROR No videos found. Exiting." -ForegroundColor Red
        exit
    }
    $videoData | ConvertTo-Json -Depth 10 | Set-Content -Path $dataFilePath
    Write-Host "$dataFilePath  saved with $($videoData.Videos.Count) videos."  -ForegroundColor Green
}
else {
    Write-Host "$dataFilePath  is up to date."  -ForegroundColor Yellow
}


$videoUpdateCount = 0
$captionsManafestUpdateCount = 0
$captionsDownloadCount = 0
foreach ($video in $videoData.Videos) {
    
    Write-Host "Processing $($video.contentDetails.videoId)"  -ForegroundColor Green

    if ($env:GOOGLE_QUOTA_OK -eq $false) {
        Write-Host "  No Quota: Skipping" -ForegroundColor Yellow
        continue;
    }
   

    $videoId = $video.contentDetails.videoId
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
            $videoData = Get-YoutubeVideoData -videoId $videoId -token $accessToken
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
            $captionListData = Get-YouTubeCaptionsData -videoId $videoId -token $accessToken
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
                    $captionData = Get-YouTubeCaption -captionId $captionId -token $accessToken
                    if ($captionData) {
                        $captionData | Set-Content -Path $captionFilePath
                        Write-Host "  Updated $captionsFileName for video: $videoId"
                        $captionsDownloadCount++
                    }
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
