# Helpers
. ./.powershell/_includes/OpenAI.ps1
. ./.powershell/_includes/HugoHelpers.ps1
. ./.powershell/_includes/ResourceHelpers.ps1

# Iterate through each blog folder and update markdown files
$outputDir = ".\site\content\resources\blog\2006"

# Get list of directories and select the first 10
$resources = Get-ChildItem -Path $outputDir  -Recurse -Filter "index.md" #| Select-Object -First 10

# Initialize a hash table to track counts of each ResourceType
$resourceTypeCounts = @{}

$resources | ForEach-Object {
    $resourceDir = (Get-Item -Path $_).DirectoryName
    $markdownFile = $_
    Write-Host "--------------------------------------------------------"
    Write-Host "Processing post: $resourceDir"
    if ((Test-Path $markdownFile)) {

        # Load markdown as HugoMarkdown object
        $hugoMarkdown = Get-HugoMarkdown -Path $markdownFile

        #=================CLEAN============================
        Remove-Field -frontMatter $hugoMarkdown.FrontMatter -fieldName 'id'
        #=================description=================
        if (-not $hugoMarkdown.FrontMatter.description -or $hugoMarkdown.FrontMatter.description -match "no specific details provided") {
            # Generate a new description using OpenAI
            $prompt = "Generate a concise, engaging description of no more than 160 characters for the following resource: '$($videoData.snippet.title)'. The Resource details are: '$($hugoMarkdown.BodyContent)'"
            $description = Get-OpenAIResponse -Prompt $prompt
            # Update the description in the front matter
            Update-Field -frontMatter $hugoMarkdown.FrontMatter -fieldName 'description' -fieldValue $description -addAfter 'title' -
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
        #=================ResourceType=================
        $ResourceType = Get-ResourceType  -FilePath  $resourceDir
        Update-Field -frontMatter $hugoMarkdown.FrontMatter -fieldName 'ResourceType' -fieldValue $ResourceType -addAfter 'ResourceId' -Overwrite

        #=================ResourceImport+=================
        if (Test-Path (Join-Path $resourceDir "data.yaml" ) || Test-Path (Join-Path $resourceDir "data.json" )) {
            $ResourceImport = $true
        }
        Update-Field -frontMatter $hugoMarkdown.FrontMatter -fieldName 'ResourceImport' -fieldValue $ResourceImport -addAfter 'ResourceId' -Overwrite
        if ($hugoMarkdown.FrontMatter.ResourceImport) {
            switch ($ResourceType) {
                "blog" { 
                    Update-Field -frontMatter $hugoMarkdown.FrontMatter -fieldName 'ResourceImportSource' -fieldValue "Wordpress" -addAfter 'ResourceImport'
                    If (([datetime]$hugoMarkdown.FrontMatter.date) -lt ([datetime]'2011-02-16')) {
                        Update-Field -frontMatter $hugoMarkdown.FrontMatter -fieldName 'ResourceImportOriginalSource' -fieldValue "GeeksWithBlogs" -addAfter 'ResourceImportSource' -Overwrite
                    }
                    else {
                        Update-Field -frontMatter $hugoMarkdown.FrontMatter -fieldName 'ResourceImportOriginalSource' -fieldValue "Wordpress" -addAfter 'ResourceImportSource' -Overwrite
                    }     
                }
                "videos" { 
                    
                }
            }
        }
        else {
            Remove-Field -frontMatter $hugoMarkdown.FrontMatter -fieldName 'ResourceImportSource'
            Remove-Field -frontMatter $hugoMarkdown.FrontMatter -fieldName 'ResourceImportOriginalSource'
        }
        # =================Add aliases===================
        $aliases = @()
        switch ($ResourceType) {
            "blog" { 
            }
            "podcast" { 
            }
            "videos" { 
            }
        }
        # Always add the ResourceId as an alias
        if ($hugoMarkdown.FrontMatter.Contains("ResourceId")) {
            $aliases += "/resources/$($hugoMarkdown.FrontMatter.ResourceId)"
        }
        Update-StringList -frontMatter $hugoMarkdown.FrontMatter -fieldName 'aliases' -values $aliases -addAfter 'slug'
        # =================Add 404 aliases===================
        $404aliases = @()
        $404aliases += $hugoMarkdown.FrontMatter.aliases | Where-Object { $_ -notmatch $hugoMarkdown.FrontMatter.ResourceId }
        switch ($ResourceType) {
            "blog" { 
                if ($hugoMarkdown.FrontMatter.Contains("slug")) {
                    $slug = $hugoMarkdown.FrontMatter.slug
                    $404aliases += "/$slug"
                    $404aliases += "/blog/$slug"
                }
                if ($hugoMarkdown.FrontMatter.Contains("title")) {
                    $slug = $hugoMarkdown.FrontMatter.slug
                    $urlSafeTitle = ($hugoMarkdown.FrontMatter.title -replace '[:\/\\*?"<>|#%.!,]', '-' -replace '\s+', '-').ToLower()
                    if ($urlSafeTitle -ne $slug) {
                        $404aliases += "/$urlSafeTitle"
                        $404aliases += "/blog/$urlSafeTitle"
                    }           
                }
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

        #================Catsagories==========================
        . ./.powershell/single-use/resources/Update-Catagories.ps1
        $newCatagories = Get-UpdatedCategories -CurrentCategories $hugoMarkdown.FrontMatter.categories -CatalogCategories $CatalogCategories -ResourceContent $hugoMarkdown.BodyContent -ResourceTitle $hugoMarkdown.FrontMatter.title
        Update-StringList -frontMatter $hugoMarkdown.FrontMatter -fieldName 'categories' -values $newCatagories -Overwrite

        # =================COMPLETE===================
        Save-HugoMarkdown -hugoMarkdown $hugoMarkdown -Path $markdownFile
    }
    else {
        Write-Host "Skipping folder: $blogDir (missing index.md)"
    }
    # Track count of ResourceType
    if ($resourceTypeCounts.ContainsKey($ResourceType)) {
        $resourceTypeCounts[$ResourceType]++
    }
    else {
        $resourceTypeCounts[$ResourceType] = 1
    }
}

Write-Host "All markdown files processed."
Write-Host "--------------------------------------------------------"
Write-Host "Summary of updated Resource Types:"
$resourceTypeCounts.GetEnumerator() | ForEach-Object { Write-Host "$($_.Key): $($_.Value)" }