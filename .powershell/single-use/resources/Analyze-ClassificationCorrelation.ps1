# Analyze-ClassificationCorrelation.ps1
# Analyzes correlation between Similarity scores and final_scores to optimize AI classification costs

# Include necessary helper modules
. ./.powershell/_includes/LoggingHelper.ps1
. ./.powershell/_includes/HugoHelpers.ps1
. ./.powershell/single-use/resources/Get-RelatedForResource.ps1

$ErrorActionPreference = 'Stop'

function Get-ClassificationDataForAnalysis {
    <#
    .SYNOPSIS
    Gets classification data for correlation analysis between Similarity and final_score.
    
    .DESCRIPTION
    This function extracts all classification data with both similarity scores and final scores
    to analyze the correlation and determine optimal thresholds for cost optimization.
    
    .PARAMETER HugoMarkdown
    The HugoMarkdown object to analyze.
    
    .PARAMETER MinClassificationScore
    Optional. Minimum classification confidence score threshold. Default is 0.0 to get all data.
    #>
    param (
        [Parameter(Mandatory = $true)]
        [HugoMarkdown]$HugoMarkdown,
        
        [Parameter(Mandatory = $false)]
        [double]$MinClassificationScore = 0.0
    )
    
    $allData = @()
    
    # Construct the cache file paths
    $relatedCachePath = Join-Path (Split-Path $HugoMarkdown.FilePath) 'data.index.related.json'
    $classificationsCachePath = Join-Path (Split-Path $HugoMarkdown.FilePath) 'data.index.classifications.json'
    
    # Create lookup tables from related items
    $similarityLookup = @{}
    $typeLookup = @{}
    
    try {
        # Load related items cache
        if (Test-Path $relatedCachePath) {
            $relatedCacheData = Get-Content $relatedCachePath | ConvertFrom-Json
            $relatedItems = $relatedCacheData.related
            
            if ($relatedItems -and $relatedItems.Count -gt 0) {
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
                # Process all classifications
                foreach ($classificationName in $classificationsCacheData.PSObject.Properties.Name) {
                    $classificationData = $classificationsCacheData.$classificationName
                    
                    # Include all classifications above minimum threshold
                    if ($classificationData.final_score -ge $MinClassificationScore -and $classificationData.level -ne "Ignored") {
                        
                        # Get data from lookups
                        $similarity = if ($similarityLookup.ContainsKey($classificationName)) { 
                            $similarityLookup[$classificationName] 
                        } else { 0.0 }
                        
                        $classificationType = if ($typeLookup.ContainsKey($classificationName)) { 
                            $typeLookup[$classificationName] 
                        } else { 'unknown' }
                        
                        $allData += [PSCustomObject]@{
                            Title = $classificationName
                            Type = $classificationType
                            Similarity = $similarity
                            final_score = $classificationData.final_score
                            HasSimilarityData = $similarity -gt 0
                            SimilarityBucket = [Math]::Floor($similarity * 10) / 10  # Round to nearest 0.1
                            ScoreBucket = [Math]::Floor($classificationData.final_score / 10) * 10  # Round to nearest 10
                        }
                    }
                }
            }
        }
        
        Write-InfoLog "Extracted $($allData.Count) classification data points for analysis"
        return $allData
    }
    catch {
        Write-ErrorLog "Error extracting classification data: $_"
        return @()
    }
}

