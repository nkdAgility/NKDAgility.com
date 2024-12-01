# Variables
$LocalImagesPath = ".\public\"  # Local folder containing images and HTML files
$BlobUrlBase = "https://nkdagilityblobs.blob.core.windows.net/`$web"  # Base URL for the blob storage
$BlobPath = "blob"  # Path to be added for images in HTML
$LocalDebug = $true

# Method 1: Upload image files using azcopy
function Upload-ImageFiles {
    param (
        [string]$LocalPath,
        [string]$AzureSASToken
    )
    try {
        Write-Host "Uploading image files to Azure Blob Storage using azcopy..."
        azcopy sync $LocalPath $AzureSASToken --recursive --include-pattern "*.jpg;*.jpeg;*.png;*.gif;*.webp"
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

# Method 3: Rewrite image links in .html files
# Method 3: Rewrite image links in .html files
# Method 3: Rewrite image links in .html files using regex
function Rewrite-ImageLinks {
    param (
        [string]$LocalPath,
        [string]$BlobPath,
        [string]$BlobUrlBase,
        [bool]$Debug = $false
    )
    try {
        Write-Host "Rewriting image links in .html files using regex..."
        if ($Debug) {
            Write-Host "DEBUG MODE: All paths will use BlobUrlBase ($BlobUrlBase)"
        }

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
                    $Extension = $Match.Groups[2].Value

                    # Skip if the path already contains 'blob' unless in debug mode
                    if ($Debug -or $OriginalPath -notmatch 'blob/') {
                        # Determine the updated path
                        $UpdatedPath = $OriginalPath

                        if ($Debug) {
                            # DEBUG MODE: Use BlobUrlBase for all paths
                            if ($OriginalPath.StartsWith("https://") -or $OriginalPath.StartsWith("//")) {
                                $UpdatedPath = $BlobUrlBase + $OriginalPath -replace "^(https?:\/\/|\/\/).*?\/", ""
                            }
                            else {
                                $UpdatedPath = $BlobUrlBase + $OriginalPath.TrimStart("./")
                            }
                        }
                        elseif ($OriginalPath.StartsWith("https://nkdagility.com") -or 
                            $OriginalPath.StartsWith("https://preview.nkdagility.com") -or 
                            $OriginalPath -match "^https:\/\/(yellow-pond-042d21b03|[a-z0-9-]+)\.azurestaticapps\.net") {
                            # Add '/blob/' to supported domains
                            $UpdatedPath = $OriginalPath -replace "^(https?:\/\/.*?)(\/|\/\/)", "`$1/$BlobPath/"
                        }
                        elseif ($OriginalPath -match "//localhost:1313") {
                            # Add full $BlobUrlBase for localhost paths
                            $UpdatedPath = $BlobUrlBase + $OriginalPath -replace "//localhost:1313", ""
                        }
                        elseif ($OriginalPath.StartsWith("/")) {
                            # Absolute path
                            $UpdatedPath = "/$BlobPath" + $OriginalPath
                        }
                        elseif ($OriginalPath.StartsWith("./")) {
                            # Relative path
                            $UpdatedPath = "./$BlobPath" + $OriginalPath.Substring(1)
                        }

                        # Replace the original path in the content
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
#Upload-ImageFiles -LocalPath $LocalImagesPath -AzureSASToken $AzureSASToken
#Delete-LocalImageFiles -LocalPath $LocalImagesPath

$LocalImagesPath = ".\public\capabilities\azure-devops-migration-services"  # Local folder containing images and HTML files

Rewrite-ImageLinks -LocalPath $LocalImagesPath -BlobPath $BlobPath -BlobUrlBase $BlobUrlBase -Debug $LocalDebug
Write-Host "Process complete!"
