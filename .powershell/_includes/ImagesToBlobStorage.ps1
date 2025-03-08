# Helpers
. ./.powershell/_includes/LoggingHelper.ps1

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
        Write-InfoLog "Uploading image files to Azure Blob Storage using azcopy..."
        azcopy sync $LocalPath "$BlobUrlBase`?$AzureSASToken" --recursive=true --include-pattern "*.jpg;*.jpeg;*.png;*.gif;*.webp;*.svg" --compare-hash=MD5
        Write-InfoLog "Upload complete."
    }
    catch {
        Write-ErrorLog"Error during upload: $_"
    }
}

# Method 2: Delete all image files locally
function Delete-LocalImageFiles {
    param (
        [string]$LocalPath
    )
    $count = 0
    try {
        Write-InfoLog "Deleting all image files locally..."
        $images = Get-ChildItem -Path $LocalPath -Recurse -Include *.jpg, *.jpeg, *.png, *.gif, *.webp, *.svg
        if ($images.Count -eq 0) {
            Write-InfoLog "No image files found."
            return 0;
        }

        $totalFiles = $images.Count
        $size = ($images | Measure-Object -Property Length -Sum).Sum 
        $sizeString = "{0:N2} MB" -f ($size / 1MB)
        Write-InfoLog "Found ($totalFiles) image files totalling $sizeString."

        $lastPercentage = 0  # Tracks when to log progress
        $progressInterval = 10 # Percentage interval for logging

        $images | ForEach-Object -Begin { $index = 0 } -Process {
            try {
                Remove-Item -Path $_.FullName -Force
                Write-DebugLog "Deleted: $($_.FullName)"
                $count++
                $index++

                # Calculate percentage progress
                $percentage = [math]::Round(($index / $totalFiles) * 100, 0)

                # Log progress at defined intervals
                if ($percentage -ge $lastPercentage + $progressInterval) {
                    Write-InfoLog "Progress: $percentage% ($index of $totalFiles image files deleted)"
                    $lastPercentage = $percentage
                }
            }
            catch {
                Write-ErrorLog "Error deleting file $($_.FullName): $_"
            }
        }
    }
    catch {
        Write-ErrorLog "Error during image file deletion: $_"
    }
    Write-InfoLog "Completed: Deleted $count image files."
    return $count;
}


