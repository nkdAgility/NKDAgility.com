# Create-ResourcePDFs.ps1
# Script to generate PDF versions of resource content

# Import required modules
. "$PSScriptRoot/../_includes/LoggingHelper.ps1"
. "$PSScriptRoot/../_includes/HugoHelpers.ps1"
. "$PSScriptRoot/../_includes/AzureBlobHelpers.ps1"

# Set paths
$resourcesPath = "$PSScriptRoot/../../site/content/resources"
$outputPath = "$PSScriptRoot/../../pdf-output"
$hugoPath = "$PSScriptRoot/../../site"
$templatePath = "$PSScriptRoot/../../.powershell/templates"
$blobContainerName = "resource-pdfs"

# Create the output directory if it doesn't exist
if (-not (Test-Path -Path $outputPath)) {
    New-Item -Path $outputPath -ItemType Directory -Force | Out-Null
    Write-InfoLog "Created output directory at $outputPath"
}

# Create a CSS template for PDF styling if it doesn't exist
$cssPath = "$templatePath/pdf-styles.css"
if (-not (Test-Path -Path $templatePath)) {
    New-Item -Path $templatePath -ItemType Directory -Force | Out-Null
}
if (-not (Test-Path -Path $cssPath)) {
    @"
body {
    font-family: Arial, sans-serif;
    line-height: 1.6;
    margin: 0;
    padding: 20px;
    color: #333;
}
h1, h2, h3, h4, h5, h6 {
    margin-top: 24px;
    margin-bottom: 16px;
    font-weight: 600;
    line-height: 1.25;
}
h1 {
    font-size: 2em;
    border-bottom: 1px solid #eaecef;
    padding-bottom: 0.3em;
}
h2 {
    font-size: 1.5em;
    border-bottom: 1px solid #eaecef;
    padding-bottom: 0.3em;
}
img {
    max-width: 100%;
    height: auto;
}
pre {
    background-color: #f6f8fa;
    border-radius: 3px;
    padding: 16px;
    overflow: auto;
    font-family: monospace;
}
code {
    font-family: monospace;
    background-color: #f6f8fa;
    padding: 2px 4px;
    border-radius: 3px;
}
a {
    color: #0366d6;
    text-decoration: none;
}
table {
    border-collapse: collapse;
    width: 100%;
    margin-bottom: 16px;
}
table, th, td {
    border: 1px solid #dfe2e5;
}
th, td {
    padding: 8px 16px;
    text-align: left;
}
tr:nth-child(even) {
    background-color: #f6f8fa;
}
blockquote {
    margin: 0;
    padding: 0 16px;
    color: #6a737d;
    border-left: 4px solid #dfe2e5;
}
footer {
    margin-top: 32px;
    border-top: 1px solid #eaecef;
    padding-top: 16px;
    font-size: 0.8em;
    color: #6a737d;
}
"@ | Set-Content -Path $cssPath -Encoding UTF8
    Write-InfoLog "Created CSS template at $cssPath"
}

