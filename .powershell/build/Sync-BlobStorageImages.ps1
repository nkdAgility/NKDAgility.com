# Variables
$LocalImagesPath = ".\public\"  # Local folder containing images and HTML files
$BlobUrl = "blob"  # URL to be used for rewriting - can be full URL or "blob" for relative paths
$BlobUrlBase = "https://nkdagilityblobs.blob.core.windows.net/`$web"  # Base URL for Blob storage
$LocalDebug = $true

# Method 1: Upload image files using azcopy
function Upload-ImageFiles {
    param (
        [Parameter(Mandatory = $true)]
        [string]$BlobUrlBase,
        [Parameter(Mandatory = $true)]
        [string]$LocalPath,
        [Parameter(Mandatory = $true)]
        [string]$AzureSASToken
    )
    try {
        Write-Host "Uploading image files to Azure Blob Storage using azcopy..."
        azcopy sync $LocalPath "$BlobUrlBase`?$AzureSASToken" --recursive=true --include-pattern "*.jpg;*.jpeg;*.png;*.gif;*.webp" --overwrite=false
        Write-Host "Upload complete."
    }
    catch {
        Write-Host "Error during upload: $_"
    }
}

# Method 2: Delete all image files locally
function Delete-LocalImageFiles {
    param (
        [string]$LocalPath
    )
    try {
        Write-Host "Deleting all image files locally..."
        Get-ChildItem -Path $LocalPath -Recurse -Include *.jpg, *.jpeg, *.png, *.gif, *.webp | ForEach-Object {
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
}

# Method 3: Rewrite image links in .html files using regex
function Rewrite-ImageLinks {
    param (
        [string]$LocalPath,
        [string]$BlobUrl
    )
    try {
        Write-Host "Rewriting image links in .html files using regex..."

        $HtmlFiles = Get-ChildItem -Path $LocalPath -Recurse -Include *.html

        foreach ($HtmlFile in $HtmlFiles) {
            try {
                $FileContent = Get-Content -Path (Resolve-Path $HtmlFile.FullName) -Raw

                # Regex to match all src attributes with image paths
                $ImageRegex = 'src=["'']([^"'']*\.(jpg|jpeg|png|gif|webp))["'']'
                # Find all matches
                $Matches = [regex]::Matches($FileContent, $ImageRegex)

                foreach ($Match in $Matches) {
                    $OriginalPath = $Match.Groups[1].Value
                    $UpdatedPath = $OriginalPath

                    # Skip if the path already contains the BlobUrl
                    if ($OriginalPath -match "^$BlobUrl") {
                        continue
                    }

                    # Handle all paths using $BlobUrl
                    if ($OriginalPath.StartsWith("https://") -or $OriginalPath.StartsWith("http://")) {
                        # Replace existing domains
                        $UpdatedPath = "$BlobUrl/" + $OriginalPath.Split('/')[3..-1] -join '/'
                    }
                    elseif ($OriginalPath.StartsWith("/")) {
                        # Absolute paths
                        $UpdatedPath = "$BlobUrl" + $OriginalPath
                    }
                    else {
                        # Relative paths - Ensure consistency by converting to root-relative
                        $RootRelativePath = (Resolve-Path -Path (Join-Path -Path (Split-Path -Path $HtmlFile.FullName -Parent) -ChildPath $OriginalPath)).Replace((Get-Item $LocalImagesPath).FullName, "").Replace("\", "/")
                        $UpdatedPath = "$BlobUrl/$RootRelativePath"
                    }

                    # Replace the original path in the content
                    if ($OriginalPath -ne $UpdatedPath) {
                        $FileContent = $FileContent -replace [regex]::Escape($OriginalPath), $UpdatedPath
                        Write-Host "Replaced: $OriginalPath -> $UpdatedPath"
                    }
                }

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
}

cls

# Main Execution
$AzureSASToken = $env:AZURE_BLOB_STORAGE_SAS_TOKEN  # Environment variable for SAS token

Write-Host "Starting process..."
Upload-ImageFiles -LocalPath $LocalImagesPath -BlobUrlBase $BlobUrlBase -AzureSASToken $AzureSASToken

if ($LocalDebug) {
    #$LocalImagesPath = ".\public\capabilities\azure-devops-migration-services"
    $BlobUrl = $BlobUrlBase 
}

# Rewrite Links in HTML Files
Rewrite-ImageLinks -LocalPath $LocalImagesPath -BlobUrl $BlobUrl

Delete-LocalImageFiles -LocalPath $LocalImagesPath

Write-Host "Process complete!"