function Show-CorrelationAnalysis {
    <#
    .SYNOPSIS
    Displays correlation analysis between Similarity and final_score.
    #>
    param (
        [Parameter(Mandatory = $true)]
        [array]$Data
    )
    
    Write-Host "`n=== CLASSIFICATION CORRELATION ANALYSIS ===" -ForegroundColor Green
    
    # Filter to only data points that have similarity scores
    $dataWithSimilarity = $Data | Where-Object { $_.HasSimilarityData }
    
    Write-Host "`nData Summary:" -ForegroundColor Cyan
    Write-Host "  Total Classifications: $($Data.Count)" -ForegroundColor White
    Write-Host "  With Similarity Data: $($dataWithSimilarity.Count)" -ForegroundColor White
    Write-Host "  Without Similarity: $($Data.Count - $dataWithSimilarity.Count)" -ForegroundColor White
    
    if ($dataWithSimilarity.Count -eq 0) {
        Write-Warning "No classifications with similarity data found!"
        return
    }
    
    # Basic statistics
    $similarityStats = $dataWithSimilarity | Measure-Object -Property Similarity -Average -Minimum -Maximum
    $scoreStats = $dataWithSimilarity | Measure-Object -Property final_score -Average -Minimum -Maximum
    
    Write-Host "`nSimilarity Statistics:" -ForegroundColor Cyan
    Write-Host "  Min: $($similarityStats.Minimum.ToString('F3'))" -ForegroundColor White
    Write-Host "  Max: $($similarityStats.Maximum.ToString('F3'))" -ForegroundColor White
    Write-Host "  Avg: $($similarityStats.Average.ToString('F3'))" -ForegroundColor White
    
    Write-Host "`nFinal Score Statistics:" -ForegroundColor Cyan
    Write-Host "  Min: $($scoreStats.Minimum.ToString('F1'))" -ForegroundColor White
    Write-Host "  Max: $($scoreStats.Maximum.ToString('F1'))" -ForegroundColor White
    Write-Host "  Avg: $($scoreStats.Average.ToString('F1'))" -ForegroundColor White
    
    # Correlation analysis
    $correlationData = $dataWithSimilarity | Select-Object Similarity, final_score
    
    # Calculate Pearson correlation coefficient manually
    $n = $correlationData.Count
    $sumX = ($correlationData | Measure-Object -Property Similarity -Sum).Sum
    $sumY = ($correlationData | Measure-Object -Property final_score -Sum).Sum
    $sumXY = ($correlationData | ForEach-Object { $_.Similarity * $_.final_score } | Measure-Object -Sum).Sum
    $sumX2 = ($correlationData | ForEach-Object { $_.Similarity * $_.Similarity } | Measure-Object -Sum).Sum
    $sumY2 = ($correlationData | ForEach-Object { $_.final_score * $_.final_score } | Measure-Object -Sum).Sum
    
    $correlation = ($n * $sumXY - $sumX * $sumY) / [Math]::Sqrt(($n * $sumX2 - $sumX * $sumX) * ($n * $sumY2 - $sumY * $sumY))
    
    Write-Host "`nCorrelation Analysis:" -ForegroundColor Cyan
    Write-Host "  Pearson Correlation: $($correlation.ToString('F4'))" -ForegroundColor White
    
    $correlationStrength = if ([Math]::Abs($correlation) -gt 0.7) { "Strong" }
                          elseif ([Math]::Abs($correlation) -gt 0.5) { "Moderate" }
                          elseif ([Math]::Abs($correlation) -gt 0.3) { "Weak" }
                          else { "Very Weak" }
    
    Write-Host "  Strength: $correlationStrength" -ForegroundColor $(if ($correlationStrength -in @("Strong", "Moderate")) { "Green" } else { "Yellow" })
    
    return $correlation
}

function Show-ThresholdAnalysis {
    <#
    .SYNOPSIS
    Shows how different similarity thresholds would affect classification filtering.
    #>
    param (
        [Parameter(Mandatory = $true)]
        [array]$Data
    )
    
    Write-Host "`n=== THRESHOLD ANALYSIS ===" -ForegroundColor Green
    
    $dataWithSimilarity = $Data | Where-Object { $_.HasSimilarityData }
    
    if ($dataWithSimilarity.Count -eq 0) {
        Write-Warning "No similarity data available for threshold analysis"
        return
    }
    
    Write-Host "`nThreshold Impact Analysis:" -ForegroundColor Cyan
    Write-Host "If you used Similarity as a pre-filter before expensive AI calls:" -ForegroundColor White
    
    $thresholds = @(0.0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9)
    
    foreach ($threshold in $thresholds) {
        $aboveThreshold = $dataWithSimilarity | Where-Object { $_.Similarity -ge $threshold }
        $belowThreshold = $dataWithSimilarity | Where-Object { $_.Similarity -lt $threshold }
        
        # Calculate what we'd save and what we'd miss
        $highScoresMissed = $belowThreshold | Where-Object { $_.final_score -ge 80 }
        $lowScoresSaved = $belowThreshold | Where-Object { $_.final_score -lt 50 }
        
        $percentKept = if ($dataWithSimilarity.Count -gt 0) { 
            [Math]::Round(($aboveThreshold.Count / $dataWithSimilarity.Count) * 100, 1) 
        } else { 0 }
        
        $percentSaved = if ($dataWithSimilarity.Count -gt 0) { 
            [Math]::Round((100 - $percentKept), 1) 
        } else { 0 }
        
        Write-Host "`n  Similarity ≥ $($threshold.ToString('F1')):" -ForegroundColor Yellow
        Write-Host "    Keep: $($aboveThreshold.Count) items ($percentKept%)" -ForegroundColor White
        Write-Host "    Skip: $($belowThreshold.Count) items ($percentSaved% cost savings)" -ForegroundColor Green
        Write-Host "    High-value missed: $($highScoresMissed.Count) (final_score ≥ 80)" -ForegroundColor $(if ($highScoresMissed.Count -eq 0) { "Green" } else { "Red" })
        Write-Host "    Low-value saved: $($lowScoresSaved.Count) (final_score < 50)" -ForegroundColor Green
    }
}

