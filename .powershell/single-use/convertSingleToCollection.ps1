
# Helpers
. ./.powershell/_includes/LoggingHelper.ps1
. ./.powershell/_includes/OpenAI.ps1
. ./.powershell/_includes/HugoHelpers.ps1
. ./.powershell/_includes/ResourceHelpers.ps1
. ./.powershell/_includes/ClassificationHelpers.ps1


$levelSwitch.MinimumLevel = 'Debug'

# Iterate through each blog folder and update markdown files
$outputDir = ".\site\content\tags"

# Get list of directories and select the first 10
$classes = Get-ChildItem -Path $outputDir | Sort-Object { $_ } -Descending | Select-Object -First 300 


# Total count for progress tracking
$TotalFiles = $classes.Count
$Counter = 0

$classes | ForEach-Object {
    $Counter++
    $oldPath = $_.FullName
    $fileName = $_.BaseName
    $newDir = Join-Path -Path $outputDir -ChildPath $fileName
    $newPath = Join-Path -Path $newDir -ChildPath "_index.md"

    if (!(Test-Path -Path $newDir)) {
        New-Item -ItemType Directory -Path $newDir
    }

    Write-Output "Moving $oldPath to $newPath"
    git mv $oldPath $newPath

    Write-Output "Progress: $Counter of $TotalFiles"
}

