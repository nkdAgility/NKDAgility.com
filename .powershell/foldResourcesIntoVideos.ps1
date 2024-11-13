$basePath = "site\content\resources\videos\youtube"

# Loop through each folder in the base path that matches "_2ZH7vbKu7Y"
$youtubeFolders = Get-ChildItem -Path $basePath -Directory
$youtubeFolders = $youtubeFolders | Where-Object { $_.Name -match "_2ZH7vbKu7Y" }

$youtubeFolders | ForEach-Object {
    $youtubeId = $_.Name
    $mainFilePath = Join-Path -Path $_.FullName -ChildPath "index.md"
    $customFilePath = Join-Path -Path $_.FullName -ChildPath "wordpress.custom.md"
    $wprssFilePattern = Join-Path -Path $_.FullName -ChildPath "wordpress.wprss*.md"

    $frontMatter = [ordered]@{}
    $body = null
    # Load the main file content
    if (Test-Path $mainFilePath) {
        $mainContent = Get-Content -Path $mainFilePath -Raw

        # Extract front matter and body from the main file
        if ($mainContent -match "(?s)^---(.*?)---\s*(.*)") {
            $frontMatter = ConvertFrom-Yaml $matches[1] -Ordered
            $body = $matches[2]
        }

        # Add URL from main front matter to aliases if it exists
        if ($frontMatter.url) {
            if (-not $frontMatter.Contains('aliases')) {
                $frontMatter.aliases = @()
            }
            $frontMatter.aliases += "$($frontMatter.url)"
        }

        # Load front matter and body for custom and wprss files if they exist
        $customFrontMatter = [ordered]@{}
        $customBody = ""
        if (Test-Path $customFilePath) {
            $customContent = Get-Content -Path $customFilePath -Raw
            if ($customContent -match "(?s)^---(.*?)---\s*(.*)") {
                $customFrontMatter = ConvertFrom-Yaml $matches[1] -Ordered
                $customBody = $matches[2]
                
                # Remove the first instance of a YouTube URL from the custom body
                $youtubeUrlPattern = "https:\/\/youtube\.com\/shorts\/[a-zA-Z0-9_-]+|https:\/\/youtu\.be\/[a-zA-Z0-9_-]+"
                $customBody = $customBody -replace $youtubeUrlPattern, ""
                
                # Always use the body from wordpress.custom.md if it exists
                $body = $customBody
                # Remove canonicalUrl from the front matter if wordpress.custom.md exists
                if ($frontMatter.Contains('canonicalUrl')) {
                    $frontMatter.Remove('canonicalUrl')
                }
                $frontMatter.title = $customFrontMatter.title
                $frontMatter.date = $customFrontMatter.date
                $frontMatter.url = "/resources/videos/:slug"
                
                # Add slug from customFrontMatter to aliases in main front matter
                if ($customFrontMatter.slug) {
                    if (-not $frontMatter.ContainsKey('aliases')) {
                        $frontMatter.aliases = @()
                    }
                    $frontMatter.aliases += "/resources/$($customFrontMatter.slug)"

                }
                # Update URL to be all lowercase and replace special characters with "-"
                $sanitizedTitle = $customFrontMatter.title -replace "[^a-zA-Z0-9]+", "-" -replace "(^-+|-+$)", ""
                $frontMatter.slug = $($sanitizedTitle.ToLower())
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

                    # Add slug from wprssFrontMatter to aliases in main front matter
                    if ($wprssFrontMatter.slug) {
                        if (-not $frontMatter.ContainsKey('aliases')) {
                            $frontMatter.aliases = @()
                        }
                        $frontMatter.aliases += "/resources/$($wprssFrontMatter.slug)"
                    }
                }
            }
        }

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
