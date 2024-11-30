# Helpers
. ./.powershell/_includes/YoutubeAPI.ps1

# Variables for OAuth credentials
$clientId = $env:GOOGLE_CLINET_ID          # Set your Google client ID here, or use environment variables
$clientSecret = $env:GOOGLE_CLINET_SECRET   # Set your Google client secret here, or use environment variables
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
