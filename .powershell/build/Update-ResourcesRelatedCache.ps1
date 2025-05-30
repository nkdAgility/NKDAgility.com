# Helpers (existing wrappers)
. ./.powershell/_includes/LoggingHelper.ps1
. ./.powershell/_includes/TokenServer.ps1
. ./.powershell/_includes/OpenAI.ps1
. ./.powershell/_includes/HugoHelpers.ps1
. ./.powershell/_includes/ResourceHelpers.ps1
. ./.powershell/_includes/ClassificationHelpers.ps1
. ./.powershell/_includes/AzureBlobHelpers.ps1
. ./.powershell/_includes/EmbeddingRepository.ps1
. ./.powershell/_includes/RelatedCacheHelpers.ps1


$ErrorActionPreference = 'Stop'
$levelSwitch.MinimumLevel = 'Information'

###### TEST CODE BELOW HERE ######
# Parameters

Start-TokenServer
#$storageContext = New-AzStorageContext -SasToken $Env:AZURE_BLOB_STORAGE_SAS_TOKEN -StorageAccountName "nkdagilityblobs"
$hugoMarkdownObjects = Get-RecentHugoMarkdownResources -Path ".\site\content\resources\" -YearsBack 20
$hugoMarkdownObjects += Get-RecentHugoMarkdownResources -Path ".\site\content\tags\" -YearsBack 10
$hugoMarkdownObjects += Get-RecentHugoMarkdownResources -Path ".\site\content\categories\" -YearsBack 10
$hugoMarkdownObjects += Get-RecentHugoMarkdownResources -Path ".\site\content\concepts\" -YearsBack 10
#Update-EmbeddingRepository2 -HugoMarkdownObjects $hugoMarkdownObjects
Build-ResourcesRelatedCache -HugoMarkdownObjects $hugoMarkdownObjects -LocalPath "./.data/content-embeddings/"
Write-DebugLog "--------------------------------------------------------"
Write-DebugLog "--------------------------------------------------------"


Write-DebugLog "All files checked."
