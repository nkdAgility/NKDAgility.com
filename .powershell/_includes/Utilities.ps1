

function ConvertTo-CamelCase {
    param (
        [string]$Text
    )

    # Split words by spaces or non-alphanumeric characters
    $words = $Text -split '\W+' | Where-Object { $_ -match '\w' }  # Remove empty values

    if ($words.Count -eq 0) { return '' }  # Handle empty input

    # Ensure first word is lowercase, and capitalize subsequent words properly
    $camelCase = $words[0].ToLower() + ($words[1..($words.Count - 1)] | ForEach-Object {
            if ($_.Length -gt 0) {
                $_.Substring(0, 1).ToUpper() + $_.Substring(1).ToLower()
            }
        }) -join ''

    return $camelCase
}

Write-Debug "Utilities.ps1 loaded"