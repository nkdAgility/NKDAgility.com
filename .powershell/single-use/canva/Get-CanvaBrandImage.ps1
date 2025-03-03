# Canva API Credentials (Update these)
$client_id = $env:CANVA_CLIENT_ID
$client_secret = $env:CANVA_CLIENT_SECRET
$redirect_uri = "http://127.0.0.1:3001/oauth/redirect"
$scope = [System.Web.HttpUtility]::UrlEncode("design:content:read design:meta:read design:content:write asset:read asset:write brandtemplate:meta:read brandtemplate:content:read profile:read")

$brand_template_id = "EAGgqamzX28" # Replace with your actual template ID

############################################
# FUNCTION: Generate Authorization Code and Save to Environment Variable
############################################
function Get-AuthorizationCode {
    # Generate a random `code_verifier`
    $code_verifier = -join ((48..57) + (65..90) + (97..122) | Get-Random -Count 64 | % { [char]$_ })

    # Convert `code_verifier` to a SHA256 hashed `code_challenge`
    $code_challenge = [Convert]::ToBase64String([System.Security.Cryptography.SHA256]::Create().ComputeHash([System.Text.Encoding]::ASCII.GetBytes($code_verifier))).Replace("+", "-").Replace("/", "_").Replace("=", "")

    # Save `code_verifier` for later use in token exchange
    [System.Environment]::SetEnvironmentVariable("CANVA_CODE_VERIFIER", $code_verifier, "User")

    # Construct the authorization URL
    $auth_url = "https://api.canva.com/oauth2/authorize?client_id=$client_id&redirect_uri=$redirect_uri&response_type=code&scope=$scope&code_challenge=$code_challenge&code_challenge_method=S256"

    Write-Host "`n🚀 Open this URL in your browser and authorize the app:"
    Write-Host "$auth_url`n"

    # Prompt user to enter the authorization code manually
    $auth_code = Read-Host "🔑 Enter the authorization code after authorization"

    # Save authorization code to environment variable
    [System.Environment]::SetEnvironmentVariable("CANVA_AUTH_CODE", $auth_code, "User")

    return $auth_code
}

############################################
# FUNCTION: Exchange Authorization Code for Access Token (Handles Refresh)
############################################
function Get-AccessToken {
    $auth_code = $env:CANVA_AUTH_CODE
    $refresh_token = $env:CANVA_REFRESH_TOKEN
    $code_verifier = $env:CANVA_CODE_VERIFIER

    if ($refresh_token) {
        Write-Host "Using refresh token to get new access token..."
        $token_body = @{
            client_id     = $client_id
            client_secret = $client_secret
            refresh_token = $refresh_token
            grant_type    = "refresh_token"
        } | ConvertTo-Json -Compress
    }
    elseif ($auth_code -and $code_verifier) {
        Write-Host "Using authorization code to get access token..."
        $token_body = @{
            client_id     = $client_id
            code          = $auth_code
            redirect_uri  = $redirect_uri
            grant_type    = "authorization_code"
            code_verifier = $code_verifier
        } | ConvertTo-Json -Compress
    }
    else {
        Write-Host "No valid authorization code, code verifier, or refresh token found. Run Get-AuthorizationCode first."
        exit
    }

    $token_url = "https://api.canva.com/oauth2/token"
    $headers = @{ "Content-Type" = "application/json" }

    try {
        $response = Invoke-RestMethod -Uri $token_url -Method Post -Headers $headers -Body $token_body
        $access_token = $response.access_token
        $expires_in = $response.expires_in
        $refresh_token = $response.refresh_token

        [System.Environment]::SetEnvironmentVariable("CANVA_ACCESS_TOKEN", $access_token, "User")
        [System.Environment]::SetEnvironmentVariable("CANVA_REFRESH_TOKEN", $refresh_token, "User")

        Write-Host "Access Token Obtained Successfully (Expires in $expires_in seconds)"
        return $access_token
    }
    catch {
        Write-Host "Error obtaining access token: $_"
        if ($_.Exception.Response) {
            Write-Host "Response Code: $($_.Exception.Response.StatusCode.Value__)"
            Write-Host "Response Message: $($_.Exception.Response.StatusDescription)"
        }
        exit
    }
}

