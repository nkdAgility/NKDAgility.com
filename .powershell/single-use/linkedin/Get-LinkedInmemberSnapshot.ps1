function Get-LinkedInSnapshotData {
    param (
        [Parameter(Mandatory = $true)]
        [string]$Domain
    )

    # Check for token
    if (-not $Env:LINKEDIN_ACCESS_TOKEN) {
        Write-Error "Environment variable 'LINKEDIN_ACCESS_TOKEN' is not set."
        return
    }

    # Initial setup
    $baseUrl = "https://api.linkedin.com/rest/memberSnapshotData?q=criteria&domain=$Domain&count=10"
    $nextUrl = $baseUrl
    $items = @()
    $itemsCount = 0

    $headers = @{
        "Authorization"             = "Bearer $Env:LINKEDIN_ACCESS_TOKEN"
        "LinkedIn-Version"          = "202312"
        "X-Restli-Protocol-Version" = "2.0.0"
        "Accept"                    = "application/json"
    }

    do {
        Write-Host "Fetching: $nextUrl"

        try {
            $response = Invoke-RestMethod -Uri $nextUrl -Headers $headers -Method GET

            # Add snapshot data
            $items += $response.elements.snapshotData
            $itemsCount += $response.elements.snapshotData.Count

            # Find the 'next' link
            $nextLink = $response.paging.links | Where-Object { $_.rel -eq 'next' }

            $nextUrl = if ($nextLink) {
                "https://api.linkedin.com$($nextLink.href)"
            }
            else {
                $null
            }
        }
        catch {
            if ($_.Exception.Response.StatusCode.value__ -eq 404) {
                Write-Warning "LinkedIn returned 404: no further data available for domain '$Domain'."
                break
            }
            Write-Error "Failed to retrieve: $nextUrl : $_"
            break
        }

    } while ($nextUrl)

    Write-Host "Total items retrieved for domain '$Domain': $itemsCount [$($items.Count)]"

    # Ensure output directory exists
    $outputDir = ".\.data"
    if (-not (Test-Path $outputDir)) {
        New-Item -ItemType Directory -Path $outputDir | Out-Null
    }

    $outputFile = Join-Path $outputDir "linkedin-$($Domain.ToLowerInvariant())-snapshots.json"
    $items | ConvertTo-Json -Depth 10 | Out-File -Encoding UTF8 -FilePath $outputFile

    Write-Host "Saved to $outputFile"
}

Get-LinkedInSnapshotData -Domain "MEMBER_SHARE_INFO"
Get-LinkedInSnapshotData -Domain "ALL_COMMENTS"