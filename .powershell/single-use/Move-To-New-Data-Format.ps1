
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

    
   
}

#Write-Progress -id 1 -Completed
Write-DebugLog "All markdown files processed." 
