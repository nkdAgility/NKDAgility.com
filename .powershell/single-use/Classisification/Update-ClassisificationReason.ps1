 
# Helpers
. ./.powershell/_includes/LoggingHelper.ps1
. ./.powershell/_includes/OpenAI.ps1
. ./.powershell/_includes/HugoHelpers.ps1
. ./.powershell/_includes/ResourceHelpers.ps1
. ./.powershell/_includes/ClassificationHelpers.ps1

$ErrorActionPreference = 'Stop'
$levelSwitch.MinimumLevel = 'Information'
$hugoMarkdownObjects = @()
$hugoMarkdownObjects = Get-RecentHugoMarkdownResources -Path ".\site\content\resources" -YearsBack 10
$hugoMarkdownObjects += Get-RecentHugoMarkdownResources -Path ".\site\content\concepts" -YearsBack 10
$hugoMarkdownObjects += Get-RecentHugoMarkdownResources -Path ".\site\content\categories" -YearsBack 10
$hugoMarkdownObjects += Get-RecentHugoMarkdownResources -Path ".\site\content\tags" -YearsBack 10

Start-TokenServer
##############################################
$reasonLengths = @()
$count = 0;
foreach ($hugoMarkdownObject in $hugoMarkdownObjects) {
    $count++
    Write-InformationLog "Processing {count} of {total} - {title}" -PropertyValues $count, $hugoMarkdownObjects.Count
    $cachedData = Get-ClassificationsFromCache -hugoMarkdown $hugoMarkdownObject
    foreach ($key in $cachedData.Keys) {
        $classification = $cachedData[$key]
        
        if ([string]::IsNullOrWhiteSpace($classification.reasoningSummary) -and $classification.final_score -gt 70) {
            $length = $classification.reasoning.Length
            $reasonLengths += $length
            Write-DebugLog "[{key}] Reason length: {Length}" -PropertyValues $key, $length
        }
        else {
            Write-DebugLog "[{key}] No reasoning or summary present"  -PropertyValues $key, $length
        }
    }
}

##############################################
# Calculate statistics

if ($reasonLengths.Count -gt 0) {
    $count = $reasonLengths.Count
    $min = ($reasonLengths | Measure-Object -Minimum).Minimum
    $max = ($reasonLengths | Measure-Object -Maximum).Maximum
    $average = ($reasonLengths | Measure-Object -Average).Average

    # Calculate standard deviation
    $mean = $average
    $sumOfSquares = ($reasonLengths | ForEach-Object { ($_ - $mean) * ($_ - $mean) }) | Measure-Object -Sum
    $stdDev = [math]::Sqrt($sumOfSquares.Sum / $count)

    # Count how many are over 500, 600, and 700 characters
    $over500Count = ($reasonLengths | Where-Object { $_ -gt 500 }).Count
    $over600Count = ($reasonLengths | Where-Object { $_ -gt 600 }).Count
    $over700Count = ($reasonLengths | Where-Object { $_ -gt 700 }).Count


    # Log summary
    Write-InformationLog "Reason lengths summary: Count={count}, Min={min}, Max={max}, Average={average}, StdDev={stdDev}, Over500={over500Count}, Over600={over600Count}, Over700={over700Count}" `
        -PropertyValues $count, $min, $max, $average, $stdDev, $over500Count, $over600Count, $over700Count

}
else {
    Write-InformationLog "No Reason entries found to calculate metrics"
}

##############################################
Stop-TokenServer