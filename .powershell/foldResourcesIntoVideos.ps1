$basePath = "site\content\resources\videos\youtube"

# Loop through each folder in the base path that matches "_Eer3X3Z_LE"
$youtubeFolders = Get-ChildItem -Path $basePath -Directory # | Select-Object -First 30
#$youtubeFolders = $youtubeFolders | Where-Object { $_.Name -match "17qTGonSsbM" }

$youtubeFolders | ForEach-Object {
    $youtubeId = $_.Name
    $mainFilePath = Join-Path -Path $_.FullName -ChildPath "index.md"
    $customFilePattern = Join-Path -Path $_.FullName -ChildPath "wordpress.custom*.md.import"
    $wprssFilePattern = Join-Path -Path $_.FullName -ChildPath "wordpress.wprss*.md.import"

    $frontMatter = [ordered]@{}
    $body = $null
    $hasImportedContent = $false
    $originalUrl = $null
    # Load the main file content
    if (Test-Path $mainFilePath) {
        $mainContent = Get-Content -Path $mainFilePath -Raw

        # Extract front matter and body from the main file
        if ($mainContent -match "(?s)^---(.*?)---\s*(.*)") {
            $frontMatter = ConvertFrom-Yaml $matches[1] -Ordered
            $body = $matches[2]
        }
        $originalUrl = $frontMatter.url
        # Remove YouTube shortcode from body
        $body = $body -replace "{{< youtube [-_a-zA-Z0-9]+ >}}", ""


        # Load front matter and body for custom files if they exist, using the newest date
        $customFiles = Get-ChildItem -Path $customFilePattern | Sort-Object { 
            $customContent = Get-Content -Path $_.FullName -Raw
            if ($customContent -match "(?s)^---(.*?)---") {
                $customFrontMatter = ConvertFrom-Yaml $matches[1] -Ordered
                [datetime]$customFrontMatter.date
            }
            else {
                [datetime]::MinValue
            }
        } -Descending

        foreach ($customFile in $customFiles) {
            $customFrontMatter = [ordered]@{}
            $customBody = ""
            $customContent = Get-Content -Path $customFile.FullName -Raw
            if ($customContent -match "(?s)^---(.*?)---\s*(.*)") {
                $customFrontMatter = ConvertFrom-Yaml $matches[1] -Ordered
                $customBody = $matches[2]
                
                # Remove the first instance of a YouTube URL from the custom body (match domain and go to end of line)
                $youtubeUrlPattern = "(?i)https?:\/\/(www\.)?(youtube\.com|youtu\.be)\/[^\s]*"
                $customBody = $customBody -replace $youtubeUrlPattern, ""
                
                # Always use the body from the newest wordpress.custom*.md file
                $body = $customBody
                # Remove canonicalUrl from the front matter if wordpress.custom.md exists
                if ($frontMatter.Contains('canonicalUrl')) {
                    $frontMatter.Remove('canonicalUrl')
                }
                $frontMatter.title = $customFrontMatter.title
                $frontMatter.date = $customFrontMatter.date
                $frontMatter.url = "/resources/videos/:slug"
                $hasImportedContent = $true
                
                # Add slug from customFrontMatter to aliases in main front matter
                if ($customFrontMatter.slug) {
                    if (-not $frontMatter.Contains('aliases')) {
                        $frontMatter.aliases = @()
                    }
                    if (-not ($frontMatter.aliases -contains "/resources/$($customFrontMatter.slug)")) {
                        $frontMatter.aliases += "/resources/$($customFrontMatter.slug)"
                    }
                }
                # Update URL to be all lowercase and replace special characters with "-"
                $sanitizedTitle = $customFrontMatter.title -replace "’", "" -replace "[^a-zA-Z0-9]+", "-" -replace "(^-+|-+$)", ""
                
                # Insert slug after URL if it does not exist
                if (-not $frontMatter.Contains('slug')) {
                    $frontMatter.Insert(($frontMatter.Keys.IndexOf('url') + 1), 'slug', $($sanitizedTitle.ToLower()))
                }
            }
        }

        # Iterate through all matching wordpress.wprss*.md files
        $wprssFiles = Get-ChildItem -Path $wprssFilePattern
        foreach ($wprssFile in $wprssFiles) {
            $wprssFrontMatter = [ordered]@{}
            $wprssBody = ""
            if (Test-Path $wprssFile.FullName) {
                $wprssContent = Get-Content -Path $wprssFile.FullName -Raw
                if ($wprssContent -match "(?s)^---(.*?)---\s*(.*)") {
                    $wprssFrontMatter = ConvertFrom-Yaml $matches[1] -Ordered
                    $wprssBody = $matches[2]
                    $hasImportedContent = $true

                    # Add slug from wprssFrontMatter to aliases in main front matter
                    if ($wprssFrontMatter.slug) {
                        if (-not $frontMatter.Contains('aliases')) {
                            $frontMatter.aliases = @()
                        }
                        if (-not ($frontMatter.aliases -contains "/resources/$($wprssFrontMatter.slug)")) {
                            $frontMatter.aliases += "/resources/$($wprssFrontMatter.slug)"
                        }
                    }
                }
            }
        }

        # Add URL from main front matter to aliases if it exists and custom or wprss files were imported
        if ($hasImportedContent -and $originalUrl -and $frontMatter.url -ne $originalUrl) {
            if (-not $frontMatter.Contains('aliases')) {
                $frontMatter.aliases = @()
            }
            if (-not ($frontMatter.aliases -contains $originalUrl)) {
                $frontMatter.aliases += "$originalUrl"
            }
        }

        # Trim new lines from start and end of body
        $body = $body.Trim()

        # Replace domain in the body content
        $body = $body -replace "nakedalmweb\.wpenginepowered\.com", "nkdagility.com"

        # Combine the contents
        $mergedContent = "---`n$($frontMatter | ConvertTo-Yaml)`n---`n`n{{< youtube $youtubeId >}}`n`n$body`n`n"

        # Write the merged content back to index.md
        Set-Content -Path $mainFilePath -Value $mergedContent

        Write-Output "Merged content updated for $youtubeId"
    }
    else {
        Write-Output "index.md not found for $youtubeId"
    }
}

Write-Output "All folders processed."
