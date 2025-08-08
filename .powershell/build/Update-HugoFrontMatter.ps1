
# Helpers
. ./.powershell/_includes/IncludesForAll.ps1

$levelSwitch.MinimumLevel = 'Information'
$ResourceCatalogue = @{}
$categoriesCatalog = Get-CatalogHashtable -Classification "categories"
$tagsCatalog = Get-CatalogHashtable -Classification "tags"

$descriptionDateWatermark = [DateTime]::Parse("2025-05-07T12:36:48Z")
$shortTitleDateWatermark = [DateTime]::Parse("2025-07-06T09:00:00Z")
$tldrDateWatermark = [DateTime]::Parse("2025-07-06T09:00:00Z")

$expensiveUpdatesWatermark = (Get-Date).ToUniversalTime().AddYears(-10)


# Date by which we remove all Aliases
$ResourceAliasExpiryDate = (Get-Date).Date.AddYears(-5)

Start-TokenServer

$hugoMarkdownObjects = @()
$hugoMarkdownObjects += Get-RecentHugoMarkdownResources -Path ".\site\content\resources\" -YearsBack 100
$hugoMarkdownObjects += Get-RecentHugoMarkdownResources -Path ".\site\content\capabilities\training-courses" -YearsBack 100
$hugoMarkdownObjects += Get-RecentHugoMarkdownResources -Path ".\site\content\capabilities\mentor-programs" -YearsBack 100

#$hugoMarkdownObjects += Get-RecentHugoMarkdownResources -Path ".\site\content\capabilities\" -YearsBack 100

