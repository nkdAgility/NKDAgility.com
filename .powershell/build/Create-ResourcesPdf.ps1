# Create-ResourcesPdf.ps1
# This script generates PDFs from Hugo Markdown resources with a professional cover page

param(
    [Parameter()]
    [string]$ResourcesPath = ".\site\content\resources",
    [Parameter()]
    [switch]$ForceRegenerate,
    [Parameter()]
    [string]$SingleResourceId
)

# Import required modules
. ./.powershell/_includes/LoggingHelper.ps1
. ./.powershell/_includes/HugoHelpers.ps1
. ./.powershell/_includes/AzureBlobHelpers.ps1

# Constants
$PDF_CACHE_BLOB_NAME = "pdf-generation-cache.json"
$PDF_CACHE_CONTAINER = "$web"
$COVER_IMAGE_PATH = ".\site\static\images\resources-pdf-cover-image.png"
$BASE_URL = "https://nkdagility.com/resources/"

# Initialize variables
$levelSwitch.MinimumLevel = 'Info'

# Function to check if Pandoc is installed and install if needed
function Initialize-Pandoc {
    Write-InfoLog "Checking Pandoc installation..."
    
    try {
        $pandocVersion = pandoc --version
        Write-InfoLog "Pandoc is installed: $($pandocVersion[0])"
        return $true
    }
    catch {
        Write-InfoLog "Pandoc is not installed. Installing..."
        
        # Install Pandoc depending on the OS
        if ($IsWindows -or $env:OS -match "Windows") {
            try {
                # Try winget first (Windows 10/11)
                winget install --id JohnMacFarlane.Pandoc --silent
            }
            catch {
                # Fallback to chocolatey
                try {
                    if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
                        Write-WarningLog "Chocolatey is not installed. Please install Pandoc manually."
                        return $false
                    }
                    choco install pandoc -y
                }
                catch {
                    Write-ErrorLog "Failed to install Pandoc: $_"
                    return $false
                }
            }
        }
        elseif ($IsMacOS) {
            try {
                brew install pandoc
            }
            catch {
                Write-ErrorLog "Failed to install Pandoc: $_"
                return $false
            }
        }
        elseif ($IsLinux) {
            try {
                sudo apt-get update
                sudo apt-get install -y pandoc texlive texlive-latex-extra
            }
            catch {
                Write-ErrorLog "Failed to install Pandoc: $_"
                return $false
            }
        }
        
        # Verify installation
        try {
            $pandocVersion = pandoc --version
            Write-InfoLog "Pandoc installed successfully: $($pandocVersion[0])"
            return $true
        }
        catch {
            Write-ErrorLog "Pandoc installation verification failed: $_"
            return $false
        }
    }
}

# Function to create a LaTeX template for the PDF with the cover page
function Get-CoverPageTemplate {
    param (
        [string]$Title,
        [string]$ResourceId
    )
    
    # Create the permalink
    $permalink = "${BASE_URL}${ResourceId}"
    
    # Get the path to the cover image
    $coverImagePath = Resolve-Path $COVER_IMAGE_PATH
    
    # LaTeX template with cover page
    $template = @"
\documentclass{article}
\usepackage[utf8]{inputenc}
\usepackage{graphicx}
\usepackage{wallpaper}
\usepackage{geometry}
\usepackage{hyperref}
\usepackage{fancyhdr}
\usepackage{xcolor}
\usepackage{titlesec}

\geometry{a4paper, margin=1in}
\pagestyle{fancy}
\fancyhf{}
\renewcommand{\headrulewidth}{0pt}
\renewcommand{\footrulewidth}{0pt}
\fancyfoot[R]{\thepage}

\hypersetup{
    colorlinks=true,
    linkcolor=blue,
    filecolor=magenta,
    urlcolor=blue,
}

\begin{document}

% Cover page
\thispagestyle{empty}
\ThisULCornerWallPaper{1}{$coverImagePath}

\vspace*{\fill}
\vspace*{0.75\textheight}
\begin{flushright}
\fontsize{24}{30}\selectfont
\textbf{$Title}
\end{flushright}

\vspace{2cm}
\begin{flushright}
\fontsize{12}{14}\selectfont
\url{$permalink}
\end{flushright}
\vspace*{\fill}
\newpage

% Document content starts here
"@

    return $template
}

