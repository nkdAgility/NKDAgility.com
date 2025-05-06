# Helpers
. ./.powershell/_includes/LoggingHelper.ps1
. ./.powershell/_includes/OpenAI.ps1
. ./.powershell/_includes/HugoHelpers.ps1
. ./.powershell/_includes/ResourceHelpers.ps1
. ./.powershell/_includes/ClassificationHelpers.ps1
. ./.powershell/_includes/TokenServer.ps1

$hugoMarkdown = (Get-RecentHugoMarkdownResources -Path ".\site\content\resources\blog\2025" -YearsBack 1) | Select-Object -First 1

$catalog = $catalogues["catalog_full"]

$cachedData = Get-ClassificationsFromCache -hugoMarkdown $hugoMarkdown
$CatalogFromCache = @{}
$cachedData.Keys | Where-Object { $catalog.ContainsKey($_) } |
ForEach-Object { $CatalogFromCache[$_] = $cachedData[$_] }

$CatalogItemsToRefreshOrGet = Get-CatalogItemsToRefreshOrGet -cachedData $cachedData -Catalog $catalog -CatalogFromCache $CatalogFromCache
$prompts = @()


$duration = Measure-Command {   
    foreach ($category in $CatalogItemsToRefreshOrGet) {
        $promptText = Get-Prompt -PromptName "classification-analysis.md" -Parameters @{
            resourceId   = $hugoMarkdown.FrontMatter.ResourceId
            category     = $category
            Instructions = $Catalog[$category].Instructions
            title        = $hugoMarkdown.FrontMatter.Title
            abstract     = $hugoMarkdown.FrontMatter.Description
            content      = $hugoMarkdown.BodyContent
        }

        $tokenEstimate = Get-TokenCountFromServer -Content $promptText

        $promptObject = [PromptForHugoMarkdown]::new($promptText, [int]$tokenEstimate)


        $prompts += $promptObject
    }
}

Write-Host "Get-PromptsForHugoMarkdown took $($duration.TotalSeconds) seconds to do $($newPrompts.Count) prompts." -ForegroundColor Green
