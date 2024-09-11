# Define the path to the folder containing the resources
$baseDirectory = "C:\Users\MartinHinshelwoodNKD\source\repos\wordpress-export-to-markdown\output\nkdresources"

# Function to determine the resource type from the index.md file
function Get-ResourceType {
    param (
        [string]$fileContent
    )

    $resourceType = $null  # Initialize resourceType as null

    # Use multi-line regex to extract YAML frontmatter (everything between --- lines)
    if ($fileContent -match '(?s)^---(.*?)---') {
        $yamlFrontMatter = $matches[1]

        # Try to match the resourceType from the frontmatter
        if ($yamlFrontMatter -match 'resourceType:\s*-\s*"([^"]+)"') {
            $resourceType = $matches[1]  # Extract the resourceType value
        }
    }

    # Check for any YouTube link in the file content (different formats)
    if (-not $resourceType -and $fileContent -match 'https?://(www\.)?(youtube\.com|youtu\.be)/') {
        $resourceType = "video"
    }

    return $resourceType
}


# Function to move the folder to the appropriate destination based on resourceType
function Move-ToFolder {
    param (
        [string]$resourceFolder,
        [string]$resourceType,
        [string]$baseDirectory
    )

    # Define the destination subfolder based on the resourceType
    $destinationFolder = Join-Path $baseDirectory $resourceType

    # Create the destination folder if it doesn't exist
    if (-not (Test-Path $destinationFolder)) {
        New-Item -Path $destinationFolder -ItemType Directory
    }

    # Move the current resource folder into the appropriate resourceType folder
    $destinationPath = Join-Path $destinationFolder (Get-Item $resourceFolder).Name
    Move-Item -Path $resourceFolder -Destination $destinationPath

    Write-Host "Moved folder '$resourceFolder' to '$destinationPath' as '$resourceType'"
}

# Loop through each folder in the base directory
Get-ChildItem -Path $baseDirectory -Directory | ForEach-Object {
    $resourceFolder = $_.FullName

    # Define the path to the index.md file inside the folder
    $indexFilePath = Join-Path $resourceFolder "index.md"

    # Check if the index.md file exists
    if (Test-Path $indexFilePath) {
        # Read the contents of the index.md file
        $fileContent = Get-Content -Path $indexFilePath -Raw

        # Determine the resource type using the Get-ResourceType function
        $resourceType = Get-ResourceType -fileContent $fileContent

        # If we have determined the resourceType, move the folder
        if ($resourceType) {
            Move-ToFolder -resourceFolder $resourceFolder -resourceType $resourceType -baseDirectory $baseDirectory
        }
        else {
            Write-Host "No valid resourceType or YouTube link found in $indexFilePath"
        }
    }
    else {
        Write-Host "No index.md file found in $resourceFolder"
    }
}
