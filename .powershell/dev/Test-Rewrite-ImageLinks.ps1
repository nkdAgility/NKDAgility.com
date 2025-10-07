. ./.powershell/_includes/ImagesToBlobStorage.ps1

$env:LOCAL_IMAGE_PATH = "public"
$env:BLOB_URL_BIT = "https://nkdagilityblobs.blob.core.windows.net/`$web"
$levelSwitch.MinimumLevel = 'Debug'
Rewrite-ImageLinks -LocalPath $env:LOCAL_IMAGE_PATH -BlobUrl $env:BLOB_URL_BIT