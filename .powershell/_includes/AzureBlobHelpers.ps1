Import-Module Az.Storage

$storageContext = New-AzStorageContext -SasToken $Env:AZURE_BLOB_STORAGE_SAS_TOKEN -StorageAccountName "nkdagilityblobs"

# Azure Blob Storage Helpers
function Get-BlobContentAsJson {
    param (
        [string]$Container,
        [string]$Blob
    )
    try {
        $tempPath = Join-Path $env:TEMP ([System.IO.Path]::GetRandomFileName())
        Get-AzStorageBlobContent -Container $Container -Blob $Blob -Destination $tempPath -Context $storageContext -Force -ErrorAction Stop | Out-Null
        if (Test-Path $tempPath) {
            $content = Get-Content -Raw -Path $tempPath | ConvertFrom-Json
            Remove-Item $tempPath
            return $content
        }
    }
    catch {
        return $null
    }
    return $null
}

function Set-BlobContentAsJson {
    param (
        [string]$Container,
        [string]$Blob,
        [object]$Content
    )
    $tempPath = Join-Path $env:TEMP ([System.IO.Path]::GetRandomFileName())
    $Content | ConvertTo-Json -Depth 10 | Set-Content -Path $tempPath -Force
    Set-AzStorageBlobContent -Container $Container -Blob $Blob -File $tempPath -Context $storageContext -Force | Out-Null
    Remove-Item $tempPath
}

function Get-ContentHash {
    param (
        [Parameter(Mandatory)]
        [string]$Content
    )

    $sha256 = [System.Security.Cryptography.SHA256]::Create()
    $contentBytes = [System.Text.Encoding]::UTF8.GetBytes($Content)
    $hashBytes = $sha256.ComputeHash($contentBytes)
    return ([System.BitConverter]::ToString($hashBytes)).Replace("-", "").ToLower()
}
