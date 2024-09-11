# Define the folder containing the blog posts
$postsFolder = "C:\Users\MartinHinshelwoodNKD\source\repos\protptype\content\resources\blog"

# Improved regular expression to remove GUIDs anywhere in the filename
$guidPattern = "[0-9A-Fa-f]{8}-[0-9A-Fa-f]{4}-[0-9A-Fa-f]{4}-[0-9A-Fa-f]{4}-[0-9A-Fa-f]{12}"

# Initialize the counter
$counter = 1

function Clean-ImageName {
    param (
        [string]$name,
        [int]$counter
    )

    # Extract file extension
    $extension = [System.IO.Path]::GetExtension($name)
    $baseName = [System.IO.Path]::GetFileNameWithoutExtension($name)
    # Remove specific text
    $baseName = $baseName-replace "GWB-WindowsLiveWriter-", ""
    $baseName = $baseName-replace "GWB-Windows-Live-Writer-", ""

    # Remove GUIDs
    $baseName = $baseName -replace $guidPattern, ""

    # Append the counter to the base name
    $cleanedBaseName = "$baseName-$counter"

    # Combine the cleaned base name with the original extension
    $cleanedName = "$cleanedBaseName$extension"

    Write-Host "Original Name: $name"
    Write-Host "Cleaned Name: $cleanedName"

    return $cleanedName
}

function Clean-ImageNameNasty {
    param (
        [string]$name,
        [int]$counter
    )

    # Extract file extension
    $extension = [System.IO.Path]::GetExtension($name)
    $baseName = "image-" + $counter
    # Combine the cleaned base name with the original extension
    $cleanedName = "$baseName$extension"

    Write-Host "Original Name: $name"
    Write-Host "Cleaned Name: $cleanedName"

    return $cleanedName
}


function Process-PostFolder {
    param (
        [string]$postFolder
    )

    $imagesFolder = Join-Path -Path $postFolder -ChildPath "images"
    $indexFile = Join-Path -Path $postFolder -ChildPath "index.md"

    if (-Not (Test-Path -Path $imagesFolder)) {
        Write-Host "Images folder not found: $imagesFolder"
        return
    }

    $renameMap = @{}

    # Process images
    $imageFiles = Get-ChildItem -Path $imagesFolder -File
    foreach ($image in $imageFiles) {
        $oldPath = $image.FullName
        
        # Only process if path length is more than 255 characters
        if ($oldPath.Length -gt 255) {
            $newName = Clean-ImageName -name $image.Name -counter $counter
            $newPath = Join-Path -Path $imagesFolder -ChildPath $newName
            if ($newPath.Length -gt 255) {
                $newName = Clean-ImageNameNasty -name $image.Name -counter $counter
                $newPath = Join-Path -Path $imagesFolder -ChildPath $newName
            }

            if ($oldPath -ne $newPath) {
                $renameMap[$image.Name] = $newName
                Rename-Item -Path $oldPath -NewName $newPath
                Write-Host "Renamed: $oldPath -> $newPath"
                $counter++  # Increment counter for the next file
            }
        }
    }

    # Update index.md
    if ((Test-Path -Path $indexFile) -and ($renameMap.Count -gt 0)) {
        $content = Get-Content -Path $indexFile -Raw

        foreach ($oldName in $renameMap.Keys) {
            $newName = $renameMap[$oldName]
            $content = $content -replace [regex]::Escape($oldName), $newName
        }

        Set-Content -Path $indexFile -Value $content
        Write-Host "Updated $indexFile with new image names."
    }
}

#Iterate through each post folder
$directories = Get-ChildItem -Path $postsFolder -Directory
foreach ($dir in $directories) {
    Process-PostFolder -postFolder $dir.FullName
}
#Process-PostFolder -postFolder "C:\Users\MartinHinshelwoodNKD\source\repos\protptype\content\resources\blog\2009-10-20-installing-visual-studio-2010-team-foundation-server-on-windows-vista-in-3-minutes"