function Show-DetailedVisualization {
    <#
    .SYNOPSIS
    Shows comprehensive visualization of correlation data including scatter plot, distribution charts, and quality zones.
    #>
    param (
        [Parameter(Mandatory = $true)]
        [array]$Data
    )
    
    $dataWithSimilarity = $Data | Where-Object { $_.HasSimilarityData }
    
    if ($dataWithSimilarity.Count -eq 0) {
        Write-Warning "No similarity data available for visualization"
        return
    }
    
    # Show scatter plot
    Show-ScatterPlotText -Data $Data
    
    # Show distribution analysis
    Show-DistributionAnalysis -Data $Data
    
    # Show quality zones
    Show-QualityZoneAnalysis -Data $Data
    
    # Show prediction accuracy
    Show-PredictionAccuracy -Data $Data
}

function Show-DistributionAnalysis {
    <#
    .SYNOPSIS
    Shows distribution of similarity and final scores in histogram format.
    #>
    param (
        [Parameter(Mandatory = $true)]
        [array]$Data
    )
    
    Write-Host "`n=== DISTRIBUTION ANALYSIS ===" -ForegroundColor Green
    
    $dataWithSimilarity = $Data | Where-Object { $_.HasSimilarityData }
    
    # Similarity distribution
    Write-Host "`nSimilarity Score Distribution:" -ForegroundColor Cyan
    $simBuckets = @{}
    for ($i = 0; $i -lt 10; $i++) {
        $simBuckets["$($i/10.0)-$((($i+1)/10.0))"] = 0
    }
    
    foreach ($point in $dataWithSimilarity) {
        $bucket = [Math]::Floor($point.Similarity * 10)
        if ($bucket -eq 10) { $bucket = 9 }  # Handle edge case
        $key = "$($bucket/10.0)-$((($bucket+1)/10.0))"
        $simBuckets[$key]++
    }
    
    $maxCount = ($simBuckets.Values | Measure-Object -Maximum).Maximum
    foreach ($bucket in $simBuckets.Keys | Sort-Object) {
        $count = $simBuckets[$bucket]
        $bar = "█" * [Math]::Max(1, [Math]::Floor(($count / $maxCount) * 30))
        Write-Host "  $bucket : $bar ($count)" -ForegroundColor White
    }
    
    # Final score distribution
    Write-Host "`nFinal Score Distribution:" -ForegroundColor Cyan
    $scoreBuckets = @{}
    for ($i = 0; $i -lt 10; $i++) {
        $scoreBuckets["$($i*10)-$(($i+1)*10)"] = 0
    }
    
    foreach ($point in $dataWithSimilarity) {
        $bucket = [Math]::Floor($point.final_score / 10)
        if ($bucket -eq 10) { $bucket = 9 }  # Handle edge case
        $key = "$($bucket*10)-$(($bucket+1)*10)"
        $scoreBuckets[$key]++
    }
    
    $maxCount = ($scoreBuckets.Values | Measure-Object -Maximum).Maximum
    foreach ($bucket in $scoreBuckets.Keys | Sort-Object) {
        $count = $scoreBuckets[$bucket]
        $bar = "█" * [Math]::Max(1, [Math]::Floor(($count / $maxCount) * 30))
        Write-Host "  $bucket : $bar ($count)" -ForegroundColor White
    }
}

