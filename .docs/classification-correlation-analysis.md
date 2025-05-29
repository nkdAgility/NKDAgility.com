# Classification Correlation Analysis System

This document describes the classification correlation analysis system used to optimize AI classification costs by analyzing the relationship between cheap Similarity scores and expensive AI final_scores.

## Overview

The classification correlation analysis helps determine if Similarity scores can be used as a cost-effective pre-filter before making expensive AI classification calls. By analyzing the correlation between these two metrics, we can identify optimal thresholds for cost optimization while maintaining classification quality.

## Directory Structure

The analysis system uses the following organized directory structure:

```
.data/classification-correlation/
├── analysis/
│   ├── csv/                    # CSV output files for Excel analysis
│   └── visualizations/         # Future: visualization outputs (charts, graphs)
└── scripts/                    # Future: additional analysis scripts
```

## Scripts

### Primary Analysis Script

**Location:** `.powershell/single-use/resources/Analyze-ClassificationCorrelation.ps1`

This is the main correlation analysis script that provides comprehensive analysis including:

- Pearson correlation coefficient calculation
- Threshold impact analysis showing cost savings vs quality loss
- Text-based scatter plot visualization with quality color coding
- Distribution analysis with histogram visualizations
- Quality zone breakdowns (high/medium/low quality classifications)
- Prediction accuracy testing with precision/recall metrics
- Type-specific correlation analysis (concepts, categories, tags)
- Intelligent threshold optimization with cost-benefit analysis
- CSV export for advanced Excel analysis
- Automated optimization recommendations

### Supporting Scripts

**Location:** `.powershell/single-use/resources/Get-RelatedForResource.ps1`

Contains the enhanced `Get-MatchingClassificationsForResource` function that:
- Groups classification results by type (concepts, categories, tags)
- Includes classification type information in output
- Applies TopN limits per classification type group
- Extracts both Similarity and EntryType from related items cache

## Usage

### Basic Analysis

```powershell
# Analyze a specific resource
Invoke-ClassificationCorrelationAnalysis -MarkdownPath "path/to/resource.md"
```

### Detailed Analysis with Visualizations

```powershell
# Run comprehensive analysis with all visualizations
Invoke-ClassificationCorrelationAnalysis -MarkdownPath "path/to/resource.md" -DetailedVisualization
```

### Export Data for Excel Analysis

```powershell
# Export analysis data to CSV (auto-generated path in organized structure)
Invoke-ClassificationCorrelationAnalysis -MarkdownPath "path/to/resource.md" -ExportPath ".data/classification-correlation/analysis/csv/my_analysis.csv"
```

## Analysis Components

### 1. Correlation Analysis
- Calculates Pearson correlation coefficient between Similarity and final_score
- Determines correlation strength (Strong: >0.7, Moderate: 0.5-0.7, Weak: 0.3-0.5, Very Weak: <0.3)
- Provides basic statistics for both metrics

### 2. Threshold Analysis
- Tests different similarity thresholds (0.0 to 0.9)
- Shows potential cost savings at each threshold
- Identifies high-value items that would be missed
- Quantifies low-value items that would be saved

### 3. Visualization Components

#### Scatter Plot (Text-Based)
- Visual representation of Similarity vs final_score relationship
- Color-coded by quality level (Green: ≥80, Yellow: 50-79, Red: <50)
- Symbol density indicates data point concentration

#### Distribution Analysis
- Histogram of Similarity score distribution
- Histogram of final_score distribution
- Helps identify data patterns and outliers

#### Quality Zone Analysis
- Breaks data into High (≥80), Medium (50-79), and Low (<50) quality zones
- Shows similarity patterns within each quality zone
- Provides percentile analysis for threshold selection

### 4. Prediction Accuracy Testing
- Tests how well similarity thresholds predict high-quality classifications
- Calculates precision, recall, and accuracy metrics
- Provides confusion matrix analysis for different thresholds

### 5. Type-Specific Analysis
- Analyzes correlation patterns for different classification types
- Provides type-specific recommendations
- Identifies which types benefit most from similarity pre-filtering

