# Get-MatchingClassificationsForResource.ps1
# Gets matching classifications for a Hugo Markdown resource by title match

# Include necessary helper modules
. ./.powershell/_includes/LoggingHelper.ps1
. ./.powershell/_includes/HugoHelpers.ps1

$ErrorActionPreference = 'Stop'

function Get-MatchingClassificationsForResource {
    <#
    .SYNOPSIS
    Gets matching classifications for a Hugo Markdown resource by title match, grouped by type.
    
    .DESCRIPTION
    This function loads the classifications cache for a Hugo Markdown object and returns
    matching classifications by title. It combines similarity scores from related items
    cache with classification confidence scores to provide comprehensive matching data.
    Results are grouped by classification type (concepts, categories, tags).
    
    .PARAMETER HugoMarkdown
    The HugoMarkdown object to get matching classifications for.
    
    .PARAMETER TopN
    Optional. Maximum number of results to return per group. Default is all results.
    
    .PARAMETER MinClassificationScore
    Optional. Minimum classification confidence score threshold. Default is 50.0.
    
    .EXAMPLE
    # Get all matching classifications for a resource grouped by type
    $classifications = Get-MatchingClassificationsForResource -HugoMarkdown $hugoMarkdown
    
    .EXAMPLE
    # Get top 10 high-confidence classifications per type
    $topClassifications = Get-MatchingClassificationsForResource -HugoMarkdown $hugoMarkdown -TopN 10 -MinClassificationScore 75.0
    #>param (
        [Parameter(Mandatory = $true)]
        [HugoMarkdown]$HugoMarkdown,
        
        [Parameter(Mandatory = $false)]
        [int]$TopN,
        
        [Parameter(Mandatory = $false)]
        [double]$MinClassificationScore = 50.0
    )    # Initialize results array
    $allResults = @()
    
    # Construct the cache file paths
    $relatedCachePath = Join-Path (Split-Path $HugoMarkdown.FilePath) 'data.index.related.json'
    $classificationsCachePath = Join-Path (Split-Path $HugoMarkdown.FilePath) 'data.index.classifications.json'
    
    # Create lookup tables for similarity scores and types from related items
    $similarityLookup = @{}
    $typeLookup = @{}
    
    try {
        # Load related items cache to get similarity scores and types
        if (Test-Path $relatedCachePath) {
            $relatedCacheData = Get-Content $relatedCachePath | ConvertFrom-Json
            $relatedItems = $relatedCacheData.related
            
            if ($relatedItems -and $relatedItems.Count -gt 0) {
                Write-DebugLog "Loaded $($relatedItems.Count) related items from cache for similarity and type lookup"
                
                # Build lookup tables by title for classifications only
                foreach ($item in $relatedItems) {
                    if ($item.EntryKind -eq "classification") {
                        $similarityLookup[$item.Title] = $item.Similarity
                        $typeLookup[$item.Title] = $item.EntryType
                    }
                }
            }
        }
        
        # Load classifications cache
        if (Test-Path $classificationsCachePath) {
            $classificationsCacheData = Get-Content $classificationsCachePath | ConvertFrom-Json
            
            if ($classificationsCacheData) {
                Write-DebugLog "Loaded classifications cache for '$($HugoMarkdown.FrontMatter.title)'"
                
                # Get the current resource title for matching
                $currentTitle = $HugoMarkdown.FrontMatter.title
                
                # Process classifications and look for title matches
                foreach ($classificationName in $classificationsCacheData.PSObject.Properties.Name) {
                    $classificationData = $classificationsCacheData.$classificationName
                    
                    # Only include classifications with high enough confidence and not ignored
                    if ($classificationData.final_score -ge $MinClassificationScore -and $classificationData.level -ne "Ignored") {
                        
                        # Try to match by title - look for the classification name in various formats
                        $titleMatch = $false
                        
                        # Check if this classification name appears in the current content's title
                        if ($currentTitle -match [regex]::Escape($classificationName)) {
                            $titleMatch = $true
                        }
                        
                        # Alternative: check if current title contains the classification (case-insensitive)
                        if ($currentTitle -like "*$classificationName*") {
                            $titleMatch = $true
                        }
                        # If we have a title match or high confidence, include this classification
                        if ($titleMatch -or $classificationData.final_score -ge 80.0) {
                            
                            # Get similarity score from related items lookup, default to 0 if not found
                            $similarity = if ($similarityLookup.ContainsKey($classificationName)) { 
                                $similarityLookup[$classificationName] 
                            }
                            else { 
                                0.0 
                            }
                            
                            # Get type from related items lookup, default to 'unknown' if not found
                            $classificationType = if ($typeLookup.ContainsKey($classificationName)) { 
                                $typeLookup[$classificationName] 
                            }
                            else { 
                                'unknown' 
                            }
                            
                            $allResults += [PSCustomObject]@{
                                Title       = $classificationName
                                Type        = $classificationType
                                Similarity  = $similarity
                                final_score = $classificationData.final_score
                            }
                        }
                    }
                }
                
                Write-DebugLog "Found $($allResults.Count) matching classifications for '$($HugoMarkdown.FrontMatter.title)'"
            }
        }
        else {
            Write-Warning "No classifications cache found for '$($HugoMarkdown.FrontMatter.title)' at path: $classificationsCachePath"
        }
        # Sort by final_score (descending - highest classification confidence first)
        $sortedItems = $allResults | Sort-Object final_score -Descending
        
        # Group results by classification type
        $groupedResults = @{
            concepts   = @()
            categories = @()
            tags       = @()
        }
        
        foreach ($item in $sortedItems) {
            switch ($item.Type) {
                'concepts' { $groupedResults.concepts += $item }
                'categories' { $groupedResults.categories += $item }
                'tags' { $groupedResults.tags += $item }
                default { 
                    # If type is unknown, try to classify based on title patterns or add to miscellaneous
                    Write-WarningLog "Unknown classification type '$($item.Type)' for '$($item.Title)'"
                    $groupedResults.tags += $item  # Default unknown types to tags
                }
            }
        }
        
        # Apply TopN limit to each group if specified
        if ($TopN -and $TopN -gt 0) {
            $groupedResults.concepts = $groupedResults.concepts | Select-Object -First $TopN
            $groupedResults.categories = $groupedResults.categories | Select-Object -First $TopN
            $groupedResults.tags = $groupedResults.tags | Select-Object -First $TopN
            Write-DebugLog "Limited each group to top $TopN items"
        }
        
        Write-InfoLog "Returning classifications grouped by type for '$($HugoMarkdown.FrontMatter.title)': Concepts: $($groupedResults.concepts.Count), Categories: $($groupedResults.categories.Count), Tags: $($groupedResults.tags.Count)"
        return $groupedResults
    }
    catch {
        Write-ErrorLog "Error loading or processing caches for '$($HugoMarkdown.FrontMatter.title)': $_"
        return @()
    }
}