function Show-QualityZoneAnalysis {
    <#
    .SYNOPSIS
    Analyzes data in different quality zones to identify patterns.
    #>
    param (
        [Parameter(Mandatory = $true)]
        [array]$Data
    )
    
    Write-Host "`n=== QUALITY ZONE ANALYSIS ===" -ForegroundColor Green
    
    $dataWithSimilarity = $Data | Where-Object { $_.HasSimilarityData }
    
    # Define quality zones
    $zones = @{
        "High Quality (final_score ≥ 80)" = $dataWithSimilarity | Where-Object { $_.final_score -ge 80 }
        "Medium Quality (50-79)" = $dataWithSimilarity | Where-Object { $_.final_score -ge 50 -and $_.final_score -lt 80 }
        "Low Quality (< 50)" = $dataWithSimilarity | Where-Object { $_.final_score -lt 50 }
    }
    
    foreach ($zoneName in $zones.Keys) {
        $zoneData = $zones[$zoneName]
        
        if ($zoneData.Count -eq 0) {
            Write-Host "`n$zoneName : No data" -ForegroundColor Gray
            continue
        }
        
        $simStats = $zoneData | Measure-Object -Property Similarity -Average -Minimum -Maximum
        
        Write-Host "`n$zoneName :" -ForegroundColor Cyan
        Write-Host "  Count: $($zoneData.Count)" -ForegroundColor White
        Write-Host "  Similarity Range: $($simStats.Minimum.ToString('F3')) - $($simStats.Maximum.ToString('F3'))" -ForegroundColor White
        Write-Host "  Avg Similarity: $($simStats.Average.ToString('F3'))" -ForegroundColor White
        
        # Show similarity thresholds that would capture different percentages
        $sortedSim = $zoneData | Sort-Object Similarity
        $percentiles = @(50, 75, 90, 95)
        Write-Host "  Similarity Percentiles:" -ForegroundColor Yellow
        foreach ($p in $percentiles) {
            $index = [Math]::Floor(($sortedSim.Count - 1) * $p / 100)
            $value = $sortedSim[$index].Similarity
            Write-Host "    ${p}th percentile: $($value.ToString('F3'))" -ForegroundColor White
        }
    }
}

function Show-PredictionAccuracy {
    <#
    .SYNOPSIS
    Tests how well similarity scores predict final score quality levels.
    #>
    param (
        [Parameter(Mandatory = $true)]
        [array]$Data
    )
    
    Write-Host "`n=== PREDICTION ACCURACY ANALYSIS ===" -ForegroundColor Green
    
    $dataWithSimilarity = $Data | Where-Object { $_.HasSimilarityData }
    
    Write-Host "`nTesting Similarity as Predictor for High-Quality Classifications:" -ForegroundColor Cyan
    
    $thresholds = @(0.3, 0.4, 0.5, 0.6, 0.7, 0.8)
    
    foreach ($threshold in $thresholds) {
        # Predict high quality (final_score >= 80) using similarity threshold
        $predictedHigh = $dataWithSimilarity | Where-Object { $_.Similarity -ge $threshold }
        $actualHigh = $dataWithSimilarity | Where-Object { $_.final_score -ge 80 }
        
        # Calculate confusion matrix
        $truePositive = $predictedHigh | Where-Object { $_.final_score -ge 80 }
        $falsePositive = $predictedHigh | Where-Object { $_.final_score -lt 80 }
        $falseNegative = $dataWithSimilarity | Where-Object { $_.Similarity -lt $threshold -and $_.final_score -ge 80 }
        $trueNegative = $dataWithSimilarity | Where-Object { $_.Similarity -lt $threshold -and $_.final_score -lt 80 }
        
        $precision = if ($predictedHigh.Count -gt 0) { $truePositive.Count / $predictedHigh.Count } else { 0 }
        $recall = if ($actualHigh.Count -gt 0) { $truePositive.Count / $actualHigh.Count } else { 0 }
        $accuracy = ($truePositive.Count + $trueNegative.Count) / $dataWithSimilarity.Count
        
        Write-Host "`n  Similarity ≥ $($threshold.ToString('F1')) predicts high quality:" -ForegroundColor Yellow
        Write-Host "    Precision: $($precision.ToString('F3')) (% of predictions that were correct)" -ForegroundColor White
        Write-Host "    Recall: $($recall.ToString('F3')) (% of high-quality items found)" -ForegroundColor White
        Write-Host "    Accuracy: $($accuracy.ToString('F3')) (% of all predictions correct)" -ForegroundColor White
        Write-Host "    Would process: $($predictedHigh.Count) / $($dataWithSimilarity.Count) items ($([Math]::Round($predictedHigh.Count/$dataWithSimilarity.Count*100,1))%)" -ForegroundColor Green
    }
}

