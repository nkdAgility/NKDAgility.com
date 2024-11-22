# Define variables
$outputDir = "site\content\resources\videos\youtube"
$excludedTags = @("martin hinshelwood", "nkd agility")  # List of tags to exclude

# Ensure PowerShell-YAML module is available
if (-not (Get-Module -ListAvailable -Name PowerShell-Yaml)) {
    Install-Module -Name PowerShell-Yaml -Force -Scope CurrentUser
    Import-Module -Name PowerShell-Yaml
}
else {
    Import-Module -Name PowerShell-Yaml
}

function Get-Excerpt {
    param (
        [string]$InputString,
        [int]$TargetLength = 100
    )

    # Remove newlines, #tags, and URLs
    $cleanInput = $InputString -replace '\r\n|\r|\n', ' ' # Replace newlines with spaces
    $cleanInput = $InputString -replace '#[^\s]+', ''                      # Remove #tags
    $cleanInput = $InputString -replace 'https?://\S+|www\.\S+', ''      # Remove URLs
    
    # Match sentences ending with `.`, `!`, `?`
    $matches = [regex]::Matches($cleanInput, '.*?[\.\!\?]')
    $excerpt = ""

    foreach ($match in $matches) {
        # Add each match to the excerpt
        $excerpt += $match.Value + " "
        # Stop if we reach or exceed the target length
        if ($excerpt.Length -ge $TargetLength) {
            break
        }
    }

    # Trim any extra spaces and return
    return $excerpt.Trim()
}



# Function to generate markdown content for a video
function Get-NewMarkdownContents {
    param (
        [pscustomobject]$videoData,
        [string]$videoId,
        [string[]]$excludedTags
    )

    $videoSnippet = $videoData.snippet
    $fullDescription = $videoSnippet.description
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
    $publishedAt = Get-Date $videoSnippet.publishedAt -Format "yyyy-MM-ddTHH:mm:ssZ"
    $urlSafeTitle = ($title -replace '[:\/\\*?"<>|#%.]', '-' -replace '\s+', '-').ToLower()

    # Remove consecutive dashes
    $urlSafeTitle = $urlSafeTitle -replace '-+', '-'

    # Create the external URL for the original video
    $externalUrl = "https://www.youtube.com/watch?v=$videoId"

    # Get the tags from the snippet and filter out excluded tags
    $tags = @()
    if ($videoSnippet.tags) {
        $tags = $videoSnippet.tags | Where-Object { -not ($excludedTags -contains $_.ToLower()) }
    }

    # Create an ordered hash for the front matter
    $frontMatter = [ordered]@{
        title        = $title
        description  = Get-Excerpt -InputString $videoSnippet.description
        date         = $publishedAt
        videoId      = $videoId
        url          = "/resources/videos/:slug"
        slug         = $urlSafeTitle
        canonicalUrl = $externalUrl
        aliases      = @("/resources/videos/$videoId", "/resources/videos/$urlSafeTitle")
        preview      = $thumbnailUrl
        duration     = $durationInSeconds
        isShort      = $isShort
        tags         = $tags
        sitemap      = @{ filename = "sitemap.xml"; priority = 0.4 }
        source       = "youtube"
    }

    # Convert ordered hash to YAML front matter
    $frontMatterYaml = "---`n" + ($frontMatter | ConvertTo-Yaml) + "`n---`
"

    # Return the markdown content with front matter and content
    return @"
$frontMatterYaml
{{< youtube $videoId >}}

# $title

$fullDescription

[Watch on YouTube]($externalUrl)
"@
}

# Function to generate markdown files from existing data.json files
function Update-YoutubeMarkdownFiles {
    param ()

    # Iterate through each video folder
    Get-ChildItem -Path $outputDir -Directory | ForEach-Object {
        $videoDir = $_.FullName
        $markdownFile = Join-Path $videoDir "index.md"
        $jsonFilePath = Join-Path $videoDir "data.json"

        # Check if index.md exists and if it contains 'canonicalUrl'
        $shouldUpdate = $false
        if (-not (Test-Path $markdownFile)) {
            # If index.md does not exist, we should create it
            $shouldUpdate = $true
        }
        elseif ((Test-Path $markdownFile) -and (Get-Content -Path $markdownFile -Raw) -match 'source: youtube') {
            # If index.md exists and contains 'canonicalUrl', we should update it
            $shouldUpdate = $true
        }
        else {
            Write-Host "Markdown file for video $($videoDir) has been customised. Skipping."
        }

        # Proceed to update or create the markdown file if necessary
        if ($shouldUpdate -and (Test-Path $jsonFilePath)) {
            # Load the video data from data.json
            $videoData = Get-Content -Path $jsonFilePath | ConvertFrom-Json
            $videoId = $videoData.id

            # Generate markdown content
            $markdownContent = Get-NewMarkdownContents -videoData $videoData -videoId $videoId -excludedTags $excludedTags

            # Write the markdown content to index.md
            Set-Content -Path $markdownFile -Value $markdownContent
            Write-Host "Markdown created or updated for video: $($videoData.snippet.title)"
        }
    }

    Write-Host "All markdown files processed."
}

Update-YoutubeMarkdownFiles  # Call this to update markdown files from existing data.json files