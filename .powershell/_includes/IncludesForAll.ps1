# Setup

$OutputEncoding = [System.Text.Encoding]::UTF8

$ErrorActionPreference = 'Stop'

# Helpers
. ./.powershell/_includes/LoggingHelper.ps1
. ./.powershell/_includes/Utilities.ps1
. ./.powershell/_includes/AzureBlobHelpers.ps1 # Depends on LoggingHelper.ps1
. ./.powershell/_includes/TokenServer.ps1 # Depends on LoggingHelper.ps1
. ./.powershell/_includes/OpenAI.ps1 # Depends on LoggingHelper.ps1, TokenServer.ps1
. ./.powershell/_includes/PromptManager.ps1 # Depends on LoggingHelper.ps1, OpenAI.ps1
. ./.powershell/_includes/HugoHelpers.ps1 # Depends on LoggingHelper.ps1
. ./.powershell/_includes/ResourceHelpers.ps1 # Depends on OpenAI.ps1
. ./.powershell/_includes/EmbeddingRepository.ps1 # LoggingHelper.ps1, TokenServer.ps1, OpenAI.ps1, PromptManager.ps1, HugoHelpers.ps1
. ./.powershell/_includes/RelatedRepository.ps1 # Depends on LoggingHelper.ps1, OpenAI.ps1, ResourceHelpers.ps1 
. ./.powershell/_includes/ClassificationHelpers.ps1 # Depends on LoggingHelper.ps1, OpenAI.ps1, ResourceHelpers.ps1
. ./.powershell/_includes/RelatedCacheHelpers.ps1 # LoggingHelper.ps1, TokenServer.ps1, OpenAI.ps1, HugoHelpers.ps1, ResourceHelpers.ps1, ClassificationHelpers.ps1, AzureBlobHelpers.ps1, EmbeddingRepository.ps1