function Show-ScatterPlotText {
    <#
    .SYNOPSIS
    Creates a text-based scatter plot showing the relationship between Similarity and final_score.
    #>
    param (
        [Parameter(Mandatory = $true)]
        [array]$Data
    )
    
    Write-Host "`n=== SCATTER PLOT (Text-Based) ===" -ForegroundColor Green
    
    $dataWithSimilarity = $Data | Where-Object { $_.HasSimilarityData }
    
    if ($dataWithSimilarity.Count -eq 0) {
        Write-Warning "No similarity data available for scatter plot"
        return
    }
    
    Write-Host "`nSimilarity vs Final Score Relationship:" -ForegroundColor Cyan
    Write-Host "X-axis: Similarity (0.0 to 1.0), Y-axis: Final Score (0 to 100)" -ForegroundColor White
    Write-Host "Legend: . = 1 point, o = 2-3 points, O = 4-5 points, @ = 6+ points" -ForegroundColor White
    Write-Host "Colors: Green = High quality (≥80), Yellow = Medium (50-79), Red = Low (<50)" -ForegroundColor White
    
    # Create a 2D grid for plotting
    $gridWidth = 50
    $gridHeight = 20
    $grid = New-Object 'int[,]' $gridHeight, $gridWidth
    $qualityGrid = New-Object 'double[,]' $gridHeight, $gridWidth  # Track average quality per cell
    
    # Map data points to grid
    foreach ($point in $dataWithSimilarity) {
        $x = [Math]::Min([Math]::Floor($point.Similarity * ($gridWidth - 1)), $gridWidth - 1)
        $y = [Math]::Min([Math]::Floor((100 - $point.final_score) / 100 * ($gridHeight - 1)), $gridHeight - 1)
          if ($x -ge 0 -and $x -lt $gridWidth -and $y -ge 0 -and $y -lt $gridHeight) {
            $grid[$y, $x]++
            # Track quality for color coding
            if ($qualityGrid[$y, $x] -eq 0) {
                $qualityGrid[$y, $x] = $point.final_score
            } else {
                $qualityGrid[$y, $x] = ($qualityGrid[$y, $x] + $point.final_score) / 2
            }
        }
    }
    
    Write-Host "`n100 |" -NoNewline -ForegroundColor Gray
    for ($y = 0; $y -lt $gridHeight; $y++) {
        if ($y -gt 0) {
            $scoreLabel = [Math]::Round(100 - ($y / ($gridHeight - 1)) * 100)
            Write-Host ("{0,3} |" -f $scoreLabel) -NoNewline -ForegroundColor Gray
        }
          for ($x = 0; $x -lt $gridWidth; $x++) {
            $count = $grid[$y, $x]
            $avgQuality = $qualityGrid[$y, $x]
            
            if ($count -eq 0) {
                Write-Host " " -NoNewline -ForegroundColor Gray
            } else {
                $symbol = if ($count -eq 1) { "." }
                         elseif ($count -le 3) { "o" }
                         elseif ($count -le 5) { "O" }
                         else { "@" }
                
                $color = if ($avgQuality -ge 80) { "Green" }
                        elseif ($avgQuality -ge 50) { "Yellow" }
                        else { "Red" }
                
                Write-Host $symbol -NoNewline -ForegroundColor $color
            }
        }
        Write-Host ""
    }
    
    Write-Host "    +" -NoNewline -ForegroundColor Gray
    Write-Host ("-" * $gridWidth) -ForegroundColor Gray
    Write-Host "    0.0" -NoNewline -ForegroundColor Gray
    Write-Host (" " * ($gridWidth - 10)) -NoNewline
    Write-Host "1.0" -ForegroundColor Gray
}

