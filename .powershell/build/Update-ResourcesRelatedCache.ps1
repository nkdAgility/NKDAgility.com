

# Helpers
. ./.powershell/_includes/IncludesForAll.ps1


$ErrorActionPreference = 'Stop'
$levelSwitch.MinimumLevel = 'Information'

###### TEST CODE BELOW HERE ######
# Parameters

Start-TokenServer
#$storageContext = New-AzStorageContext -SasToken $Env:AZURE_BLOB_STORAGE_SAS_TOKEN -StorageAccountName "nkdagilityblobs"
$hugoMarkdownObjects = @()
$hugoMarkdownObjects += Get-RecentHugoMarkdownResources -Path ".\site\content\resources\" -YearsBack 20
$hugoMarkdownObjects += Get-RecentHugoMarkdownResources -Path ".\site\content\tags\" -YearsBack 10
$hugoMarkdownObjects += Get-RecentHugoMarkdownResources -Path ".\site\content\categories\" -YearsBack 10
$hugoMarkdownObjects += Get-RecentHugoMarkdownResources -Path ".\site\content\concepts\" -YearsBack 10

# Update-EmbeddingRepository -HugoMarkdownObjects $hugoMarkdownObjects
#Update-RelatedRepository -HugoMarkdownObjects $hugoMarkdownObjects -ThrottleLimit 0
Write-DebugLog "--------------------------------------------------------"
Write-DebugLog "--------------------------------------------------------"

foreach ($HugoMarkdown in $hugoMarkdownObjects) {
    Write-DebugLog "Processing $($HugoMarkdown.ReferencePath)"
    $relatedWrapper = Get-RelatedFromHugoMarkdown -HugoMarkdown $HugoMarkdown
    $filteredRelated = $relatedWrapper.related | Where-Object { $_.Similarity -gt 0.6 }
    $relatedWrapper.related = $filteredRelated
    if ($relatedWrapper.related.Count -gt 0) {
        $relatedLocalCache = Join-Path $HugoMarkdown.FolderPath 'data.index.related.json'
        $relatedWrapper | ConvertTo-Json -Depth 10 | Set-Content $relatedLocalCache 
    }    
}

#$hugoMdObj = $hugoMarkdownObjects | Select-Object -First 1

#$stuff = Get-RelatedFromHugoMarkdown -HugoMarkdown $hugoMdObj

Write-DebugLog "All files checked."
