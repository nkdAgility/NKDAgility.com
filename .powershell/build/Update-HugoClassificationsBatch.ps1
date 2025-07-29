
# Helpers
. ./.powershell/_includes/IncludesForAll.ps1

$ErrorActionPreference = 'Stop'
$levelSwitch.MinimumLevel = 'Information'
$hugoMarkdownObjects = @()
$hugoMarkdownObjects += Get-RecentHugoMarkdownResources -Path ".\site\content\resources\" -YearsBack 10
$hugoMarkdownObjects += Get-RecentHugoMarkdownResources -Path ".\site\content\capabilities\training-courses" -YearsBack 10
$hugoMarkdownObjects += Get-RecentHugoMarkdownResources -Path ".\site\content\capabilities\mentor-programs" -YearsBack 10
$hugoMarkdownObjects += Get-RecentHugoMarkdownResources -Path ".\site\content\concepts" -YearsBack 10
$hugoMarkdownObjects += Get-RecentHugoMarkdownResources -Path ".\site\content\categories" -YearsBack 10
$hugoMarkdownObjects += Get-RecentHugoMarkdownResources -Path ".\site\content\tags" -YearsBack 10

Start-TokenServer
##############################################

Update-ClassificationsForHugoMarkdownList -hugoMarkdownList $hugoMarkdownObjects

##############################################
Stop-TokenServer