function Show-OptimizationRecommendations {
    <#
    .SYNOPSIS
    Provides specific recommendations for optimizing classification costs based on correlation analysis.
    #>
    param (
        [Parameter(Mandatory = $true)]
        [array]$Data,
        
        [Parameter(Mandatory = $true)]
        [double]$Correlation
    )
    
    Write-Host "`n=== OPTIMIZATION RECOMMENDATIONS ===" -ForegroundColor Green
    
    $dataWithSimilarity = $Data | Where-Object { $_.HasSimilarityData }
    
    if ($dataWithSimilarity.Count -eq 0) {
        Write-Warning "No similarity data available for recommendations"
        return
    }
    
    Write-Host "`nBased on correlation analysis:" -ForegroundColor Cyan
    
    if ([Math]::Abs($Correlation) -gt 0.7) {
        Write-Host "✓ STRONG CORRELATION: Similarity is highly predictive of final scores!" -ForegroundColor Green
        
        # Find optimal threshold for maximum cost savings with minimal quality loss
        $bestThreshold = Find-OptimalThreshold -Data $dataWithSimilarity -MaxQualityLoss 0.05
        
        Write-Host "`nRecommended Strategy:" -ForegroundColor Yellow
        Write-Host "  1. Use Similarity ≥ $($bestThreshold.ToString('F2')) as pre-filter" -ForegroundColor White
        Write-Host "  2. Only run expensive AI on items above threshold" -ForegroundColor White
        Write-Host "  3. Auto-reject items below threshold" -ForegroundColor White
        
        $savings = ($dataWithSimilarity | Where-Object { $_.Similarity -lt $bestThreshold }).Count / $dataWithSimilarity.Count
        Write-Host "  4. Expected cost savings: $([Math]::Round($savings * 100, 1))%" -ForegroundColor Green
        
    } elseif ([Math]::Abs($Correlation) -gt 0.5) {
        Write-Host "✓ MODERATE CORRELATION: Similarity can help reduce costs" -ForegroundColor Yellow
        
        Write-Host "`nRecommended Strategy:" -ForegroundColor Yellow
        Write-Host "  1. Use conservative Similarity threshold (≥ 0.3)" -ForegroundColor White
        Write-Host "  2. Run AI on all items above threshold" -ForegroundColor White
        Write-Host "  3. Sample items below threshold for validation" -ForegroundColor White
        Write-Host "  4. Monitor false negative rate closely" -ForegroundColor White
        
    } elseif ([Math]::Abs($Correlation) -gt 0.3) {
        Write-Host "⚠ WEAK CORRELATION: Limited cost optimization potential" -ForegroundColor Yellow
        
        Write-Host "`nRecommended Strategy:" -ForegroundColor Yellow
        Write-Host "  1. Use very low threshold (≥ 0.1) to catch obvious non-matches" -ForegroundColor White
        Write-Host "  2. Continue running AI on most items" -ForegroundColor White
        Write-Host "  3. Focus on improving similarity algorithm" -ForegroundColor White
        Write-Host "  4. Consider other pre-filtering features" -ForegroundColor White
        
    } else {
        Write-Host "❌ VERY WEAK CORRELATION: Do not use Similarity as pre-filter" -ForegroundColor Red
        
        Write-Host "`nRecommended Strategy:" -ForegroundColor Yellow
        Write-Host "  1. Continue running AI on all items" -ForegroundColor White
        Write-Host "  2. Investigate similarity calculation issues" -ForegroundColor White
        Write-Host "  3. Consider alternative features for pre-filtering" -ForegroundColor White
        Write-Host "  4. Focus on improving AI model efficiency" -ForegroundColor White
    }
    
    # Show type-specific recommendations
    Show-TypeSpecificRecommendations -Data $dataWithSimilarity
}

