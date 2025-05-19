
# Helpers
. ./.powershell/_includes/LoggingHelper.ps1
. ./.powershell/_includes/TokenServer.ps1
. ./.powershell/_includes/OpenAI.ps1
. ./.powershell/_includes/HugoHelpers.ps1
. ./.powershell/_includes/ResourceHelpers.ps1
. ./.powershell/_includes/ClassificationHelpers.ps1

$ErrorActionPreference = 'Stop'
$levelSwitch.MinimumLevel = 'Information'
$CaptionsCatalogue = @()


$hugoMarkdownObjects = Get-RecentHugoMarkdownResources -Path ".\site\content\resources\videos" -YearsBack 10

Write-InformationLog "Processing ({count}) HugoMarkdown Objects." -PropertyValues ($hugoMarkdownObjects.Count)
### /FILTER hugoMarkdownObjects
### Convert hugoMarkdownObjects to queue
$hugoMarkdownQueue = New-Object System.Collections.Generic.Queue[HugoMarkdown]
$hugoMarkdownObjects | ForEach-Object {
    $hugoMarkdownQueue.Enqueue($_)
}
$Counter = 0
$TotalItems = $hugoMarkdownQueue.Count

while ($hugoMarkdownQueue.Count -gt 0) { 
    $hugoMarkdown = $hugoMarkdownQueue.Dequeue()
    if ($hugoMarkdown.FrontMatter.duration -gt 1500) {
        Write-InformationLog "Skipping ({title}) with duration ({duration})" -PropertyValues ($hugoMarkdown.FrontMatter.Title, $hugoMarkdown.FrontMatter.duration)
        continue
    }
    $captionsPath = Join-Path $hugoMarkdown.FolderPath "captions.en.md"
    if (Test-Path $captionsPath) {
        $captions = Get-Content $captionsPath -Raw
        $CaptionsCatalogue += [PSCustomObject]@{
            Title       = $hugoMarkdown.FrontMatter.Title
            Description = $hugoMarkdown.FrontMatter.Description
            ResourceId  = $hugoMarkdown.FrontMatter.ResourceId
            Url         = "https://www.youtube.com/watch?v=$($hugoMarkdown.FrontMatter.ResourceId)"
            Date        = $hugoMarkdown.FrontMatter.Date
            Captions    = $captions
        }
    }

    $Counter++
    Write-InformationLog "Processed ({count}) of ({total}) HugoMarkdown Objects." -PropertyValues ($Counter, $TotalItems)

}

Set-Content -Path ".\.resources\catalogue-captions.json" -Value ($CaptionsCatalogue | ConvertTo-Json -Depth 10) -Encoding UTF8