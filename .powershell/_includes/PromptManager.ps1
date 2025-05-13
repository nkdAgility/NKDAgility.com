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

    # Match all {{param}} patterns
    $Placeholders = [regex]::Matches($PromptContent, "{{\s*([^}]+?)\s*}}")

    foreach ($match in $Placeholders) {
        $fullMatch = $match.Value                   # e.g., "{{SomeKey}}"
        $paramName = $match.Groups[1].Value.Trim()  # e.g., "SomeKey"

        # Case-insensitive lookup in the provided $Parameters hashtable
        $actualKey = $Parameters.Keys | Where-Object { $_ -ieq $paramName } | Select-Object -First 1

        if ($null -ne $actualKey) {
            $replacement = $Parameters[$actualKey]
            $placeholder = "{{${Key}}}"
            $PromptContent = $PromptContent.Replace( $placeholder, $replacement)
        }
    }

    # Final check for any unresolved placeholders
    if ($PromptContent -match "{{\s*[^<%][^}]*\s*}}") {
        Write-Error "Prompt contains unresolved parameters: $($Matches[0])"
        exit 1
        return $null
    }

    return $PromptContent
}

Write-DebugLog "PromptManager.ps1 loaded"
