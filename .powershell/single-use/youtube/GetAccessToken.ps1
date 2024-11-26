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

# Variables for OAuth credentials
$clientId = $env:google_clientId           # Set your Google client ID here, or use environment variables
$clientSecret = $env:google_clientSecret   # Set your Google client secret here, or use environment variables
$scope = "https://www.googleapis.com/auth/youtube.readonly https://www.googleapis.com/auth/youtube.force-ssl"
$redirectUri = "http://localhost:8080"

# Step 1: Get authorization code from user (one-time process)
$authCode = Get-AuthorizationCode -clientId $clientId -scope $scope -redirectUri $redirectUri

# Step 2: Exchange authorization code for tokens
$tokens = Get-TokensFromAuthCode -clientId $clientId -clientSecret $clientSecret -authCode $authCode -redirectUri $redirectUri

# Output the tokens
Write-Host "Access Token: $($tokens.access_token)"
Write-Host "Refresh Token: $($tokens.refresh_token)"

# Save the refresh token for future use
$refreshToken = $tokens.refresh_token

# Step 3: Get OAuth token using refresh token (subsequent use)
$accessToken = Get-OAuthTokenFromRefreshToken -clientId $clientId -clientSecret $clientSecret -refreshToken $refreshToken

# Output the access token
Write-Host "Access Token for unattended use: $accessToken"
