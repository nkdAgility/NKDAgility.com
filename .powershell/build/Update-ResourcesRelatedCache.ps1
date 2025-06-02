

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
    $filteredRelated = @()
    $filteredRelated += $relatedWrapper.related | Sort-Object Similarity -Descending | Where-Object { $_.EntryType -eq "Videos" } | Select-Object -First 5
    $filteredRelated += $relatedWrapper.related | Sort-Object Similarity -Descending | Where-Object { $_.EntryType -eq "blog" } | Select-Object -First 5
    $filteredRelated += $relatedWrapper.related | Sort-Object Similarity -Descending | Where-Object { $_.EntryType -eq "Signals" } | Select-Object -First 5
    $filteredRelated += $relatedWrapper.related | Sort-Object Similarity -Descending | Where-Object { $_.EntryType -eq "Guides" } | Select-Object -First 5
    $relatedWrapper.related = $filteredRelated  | Sort-Object Similarity -Descending
    if ($relatedWrapper.related.Count -gt 0) {
        $relatedLocalCache = Join-Path $HugoMarkdown.FolderPath 'data.index.related.json'
        $relatedWrapper | ConvertTo-Json -Depth 10 | Set-Content $relatedLocalCache 
        Write-DebugLog "Processing  $($HugoMarkdown.ReferencePath) [$($relatedWrapper.related.Count) related items found.]"
    }    
}

#$hugoMdObj = $hugoMarkdownObjects | Select-Object -First 1

#$stuff = Get-RelatedFromHugoMarkdown -HugoMarkdown $hugoMdObj

Write-DebugLog "All files checked."