# Create HTML template for PDF rendering
$htmlTemplatePath = "$templatePath/pdf-template.html"
if (-not (Test-Path -Path $htmlTemplatePath)) {
    @"
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{{TITLE}}</title>
    <style>
        {{CSS_CONTENT}}
    </style>
</head>
<body>
    <header>
        <h1>{{TITLE}}</h1>
        <p class="metadata">{{DATE}} | {{RESOURCE_TYPE}}</p>
        {{#if ABSTRACT}}
        <blockquote>
            <p>{{ABSTRACT}}</p>
        </blockquote>
        {{/if}}
    </header>
    <main>
        {{CONTENT}}
    </main>
    <footer>
        <p>&copy; {{CURRENT_YEAR}} NKD Agility Ltd. All rights reserved.</p>
        <p>Retrieved from: {{URL}}</p>
    </footer>
</body>
</html>
"@ | Set-Content -Path $htmlTemplatePath -Encoding UTF8
    Write-InfoLog "Created HTML template at $htmlTemplatePath"
}

# Function to convert markdown to HTML using Hugo's built-in markdown processor
function ConvertTo-HugoHTML {
    param (
        [Parameter(Mandatory = $true)]
        [HugoMarkdown]$hugoMarkdown
    )

    $tempMarkdownPath = "$env:TEMP/temp_content_$(Get-Random).md"
    
    # Create a temporary markdown file with front matter and content
    "---`n$(ConvertTo-Yaml $hugoMarkdown.FrontMatter)`n---`n$($hugoMarkdown.BodyContent)" | 
        Set-Content -Path $tempMarkdownPath -Encoding UTF8

    # Use Hugo to convert the markdown to HTML
    $hugoCmdOutput = & hugo --source $hugoPath convert $tempMarkdownPath 2>&1

    # Extract the HTML content from Hugo's output
    $html = $hugoCmdOutput | Out-String

    # Clean up
    Remove-Item -Path $tempMarkdownPath -Force

    return $html
}

# Function to generate PDF from HTML
function ConvertTo-PDF {
    param (
        [Parameter(Mandatory = $true)]
        [string]$htmlContent,
        [Parameter(Mandatory = $true)]
        [string]$outputPath,
        [Parameter(Mandatory = $true)]
        [string]$title
    )

    $tempHtmlPath = "$env:TEMP/temp_html_$(Get-Random).html"
    $htmlContent | Set-Content -Path $tempHtmlPath -Encoding UTF8

    # Use wkhtmltopdf to convert HTML to PDF
    $wkhtmltopdfArgs = @(
        "--enable-local-file-access",
        "--encoding utf-8",
        "--title `"$title`"",
        "--footer-right `"Page [page]/[topage]`"",
        "--footer-font-size 8",
        "--margin-top 20",
        "--margin-bottom 20",
        "--margin-left 20",
        "--margin-right 20",
        $tempHtmlPath,
        $outputPath
    )

    # Execute wkhtmltopdf
    $process = Start-Process -FilePath "wkhtmltopdf" -ArgumentList $wkhtmltopdfArgs -NoNewWindow -PassThru -Wait

    # Clean up
    Remove-Item -Path $tempHtmlPath -Force

    return $process.ExitCode -eq 0
}

# Process resource files and generate PDFs
function Process-ResourceFiles {
    param (
        [Parameter(Mandatory = $true)]
        [string]$resourcesDir,
        [Parameter(Mandatory = $true)]
        [string]$outputDir
    )

    # Get the CSS content
    $cssContent = Get-Content -Path $cssPath -Raw

    # Get the HTML template
    $htmlTemplate = Get-Content -Path $htmlTemplatePath -Raw

    # Get all resources
    $hugoMarkdownObjects = Get-RecentHugoMarkdownResources -Path $resourcesDir -YearsBack 10

    # Filter out resources without content
    $hugoMarkdownObjects = $hugoMarkdownObjects | Where-Object { 
        $_.BodyContent -and $_.BodyContent.Trim().Length -gt 0 
    }

    $processedCount = 0
    $totalCount = $hugoMarkdownObjects.Count

    Write-InfoLog "Found $totalCount resources to process"

    foreach ($resource in $hugoMarkdownObjects) {
        $processedCount++
        $percentComplete = [math]::Round(($processedCount / $totalCount) * 100)

        # Extract metadata from frontmatter
        $title = $resource.FrontMatter.title
        $slug = $resource.FrontMatter.slug
        $resourceType = if ($resource.FrontMatter.resourceType) { $resource.FrontMatter.resourceType } else { "Resource" }
        $date = if ($resource.FrontMatter.date) { (Get-Date -Date $resource.FrontMatter.date -Format "MMMM d, yyyy") } else { (Get-Date -Format "MMMM d, yyyy") }
        $abstract = $resource.FrontMatter.abstract
        
        # Create slug if not present
        if (-not $slug) {
            $slug = $title -replace '[:\\/\\\\*?"<>| #%.!,]', '-' -replace '\s+', '-'
        }

        # Generate PDF filename
        $pdfFilename = "$resourceType.$date.$slug.pdf" -replace " ", "-" -replace ":", "-"
        $pdfPath = Join-Path -Path $outputDir -ChildPath $pdfFilename

        Write-InfoLog "Processing [$processedCount/$totalCount] - $title"

        try {
            # Generate HTML content from template
            $htmlContent = $htmlTemplate -replace "{{TITLE}}", $title `
                                        -replace "{{DATE}}", $date `
                                        -replace "{{RESOURCE_TYPE}}", $resourceType `
                                        -replace "{{CSS_CONTENT}}", $cssContent `
                                        -replace "{{CURRENT_YEAR}}", (Get-Date).Year `
                                        -replace "{{URL}}", "https://nkdagility.com$($resource.FrontMatter.url)" `
                                        -replace "{{CONTENT}}", $resource.BodyContent

            # Handle optional abstract
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
                # Update the front matter to include the PDF path if successful
                if (-not $resource.FrontMatter.pdf) {
                    $resource.FrontMatter.pdf = $pdfFilename
                    Save-HugoMarkdown -hugoMarkdown $resource -Path $resource.FilePath
                    Write-InfoLog "Updated front matter with PDF path: $pdfFilename"
                }
                else {
                    Write-InfoLog "PDF path already exists in front matter: $($resource.FrontMatter.pdf)"
                }
            }
            else {
                Write-ErrorLog "Failed to generate PDF for $title"
            }
        }
        catch {
            Write-ErrorLog "Error processing $title: $_"
        }
    }

    Write-InfoLog "Processed $processedCount resources"
    return $processedCount
}

# Main execution
try {
    $startTime = Get-Date
    Write-InfoLog "Starting PDF generation for resources"

    # Process resources
    $processedCount = Process-ResourceFiles -resourcesDir $resourcesPath -outputDir $outputPath

    $endTime = Get-Date
    $duration = $endTime - $startTime
    Write-InfoLog "PDF generation completed. Processed $processedCount resources in $($duration.TotalMinutes.ToString('0.00')) minutes"
    
    # TODO: Upload PDFs to Azure Blob Storage when needed
    # If we have Azure Blob Storage credentials, upload the PDFs
    # $storageContext = New-AzStorageContext -ConnectionString $env:AZURE_STORAGE_CONNECTION_STRING
    # Get-ChildItem -Path $outputPath -Filter "*.pdf" | ForEach-Object {
    #     Set-AzStorageBlobContent -Container $blobContainerName -File $_.FullName -Blob $_.Name -Context $storageContext -Force
    # }
}
catch {
    Write-ErrorLog "Error in PDF generation: $_"
    exit 1
}