Write-InformationLog "Processing ({count}) HugoMarkdown Objects." -PropertyValues ($hugoMarkdownObjects.Count)
### /FILTER hugoMarkdownObjects
### Convert hugoMarkdownObjects to queue
$hugoMarkdownQueue = New-Object System.Collections.Generic.Queue[HugoMarkdown]
$hugoMarkdownObjects | ForEach-Object {
    $hugoMarkdownQueue.Enqueue($_)
}
$Counter = 0
$TotalItems = $hugoMarkdownQueue.Count
$missingFromOrder = @()
while ($hugoMarkdownQueue.Count -gt 0) {
   
    $hugoMarkdown = $hugoMarkdownQueue.Dequeue()
    $Counter++
    $PercentComplete = ($Counter / $TotalItems) * 100
    #Write-Progress -id 1 -Activity $ActivityText -Status "Queue Item: $($hugoMarkdown.FrontMatter.date) | $($hugoMarkdown.FrontMatter.ResourceType) | $($hugoMarkdown.FrontMatter.title)" -PercentComplete $PercentComplete
    Write-DebugLog "--------------------------------------------------------"
    Write-InformationLog "Processing [Q1:$($Counter)/$TotalItems] {ResolvePath}" -PropertyValues  $(Resolve-Path -Path $hugoMarkdown.FolderPath -Relative)

    #=================CLEAN============================
    Remove-Field -frontMatter $hugoMarkdown.FrontMatter -fieldName 'id'


    #=================DATES=================
    if (-not $hugoMarkdown.FrontMatter.date) {
        $date = Get-Date -Format "yyyy-MM-ddT09:00:00Z"
        Update-Field -frontMatter $hugoMarkdown.FrontMatter -fieldName 'date' -fieldValue $date
    }
    switch ($ResourceType) {
        { $_ -in @("case-studies", "blog", "signals", "newsletters", "guides", "engineering-notes", "videos", "podcast") } { 
            if (-not $hugoMarkdown.FrontMatter.lastmod) {
                Update-Field -frontMatter $hugoMarkdown.FrontMatter -fieldName 'lastmod' -fieldValue $hugoMarkdown.FrontMatter.date
            }
        }
        default { 
            # do nothing
        } 
    }
    #=================/DATES=================



    if ([datetime]::Parse($hugoMarkdown.FrontMatter.date) -gt $expensiveUpdatesWatermark) {
        ## Expensive Commands that should only be run on recent content
        #=================description=================
        $descUpdateString = $hugoMarkdown.FrontMatter.Watermarks?.Description
        $descUpdateDate = if ($descUpdateString) { [DateTime]::Parse($descUpdateString) } else { [DateTime]::MinValue }
        if (-not $hugoMarkdown.FrontMatter.description -or $descUpdateDate -lt $descriptionDateWatermark) {
            try {
                # Generate a new description using OpenAI
                $promptText = Get-Prompt -PromptName "content-description.md" -Parameters @{
                    title    = $hugoMarkdown.FrontMatter.Title
                    abstract = "none"
                    content  = $hugoMarkdown.BodyContent
                }
                $description = Get-OpenAIResponse -Prompt $promptText
                $description = ($description -replace '\r', '').Trim()
            
                # Update the description in the front matter
                Update-Field -frontMatter $hugoMarkdown.FrontMatter -fieldName 'description' -fieldValue $description -Overwrite
                Update-Field -frontMatter $hugoMarkdown.FrontMatter -fieldName 'Watermarks.description' -fieldValue (Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ") -Overwrite
            }
            catch {
                throw "Error generating description: $_"
            }
       
        }
 
        ## TLDR
        $tldrUpdateString = $hugoMarkdown.FrontMatter.Watermarks?.TLDR
        $tldrUpdateDate = if ($tldrUpdateString) { [DateTime]::Parse($tldrUpdateString) } else { [DateTime]::MinValue }
        if (-not $hugoMarkdown.FrontMatter.tldr -or $tldrUpdateDate -lt $tldrDateWatermark) {
            try {
                # Generate a new description using OpenAI
                $promptText = Get-Prompt -PromptName "content-tldr.md" -Parameters @{
                    title    = $hugoMarkdown.FrontMatter.Title
                    abstract = "none"
                    content  = $hugoMarkdown.BodyContent
                }
                $tldr = Get-OpenAIResponse -Prompt $promptText
                # Update the description in the front matter
                Update-Field -frontMatter $hugoMarkdown.FrontMatter -fieldName 'tldr' -fieldValue $tldr -Overwrite
                Update-Field -frontMatter $hugoMarkdown.FrontMatter -fieldName 'Watermarks.tldr' -fieldValue (Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ") -Overwrite
            }
            catch {
                throw "Error generating tldr: $_"
            }
       
        }        

        ## Short Title
        $shortTitleUpdateString = $hugoMarkdown.FrontMatter.Watermarks?.short_title
        $shortTitleUpdateDate = if ($shortTitleUpdateString) { [DateTime]::Parse($shortTitleUpdateString) } else { Get-Date }
        if (-not $hugoMarkdown.FrontMatter.short_title -or $shortTitleUpdateDate -lt $shortTitleDateWatermark) {
            try {
                # Generate a new description using OpenAI
                $promptText = Get-Prompt -PromptName "content-short-title.md" -Parameters @{
                    maxchars = 40
                    title    = $hugoMarkdown.FrontMatter.Title
                    abstract = $hugoMarkdown.FrontMatter.description
                    slug     = $hugoMarkdown.FrontMatter.slug
                    content  = $hugoMarkdown.BodyContent
                }
                $shortTitle = Get-OpenAIResponse -Prompt $promptText
                # Update the short_title in the front matter
                Update-Field -frontMatter $hugoMarkdown.FrontMatter -fieldName 'short_title' -fieldValue $shortTitle -Overwrite
                Update-Field -frontMatter $hugoMarkdown.FrontMatter -fieldName 'Watermarks.short_title' -fieldValue (Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ") -Overwrite
            }
            catch {
                throw "Error generating short_title: $_"
            }
       
        }
    }

    #================CONVERT RESOUCE TO ITEM=================
    #  ItemId: sasadsadsad
    #  ItemType: blog
    #  ItemKind: resource
    #  ItemContentOrigin: human
    #  ItemImport: false
  


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

    Update-Field -frontMatter $hugoMarkdown.FrontMatter -fieldName 'ResourceId' -fieldValue $ResourceId

    #=================ResourceType=================
    $ResourceType = Get-ResourceType  -FilePath  $hugoMarkdown.FolderPath
    if ($null -eq $ResourceType) {
        $ResourceType = $hugoMarkdown.FrontMatter.type
    }
    Update-Field -frontMatter $hugoMarkdown.FrontMatter -fieldName 'ResourceType' -fieldValue $ResourceType -Overwrite
    #=================ResourceContentOrigin=================
    if ($hugoMarkdown.FrontMatter.Contains("ResourceContentOrigin")) {
        $ResourceContentOrigin = $hugoMarkdown.FrontMatter.ResourceContentOrigin
    }
    else {
        switch ($ResourceType) {
            "blog" { 
                if ([DateTime]::Parse($hugoMarkdown.FrontMatter.date) -gt [DateTime]::Parse("2018-01-01")) {
                    $ResourceContentOrigin = "hybrid"
                }
                else {
                    $ResourceContentOrigin = "human"
                }    
            }
            "videos" { 
                $ResourceContentOrigin = "ai"
            }
            default { 
                $ResourceContentOrigin = "human"
            }
        }
        Update-Field -frontMatter $hugoMarkdown.FrontMatter -fieldName 'ResourceContentOrigin' -fieldValue $ResourceContentOrigin
    }
    #=================ResourceImport+=================
    if ( (Test-Path (Join-Path $hugoMarkdown.FolderPath "data.yaml" )) -or (Test-Path (Join-Path $hugoMarkdown.FolderPath "data.json" ))) {
        $ResourceImport = $true
    }
    else {
        $ResourceImport = $false
    }
    Update-Field -frontMatter $hugoMarkdown.FrontMatter -fieldName 'ResourceImport' -fieldValue $ResourceImport -Overwrite
    if ($hugoMarkdown.FrontMatter.ResourceImport) {
        switch ($ResourceType) {
            "blog" { 
                Update-Field -frontMatter $hugoMarkdown.FrontMatter -fieldName 'ResourceImportSource' -fieldValue "Wordpress"
                If (([datetime]$hugoMarkdown.FrontMatter.date) -lt ([datetime]'2011-02-16')) {
                    Update-Field -frontMatter $hugoMarkdown.FrontMatter -fieldName 'ResourceImportOriginalSource' -fieldValue "GeeksWithBlogs" -Overwrite
                }
                else {
                    Update-Field -frontMatter $hugoMarkdown.FrontMatter -fieldName 'ResourceImportOriginalSource' -fieldValue "Wordpress" -Overwrite
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

    switch ($ResourceType) {
        "blog" {   
        }
        "videos" { 
                    
        }
        "signals" {
            Update-Field -frontMatter $hugoMarkdown.FrontMatter -fieldName 'layout' -fieldValue "signal" -Overwrite
        }
    }


    $slug = ($hugoMarkdown.FrontMatter.title -replace '[:\/\\\*\?"<>\|#%\.,!—&‘’“”;()\[\]\{\}\+=@^~`]', '-' `
            -replace '\s+', '-' `
            -replace '-{2,}', '-' `
    ).Trim('-. ').ToLower()

    $hugoSlugSimulation = ($hugoMarkdown.FrontMatter.title -replace '[^A-Za-z0-9._~]+', '-' -replace '-{2,}', '-' ).Trim('-').ToLower()
    if ($hugoMarkdown.FrontMatter.slug -ne $null -and -not $slug.Contains($hugoMarkdown.FrontMatter.slug)) {
        Update-Field -frontMatter $hugoMarkdown.FrontMatter -fieldName 'slug' -fieldValue $slug -Overwrite
    }
    

    # =================Add aliases===================
    $aliases = @()
   
    switch ($ResourceType) {
        "blog" { 
            If ($hugoSlugSimulation -ne $slug) {
                $aliases += "/resources/blog/$hugoSlugSimulation"
            }
        }
        "podcast" { 
        }
        "videos" { 
            If ($hugoSlugSimulation -ne $slug) {
                $aliases += "/resources/videos/$hugoSlugSimulation"
            }
        }
    }
    # Always add the ResourceId as an alias
    if ($hugoMarkdown.FrontMatter.Contains("ResourceId")) {
        $aliases += "/resources/$($hugoMarkdown.FrontMatter.ResourceId)"
    }
    if ([DateTime]$hugoMarkdown.FrontMatter.date -lt $ResourceAliasExpiryDate) {
        Update-StringList -frontMatter $hugoMarkdown.FrontMatter -fieldName 'aliases' -values $aliases -Overwrite
    }
    else {
        # You can change this branch if you want different behaviour, or leave it identical
        Update-StringList -frontMatter $hugoMarkdown.FrontMatter -fieldName 'aliases' -values $aliases
    }
    
    # =================Add aliasesArchive===================
    $aliasesArchive = @()
    $aliasesArchive += $hugoMarkdown.FrontMatter.aliases | Where-Object { $_ -notmatch $hugoMarkdown.FrontMatter.ResourceId }
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
    if ($null -ne $aliasesArchive -and $aliasesArchive -is [array] -and $aliasesArchive.Count -gt 0) {
        Update-StringList -frontMatter $hugoMarkdown.FrontMatter -fieldName 'aliasesArchive' -values $aliasesArchive
    }

    Remove-Field -frontMatter $hugoMarkdown.FrontMatter -fieldName 'aliasesFor404'

    # Interim save, before posible longer actions
    Save-HugoMarkdown -hugoMarkdown $hugoMarkdown -Path $hugoMarkdown.FilePath

    #================Themes, Categories, & TAGS==========================
    $BodyContent = $hugoMarkdown.BodyContent
    If ($hugoMarkdown.FrontMatter.ResourceType -eq "videos") {
        $captionsPath = Join-Path $hugoMarkdown.FolderPath "captions.en.md"
        if (Test-Path ($captionsPath )) {
            $BodyContent = Get-Content $captionsPath -Raw
        }
    }


    # =================CLASSIFICATION===================
    switch ($ResourceType) {
        { $_ -in @("videos", "podcast", "blog", "signals", "newsletters", "guides", "engineering-notes", "workshops", "recipes", "principles", "case-studies") } { 
            #-----------------Concepts-------------------
            $conceptsClassification = Get-ClassificationsForType -ClassificationType "concepts" -hugoMarkdown $hugoMarkdown
            $conceptsClassificationOrdered = Get-ClassificationOrderedList -minScore 80 -classifications $conceptsClassification | Select-Object -First 1
            $concepts = $conceptsClassificationOrdered | ForEach-Object { $_.category }
            Update-StringList -frontMatter $hugoMarkdown.FrontMatter -fieldName 'concepts' -values @($concepts) -Overwrite
            Save-HugoMarkdown -hugoMarkdown $hugoMarkdown -Path $hugoMarkdown.FilePath
            #-----------------Categories-------------------
            $categoryClassification = Get-ClassificationsForType -ClassificationType "categories" -hugoMarkdown $hugoMarkdown
            $categoryClassificationOrdered = Get-ClassificationOrderedList -minScore 75 -classifications $categoryClassification | Select-Object -First 3
            $categories = $categoryClassificationOrdered | ForEach-Object { $_.category }
            if ($categories.Count -eq 0) {
                $categories = @("Uncategorized")
            }
            Update-StringList -frontMatter $hugoMarkdown.FrontMatter -fieldName 'categories' -values @($categories) -Overwrite
            Save-HugoMarkdown -hugoMarkdown $hugoMarkdown -Path $hugoMarkdown.FilePath
            #-----------------Tags-------------------
            $tagClassification = Get-ClassificationsForType -ClassificationType "tags" -hugoMarkdown $hugoMarkdown
            $tagClassificationOrdered = Get-ClassificationOrderedList -minScore 80 -classifications $tagClassification | Select-Object -First 15
            $tags = $tagClassificationOrdered | ForEach-Object { $_.category }
            Update-StringList -frontMatter $hugoMarkdown.FrontMatter -fieldName 'tags' -values @($tags) -Overwrite
            Save-HugoMarkdown -hugoMarkdown $hugoMarkdown -Path $hugoMarkdown.FilePath
        }
        default { 
            # Do nothing

            Write-ErrorLog "We dont have a sitemap for this type of resource: $ResourceType" 
        }
    }
    # =================/CLASSIFICATION===================  


    
    # =================weight===================
    switch ($ResourceType) {
        { $_ -in @("videos", "podcast", "blog", "signals", "newsletters", "guides", "engineering-notes", "workshops", "recipes", "principles", "case-studies") } { 
            $eeResult = Get-Classification -CacheFolder $hugoMarkdown.FolderPath  -ClassificationName "Engineering Excellence"
            $tlResult = Get-Classification -CacheFolder $hugoMarkdown.FolderPath  -ClassificationName "Technical Leadership"
            $weight = [math]::Round(((1000 - ($eeResult.final_score * 10)) + (1000 - ($tlResult.final_score * 10))) / 2)
            Update-Field -frontMatter $hugoMarkdown.FrontMatter -fieldName 'weight' -fieldValue $weight -Overwrite
        }
        default { 
            # Do nothing

            Write-ErrorLog "We dont have a sitemap for this type of resource: $ResourceType" 
        }
    }
    # =================/weight===================
    # =================SITEMAP===================
    $sitemap = [ordered]@{
        filename   = "sitemap.xml"
        priority   = $hugoMarkdown.FrontMatter.sitemap?.priority ?? 0
        changefreq = "weekly"
    }
    $sitemap.priority = [math]::Round((1000 - $hugoMarkdown.FrontMatter.weight) / 999, 1)
    switch ($ResourceType) {
        { $_ -in @("videos", "podcast") } { 
            $sitemap.priority = $sitemap.priority - 0.2
            $sitemap.changefreq = "monthly"   
        }
        { $_ -in @("blog", "signals", "newsletters", "guides", "engineering-notes", "workshops", "recipes", "principles") } { 
            $sitemap.priority = $sitemap.priority - 0.1
            $sitemap.changefreq = "weekly"
        }
        { $_ -in @("case-studies") } { 
            $sitemap.changefreq = "monthly"
        }
        { $_ -in @("capabilities", "outcomes") } { 
            $sitemap.priority = 0.9
            $sitemap.changefreq = "weekly"
        }
        { $_ -in @("course", "mentor-program") } { 
            $sitemap.priority = 0.8
            $sitemap.changefreq = "weekly"
        }
        default { 
            # Do nothing
            $sitemap.priority = $sitemap.priority - 0.4
            Write-ErrorLog "We dont have a sitemap for this type of resource: $ResourceType" 
        }
    }
    $sitemap.priority = [math]::Max([math]::Round($sitemap.priority, 1), 0.1)
    Update-Field -frontMatter $hugoMarkdown.FrontMatter -fieldName 'sitemap' -fieldValue $sitemap -Overwrite
    # =================/SITEMAP===================
    # =================CONTENT===================
    switch ($ResourceType) {
        "blog" { 
           
        }
        "podcast" { 
                 
        }
        "videos" { 
            if ($hugoMarkdown.FrontMatter.Contains('canonicalURL')) {
                if ( (Test-Path (Join-Path $hugoMarkdown.FolderPath "captions.en.md" ))) {
                    $transcript = Get-Content -Path (Join-Path $hugoMarkdown.FolderPath "captions.en.md" ) -Raw
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
    # =================CONTENT===================
    #$hugoMarkdown.BodyContent = Update-ClassificationLinksInBodyContent -ClassificationType "categories" -hugoMarkdown $hugoMarkdown
    #$hugoMarkdown.BodyContent = Update-ClassificationLinksInBodyContent -ClassificationType "tags" -hugoMarkdown $hugoMarkdown
    # =================COMPLETE===================
    $list = @()
    $list += 'title'
    $list += 'short_title'
    $list += 'subtitle'
    $list += 'description'
    $list += 'abstract'
    $list += 'tldr'
    $list += 'date'
    $list += 'lastmod'
    $list += 'weight'
    $list += 'sitemap'
    $list += 'author'
    $list += 'contributors'
    $list += 'ResourceId'
    $list += 'ResourceImport'
    $list += 'ResourceType'
    $list += 'ResourceContentOrigin'
    $list += 'ResourceImportSource'
    $list += 'slug'
    $list += 'aliases'
    $list += 'aliasesArchive'
    $list += 'source'
    $list += 'layout'
    $list += 'type'
    $list += 'concepts'
    $list += 'categories'
    $list += 'tags'
    $list += 'platform_signals'
    $list += 'headlines'
    $list += 'sections'
    $list += 'card'
    $list += 'Watermarks'
    $missingFromOrder += Update-FieldPositions -data $hugoMarkdown.FrontMatter -orderedkeys $list
    $missingFromOrder = $missingFromOrder | Sort-Object -Unique

    Save-HugoMarkdown -hugoMarkdown $hugoMarkdown -Path $hugoMarkdown.FilePath

    
   
    #=================ResourceCatalogue=================
    if ($hugoMarkdown.FrontMatter.Contains("ResourceContentOrigin")) {
        $origin = $hugoMarkdown.FrontMatter.ResourceContentOrigin
        $ItemDate = [DateTime]::Parse($hugoMarkdown.FrontMatter.date)
        if ($origin -ne "AI" -and $ItemDate -gt $ResourceCatalogueCutoffDate) {
            $year = $ItemDate.ToString("yyyy")
            # Aggregate yearly content per ResourceType
            if (-not $ResourceCatalogue.ContainsKey($ResourceType)) {
                $ResourceCatalogue[$ResourceType] = @{}
            }
            if (-not $ResourceCatalogue[$ResourceType].ContainsKey($year)) {
                $ResourceCatalogue[$ResourceType][$year] = @()
            }
            $ResourceCatalogue[$ResourceType][$year] += $hugoMarkdown
        }
    }

}

#Write-Progress -id 1 -Completed
Write-DebugLog "All markdown files processed." 
Write-DebugLog "-------Missing Fields---------------------------------"
Write-DebugLog ($missingFromOrder -join ', ')
Write-DebugLog "-------------------------------------------------"

# Save the yearly aggregated content files per ResourceType
# Iterate over each ResourceType in the catalogue
foreach ($ResourceType in $ResourceCatalogue.Keys) {
    foreach ($year in $ResourceCatalogue[$ResourceType].Keys) {
        $directoryPath = [System.IO.Path]::Combine(".\.resources", $ResourceType)

        # Ensure the directory exists
        if (-not (Test-Path -Path $directoryPath -PathType Container)) {
            New-Item -Path $directoryPath -ItemType Directory -Force | Out-Null
        }

        foreach ($hugoMarkdown in $ResourceCatalogue[$ResourceType][$year]) {
            $date = [DateTime]::Parse($hugoMarkdown.FrontMatter.date)
            $slug = $hugoMarkdown.FrontMatter.slug
            $origin = ($hugoMarkdown.FrontMatter.ResourceContentOrigin).ToLower()

            # Ensure slug is formatted properly
            if (-not $slug) {
                $slug = $hugoMarkdown.FrontMatter.title -replace '[:\/\\*?"<>| #%.!,]', '-' -replace '\s+', '-'
            }

            # Save individual post file
            $SaveLocation = [System.IO.Path]::Combine($directoryPath, $year)
            if (-not (Test-Path -Path $SaveLocation -PathType Container)) {
                New-Item -Path $SaveLocation -ItemType Directory -Force | Out-Null
            }
            $SavedFile = [System.IO.Path]::Combine($SaveLocation, "$ResourceType.$($date.ToString("yyyy-MM-dd")).$slug.$origin.md")
            Save-HugoMarkdown -hugoMarkdown $hugoMarkdown -Path $SavedFile
        }

        # Save aggregated yearly content
        $yearlyFilePath = [System.IO.Path]::Combine($directoryPath, "$ResourceType.$year.json")
        $count = $ResourceCatalogue[$ResourceType][$year].Count
        $yearContent = $ResourceCatalogue[$ResourceType][$year] | ConvertTo-Json -Depth 10
        $tokens = Get-TokenCountFromServer -Content $yearContent
        Set-Content -Path $yearlyFilePath -Value $yearContent -Encoding UTF8
        Write-InfoLog "$ResourceType $year : {files}/{tokens} : {yearlyFilePath}" -PropertyValues $count, $tokens, $yearlyFilePath
    }
}

