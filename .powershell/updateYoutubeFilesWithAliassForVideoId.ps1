# Define the base directory
$baseDir = "site\content\resources\videos\youtube\"

# Iterate through all index.md files
Get-ChildItem -Path $baseDir -Recurse -Filter "index.md" | ForEach-Object {
    # Read the file content
    $filePath = $_.FullName
    $content = Get-Content -Path $filePath -Raw

    # Separate front matter and body
    if ($content -match '(?s)^---(.*?)---') {
        $frontMatter = $matches[1]
        $body = $content -replace "(?s)^---(.*?)---", ''

        # Convert front matter to a hashtable
        $yaml = $frontMatter -replace '^---\s*\n', '' -replace '\n---$', ''
        $frontMatterHash = ConvertFrom-Yaml $yaml -Ordered

        # Ensure videoId exists in front matter
        if ($frontMatterHash.Contains('videoId')) {
            $videoId = $frontMatterHash['videoId']
            $newAlias = "/resources/videos/$videoId"

            # Add the new alias if it doesn't already exist
            if ($frontMatterHash.Contains('aliases')) {
                if ($frontMatterHash.aliases -notcontains $newAlias) {
                    $frontMatterHash.aliases += $newAlias
                }
            }
            else {
                $frontMatterHash.aliases = @($newAlias)
            }

            # Convert updated front matter back to YAML
            $updatedFrontMatter = ConvertTo-Yaml $frontMatterHash

            # Write the updated content back to the file
            $updatedContent = "---`r`n$updatedFrontMatter`r`n---`r`n$body"
            Set-Content -Path $filePath -Value $updatedContent -Force

            Write-Host "Updated aliases for video ID: $videoId in $filePath" -ForegroundColor Green
        }
        else {
            Write-Host "videoId not found in $filePath. Skipping..." -ForegroundColor Yellow
        }
    }
    else {
        Write-Host "Invalid front matter in $filePath. Skipping..." -ForegroundColor Red
    }
}
