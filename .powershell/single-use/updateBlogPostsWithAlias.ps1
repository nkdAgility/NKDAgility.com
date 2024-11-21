# Define the path to the blog content
$blogPath = "site\content\resources\blog"

# Limit the number of files to update (set this to the desired number)
$fileLimit = 900

# Get all index.md files under the blogPath recursively
$indexFiles = Get-ChildItem -Path $blogPath -Recurse -Filter "index.md" | Select-Object -First $fileLimit

foreach ($indexFile in $indexFiles) {
    # Read the content of the current index.md file
    $content = Get-Content -Path $indexFile.FullName -Raw

    # Extract the slug from the front matter (assuming there's a slug field in YAML front matter)
    $slug = $null
    $contentLines = $content -split "`r`n"
    foreach ($line in $contentLines) {
        if ($line -match '^slug:\s*["]?([^\s"]+)["]?$') {
            $slug = $matches[1] # This removes any quotes around the slug
            break
        }
    }

    # If no slug was found, skip this file
    if (-not $slug) {
        Write-Host "No slug found for $($indexFile.FullName), skipping..."
        continue
    }

    # Check if the alias already exists
    $aliasExists = $content -match "aliases:"
    $aliasEntry = "  - /blog/$slug"

    if ($aliasExists) {
        # Check if the alias for /blog/[slug] already exists
        if ($content -match [regex]::Escape($aliasEntry)) {
            Write-Host "Alias already exists for $($indexFile.FullName)"
        }
        else {
            # Append the new alias under the aliases section
            $newContent = $content -replace "(aliases:\s*[\r\n]+)", "`$1`n$aliasEntry`n"
            Set-Content -Path $indexFile.FullName -Value $newContent -Force
            Write-Host "Added alias for $($indexFile.FullName)"
        }
    }
    else {
        # Add the aliases section and the alias
        $aliasesSection = @(
            "aliases:",
            $aliasEntry
        )

        # Insert the alias right after the front matter
        # Find the position of the slug field
        $slugIndex = $content.IndexOf("slug:", 0)
        if ($slugIndex -ne -1) {
            # Insert the alias right after the slug
            $updatedContent = $content.Insert($slugIndex + $content.Substring($slugIndex).IndexOf("`n") + 1, "`n" + ($aliasesSection -join "`n") + "`n")
            Set-Content -Path $indexFile.FullName -Value $updatedContent -Force
            Write-Host "Added aliases section for $($indexFile.FullName)"
        }
        else {
            Write-Host "No slug found for $($indexFile.FullName), skipping..."
        }

    }
}