# Method 3: Rewrite image links in .html files using regex
function Rewrite-ImageLinks {
    param (
        [string]$LocalPath,
        [string]$BlobUrl
    )
  
    Write-InfoLog "Rewriting image links in .html files using regex..."

    $HtmlFiles = Get-ChildItem -Path $LocalPath -Recurse -Include *.html

    $totalLinks = 0;
    $totalFiles = $HtmlFiles.Count

    if ($totalFiles -eq 0) {
        Write-InfoLog "No .html files found for processing."
        return
    }

    $lastPercentage = 0  # Tracks when to log progress
    $progressInterval = 10 # Percentage interval for logging

    foreach ($HtmlFile in $HtmlFiles) {
       
        $FileContent = Get-Content -LiteralPath $HtmlFile.FullName -Raw
        # Regex to match all src attributes with image paths
        $ImageRegex = "(?i)(src|content|href)\s*=\s*([""']?)(?<url>[^\s""'>]+\.(jpg|jpeg|png|gif|webp|svg))\2"

        # Find all matches and ensure uniqueness based on the 'url' group
        $Matches = [regex]::Matches($FileContent, $ImageRegex)
        $UniqueUrls = @()

        foreach ($Match in $Matches) {
            $Url = $Match.Groups['url'].Value
        
            # Add the URL to the array if it's not already included
            if ($Url -notin $UniqueUrls) {
                $UniqueUrls += $Url
            }
        }    

        foreach ($UniqueUrl in $UniqueUrls) {
           
            $OriginalPath = $UniqueUrl
            $UpdatedPath = $OriginalPath

            # Skip if the path already contains the BlobUrl
            if ($OriginalPath -like "$BlobUrl*") {
                continue
            }

            # Handle all paths using $BlobUrl
            if ($OriginalPath.StartsWith("https://") -or $OriginalPath.StartsWith("http://")) {
                try {
                    # Define the regex pattern
                    $allowedPattern = '^(?:https?:\/\/)?(?:nkdagility\.com|preview\.nkdagility\.com|yellow-pond-042d21b03.*\.westeurope\.5\.azurestaticapps\.net)(\/.*)?$'
                    if ($OriginalPath -match $allowedPattern) {
                        $pattern = '^(?:https?:\/\/)?[^\/]+(?<path>\/.*)$'
                        if ($OriginalPath -match $pattern) {
                            $path = $matches['path']
                            $UpdatedPath = "$BlobUrl/" + $path -join '/'
                        }
                       
                    }
                    else {
                        Write-DebugLog "  Skipping : $OriginalPath"
                    }   
                          
                }
                catch {
                    Write-DebugLog "  ERROR HTTP: $OriginalPath -> $UpdatedPath : $_" 
                }              
            }
            elseif ($OriginalPath.StartsWith("/")) {
                # Absolute paths
                $UpdatedPath = "$BlobUrl" + $OriginalPath

            }
            else {
                try {
                    # Relative paths - Ensure consistency by converting to root-relative
                    # 1. Get the parent directory of the HTML file
                    $ParentDirectory = Split-Path -Path $HtmlFile.FullName -Parent
                    Write-DebugLog "Parent Directory: $ParentDirectory"

                    # 2. Combine the parent directory with the original path
                    $CombinedPath = Join-Path -Path $ParentDirectory -ChildPath $OriginalPath
                    Write-DebugLog "Combined Path: $CombinedPath"

                    if (-not (Test-Path -Path $CombinedPath)) {
                        Write-DebugLog "  Path does not exist: $CombinedPath"
                        continue;
                    }
                    # 3. Resolve the full path
                    $ResolvedPath = Resolve-Path -Path $CombinedPath
                    Write-DebugLog "Resolved Path: $ResolvedPath"

                    # 4. Get the root-relative path
                    $LocalImagesFullPath = (Get-Item $LocalPath).FullName
                    Write-DebugLog "Local Images Full Path: $LocalImagesFullPath"

                    $RootRelativePath = $ResolvedPath.Path.Replace($LocalImagesFullPath, "").Replace("\", "/")
                    Write-DebugLog "Root Relative Path: $RootRelativePath"

                    # 5. Construct the updated path
                    $UpdatedPath = "$BlobUrl/$RootRelativePath"
                    Write-DebugLog "  Updated Path: $UpdatedPath"
                }
                catch {
                    Write-ErrorLog "  Error resolving path: $_"
                    continue;
                }
            }

            # Replace the original path in the content
            if ($OriginalPath -ne $UpdatedPath) {
                $FileContent = $FileContent -replace [regex]::Escape($OriginalPath), $UpdatedPath
                Write-DebugLog "  Replaced: $OriginalPath -> $UpdatedPath"
                $totalLinks += 1;
            }
            
        }

        # Save updated content back to the file
        Set-Content -LiteralPath $HtmlFile.FullName -Value $FileContent
        Write-DebugLog "Updated ($($Matches.count)): $($HtmlFile.FullName)"

        # **Progress tracking**
        $index++
        $percentage = [math]::Round(($index / $totalFiles) * 100, 0)
        
        # Log progress every 10%
        if ($percentage -ge $lastPercentage + $progressInterval) {
            Write-InfoLog "Progress: $percentage% ($index of $totalFiles HTML files processed with $totalLinks links updated)"
            $lastPercentage = $percentage
        }
            
    }
    Write-InfoLog "HTML link rewriting complete: $totalLinks links updated across $totalFiles files."
}
