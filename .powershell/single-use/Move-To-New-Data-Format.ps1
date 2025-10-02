# Helpers
. ./.powershell/_includes/IncludesForAll.ps1

$levelSwitch.MinimumLevel = 'Information'
$ResourceCatalogue = @{}
$categoriesCatalog = Get-CatalogHashtable -Classification "categories"
$tagsCatalog = Get-CatalogHashtable -Classification "tags"


$expensiveUpdatesWatermark = (Get-Date).ToUniversalTime().AddYears(-10)


# Date by which we remove all Aliases
$ResourceAliasExpiryDate = (Get-Date).Date.AddYears(-5)

Start-TokenServer

$hugoMarkdownObjects = @()
$hugoMarkdownObjects += Get-RecentHugoMarkdownResources -Path ".\site\content\" -YearsBack 100

Write-InformationLog "Processing ({count}) HugoMarkdown Objects." -PropertyValues ($hugoMarkdownObjects.Count)
### /FILTER hugoMarkdownObjects
### Convert hugoMarkdownObjects to queue
$hugoMarkdownQueue = New-Object System.Collections.Generic.Queue[HugoMarkdown]
$hugoMarkdownObjects | ForEach-Object {
    $hugoMarkdownQueue.Enqueue($_)
}
$Counter = 0
$TotalItems = $hugoMarkdownQueue.Count
while ($hugoMarkdownQueue.Count -gt 0) {
   
    $hugoMarkdown = $hugoMarkdownQueue.Dequeue()
    $Counter++
    $PercentComplete = ($Counter / $TotalItems) * 100
    #Write-Progress -id 1 -Activity $ActivityText -Status "Queue Item: $($hugoMarkdown.FrontMatter.date) | $($hugoMarkdown.FrontMatter.ResourceType) | $($hugoMarkdown.FrontMatter.title)" -PercentComplete $PercentComplete
    Write-DebugLog "--------------------------------------------------------"
    Write-InformationLog "Processing [Q1:$($Counter)/$TotalItems] {ResolvePath}" -PropertyValues  $(Resolve-Path -Path $hugoMarkdown.FolderPath -Relative)

    #=================CLEAN============================


    $ItemData = Update-ItemFrontMatterData -hugoMarkdown $hugoMarkdown
    $ItemType = $ItemData.ItemType
    $ItemKind = $ItemData.ItemKind
    $ItemId = $ItemData.ItemId
    Save-HugoMarkdown -hugoMarkdown $hugoMarkdown -Path $hugoMarkdown.FilePath

    # If the $hugoMarkdown.FolderPath contains a file called data.index.related.json then we need to move it to teh data folder under data/$ItemKind/$ItemType/$ItemId/related.json
    $relatedDataFile = Join-Path -Path $hugoMarkdown.FolderPath -ChildPath "data.index.related.json"
    if (Test-Path -Path $relatedDataFile) {
        $newRelatedDataFile = "site/data/$ItemKind/$ItemType/$ItemId/related.json"
        # Create directory structure if it doesn't exist
        $newRelatedDataDir = Split-Path -Path $newRelatedDataFile -Parent
        New-Item -ItemType Directory -Path $newRelatedDataDir -Force | Out-Null
        Move-Item -Path $relatedDataFile -Destination $newRelatedDataFile -Force
        Write-InformationLog "Moved related data to {RelatedDataFileNew}" -PropertyValues $newRelatedDataFile
    }
    # If the $hugoMarkdown.FolderPath contains a file called data.index.classifications.json then we need to move it to teh data folder under data/$ItemKind/$ItemType/$ItemId/classifications.json
    $classificationsDataFile = Join-Path -Path $hugoMarkdown.FolderPath -ChildPath "data.index.classifications.json"
    if (Test-Path -Path $classificationsDataFile) {
        $newClassificationsDataFile = "site/data/$ItemKind/$ItemType/$ItemId/classifications.json"
        # Create directory structure if it doesn't exist
        $newClassificationsDataDir = Split-Path -Path $newClassificationsDataFile -Parent
        New-Item -ItemType Directory -Path $newClassificationsDataDir -Force | Out-Null
        Move-Item -Path $classificationsDataFile -Destination $newClassificationsDataFile -Force
        Write-InformationLog "Moved classifications data to {ClassificationsDataFileNew}" -PropertyValues $newClassificationsDataFile
    }




    
   
}

#Write-Progress -id 1 -Completed
Write-DebugLog "All markdown files processed."
