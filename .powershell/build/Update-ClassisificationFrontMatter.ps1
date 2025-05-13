
# Helpers
. ./.powershell/_includes/LoggingHelper.ps1
. ./.powershell/_includes/TokenServer.ps1
. ./.powershell/_includes/OpenAI.ps1
. ./.powershell/_includes/HugoHelpers.ps1
. ./.powershell/_includes/ResourceHelpers.ps1
. ./.powershell/_includes/ClassificationHelpers.ps1
. ./.powershell/_includes/PromptManager.ps1


$levelSwitch.MinimumLevel = 'Debug'

# Get list of directories and select the first 10
$classes = @();
$classes += Get-ChildItem -Path ".\site\content\concepts\" -Recurse -Filter "_index.md" | Sort-Object { $_ } -Descending | Select-Object -First 300 
$classes += Get-ChildItem -Path ".\site\content\tags\" -Recurse -Filter "_index.md" | Sort-Object { $_ } -Descending | Select-Object -First 300 
$classes += Get-ChildItem -Path ".\site\content\categories\" -Recurse -Filter "_index.md" | Sort-Object { $_ } -Descending | Select-Object -First 300 
$hugoMarkdownList = @()
$classes | ForEach-Object { 
    $hugoMarkdown = Get-HugoMarkdown -Path $_.FullName
    $hugoMarkdownList += $hugoMarkdown
}


$distinctClassificationTypes = $hugoMarkdownList |
ForEach-Object { $_.FrontMatter.ClassificationType } |
Sort-Object -Unique

$classificationPeers = @{}

foreach ($type in $distinctClassificationTypes) {
    $peers = $hugoMarkdownList |
    Where-Object { $_.FrontMatter.ClassificationType -eq $type } |
    ForEach-Object { $_.FrontMatter.Title } |
    Sort-Object

    $classificationPeers[$type] = $peers -join ', '
}
$classificationPeers | ConvertTo-Json -Depth 5 | Set-Content -Path ".\.resources\classificationPeers.json" -Encoding UTF8

######################################################

$classificationHierarchy = @{}
$concepts = $hugoMarkdownList | Where-Object {
    $_.FrontMatter.ClassificationType -in @('concepts')
}

Start-TokenServer

foreach ($concept in $concepts) {
    $conceptName = $concept.FrontMatter.title  # This assumes the "Title" field is set correctly for each item
    # Ensure that the concept exists in the structure
    if (-not $classificationHierarchy.ContainsKey($conceptName)) {
        $classificationHierarchy[$conceptName] = @{
            "tags"       = @()
            "categories" = @()
        }
    }
    $items = $hugoMarkdownList | Where-Object {
        $_.FrontMatter.concepts -ne $null -and $_.FrontMatter.concepts.Contains($conceptName)
    }    
    foreach ($item in $items) {
        $classificationType = $item.FrontMatter.ClassificationType  # This assumes the "ClassificationType" field is set correctly for each item
        $classificationHierarchy[$conceptName].$classificationType += $item.FrontMatter.title
    }       
    
}

# Convert the resulting hierarchical structure into JSON format and write to file
$classificationHierarchy | ConvertTo-Json -Depth 5 | Set-Content -Path ".\.resources\classificationHierarchy.json" -Encoding UTF8

########################################


$ResourceCatalogue = @{};

# Total count for progress tracking
$TotalFiles = $hugoMarkdownList.Count
$Counter = 0

# $hugoMarkdownList = @($hugoMarkdownList | Where-Object { $_.FrontMatter.title -eq "Deployment Frequency" })

