
# Helpers
. ./.powershell/_includes/LoggingHelper.ps1
. ./.powershell/_includes/OpenAI.ps1
. ./.powershell/_includes/HugoHelpers.ps1
. ./.powershell/_includes/ResourceHelpers.ps1
. ./.powershell/_includes/ClassificationHelpers.ps1


$levelSwitch.MinimumLevel = 'Debug'

# Iterate through each blog folder and update markdown files
$outputDir = "site\content\resources\blog\2025"
$resources = $null
# Get list of directories and select the first 10
$resources = Get-ChildItem -Path $outputDir  -Recurse -Filter "index.md"  | Sort-Object { $_ } -Descending 
#$resources += Get-ChildItem -Path "site\content\capabilities\training-courses"  -Recurse -Include "index.md", "_index.md"  | Sort-Object { $_ } -Descending

$Counter = 1

$categoriesCatalog = Get-CatalogHashtable -Classification "categories"
$tagsCatalog = Get-CatalogHashtable -Classification "tags"

$ResourceCatalogue = @{}
$ResourceCatalogueCutoffDate = [DateTime]::Parse("2018-01-01")

Write-InformationLog "Loading ({count}) markdown files...." -PropertyValues $resources.Count
$resourceCount = $resources.Count
$progressStep = [math]::Ceiling($resourceCount / 10)  # Calculate step for 10% progress
$hugoMarkdownObjects = @()

$resources | ForEach-Object -Begin { $index = 0 } -Process {
    if (Test-Path $_) {
        $hugoMarkdown = Get-HugoMarkdown -Path $_
        $hugoMarkdownObjects += $hugoMarkdown
    }

    $index++
    if ($index % $progressStep -eq 0 -or $index -eq $resourceCount) {
        Write-InformationLog "Progress: $([math]::Round(($index / $resourceCount) * 100))% complete"
    }
}

$TotalItems = $hugoMarkdownObjects.Count
Write-InformationLog "Loaded ({count}) HugoMarkdown Objects." -PropertyValues $TotalItems
### FILTER hugoMarkdownObjects
$hugoMarkdownObjects = $hugoMarkdownObjects | Sort-Object { $_.FrontMatter.date } -Descending #| Select-Object -First 200 
$hugoMarkdownObjects = $hugoMarkdownObjects | Where-Object { 
    if ($_.FrontMatter.date) { 
        $date = [DateTime]::Parse($_.FrontMatter.date)
        return $date -gt $ResourceCatalogueCutoffDate
    }
    else {
        return $false  # Skip objects with null/empty dates
    }
} | Sort-Object { [DateTime]::Parse($_.FrontMatter.date) } -Descending


# Display the filtered results
#$hugoMarkdownObjects | Select-Object FrontMatter

Write-InformationLog "Processing ({count}) HugoMarkdown Objects." -PropertyValues ($hugoMarkdownObjects.Count)
### /FILTER hugoMarkdownObjects
### Convert hugoMarkdownObjects to queue
$hugoMarkdownQueue = New-Object System.Collections.Generic.Queue[HugoMarkdown]
$hugoMarkdownObjects | ForEach-Object {
    $hugoMarkdownQueue.Enqueue($_)
}
$hugoMarkdownBatchQueue = New-Object System.Collections.Generic.Queue[HugoMarkdown]
$Counter = 0
$TotalItems = $hugoMarkdownQueue.Count
Write-InfoLog "Initialise Batch Count..."
$batchesInProgress = 0# Get-OpenAIBatchesInProgress <----------------------------------------------
$batchOverage = 10
Write-InfoLog "Batches in Progress: {batchesInProgress}" -PropertyValues $batchesInProgress
$runBatchCheck = $false
$batchCheckCount = 0
$batchCheckCountMax = 0

