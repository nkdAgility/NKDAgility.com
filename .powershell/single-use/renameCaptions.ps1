# Helpers
. ./.powershell/_includes/LoggingHelper.ps1
. ./.powershell/_includes/OpenAI.ps1
. ./.powershell/_includes/HugoHelpers.ps1
. ./.powershell/_includes/ResourceHelpers.ps1
. ./.powershell/_includes/ClassificationHelpers.ps1

$levelSwitch.MinimumLevel = 'Debug'

# Iterate through each blog folder and update markdown files
$outputDir = ".\site\content\resources\videos\youtube"

# Get list of directories and select the first 10
$captions = Get-ChildItem -Path $outputDir -Recurse -Include "index.captions.*.md" | Sort-Object -Property FullName -Descending

# Total count for progress tracking
$TotalFiles = $captions.Count
$Counter = 0

$captions | ForEach-Object {
    $Counter++
    $oldName = $_.FullName
    $newName = $oldName -replace 'index\.', ''
    Rename-Item -Path $oldName -NewName $newName

    Write-Output "Renamed: $oldName to $newName"
    Write-Output "Progress: $Counter of $TotalFiles"
}
