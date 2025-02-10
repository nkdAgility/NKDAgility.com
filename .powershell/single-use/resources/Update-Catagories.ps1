

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
$resources = Get-ChildItem -Path $outputDir  -Recurse -Filter "index.md"  | Sort-Object { $_ } -Descending

$categoriesCatalog = Get-CatalogHashtable -Classification "categories"
$tagsCatalog = Get-CatalogHashtable -Classification "tags"

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

    Remove-ClassificationsFromCache -ClassificationsToRemove @("Value Stream Management", "Value Prioritisation", "Test Strategy", "Technical Strategy", "Systemic Thinking", "Strategic", "Software Increment", "Site Reliability", "Release Planning", "Predictability in Kanban", "Organisational Transformational Mastery", "Nonlinear Dynamics", "Lean UX", "Lean Agile", "Leadership Training", "Kanban Training", "Kanban Theory", "Kanban", "Kanban Process", "Kanban Flow", "Kanban Coaching", "Homepage", "Evidence Based Improvement", "Data Driven Decisions", "Continuos Delivery", "Complexity Science", "Agile Tools", "Agile Software Engineering", "Agile Software Development", "Agile Scaling", "Agile Resource Management", "Agile Project Management", "Agile Product Validation", "Agile Product Ownership", "Agile Product Management", "Discovery and Learning", "Agile Product Discovery", "Sprint Review Workshops", "Sprint Review Workshops", "Agile Portfolio Management", "Agile Certifications") -CacheFolder $resourceDir -ClassificationType "tags"
    #Remove-ClassificationsFromCacheThatLookBroken -ClassificationCatalog $tagsCatalog -CacheFolder $resourceDir -ClassificationType "tags"
}