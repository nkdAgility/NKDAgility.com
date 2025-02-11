
# Helpers
. ./.powershell/_includes/LoggingHelper.ps1
. ./.powershell/_includes/OpenAI.ps1
. ./.powershell/_includes/HugoHelpers.ps1
. ./.powershell/_includes/ResourceHelpers.ps1
. ./.powershell/_includes/ClassificationHelpers.ps1


$levelSwitch.MinimumLevel = 'Debug'

# Iterate through each blog folder and update markdown files
$outputDir = ".\site\content\resources\blog\"

# Get list of directories and select the first 10
$resources = Get-ChildItem -Path $outputDir  -Recurse -Filter "index.md"  | Sort-Object { $_ } -Descending | Select-Object -First 300 

$categoriesCatalog = Get-CatalogHashtable -Classification "categories"
$tagsCatalog = Get-CatalogHashtable -Classification "tags"

# Initialize a hash table to track counts of each ResourceType
$resourceTypeCounts = @{}

# Total count for progress tracking
$TotalFiles = $resources.Count
$Counter = 0

$resources | ForEach-Object {

    $Counter++
    $PercentComplete = ($Counter / $TotalFiles) * 100


    $resourceDir = (Get-Item -Path $_).DirectoryName
    $markdownFile = $_
    Write-InfoLog "--------------------------------------------------------"
    Write-InfoLog "Processing post: {ResolvePath}" -PropertyValues  $(Resolve-Path -Path $resourceDir -Relative)
    if ((Test-Path $markdownFile)) {

        # Load markdown as HugoMarkdown object
        $hugoMarkdown = Get-HugoMarkdown -Path $markdownFile

        Write-Progress -id 1 -Activity "Processing Markdown Files" -Status "Processing $Counter ('$($hugoMarkdown.FrontMatter.date)') of $TotalFiles" -PercentComplete $PercentComplete

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
        if ( (Test-Path (Join-Path $resourceDir "data.yaml" )) -or (Test-Path (Join-Path $resourceDir "data.json" ))) {
            $ResourceImport = $true
        }
        else {
            $ResourceImport = $false
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

        #================Themes, Categories, & TAGS==========================
        $BodyContent = $hugoMarkdown.BodyContent
        If ($hugoMarkdown.FrontMatter.ResourceType -eq "videos") {
            $captionsPath = Join-Path $resourceDir "index.captions.en.md"
            if (Test-Path ($captionsPath )) {
                $BodyContent = Get-Content $captionsPath -Raw
            }
        }
        #-----------------Categories-------------------
        $categoryClassification = Get-CategoryConfidenceWithChecksum -ClassificationType "categories" -Catalog $categoriesCatalog -CacheFolder $resourceDir -ResourceContent  $BodyContent -ResourceTitle $hugoMarkdown.FrontMatter.title -MaxCategories 3 
        $categories = $categoryClassification | ConvertFrom-Json | ForEach-Object { $_.category } | Sort-Object
        Update-StringList -frontMatter $hugoMarkdown.FrontMatter -fieldName 'categories' -values @($categories) -Overwrite
        #-----------------Tags-------------------
        $tagClassification = Get-CategoryConfidenceWithChecksum -ClassificationType "tags" -Catalog $tagsCatalog -CacheFolder $resourceDir -ResourceContent  $BodyContent -ResourceTitle $hugoMarkdown.FrontMatter.title -MaxCategories 15
        $tags = $tagClassification | ConvertFrom-Json | ForEach-Object { $_.category } | Sort-Object
        Update-StringList -frontMatter $hugoMarkdown.FrontMatter -fieldName 'tags' -values @($tags) -Overwrite
        # =================COMPLETE===================
        Save-HugoMarkdown -hugoMarkdown $hugoMarkdown -Path $markdownFile
    }
    else {
        Write-InfoLog "Skipping folder: $blogDir (missing index.md)"
    }
    # Track count of ResourceType
    if ($resourceTypeCounts.ContainsKey($ResourceType)) {
        $resourceTypeCounts[$ResourceType]++
    }
    else {
        $resourceTypeCounts[$ResourceType] = 1
    }
}
Write-Progress -id 1 -Completed
Write-InfoLog "All markdown files processed."
Write-InfoLog "--------------------------------------------------------"
Write-InfoLog "Summary of updated Resource Types:"
$resourceTypeCounts.GetEnumerator() | ForEach-Object { Write-InfoLog "$($_.Key): $($_.Value)" }