while ($hugoMarkdownQueue.Count -gt 0 -or $hugoMarkdownBatchQueue.Count -gt 0) {
    if (($hugoMarkdownBatchQueue.Count -le $batchesInProgress)) {
        $runBatchCheck = $false
    }
    $ActivityText = "Processing [Q1:$($Counter)/$TotalItems][Q2:$($hugoMarkdownBatchQueue.count)/$batchesInProgress|$($hugoMarkdownBatchQueue.Count - $batchesInProgress - $batchOverage)]"
    Write-InformationLog $ActivityText 
    if ((($runBatchCheck -and $hugoMarkdownBatchQueue.Count -gt 0) -and $batchCheckCount -le $hugoMarkdownBatchQueue.Count) -or $hugoMarkdownQueue.Count -eq 0) {
        $hugoMarkdown = $hugoMarkdownBatchQueue.Dequeue()
        $batchCheckCount++
        Write-Progress -id 1 -Activity $ActivityText -Status "Batch Item: $($hugoMarkdown.FrontMatter.date) | $($hugoMarkdown.FrontMatter.ResourceType) | $($hugoMarkdown.FrontMatter.title)" -PercentComplete $PercentComplete
        Write-InfoLog "Processing Batch: {ResolvePath}" -PropertyValues  $(Resolve-Path -Path $hugoMarkdown.FolderPath -Relative)
        if ($batchCheckCount -ge $batchCheckCountMax) {
            Write-DebugLog "Checking Batch status..."
            $batchesInProgress = Get-OpenAIBatchesInProgress
            Write-InfoLog "Batch Status: [Queued:{queued}] [InProgress:{batchesInProgress}]" -PropertyValues ($hugoMarkdownBatchQueue.count), $batchesInProgress
            $runBatchCheck = $false
            $batchCheckCount = 0
            $batchCheckCountMax = 0
        }        
    }
    elseif ($hugoMarkdownQueue.Count -gt 0) {
        $hugoMarkdown = $hugoMarkdownQueue.Dequeue()
        $Counter++
        $PercentComplete = ($Counter / $TotalItems) * 100
        Write-Progress -id 1 -Activity $ActivityText -Status "Queue Item: $($hugoMarkdown.FrontMatter.date) | $($hugoMarkdown.FrontMatter.ResourceType) | $($hugoMarkdown.FrontMatter.title)" -PercentComplete $PercentComplete
        Write-DebugLog "--------------------------------------------------------"
        Write-InfoLog "Processing post: {ResolvePath}" -PropertyValues  $(Resolve-Path -Path $hugoMarkdown.FolderPath -Relative)
    }
    else {
        Write-DebugLog "Checking Batch status..."
        $batchesInProgress = Get-OpenAIBatchesInProgress
        Write-InfoLog "Batch Status: [Queued:{queued}] [InProgress:{batchesInProgress}]" -PropertyValues ($hugoMarkdownBatchQueue.count), $batchesInProgress
        continue
    }

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
    if ($null -eq $ResourceType) {
        $ResourceType = $hugoMarkdown.FrontMatter.type
    }
    Update-Field -frontMatter $hugoMarkdown.FrontMatter -fieldName 'ResourceType' -fieldValue $ResourceType -addAfter 'ResourceId' -Overwrite
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
        Update-Field -frontMatter $hugoMarkdown.FrontMatter -fieldName 'ResourceContentOrigin' -fieldValue $ResourceContentOrigin -addAfter 'ResourceType'
    }
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
    # =================Add aliasesArchive===================
    $aliasesArchive = @()
    $aliasesArchive += $hugoMarkdown.FrontMatter.aliases | Where-Object { $_ -notmatch $hugoMarkdown.FrontMatter.ResourceId }
    switch ($ResourceType) {
        "blog" { 
            if ($hugoMarkdown.FrontMatter.Contains("slug")) {
                $slug = $hugoMarkdown.FrontMatter.slug
                $aliasesArchive += "/$slug"
                $aliasesArchive += "/blog/$slug"
            }
            if ($hugoMarkdown.FrontMatter.Contains("title")) {
                $slug = $hugoMarkdown.FrontMatter.slug
                $urlSafeTitle = ($hugoMarkdown.FrontMatter.title -replace '[:\/\\*?"<>| #%.!,]', '-' -replace '\s+', '-').ToLower()
                if ($urlSafeTitle -ne $slug) {
                    $aliasesArchive += "/$urlSafeTitle"
                    $aliasesArchive += "/blog/$urlSafeTitle"
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
    if ($null -ne $aliasesArchive -and $aliasesArchive -is [array] -and $aliasesArchive.Count -gt 0) {
        Update-StringList -frontMatter $hugoMarkdown.FrontMatter -fieldName 'aliasesArchive' -values $aliasesArchive -addAfter 'aliases'
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
    #-----------------marketing-------------------
    # $marketingClassification = Get-CategoryConfidenceWithChecksum -ClassificationType "marketing" -Catalog $marketingCatalog -CacheFolder $hugoMarkdown.FolderPath -ResourceContent  $BodyContent -ResourceTitle $hugoMarkdown.FrontMatter.title -MaxCategories 3 
    # $categories = $marketingClassification | ConvertFrom-Json | ForEach-Object { $_.category } #| Sort-Object
    # Update-StringList -frontMatter $hugoMarkdown.FrontMatter -fieldName 'marketing' -values @($categories) -Overwrite
    #-----------------Categories-------------------
    $categoryClassification = Get-ClassificationsForType -updateMissing -ClassificationType "categories" -hugoMarkdown $hugoMarkdown
    $categoryClassificationOrdered = Get-ClassificationOrderedList -minScore 75 -classifications $categoryClassification | Select-Object -First 3
    $categories = $categoryClassificationOrdered | ForEach-Object { $_.category }
    Update-StringList -frontMatter $hugoMarkdown.FrontMatter -fieldName 'categories' -values @($categories) -Overwrite
    #-----------------Tags-------------------
    $tagClassification = Get-ClassificationsForType -updateMissing -ClassificationType "tags" -hugoMarkdown $hugoMarkdown
    $tagClassificationOrdered = Get-ClassificationOrderedList -minScore 75 -classifications $tagClassification | Select-Object -First 20
    $tags = $tagClassificationOrdered | ForEach-Object { $_.category }
    Update-StringList -frontMatter $hugoMarkdown.FrontMatter -fieldName 'tags' -values @($tags) -Overwrite
    #-----------------catalog_full------------------
    # $keywordsClassification = Get-ClassificationsForType -ClassificationType "catalog_full" -hugoMarkdown $hugoMarkdown
    # $keywordsClassificationOrdered = Get-ClassificationOrderedList -minScore 80 -classifications $keywordsClassification | Select-Object -First 3
    # $keywords = $keywordsClassificationOrdered | ForEach-Object { $_.category }
    # Update-StringList -frontMatter $hugoMarkdown.FrontMatter -fieldName 'keywords' -values @($keywords) -addAfter "title" -Overwrite
    # =================COMPLETE===================

    $eeResult = Get-Classification -CacheFolder $hugoMarkdown.FolderPath  -ClassificationName "Engineering Excellence"
    $tlResult = Get-Classification -CacheFolder $hugoMarkdown.FolderPath  -ClassificationName "Technical Leadership"
    $weight = [math]::Round(((1000 - ($eeResult.final_score * 10)) + (1000 - ($tlResult.final_score * 10))) / 2)
    Update-Field -frontMatter $hugoMarkdown.FrontMatter -fieldName 'weight' -fieldValue $weight -addAfter 'date' -Overwrite
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
    $hugoMarkdown.BodyContent = Update-ClassificationLinksInBodyContent -ClassificationType "categories" -hugoMarkdown $hugoMarkdown
    $hugoMarkdown.BodyContent = Update-ClassificationLinksInBodyContent -ClassificationType "tags" -hugoMarkdown $hugoMarkdown
    # =================COMPLETE===================
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

    #=================Batch=================  
    # If there are any batches for this item add it to the batch queue for reprocessing
    $resources = Get-ChildItem -Path $hugoMarkdown.FolderPath  -Recurse -Filter "*.batch"
    if ($resources.Count -gt 0) {
        $hugoMarkdownBatchQueue.Enqueue($hugoMarkdown)
        if ((($hugoMarkdownBatchQueue.Count) -gt $batchesInProgress) -and $runBatchCheck -eq $false) {
            Write-DebugLog "Checking Batch status..."
            $batchesInProgress = Get-OpenAIBatchesInProgress
            Write-InfoLog "Batch Status: [Queued:{queued}] [InProgress:{batchesInProgress}]" -PropertyValues ($hugoMarkdownBatchQueue.count), $batchesInProgress
        }
        if (($hugoMarkdownBatchQueue.Count - $batchesInProgress) -gt $batchOverage) {
            $runBatchCheck = $true
            $batchCheckCountMax = $hugoMarkdownBatchQueue.Count
        }
    }
}

Write-Progress -id 1 -Completed
Write-DebugLog "All markdown files processed." 
Write-DebugLog "--------------------------------------------------------"

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
        $yearlyFilePath = [System.IO.Path]::Combine($directoryPath, "$ResourceType.$year.yaml")
        $count = $ResourceCatalogue[$ResourceType][$year].Count
        $yearContent = $ResourceCatalogue[$ResourceType][$year] | ConvertTo-Yaml
        $tokens = Get-TokenCount -Content $yearContent
        Set-Content -Path $yearlyFilePath -Value $yearContent -Encoding UTF8
        Write-InfoLog "$ResourceType $year : {files}/{tokens} : {yearlyFilePath}" -PropertyValues $count, $tokens, $yearlyFilePath
    }
}

