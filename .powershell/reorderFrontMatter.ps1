# Load the required module to handle YAML
Import-Module powershell-yaml

# Define the custom order for front matter keys
$desiredOrder = @(
    "title",
    "date",
    "id",
    "type",
    "layout",
    "slug",
    "url",
    "aliases",
    "tags",
    "categories",
    "card", "headline", "sections"
)

# Function to reorder front matter keys based on the desired order
function Reorder-FrontMatter {
    param (
        [string]$filePath,
        [array]$order
    )

    # Read the file content
    $content = Get-Content $filePath -Raw

    # Extract the front matter (between '---')
    if ($content -match "(?s)^---(.*?)---") {
        $frontMatter = $matches[1]
        $markdownBody = $content -replace "(?s)^---(.*?)---", ""

        # Convert the front matter to a hashtable
        $frontMatterData = ConvertFrom-Yaml -Yaml $frontMatter

        # Create new ordered front matter
        $newFrontMatter = [ordered]@{}

        # Reorder the keys according to $desiredOrder
        foreach ($key in $order) {
            if ($frontMatterData.ContainsKey($key)) {
                $newFrontMatter[$key] = $frontMatterData[$key]
            }
        }

        # Add any remaining keys that were not in $desiredOrder
        foreach ($key in $frontMatterData.Keys) {
            if (-not $newFrontMatter.ContainsKey($key)) {
                $newFrontMatter[$key] = $frontMatterData[$key]
            }
        }

        # Convert the updated front matter back to YAML
        $updatedFrontMatter = ConvertTo-Yaml -Data $newFrontMatter

        # Rebuild the Markdown file with the updated front matter and the original content
        $updatedMarkdownContent = "---`n$updatedFrontMatter`n---`n$markdownBody"

        # Write the updated Markdown content back to the file
        Set-Content -Path $filePath -Value $updatedMarkdownContent

        Write-Host "Updated front matter for $filePath"
    }
    else {
        Write-Host "No front matter found in $filePath"
    }
}

# Define the path where the files are located
$rootPath = "C:\Users\MartinHinshelwoodNKD\source\repos\NKDAgility.com\site\content"

# Recursively process all files
Get-ChildItem -Path $rootPath -Recurse -Include "*.md" | ForEach-Object {
    Reorder-FrontMatter -filePath $_.FullName -order $desiredOrder
}