############################################
# FUNCTION: Create and Wait for Autofill Completion
############################################
function Get-CanvaAutoFill {
    param (
        [string]$access_token
    )

    $autofill_url = "https://api.canva.com/v1/designs/autofill_jobs"
    $autofill_payload = @{
        template_id   = $brand_template_id
        autofill_data = @(
            @{
                field_id = "TEXT_FIELD_ID"   # Replace with actual field ID
                value    = "PowerShell Generated Content"
            },
            @{
                field_id = "IMAGE_FIELD_ID"  # Replace with actual field ID
                value    = "https://example.com/image.jpg"  # Replace with an actual image URL
            }
        )
    } | ConvertTo-Json -Depth 10 -Compress

    $headers = @{ "Authorization" = "Bearer $access_token"; "Content-Type" = "application/json" }

    try {
        $response = Invoke-RestMethod -Uri $autofill_url -Method Post -Headers $headers -Body $autofill_payload
        $autofill_job_id = $response.job_id
        Write-Host "Autofill Job Created: $autofill_job_id"
    }
    catch {
        Write-Host "Error creating autofill job: $_"
        exit
    }

    # Wait for Autofill Completion
    $autofill_status_url = "https://api.canva.com/v1/designs/autofill_jobs/$autofill_job_id"
    do {
        Start-Sleep -Seconds 5
        $status_response = Invoke-RestMethod -Uri $autofill_status_url -Method Get -Headers $headers
        Write-Host "Autofill Status: $($status_response.status)"
    } while ($status_response.status -ne "completed")

    return $status_response.design_id
}

############################################
# FUNCTION: Create and Wait for Export Completion
############################################
function Get-CanvaDesignExport {
    param (
        [string]$access_token,
        [string]$design_id
    )

    $export_url = "https://api.canva.com/v1/designs/$design_id/exports"
    $export_payload = @{ format = "PNG" } | ConvertTo-Json -Compress

    $headers = @{ "Authorization" = "Bearer $access_token"; "Content-Type" = "application/json" }

    try {
        $response = Invoke-RestMethod -Uri $export_url -Method Post -Headers $headers -Body $export_payload
        $export_job_id = $response.job_id
        Write-Host "Export Job Created: $export_job_id"
    }
    catch {
        Write-Host "Error creating export job: $_"
        exit
    }

    # Wait for Export Completion
    $export_status_url = "https://api.canva.com/v1/designs/$design_id/exports/$export_job_id"
    do {
        Start-Sleep -Seconds 5
        $status_response = Invoke-RestMethod -Uri $export_status_url -Method Get -Headers $headers
        Write-Host "Export Status: $($status_response.status)"
    } while ($status_response.status -ne "completed")

    return $status_response.exports[0].url
}

############################################
# MAIN SCRIPT EXECUTION
############################################

# Step 1: Get Authorization Code
$auth_code = Get-AuthorizationCode

# Step 2: Get Access Token
$access_token = Get-AccessToken
Write-Host "Access Token Obtained Successfully"

# Step 3: Create and Wait for Autofill Completion
$design_id = Get-CanvaAutoFill -access_token $access_token
Write-Host "Autofill Completed, Design ID: $design_id"

# Step 4: Create and Wait for Export Completion
$export_url = Get-CanvaDesignExport -access_token $access_token -design_id $design_id
Write-Host "Export Completed, Download URL: $export_url"

# Step 5: Download the Exported File
Invoke-WebRequest -Uri $export_url -OutFile "$PWD\Canva_Export.png"
Write-Host "File downloaded successfully: $PWD\Canva_Export.png"
