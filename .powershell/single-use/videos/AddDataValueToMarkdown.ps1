# Helpers
. ./.powershell/include/OpenAI.ps1
. ./.powershell/include/HugoHelpers.ps1

# Function to update a string field in the front matter
function Update-String {
    param (
        [object]$hugoMarkdown,
        [string]$fieldName,
        [string]$fieldValue,
        [string]$addAfter
    )

    # Check and update the field
    if (-not $hugoMarkdown.FrontMatter.Contains($fieldName)) {
        if ($addAfter -and $hugoMarkdown.FrontMatter.Contains($addAfter)) {
            # Insert the new field after the specified field
            $hugoMarkdown.FrontMatter.Insert(($hugoMarkdown.FrontMatter.Keys.IndexOf($addAfter) + 1), $fieldName, $fieldValue)
        }
        else {
            # Add the field to the front matter
            $hugoMarkdown.FrontMatter[$fieldName] = $fieldValue
        }

        Write-Host "$fieldName added for: $($hugoMarkdown.Path)"
    }
    else {
        Write-Host "$fieldName already exists for: $($hugoMarkdown.Path)"
    }

    return $hugoMarkdown
}

# Iterate through each video folder and update markdown files
$outputDir = "site\content\resources\videos\youtube"

Get-ChildItem -Path $outputDir -Directory | ForEach-Object {
    $videoDir = $_.FullName
    $markdownFile = Join-Path $videoDir "index.md"
    $jsonFilePath = Join-Path $videoDir "data.json"

    if ((Test-Path $markdownFile) -and (Test-Path $jsonFilePath)) {
        # Load the video data from data.json
        $videoData = Get-Content -Path $jsonFilePath | ConvertFrom-Json
        $description = Get-Excerpt($videoData.snippet.description)

        # Load markdown as HugoMarkdown object
        $hugoMarkdown = Get-HugoMarkdown -Path $markdownFile

        # Update the description in the HugoMarkdown object
        $hugoMarkdown = Update-String -hugoMarkdown $hugoMarkdown -fieldName 'description' -fieldValue $description -addAfter 'title'

        # Save updated markdown
        Save-HugoMarkdown -HugoMarkdown $hugoMarkdown
    }
    elseif (-not (Test-Path $markdownFile)) {
        Write-Host "Skipping folder: $videoDir (missing index.md)"
    }
    elseif (-not (Test-Path $jsonFilePath)) {
        Write-Host "Skipping folder: $videoDir (missing data.json)"
    }
}

Write-Host "All markdown files processed."
