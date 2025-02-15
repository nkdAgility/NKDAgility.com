
# Helpers
. ./.powershell/_includes/LoggingHelper.ps1
. ./.powershell/_includes/OpenAI.ps1
. ./.powershell/_includes/HugoHelpers.ps1
. ./.powershell/_includes/ResourceHelpers.ps1
. ./.powershell/_includes/ClassificationHelpers.ps1


$levelSwitch.MinimumLevel = 'Debug'

# Iterate through each blog folder and update markdown files
$outputDir = "site\content\resources\blog\2006"

# Get list of directories and select the first 10
$resources = Get-ChildItem -Path $outputDir  -Recurse -Filter "index.md"  | Sort-Object { $_ } -Descending | Select-Object -First 300 

$ClassificationType = "tags"

$catalogCategories = Get-CatalogHashtable -Classification "categories"
$catalogTags = Get-CatalogHashtable -Classification "tags"

#$duplicateKeys = $catalogCategories.Keys | Where-Object { $catalogTags.ContainsKey($_) } | Sort-Object { $_ } 

switch ($ClassificationType) {
    "categories" {
        $catalog = $catalogCategories
    }
    "tags" {
        $catalog = $catalogTags
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

        $CacheFolder = $resourceDir
        $oldDataFiles = @((Join-Path $CacheFolder "data.index.tags.json"), (Join-Path $CacheFolder "data.index.categories.json"))
        if ($oldDataFiles | Where-Object { Test-Path $_ }) {
            try {
                $dataFile = Join-Path $CacheFolder "data.index.classifications.json"
                $data = $null;
                if (Test-Path $dataFile) {
                    $data = Get-Content (Join-Path $CacheFolder "data.index.classifications.json") | ConvertFrom-Json -ErrorAction Stop
                }
                foreach ($oldDataFile in $oldDataFiles) {
                    if (Test-Path $oldDataFile) {
                        $oldData = Get-Content $oldDataFile | ConvertFrom-Json -ErrorAction Stop
                        if ($null -eq $data -or ($data.PSObject.Properties.Name.Count -eq 0)) {
                            $data = $oldData
                        }
                        else {
                            # Merge properties from $oldData into $data
                            foreach ($property in $oldData.PSObject.Properties) {
                                if (-not $data.PSObject.Properties.Name.Contains($property.Name)) {
                                    Add-Member -InputObject $data -MemberType NoteProperty -Name $property.Name -Value $property.Value
                                }
                                else {
                                    # Optionally, handle merging of existing properties if needed
                                    # For example, if it's a list, you can combine them
                                    if ($data.$($property.Name) -is [System.Collections.IList]) {
                                        $data.$($property.Name) += $property.Value
                                    }
                                }
                            }
                        }
                    }
                }
                $data | ConvertTo-Json -Depth 2 | Set-Content -Path $dataFile -Force
    
                foreach ($oldDataFile in $oldDataFiles) {
                    if (Test-Path $oldDataFile) {
                        Remove-Item $oldDataFile -Force
                    }
                }
            }
            catch {
                Write-ErrorLog "Error migrating old data files. Please re-run the command.\n Error: $_"
                exit
            }
        }

        Write-InfoLog "Original: $($cachedData.PSObject.Properties.Count) items"
   
        # $keysToRemove = $cachedData.PSObject.Properties.Name | Where-Object { $_ -notin $catalog.Keys }
        # Write-InfoLog "Remove: $($keysToRemove.Count) items"
        # foreach ($key in $keysToRemove) {
        #     $cachedData.PSObject.Properties.Remove($key)
        # }
        # Write-InfoLog "After: $($cachedData.PSObject.Properties.Count) items"
        #$cachedData | ConvertTo-Json -Depth 2 | Set-Content -Path $cacheFile -Force
   

    }
    else {
        Write-InfoLog "Skipping folder: $blogDir (missing index.md)"
    }
    # Track count of ResourceType
   
}
Write-Progress -id 1 -Completed
Write-InfoLog "All markdown files processed."
Write-InfoLog "--------------------------------------------------------"