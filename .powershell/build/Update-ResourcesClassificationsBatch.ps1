
# Helpers
. ./.powershell/_includes/IncludesForAll.ps1

$ErrorActionPreference = 'Stop'
$levelSwitch.MinimumLevel = 'Information'
$hugoMarkdownObjects = @()
$hugoMarkdownObjects = Get-RecentHugoMarkdownResources -Path ".\site\content\resources\signals" -YearsBack 10
#$hugoMarkdownObjects += Get-RecentHugoMarkdownResources -Path ".\site\content\concepts" -YearsBack 10
#$hugoMarkdownObjects += Get-RecentHugoMarkdownResources -Path ".\site\content\categories" -YearsBack 10
#$hugoMarkdownObjects += Get-RecentHugoMarkdownResources -Path ".\site\content\tags" -YearsBack 10

Start-TokenServer
##############################################

Update-ClassificationsForHugoMarkdownList -hugoMarkdownList $hugoMarkdownObjects

##############################################
Stop-TokenServer