### 6. Optimization Recommendations
- Provides actionable recommendations based on correlation strength
- Suggests optimal thresholds for cost optimization
- Estimates potential cost savings and quality impact

## Output Files

### CSV Exports
All CSV files are automatically saved to `.data/classification-correlation/analysis/csv/` with naming pattern:
- `{resource-name}_correlation_analysis.csv` - Individual resource analysis
- `correlation_analysis_results.csv` - Aggregated results

### CSV Structure
Each CSV contains the following columns:
- `Title` - Classification name
- `Type` - Classification type (concepts/categories/tags)
- `Similarity` - Similarity score (0.0-1.0)
- `final_score` - AI final score (0-100)
- `HasSimilarityData` - Boolean indicating if similarity data exists
- `SimilarityBucket` - Rounded similarity for grouping analysis
- `ScoreBucket` - Rounded score for distribution analysis

## Key Findings Example

Based on analysis of the "why-topic-branches-drive-high-quality-delivery" resource:

### Overall Correlation: 0.4350 (Weak)
- **Total Classifications:** 103
- **With Similarity Data:** 61
- **Recommendation:** Use conservative thresholds or avoid pre-filtering

### Type-Specific Correlations:
- **Categories:** 0.787 (STRONG) - Excellent for pre-filtering
- **Tags:** 0.540 (MODERATE) - Use with caution  
- **Concepts:** -0.103 (NEGATIVE) - Avoid pre-filtering

### Cost Optimization Potential:
- Using 0.5 similarity threshold: 10.7% cost savings
- High-value items missed: Minimal (2 items)
- Recommended strategy: Type-specific thresholds

## Implementation Recommendations

### Production Deployment Strategy

1. **Categories:** Use Similarity ≥ 0.6 as pre-filter (strong correlation)
2. **Tags:** Use Similarity ≥ 0.4 with monitoring (moderate correlation)
3. **Concepts:** Process all items (negative correlation - similarity not predictive)

### Monitoring Requirements

- Track false negative rates by classification type
- Monitor cost savings vs quality metrics
- Regular correlation re-analysis as data evolves
- A/B testing of threshold adjustments

### Future Enhancements

1. **Advanced Visualizations:** Generate actual chart files for better analysis
2. **Automated Monitoring:** Scheduled correlation analysis with alerting
3. **Machine Learning:** Use correlation insights to improve similarity algorithms
4. **Multi-Resource Analysis:** Aggregate correlation patterns across all resources

## Dependencies

- `.powershell/_includes/LoggingHelper.ps1` - Logging utilities
- `.powershell/_includes/HugoHelpers.ps1` - Hugo content processing
- Related cache files: `data.index.related.json` and `data.index.classifications.json`

## Cache File Requirements

The analysis requires two cache files in each resource directory:

### data.index.related.json
Contains similarity scores and classification types:
```json
{
  "related": [
    {
      "Title": "Classification Name",
      "EntryKind": "classification",
      "EntryType": "concepts|categories|tags",
      "Similarity": 0.75
    }
  ]
}
```

### data.index.classifications.json
Contains AI final scores:
```json
{
  "Classification Name": {
    "final_score": 85.5,
    "level": "Confirmed|Suggested|Ignored"
  }
}
```

## Best Practices

1. **Regular Analysis:** Run correlation analysis monthly to track changes
2. **Type-Specific Thresholds:** Use different similarity thresholds for different classification types
3. **Quality Monitoring:** Track classification quality metrics alongside cost savings
4. **Data Validation:** Ensure both similarity and final_score data are available
5. **Threshold Testing:** Test threshold changes on small subsets before full deployment

## Troubleshooting

### Common Issues

1. **No Similarity Data:** Ensure related cache files contain classification entries with similarity scores
2. **Empty Analysis:** Check that classifications cache contains non-ignored items above minimum score
3. **Correlation Issues:** Verify data quality and ensure sufficient sample size (minimum 10 items recommended)

### Error Messages

- "No classification data found for analysis" - Check cache file paths and content
- "No similarity data available" - Verify related cache contains similarity scores
- "Too few samples for analysis" - Increase data set or lower minimum thresholds
