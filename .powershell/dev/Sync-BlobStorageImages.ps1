# Helpers
. ./.powershell/_includes/ImagesToBlobStorage.ps1

Write-Host "Starting process..."

# Variables
if (-not $env:LOCAL_IMAGE_PATH) {
    $env:LOCAL_IMAGE_PATH = ".\public\" # Local folder containing images and HTML files
    
}
Write-Host "Local Image Path: $env:LOCAL_IMAGE_PATH"
if (-not $env:BLOB_URL_BIT) {
    $env:BLOB_URL_BIT = "https://nkdagilityblobs.blob.core.windows.net/`$web" #"/blob"  # URL to be used for rewriting - can be full URL or "blob" for relative paths
}
Write-Host "Blob URL Bit: $env:BLOB_URL_BIT"
if (-not $env:BLOB_STORAGE_URL) {
    $env:BLOB_STORAGE_URL = "https://nkdagilityblobs.blob.core.windows.net/`$web"  # Base URL for Blob storage
}
Write-Host "Blob Storage URL: $env:BLOB_STORAGE_URL"
if (-not $env:AZURE_BLOB_STORAGE_SAS_TOKEN) {
    Write-Host "Azure Blob Storage SAS Token not provided. "
    exit 2
}

Upload-ImageFiles -LocalPath $env:LOCAL_IMAGE_PATH -BlobUrlBase $env:BLOB_STORAGE_URL -AzureSASToken $env:AZURE_BLOB_STORAGE_SAS_TOKEN

# Rewrite Links in HTML Files
Rewrite-ImageLinks -LocalPath $env:LOCAL_IMAGE_PATH -BlobUrl $env:BLOB_URL_BIT

Delete-LocalImageFiles -LocalPath $env:LOCAL_IMAGE_PATH

Write-Host "Process complete!"
