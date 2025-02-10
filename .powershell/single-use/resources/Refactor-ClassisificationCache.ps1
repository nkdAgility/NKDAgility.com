
# Helpers
. ./.powershell/_includes/LoggingHelper.ps1
. ./.powershell/_includes/OpenAI.ps1
. ./.powershell/_includes/HugoHelpers.ps1
. ./.powershell/_includes/ResourceHelpers.ps1
. ./.powershell/_includes/ClassificationHelpers.ps1


$levelSwitch.MinimumLevel = 'Debug'

# Iterate through each blog folder and update markdown files
$outputDir = ".\site\content\resources\blog\"

# Get list of directories and select the first 10
$resources = Get-ChildItem -Path $outputDir  -Recurse -Filter "index.md"  | Sort-Object { $_ } -Descending | Select-Object -First 300 

$ClassificationType = "tags"

switch ($ClassificationType) {
    "categories" {
        $catalog = Get-CatalogHashtable -Classification "categories"
    }
    "tags" {
        $catalog = Get-CatalogHashtable -Classification "tags"
    }
    default {
        Write-Error "Invalid ClassificationType: $ClassificationType"
        exit
    }
}

# Initialize a hash table to track counts of each ResourceType
$resourceTypeCounts = @{}

# Total count for progress tracking
$TotalFiles = $resources.Count
$Counter = 0

$resources | ForEach-Object {

    $Counter++
    $PercentComplete = ($Counter / $TotalFiles) * 100


    $resourceDir = (Get-Item -Path $_).DirectoryName
    $markdownFile = $_
    Write-InfoLog "--------------------------------------------------------"
    Write-InfoLog "Processing post: $(Resolve-Path -Path $resourceDir -Relative)"
    if ((Test-Path $markdownFile)) {

        Write-Progress -id 1 -Activity "Processing Markdown Files" -Status "Processing $Counter ('$($hugoMarkdown.FrontMatter.date)') of $TotalFiles" -PercentComplete $PercentComplete


        $cacheFile = Join-Path $resourceDir "data.index.$ClassificationType.json"
        $cachedData = @{}
        if (Test-Path $cacheFile) {
            try {
                $cachedData = Get-Content $cacheFile | ConvertFrom-Json -Depth 2 -ErrorAction Stop
            }
            catch {
                Write-Debug "Warning: Cache file corrupted. Resetting cache."
                $cachedData = @{}
            }
        }

  
   
        $keysToRemove = $cachedData.PSObject.Properties.Name | Where-Object { $_ -notin $catalog.Keys }

        foreach ($key in $keysToRemove) {
            $cachedData.Remove($key)
        }

        $cachedData | ConvertTo-Json -Depth 2 | Set-Content -Path $cacheFile -Force
   

    }
    else {
        Write-InfoLog "Skipping folder: $blogDir (missing index.md)"
    }
    # Track count of ResourceType
    if ($resourceTypeCounts.ContainsKey($ResourceType)) {
        $resourceTypeCounts[$ResourceType]++
    }
    else {
        $resourceTypeCounts[$ResourceType] = 1
    }
}
Write-Progress -id 1 -Completed
Write-InfoLog "All markdown files processed."
Write-InfoLog "--------------------------------------------------------"
Write-InfoLog "Summary of updated Resource Types:"
$resourceTypeCounts.GetEnumerator() | ForEach-Object { Write-InfoLog "$($_.Key): $($_.Value)" }