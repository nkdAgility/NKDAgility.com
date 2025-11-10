

# Helpers
. ./.powershell/_includes/IncludesForAll.ps1


$ErrorActionPreference = 'Stop'
$levelSwitch.MinimumLevel = 'Information'

###### TEST CODE BELOW HERE ######
# Parameters

Start-TokenServer
#$storageContext = New-AzStorageContext -SasToken $Env:AZURE_BLOB_STORAGE_SAS_TOKEN -StorageAccountName "nkdagilityblobs"
$hugoMarkdownObjects = @()
$hugoMarkdownObjects += Get-RecentHugoMarkdownResources -Path ".\site\content\capabilities\" -YearsBack 100
$hugoMarkdownObjects += Get-RecentHugoMarkdownResources -Path ".\site\content\outcomes\" -YearsBack 100
$hugoMarkdownObjects += Get-RecentHugoMarkdownResources -Path ".\site\content\tags\" -YearsBack 100
$hugoMarkdownObjects += Get-RecentHugoMarkdownResources -Path ".\site\content\categories\" -YearsBack 100
$hugoMarkdownObjects += Get-RecentHugoMarkdownResources -Path ".\site\content\concepts\" -YearsBack 100
$hugoMarkdownObjects += Get-RecentHugoMarkdownResources -Path ".\site\content\resources\" -YearsBack 100

$hugoMarkdownObjectsSorted = $hugoMarkdownObjects | Sort-Object { $_.FrontMatter.weight } | Where-Object { $_.FrontMatter.ignore -eq $false -or $_.FrontMatter.ignore -eq $null }


#Update-EmbeddingRepository -HugoMarkdownObjects $hugoMarkdownObjectsSorted
#Update-RelatedRepository -HugoMarkdownObjects $hugoMarkdownObjectsSorted -ThrottleLimit 12
Write-DebugLog "--------------------------------------------------------"
Write-DebugLog "--------------------------------------------------------"

$totalCount = $hugoMarkdownObjects.Count
$currentIndex = 0

pause

foreach ($HugoMarkdown in $hugoMarkdownObjectsSorted) {
    $currentIndex++
    $percentComplete = [math]::Round(($currentIndex / $totalCount) * 100, 2)
    $progress = "[$currentIndex|$totalCount]"
    Write-Progress -Activity "Processing $progress Hugo Markdown Objects" -Status "Processing: $($HugoMarkdown.ReferencePath)" -PercentComplete $percentComplete -CurrentOperation "$currentIndex of $totalCount"
    Write-DebugLog "Processing $($HugoMarkdown.ReferencePath)"
    $relatedWrapper = Get-RelatedFromHugoMarkdown -HugoMarkdown $HugoMarkdown
    $filteredRelated = @()
    $filteredRelated += $relatedWrapper.related | Sort-Object Similarity -Descending | Where-Object { $_.EntryType -eq "Videos" } | Select-Object -First 5
    $filteredRelated += $relatedWrapper.related | Sort-Object Similarity -Descending | Where-Object { $_.EntryType -eq "blog" } | Select-Object -First 5
    $filteredRelated += $relatedWrapper.related | Sort-Object Similarity -Descending | Where-Object { $_.EntryType -eq "Signals" } | Select-Object -First 5
    $filteredRelated += $relatedWrapper.related | Sort-Object Similarity -Descending | Where-Object { $_.EntryType -eq "Guides" } | Select-Object -First 5
    $filteredRelated += $relatedWrapper.related | Sort-Object Similarity -Descending | Where-Object { $_.EntryType -eq "course" } | Select-Object -First 5

    $capabilities = $relatedWrapper.related | Sort-Object Similarity -Descending | Where-Object { $_.EntryType -eq "capabilities" } | Select-Object -First 5
    if ($capabilities.count -eq 0) {
        Write-InformationLog "No capabilities found for $($HugoMarkdown.ReferencePath)"
    }
    $filteredRelated += $capabilities
    $filteredRelated += $relatedWrapper.related | Sort-Object Similarity -Descending | Where-Object { $_.EntryType -eq "outcomes" } | Select-Object -First 5
    $relatedWrapper.related = $filteredRelated  | Sort-Object Similarity -Descending
    if ($relatedWrapper.related.Count -gt 0) {
        $relatedLocalCache = "site/data/$($HugoMarkdown.FrontMatter.ItemKind)/$($HugoMarkdown.FrontMatter.ItemType)/$($HugoMarkdown.FrontMatter.ItemId)/related.json"
        $relatedDataDir = Split-Path -Path $relatedLocalCache -Parent
        New-Item -ItemType Directory -Path $relatedDataDir -Force | Out-Null
        $relatedWrapper | ConvertTo-Json -Depth 10 | Set-Content $relatedLocalCache 
        Write-DebugLog "Processing  $($HugoMarkdown.ReferencePath) [$($relatedWrapper.related.Count) related items found.]"    
    }    
}

# Complete the progress bar
Write-Progress -Activity "Processing Hugo Markdown Objects" -Completed

#$hugoMdObj = $hugoMarkdownObjects | Select-Object -First 1

#$stuff = Get-RelatedFromHugoMarkdown -HugoMarkdown $hugoMdObj

Write-DebugLog "All files checked."
