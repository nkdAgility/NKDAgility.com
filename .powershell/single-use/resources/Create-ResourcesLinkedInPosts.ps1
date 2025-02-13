
# Helpers
. ./.powershell/_includes/LoggingHelper.ps1
. ./.powershell/_includes/OpenAI.ps1
. ./.powershell/_includes/HugoHelpers.ps1
. ./.powershell/_includes/ResourceHelpers.ps1
. ./.powershell/_includes/ClassificationHelpers.ps1


$levelSwitch.MinimumLevel = 'Information'

# Iterate through each blog folder and update markdown files
$outputDir = ".\site\content\resources\blog"

# Get list of directories and select the first 10
$resources = Get-ChildItem -Path $outputDir  -Recurse -Filter "index.md"  | Sort-Object { $_ } -Descending #| Select-Object -Skip 600  # | Select-Object -First 300 

$Counter = 1


$hugoMarkdownFiles = @()
$TotalFiles = $resources.Count
Write-InformationLog "Loading ({count}) markdown files...." -PropertyValues $TotalFiles
$resources | ForEach-Object {
    if ((Test-Path $_)) {
        $hugoMarkdown = Get-HugoMarkdown -Path $_
        $hugoMarkdownFiles += $hugoMarkdown
    }
}
Write-InformationLog "Loaded ({count}) HugoMarkdown Objects." -PropertyValues $hugoMarkdownFiles.Count


$categoriesCatalog = Get-CatalogHashtable -Classification "categories"
$tagsCatalog = Get-CatalogHashtable -Classification "tags"

# Initialize a hash table to track counts of each ResourceType
$resourceTypeCounts = @{}


$Counter = 0


$TotalItems = $hugoMarkdownFiles.Count
$hugoMarkdownFiles = $hugoMarkdownFiles  | Where-Object { $_.FrontMatter.isShort -ne $true }
Write-InformationLog "Removed ({count}) HugoMarkdown Objects where FrontMatter.isShort -ne true." -PropertyValues ($TotalItems - $hugoMarkdownFiles.Count)
$TotalItems = $hugoMarkdownFiles.Count
$hugoMarkdownFiles = $hugoMarkdownFiles  | Where-Object { $_.FrontMatter.draft -ne $true }
Write-InformationLog "Removed ({count}) HugoMarkdown Objects where FrontMatter.draft -ne true." -PropertyValues ($TotalItems - $hugoMarkdownFiles.Count)


$hugoMarkdownFiles = $hugoMarkdownFiles | Sort-Object { $_.FrontMatter.date } -Descending
# Total count for progress tracking
$TotalItems = $hugoMarkdownFiles.Count
Write-InformationLog "Processing ({count}) HugoMarkdown Objects." -PropertyValues ($TotalItems)
foreach ($hugoMarkdown in $hugoMarkdownFiles ) {
    $Counter++
    $PercentComplete = ($Counter / $TotalItems) * 100
    Write-Progress -id 1 -Activity "Processing Markdown Files" -Status "Processing $Counter of $TotalItems | $($hugoMarkdown.FrontMatter.date) | $($hugoMarkdown.FrontMatter.ResourceType) | $($hugoMarkdown.FrontMatter.title)" -PercentComplete $PercentComplete
 

    Write-DebugLog "--------------------------------------------------------"
    Write-InfoLog "Processing post: { ResolvePath }" -PropertyValues  $(Resolve-Path -Path $hugoMarkdown.FolderPath -Relative)


}
Write-Progress -id 1 -Completed
Write-DebugLog "All markdown files processed."
Write-DebugLog "--------------------------------------------------------"
Write-DebugLog "Summary of updated Resource Types:"
$resourceTypeCounts.GetEnumerator() | ForEach-Object { Write-DebugLog "$($_.Key): $($_.Value)" }