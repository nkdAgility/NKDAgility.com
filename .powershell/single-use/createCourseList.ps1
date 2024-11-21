# Define the base directory to search
$basePath = "site\content\capabilities\training-courses"
$relativeBase = "capabilities"

# Get all directories within "training-courses"
$folders = Get-ChildItem -Path $basePath -Directory

# Create a list of subfolder paths relative to "capabilities"
$relativePaths = foreach ($folder in $folders) {
    # Find the position of "capabilities" in the full path
    $startIndex = $folder.FullName.IndexOf($relativeBase)
    # Calculate the relative path from "capabilities" onwards
    if ($startIndex -ge 0) {
        $relativePath = $folder.FullName.Substring($startIndex - 1)
        # Replace backslashes with forward slashes
        $relativePath -replace "\\", "/"
    }
}

# Output the list
$relativePaths
