# Helpers
. ./.powershell/_includes/LoggingHelper.ps1

function Delete-LocalDataFiles {
    param (
        [string]$LocalPath
    )
    $count = 0
    try {
        Write-InfoLog "Deleting all data file files locally from '$LocalPath'..."
        $files = Get-ChildItem -Path $env:LOCAL_IMAGE_PATH -Recurse -Include data.captions.*.srt, data.captions.json, data.json, data.index.classifications.json
        if ($files.Count -eq 0) {
            Write-InfoLog "No files found."
            return 0;
        }
        $size = ($files | Measure-Object -Property Length -Sum).Sum 
        $sizeString = "{0:N2} MB" -f ($size / 1MB)
        Write-InfoLog "Found ($($files.Count)) files totalling $sizeString."
        $files | ForEach-Object {
            try {
                $count++
                Remove-Item -Path $_.FullName -Force
                Write-DebugLog "Deleted: $($_.FullName)"
            }
            catch {
                Write-ErrorLog "Error deleting file $($_.FullName): $_"
            }
        }
    }
    catch {
        Write-ErrorLog "Error during file deletion: $_"
    }
    Write-InfoLog "Deleted: $count"
    return $count;
}