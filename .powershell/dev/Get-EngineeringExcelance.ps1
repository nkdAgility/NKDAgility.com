
# Helpers
. ./.powershell/_includes/IncludesForAll.ps1

$ErrorActionPreference = 'Stop'
$levelSwitch.MinimumLevel = 'Information'

###### EXPORT BLOG POSTS IN SCORE CHUNKS ######
# Configuration
$MinScore = 60    # Minimum score threshold (0-100, where 100 is best)
$ChunkSize = 10   # Score range per file (60-69, 70-79, 80-89, 90-100, etc.)
$classificationNames = @("Engineering Excellence", "Technical Leadership", "Lean", "DevOps", "Product Development", "Accountability", "Capability", "Discipline", "Ethos", "First Principle", "Model", "Observability", "Practice", "Principle", "Strategy", "Tenet", "Operating Model", "One Engineering System", "Adaptive Operating Model", "Predictive Operating Model", "Engineering Practices", "Flow Efficiency", "Throughput", "Lead Time", "Cycle Time", "Value Stream Management", "Value Stream Mapping", "Continuous Integration", "Continuous Delivery", "Deployment Strategies", "Release Management", "Definition of Done", "Technical Debt", "Technical Excellence", "Reversibility", "Change Safety", "Metrics and Learning", "Empirical Process Control", "Evidence Based Management", "Customer Feedback Loops", "Decision Making", "Decision Theory", "Operational Practices", "Platform Engineering", "Internal Developer Platform", "Site Reliability Engineering", "Systems Thinking", "Sociotechnical Systems", "Organisational Physics", "Complexity Thinking", "Feedback Loops", "Flow", "Learning Systems", "Quality as a Constraint", "Authority and Accountability Alignment", "System Design")

# Load all blog posts
Write-InformationLog "Loading blog posts..."
$hugoMarkdownObjects = Get-RecentHugoMarkdownResources -Path ".\site\content\resources\blog\" -YearsBack 100
$hugoMarkdownObjects += Get-RecentHugoMarkdownResources -Path ".\site\content\resources\case-studies\" -YearsBack 100

# Filter for posts with score above minimum, from 2018 onwards, sort by score descending
$cutoffDate = [DateTime]::Parse("2018-01-01")
$allPosts = $hugoMarkdownObjects | 
Where-Object { 
    $post = $_
    
    # Check date
    if (-not $post.FrontMatter.date) { return $false }
    if ([DateTime]::Parse($post.FrontMatter.date) -lt $cutoffDate) { return $false }
    
    # Include if any classification score is above minimum
    foreach ($name in $classificationNames) {
        $result = Get-Classification -hugoMarkdown $post -ClassificationName $name
        if ($result -and $result.final_score) {
            if ($result.final_score -ge $MinScore) {
                return $true
            }
        }
    }
    
    return $false
} | 
Sort-Object { 
    # Sort by the highest final_score from classifications (descending)
    $maxScore = 0
    
    # Check all classifications for highest score
    foreach ($name in $classificationNames) {
        $result = Get-Classification -hugoMarkdown $_ -ClassificationName $name
        if ($result -and $result.final_score) {
            if ($result.final_score -gt $maxScore) {
                $maxScore = $result.final_score
            }
        }
    }
    
    - $maxScore  # Negative for descending sort
}

Write-InformationLog "Found $($allPosts.Count) blog posts with score >= $MinScore"

# Ensure directories exist
$referenceDir = ".\\.resources\\reference"
$contentDir = ".\\.resources\\reference\\reference"
if (-not (Test-Path $referenceDir)) {
    New-Item -Path $referenceDir -ItemType Directory -Force | Out-Null
}
if (-not (Test-Path $contentDir)) {
    New-Item -Path $contentDir -ItemType Directory -Force | Out-Null
}

# Build catalog and create individual content files
$catalogEntries = @()

foreach ($post in $allPosts) {
    # Get classification results
    $classificationResults = @()
    $maxScore = 0
    $primaryClassification = ""
    
    foreach ($name in $classificationNames) {
        $result = Get-Classification -hugoMarkdown $post -ClassificationName $name
        if ($result -and $result.final_score) {
            $classificationResults += [ordered]@{
                label = $result.category
                score = [int]$result.final_score
            }
            
            if ($result.final_score -gt $maxScore) {
                $maxScore = $result.final_score
                $primaryClassification = $result.category
            }
        }
    }
    
    # Extract fields
    $itemId = if ($post.FrontMatter.ItemId) { $post.FrontMatter.ItemId } else { "unknown" }
    $ItemType = if ($post.FrontMatter.ItemType) { $post.FrontMatter.ItemType } else { "unknown" }
    $title = if ($post.FrontMatter.title) { $post.FrontMatter.title } else { "Untitled" }
    $tldr = if ($post.FrontMatter.tldr) { $post.FrontMatter.tldr } else { "" }
    $contentFileName = "reference-content-$itemId.md"
    
    # Sort classifications by score and take top 3
    $topClassifications = $classificationResults | Sort-Object -Property score -Descending | Select-Object -First 3
    
    # Add to catalog
    $catalogEntry = [ordered]@{
        id                     = $itemId
        type                   = $ItemType
        title                  = $title
        primary_classification = $primaryClassification
        scored                 = $topClassifications
        tldr                   = $tldr
        content_ref            = "reference/$contentFileName"
    }
    $catalogEntries += $catalogEntry
    
    # Create individual content file
    $contentPath = ".\.resources\reference\reference\$contentFileName"
    $contentData = [ordered]@{
        id              = $itemId
        title           = $title
        tldr            = $tldr
        classifications = $topClassifications
        content         = if ($post.BodyContent) { $post.BodyContent } else { "" }
    }
    
    ConvertTo-Yaml -Data $contentData -OutFile $contentPath -Force
    Write-InformationLog "Created content file: $contentFileName"
}

# Create catalog file with metadata
$catalogOutput = [ordered]@{
    context = [ordered]@{
        description             = "Catalog of reference content filtered by classification scores"
        classifications         = $classificationNames
        minimum_score_threshold = $MinScore
        filter_note             = "Posts included have at least one classification with a score >= $MinScore."
        content_count           = $catalogEntries.Count
        score_note              = "Scores range from 0-100, where 100 is the highest/best score"
        generated_date          = (Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ")
    }
    catalog = $catalogEntries
}

$catalogPath = ".\.resources\reference\catalog.yaml"
ConvertTo-Yaml -Data $catalogOutput -OutFile $catalogPath -Force
Write-InformationLog "Created catalog file: $catalogPath"

Write-InformationLog "All files created successfully. Total posts exported: $($allPosts.Count)"
