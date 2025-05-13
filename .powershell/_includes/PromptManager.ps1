. ./.powershell/_includes/LoggingHelper.ps1
. ./.powershell/_includes/OpenAI.ps1

$PromptRepository = ".prompts"

function Get-Prompt {
    param (
        [Parameter(Mandatory = $true)]
        [string]$PromptName,
        [Hashtable]$Parameters = @{}
    )

    $PromptPath = Join-Path -Path $PromptRepository -ChildPath $PromptName

    if (-not (Test-Path $PromptPath)) {
        Write-Error "Prompt file not found: $PromptPath"
        return $null
    }

    $PromptContent = Get-Content -Path $PromptPath -Raw

    foreach ($Key in $Parameters.Keys) {
        $Placeholder = "{{${Key}}}"
        $PromptContent = $PromptContent.Replace($Placeholder, $Parameters[$Key])
    }

    # Check for any unreplaced parameters like {{...}}
    if ($PromptContent -match "{{\s*[^<%][^}]*\s*}}") {

        Write-Error "Prompt contains unresolved parameters: $($Matches[0])"
        exit 1
        return $null
    }

    return $PromptContent
}

Write-DebugLog "PromptManager.ps1 loaded"
