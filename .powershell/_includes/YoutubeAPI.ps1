
$env:GOOGLE_QUOTA_OK = $true
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

    Write-Debug "Fetching video list for channel: $channelId using $authType"

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
        Write-Debug "Uploads playlist ID retrieved: $uploadsPlaylistId"
    }
    catch {
        Write-Error "Failed to fetch uploads playlist ID: $($_.Exception.Message)"
        return
    }

    # Step 2: Retrieve all videos from the uploads playlist
    do {
        try {
            $playlistApiUrl = "https://www.googleapis.com/youtube/v3/playlistItems?part=snippet,contentDetails,status&playlistId=$uploadsPlaylistId&maxResults=$maxResults&pageToken=$nextPageToken"
            $headers = @{ Authorization = "Bearer $token" }
        
            $playlistResponse = Invoke-RestMethod -Uri $playlistApiUrl -Headers $headers -Method Get
            Write-Debug "  Parsing Page $page with $($playlistResponse.items.Count) videos"
            $allVideosData += $playlistResponse.items
            $nextPageToken = $playlistResponse.nextPageToken
            $page++
        }
        catch {
            Write-Error "Failed to fetch playlist items: $($_.Exception.Message)"
            break
        }
    } while ($nextPageToken)

    Write-Debug "Retrieved $($allVideosData.Count) videos from uploads playlist."

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
        Write-Debug "token is missing.." 
        return $null
    }

    # Ensure videoId is valid
    if (-not $videoId) {
        Write-Debug "Invalid videoId provided."
        return $null
    }

    Write-Debug "Working on Data for: $videoId"
    $videoDetailsUrl = "https://www.googleapis.com/youtube/v3/videos?id=$videoId&part=snippet,contentDetails,statistics,status"
    $headers = @{ Authorization = "Bearer $token" }
    try {
        $videoDetails = Invoke-RestMethod -Uri $videoDetailsUrl -Method Get -Headers $headers -ErrorAction Stop
        if ($null -eq $videoDetails -or $null -eq $videoDetails.items -or $videoDetails.items.Count -eq 0) {
            Write-Debug "No data found for video: $videoId" 
            return $null
        }

        $videoData = $videoDetails.items[0]

        Write-Debug "Data found for video: $videoId" 
        return $videoData
    }
    catch {
        Write-Debug "Error fetching data for video: $videoId" 
        Write-Debug $_.Exception.Message 
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
        Write-Debug "API Key is missing. Please set the API Key." 
        return $null
    }

    # Ensure videoId is valid
    if (-not $videoId) {
        Write-Debug "Invalid videoId provided."
        return $null
    }

    Write-Debug "Getting caption data for: $videoId"
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
            Write-Debug "No captions found for video: $videoId"
        }

        return $captionsData
    }
    catch {
        if ($_.ErrorDetails) {
            # Parse the error response from the error details
            $errorObject = $_.ErrorDetails | ConvertFrom-Json
            # Extract the "reason" field
            $reason = $errorObject.error.errors[0].reason
            Write-Debug "Error Reason: $reason"
            if ($reason -eq "quotaExceeded") {
                Write-Debug "Quota Exceeded. Set GOOGLE_QUOTA_OK to false to stop further requests."
                $env:GOOGLE_QUOTA_OK = $false
            }
        }
        else {
            Write-Debug "Error downloading caption: $($_.Exception.Message)" 
        }
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
    try {
        $response = Invoke-RestMethod -Uri $captionsApiUrl -Headers $headers -Method Get
        return $response.items
    }
    catch {
        if ($_.ErrorDetails) {
            # Parse the error response from the error details
            $errorObject = $_.ErrorDetails | ConvertFrom-Json
            # Extract the "reason" field
            $reason = $errorObject.error.errors[0].reason
            Write-Debug "Error Reason: $reason"
            if ($reason -eq "quotaExceeded") {
                Write-Debug "Quota Exceeded. Set GOOGLE_QUOTA_OK to false to stop further requests."
                $env:GOOGLE_QUOTA_OK = $false
            }
        }
        else {
            Write-Debug "Error downloading caption: $($_.Exception.Message)"
        }
        return $null
    }
}

# Function to download a caption file with proper ASCII and UTF-8 handling
function Get-YouTubeCaption {
    param (
        [Parameter(Mandatory = $true)]
        [string]$captionId,
        [Parameter(Mandatory = $true)]
        [string]$token
    )

    $downloadUrl = "https://www.googleapis.com/youtube/v3/captions/$captionId/?tfmt=srt"
    $headers = @{"Authorization" = "Bearer $token" }

    try {
        $response = Invoke-WebRequest -Uri $downloadUrl -Headers $headers -Method Get
        $captionContent = $response.Content

        # Convert to byte array and check encoding
        $bytes = [System.Text.Encoding]::UTF8.GetBytes($captionContent)
        $utf8Decoded = [System.Text.Encoding]::UTF8.GetString($bytes)

        # If it contains non-ASCII characters, assume it's already UTF-8
        if ($utf8Decoded -match '[^\x00-\x7F]') {
            Write-Debug "Content is UTF-8. Returning as-is." 
            return $utf8Decoded
        }

        # Otherwise, check if it's numeric ASCII-encoded content
        if ($utf8Decoded -match '^(\d+(\s\d+)*\r?\n?)+$') {
            Write-Debug "Content appears to be ASCII-encoded text. Decoding..." 
            $decodedContent = ""

            foreach ($line in $utf8Decoded -split "\s+") {
                if ($line -match '^\d+$') {
                    $decodedContent += [char][int]$line
                }
                else {
                    $decodedContent += "`n" + $line
                }
            }
            return $decodedContent
        }

        # If no encoding issue is detected, return content as is
        Write-Debug "Content is ASCII text. Returning as-is." 
        return $utf8Decoded
    }
    catch {
        if ($_.ErrorDetails) {
            $errorObject = $_.ErrorDetails | ConvertFrom-Json
            $reason = $errorObject.error.errors[0].reason
            Write-Debug "Error Reason: $reason"
            if ($reason -eq "quotaExceeded") {
                Write-Debug "Quota Exceeded. Set GOOGLE_QUOTA_OK to false to stop further requests."
                $env:GOOGLE_QUOTA_OK = $false
            }
        }
        else {
            Write-Debug "Error downloading caption: $($_.Exception.Message)"
        }
        return $null
    }
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
    Write-Debug "Open this URL in your browser to authorize the application:"
    Write-Debug $authUrl

    # Open the URL in the default browser
    Start-Process $authUrl

    # Step 2: Set up a local web server to listen for the OAuth callback
    $listener = New-Object System.Net.HttpListener
    $listener.Prefixes.Add($redirectUri + "/")
    $listener.Start()

    Write-Debug "Waiting for authorization response..."

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


Write-Debug "YoutubeAPI.ps1 loaded"