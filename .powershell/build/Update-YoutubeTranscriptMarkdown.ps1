# Helpers
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
        $prompt = "Turn this youtube transcript into readable markdown using only the original words of the transcript. Dont add titles, but do add capitalisation and punctuation. \n\n $captionsText"
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
        $markdownFile = Join-Path $videoDir "index.captions.en.md"
        $captionPath = Join-Path $videoDir "data.captions.en.srt"

        # Load the video data from data.json if available
        if (Test-Path $captionPath) {
            $captionsData = Get-Content -Path $captionPath

            # Load existing markdown or create a new HugoMarkdown object
            if (-not (Test-Path $markdownFile)) {
                Write-Host "Markdown file not found for video: $videoId"
                $captionsText = Get-CaptionsText -captionsText $captionsData
                Set-Content -Path $markdownFile -Value $captionsText -Encoding UTF8NoBOM -NoNewline
                Write-Host "Markdown created or updated for video: $videoId"
            }  

            
        }
    }

    Write-Host "All markdown files processed."
}

Update-YoutubeTranscriptMarkdown  # Call this to update markdown files from existing data.captions.en.srt files