foreach ($hugoMarkdown in $hugoMarkdownList) {
    if ($hugoMarkdown.FrontMatter.ignore) {
        Write-InfoLog "Skipping post: $(Resolve-Path -Path $hugoMarkdown.FilePath -Relative)"
        $Counter++
        continue
    }
    $Counter++
    $PercentComplete = ($Counter / $TotalFiles) * 100
    $markdownFile = $hugoMarkdown.FilePath

    Write-InfoLog "--------------------------------------------------------"
    Write-InfoLog "Processing post: $(Resolve-Path -Path $markdownFile -Relative)"
    $peerTitleList = ($hugoMarkdownList | Where-Object { $_.FrontMatter.ClassificationType -eq $hugoMarkdown.FrontMatter.ClassificationType -and $_.FrontMatter.Title -ne $hugoMarkdown.FrontMatter.Title } | ForEach-Object { $_.FrontMatter.Title } | Sort-Object) -join ', '

    Write-Progress -id 1 -Activity "Processing Markdown Files" -Status "Processing $Counter ('$($hugoMarkdown.FrontMatter.title)') of $TotalFiles" -PercentComplete $PercentComplete

        
    Update-Field -frontMatter $hugoMarkdown.FrontMatter -fieldName 'trustpilot' -fieldValue $false -addAfter 'title' 

    $ClassificationType = "Classification"
    $ClassificationType = Split-Path $hugoMarkdown.FolderPath -Parent | Split-Path -Leaf
    Update-Field -frontMatter $hugoMarkdown.FrontMatter -fieldName 'ClassificationType' -fieldValue $ClassificationType -addAfter 'title' -Overwrite

    #=================description=================
    if (-not $hugoMarkdown.FrontMatter.abstract) {
        # Generate a new description using OpenAI
        $prompt = Get-Prompt -PromptName "classification-abstract.md" -Parameters @{
            title   = $hugoMarkdown.FrontMatter.title
            content = $hugoMarkdown.BodyContent
        }
        $abstract = Get-OpenAIResponse -Prompt $prompt
        # Update the description in the front matter
        Update-Field -frontMatter $hugoMarkdown.FrontMatter -fieldName 'abstract' -fieldValue $abstract -addAfter 'title' 
    }

    if (-not $hugoMarkdown.FrontMatter.description -or $hugoMarkdown.FrontMatter.description -match "no specific details provided" -or $hugoMarkdown.FrontMatter.description.Length -gt 180) {
        # Generate a new description using OpenAI
        $prompt = Get-Prompt -PromptName "classification-description.md" -Parameters @{
            title    = $hugoMarkdown.FrontMatter.title
            abstract = $hugoMarkdown.FrontMatter.abstract
            content  = $hugoMarkdown.BodyContent
        }
        $description = Get-OpenAIResponse -Prompt $prompt
        # Update the description in the front matter
        Update-Field -frontMatter $hugoMarkdown.FrontMatter -fieldName 'description' -fieldValue $description -addAfter 'title' 
    }
    if (-not $hugoMarkdown.FrontMatter.Instructions) {
        # Generate a new Instructions using OpenAI
        $prompt = Get-Prompt -PromptName "classification-instructions.md" -Parameters @{
            title    = $hugoMarkdown.FrontMatter.title
            abstract = $hugoMarkdown.FrontMatter.abstract
            content  = $hugoMarkdown.BodyContent
        }
        $Instructions = Get-OpenAIResponse -Prompt $prompt
        # Update the description in the front matter
        Update-Field -frontMatter $hugoMarkdown.FrontMatter -fieldName 'Instructions' -fieldValue $Instructions -addAfter 'description' -Overwrite
        Update-Field -frontMatter $hugoMarkdown.FrontMatter -fieldName 'date' -fieldValue (Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ") -addAfter 'title' 
    } 
    if (-not $hugoMarkdown.FrontMatter.headline -or (([datetime]$hugoMarkdown.FrontMatter.headline.updated) -lt ([datetime]::Parse("2025-02-13T11:58:02Z")))) {
        $classificationTitlePrompt = Get-Prompt -PromptName "classification-headline-title.md" -Parameters @{
            title    = $hugoMarkdown.FrontMatter.title
            abstract = $hugoMarkdown.FrontMatter.abstract
            content  = $hugoMarkdown.BodyContent
        }
        $ClassificationTitle = Get-OpenAIResponse -Prompt $classificationTitlePrompt

        $classificationHeadlinePrompt = Get-Prompt -PromptName "classification-headline-subtitle.md" -Parameters @{
            title    = $hugoMarkdown.FrontMatter.title
            abstract = $hugoMarkdown.FrontMatter.abstract
            content  = $hugoMarkdown.BodyContent
        }
        $ClassificationHeadline = Get-OpenAIResponse -Prompt $classificationHeadlinePrompt
            
        $classificationDescriptionPrompt = Get-Prompt -PromptName "classification-headline-description.md" -Parameters @{
            title    = $hugoMarkdown.FrontMatter.title
            abstract = $hugoMarkdown.FrontMatter.abstract
            content  = $hugoMarkdown.BodyContent
        }
        $ClassificationDescription = Get-OpenAIResponse -Prompt $classificationDescriptionPrompt

        $headline = [ordered]@{
            cards    = @()
            title    = $ClassificationTitle
            subtitle = $ClassificationHeadline
            content  = $ClassificationDescription
            updated  = (Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ")
        }
        Update-Field -frontMatter $hugoMarkdown.FrontMatter -fieldName 'headline' -fieldValue  $headline -addAfter 'Instructions' -Overwrite
    }

    # =================CONTENT====================
    
    $classificationContentPrompt = get-Prompt -PromptName "classification-content.md" -Parameters @{
        title              = $hugoMarkdown.FrontMatter.title
        abstract           = $hugoMarkdown.FrontMatter.abstract
        content            = $hugoMarkdown.BodyContent
        classificationType = $hugoMarkdown.FrontMatter.ClassificationType
        peerTitleList      = $peerTitleList
        instructions       = $hugoMarkdown.Instructions
    }
    
    # =================COMPLETE===================
    Save-HugoMarkdown -hugoMarkdown $hugoMarkdown -Path $markdownFile 
        
    if (-not $hugoMarkdown.BodyContent) {
        $ClassificationContent = Get-OpenAIResponse -Prompt $classificationContentPrompt

        $hugoMarkdown.BodyContent = $ClassificationContent
        $updateDate = Get-Date -Format "yyyy-MM-ddTHH:mm:ss"
        Update-Field -frontMatter $hugoMarkdown.FrontMatter -fieldName 'BodyContentGenDate' -fieldValue $updateDate -Overwrite
        Update-Field -frontMatter $hugoMarkdown.FrontMatter -fieldName 'ClassificationContentOrigin' -fieldValue "AI" -addAfter 'ClassificationType'
    }

    if ($hugoMarkdown.BodyContent) {
        $priority = 0.7
    }
    else {
        $priority = 0.5
    }                 
    $hugoMarkdown.FrontMatter["sitemap"] = [ordered]@{ filename = "sitemap.xml"; priority = $priority }  # Update sitemap filename

    if ($hugoMarkdown.BodyContent -and $hugoMarkdown.FolderPath -notlike "*concepts*") {
        $typesClassification = Get-ClassificationsForType -ClassificationType "concepts" -hugoMarkdown $hugoMarkdown
        $typesClassificationOrdered = @(Get-ClassificationOrderedList -minScore 60 -classifications $typesClassification | Select-Object -First 1)
        $types = $typesClassificationOrdered | Where-Object { $_.category -ne $hugoMarkdown.FrontMatter.Title } | ForEach-Object { $_.category }
        Update-StringList -frontMatter $hugoMarkdown.FrontMatter -fieldName 'concepts' -values @($types) -Overwrite
        Save-HugoMarkdown -hugoMarkdown $hugoMarkdown -Path $hugoMarkdown.FilePath
    }
    if ($hugoMarkdown.BodyContent -and $hugoMarkdown.FolderPath -notlike "*concepts*" -and $hugoMarkdown.FolderPath -notlike "*categories*") {
        # Categroies
        $categoryClassification = Get-ClassificationsForType -ClassificationType "categories" -hugoMarkdown $hugoMarkdown
        $categoryClassificationOrdered = Get-ClassificationOrderedList -minScore 75 -classifications $categoryClassification | Select-Object -First 3
        $categories = $categoryClassificationOrdered | Where-Object { $_.category -ne $hugoMarkdown.FrontMatter.Title } | ForEach-Object { $_.category }
        Update-StringList -frontMatter $hugoMarkdown.FrontMatter -fieldName 'categories' -values @($categories) -Overwrite
        Save-HugoMarkdown -hugoMarkdown $hugoMarkdown -Path $hugoMarkdown.FilePath
        # Tags
        $tagClassification = Get-ClassificationsForType -ClassificationType "tags" -hugoMarkdown $hugoMarkdown
        $tagClassificationOrdered = Get-ClassificationOrderedList -minScore 80 -classifications $tagClassification | Select-Object -First 15
        $tags = $tagClassificationOrdered | Where-Object { $_.category -ne $hugoMarkdown.FrontMatter.Title } | ForEach-Object { $_.category }
        Update-StringList -frontMatter $hugoMarkdown.FrontMatter -fieldName 'tags' -values @($tags) -Overwrite
        Save-HugoMarkdown -hugoMarkdown $hugoMarkdown -Path $hugoMarkdown.FilePath
    }


    $eeResult = Get-Classification -CacheFolder $hugoMarkdown.FolderPath  -ClassificationName "Engineering Excellence"
    $tlResult = Get-Classification -CacheFolder $hugoMarkdown.FolderPath  -ClassificationName "Technical Leadership"
    $weight = [math]::Round(((1000 - ($eeResult.final_score * 10)) + (1000 - ($tlResult.final_score * 10))) / 2)
    if ($weight -eq 0) {
        $weight = 1000
    }
    Update-Field -frontMatter $hugoMarkdown.FrontMatter -fieldName 'weight' -fieldValue $weight -addAfter 'date' -Overwrite

    # =================COMPLETE===================
    Save-HugoMarkdown -hugoMarkdown $hugoMarkdown -Path $markdownFile 

    if ($hugoMarkdown.BodyContent) {
        #=================ResourceCatalogue=================
        # Aggregate yearly content per ResourceType
        $classificationType = Split-Path -Path (Split-Path -Path (Split-Path -Path $hugoMarkdown.FilePath -Parent) -Parent) -Leaf
        if (-not $ResourceCatalogue.Contains($classificationType)) {
            $ResourceCatalogue[$classificationType] = @()
        }
        $ResourceCatalogue[$classificationType] += $hugoMarkdown
    }

}

Write-Progress -id 1 -Completed
Write-InfoLog "All markdown files processed."
Write-InfoLog "--------------------------------------------------------"

# Iterate over each ResourceType in the catalogue
foreach ($ResourceType in $ResourceCatalogue.Keys) {
    
    $directoryPath = [System.IO.Path]::Combine(".\.resources", $ResourceType)
    # Ensure the directory exists
    if (-not (Test-Path -Path $directoryPath -PathType Container)) {
        New-Item -Path $directoryPath -ItemType Directory -Force | Out-Null
    }

    foreach ($hugoMarkdown in $ResourceCatalogue[$ResourceType]) {
        $slug = $hugoMarkdown.FrontMatter.slug

        # Ensure slug is formatted properly
        if (-not $slug) {
            $slug = $hugoMarkdown.FrontMatter.title -replace '[:\/\\*?"<>| #%.!,]', '-' -replace '\s+', '-'
        }

        # Save individual post file
        $SaveLocation = [System.IO.Path]::Combine($directoryPath)
        if (-not (Test-Path -Path $SaveLocation -PathType Container)) {
            New-Item -Path $SaveLocation -ItemType Directory -Force | Out-Null
        }
        $SavedFile = [System.IO.Path]::Combine($SaveLocation, "$ResourceType.$slug.$origin.md")
        Save-HugoMarkdown -hugoMarkdown $hugoMarkdown -Path $SavedFile
    }

    # Save aggregated  content
    $FilePath = [System.IO.Path]::Combine($directoryPath, "$ResourceType.yaml")
    $count = $ResourceCatalogue[$ResourceType].Count
    $Content = $ResourceCatalogue[$ResourceType] | ConvertTo-Yaml
    $tokens = Get-TokenCountFromServer -Content $Content
    Set-Content -Path $FilePath -Value $Content -Encoding UTF8
    Write-InfoLog "$ResourceType : {files}/{tokens} : {yearlyFilePath}" -PropertyValues $count, $tokens, $FilePath
  
}

Stop-TokenServer