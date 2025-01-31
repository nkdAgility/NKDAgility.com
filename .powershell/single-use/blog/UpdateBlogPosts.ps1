# Helpers
. ./.powershell/_includes/OpenAI.ps1
. ./.powershell/_includes/HugoHelpers.ps1
. ./.powershell/_includes/ResourceHelpers.ps1

# Iterate through each blog folder and update markdown files
$outputDir = "site\content\resources\blog\"

# Get list of directories and select the first 10
$blogs = Get-ChildItem -Path $outputDir  -Recurse -Filter "index.md"#| Select-Object -First 10

$blogs | ForEach-Object {
    $blogDir = (Get-Item -Path $_).DirectoryName
    $markdownFile = $_

    if ((Test-Path $markdownFile)) {

        # Load markdown as HugoMarkdown object
        $hugoMarkdown = Get-HugoMarkdown -Path $markdownFile
        
        if (-not $hugoMarkdown.FrontMatter.description) {
            # Generate a new description using OpenAI
            $prompt = "Generate a concise, engaging description of no more than 160 characters for the following video: '$($videoData.snippet.title)'. The video details are: '$($videoData.snippet.description)'"
            $description = Get-OpenAIResponse -Prompt $prompt
            # Update the description in the front matter
            Update-Field -frontMatter $hugoMarkdown.FrontMatter -fieldName 'description' -fieldValue $description -addAfter 'title'
        }
        $ResourceId = $null;
        if ($hugoMarkdown.FrontMatter.Contains("ResourceId")) {
            $ResourceId = $hugoMarkdown.FrontMatter.ResourceId
        }
        else {
            $ResourceId = New-ResourceId
            Update-Field -frontMatter $hugoMarkdown.FrontMatter -fieldName 'ResourceId' -fieldValue $ResourceId -addAfter 'description'
        }


        $aliases = @()
        if ($hugoMarkdown.FrontMatter.Contains("id")) {
            if ($hugoMarkdown.FrontMatter.Contains("slug")) {
                $slug = $hugoMarkdown.FrontMatter.slug
                $aliases += "/$slug"
                $aliases += "/blog/$slug"
            }
            if ($hugoMarkdown.FrontMatter.Contains("title")) {
                $slug = $hugoMarkdown.FrontMatter.slug
                $urlSafeTitle = ($hugoMarkdown.FrontMatter.title -replace '[:\/\\*?"<>|#%.!]', '-' -replace '\s+', '-').ToLower()
                if ($urlSafeTitle -ne $slug) {
                    $aliases += "/$urlSafeTitle"
                    $aliases += "/blog/$urlSafeTitle"
                }           
            }
        }
        if ($hugoMarkdown.FrontMatter.Contains("ResourceId")) {
            $aliases += "/resources/$($hugoMarkdown.FrontMatter.ResourceId)"
        }
        Update-StringList -frontMatter $hugoMarkdown.FrontMatter -fieldName 'aliases' -values $aliases -addAfter 'slug'

        

        Save-HugoMarkdown -hugoMarkdown $hugoMarkdown -Path $markdownFile
    }
    else {
        Write-Host "Skipping folder: $blogDir (missing index.md)"
    }
}

Write-Host "All markdown files processed."
