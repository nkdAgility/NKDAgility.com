# Helpers
. ./.powershell/_includes/OpenAI.ps1
. ./.powershell/_includes/HugoHelpers.ps1
. ./.powershell/_includes/ResourceHelpers.ps1

# Iterate through each blog folder and update markdown files
$outputDir = "site\content\resources\blog\2019"

# Get list of directories and select the first 10
$resources = Get-ChildItem -Path $outputDir  -Recurse -Filter "index.md" #| Select-Object -First 10

$resources | ForEach-Object {
    $resourceDir = (Get-Item -Path $_).DirectoryName
    $markdownFile = $_
    Write-Host "--------------------------------------------------------"
    Write-Host "Processing post: $resourceDir"
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

        #=================ResourceId=================
        $ResourceId = $null;
        if ($hugoMarkdown.FrontMatter.Contains("ResourceId")) {
            $ResourceId = $hugoMarkdown.FrontMatter.ResourceId
        }
        elseif ($hugoMarkdown.FrontMatter.Contains("videoId")) {
            $ResourceId = $hugoMarkdown.FrontMatter.videoId
        }
        else {
            $ResourceId = New-ResourceId
        }
        Update-Field -frontMatter $hugoMarkdown.FrontMatter -fieldName 'ResourceId' -fieldValue $ResourceId -addAfter 'description'
        
        #=================ResourceImport=================
        if (Test-Path (Join-Path $resourceDir "data.yaml" ) || Test-Path (Join-Path $resourceDir "data.json" )) {
            $ResourceImport = $true
        }
        Update-Field -frontMatter $hugoMarkdown.FrontMatter -fieldName 'ResourceImport' -fieldValue $ResourceImport -addAfter 'ResourceId' -Overwrite

        $ResourceType = Get-ResourceType  -FilePath  $resourceDir
        Update-Field -frontMatter $hugoMarkdown.FrontMatter -fieldName 'ResourceType' -fieldValue $ResourceType -addAfter 'ResourceId' -Overwrite
        
        # =================Add aliases===================
        $aliases = @()
        switch ($ResourceType) {
            "blog" { 
            }
            "podcast" { 
                
            }
            "videos" { 
                
            }
            default { 
                
            }
        }
        # Always add the ResourceId as an alias
        if ($hugoMarkdown.FrontMatter.Contains("ResourceId")) {
            $aliases += "/resources/$($hugoMarkdown.FrontMatter.ResourceId)"
        }
        Update-StringList -frontMatter $hugoMarkdown.FrontMatter -fieldName 'aliases' -values $aliases -addAfter 'slug'
        # =================Add 404 aliases===================
        $404aliases = @()
        $404aliases += $aliases
        switch ($ResourceType) {
            "blog" { 
            }
            "podcast" { 
                
            }
            "videos" { 
                
            }
            default { 
                
            }
        }
        if ($404aliases -is [array] -and $404aliases.Count -gt 0) {
            Update-StringList -frontMatter $hugoMarkdown.FrontMatter -fieldName 'aliasesFor404' -values $404aliases -addAfter 'aliases'
        }
        
        switch ($ResourceType) {
            "blog" { 
               
                # Update-Field -frontMatter $hugoMarkdown.FrontMatter -fieldName 'ResourceImportSource' -fieldValue "Wordpress" -addAfter 'ResourceImport'
                # If (([datetime]$hugoMarkdown.FrontMatter.date) -lt ([datetime]'2011-02-16')) {
                #     Update-Field -frontMatter $hugoMarkdown.FrontMatter -fieldName 'ResourceImportOriginalSource' -fieldValue "GeeksWithBlogs" -addAfter 'ResourceImportSource'
                # }
                # else {
                #     Update-Field -frontMatter $hugoMarkdown.FrontMatter -fieldName 'ResourceImportOriginalSource' -fieldValue "Wordpress" -addAfter 'ResourceImportSource'
                # }     
                # if ($hugoMarkdown.FrontMatter.Contains("slug")) {
                #     $slug = $hugoMarkdown.FrontMatter.slug
                #     $aliases += "/$slug"
                #     $404aliases += "/$slug"
                #     $aliases += "/blog/$slug"
                #     $404aliases += "/blog/$slug"
                # }
                # if ($hugoMarkdown.FrontMatter.Contains("title")) {
                #     $slug = $hugoMarkdown.FrontMatter.slug
                #     $urlSafeTitle = ($hugoMarkdown.FrontMatter.title -replace '[:\/\\*?"<>|#%.!,]', '-' -replace '\s+', '-').ToLower()
                #     if ($urlSafeTitle -ne $slug) {
                #         $aliases += "/$urlSafeTitle"
                #         $404aliases += "/$urlSafeTitle"
                #         $aliases += "/blog/$urlSafeTitle"
                #         $404aliases += "/blog/$urlSafeTitle"
                #     }           
                # }
                
            }
            "podcast" { 
                
            }
            "videos" { 
                
            }
            default { 
                
            }
        }

        

       
       
        Save-HugoMarkdown -hugoMarkdown $hugoMarkdown -Path $markdownFile
    }
    else {
        Write-Host "Skipping folder: $blogDir (missing index.md)"
    }
}

Write-Host "All markdown files processed."
