

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

    $PromptContent = Get-Content -Path $PromptPath -Raw    # Match all {{param}} patterns but exclude {{< shortcodes
    $Placeholders = [regex]::Matches($PromptContent, "{{\s*(?!<)([^}]+?)\s*}}")

    foreach ($match in $Placeholders) {
        $fullMatch = $match.Value                   # e.g., "{{SomeKey}}"
        $paramName = $match.Groups[1].Value.Trim()  # e.g., "SomeKey"

        # Case-insensitive lookup in the provided $Parameters hashtable
        $actualKey = $Parameters.Keys | Where-Object { $_ -ieq $paramName } | Select-Object -First 1

        if ($null -ne $actualKey) {
            $replacement = $Parameters[$actualKey]
            $PromptContent = $PromptContent.Replace($fullMatch, $replacement)
        }
    }    # Final check for any unresolved placeholders (excluding {{< shortcodes)
    if ($PromptContent -match "{{\s*(?!<)[^}]*\s*}}") {
        Write-Error "Prompt contains unresolved parameters: $($Matches[0])"
        exit 1
        return $null
    }

    return $PromptContent
}

Write-DebugLog "PromptManager.ps1 loaded"
