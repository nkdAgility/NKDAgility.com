
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

Update-ClassificationsForHugoMarkdownList -hugoMarkdownList $hugoMarkdownObjects

##############################################
Stop-TokenServer