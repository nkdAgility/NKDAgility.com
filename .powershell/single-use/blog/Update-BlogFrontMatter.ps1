# Helpers
. ./.powershell/_includes/OpenAI.ps1
. ./.powershell/_includes/HugoHelpers.ps1
. ./.powershell/_includes/ResourceHelpers.ps1

# Iterate through each blog folder and update markdown files
$outputDir = "site\content\resources\blog\2025"

# Get list of directories and select the first 10
$blogs = Get-ChildItem -Path $outputDir  -Recurse -Filter "index.md" #| Select-Object -First 10

$blogs | ForEach-Object {
    $blogDir = (Get-Item -Path $_).DirectoryName
    $markdownFile = $_
    Write-Host "--------------------------------------------------------"
    Write-Host "Processing post: $blogDir"
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

        if ($hugoMarkdown.FrontMatter.Contains("id")) {
            Update-Field -frontMatter $hugoMarkdown.FrontMatter -fieldName 'ResourceType' -fieldValue "blogpost" -addAfter 'ResourceId'
            Update-Field -frontMatter $hugoMarkdown.FrontMatter -fieldName 'ResourceImport' -fieldValue $true -addAfter 'ResourceType'
            Update-Field -frontMatter $hugoMarkdown.FrontMatter -fieldName 'ResourceImportSource' -fieldValue "Wordpress" -addAfter 'ResourceImport'
            If (([datetime]$hugoMarkdown.FrontMatter.date) -lt ([datetime]'2011-02-16')) {
                Update-Field -frontMatter $hugoMarkdown.FrontMatter -fieldName 'ResourceImportOriginalSource' -fieldValue "GeeksWithBlogs" -addAfter 'ResourceImportSource'
            }
            else {
                Update-Field -frontMatter $hugoMarkdown.FrontMatter -fieldName 'ResourceImportOriginalSource' -fieldValue "Wordpress" -addAfter 'ResourceImportSource'
            }     
            Update-Field -frontMatter $hugoMarkdown.FrontMatter -fieldName 'ResourceImportId' -fieldValue ([int]$hugoMarkdown.FrontMatter.Id) -addAfter 'ResourceImport'
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
                $urlSafeTitle = ($hugoMarkdown.FrontMatter.title -replace '[:\/\\*?"<>|#%.!,]', '-' -replace '\s+', '-').ToLower()
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

        $404aliases = @()
        if ($hugoMarkdown.FrontMatter.Contains("id")) {
            if ($hugoMarkdown.FrontMatter.Contains("slug")) {
                $slug = $hugoMarkdown.FrontMatter.slug
                $404aliases += "/$slug"
                $404aliases += "/blog/$slug"
            }
            if ($hugoMarkdown.FrontMatter.Contains("title")) {
                $slug = $hugoMarkdown.FrontMatter.slug
                $urlSafeTitle = ($hugoMarkdown.FrontMatter.title -replace '[:\/\\*?"<>| #%.!]', '-' -replace '\s+', '-').ToLower()
                if ($urlSafeTitle -ne $slug) {
                    $404aliases += "/$urlSafeTitle"
                    $404aliases += "/blog/$urlSafeTitle"
                }           
            }
        }
        if ($404aliases -is [array] -and $404aliases.Count -gt 0) {
            Update-StringList -frontMatter $hugoMarkdown.FrontMatter -fieldName 'aliasesArchive' -values $404aliases -addAfter 'aliases'
        }
        
        

        Save-HugoMarkdown -hugoMarkdown $hugoMarkdown -Path $markdownFile
    }
    else {
        Write-Host "Skipping folder: $blogDir (missing index.md)"
    }
}

Write-Host "All markdown files processed."
