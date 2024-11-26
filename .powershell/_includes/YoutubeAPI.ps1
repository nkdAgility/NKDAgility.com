
# Function to fetch video list from YouTube API and save a single youtube.json file
function Get-YoutubePublicChannelVideos {
    param (
        [string]$channelId,
        [string]$apiKey
    )

    Write-Host "Getting Video List for $channelId"
    $nextPageToken = $null
    $page = 1;
    $allVideosData = @()

    do {
        # YouTube API endpoint to get videos from a channel, including nextPageToken
        $searchApiUrl = "https://www.googleapis.com/youtube/v3/search?key=$apiKey&part=snippet&channelId=$channelId&type=video&maxResults=$maxResults&pageToken=$nextPageToken"
        
        # Fetch video list
        $searchResponse = Invoke-RestMethod -Uri $searchApiUrl -Method Get
        Write-Host "  Parsing Page $page with $($searchResponse.items.Count) videos and etag: $($searchResponse.etag)" 
        $allVideosData += $searchResponse.items

        # Get the nextPageToken to continue fetching more videos
        $nextPageToken = $searchResponse.nextPageToken
        $page++
    } while ($nextPageToken)
    Write-Host " Found $($allVideosData.Count) videos"
    return  $allVideosData;
}

# Function to test if a file is older than a specified number of hours
function Test-FileAge {
    param (
        [Parameter(Mandatory = $true)]
        [string]$filePath,
        [Parameter(Mandatory = $true)]
        [int]$hours
    )

    if (-not (Test-Path -Path $filePath)) {
        # File doesn't exist, consider it old
        return $true
    }

    $fileInfo = Get-Item -Path $filePath
    $lastWriteTime = $fileInfo.LastWriteTime
    $timeDifference = (Get-Date) - $lastWriteTime

    return $timeDifference.TotalHours -ge $hours
}

# Function to update data.json for a single video
function Get-YoutubeVideoData {
    param (
        [Parameter(Mandatory = $true)]
        [string]$videoId
    )
    
    # Ensure API key is defined
    if (-not $apiKey) {
        Write-Host "API Key is missing. Please set the API Key." -ForegroundColor Red
        return $null
    }

    # Ensure videoId is valid
    if (-not $videoId) {
        Write-Host "Invalid videoId provided." -ForegroundColor Red
        return $null
    }

    Write-Host "Working on Data for: $videoId" -ForegroundColor Green
    $videoDetailsUrl = "https://www.googleapis.com/youtube/v3/videos?key=$apiKey&id=$videoId&part=snippet,contentDetails"

    try {
        $videoDetails = Invoke-RestMethod -Uri $videoDetailsUrl -Method Get -ErrorAction Stop
        if ($null -eq $videoDetails -or $null -eq $videoDetails.items -or $videoDetails.items.Count -eq 0) {
            Write-Host "No data found for video: $videoId" -ForegroundColor Yellow
            return $null
        }

        $videoData = $videoDetails.items[0]

        Write-Host "Data found for video: $videoId" -ForegroundColor Green
        return $videoData
    }
    catch {
        Write-Host "Error fetching data for video: $videoId" -ForegroundColor Red
        Write-Host $_.Exception.Message -ForegroundColor Red
        return $null
    }
}

# Function to get captions data for a single video
function Get-YouTubeCaptionsData {
    param (
        [Parameter(Mandatory = $true)]
        [string]$videoId
    )

    # Ensure API key is defined
    if (-not $apiKey) {
        Write-Host "API Key is missing. Please set the API Key." -ForegroundColor Red
        return $null
    }

    # Ensure videoId is valid
    if (-not $videoId) {
        Write-Host "Invalid videoId provided." -ForegroundColor Red
        return $null
    }

    Write-Host "Getting caption data for: $videoId" -ForegroundColor Green
    $captionsUrl = "https://www.googleapis.com/youtube/v3/captions?key=$apiKey&videoId=$videoId&part=snippet"

    try {
        # Get captions for the video
        $captionsResponse = Invoke-RestMethod -Uri $captionsUrl -Method Get -ErrorAction Stop
        $captionsData = @()

        if ($null -ne $captionsResponse -and $null -ne $captionsResponse.items -and $captionsResponse.items.Count -gt 0) {
            foreach ($caption in $captionsResponse.items) {
                $captionsData += @{
                    "captionId"   = $caption.id
                    "language"    = $caption.snippet.language
                    "trackKind"   = $caption.snippet.trackKind
                    "isDraft"     = $caption.snippet.isDraft
                    "status"      = $caption.snippet.status
                    "lastUpdated" = $caption.snippet.lastUpdated
                }
            }
        }
        else {
            Write-Host "No captions found for video: $videoId" -ForegroundColor Yellow
        }

        return $captionsData
    }
    catch {
        Write-Host "Error fetching captions for video: $videoId" -ForegroundColor Red
        Write-Host $_.Exception.Message -ForegroundColor Red
        return $null
    }
}


Write-Host "YoutubeAPI.ps1 loaded" -ForegroundColor Green