
# Helpers
. ./.powershell/_includes/LoggingHelper.ps1
. ./.powershell/_includes/OpenAI.ps1
. ./.powershell/_includes/HugoHelpers.ps1
. ./.powershell/_includes/ResourceHelpers.ps1
. ./.powershell/_includes/ClassificationHelpers.ps1


$levelSwitch.MinimumLevel = 'Information'

# Iterate through each blog folder and update markdown files
$outputDir = ".\site\content\resources\videos"

# Get list of directories and select the first 10
$resources = Get-ChildItem -Path $outputDir  -Recurse -Filter "index.md"  | Sort-Object { $_ } -Descending #| Select-Object -Skip 600  # | Select-Object -First 300 

$Counter = 1


$hugoMarkdownFiles = @()
$TotalFiles = $resources.Count
Write-InformationLog "Loading ({count}) markdown files...." -PropertyValues $TotalFiles
$resources | ForEach-Object {
    if ((Test-Path $_)) {
        $hugoMarkdown = Get-HugoMarkdown -Path $_
        $hugoMarkdownFiles += $hugoMarkdown
    }
}
Write-InformationLog "Loaded ({count}) HugoMarkdown Objects." -PropertyValues $hugoMarkdownFiles.Count


$categoriesCatalog = Get-CatalogHashtable -Classification "categories"
$tagsCatalog = Get-CatalogHashtable -Classification "tags"

# Initialize a hash table to track counts of each ResourceType
$resourceTypeCounts = @{}


$Counter = 0


#$hugoMarkdownFiles = $hugoMarkdownFiles  | Where-Object { $_.FrontMatter.Contains('canonicalURL') }


$TotalItems = $hugoMarkdownFiles.Count
#$hugoMarkdownFiles = $hugoMarkdownFiles  | Where-Object { $_.FrontMatter.isShort -ne $true }
#Write-InformationLog "Removed ({count}) HugoMarkdown Objects where FrontMatter.isShort -ne true." -PropertyValues ($TotalItems - $hugoMarkdownFiles.Count)
#$TotalItems = $hugoMarkdownFiles.Count
$hugoMarkdownFiles = $hugoMarkdownFiles  | Where-Object { $_.FrontMatter.draft -ne $true }
Write-InformationLog "Removed ({count}) HugoMarkdown Objects where FrontMatter.draft -ne true." -PropertyValues ($TotalItems - $hugoMarkdownFiles.Count)


