

function New-ResourceId {
    param (
        [int]$Length = 11  # Default length of YouTube-style ID
    )

    # Define YouTube-style character set (Base64-like but URL-friendly)
    $charSet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_"

    # Generate a random ID
    $resourceId = -join ((1..$Length) | ForEach-Object { $charSet[(Get-Random -Minimum 0 -Maximum $charSet.Length)] })

    return $resourceId
}

function Get-ResourceType {
    param (
        [string]$FilePath
    )

    # Define regex pattern to match resource type
    $pattern = '\\content\\resources\\(?<ResourceType>[^\\]+)\\'

    # Run regex match
    if ($FilePath -match $pattern) {
        return $matches['ResourceType']
    }
    else {
        Write-Host "No match found." -ForegroundColor Red
        return $null
    }
}


Write-Host "ResourceHelpers.ps1 loaded" -ForegroundColor Green