function Find-OptimalThreshold {
    <#
    .SYNOPSIS
    Finds the optimal similarity threshold that maximizes cost savings while maintaining quality.
    #>
    param (
        [Parameter(Mandatory = $true)]
        [array]$Data,
        
        [Parameter(Mandatory = $false)]
        [double]$MaxQualityLoss = 0.05  # 5% acceptable quality loss
    )
    
    $thresholds = 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9
    $bestThreshold = 0.0
    $bestScore = -1
    
    $highQualityItems = $Data | Where-Object { $_.final_score -ge 80 }
    $totalHighQuality = $highQualityItems.Count
    
    foreach ($threshold in $thresholds) {
        $itemsAboveThreshold = $Data | Where-Object { $_.Similarity -ge $threshold }
        $highQualityFound = $itemsAboveThreshold | Where-Object { $_.final_score -ge 80 }
        
        $recall = if ($totalHighQuality -gt 0) { $highQualityFound.Count / $totalHighQuality } else { 0 }
        $costSaving = 1 - ($itemsAboveThreshold.Count / $Data.Count)
        
        # Only consider thresholds that maintain acceptable quality
        if ($recall -ge (1 - $MaxQualityLoss)) {
            $score = $costSaving  # Maximize cost savings while maintaining quality
            
            if ($score -gt $bestScore) {
                $bestScore = $score
                $bestThreshold = $threshold
            }
        }
    }
    
    return $bestThreshold
}

function Show-TypeSpecificRecommendations {
    <#
    .SYNOPSIS
    Shows recommendations specific to different classification types.
    #>
    param (
        [Parameter(Mandatory = $true)]
        [array]$Data
    )
    
    Write-Host "`nType-Specific Analysis:" -ForegroundColor Cyan
    
    $typeGroups = $Data | Group-Object Type
    
    foreach ($group in $typeGroups) {
        $typeName = if ($group.Name) { $group.Name } else { "Unknown" }
        $typeData = $group.Group
        
        if ($typeData.Count -lt 5) {
            Write-Host "  $typeName : Too few samples ($($typeData.Count)) for analysis" -ForegroundColor Gray
            continue
        }
        
        $correlation = Get-TypeCorrelation -Data $typeData
        $avgSimilarity = ($typeData | Measure-Object -Property Similarity -Average).Average
        $avgScore = ($typeData | Measure-Object -Property final_score -Average).Average
        
        Write-Host "  $typeName ($($typeData.Count) items):" -ForegroundColor Yellow
        Write-Host "    Correlation: $($correlation.ToString('F3'))" -ForegroundColor White
        Write-Host "    Avg Similarity: $($avgSimilarity.ToString('F3'))" -ForegroundColor White
        Write-Host "    Avg Score: $($avgScore.ToString('F1'))" -ForegroundColor White
        
        if ([Math]::Abs($correlation) -gt 0.5) {
            Write-Host "    Recommendation: Good candidate for similarity pre-filtering" -ForegroundColor Green
        } else {
            Write-Host "    Recommendation: Use with caution or avoid pre-filtering" -ForegroundColor Yellow
        }
    }
}

function Get-TypeCorrelation {
    <#
    .SYNOPSIS
    Calculates correlation for a specific type of classification.
    #>
    param (
        [Parameter(Mandatory = $true)]
        [array]$Data
    )
    
    if ($Data.Count -lt 2) {
        return 0
    }
    
    $n = $Data.Count
    $sumX = ($Data | Measure-Object -Property Similarity -Sum).Sum
    $sumY = ($Data | Measure-Object -Property final_score -Sum).Sum
    $sumXY = ($Data | ForEach-Object { $_.Similarity * $_.final_score } | Measure-Object -Sum).Sum
    $sumX2 = ($Data | ForEach-Object { $_.Similarity * $_.Similarity } | Measure-Object -Sum).Sum
    $sumY2 = ($Data | ForEach-Object { $_.final_score * $_.final_score } | Measure-Object -Sum).Sum
    
    $denominator = [Math]::Sqrt(($n * $sumX2 - $sumX * $sumX) * ($n * $sumY2 - $sumY * $sumY))
    
    if ($denominator -eq 0) {
        return 0
    }
    
    return ($n * $sumXY - $sumX * $sumY) / $denominator
}

