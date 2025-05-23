function Get-AzBlobContentAsString {
    param (
        [string]$BlobName,
        [string]$Container = $env:AZURE_BLOB_STORAGE_CONTAINER_NAME,
        [string]$StorageAccountName = $env:AZURE_STORAGE_ACCOUNT_NAME,
        [string]$SAASToken = $env:AZURE_BLOB_STORAGE_SAS_TOKEN
    )
    $Ctx = New-AzStorageContext -StorageAccountName $StorageAccountName -SasToken $SAASToken

    $blob = Get-AzStorageBlobContent -Container $Container -Blob $BlobName -Destination "$env:TEMP\_$BlobName" -Context $Ctx -Force -ErrorAction SilentlyContinue
    if (Test-Path "$env:TEMP\_$BlobName") {
        return Get-Content -Raw -Path "$env:TEMP\_$BlobName"
    }
    return $null
}

function Set-AzBlobContentFromString {
    param (
        [string]$BlobName,
        [string]$Content,
        [string]$Container = $env:AZURE_BLOB_STORAGE_CONTAINER_NAME,
        [string]$StorageAccountName = $env:AZURE_STORAGE_ACCOUNT_NAME,
        [string]$SAASToken = $env:AZURE_BLOB_STORAGE_SAS_TOKEN
    )
    $Ctx = New-AzStorageContext -StorageAccountName $StorageAccountName -SasToken $SAASToken
    $tempPath = Join-Path $env:TEMP $BlobName
    $Content | Set-Content -Path $tempPath -Force
    Set-AzStorageBlobContent -Container $Container -File $tempPath -Blob $BlobName -Context $Ctx -Force | Out-Null
    Remove-Item $tempPath -Force
}

function Remove-AzBlob {
    param (
        [string]$BlobName,
        [string]$Container = $env:AZURE_BLOB_STORAGE_CONTAINER_NAME,
        [string]$StorageAccountName = $env:AZURE_STORAGE_ACCOUNT_NAME,
        [string]$SAASToken = $env:AZURE_BLOB_STORAGE_SAS_TOKEN
    )
    $Ctx = New-AzStorageContext -StorageAccountName $StorageAccountName -SasToken $SAASToken
    Remove-AzStorageBlob -Container $Container -Blob $BlobName -Context $Ctx -Force | Out-Null
}