# Function to get or create PDF cache
function Get-PdfGenerationCache {
    try {
        # Try to get the cache file from Azure Blob Storage
        $cacheContent = Get-AzBlobContentAsString -BlobName $PDF_CACHE_BLOB_NAME -Container $PDF_CACHE_CONTAINER
        
        if ($cacheContent) {
            try {
                $cache = $cacheContent | ConvertFrom-Json -AsHashtable
                Write-InfoLog "PDF generation cache loaded from Azure Blob Storage"
                return $cache
            }
            catch {
                Write-WarningLog "Failed to parse cache JSON: $_"
                return @{}
            }
        }
        else {
            Write-InfoLog "No existing PDF generation cache found. Creating new one."
            return @{}
        }
    }
    catch {
        Write-WarningLog "Error accessing cache in Azure Blob Storage: $_"
        return @{}
    }
}

# Function to save PDF cache
function Save-PdfGenerationCache {
    param (
        [hashtable]$Cache
    )
    
    try {
        $cacheJson = $Cache | ConvertTo-Json -Depth 10
        Set-AzBlobContentFromString -BlobName $PDF_CACHE_BLOB_NAME -Container $PDF_CACHE_CONTAINER -Content $cacheJson
        Write-InfoLog "PDF generation cache saved to Azure Blob Storage"
        return $true
    }
    catch {
        Write-ErrorLog "Failed to save PDF generation cache to Azure Blob Storage: $_"
        return $false
    }
}

# Function to check if PDF regeneration is needed
function Test-ShouldRegeneratePdf {
    param (
        [HugoMarkdown]$HugoMarkdown,
        [hashtable]$Cache
    )
    
    # Force regeneration if specified
    if ($ForceRegenerate) {
        Write-InfoLog "Force regeneration flag is set"
        return $true
    }
    
    # Get resource ID
    $resourceId = $HugoMarkdown.FrontMatter.ResourceId
    if (-not $resourceId) {
        Write-WarningLog "Missing ResourceId in frontmatter"
        return $true
    }
    
    # Determine PDF filename
    $pdfFileName = Get-PdfFileName -HugoMarkdown $HugoMarkdown
    $pdfPath = Join-Path $HugoMarkdown.FolderPath $pdfFileName
    
    # Check if PDF exists
    if (-not (Test-Path $pdfPath)) {
        Write-InfoLog "PDF does not exist: $pdfFileName"
        return $true
    }
    
    # Check cache
    if (-not $Cache.ContainsKey($resourceId)) {
        Write-InfoLog "Resource not found in cache: $resourceId"
        return $true
    }
    
    # Check if frontmatter.date has changed
    $cacheItem = $Cache[$resourceId]
    if ($cacheItem.frontmatter_date -ne $HugoMarkdown.FrontMatter.date) {
        Write-InfoLog "Frontmatter date has changed: $($cacheItem.frontmatter_date) -> $($HugoMarkdown.FrontMatter.date)"
        return $true
    }
    
    Write-InfoLog "No changes detected, PDF regeneration not needed"
    return $false
}

# Function to get PDF filename according to the required format
function Get-PdfFileName {
    param (
        [HugoMarkdown]$HugoMarkdown
    )
    
    if (-not $env:GITHUB_ACTIONS) {
        $nkdAgility_Ring = 'local'
    }
    else {
        $nkdAgility_Ring = $env:nkdAgility_Ring
    }
    
    if ($nkdAgility_Ring -and $nkdAgility_Ring.ToLower() -ne 'production') {
        return "$($HugoMarkdown.FrontMatter.slug)-$($HugoMarkdown.FrontMatter.date)-$nkdAgility_Ring.pdf"
    }
    else {
        return "$($HugoMarkdown.FrontMatter.slug)-$($HugoMarkdown.FrontMatter.date).pdf"
    }
}

