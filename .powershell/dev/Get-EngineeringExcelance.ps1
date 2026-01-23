
# Helpers
. ./.powershell/_includes/IncludesForAll.ps1

$ErrorActionPreference = 'Stop'
$levelSwitch.MinimumLevel = 'Information'

###### EXPORT BLOG POSTS IN WEIGHT CHUNKS ######
# Configuration
$MaxWeight = 400  # Change this value to set the maximum weight to process
$ChunkSize = 100  # Weight range per file (0-100, 101-200, etc.)

# Load all blog posts
Write-InformationLog "Loading blog posts..."
$hugoMarkdownObjects = Get-RecentHugoMarkdownResources -Path ".\site\content\resources\blog" -YearsBack 100

# Filter for posts with weight and under max, from 2014 onwards, sort by weight ascending
$cutoffDate = [DateTime]::Parse("2018-01-01")
$allPosts = $hugoMarkdownObjects | 
Where-Object { 
    $_.FrontMatter.date -and
    [DateTime]::Parse($_.FrontMatter.date) -ge $cutoffDate -and
    (
        # Include if old weight field exists and is under max
        ($_.FrontMatter.weight -and [int]$_.FrontMatter.weight -le $MaxWeight) -or
        # Include if any weightByClassification entry is under max
        ($_.FrontMatter.weightByClassification -and 
         ($_.FrontMatter.weightByClassification | Where-Object { $_.value -and [int]$_.value -le $MaxWeight }))
    )
} | 
Sort-Object { 
    # Sort by the lowest weight across both weight and weightByClassification
    if ($_.FrontMatter.weight) {
        [int]$_.FrontMatter.weight
    } elseif ($_.FrontMatter.weightByClassification) {
        ($_.FrontMatter.weightByClassification | Measure-Object -Property value -Minimum).Minimum
    } else {
        [int]::MaxValue
    }
}

Write-InformationLog "Found $($allPosts.Count) blog posts with weight <= $MaxWeight"

# Group posts by weight ranges
$weightRanges = @{}
foreach ($post in $allPosts) {
    # Get the minimum weight from either the old weight field or weightByClassification
    $weight = $null
    if ($post.FrontMatter.weight) {
        $weight = [int]$post.FrontMatter.weight
    } elseif ($post.FrontMatter.weightByClassification) {
        $weight = ($post.FrontMatter.weightByClassification | Measure-Object -Property value -Minimum).Minimum
    }
    
    if ($null -ne $weight) {
        $rangeStart = [math]::Floor($weight / $ChunkSize) * $ChunkSize
        $rangeEnd = $rangeStart + $ChunkSize - 1
        $rangeKey = "$rangeStart-$rangeEnd"
        
        if (-not $weightRanges.ContainsKey($rangeKey)) {
            $weightRanges[$rangeKey] = @()
        }
        $weightRanges[$rangeKey] += $post
    }
}

Write-InformationLog "Creating $($weightRanges.Count) output files for weight ranges"

# Process each weight range
foreach ($rangeKey in ($weightRanges.Keys | Sort-Object)) {
    $posts = $weightRanges[$rangeKey]
    $outputPath = ".\.resources\blog-posts-weight-$rangeKey.yaml"
    $postsArray = @()
    
    Write-InformationLog "Processing range $rangeKey with $($posts.Count) posts"
    
    $index = 0
    foreach ($post in $posts) {
        $index++
        
        # Extract required fields
        $title = if ($post.FrontMatter.title) { $post.FrontMatter.title } else { "" }
        $tldr = if ($post.FrontMatter.tldr) { $post.FrontMatter.tldr } else { "" }
        $itemId = if ($post.FrontMatter.ItemId) { $post.FrontMatter.ItemId } else { "" }
        $content = if ($post.BodyContent) { $post.BodyContent } else { "" }
        $weight = if ($post.FrontMatter.weight) { [int]$post.FrontMatter.weight } else { 0 }
        
        # Create ordered dictionary for this post
        $postObject = [ordered]@{
            weight  = $weight
            title   = $title
            tldr    = $tldr
            ItemId  = $itemId
            content = $content
        }
        
        # Add weightByClassification if it exists
        if ($post.FrontMatter.weightByClassification) {
            $postObject['weightByClassification'] = $post.FrontMatter.weightByClassification
        }
        
        $postsArray += $postObject
    }
    
    # Convert to YAML and write to file
    $yamlContent = ConvertTo-Yaml -Data $postsArray -OutFile $outputPath -Force
    Write-InformationLog "Written $($postsArray.Count) posts to: $outputPath"
}

Write-InformationLog "All files created successfully. Total posts exported: $($allPosts.Count)"
