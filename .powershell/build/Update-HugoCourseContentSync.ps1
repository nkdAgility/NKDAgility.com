
# Helpers
. ./.powershell/_includes/IncludesForAll.ps1

$levelSwitch.MinimumLevel = 'Debug'

Start-TokenServer

$hugoMarkdownObjects = @()
$hugoMarkdownObjects += Get-RecentHugoMarkdownResources -Path ".\site\content\capabilities\training-courses" -YearsBack 10
$hugoMarkdownObjects += Get-RecentHugoMarkdownResources -Path ".\site\content\capabilities\mentor-programs" -YearsBack 10

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
    $Counter++
    $PercentComplete = ($Counter / $TotalItems) * 100
    #Write-Progress -id 1 -Activity $ActivityText -Status "Queue Item: $($hugoMarkdown.FrontMatter.date) | $($hugoMarkdown.FrontMatter.ResourceType) | $($hugoMarkdown.FrontMatter.title)" -PercentComplete $PercentComplete
    Write-DebugLog "--------------------------------------------------------"
    Write-InformationLog "Processing [Q1:$($Counter)/$TotalItems] {ResolvePath}" -PropertyValues  $(Resolve-Path -Path $hugoMarkdown.FolderPath -Relative)

    if (-not $hugoMarkdown.FrontMatter.Type -eq "course") {
        Write-DebugLog "Skipping $($hugoMarkdown.ReferencePath) as it is not a training course."
        continue
    }
    else {
        Write-DebugLog "Processing $($hugoMarkdown.ReferencePath) as a training course."
    }
    

    #=================CONTENT=================

    # Generate a new description using OpenAI
    $courseBodyContentPrompt = Get-Prompt -PromptName "course-datasheet.md" -Parameters @{
        frontmatter = Get-Content -raw $hugoMarkdown.FilePath
    }
    $newContent = Get-OpenAIResponse -Prompt $courseBodyContentPrompt
   
    $hugoMarkdown.BodyContent = $newContent

    Save-HugoMarkdown -hugoMarkdown $hugoMarkdown -Path $hugoMarkdown.FilePath

}

#Write-Progress -id 1 -Completed
Write-DebugLog "All markdown files processed." 
