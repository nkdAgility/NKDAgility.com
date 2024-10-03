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

# Function to get captions for a video
function Get-YouTubeCaptions {
    param (
        [string]$videoId,
        [string]$accessToken
    )

    $captionsApiUrl = "https://www.googleapis.com/youtube/v3/captions?part=id,snippet&videoId=$videoId"
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
    $downloadUrl = "https://www.googleapis.com/youtube/v3/captions/$captionId/?tfmt=srt"
    $headers = @{"Authorization" = "Bearer $accessToken" }

    # Use Invoke-WebRequest for binary or non-JSON/XML responses
    $response = Invoke-WebRequest -Uri $downloadUrl -Headers $headers -Method Get

    # Check if the response has content
    if (-not [string]::IsNullOrEmpty($response.Content)) {
        # Save the caption content to a file
        [System.IO.File]::WriteAllBytes($outputPath, $response.Content)
        Write-Host "Caption saved to: $outputPath"
    }
    else {
        Write-Host "No caption content available for captionId: $captionId"
    }
}

# Function to loop through outputDir folders and download captions based on folder names (which are video IDs)
# It will only download the caption if the transcript file does not already exist
function Download-AllYouTubeCaptions {
    param ([string]$accessToken)

    # Get all folders in $outputDir
    $videoFolders = Get-ChildItem -Path $outputDir -Directory

    foreach ($folder in $videoFolders) {
        $videoId = $folder.Name  # The folder name is assumed to be the videoId
        Write-Host "Processing video ID: $videoId"

        $captions = Get-YouTubeCaptions -videoId $videoId -accessToken $accessToken

        foreach ($caption in $captions) {
            $captionId = $caption.id
            $language = $caption.snippet.language
           
            $outputPath = Join-Path $folder.FullName "transcript.$language.srt"
            # Check if the transcript already exists
            if (-not (Test-Path $outputPath)) {
                Write-Host "Downloading Transcript in $language for $captionId"
                Download-YouTubeCaption -captionId $captionId -accessToken $accessToken -outputPath $outputPath
            }
            else {
                Write-Host "Transcript in $language for $captionId already exists"
            }
        }

       
    }
}

# Main execution flow

# Step 1: Get OAuth token
$accessToken = Get-OAuthToken -clientId $clientId -clientSecret $clientSecret -redirectUri $redirectUri -scope $scope

# Step 2: Download captions for all videos by iterating over folder names (which represent video IDs),
# only downloading the transcript if it does not already exist
Download-AllYouTubeCaptions -accessToken $accessToken
