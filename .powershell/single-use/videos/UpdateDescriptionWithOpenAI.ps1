# Helpers
. ./.powershell/_includes/OpenAI.ps1
. ./.powershell/_includes/HugoHelpers.ps1

# Iterate through each video folder and update markdown files
$outputDir = "site\content\resources\videos\youtube"

# Get list of directories and select the first 10
$videoFolders = Get-ChildItem -Path $outputDir -Directory #| Select-Object -First 10

$videoFolders | ForEach-Object {
    $videoDir = $_.FullName
    $markdownFile = Join-Path $videoDir "index.md"
    $jsonFilePath = Join-Path $videoDir "data.json"

    if ((Test-Path $markdownFile) -and (Test-Path $jsonFilePath)) {
        # Load the video data from data.json
        $videoData = Get-Content -Path $jsonFilePath | ConvertFrom-Json
        
        # Load markdown as HugoMarkdown object
        $hugoMarkdown = Get-HugoMarkdown -Path $markdownFile
        
        if ($hugoMarkdown.FrontMatter.description) {
            Write-Host "Skipping folder: $videoDir (description already exists)"
            return
        }

        # Generate a new description using OpenAI
        $prompt = "Generate a concise, engaging description of no more than 160 characters for the following video: '$($videoData.snippet.title)'. The video details are: '$($videoData.snippet.description)'"
        $description = Get-OpenAIResponse -Prompt $prompt

        # Update the description in the front matter
        $updatedFrontMatter = Update-Field -frontMatter $hugoMarkdown.FrontMatter -fieldName 'description' -fieldValue $description -addAfter 'title'

        # Save updated markdown
        $hugoMarkdown.FrontMatter = $updatedFrontMatter
        Save-HugoMarkdown -hugoMarkdown $hugoMarkdown -Path $markdownFile
    }
    elseif (-not (Test-Path $markdownFile)) {
        Write-Host "Skipping folder: $videoDir (missing index.md)"
    }
    elseif (-not (Test-Path $jsonFilePath)) {
        Write-Host "Skipping folder: $videoDir (missing data.json)"
    }
}

Write-Host "All markdown files processed."
