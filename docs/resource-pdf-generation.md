# Resource PDF Generation

This feature generates PDF versions of resources in the NKDAgility.com website. PDFs are generated during the build process and made available for download on resource pages.

## How It Works

1. During the build process, a PowerShell script (`Generate-ResourcePDFs.ps1`) is executed
2. The script processes all resources in the `site/content/resources` directory
3. For each resource, a PDF is generated using `wkhtmltopdf`
4. The generated PDFs are stored in a `pdf-output` directory
5. The PDFs are copied to the `public/pdfs` directory during the build
6. Resources have their front matter updated to include a `pdf` property with the PDF filename
7. A download button is displayed on resource pages when a PDF is available

## Files

- `.powershell/build/Create-ResourcePDFs.ps1` - Main script for PDF generation
- `.powershell/Generate-ResourcePDFs.ps1` - Entry point script for the build process
- `site/layouts/partials/pdf-download.html` - Partial template for PDF download button
- `.github/workflows/main.yaml` - Updated to include PDF generation in the build process

## PDF Styling

The PDFs are styled using a custom CSS file that is created during the build process. The styling matches the website's design.

## Future Enhancements

- Upload PDFs to Azure Blob Storage (commented out in the code)
- Add custom PDF templates for different resource types
- Add PDF metadata (author, keywords, etc.)
- Add table of contents for longer resources