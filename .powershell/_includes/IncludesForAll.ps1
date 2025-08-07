# Setup

$OutputEncoding = [System.Text.Encoding]::UTF8

$ErrorActionPreference = 'Stop'

# Helpers
. ./.powershell/_includes/LoggingHelper.ps1

# Enable debug logging if debugger is attached
$isDebugging = $false

# Check for various debugging indicators
if ([System.Diagnostics.Debugger]::IsAttached) {
    $isDebugging = $true
    Write-InfoLog "System debugger detected"
}

# Check for VS Code PowerShell debugging
if ($env:VSCODE_PID -or $env:TERM_PROGRAM -eq "vscode" -or $PSDebugContext) {
    $isDebugging = $true
    Write-InfoLog "VS Code PowerShell debugging environment detected"
}

# Check if running in PowerShell ISE
if ($psISE) {
    $isDebugging = $true
    Write-InfoLog "PowerShell ISE debugging environment detected"
}

# Check for debug preference variables
if ($DebugPreference -ne 'SilentlyContinue' -or $VerbosePreference -ne 'SilentlyContinue') {
    $isDebugging = $true
    Write-InfoLog "Debug/Verbose preferences detected"
}

if ($isDebugging) {
    $levelSwitch.MinimumLevel = 'Debug'
    Write-InfoLog "Debug logging enabled due to debugging environment"
}

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
. ./.powershell/_includes/YoutubeAPI.ps1
