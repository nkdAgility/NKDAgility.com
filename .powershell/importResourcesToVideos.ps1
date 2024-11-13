# Base directories for incoming resources
$incomingDir = ".processing"
$videosDir = ".processing\_videos"
$dataDir = "site\data"

# Get all YouTube JSON files in the data directory
$youtubeFiles = Get-ChildItem -Path $dataDir -Filter "youtube-*.json"

# Iterate through each YouTube JSON file
foreach ($youtubeFile in $youtubeFiles) {
    # Load the JSON file
    $jsonData = Get-Content -Raw -Path $youtubeFile.FullName | ConvertFrom-Json

    # Iterate through each item in JSON to get videoId
    foreach ($item in $jsonData.items) {
        $videoId = $item.id.videoId
        Write-Output "Processing videoId: $videoId"

        # Get all folders containing data.yaml under the incoming directory
        $folders = Get-ChildItem -Path $incomingDir -Recurse -Directory | Where-Object {
            Test-Path "$($_.FullName)\data.yaml"
        }

        foreach ($folder in $folders) {
            # Path to the data.yaml file
            $dataYamlPath = "$($folder.FullName)\data.yaml"

            # Load the contents of the YAML file and search for the videoId
            $yamlContent = Get-Content -Path $dataYamlPath -Raw
            if ($yamlContent -match $videoId) {
                # Check if 'wprss_item_guid' exists in the yamlContent
                $hasWPRSS = $yamlContent -match "wprss_item_guid"
                $type = if ($hasWPRSS) { "wprss" } else { "custom" }

                # Define the destination folder for files
                $destination = Join-Path -Path $videosDir -ChildPath $videoId

                # Ensure the destination directory exists
                if (-not (Test-Path -Path $destination)) {
                    New-Item -Path $destination -ItemType Directory -Force
                }

                # List only the files in the folder (excluding any subfolders like 'images')
                Get-ChildItem -Path $folder.FullName -File | ForEach-Object {
                    $fileExtension = $_.Extension
                    $newFileName = "wordpress.$type$fileExtension"

                    # Ensure uniqueness by appending a suffix if needed
                    $counter = 1
                    $finalFilePath = Join-Path -Path $destination -ChildPath $newFileName
                    while (Test-Path -Path $finalFilePath) {
                        $newFileName = "wordpress.$type.$counter$fileExtension"
                        $finalFilePath = Join-Path -Path $destination -ChildPath $newFileName
                        $counter++
                    }

                    # Move and rename the file
                    Copy-Item -Path $_.FullName -Destination $finalFilePath -Force
                }
            }
        }
    }
}
