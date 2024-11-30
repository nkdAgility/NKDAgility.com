

# Function to fetch video list from YouTube API using either AccessToken or ApiKey
function Get-YoutubeChannelVideos {
    param (
        [string]$channelId,
        [string]$token, #  AccessToken 
        [int]$maxResults = 50
    )

    if (-not $token) {
        Write-Error "Token is required. Provide either an API Key or Access Token based on AuthType."
        return
    }

    Write-Host "Fetching video list for channel: $channelId using $authType"

    $searchDate = Get-Date -Format "yyyy-MM-ddTHH:mm:ss" # ISO 8601 timestamp
    $uploadsPlaylistId = $null
    $allVideosData = @()
    $nextPageToken = $null
    $page = 1

    # Step 1: Retrieve the channel's uploads playlist ID
    try {
        $channelApiUrl = "https://www.googleapis.com/youtube/v3/channels?part=snippet,contentDetails,statistics&id=$channelId"
        $headers = @{ Authorization = "Bearer $token" }
        $channelResponse = Invoke-RestMethod -Uri $channelApiUrl -Headers $headers -Method Get
        $uploadsPlaylistId = $channelResponse.items[0].contentDetails.relatedPlaylists.uploads
        Write-Host "Uploads playlist ID retrieved: $uploadsPlaylistId"
    }
    catch {
        Write-Error "Failed to fetch uploads playlist ID: $($_.Exception.Message)"
        return
    }

    # Step 2: Retrieve all videos from the uploads playlist
    do {
        try {
            $playlistApiUrl = "https://www.googleapis.com/youtube/v3/playlistItems?part=snippet,contentDetails&playlistId=$uploadsPlaylistId&maxResults=$maxResults&pageToken=$nextPageToken"
            $headers = @{ Authorization = "Bearer $token" }
        
            $playlistResponse = Invoke-RestMethod -Uri $playlistApiUrl -Headers $headers -Method Get
            Write-Host "  Parsing Page $page with $($playlistResponse.items.Count) videos"
            $allVideosData += $playlistResponse.items
            $nextPageToken = $playlistResponse.nextPageToken
            $page++
        }
        catch {
            Write-Error "Failed to fetch playlist items: $($_.Exception.Message)"
            break
        }
    } while ($nextPageToken)

    Write-Host "Retrieved $($allVideosData.Count) videos from uploads playlist."

    # Return an object containing the search date and basic video list
    return @{
        SearchDate = $searchDate
        Videos     = $allVideosData
    }
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
        [string]$videoId,
        [Parameter(Mandatory = $true)]
        [string]$token
    )
    
    # Ensure API key is defined
    if (-not $token) {
        Write-Host "token is missing.." -ForegroundColor Red
        return $null
    }

    # Ensure videoId is valid
    if (-not $videoId) {
        Write-Host "Invalid videoId provided." -ForegroundColor Red
        return $null
    }

    Write-Host "Working on Data for: $videoId" -ForegroundColor Green
    $videoDetailsUrl = "https://www.googleapis.com/youtube/v3/videos?id=$videoId&part=snippet,contentDetails,statistics,status"
    $headers = @{ Authorization = "Bearer $token" }
    try {
        $videoDetails = Invoke-RestMethod -Uri $videoDetailsUrl -Method Get -Headers $headers -ErrorAction Stop
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
        [string]$videoId,
        [Parameter(Mandatory = $true)]
        [string]$token
    )

    # Ensure API key is defined
    if (-not $token) {
        Write-Host "API Key is missing. Please set the API Key." -ForegroundColor Red
        return $null
    }

    # Ensure videoId is valid
    if (-not $videoId) {
        Write-Host "Invalid videoId provided." -ForegroundColor Red
        return $null
    }

    Write-Host "Getting caption data for: $videoId" -ForegroundColor Green
    $captionsUrl = "https://www.googleapis.com/youtube/v3/captions?videoId=$videoId&part=snippet"
    $headers = @{ Authorization = "Bearer $token" }
    try {
        # Get captions for the video
        $captionsResponse = Invoke-RestMethod -Uri $captionsUrl -Method Get -Headers $headers -ErrorAction Stop
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

# Function to get OAuth token using a refresh token
function Get-OAuthTokenFromRefreshToken {
    param (
        [string]$clientId,
        [string]$clientSecret,
        [string]$refreshToken
    )

    # Request body for token refresh
    $tokenRequestBody = @{
        client_id     = $clientId
        client_secret = $clientSecret
        refresh_token = $refreshToken
        grant_type    = "refresh_token"
    }

    # Request new access token
    $tokenResponse = Invoke-RestMethod -Uri "https://oauth2.googleapis.com/token" -Method Post -Body $tokenRequestBody -ContentType "application/x-www-form-urlencoded"
    return $tokenResponse.access_token
}


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
        [string]$token
    )

    # Specify the format as SRT by adding 'tfmt=srt' to the URL
    $downloadUrl = "https://www.googleapis.com/youtube/v3/captions/$captionId/?tfmt=srt"
    $headers = @{"Authorization" = "Bearer $token" }

    # Use Invoke-WebRequest for binary or non-JSON/XML responses
    $response = Invoke-WebRequest -Uri $downloadUrl -Headers $headers -Method Get

    return $response.Content
}

# Function to get authorization code from user
function Get-AuthorizationCode {
    param (
        [string]$clientId,
        [string]$scope,
        [string]$redirectUri
    )

    # Construct the authorization URL
    $authUrl = "https://accounts.google.com/o/oauth2/auth?client_id=$clientId&redirect_uri=$redirectUri&response_type=code&scope=$scope"
    Write-Host "Open this URL in your browser to authorize the application:"
    Write-Host $authUrl

    # Open the URL in the default browser
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

    return $authCode
}

# Function to exchange authorization code for access and refresh tokens
function Get-TokensFromAuthCode {
    param (
        [string]$clientId,
        [string]$clientSecret,
        [string]$authCode,
        [string]$redirectUri
    )

    # Request body for exchanging the authorization code for tokens
    $tokenRequestBody = @{
        code          = $authCode
        client_id     = $clientId
        client_secret = $clientSecret
        redirect_uri  = $redirectUri
        grant_type    = "authorization_code"
    }

    # Exchange the authorization code for an access token and refresh token
    $tokenResponse = Invoke-RestMethod -Uri "https://oauth2.googleapis.com/token" -Method Post -Body $tokenRequestBody -ContentType "application/x-www-form-urlencoded"
    return $tokenResponse
}


Write-Host "YoutubeAPI.ps1 loaded" -ForegroundColor Green