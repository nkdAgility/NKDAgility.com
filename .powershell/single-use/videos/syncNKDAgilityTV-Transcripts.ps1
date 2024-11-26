$outputDir = "site\content\resources\videos\youtube"
$downloadLimit = 10  # Set a limit for the number of transcripts to download

# Function to get captions for a video
function Get-YouTubeCaptions {
    param (
        [string]$videoId,
        [string]$accessToken
    )

    $captionsApiUrl = "https://www.googleapis.com/youtube/v3/captions?part=id,snippet&videoId=$videoId"
    $headers = @{"Authorization" = "Bearer $accessToken" }

    $response = Invoke-RestMethod -Uri $captionsApiUrl -Headers $headers -Method Get
    return $response.items
}

# Function to download a caption file with a check if $captionContent is empty
function Download-YouTubeCaption {
    param (
        [string]$captionId,
        [string]$accessToken,
        [string]$outputPath
    )

    # Specify the format as SRT by adding 'tfmt=srt' to the URL
    $downloadUrl = "https://www.googleapis.com/youtube/v3/captions/$captionId/?tfmt=srt"
    $headers = @{"Authorization" = "Bearer $accessToken" }

    # Use Invoke-WebRequest for binary or non-JSON/XML responses
    $response = Invoke-WebRequest -Uri $downloadUrl -Headers $headers -Method Get

    # Check if the response has content
    if (-not [string]::IsNullOrEmpty($response.Content)) {
        # Save the caption content to a file
        [System.IO.File]::WriteAllBytes($outputPath, $response.Content)
        Write-Host "Caption saved to: $outputPath"
        return $true  # Return true to indicate success
    }
    else {
        Write-Host "No caption content available for captionId: $captionId"
        return $false  # Return false to indicate no content
    }
}

# Function to loop through outputDir folders and download captions based on folder names (which are video IDs)
# It will only download the caption if the transcript file does not already exist
function Download-AllYouTubeCaptions {
    param ([string]$accessToken)

    # Get all folders in $outputDir
    $videoFolders = Get-ChildItem -Path $outputDir -Directory
    $downloadCount = 0  # Initialize counter for downloaded transcripts

    foreach ($folder in $videoFolders) {
        if ($downloadCount -ge $downloadLimit) {
            Write-Host "Reached download limit of $downloadLimit transcripts. Stopping."
            break
        }

        $videoId = $folder.Name  # The folder name is assumed to be the videoId
        Write-Host "Processing video ID: $videoId"
        $matchingFiles = Get-ChildItem -Path $folder -Filter "transcript.*.srt" -File

        # Skip if there are already transcript files in the folder
        if ($matchingFiles.Count -gt 0) {
            Write-Host "Transcript files already exist for $videoId"
            continue
        }

        $captions = Get-YouTubeCaptions -videoId $videoId -accessToken $accessToken

        foreach ($caption in $captions) {
            if ($downloadCount -ge $downloadLimit) {
                Write-Host "Reached download limit of $downloadLimit transcripts. Stopping."
                break
            }

            $captionId = $caption.id
            $language = $caption.snippet.language
            $outputPath = Join-Path $folder.FullName "transcript.$language.srt"

            # Check if the transcript already exists
            if (-not (Test-Path $outputPath)) {
                Write-Host "Downloading Transcript in $language for $captionId"
                $success = Download-YouTubeCaption -captionId $captionId -accessToken $accessToken -outputPath $outputPath

                if ($success) {
                    $downloadCount++
                }
            }
            else {
                Write-Host "Transcript in $language for $captionId already exists"
            }
        }
    }

    Write-Host "Downloaded $downloadCount transcript(s)."
}

# Main execution flow

# Step 2: Download captions for all videos by iterating over folder names (which represent video IDs),
# only downloading the transcript if it does not already exist
Download-AllYouTubeCaptions -accessToken $env:GOOGLE_ACCESS_TOKEN
