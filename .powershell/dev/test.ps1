# Find all files matching the pattern in a safe way
$files = Get-ChildItem -Path "./" -Filter "staticwebapp.*.json" -ErrorAction Stop

if ($files.Count -eq 0) {
    Write-Host "No files matching the pattern 'staticwebapp.*.json' were found."
    exit 1
}

# Output each file's full name (for verification/debugging purposes)
$files | ForEach-Object {
    Write-Host "Found file: $($_.FullName)"
}

# Paths to main and environment-specific config files
$rootConfig = "./staticwebapp.config.json"
$environmentConfig = "./staticwebapp.config.canary.json"

# Check if both target files exist
if ((Test-Path -Path $rootConfig -ErrorAction Stop) -and (Test-Path -Path $environmentConfig -ErrorAction Stop)) {
    try {
        # Run jq to merge files and capture the output
        $mergedContent = & jq -s 'reduce .[] as $item ({}; . * $item)' $rootConfig $environmentConfig

        if ($mergedContent -ne "") {
            # Write the merged content to the output file
            $mergedContent | Set-Content -Path "./staticwebapp.config.json"
            Write-Host "Merged JSON files successfully."
        }
        else {
            Write-Host "jq command produced empty output. Check JSON structures in input files."
            exit 1
        }
    }
    catch {
        Write-Host "Error merging JSON files with jq: $_"
        exit 1
    }
}
else {
    Write-Host "One or both of the specified config files were not found:"
    if (!(Test-Path -Path $rootConfig)) { Write-Host " - $rootConfig not found" }
    if (!(Test-Path -Path $environmentConfig)) { Write-Host " - $environmentConfig not found" }
    exit 1
}

# Verify and read the merged file content
try {
    $content = Get-Content -Path "./staticwebapp.config.json" -ErrorAction Stop
    Write-Host "Content of merged config file:"
    Write-Output $content
}
catch {
    Write-Host "Error reading the merged config file: $_"
    exit 1
}