# Function to generate PDF from Hugo Markdown
function Convert-HugoMarkdownToPdf {
    param (
        [HugoMarkdown]$HugoMarkdown
    )
    
    $resourceId = $HugoMarkdown.FrontMatter.ResourceId
    if (-not $resourceId) {
        Write-ErrorLog "Resource ID is missing in frontmatter"
        return $false
    }
    
    $title = $HugoMarkdown.FrontMatter.title
    if (-not $title) {
        Write-ErrorLog "Title is missing in frontmatter"
        return $false
    }
    
    # Get PDF filename and path
    $pdfFileName = Get-PdfFileName -HugoMarkdown $HugoMarkdown
    $pdfPath = Join-Path $HugoMarkdown.FolderPath $pdfFileName
    
    # Create a temporary directory for processing
    $tempDir = Join-Path $env:TEMP ([guid]::NewGuid().ToString())
    New-Item -ItemType Directory -Path $tempDir -Force | Out-Null
    
    try {
        # Create temporary markdown file with the content
        $tempMdPath = Join-Path $tempDir "content.md"
        Set-Content -Path $tempMdPath -Value $HugoMarkdown.BodyContent -Encoding UTF8
        
        # Create LaTeX template file with cover page
        $templatePath = Join-Path $tempDir "template.tex"
        $template = Get-CoverPageTemplate -Title $title -ResourceId $resourceId
        Set-Content -Path $templatePath -Value $template -Encoding UTF8
        
        # Generate PDF using pandoc
        $pandocArgs = @(
            "-f", "markdown",
            "-t", "pdf",
            "--pdf-engine=xelatex",
            "--template=$templatePath",
            "-o", $pdfPath,
            $tempMdPath
        )
        
        Write-InfoLog "Generating PDF: $pdfFileName"
        $process = Start-Process -FilePath "pandoc" -ArgumentList $pandocArgs -NoNewWindow -Wait -PassThru
        
        if ($process.ExitCode -eq 0) {
            Write-InfoLog "PDF generated successfully: $pdfPath"
            return $true
        }
        else {
            Write-ErrorLog "PDF generation failed with exit code: $($process.ExitCode)"
            return $false
        }
    }
    catch {
        Write-ErrorLog "Error generating PDF: $_"
        return $false
    }
    finally {
        # Clean up temporary files
        if (Test-Path $tempDir) {
            Remove-Item -Path $tempDir -Recurse -Force
        }
    }
}

# Function to update the cache with successful PDF generation
function Update-PdfGenerationCache {
    param (
        [HugoMarkdown]$HugoMarkdown,
        [hashtable]$Cache
    )
    
    $resourceId = $HugoMarkdown.FrontMatter.ResourceId
    $pdfFileName = Get-PdfFileName -HugoMarkdown $HugoMarkdown
    
    $Cache[$resourceId] = @{
        slug = $HugoMarkdown.FrontMatter.slug
        frontmatter_date = $HugoMarkdown.FrontMatter.date
        pdf_file_name = $pdfFileName
        last_generated = (Get-Date).ToString("o")  # ISO 8601 timestamp
    }
    
    return $Cache
}

# Main execution function
function Start-PdfGeneration {
    # Check if the cover image exists
    if (-not (Test-Path $COVER_IMAGE_PATH)) {
        Write-ErrorLog "Cover image not found: $COVER_IMAGE_PATH"
        Write-Host "Please create a cover image at: $COVER_IMAGE_PATH" -ForegroundColor Yellow
        Write-Host "The image should be a professional background image for PDF covers." -ForegroundColor Yellow
        return
    }
    
    # Initialize Pandoc
    if (-not (Initialize-Pandoc)) {
        Write-ErrorLog "Failed to initialize Pandoc. Exiting."
        return
    }
    
    # Get or create the cache
    $cache = Get-PdfGenerationCache
    
    # Get the Hugo resources
    if ($SingleResourceId) {
        Write-InfoLog "Processing single resource: $SingleResourceId"
        $resources = Get-RecentHugoMarkdownResources -Path $ResourcesPath | Where-Object {
            $_.FrontMatter.ResourceId -eq $SingleResourceId
        }
        
        if ($resources.Count -eq 0) {
            Write-ErrorLog "Resource not found: $SingleResourceId"
            return
        }
    }
    else {
        Write-InfoLog "Processing all resources from: $ResourcesPath"
        $resources = Get-RecentHugoMarkdownResources -Path $ResourcesPath
    }
    
    $totalResources = $resources.Count
    $processedCount = 0
    $successCount = 0
    
    Write-InfoLog "Found $totalResources resources to process"
    
    # Process each resource
    $resources | ForEach-Object {
        $hugoMarkdown = $_
        $resourceId = $hugoMarkdown.FrontMatter.ResourceId
        $processedCount++
        
        Write-InfoLog "Processing ($processedCount/$totalResources): $resourceId - $($hugoMarkdown.FrontMatter.title)"
        
        if (Test-ShouldRegeneratePdf -HugoMarkdown $hugoMarkdown -Cache $cache) {
            $result = Convert-HugoMarkdownToPdf -HugoMarkdown $hugoMarkdown
            
            if ($result) {
                $cache = Update-PdfGenerationCache -HugoMarkdown $hugoMarkdown -Cache $cache
                $successCount++
            }
        }
        else {
            Write-InfoLog "Skipping generation for $resourceId (no changes)"
        }
    }
    
    # Save the updated cache
    Save-PdfGenerationCache -Cache $cache
    
    Write-InfoLog "PDF generation completed: $successCount/$totalResources PDFs generated/updated"
}

# Start the PDF generation process
Start-PdfGeneration