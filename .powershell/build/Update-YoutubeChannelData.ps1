# Define variables
$apiKey = $env:YOUTUBE_API_KEY
$channelId = "UCkYqhFNmhCzkefHsHS652hw"
$outputDir = "site\content\resources\videos\youtube"
$dataDirectory = ".\site\data"
$refreshData = $false

$maxResults = 800

# Create the output directory if it doesn't exist
if (-not (Test-Path $outputDir)) {
    New-Item -Path $outputDir -ItemType Directory
}

# Function to fetch video list from YouTube API and save a single youtube.json file
function Fetch-YoutubeVideoList {
    param ()

    $nextPageToken = $null
    $page = 1;
    $allVideosData = @()

    do {
        # YouTube API endpoint to get videos from a channel, including nextPageToken
        $searchApiUrl = "https://www.googleapis.com/youtube/v3/search?key=$apiKey&part=snippet&channelId=$channelId&type=video&maxResults=$maxResults&pageToken=$nextPageToken"

        # Fetch video list
        $searchResponse = Invoke-RestMethod -Uri $searchApiUrl -Method Get

        $allVideosData += $searchResponse.items

        # Get the nextPageToken to continue fetching more videos
        $nextPageToken = $searchResponse.nextPageToken
        $page++
    } while ($nextPageToken)

    # Save all video data to a single youtube.json file
    $dataFilePath = Join-Path $dataDirectory "youtube.json"
    $allVideosData | ConvertTo-Json -Depth 10 | Set-Content -Path $dataFilePath

    Write-Host "All video data saved to youtube.json."
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

# Function to iterate through youtube.json and update data.json for each video
function Update-YoutubeDataFilesFromJson {
    param ()

    $dataFilePath = Join-Path $dataDirectory "youtube.json"
    if (-not (Test-Path $dataFilePath)) {
        Write-Host "youtube.json file not found. Please run Fetch-YoutubeVideoList first."
        return
    }

    # Load video list from youtube.json
    $allVideosData = Get-Content -Path $dataFilePath | ConvertFrom-Json

    foreach ($video in $allVideosData) {
        $videoId = $video.id.videoId

        # Call the function to update the data for a single video
        Update-YoutubeDataFile -videoId $videoId
    }

    Write-Host "All video data files updated from youtube.json."
}

#Fetch-YoutubeVideoList          # Call this to fetch video list and save to youtube.json
Update-YoutubeDataFilesFromJson # Call this to update data.json files from youtube.json
