# Variables
$LocalImagesPath = ".\public\"  # Local folder containing images and HTML files
$BlobUrlBase = "https://nkdagilityblobs.blob.core.windows.net/`$web"  # Base URL for the blob storage
$SASToken = ""
$BlobPath = "blob"  # Path to be added for images in HTML

# Step 1: Upload .jpg files using azcopy
try {
    Write-Host "Uploading .jpg files to Azure Blob Storage using azcopy..."
    azcopy sync "$LocalImagesPath" "$BlobUrlBase$SASToken" --recursive --include-pattern "*.jpg"
    Write-Host "Upload complete."
}
catch {
    Write-Host "Error during upload: $_"
}

# Step 2: Delete all .jpg files locally
try {
    Write-Host "Deleting all .jpg files locally..."
    Get-ChildItem -Path $LocalImagesPath -Recurse -Include *.jpg | ForEach-Object {
        try {
            Remove-Item -Path $_.FullName -Force
            Write-Host "Deleted: $($_.FullName)"
        }
        catch {
            Write-Host "Error deleting file $($_.FullName): $_"
        }
    }
}
catch {
    Write-Host "Error during file deletion: $_"
}

# Step 3: Rewrite image links in .html files
try {
    Write-Host "Rewriting image links in .html files..."
    $HtmlFiles = Get-ChildItem -Path $LocalImagesPath -Recurse -Include *.html

    foreach ($HtmlFile in $HtmlFiles) {
        try {
            $FileContent = Get-Content -Path (Resolve-Path $HtmlFile.FullName) -Raw

            # Replace relative paths like "./images/file.jpg" with "./blob/images/file.jpg"
            $FileContent = $FileContent -replace "(src=['""]\./images/)", "`${1}./$BlobPath/images/"

            # Replace nested paths without "blob" (e.g., "https://nkdagility.com/folder/folder/images/file.jpg")
            $FileContent = $FileContent -replace "(src=['""]https://nkdagility.com/(.*?/images/))", "`${1}$BlobPath/`${2}"

            # Save updated content back to the file
            Set-Content -Path $HtmlFile.FullName -Value $FileContent
            Write-Host "Updated: $($HtmlFile.FullName)"
        }
        catch {
            Write-Host "Error processing file $($HtmlFile.FullName): $_"
        }
    }
    Write-Host "HTML link rewriting complete."
}
catch {
    Write-Host "Error during HTML processing: $_"
}

Write-Host "Process complete!"
