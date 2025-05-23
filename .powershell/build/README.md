# Build Scripts

This directory contains PowerShell scripts used for building and generating content for the NKDAgility website.

## Create-ResourcesPdf.ps1

This script generates PDF files from Hugo Markdown resources. PDFs include a professional cover page with a background image, title, and permalink.

### Prerequisites

- PowerShell 7+
- Pandoc (latest stable release) - will be installed automatically if not present
- LaTeX distribution (will be installed automatically with Pandoc)

### Usage

```powershell
# Generate PDFs for all resources
.\Create-ResourcesPdf.ps1 -ResourcesPath ".\site\content\resources"

# Force regeneration of all PDFs
.\Create-ResourcesPdf.ps1 -ForceRegenerate

# Generate PDF for a specific resource
.\Create-ResourcesPdf.ps1 -SingleResourceId "your-resource-id"
```

### Cover Image

The script requires a cover image at `.\site\static\images\resources-pdf-cover-image.png`. This image will be used as the background for the cover page of each PDF.

### PDF Generation Rules

PDFs are generated only under these conditions:
- No previous PDF exists
- The resource's content or metadata (`FrontMatter.date`) has changed since the last generation
- A manual override is explicitly specified for regeneration

### PDF Filename Format

The PDF filename follows this format:
- For non-production environments: `{slug}-{date}-{environment}.pdf`
- For production: `{slug}-{date}.pdf`

### Cache Management

The script maintains a JSON cache of generated PDFs in Azure Blob Storage:
- Cache location: `https://nkdagilityblobs.blob.core.windows.net/$web/pdf-generation-cache.json`
- The cache is downloaded at the start of the generation process, updated after each successful PDF creation, and re-uploaded upon completion

### UI Integration

PDFs are accessible on resource pages through a download button that appears when a PDF for that resource exists.