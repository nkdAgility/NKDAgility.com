# Define the custom order for front matter keys
$desiredOrder = @(
    "title",
    "date",
    "id",
    "type",
    "slug",
    "url",
    "aliases",
    "tags",
    "categories",
    "card"
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
    if ($content -match "(?s)^---\n(.*?)\n---\n(.*)$") {
        $frontMatter = $matches[1]
        $remainingContent = $matches[2]

        # Convert the front matter to a hashtable
        $frontMatterHash = ConvertFrom-Yaml -Yaml $frontMatter

        # Split the front matter into keys and reorder them
        $orderedKeys = @()
        $unorderedKeys = @()

        foreach ($key in $frontMatterHash.PSObject.Properties.Name) {
            if ($order -contains $key) {
                $orderedKeys += $key
            }
            else {
                $unorderedKeys += $key
            }
        }

        # Sort unordered keys alphabetically
        $unorderedKeys = $unorderedKeys | Sort-Object

        # Merge the keys with the desired order first, then alphabetically
        $finalOrder = $orderedKeys + $unorderedKeys

        # Rebuild the front matter in the correct order
        $newFrontMatter = @()
        foreach ($key in $finalOrder) {
            $value = $frontMatterHash.$key
            $newFrontMatter += "${$key}: $value"
        }

        # Rebuild the full file with the reordered front matter
        $newContent = @("---", ($newFrontMatter -join "`n"), "---", $remainingContent) -join "`n"

        # Write the updated content back to the file
        Set-Content $filePath $newContent
    }
    else {
        Write-Host "No front matter found in $filePath"
    }
}

# Define the path where the files are located
$rootPath = "C:\path\to\your\files"

# Recursively process all files
Get-ChildItem -Path $rootPath -Recurse -Include "*.md" | ForEach-Object {
    Reorder-FrontMatter -filePath $_.FullName -order $desiredOrder
}

