cls
# Helpers
. ./.powershell/_includes/LoggingHelper.ps1
. ./.powershell/_includes/OpenAI.ps1
. ./.powershell/_includes/HugoHelpers.ps1
. ./.powershell/_includes/ResourceHelpers.ps1
. ./.powershell/_includes/ClassificationHelpers.ps1

function Output-Classifications {
    param (
        [array]$classifications
    )
    if ($classifications.Count -eq 0) {
        Write-WarningLog "   |---No classifications match "
        return
    }
    foreach ($classification in $classifications) {
        Write-InfoLog "   |---$($classification.category) - $($classification.final_score) [A:$($classification.ai_alignment) D:$($classification.ai_depth) C:$($classification.ai_confidence) M:$($classification.ai_mentions)]"
    }    
}


$ErrorActionPreference = 'Stop'
$levelSwitch.MinimumLevel = 'Information'

$ResourceId = "KhKFVRcdbGo"
If ($lookup -eq $null) {
    Write-InfoLog "Lookup is null, creating it..."
    $hugoMarkdownObjects = Get-RecentHugoMarkdownResources -Path ".\site\content\resources" -YearsBack 10
    $lookup = Get-HugoMarkdownListAsHashTable -hugoMarkdownList $hugoMarkdownObjects 
}
else {
    Write-InfoLog "Lookup is not null, using existing one..."
}
$hugoMarkdown = $lookup[$ResourceId]

$categoryClassification = Get-ClassificationsForType -updateMissing -ClassificationType "categories" -hugoMarkdown $hugoMarkdown

Write-InfoLog "Classification: Category"
$categoryClassificationOrdered = Get-ClassificationOrderedList -minScore 70 -classifications $categoryClassification | Select-Object -First 3
Output-Classifications $categoryClassificationOrdered
Write-InfoLog "   |------------------------------------------------"
$remainingCategoryClassifications = $categoryClassification | Where-Object { $_.category -notin ($categoryClassificationOrdered | ForEach-Object { $_.category }) }
Output-Classifications $remainingCategoryClassifications

#-----------------Tags-------------------
$tagClassification = Get-ClassificationsForType -updateMissing -ClassificationType "tags" -hugoMarkdown $hugoMarkdown
Write-InfoLog "Classification: Tags"
$tagClassificationOrdered = Get-ClassificationOrderedList -minScore 80 -classifications $tagClassification | Select-Object -First 15
Output-Classifications $tagClassificationOrdered

Write-InfoLog "   |------------------------------------------------"
$remainingTagClassifications = $tagClassification | Where-Object { $_.category -notin ($tagClassificationOrdered | ForEach-Object { $_.category }) }
Output-Classifications $remainingTagClassifications
