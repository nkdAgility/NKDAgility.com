function Get-AzBlobContentAsString {
    param (
        [string]$BlobName,
        [string]$Container
    )
    $blob = Get-AzStorageBlobContent -Container $Container -Blob $BlobName -Destination "$env:TEMP\$BlobName" -Force -ErrorAction SilentlyContinue
    if (Test-Path "$env:TEMP\$BlobName") {
        return Get-Content -Raw -Path "$env:TEMP\$BlobName"
    }
    return $null
}

function Set-AzBlobContentFromString {
    param (
        [string]$BlobName,
        [string]$Container,
        [string]$Content
    )
    $tempPath = Join-Path $env:TEMP $BlobName
    $Content | Set-Content -Path $tempPath -Force
    Set-AzStorageBlobContent -Container $Container -File $tempPath -Blob $BlobName -Force | Out-Null
    Remove-Item $tempPath -Force
}

function Remove-AzBlob {
    param (
        [string]$BlobName,
        [string]$Container
    )
    Remove-AzStorageBlob -Container $Container -Blob $BlobName -Force | Out-Null
}
