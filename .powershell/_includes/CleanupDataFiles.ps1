# Helpers
. ./.powershell/_includes/LoggingHelper.ps1

function Delete-LocalDataFiles {
    param (
        [string]$LocalPath
    )
    $count = 0
    try {
        Write-InfoLog "Deleting all data files locally from '$LocalPath'..."
        $files = Get-ChildItem -Path $LocalPath -Recurse -Include data.captions.*.srt, data.captions.json, data.json, data.index.classifications.json
        if ($files.Count -eq 0) {
            Write-InfoLog "No files found."
            return 0;
        }
        
        $totalFiles = $files.Count
        $size = ($files | Measure-Object -Property Length -Sum).Sum 
        $sizeString = "{0:N2} MB" -f ($size / 1MB)
        Write-InfoLog "Found ($totalFiles) files totalling $sizeString."

        $lastPercentage = 0  # To track when to log progress
        $progressInterval = 10 # Percentage interval for logging

        $files | ForEach-Object -Begin { $index = 0 } -Process {
            try {
                Remove-Item -Path $_.FullName -Force
                Write-DebugLog "Deleted: $($_.FullName)"
                $count++
                $index++

                # Calculate percentage progress
                $percentage = [math]::Round(($index / $totalFiles) * 100, 0)
                
                # Log progress at defined intervals (e.g., every 10%)
                if ($percentage -ge $lastPercentage + $progressInterval) {
                    Write-InfoLog "Progress: $percentage% ($index of $totalFiles files deleted)"
                    $lastPercentage = $percentage
                }
            }
            catch {
                Write-ErrorLog "Error deleting file $($_.FullName): $_"
            }
        }
    }
    catch {
        Write-ErrorLog "Error during file deletion: $_"
    }
    Write-InfoLog "Completed: Deleted $count files."
    return $count;
}
