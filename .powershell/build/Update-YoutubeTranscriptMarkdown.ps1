# Helpers
. ./.powershell/_includes/LoggingHelper.ps1
. ./.powershell/_includes/OpenAI.ps1
. ./.powershell/_includes/HugoHelpers.ps1

$outputDir = "site\content\resources\videos\youtube"

# Function to use OpenAI to update the description if needed
function Get-CaptionsText {
    param (
        [string]$captionsText
    )
    # Check if the description needs updating
   
    # Generate a new or enhanced description using OpenAI
    $prompt = "Turn this youtube transcript into readable markdown using only the original words of the transcript in the language of the transcript. Dont add titles, but do add capitalisation and punctuation. The speakers name is Martin Hinshelwood and the company is NKDAgility or Naked Agility. \n\n $captionsText"
    $newDescription = Get-OpenAIResponse -Prompt $prompt
    return $newDescription
}

# Function to generate or update Hugo markdown content for a video
function Update-YoutubeTranscriptMarkdown {
    param ()

    # Iterate through each video folder
    Get-ChildItem -Path $outputDir -Directory | ForEach-Object {
        $videoDir = $_.FullName
        $videoId = $_.Name

        # Loop through files matching the format
        Get-ChildItem -Path $videoDir -File -Filter "data.captions.*.srt" | ForEach-Object {
            # Extract the part that matches the * in the pattern
            if ($_.Name -match '^data\.captions\.(.*)\.srt$') {
                $matchPart = $matches[1]
                # Perform operations using the extracted part
                Write-InfoLog $matchPart

                $markdownFile = Join-Path $videoDir "captions.$matchPart.md"
                $captionPath = Join-Path $videoDir "data.captions.$matchPart.srt"
        
                # Load the video data from data.json if available
                if (Test-Path $captionPath) {
                    $captionsData = Get-Content -Path $captionPath
        
                    # Load existing markdown or create a new HugoMarkdown object
                    if (-not (Test-Path $markdownFile)) {
                        Write-InfoLog "Markdown file not found for video: $videoId"
                        $captionsText = Get-CaptionsText -captionsText $captionsData
                        Set-Content -Path $markdownFile -Value $captionsText -Encoding UTF8NoBOM -NoNewline
                        Write-InfoLog "Markdown created or updated for video: $videoId"
                    }  
                    else {
                        Write-InfoLog "Markdown exists: $videoId"
                    }
        
                    
                }
            }
           
           
        }

        
    }

    Write-InfoLog "All markdown files processed."
}

Update-YoutubeTranscriptMarkdown  # Call this to update markdown files from existing data.captions.en.srt files
