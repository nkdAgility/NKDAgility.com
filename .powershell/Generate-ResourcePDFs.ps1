# Generate-ResourcePDFs.ps1
# Script to generate PDF versions of resource content as a pre-build step

param (
    [Parameter(Mandatory = $false)]
    [string]$ResourcesPath = "$PSScriptRoot/../site/content/resources",
    
    [Parameter(Mandatory = $false)]
    [string]$OutputPath = "$PSScriptRoot/../pdf-output",
    
    [Parameter(Mandatory = $false)]
    [switch]$UploadToBlob
)

# Import modules
. "$PSScriptRoot/_includes/LoggingHelper.ps1"
. "$PSScriptRoot/build/Create-ResourcePDFs.ps1"

Write-InfoLog "Starting Generate-ResourcePDFs script"

# Process resources
try {
    $processedCount = Process-ResourceFiles -resourcesDir $ResourcesPath -outputDir $OutputPath
    Write-InfoLog "Generated $processedCount PDF files"
    
    # If UploadToBlob switch is set, upload the PDFs to Azure Blob Storage
    if ($UploadToBlob) {
        # TODO: Add Azure Blob Storage upload functionality
        Write-InfoLog "Uploading PDFs to Azure Blob Storage is not implemented yet"
    }
    
    Write-InfoLog "PDF generation completed successfully"
}
catch {
    Write-ErrorLog "Error generating PDFs: $_"
    exit 1
}