$hugoMarkdownFiles = $hugoMarkdownFiles | Sort-Object { $_.FrontMatter.date } -Descending
# Total count for progress tracking
$TotalItems = $hugoMarkdownFiles.Count
Write-InformationLog "Processing ({count}) HugoMarkdown Objects." -PropertyValues ($TotalItems)
foreach ($hugoMarkdown in $hugoMarkdownFiles ) {
    $Counter++
    $PercentComplete = ($Counter / $TotalItems) * 100
    Write-Progress -id 1 -Activity "Processing Markdown Files" -Status "Processing $Counter of $TotalItems | $($hugoMarkdown.FrontMatter.date) | $($hugoMarkdown.FrontMatter.ResourceType) | $($hugoMarkdown.FrontMatter.title)" -PercentComplete $PercentComplete
 

    Write-DebugLog "--------------------------------------------------------"
    Write-InfoLog "Processing post: {ResolvePath}" -PropertyValues  $(Resolve-Path -Path $hugoMarkdown.FolderPath -Relative)

    

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
    $ResourceType = Get-ResourceType  -FilePath  $hugoMarkdown.FolderPath
    Update-Field -frontMatter $hugoMarkdown.FrontMatter -fieldName 'ResourceType' -fieldValue $ResourceType -addAfter 'ResourceId' -Overwrite

    #=================ResourceImport+=================
    if ( (Test-Path (Join-Path $hugoMarkdown.FolderPath "data.yaml" )) -or (Test-Path (Join-Path $hugoMarkdown.FolderPath "data.json" ))) {
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
                $urlSafeTitle = ($hugoMarkdown.FrontMatter.title -replace '[:\/\\*?"<>| #%.!,]', '-' -replace '\s+', '-').ToLower()
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

    if ($hugoMarkdown.FrontMatter.draft -ne $true -or ($hugoMarkdown.FrontMatter.ResourceType -eq "videos" -and $hugoMarkdown.FrontMatter.isShort -ne $true)) {
        # Do for Non-Draft items only      

        #================Themes, Categories, & TAGS==========================
        $BodyContent = $hugoMarkdown.BodyContent
        If ($hugoMarkdown.FrontMatter.ResourceType -eq "videos") {
            $captionsPath = Join-Path $hugoMarkdown.FolderPath "index.captions.en.md"
            if (Test-Path ($captionsPath )) {
                $BodyContent = Get-Content $captionsPath -Raw
            }
        }
        #-----------------Categories-------------------
        $categoryClassification = Get-CategoryConfidenceWithChecksum -ClassificationType "categories" -Catalog $categoriesCatalog -CacheFolder $hugoMarkdown.FolderPath -ResourceContent  $BodyContent -ResourceTitle $hugoMarkdown.FrontMatter.title -MaxCategories 3 
        $categories = $categoryClassification | ConvertFrom-Json | ForEach-Object { $_.category } | Sort-Object
        Update-StringList -frontMatter $hugoMarkdown.FrontMatter -fieldName 'categories' -values @($categories) -Overwrite
        #-----------------Tags-------------------
        $tagClassification = Get-CategoryConfidenceWithChecksum -ClassificationType "tags" -Catalog $tagsCatalog -CacheFolder $hugoMarkdown.FolderPath -ResourceContent  $BodyContent -ResourceTitle $hugoMarkdown.FrontMatter.title -MaxCategories 20
        $tags = $tagClassification | ConvertFrom-Json | ForEach-Object { $_.category } | Sort-Object
        Update-StringList -frontMatter $hugoMarkdown.FrontMatter -fieldName 'tags' -values @($tags) -Overwrite

    }
    # =================COMPLETE===================
    # =================CONTENT===================
    switch ($ResourceType) {
        "blog" { 
           
        }
        "podcast" { 
                
        }
        "videos" { 
            if ($hugoMarkdown.FrontMatter.Contains('canonicalURL')) {
                if ( (Test-Path (Join-Path $hugoMarkdown.FolderPath "index.captions.en.md" ))) {
                    $transcript = Get-Content -Path (Join-Path $hugoMarkdown.FolderPath "index.captions.en.md" ) -Raw
                    $content = Get-NewPostBasedOnTranscript -ResourceTranscript $transcript
                    $newTitle = Get-NewTitleBasedOnContent -Content $content
                    $newDescription = Get-NewDescriptionBasedOnContent -Content $content
                    If ($content -ne $null) {
                        $hugoMarkdown.BodyContent = $content
                        Remove-Field -frontMatter $hugoMarkdown.FrontMatter -fieldName 'canonicalUrl'
                        Update-Field -frontMatter $hugoMarkdown.FrontMatter -fieldName 'title' -fieldValue $newTitle -Overwrite
                        Update-Field -frontMatter $hugoMarkdown.FrontMatter -fieldName 'description' -fieldValue $newDescription -Overwrite
                        $hugoMarkdown.FrontMatter.sitemap.priority = 0.6
                    }
                }
            }
        }
        default { 
                
        }
    }
    # =================COMPLETE===================
    Save-HugoMarkdown -hugoMarkdown $hugoMarkdown -Path $hugoMarkdown.FilePath

    # Track count of ResourceType
    if ($resourceTypeCounts.ContainsKey($ResourceType)) {
        $resourceTypeCounts[$ResourceType]++
    }
    else {
        $resourceTypeCounts[$ResourceType] = 1
    }
}
Write-Progress -id 1 -Completed
Write-DebugLog "All markdown files processed."
Write-DebugLog "--------------------------------------------------------"
Write-DebugLog "Summary of updated Resource Types:"
$resourceTypeCounts.GetEnumerator() | ForEach-Object { Write-DebugLog "$($_.Key): $($_.Value)" }