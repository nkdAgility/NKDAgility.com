# Define variables
$outputDir = "site\content\resources\videos\youtube"

# Function to update the front matter with resourceTypes
function Update-ResourceTypes {
    param (
        [string]$markdownPath
    )

    # Load the existing content
    $content = Get-Content -Path $markdownPath -Raw

    # Extract front matter and body content
    if ($content -match '(?ms)^---\s*(.*?)---\s*(.*)$') {
        $frontMatterContent = $matches[1]
        $bodyContent = $matches[2]

        # Convert front matter content to ordered hash table
        $frontMatter = ConvertFrom-Yaml $frontMatterContent -Ordered

        # Check and update resourceTypes
        if ($frontMatter.Contains("resourceTypes")) {
            # Ensure resourceTypes is a list and add "video" only if not present
            if ($frontMatter["resourceTypes"] -notcontains "video") {
                $frontMatter["resourceTypes"] += "video"
            }
        }
        else {
            # Add resourceTypes as a list with "video"
            $frontMatter.Add("resourceTypes", @("video"))
        }

        # Convert the updated front matter back to YAML
        $updatedFrontMatter = ConvertTo-Yaml $frontMatter

        # Combine updated front matter and body content
        $updatedContent = "---`n$updatedFrontMatter`n---`n$bodyContent"

        # Write updated content back to file
        Set-Content -Path $markdownPath -Value $updatedContent
        Write-Host "resourceTypes updated for file: $markdownPath"
    }
    else {
        Write-Host "Failed to parse front matter for file: $markdownPath"
    }
}

# Iterate through each video folder and update markdown files
Get-ChildItem -Path $outputDir -Directory | ForEach-Object {
    $videoDir = $_.FullName
    $markdownFile = Join-Path $videoDir "index.md"

    if (Test-Path $markdownFile) {
        # Update the resourceTypes in the existing markdown file
        Update-ResourceTypes -markdownPath $markdownFile
    }
    else {
        Write-Host "Skipping folder: $videoDir (missing index.md)"
    }
}

Write-Host "All markdown files processed."
