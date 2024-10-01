# Variables for OAuth credentials
$clientId = $env:google_clientId
$clientSecret = $env:google_clientSecret
$redirectUri = "http://localhost:8080"
$scope = "https://www.googleapis.com/auth/youtube.readonly https://www.googleapis.com/auth/youtube.force-ssl"
$channelId = "UCkYqhFNmhCzkefHsHS652hw"
$outputDir = "site\content\resources\videos\youtube"
$maxResults = 1  # Limit the number of results per API call (page)
$totalResultsLimit = 1  # Set a limit on the total number of results fetched

# Function to get OAuth access token
function Get-OAuthToken {
    param (
        [string]$clientId,
        [string]$clientSecret,
        [string]$redirectUri,
        [string]$scope
    )

    # Step 1: Get authorization code
    $authUrl = "https://accounts.google.com/o/oauth2/auth?client_id=$clientId&redirect_uri=$redirectUri&response_type=code&scope=$scope"
    Write-Host "Open this URL in your browser to authorize the application:"
    Write-Host $authUrl
    Start-Process $authUrl

    # Step 2: Set up a local web server to listen for the OAuth callback
    $listener = New-Object System.Net.HttpListener
    $listener.Prefixes.Add($redirectUri + "/")
    $listener.Start()

    Write-Host "Waiting for authorization response..."

    # Step 3: Wait for the OAuth response and extract the authorization code
    $context = $listener.GetContext()
    $response = $context.Response
    $authCode = ($context.Request.Url.Query -split 'code=')[1] -split '&'[0]

    # Send a response to the browser
    $responseString = "<html><body>Authorization successful. You can close this tab now.</body></html>"
    $buffer = [System.Text.Encoding]::UTF8.GetBytes($responseString)
    $response.ContentLength64 = $buffer.Length
    $response.OutputStream.Write($buffer, 0, $buffer.Length)
    $response.OutputStream.Close()
    $listener.Stop()

    # Step 4: Exchange the authorization code for an access token
    $tokenRequestBody = @{
        code          = $authCode[0]
        client_id     = $clientId
        client_secret = $clientSecret
        redirect_uri  = $redirectUri
        grant_type    = "authorization_code"
    }

    $tokenResponse = Invoke-RestMethod -Uri "https://oauth2.googleapis.com/token" -Method Post -Body $tokenRequestBody
    return $tokenResponse.access_token
}

# Function to get list of videos from your YouTube channel with total results limit
function Get-YouTubeVideos {
    param (
        [string]$accessToken,
        [int]$maxResults = 50,
        [int]$totalResultsLimit
    )

    $videos = @()
    $nextPageToken = $null
    $totalResultsFetched = 0  # Track the total number of results fetched

    do {
        # If the total number of fetched results will exceed the limit, adjust maxResults
        if (($totalResultsLimit - $totalResultsFetched) -lt $maxResults) {
            $maxResults = $totalResultsLimit - $totalResultsFetched
        }

        $videosApiUrl = "https://www.googleapis.com/youtube/v3/search?part=snippet&channelId=$channelId&type=video&maxResults=$maxResults&pageToken=$nextPageToken"
        $headers = @{"Authorization" = "Bearer $accessToken" }

        $response = Invoke-RestMethod -Uri $videosApiUrl -Headers $headers -Method Get
        $videos += $response.items
        $totalResultsFetched += $response.items.Count
        $nextPageToken = $response.nextPageToken

        # Stop fetching if we've reached the total results limit
        if ($totalResultsFetched -ge $totalResultsLimit) {
            break
        }
    } while ($nextPageToken -and $totalResultsFetched -lt $totalResultsLimit)

    return $videos
}

# Function to get captions for a video
function Get-YouTubeCaptions {
    param (
        [string]$videoId,
        [string]$accessToken
    )

    $captionsApiUrl = "https://www.googleapis.com/youtube/v3/captions?part=snippet&videoId=$videoId"
    $headers = @{"Authorization" = "Bearer $accessToken" }

    $response = Invoke-RestMethod -Uri $captionsApiUrl -Headers $headers -Method Get
    return $response.items
}

# Function to download a caption file with a check if $captionContent is empty
function Download-YouTubeCaption {
    param (
        [string]$captionId,
        [string]$accessToken,
        [string]$outputPath
    )

    # Specify the format as SRT by adding 'tfmt=srt' to the URL
    $downloadUrl = "https://www.googleapis.com/youtube/v3/captions/$captionId?tfmt=srt"
    $headers = @{"Authorization" = "Bearer $accessToken" }

    $captionContent = Invoke-RestMethod -Uri $downloadUrl -Headers $headers -Method Get

    # Check if $captionContent is empty
    if (-not [string]::IsNullOrEmpty($captionContent)) {
        Set-Content -Path $outputPath -Value $captionContent
        Write-Host "Caption saved to: $outputPath"
    }
    else {
        Write-Host "No caption content available for captionId: $captionId"
    }
}

# Function to iterate through videos and download captions
function Download-AllYouTubeCaptions {
    param ([string]$accessToken)

    # Get list of videos with the total results limit
    $videos = Get-YouTubeVideos -accessToken $accessToken -maxResults $maxResults -totalResultsLimit $totalResultsLimit
    foreach ($video in $videos) {
        $videoId = $video.id.videoId
        $title = $video.snippet.title
        Write-Host "Processing video: $title"

        # Create a folder for the video using its ID
        $videoFolder = Join-Path $outputDir $videoId
        if (-not (Test-Path $videoFolder)) {
            New-Item -Path $videoFolder -ItemType Directory
        }

        # Get captions for the video
        $captions = Get-YouTubeCaptions -videoId $videoId -accessToken $accessToken

        if ($captions.Count -gt 0) {
            $captionId = $captions[0].id
            $outputPath = Join-Path $videoFolder "transcript.srt"

            # Download the caption
            Download-YouTubeCaption -captionId $captionId -accessToken $accessToken -outputPath $outputPath
        }
        else {
            Write-Host "No captions available for video: $title"
        }
    }
}

# Main execution flow

# Step 1: Get OAuth token
$accessToken = Get-OAuthToken -clientId $clientId -clientSecret $clientSecret -redirectUri $redirectUri -scope $scope

# Step 2: Download captions for all videos (as before)
Download-AllYouTubeCaptions -accessToken $accessToken
