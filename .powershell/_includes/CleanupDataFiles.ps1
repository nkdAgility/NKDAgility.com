# Helpers
. ./.powershell/_includes/LoggingHelper.ps1

function Delete-LocalDataFiles {
    [CmdletBinding()]
    param([Parameter(Mandatory)][string]$LocalPath)

    Write-InfoLog "Deleting all data.* files from '$LocalPath'..."
    # -Filter is handled by the filesystem, faster than -Include; -File avoids dirs
    $files = Get-ChildItem -Path $LocalPath -Recurse -File -Filter 'data.*' -ErrorAction SilentlyContinue
    $total = $files.Count
    if ($total -eq 0) { Write-InfoLog "No files found."; return 0 }

    $bytes = ($files | Measure-Object Length -Sum).Sum
    Write-InfoLog ("Found ({0}) files totalling {1:N2} MB." -f $total, ($bytes / 1MB))

    # Single call reduces per-item cmdlet overhead
    Remove-Item -LiteralPath $files.FullName -Force -ErrorAction SilentlyContinue
    Write-InfoLog "Completed: Deleted $total files."
    return $total
}
