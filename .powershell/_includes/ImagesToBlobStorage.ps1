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
        #azcopy copy $LocalPath "$BlobUrlBase`?$AzureSASToken" --recursive=true --include-pattern "*.jpg;*.jpeg;*.png;*.gif;*.webp;*.svg" --overwrite ifSourceNewer --put-md5=false
        Write-InfoLog "Upload complete."
    }
    catch {
        Write-ErrorLog"Error during upload: $_"
    }
}

# Method 2: Remove all image files locally
function Remove-LocalImageFiles {
    param([Parameter(Mandatory)][string]$LocalPath)

    Write-InfoLog "Scanning for image files..."
    $patterns = @('*.jpg', '*.jpeg', '*.png', '*.gif', '*.webp', '*.svg')

    # Use -Filter per pattern, it is handled by the filesystem and is faster than -Include
    $files = foreach ($p in $patterns) {
        Get-ChildItem -Path $LocalPath -Recurse -File -Filter $p -ErrorAction SilentlyContinue
    }

    $total = $files.Count
    if ($total -eq 0) {
        Write-InfoLog "No image files found."
        return 0
    }

    $size = ($files | Measure-Object Length -Sum).Sum
    $sizeString = "{0:N2} MB" -f ($size / 1MB)
    Write-InfoLog "Found ($total) image files totalling $sizeString."

    # Single call, array of literal paths, minimal overhead
    Remove-Item -LiteralPath $files.FullName -Force -ErrorAction SilentlyContinue
    Write-InfoLog "Completed: Deleted $total image files."
    return $total
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

    # Use Group-Object chunking
    $chunkSize = [math]::Max(1, [math]::Ceiling($totalFiles / 10))
    Write-InfoLog "Processing $totalFiles HTML files in chunks of ~$chunkSize files each..."

    # 4. Get the root-relative path
    $LocalImagesFullPath = (Get-Item $LocalPath).FullName
    Write-DebugLog "Local Images Full Path: $LocalImagesFullPath"

    # Precompile the regex for better performance
    $ImageRegexPattern = "(?i)(src|content|href|data-theme-src-light|data-theme-src-dark)\s*=\s*([""']?)(?<url>[^\s""'>]+\.(jpg|jpeg|png|gif|webp|svg))\2"
    $CompiledImageRegex = [System.Text.RegularExpressions.Regex]::new($ImageRegexPattern, [System.Text.RegularExpressions.RegexOptions]::IgnoreCase -bor [System.Text.RegularExpressions.RegexOptions]::Compiled)

    # Create chunks using Group-Object
    $counter = [pscustomobject] @{ Value = 0 }
    $chunks = $HtmlFiles | Group-Object -Property { [math]::Floor($counter.Value++ / $chunkSize) }

    $processedFiles = 0
    $chunkNumber = 0

    # Note: Using simple fallback logging in parallel blocks to avoid complex dependencies

    # Start overall timing
    $overallStopwatch = [System.Diagnostics.Stopwatch]::StartNew()

    # Process each chunk
    foreach ($chunk in $chunks) {
        $chunkNumber++
        $chunkLinks = 0

        # Optimize parallelism for build servers - use fewer threads to avoid resource contention
        $processorCount = [Environment]::ProcessorCount
        $maxDegreeOfParallelism = [math]::Max(1, [math]::Min(4, [math]::Ceiling($processorCount / 2)))

        Write-InfoLog "Processing chunk $chunkNumber of $($chunks.Count) ($($chunk.Group.Count) files) with $maxDegreeOfParallelism parallel tasks (out of $processorCount processors)..."

        # Start chunk timing
        $chunkStopwatch = [System.Diagnostics.Stopwatch]::StartNew()

        $chunk.Group | ForEach-Object -ThrottleLimit $maxDegreeOfParallelism -Parallel {
            # Simple fallback logging functions to avoid complex dependencies
            function Write-DebugLog { param($msg) Write-Debug $msg }
            function Write-ErrorLog { param($msg) Write-Error $msg }
            
            # Import variables into parallel scope
            $BlobUrl = $using:BlobUrl
            $LocalPath = $using:LocalPath
            $LocalImagesFullPath = $using:LocalImagesFullPath
            $CompiledImageRegex = $using:CompiledImageRegex
            $currentFile = $_
       
            #$FileContent = Get-Content -LiteralPath $_.FullName -Raw
            $FileContent = [System.IO.File]::ReadAllText($_.FullName)

            # Find all matches using the precompiled regex
            $RegexMatches = $CompiledImageRegex.Matches($FileContent)
            $UniqueUrls = [System.Collections.Generic.HashSet[string]]::new()

            foreach ($Match in $RegexMatches) {
                $Url = $Match.Groups['url'].Value
                [void]$UniqueUrls.Add($Url)
            }    

            # Initialize file link counter
            $fileLinks = 0

            # Process each match and build replacement pairs
            $replacements = @()
            
            foreach ($match in $RegexMatches) {
                $OriginalPath = $match.Groups['url'].Value
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
                                $UpdatedPath = "$BlobUrl$path"
                            }
                        }
                        else {
                            Write-DebugLog "  Skipping : $OriginalPath"
                            continue
                        }   
                    }
                    catch {
                        Write-DebugLog "  ERROR HTTP: $OriginalPath -> $UpdatedPath : $_" 
                        continue
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
                        $ParentDirectory = Split-Path -Path $currentFile.FullName -Parent
                        Write-DebugLog "Parent Directory: $ParentDirectory"

                        # 2. Combine the parent directory with the original path
                        $CombinedPath = Join-Path -Path $ParentDirectory -ChildPath $OriginalPath
                        Write-DebugLog "Combined Path: $CombinedPath"

                        if (-not (Test-Path -Path $CombinedPath)) {
                            Write-DebugLog "  Path does not exist: $CombinedPath"
                            continue
                        }
                        # 3. Resolve the full path
                        $ResolvedPath = Resolve-Path -Path $CombinedPath
                        Write-DebugLog "Resolved Path: $ResolvedPath"

                        $RootRelativePath = $ResolvedPath.Path.Replace($LocalImagesFullPath, "").Replace("\", "/")
                        Write-DebugLog "Root Relative Path: $RootRelativePath"

                        # 5. Construct the updated path
                        $UpdatedPath = "$BlobUrl/$RootRelativePath"
                        Write-DebugLog "  Updated Path: $UpdatedPath"
                    }
                    catch {
                        Write-ErrorLog "  Error resolving path: $_"
                        continue
                    }
                }

                # Add replacement if the path changed
                if ($OriginalPath -ne $UpdatedPath) {
                    $replacements += @{
                        Original  = $OriginalPath
                        Updated   = $UpdatedPath
                        FullMatch = $match.Value
                    }
                    $fileLinks++
                    Write-DebugLog "  Will replace: $OriginalPath -> $UpdatedPath"
                }
            }

            # Apply all replacements to the file content
            foreach ($replacement in $replacements) {
                $newMatchValue = $replacement.FullMatch.Replace($replacement.Original, $replacement.Updated)
                $FileContent = $FileContent.Replace($replacement.FullMatch, $newMatchValue)
            }

            # Only save the file if there were actual changes
            if ($fileLinks -gt 0) {
                [System.IO.File]::WriteAllText($_.FullName, $FileContent)
                Write-DebugLog "Updated ($($RegexMatches.count) matches, $fileLinks links): $($_.FullName)"
            }
            else {
                Write-DebugLog "No changes needed: $($_.FullName)"
            }

            # Return the count of links processed for this file
            return $fileLinks
            
        } | ForEach-Object {
            $chunkLinks += $_
        }

        $processedFiles += $chunk.Group.Count
        $totalLinks += $chunkLinks
        $percentage = [math]::Round(($processedFiles / $totalFiles) * 100, 0)
        
        # Stop chunk timing
        $chunkStopwatch.Stop()
        $chunkTime = $chunkStopwatch.Elapsed.TotalSeconds
        $avgTimePerFile = $chunkTime / $chunk.Group.Count
        
        Write-InfoLog "Completed chunk ${chunkNumber}: $chunkLinks links updated in $($chunkTime.ToString('F1'))s (avg $($avgTimePerFile.ToString('F2'))s/file). Overall progress: $percentage% ($processedFiles of $totalFiles files, $totalLinks total links updated)"
    }

    # Stop overall timing
    $overallStopwatch.Stop()
    $totalTime = $overallStopwatch.Elapsed.TotalSeconds
    $avgOverallTimePerFile = $totalTime / $totalFiles
    
    Write-InfoLog "HTML link rewriting complete: $totalLinks links updated across $totalFiles files in $($totalTime.ToString('F1'))s (avg $($avgOverallTimePerFile.ToString('F2'))s/file)"
}
