function Move-And-ConvertJekyllToHugo {
    param (
        [Parameter(Mandatory = $true)]
        [string]$sourceDir, # Source folder where Jekyll markdown files are located

        [Parameter(Mandatory = $true)]
        [string]$destinationDir  # Destination folder where the converted Hugo files should be placed
    )

    # Function to convert Jekyll front matter to Hugo format
    function Convert-FrontMatter {
        param ($frontMatterLines, $baseName)

        $hugoFrontMatter = @()
        $aliases = @()
        $title = ""

        foreach ($line in $frontMatterLines) {
            switch -regex ($line) {
                "^title:" {
                    # Capture title for later use in the card content
                    $title = $line -replace "^title:\s*", ""
                    $hugoFrontMatter += $line
                }
                "^layout:" {
                    # Skip layout (Jekyll-specific)
                    continue
                }
                "^pageType:" {
                    # Convert pageType to type in Hugo
                    $hugoFrontMatter += $line -replace "pageType:", "type:"
                }
                "^redirect_from:" {
                    # Convert redirect_from to aliases in Hugo
                    $aliases += $line -replace "redirect_from:", "aliases:"
                }
                "^- " {
                    # Append items under aliases or other lists
                    $aliases += $line
                }
                "^references:" {
                    # Retain references as is
                    $hugoFrontMatter += $line
                }
                "^recommendedVideos:" {
                    # Convert recommendedVideos to videos in Hugo
                    $hugoFrontMatter += $line -replace "recommendedVideos:", "videos:"
                }
                "^toc:|^pdf:|^pageStatus:" {
                    # Skip toc, pdf, and pageStatus
                    continue
                }
                default {
                    # Retain other lines
                    $hugoFrontMatter += $line
                }
            }
        }

        # Add additional fields for Hugo
        $hugoFrontMatter += "date: $(Get-Date -Format yyyy-MM-dd)"
        $hugoFrontMatter += "creator: Martin Hinshelwood"

        # Add the card section with dynamic title and content
        $hugoFrontMatter += "card:"
        $hugoFrontMatter += "  button:"
        $hugoFrontMatter += "    content: Learn More"
        $hugoFrontMatter += "  content: Discover more about $title and how it can help you in your Agile journey!"
        $hugoFrontMatter += "  title: $title"

        # Combine aliases into the front matter
        $hugoFrontMatter = $hugoFrontMatter + $aliases
        return $hugoFrontMatter
    }

    # Get all markdown files in the source directory
    $markdownFiles = Get-ChildItem -Path $sourceDir -Filter "*.md"

    # Loop through each markdown file
    foreach ($file in $markdownFiles) {
        # Extract the base name without extension (e.g., "nexus-framework")
        $baseName = [System.IO.Path]::GetFileNameWithoutExtension($file.Name)

        # Create the target folder based on the base name
        $targetFolder = Join-Path $destinationDir $baseName
        if (-not (Test-Path $targetFolder)) {
            New-Item -Path $targetFolder -ItemType Directory
        }

        # Define the target file path for index.md
        $targetFile = Join-Path $targetFolder "index.md"

        # Read the contents of the source file
        $content = Get-Content -Path $file.FullName

        # Separate front matter and body content
        $inFrontMatter = $false
        $frontMatterLines = @()
        $bodyContent = @()

        foreach ($line in $content) {
            if ($line -eq "---") {
                $inFrontMatter = -not $inFrontMatter
                continue
            }

            if ($inFrontMatter) {
                # Collect front matter lines
                $frontMatterLines += $line
            }
            else {
                # Collect body content
                $bodyContent += $line
            }
        }

        # Convert the front matter with the slug and card content customized per page
        $hugoFrontMatter = Convert-FrontMatter -frontMatterLines $frontMatterLines -baseName $baseName

        # Prepare the final content for the Hugo index.md
        $finalContent = @("---")
        $finalContent += $hugoFrontMatter
        $finalContent += "---"
        $finalContent += $bodyContent

        # Write the new content to the target index.md file
        Set-Content -Path $targetFile -Value ($finalContent -join "`n")

        Write-Host "Moved and converted: $($file.Name) to $targetFile"
    }
}





# Example usage of the function
#Move-And-ConvertJekyllToHugo -sourceDir "C:\Users\MartinHinshelwoodNKD\source\repos\Agile-Delivery-Kit-for-Software-Organisations\src\collections\_guides" -destinationDir "C:\Users\MartinHinshelwoodNKD\source\repos\NKDAgility.com\site\content\resources\guides"

#Move-And-ConvertJekyllToHugo -sourceDir "C:\Users\MartinHinshelwoodNKD\source\repos\Agile-Delivery-Kit-for-Software-Organisations\src\collections\_workshops" -destinationDir "C:\Users\MartinHinshelwoodNKD\source\repos\NKDAgility.com\site\content\resources\workshops"


# Define the parent directory containing all the subfolders
$parentSourceDir = "C:\Users\MartinHinshelwoodNKD\source\repos\Agile-Delivery-Kit-for-Software-Organisations\src\collections"
$parentDestinationDir = "C:\Users\MartinHinshelwoodNKD\source\repos\NKDAgility.com\site\content\resources\_incomming"

# Get all subdirectories in the parent directory
$subfolders = Get-ChildItem -Path $parentSourceDir -Directory

# Loop through each subfolder and call Move-And-ConvertJekyllToHugo
foreach ($folder in $subfolders) {
    $sourceDir = $folder.FullName
    $folderName = $folder.Name

    # Set the destination folder based on the folder name
    $destinationDir = Join-Path $parentDestinationDir $folderName

    # Run the Move-And-ConvertJekyllToHugo function for this subfolder
    Move-And-ConvertJekyllToHugo -sourceDir $sourceDir -destinationDir $destinationDir

    Write-Host "Processed folder: $folderName"
}
