# Helpers
. ./.powershell/_includes/YoutubeAPI.ps1

Write-Host "Running v3"


# Create the output directory if it doesn't exist
if (-not (Test-Path $outputDir)) {
    New-Item -Path $outputDir -ItemType Directory
}


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

# Define variables
$apiKey = $env:YOUTUBE_API_KEY
$channelId = "UCkYqhFNmhCzkefHsHS652hw"
$outputDir = "site\content\resources\videos\youtube"
$dataDirectory = ".\site\data"
$refreshData = $false
$transcriptDownloadLimit = 10
$videoUpdateLimit = 1

$dataFilePath = Join-Path $dataDirectory "youtube.json"
if (Test-FileAge -filePath $dataFilePath -hours 3) {
    $allVideosData = Get-YoutubePublicChannelVideos -channelId $channelId -apiKey $env:YOUTUBE_API_KEY  # Call this to fetch video list and save to youtube.json
    # Save all video data to a single youtube.json file
    
    $allVideosData | ConvertTo-Json -Depth 10 | Set-Content -Path $dataFilePath
    Write-Host "$dataFilePath  saved with $($allVideosData.Count) videos."  -ForegroundColor Green
}
else {
    Write-Host "$dataFilePath  is up to date."  -ForegroundColor Yellow
}

$videoUpdateLimit = 1
$videoUpdateCount = 0
$captionsUpdateLimit = 1
$captionsUpdateCount = 0
foreach ($video in $allVideosData) {
    
    Write-Host "Get Video Data for $($video.id.videoId)"  -ForegroundColor Green
    $videoId = $video.id.videoId
    # Create the directory named after the video ID
    $videoDir = Join-Path $outputDir $videoId
    if (-not (Test-Path $videoDir)) {
        New-Item -Path $videoDir -ItemType Directory
    }

    # 1. Get Youtube Video Data

    # File path for data.json
    $jsonFilePathVideos = Join-Path $videoDir "data.json"
    if ($refreshData -or -not (Test-Path $jsonFilePathVideos)) {
        if ($videoUpdateCount -le $videoUpdateLimit) {
            # Call the function to update the data for a single video
            $videoData = Get-YoutubeVideoData -videoId $videoId
            # Save updated video data to data.json
            if ($videoData) {
                $videoData | ConvertTo-Json -Depth 10 | Set-Content -Path $jsonFilePathVideos
                Write-Host "Updated data.json for video: $videoId"
                $videoUpdateCount++;
            }        
        }
        else {
            Write-Host "Reached video update limit of $videoUpdateLimit. skipping."
        }       
    }
    # 2. Get Youtube Captions List
    $jsonFilePathCaptions = Join-Path $videoDir "data.captions.json"
    if ($refreshData -or -not (Test-Path $jsonFilePathCaptions)) {
        if ($captionsUpdateCount -le $videoUpdateLimit) {
            # Call the function to update the data for a single video
            $captionData = Get-YouTubeCaptionsData -videoId $videoId
            # Save updated video data to data.json
            if ($captionData) {
                $captionData | ConvertTo-Json -Depth 10 | Set-Content -Path $jsonFilePathCaptions
                Write-Host "Updated data.captions.json for video: $videoId"
                $captionsUpdateCount++;
            }        
        }
        else {
            Write-Host "Reached capations update limit of $videoUpdateLimit. skipping."
        }
       
    }

   
}



# Update-YoutubeDataFilesFromJson # Call this to update data.json files from youtube.json

#   # Set a limit for the number of transcripts to download

# Download-AllYouTubeCaptions -accessToken $env:GOOGLE_ACCESS_TOKEN