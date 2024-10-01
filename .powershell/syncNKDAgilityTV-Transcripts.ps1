# Variables for OAuth credentials
$clientId = $env:google_clientId
$clientSecret = $env:google_clientSecret
$redirectUri = "http://localhost:8080"
$scope = "https://www.googleapis.com/auth/youtube.force-ssl"

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

# Function to get list of videos from your YouTube channel
function Get-YouTubeVideos {
    param (
        [string]$accessToken,
        [int]$maxResults = 50
    )

    $videos = @()
    $nextPageToken = $null

    do {
        $videosApiUrl = "https://www.googleapis.com/youtube/v3/search?part=snippet&mine=true&maxResults=$maxResults&type=video&pageToken=$nextPageToken"
        $headers = @{
            "Authorization" = "Bearer $accessToken"
        }

        $response = Invoke-RestMethod -Uri $videosApiUrl -Headers $headers -Method Get
        $videos += $response.items
        $nextPageToken = $response.nextPageToken
    } while ($nextPageToken)

    return $videos
}

# Function to get captions for a video
function Get-YouTubeCaptions {
    param (
        [string]$videoId,
        [string]$accessToken
    )

    $captionsApiUrl = "https://www.googleapis.com/youtube/v3/captions?part=snippet&videoId=$videoId"
    $headers = @{
        "Authorization" = "Bearer $accessToken"
    }

    $response = Invoke-RestMethod -Uri $captionsApiUrl -Headers $headers -Method Get
    return $response.items
}

# Function to download a caption file
function Download-YouTubeCaption {
    param (
        [string]$captionId,
        [string]$accessToken,
        [string]$outputPath
    )

    $downloadUrl = "https://www.googleapis.com/youtube/v3/captions/$captionId"
    $headers = @{
        "Authorization" = "Bearer $accessToken"
    }

    $captionContent = Invoke-RestMethod -Uri $downloadUrl -Headers $headers -Method Get
    Set-Content -Path $outputPath -Value $captionContent
    Write-Host "Caption saved to: $outputPath"
}

# Function to iterate through videos and download captions
function Download-AllYouTubeCaptions {
    param (
        [string]$accessToken
    )

    # Output directory for captions
    $outputDir = "youtube_captions"
    if (-not (Test-Path $outputDir)) {
        New-Item -Path $outputDir -ItemType Directory
    }

    # Get list of videos
    $videos = Get-YouTubeVideos -accessToken $accessToken
    foreach ($video in $videos) {
        $videoId = $video.id.videoId
        $title = $video.snippet.title
        Write-Host "Processing video: $title"

        # Get captions for the video
        $captions = Get-YouTubeCaptions -videoId $videoId -accessToken $accessToken

        if ($captions.Count -gt 0) {
            $captionId = $captions[0].id
            $outputPath = Join-Path $outputDir "$videoId.srt"

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