<#
# Example usage and testing
if ($MyInvocation.InvocationName -eq '&') {
    # Only run examples if script is executed directly (not dot-sourced)
    
    # Example: Load a Hugo markdown file and get related items
    $testMarkdownPath = ".\site\content\resources\blog\2025\2025-07-21-rethinking-capacity-planning\index.md"
    if (Test-Path $testMarkdownPath) {
        $hugoMarkdown = Get-HugoMarkdown -Path $testMarkdownPath
        
        Write-Host "=== Testing Get-RelatedForResource with Classifications ===" -ForegroundColor Green
        
        # Test 1: Get all related items (including classifications)
        Write-Host "`n1. Getting all related items (with classifications)..." -ForegroundColor Yellow
        $allRelated = Get-RelatedForResource -HugoMarkdown $hugoMarkdown
        Write-Host "Found $($allRelated.Count) total related items"
        $relatedCount = ($allRelated | Where-Object {$_.Source -eq 'Related'}).Count
        $classificationCount = ($allRelated | Where-Object {$_.Source -eq 'Classifications'}).Count
        Write-Host "  - Related items: $relatedCount"
        Write-Host "  - Classifications: $classificationCount"
        
        # Test 2: Get only resource items (blogs, videos, etc.) - excludes classifications
        Write-Host "`n2. Getting only resource items..." -ForegroundColor Yellow
        $resourceItems = Get-RelatedForResource -HugoMarkdown $hugoMarkdown -Kind "resource"
        Write-Host "Found $($resourceItems.Count) resource items"
        
        # Test 3: Get only blog posts
        Write-Host "`n3. Getting only blog posts..." -ForegroundColor Yellow
        $blogItems = Get-RelatedForResource -HugoMarkdown $hugoMarkdown -Kind "resource" -Type "blog"
        Write-Host "Found $($blogItems.Count) blog items"
        
        # Test 4: Get only classification items from both sources
        Write-Host "`n4. Getting only classification items (both sources)..." -ForegroundColor Yellow
        $classificationItems = Get-RelatedForResource -HugoMarkdown $hugoMarkdown -Kind "classification"
        Write-Host "Found $($classificationItems.Count) classification items"
        
        # Test 5: Get only classifications from the classifications cache (high confidence)
        Write-Host "`n5. Getting high-confidence classifications only..." -ForegroundColor Yellow
        $highConfidenceClassifications = Get-RelatedForResource -HugoMarkdown $hugoMarkdown -Kind "classification" -Type "classifications" -MinClassificationScore 75.0
        Write-Host "Found $($highConfidenceClassifications.Count) high-confidence classifications"
        
        # Test 6: Get top 5 items with minimum similarity of 0.4 (exclude classifications cache)
        Write-Host "`n6. Getting top 5 items with similarity >= 0.4 (no classifications cache)..." -ForegroundColor Yellow
        $topItems = Get-RelatedForResource -HugoMarkdown $hugoMarkdown -TopN 5 -MinSimilarity 0.4 -IncludeClassifications $false
        Write-Host "Found $($topItems.Count) high-similarity items"
        
        # Display sample results
        if ($allRelated.Count -gt 0) {
            Write-Host "`nSample results (top 5 from all sources):" -ForegroundColor Cyan
            $allRelated | Select-Object -First 5 | ForEach-Object {
                Write-Host "  - $($_.Title) (Kind: $($_.EntryKind), Type: $($_.EntryType), Score: $($_.Similarity.ToString('F3')), Source: $($_.Source))"
            }
        }
        
        # Show classifications specifically
        if ($classificationCount -gt 0) {
            Write-Host "`nClassifications found:" -ForegroundColor Cyan
            $allRelated | Where-Object {$_.Source -eq 'Classifications'} | Select-Object -First 3 | ForEach-Object {
                Write-Host "  - $($_.Title) (Score: $($_.Similarity.ToString('F3')))"
            }
        }
    } else {
        Write-Warning "Test markdown file not found: $testMarkdownPath"
    }
}
#>


