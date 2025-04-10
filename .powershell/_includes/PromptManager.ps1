. ./.powershell/_includes/LoggingHelper.ps1
. ./.powershell/_includes/OpenAI.ps1

$PromptRepository = ".prompts"

function Get-Prompt {
    param (
        [string]$PromptName = "first-prompt.prompt",
        [Hashtable]$Parameters = @{}
    )

    $PromptPath = Join-Path -Path $PromptRepository -ChildPath $PromptName

    if (-not (Test-Path $PromptPath)) {
        Write-Error "Prompt file not found: $PromptPath"
        return $null
    }

    $PromptContent = Get-Content -Path $PromptPath -Raw

    foreach ($Key in $Parameters.Keys) {
        $Value = $Parameters[$Key]
        $PromptContent = $PromptContent -replace "(?i){{\s*$Key\s*}}", $Value
    }

    return $PromptContent
}

Write-DebugLog "PromptManager.ps1 loaded"