function Export-AnalysisData {
    <#
    .SYNOPSIS
    Exports the analysis data to CSV for further analysis in Excel or other tools.
    #>
    param (
        [Parameter(Mandatory = $true)]
        [array]$Data,
        
        [Parameter(Mandatory = $true)]
        [string]$FilePath
    )
    
    # Ensure the output directory exists
    $outputDir = Split-Path -Path $FilePath -Parent
    if (-not (Test-Path $outputDir)) {
        New-Item -Path $outputDir -ItemType Directory -Force | Out-Null
    }
    
    $Data | Export-Csv -Path $FilePath -NoTypeInformation
    Write-Host "`nData exported to: $FilePath" -ForegroundColor Green
    Write-Host "You can open this in Excel to create charts and perform further analysis." -ForegroundColor White
}

# Main analysis function
function Invoke-ClassificationCorrelationAnalysis {
    <#
    .SYNOPSIS
    Performs complete correlation analysis between Similarity and final_score.
    #>
    param (
        [Parameter(Mandatory = $true)]
        [string]$MarkdownPath,
        
        [Parameter(Mandatory = $false)]
        [string]$ExportPath = $null,
        
        [Parameter(Mandatory = $false)]
        [switch]$DetailedVisualization,
          [Parameter(Mandatory = $false)]
        [switch]$ShowRecommendations
    )
    
    if (-not (Test-Path $MarkdownPath)) {
        Write-Error "Markdown file not found: $MarkdownPath"
        return
    }
    
    # Set up default export path in organized directory structure if not provided
    if (-not $ExportPath -and $MarkdownPath) {
        $resourceName = (Get-Item $MarkdownPath).BaseName
        $ExportPath = "c:\Users\MartinHinshelwoodNKD\source\repos\NKDAgility.com\.data\classification-correlation\analysis\csv\${resourceName}_correlation_analysis.csv"
    }
    
    Write-Host "Loading Hugo Markdown from: $MarkdownPath" -ForegroundColor Cyan
    $hugoMarkdown = Get-HugoMarkdown -Path $MarkdownPath
    
    Write-Host "Extracting classification data for analysis..." -ForegroundColor Cyan
    $analysisData = Get-ClassificationDataForAnalysis -HugoMarkdown $hugoMarkdown
    
    if ($analysisData.Count -eq 0) {
        Write-Warning "No classification data found for analysis"
        return
    }
    
    # Perform core analyses
    $correlation = Show-CorrelationAnalysis -Data $analysisData
    Show-ThresholdAnalysis -Data $analysisData
    
    # Show visualizations
    if ($DetailedVisualization) {
        Show-DetailedVisualization -Data $analysisData
    } else {
        Show-ScatterPlotText -Data $analysisData
    }
      # Show recommendations (default to true unless explicitly disabled)
    if ($ShowRecommendations -or -not $PSBoundParameters.ContainsKey('ShowRecommendations')) {
        Show-OptimizationRecommendations -Data $analysisData -Correlation $correlation
    }
    
    # Export data if path provided or auto-generated
    if ($ExportPath) {
        Export-AnalysisData -Data $analysisData -FilePath $ExportPath
    }
    
    # Summary recommendations
    Write-Host "`n=== SUMMARY ===" -ForegroundColor Green
    
    $dataWithSimilarity = $analysisData | Where-Object { $_.HasSimilarityData }
    Write-Host "Analysis completed on $($dataWithSimilarity.Count) classifications with similarity data" -ForegroundColor White
    Write-Host "Correlation strength: $(if ([Math]::Abs($correlation) -gt 0.7) { "Strong" } elseif ([Math]::Abs($correlation) -gt 0.5) { "Moderate" } elseif ([Math]::Abs($correlation) -gt 0.3) { "Weak" } else { "Very Weak" })" -ForegroundColor $(if ([Math]::Abs($correlation) -gt 0.5) { "Green" } else { "Yellow" })
    
    if ($ExportPath) {
        Write-Host "Data exported to: $ExportPath for further analysis" -ForegroundColor Cyan
    }
    
    return $analysisData
}

# Functions are now available for use in this script context