$testMarkdownPath = ".\site\content\resources\blog\2025\2025-07-21-rethinking-capacity-planning\index.md"
$hugoMarkdown = Get-HugoMarkdown -Path $testMarkdownPath

Write-Host "=== Testing Get-MatchingClassificationsForResource (Grouped by Type) ===" -ForegroundColor Green
$classificationGroups = Get-MatchingClassificationsForResource -HugoMarkdown $hugoMarkdown

Write-Host "`nClassification Results:" -ForegroundColor Cyan
Write-Host "  Concepts: $($classificationGroups.concepts.Count)" -ForegroundColor Yellow
Write-Host "  Categories: $($classificationGroups.categories.Count)" -ForegroundColor Yellow  
Write-Host "  Tags: $($classificationGroups.tags.Count)" -ForegroundColor Yellow

if ($classificationGroups.concepts.Count -gt 0) {
    Write-Host "`nTop Concepts:" -ForegroundColor Cyan
    $classificationGroups.concepts | Select-Object -First 3 | ForEach-Object {
        Write-Host "  - $($_.Title) (Similarity: $($_.Similarity.ToString('F3')), Score: $($_.final_score))"
    }
}

if ($classificationGroups.categories.Count -gt 0) {
    Write-Host "`nTop Categories:" -ForegroundColor Cyan
    $classificationGroups.categories | Select-Object -First 3 | ForEach-Object {
        Write-Host "  - $($_.Title) (Similarity: $($_.Similarity.ToString('F3')), Score: $($_.final_score))"
    }
}

if ($classificationGroups.tags.Count -gt 0) {
    Write-Host "`nTop Tags:" -ForegroundColor Cyan
    $classificationGroups.tags | Select-Object -First 5 | ForEach-Object {
        Write-Host "  - $($_.Title) (Similarity: $($_.Similarity.ToString('F3')), Score: $($_.final_score))"
    }
}