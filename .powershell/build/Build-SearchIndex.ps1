
# Helpers
. ./.powershell/_includes/LoggingHelper.ps1
. ./.powershell/_includes/OpenAI.ps1
. ./.powershell/_includes/HugoHelpers.ps1
. ./.powershell/_includes/ResourceHelpers.ps1
. ./.powershell/_includes/ClassificationHelpers.ps1

$ErrorActionPreference = 'Stop'
$levelSwitch.MinimumLevel = 'Information'
$hugoMarkdownObjects = @()
$hugoMarkdownObjects = Get-RecentHugoMarkdownResources -Path ".\site\content\resources" -YearsBack 10
$hugoMarkdownObjects += Get-RecentHugoMarkdownResources -Path ".\site\content\concepts" -YearsBack 10
$hugoMarkdownObjects += Get-RecentHugoMarkdownResources -Path ".\site\content\categories" -YearsBack 10
$hugoMarkdownObjects += Get-RecentHugoMarkdownResources -Path ".\site\content\tags" -YearsBack 10

Start-TokenServer
##############################################

$searchData = @();

Foreach ($hugoMarkdownObject in $hugoMarkdownObjects) {
    Write-InformationLog "Processing {Title}" -PropertyValues $hugoMarkdownObject.FrontMatter.title
    $categoryClassification = Get-ClassificationsForType -ClassificationType "categories" -hugoMarkdown $hugoMarkdownObject
    $categoryClassificationOrdered = Get-ClassificationOrderedList -minScore 75 -classifications $categoryClassification | Select-Object -First 3
    $tagClassification = Get-ClassificationsForType -ClassificationType "tags" -hugoMarkdown $hugoMarkdownObject
    $tagClassificationOrdered = Get-ClassificationOrderedList -minScore 80 -classifications $tagClassification | Select-Object -First 15
    $conceptsClassification = Get-ClassificationsForType -ClassificationType "concepts" -hugoMarkdown $hugoMarkdownObject
    $conceptsClassificationOrdered = Get-ClassificationOrderedList -minScore 80 -classifications $conceptsClassification | Select-Object -First 1
    # ResourceType: blog
    # ClassificationType: tags
    if ($hugoMarkdownObject.FrontMatter.PSObject.Properties.Name -contains 'ClassificationType' -and `
            -not [string]::IsNullOrEmpty($hugoMarkdownObject.FrontMatter.ClassificationType)) {
        $recordType = 'Categorisation'
        $recordKind = $hugoMarkdownObject.FrontMatter.ClassificationType
        $recordId = $hugoMarkdownObject.FrontMatter.title
        $recordPermalink = "/resources/" + $hugoMarkdownObject.FrontMatter.title.ToLower() -replace '\s+', '-'
    }
    else {
        $recordType = 'Resource'
        $recordKind = $hugoMarkdownObject.ResourceType
        $recordId = $hugoMarkdownObject.FrontMatter.resourceId
        $recordPermalink = "/resources/$($hugoMarkdownObject.FrontMatter.resourceId)"
    }

    $searchData += [PSCustomObject]@{
        title       = $hugoMarkdownObject.FrontMatter.title
        recordType  = $recordType
        recordKind  = $recordKind
        recordId    = $recordId
        url         = $hugoMarkdownObject.Url
        description = $hugoMarkdownObject.FrontMatter.description
        date        = $hugoMarkdownObject.FrontMatter.date
        keywords    = ($tagClassification + $categoryClassification + $conceptsClassificationOrdered | ForEach-Object { $_.Category } | Sort-Object -Unique) -join ', '
        concepts    = $conceptsClassificationOrdered | ForEach-Object {
            [PSCustomObject]@{
                name   = $_.category
                score  = $_.final_score
                reason = if ($_.reasoning_summary) { $_.reasoning_summary } else { $_.reasoning }
            }
        }
        categories  = $categoryClassificationOrdered | ForEach-Object {
            [PSCustomObject]@{
                name   = $_.category
                score  = $_.final_score
                reason = if ($_.reasoning_summary) { $_.reasoning_summary } else { $_.reasoning }
            }
        }
        tags        = $tagClassificationOrdered | ForEach-Object {
            [PSCustomObject]@{
                name   = $_.category
                score  = $_.final_score
                reason = if ($_.reasoning_summary) { $_.reasoning_summary } else { $_.reasoning }
            }
        }
    }
}
# Export to JSON
$index | ConvertTo-Json -Depth 10 | Set-Content -Path "./site/data/search-resource.json" -Encoding UTF8

Write-Host "Algolia index built successfully at ./public/algolia.json"

##############################################
Stop-TokenServer