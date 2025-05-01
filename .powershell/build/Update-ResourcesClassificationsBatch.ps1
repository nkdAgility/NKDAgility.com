
# Helpers
. ./.powershell/_includes/LoggingHelper.ps1
. ./.powershell/_includes/OpenAI.ps1
. ./.powershell/_includes/HugoHelpers.ps1
. ./.powershell/_includes/ResourceHelpers.ps1
. ./.powershell/_includes/ClassificationHelpers.ps1

$ErrorActionPreference = 'Stop'
$levelSwitch.MinimumLevel = 'Information'

$hugoMarkdownObjects = Get-RecentHugoMarkdownResources -Path ".\site\content\resources" -YearsBack 10

##############################################
Update-ClassificationsForHugoMarkdownList -hugoMarkdownList $hugoMarkdownObjects
##############################################
