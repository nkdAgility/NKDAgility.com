# Test-ResourcePDFs.ps1
# Test script to generate PDF versions of a few resources

# Import modules
. "$PSScriptRoot/_includes/LoggingHelper.ps1"
. "$PSScriptRoot/build/Create-ResourcePDFs.ps1"

# Set paths for testing
$resourcesPath = "$PSScriptRoot/../site/content/resources"
$testOutputPath = "$PSScriptRoot/../test-pdf-output"

# Create the output directory if it doesn't exist
if (-not (Test-Path -Path $testOutputPath)) {
    New-Item -Path $testOutputPath -ItemType Directory -Force | Out-Null
    Write-InfoLog "Created test output directory at $testOutputPath"
}

# Get a sample of resources for testing
$testResourceTypes = @("blog", "engineering-notes", "videos")
$hugoMarkdownObjects = @()

foreach ($type in $testResourceTypes) {
    $typePath = Join-Path -Path $resourcesPath -ChildPath $type
    if (Test-Path -Path $typePath) {
        $resources = Get-ChildItem -Path "$typePath" -Recurse -Include "index.md" | Select-Object -First 2
        foreach ($resource in $resources) {
            try {
                $hugoMarkdown = Get-HugoMarkdown -Path $resource.FullName
                $hugoMarkdownObjects += $hugoMarkdown
            }
            catch {
                Write-ErrorLog "Error loading resource at $($resource.FullName): $_"
            }
        }
    }
}

Write-InfoLog "Testing PDF generation for $($hugoMarkdownObjects.Count) resources"

# Process each sample resource
$processedCount = 0
foreach ($resource in $hugoMarkdownObjects) {
    # Extract metadata from frontmatter
    $title = $resource.FrontMatter.title
    $resourceType = if ($resource.FrontMatter.resourceType) { $resource.FrontMatter.resourceType } else { "Resource" }
    $date = if ($resource.FrontMatter.date) { (Get-Date -Date $resource.FrontMatter.date -Format "yyyy-MM-dd") } else { (Get-Date -Format "yyyy-MM-dd") }
    
    # Generate a simple slug for the filename
    $slug = $title -replace '[:\\/\\\\*?"<>| #%.!,]', '-' -replace '\s+', '-'
    
    # Generate PDF filename
    $pdfFilename = "$resourceType.$date.$slug.pdf" -replace " ", "-" -replace ":", "-"
    $pdfPath = Join-Path -Path $testOutputPath -ChildPath $pdfFilename
    
    Write-InfoLog "Processing $title"
    
    try {
        # Generate HTML content from template
        $cssContent = Get-Content -Path $cssPath -Raw
        $htmlTemplate = Get-Content -Path $htmlTemplatePath -Raw
        
        $htmlContent = $htmlTemplate -replace "{{TITLE}}", $title `
                                     -replace "{{DATE}}", $date `
                                     -replace "{{RESOURCE_TYPE}}", $resourceType `
                                     -replace "{{CSS_CONTENT}}", $cssContent `
                                     -replace "{{CURRENT_YEAR}}", (Get-Date).Year `
                                     -replace "{{URL}}", "https://nkdagility.com$($resource.FrontMatter.url)" `
                                     -replace "{{CONTENT}}", $resource.BodyContent
                                     
        # Handle optional abstract
        $abstract = $resource.FrontMatter.abstract
        if ($abstract) {
            $htmlContent = $htmlContent -replace "{{#if ABSTRACT}}", "" `
                                        -replace "{{/if}}", "" `
                                        -replace "{{ABSTRACT}}", $abstract
        }
        else {
            $htmlContent = $htmlContent -replace "{{#if ABSTRACT}}.*?{{/if}}", "" -replace "`r`n", ""
        }
        
        # Convert HTML to PDF
        $success = ConvertTo-PDF -htmlContent $htmlContent -outputPath $pdfPath -title $title
        
        if ($success) {
            $processedCount++
            Write-InfoLog "Successfully generated PDF: $pdfFilename"
        }
        else {
            Write-ErrorLog "Failed to generate PDF for $title"
        }
    }
    catch {
        Write-ErrorLog "Error processing $title: $_"
    }
}

Write-InfoLog "Test completed. Successfully generated $processedCount PDFs in $testOutputPath"