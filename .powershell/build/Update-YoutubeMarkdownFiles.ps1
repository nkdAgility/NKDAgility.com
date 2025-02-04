# Helpers
. ./.powershell/_includes/OpenAI.ps1
. ./.powershell/_includes/HugoHelpers.ps1

$outputDir = "site\content\resources\videos\youtube"
$excludedTags = @("martin hinshelwood", "nkd agility")  # List of tags to exclude

# Function to use OpenAI to update the description if needed
function Get-UpdatedDescription {
    param (
        [pscustomobject]$videoData
    )

    # Check if the description needs updating
    if (-not $description -or $description.Length -lt 100) {
        # Generate a new or enhanced description using OpenAI
        $prompt = "Generate a concise, engaging description of no more than 160 characters for the following video: '$($videoData.snippet.title)'. The video details are: '$($videoData.snippet.description)'"
        $newDescription = Get-OpenAIResponse -Prompt $prompt
        return $newDescription
    }
    else {
        return $description
    }
}

# Function to generate or update Hugo markdown content for a video
function Update-YoutubeMarkdownFiles {
    param ()

    # Iterate through each video folder
    Get-ChildItem -Path $outputDir -Directory | ForEach-Object {
        $videoDir = $_.FullName
        $markdownFile = Join-Path $videoDir "index.md"
        $jsonFilePath = Join-Path $videoDir "data.json"

        # Load the video data from data.json if available
        if (Test-Path $jsonFilePath) {
            $videoData = Get-Content -Path $jsonFilePath | ConvertFrom-Json
            $videoId = $videoData.id
            $source = $null;
            # Load existing markdown or create a new HugoMarkdown object
            if (Test-Path $markdownFile) {
                $hugoMarkdown = Get-HugoMarkdown -Path $markdownFile
                if ($hugoMarkdown.FrontMatter.Contains("canonicalUrl")) {
                    $source = "youtube"
                }
                else {
                    $source = "internal"
                }
            }
            else {
                $frontMatter = [ordered]@{}
                $hugoMarkdown = [HugoMarkdown]::new($frontMatter, "")
                $source = "youtube"
            }  

            if ($source -eq $null) {
                Write-Host "No source found for video: $($videoData.snippet.title)"
                return
            }

            
           
            $videoSnippet = $videoData.snippet
            $durationISO = $videoData.contentDetails.duration

            # Convert duration to seconds
            $timeSpan = [System.Xml.XmlConvert]::ToTimeSpan($durationISO)
            $durationInSeconds = $timeSpan.TotalSeconds

            # Check if the video is a short (60 seconds or less)
            $isShort = $durationInSeconds -le 60

            # Get the highest resolution thumbnail
            $thumbnails = $videoSnippet.thumbnails
            $thumbnailUrl = $thumbnails.maxres.url
            if (-not $thumbnailUrl) {
                $thumbnailUrl = $thumbnails.high.url  # Fallback to high resolution
            }

            # Format the title to be URL-safe and remove invalid characters
            $title = $videoSnippet.title -replace '[#"]', ' ' -replace ':', ' - ' -replace '\s+', ' '  # Ensure only one space in a row

            

            $urlSafeTitle = ($title -replace '[:\/\\*?"<>|#%.]', '-' -replace '\s+', '-').ToLower()

            # Remove consecutive dashes
            $urlSafeTitle = $urlSafeTitle -replace '-+', '-'

            $aliases = @("/resources/$videoId", "/resources/videos/$videoId", "/resources/videos/$urlSafeTitle", "/resources/$urlSafeTitle")
           
            # Get the tags from the snippet and filter out excluded tags
            $tags = @()
            if ($videoSnippet.tags) {
                $tags = $videoSnippet.tags | Where-Object { -not ($excludedTags -contains $_.ToLower()) }
            }

            # Use Update-Field from HugoHelpers.ps1 to update or add each field
            Update-Field -frontMatter $hugoMarkdown.FrontMatter -fieldName 'title' -fieldValue $title 
            if (-not $hugoMarkdown.FrontMatter.Contains("description")) {
                # Update description using OpenAI if needed
                $fullDescription = Get-UpdatedDescription -videoData $videoData
                Update-Field -frontMatter $hugoMarkdown.FrontMatter -fieldName 'description' -fieldValue $fullDescription -addAfter "title"
            }
            # get the Dates right
            $publishDate = $null
            if ($videoData.status.publishAt) {
                $publishDate = Get-Date $videoData.status.publishAt -Format "yyyy-MM-ddTHH:mm:ssZ"
            }
            else {
                $publishDate = Get-Date $videoSnippet.publishedAt -Format "yyyy-MM-ddTHH:mm:ssZ"
            }
            Update-Field -frontMatter $hugoMarkdown.FrontMatter -fieldName 'date' -fieldValue $publishDate -addAfter "description" -Overwrite
            # / Get the Dates right
            #ExpiryDate
            if ($videoData.status.privacyStatus -eq "private" -and -not $videoData.status.publishAt) {
                if ($videoData.snippet.publishedAt) {
                    $ExpiryDate = $videoData.snippet.publishedAt
                    Update-Field -frontMatter $hugoMarkdown.FrontMatter -fieldName 'ExpiryDate' -fieldValue $ExpiryDate  -addAfter "description" -Overwrite
                    Write-Host "ExpiryDate set to snippet.publishedAt: $($ExpiryDate )"
                }
                else {
                    Write-Host "snippet.publishedAt is missing, cannot set ExpiryDate."
                }
            }
            else {
                Write-Host "!!REMOVE FILED!! Conditions not met. privacyStatus: $($videoData.status.privacyStatus), publishAt: $($jsonData.status.publishAt)" -ForegroundColor Yellow
            }


            Update-Field -frontMatter $hugoMarkdown.FrontMatter -fieldName 'videoId' -fieldValue $videoId
            Update-Field -frontMatter $hugoMarkdown.FrontMatter -fieldName 'ResourceId' -fieldValue $videoId -addAfter "date"
            Update-Field -frontMatter $hugoMarkdown.FrontMatter -fieldName 'source' -fieldValue $source -addAfter "videoId" 
            Update-Field -frontMatter $hugoMarkdown.FrontMatter -fieldName 'url' -fieldValue "/resources/videos/:slug"
            Update-Field -frontMatter $hugoMarkdown.FrontMatter -fieldName 'slug' -fieldValue $urlSafeTitle
            if ($videoData.status.privacyStatus -eq "unlisted") {
                Update-Field -frontMatter $hugoMarkdown.FrontMatter -fieldName 'draft' -fieldValue $true -addAfter "slug" -Overwrite
            }
            Update-Field -frontMatter $hugoMarkdown.FrontMatter -fieldName 'layout' -fieldValue "video" -addAfter "slug"
            if ($source -eq "youtube") {
                $externalUrl = "https://www.youtube.com/watch?v=$videoId"
                Update-Field -frontMatter $hugoMarkdown.FrontMatter -fieldName 'canonicalUrl' -fieldValue $externalUrl
            }           
            Update-StringList -frontMatter $hugoMarkdown.FrontMatter -fieldName 'aliases' -values $aliases
            Update-Field -frontMatter $hugoMarkdown.FrontMatter -fieldName 'preview' -fieldValue $thumbnailUrl 
            Update-Field -frontMatter $hugoMarkdown.FrontMatter -fieldName 'duration' -fieldValue $durationInSeconds
            Update-Field -frontMatter $hugoMarkdown.FrontMatter -fieldName 'isShort' -fieldValue $isShort
            if ($tags.Count -gt 0) {
                Update-StringList -frontMatter $hugoMarkdown.FrontMatter -fieldName 'tags' -values $tags -addAfter "isShort"
            }
            Update-StringList -frontMatter $hugoMarkdown.FrontMatter -fieldName 'resourceTypes' -values "video" -addAfter "duration"
            if ($source -eq "youtube") {
                $priority = 0.4
            }
            else {
                $priority = 0.6
            }                 
            $hugoMarkdown.FrontMatter["sitemap"] = [ordered]@{ filename = "sitemap.xml"; priority = $priority }  # Update sitemap filename
            if ($source -eq "youtube" -or [string]::IsNullOrWhiteSpace($hugoMarkdown.BodyContent)) {
                # Ensure Content
                $hugoMarkdown.BodyContent = " $($videoData.snippet.description) `n [Watch on Youtube](https://www.youtube.com/watch?v=$videoId)" 
            }
            if ($source -eq "internal") {
                $hugoMarkdown.BodyContent = $hugoMarkdown.BodyContent.Replace("{{< youtube $videoId >}}", "")
            }
            # Save the updated HugoMarkdown to index.md
            Save-HugoMarkdown -hugoMarkdown $hugoMarkdown -Path $markdownFile
            Write-Host "Markdown created or updated for video: $($videoSnippet.title)"
        }
    }

    Write-Host "All markdown files processed."
}

Update-YoutubeMarkdownFiles  # Call this to update markdown files from existing data.json files
