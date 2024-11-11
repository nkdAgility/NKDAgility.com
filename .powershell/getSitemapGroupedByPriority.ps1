$sitemapUrl = "http://localhost:1313/sitemap.xml"
$outputFile = "priority_pages.md"

# Load the sitemap
[xml]$sitemap = Invoke-WebRequest -Uri $sitemapUrl -UseBasicParsing

# Initialize a hashtable to group pages by priority
$priorityGroups = @{}

# Iterate through each URL node in the sitemap
foreach ($url in $sitemap.urlset.url) {
    $loc = $url.loc
    $priority = [decimal]$url.priority

    # Only include pages with a priority higher than 0.5
    if ($priority -gt 0.5) {
        # Add the URL to the appropriate priority group
        if (-not $priorityGroups.ContainsKey($priority)) {
            $priorityGroups[$priority] = @()
        }
        $priorityGroups[$priority] += $loc
    }
}

# Generate the markdown table
$markdownContent = "# Sitemap Priority Pages`n`n"
foreach ($priority in ($priorityGroups.Keys | Sort-Object -Descending)) {
    $markdownContent += "## Priority: $priority`n`n"
    $markdownContent += "| URL |`n"
    $markdownContent += "| --- |`n"
    foreach ($url in $priorityGroups[$priority]) {
        $markdownContent += "| $url |`n"
    }
    $markdownContent += "`n"
}

# Save the markdown content to a file
Set-Content -Path $outputFile -Value $markdownContent

# Display the output file path
Write-Output "Markdown file generated: $outputFile"
