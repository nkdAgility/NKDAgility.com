# Install and import PSAuthClient from GitHub
if (-not (Get-Module -ListAvailable -Name PSAuthClient)) {
    Write-Host "Installing PSAuthClient module..."
    Install-Module -Name PSAuthClient
}
Import-Module PSAuthClient

# Canva API Credentials (Update these)
$client_id = $env:CANVA_CLIENT_ID
$client_secret = $env:CANVA_CLIENT_SECRET
$redirect_uri = "http://127.0.0.1:3001/oauth/redirect"
$scope = [System.Web.HttpUtility]::UrlEncode("design:content:read design:meta:read design:content:write asset:read asset:write brandtemplate:meta:read brandtemplate:content:read profile:read")
$authorization_endpoint = "https://api.canva.com/oauth2/authorize"
$token_endpoint = "https://api.canva.com/oauth2/token"

$brand_template_id = "EAGgqamzX28" # Replace with your actual template ID


function Get-AccessToken {
    $splat = @{
        client_id        = $client_id
        scope            = $scope
        response_type    = "code"
        redirect_uri     = $redirect_uri
        customParameters = @{ }
    }

    $code = Invoke-OAuth2AuthorizationEndpoint -uri $authorization_endpoint @splat
    $token = Invoke-OAuth2TokenEndpoint -uri $token_endpoint @code

    if ($token -and $token.access_token) {
        [System.Environment]::SetEnvironmentVariable("CANVA_ACCESS_TOKEN", $token.access_token, "User")
        Write-Host "✅ Access Token Obtained Successfully!"
        return $token.access_token
    }
    else {
        Write-Host "❌ Failed to obtain access token."
        exit 1
    }
}

# Retrieve and store the access token
$accessToken = Get-AccessToken


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
