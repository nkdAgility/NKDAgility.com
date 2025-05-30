# Classification Correlation Analysis

This directory contains analysis outputs from the correlation study between cheap Similarity scores and expensive AI final_scores for classification optimization.

## Directory Structure

```
classification-correlation/
├── README.md                   # This file
├── analysis/                   # Analysis outputs
│   ├── csv/                   # CSV data exports for Excel analysis
│   └── visualizations/       # Future: charts, graphs, plots
└── scripts/                   # Future: dedicated analysis scripts (if needed)
```

## Files in analysis/csv/

- `*_correlation_analysis.csv` - Individual resource correlation analysis data
- `correlation_analysis_results.csv` - Combined analysis results

## Analysis Scripts

The main analysis script remains in the `.powershell` directory:

- `.powershell/single-use/resources/Analyze-ClassificationCorrelation.ps1`

## Usage

Run correlation analysis on a resource:

```powershell
# Load the analysis script
. "c:\Users\MartinHinshelwoodNKD\source\repos\NKDAgility.com\.powershell\single-use\resources\Analyze-ClassificationCorrelation.ps1"

# Analyze a specific resource (CSV will be auto-exported to organized directory)
Invoke-ClassificationCorrelationAnalysis -MarkdownPath "path\to\resource\index.md" -DetailedVisualization

# Or specify custom export path
Invoke-ClassificationCorrelationAnalysis -MarkdownPath "path\to\resource\index.md" -ExportPath "custom\path\analysis.csv"
```

## Key Findings

Based on analysis of multiple resources:

### Overall Correlation: Weak to Moderate (0.4350)

- **Categories**: Strong correlation (0.787) - Good for pre-filtering
- **Tags**: Moderate correlation (0.540) - Use with caution
- **Concepts**: Negative correlation (-0.103) - Avoid pre-filtering

### Cost Optimization Recommendations

1. **Use Similarity pre-filtering for Categories only**
2. **Threshold of 0.5 provides 10.7% cost savings**
3. **Monitor false negative rates carefully**
4. **Focus on improving Concepts similarity algorithm**

## Next Steps

1. Implement production pipeline with type-specific filtering
2. A/B test cost savings vs quality impact
3. Improve similarity algorithms for Concepts
4. Expand analysis to more resources
