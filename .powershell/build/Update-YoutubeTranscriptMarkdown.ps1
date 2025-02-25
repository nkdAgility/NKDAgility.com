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

    $prompt = @"
Turn this YouTube srt transcript into readable Markdown using only the original words of the transcript in the language of the transcript.

- Do not add titles, speaker names, or company names.
- Do not add explanations, attributes, or additional text.
- Only use the words from the transcript between the tildes (~).
- Ensure correct capitalisation and punctuation.
- Ensure the text is readable with paragraphs and line breaks.
- Output only the cleaned transcript content. 

~~~
$captionsText
~~~
"@

    # Write the prompt to a temporary file
    $tempFile = [System.IO.Path]::GetTempFileName()
    Set-Content -Path $tempFile -Value $prompt -Encoding UTF8
    $escapedTempFile = $tempFile -replace '\\', '\\'
    # Use Python to count tokens from the file
    $tokenCount = python -c "import tiktoken; enc = tiktoken.encoding_for_model('gpt-4'); print(len(enc.encode(open('''$escapedTempFile''').read())))"
    $tokenCount = [int]$tokenCount
    # Clean up the temporary file
    Remove-Item -Path $tempFile

    Write-InfoLog "Token count: $tokenCount"

    if ($tokenCount -gt 10000) {
        Write-InfoLog "Token count exceeds 10000 Skipping OpenAI request."
        return
    }

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
                    if ($hasWords = $captionsData -match '[a-zA-Z]') {
                        # Load existing markdown or create a new HugoMarkdown object
                        if (-not (Test-Path $markdownFile)) {

                            Write-InfoLog "Markdown file not found for video: $videoId"

                            $captionsText = Get-CaptionsText -captionsText $captionsData
                            if ($captionsText) {
                                Set-Content -Path $markdownFile -Value $captionsText -Encoding UTF8NoBOM -NoNewline
                                Write-InfoLog "Markdown created or updated for video: $videoId"
                            }                
                        }  
                        else {
                            Write-InfoLog "Markdown exists: $videoId"
                        }
                    }
                    else {
                        Write-InfoLog "Should be deleted"
                        Remove-Item -Path $captionPath
                    }
                   
        
                    
                }
            }
           
           
        }

        
    }

    Write-InfoLog "All markdown files processed."
}

Update-YoutubeTranscriptMarkdown  # Call this to update markdown files from existing data.captions.en.srt files
