# Helpers
. ./.powershell/_includes/IncludesForAll.ps1

$levelSwitch.MinimumLevel = 'Information'

$hugoMarkdownObjects = @()
$hugoMarkdownObjects += Get-RecentHugoMarkdownResources -Path ".\site\content\capabilities\training-courses\" -YearsBack 10

Write-InformationLog "Processing ({count}) HugoMarkdown Objects." -PropertyValues ($hugoMarkdownObjects.Count)
### /FILTER hugoMarkdownObjects
### Convert hugoMarkdownObjects to queue
$hugoMarkdownQueue = New-Object System.Collections.Generic.Queue[HugoMarkdown]
$hugoMarkdownObjects | ForEach-Object {
    $hugoMarkdownQueue.Enqueue($_)
}

$Counter = 0
$TotalItems = $hugoMarkdownQueue.Count
$missingFromOrder = @()

$baseSessionRate = 2000  # GBP for up to 12 students, per ~4h session
$trainingRateTable = @()

while ($hugoMarkdownQueue.Count -gt 0) {
   
    $hugoMarkdown = $hugoMarkdownQueue.Dequeue()
    $Counter++
    $PercentComplete = ($Counter / $TotalItems) * 100
    #Write-Progress -id 1 -Activity $ActivityText -Status "Queue Item: $($hugoMarkdown.FrontMatter.date) | $($hugoMarkdown.FrontMatter.ResourceType) | $($hugoMarkdown.FrontMatter.title)" -PercentComplete $PercentComplete
    Write-DebugLog "--------------------------------------------------------"
    Write-InformationLog "Processing [Q1:$($Counter)/$TotalItems] {ResolvePath}" -PropertyValues  $(Resolve-Path -Path $hugoMarkdown.FolderPath -Relative)
    if ($hugoMarkdown.FrontMatter.title -eq "Training Programs") {
        Write-WarningLog "Skipping Training Programs overview page."
        continue
    }
    # Reset Values
    $trainingLevel = "";
    $sessionCount = 0
    $sessionRate = 0
    $baseRate = 0
    $baseRatePerson = 0
    $baseRate12 = 0

    # Calculate Session Count
    $sessionsFromFrontMatter = $hugoMarkdown.FrontMatter.sessionCount;
    $sessionsFromSyllabus = 0
    $syllabusFile = Join-Path -Path $hugoMarkdown.FolderPath -ChildPath "syllabus.yaml"
    if (Test-Path -Path $syllabusFile) {
        $syllabusData = Get-Content -Path $syllabusFile | ConvertFrom-Yaml
        if (!$null -eq $syllabusData) {
            $sessionsFromSyllabus = $syllabusData.syllabus.Count
        }
    }

    if ($sessionsFromFrontMatter -le 0 -and $sessionsFromSyllabus -le 0) {
        Write-WarningLog "SessionCount missing or invalid in syllabus.yaml or front matter."
        continue;
    }

    $sessionCount = [Math]::Max($sessionsFromFrontMatter, $sessionsFromSyllabus)
   
    $trainingLevel = $hugoMarkdown.FrontMatter.course_proficiencies[0]
    $sessionRate = $baseSessionRate
    switch ($trainingLevel) {
        "beginner" { $sessionRate = $sessionRate * 0.8 }
        "intermediate" { $sessionRate = $sessionRate * 1.0 }
        "advanced" { $sessionRate = $sessionRate * 1.2 }
        Default {
            # Intermediate or other levels
            Write-WarningLog "Training level '{Level}' not specifically handled, using base rate." -PropertyValues $trainingLevel
        }
    }
 
    $relativePath = ($hugoMarkdown.FolderPath -replace [regex]::Escape("$((Get-Location).Path)\site\content\"), "").Replace('\', '/')
    
    $baseRate = $sessionRate * $sessionCount
    $baseRatePerson = $baseRate / 12
    $baseRate12 = $baseRatePerson * 12


    $trainingRateTable += [ordered]@{
        title       = $hugoMarkdown.FrontMatter.title
        code        = $hugoMarkdown.FrontMatter.code
        short_title = $hugoMarkdown.FrontMatter.short_title
        path        = $relativePath
        sessions    = $sessionCount
        sessionRate = $sessionRate
        level       = $trainingLevel
        rates       = [ordered]@{
            "12"         = [Math]::Ceiling($baseRate12 / 1000) * 1000
            "16"         = [Math]::Ceiling(($baseRate12 + (($baseRatePerson * 4)) * 1.1) / 1000) * 1000
            "20"         = [Math]::Ceiling(($baseRate12 + (($baseRatePerson * 8) ) * 1.15) / 1000) * 1000
            "24"         = [Math]::Ceiling(($baseRate12 + (($baseRatePerson * 12)) * 1.2) / 1000) * 1000
            "additional" = [Math]::Ceiling((($baseRatePerson) * 1.2) / 100) * 100
            "public"     = [Math]::Ceiling($baseRatePerson / 100) * 100
        }
    }

}

# Output the training rate table to trainingRates.json
$trainingRatesOutputFile = ".\site\data\trainingRates.json"
$outputData = @{
    baseSessionRate = $baseSessionRate
    rates           = $trainingRateTable
}
$outputData | ConvertTo-Json -Depth 3 | Set-Content -Path $trainingRatesOutputFile -Encoding UTF8
Write-InformationLog "Training rates written to {OutputFile}" -PropertyValues $trainingRatesOutputFile




#Write-Progress -id 1 -Completed
Write-DebugLog "All markdown files processed." 
Write-DebugLog "-------Missing Fields---------------------------------"
Write-DebugLog ($missingFromOrder -join ', ')
Write-DebugLog "-------------------------------------------------"
