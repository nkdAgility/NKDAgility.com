
# Helpers
. ./.powershell/_includes/LoggingHelper.ps1
. ./.powershell/_includes/TokenServer.ps1
. ./.powershell/_includes/OpenAI.ps1
. ./.powershell/_includes/HugoHelpers.ps1
. ./.powershell/_includes/ResourceHelpers.ps1
. ./.powershell/_includes/ClassificationHelpers.ps1

$ErrorActionPreference = 'Stop'
$levelSwitch.MinimumLevel = 'Information'

# Paths
$inputPath = ".\.data\matched_resource_posts_with_comments.json"
$outputRoot = "site\content\resources\signals"

# Load matched posts
$entries = Get-Content $inputPath -Raw | ConvertFrom-Json

# Existing Entries
$hugoMarkdownObjects = Get-RecentHugoMarkdownResources -Path $outputRoot -YearsBack 10
$linkedinUrls = $hugoMarkdownObjects |
ForEach-Object {
    $_.FrontMatter.platform_signals |
    Where-Object { $_.platform -eq "LinkedIn" -and $_.post_url } |
    ForEach-Object { $_.post_url }
}

foreach ($entry in $entries) {
    $signalMarkdownFile = $null
    $folderName = $null
    $signalFolder = $null
    $slug = $null
    $title = $null
    $BodyContent = $null
    $ShareLinkDecoded = $null
    $post = $null
    ## begin
    $post = $entry.Post

    Add-Type -AssemblyName System.Web
    $ShareLinkDecoded = [System.Web.HttpUtility]::UrlDecode($post.ShareLink)

    if ($linkedinUrls -contains $ShareLinkDecoded) {
        Write-Host "File already exists for this post: $ShareLinkDecoded"
        continue
    }

   
    $date = [datetime]::Parse($post.Date)

    # Loop until we get a unique slug
    $maxAttempts = 5
    $attempt = 0
    $attemptOutput = @()
    do {
        $title = ($post.ShareCommentary -split "`r?`n" | Select-Object -First 1) -split '\. ' | Select-Object -First 1
        $title = $title.Trim(".- ")
        if ([string]::IsNullOrWhiteSpace($title) -or $title.Length -gt 70 -or $attempt -gt 0) {
            try {
                $titlePrompt = Get-Prompt -PromptName "signal-linkedin-title.md" `
                    -Parameters @{ content = if ($attempt -lt 1) { $title } else { $post.ShareCommentary } }

                $title = Get-OpenAIResponse -Prompt $titlePrompt
            }
            catch {
                throw "Error generating title: $_"
            }
        }

        # Normalise contractions (your existing logic here...)
        # Normalize common contractions for slugs
        $title = $title -replace "\bcan't\b", "can-not"
        $title = $title -replace "\bwon't\b", "will-not"
        $title = $title -replace "\bit's\b", "it-is"
        $title = $title -replace "\bI'm\b", "i-am"
        $title = $title -replace "\bthey're\b", "they-are"
        $title = $title -replace "\bwe're\b", "we-are"
        $title = $title -replace "\byou're\b", "you-are"
        $title = $title -replace "\bI've\b", "i-have"
        $title = $title -replace "\bwe've\b", "we-have"
        $title = $title -replace "\bthey've\b", "they-have"
        $title = $title -replace "\bI'll\b", "i-will"
        $title = $title -replace "\bthey'll\b", "they-will"
        $title = $title -replace "\bthere's\b", "there-is"
        $title = $title -replace "\bthat's\b", "that-is"
        $title = $title -replace "\bdidn't\b", "did-not"
        $title = $title -replace "\bdoesn't\b", "does-not"
        $title = $title -replace "\bdon't\b", "do-not"
        $title = $title -replace "\bshouldn't\b", "should-not"
        $title = $title -replace "\bcouldn't\b", "could-not"
        $title = $title -replace "\bwouldn't\b", "would-not"
        $title = $title -replace "\bhasn't\b", "has-not"
        $title = $title -replace "\bhaven't\b", "have-not"
        $title = $title -replace "\bLet’s\b", "let-us"
        $title = $title -replace "\’s\b", ""
        $title = $title -replace "\'s\b", ""

        # Slugify
        $slug = ($title -replace '[:\/\\\*\?"<>\|#%\.,!—&‘’“”;()\[\]\{\}\+=@^~`]', '-' `
                -replace '\s+', '-' `
                -replace '-{2,}', '-' `
        ).Trim('-').ToLower()

        # Folder path
        $folderName = "{0:yyyy-MM-dd}-{1}" -f $date, $slug
        $signalFolder = Join-Path $outputRoot $folderName
        $attemptOutput += "Attempt $attempt : $signalFolder"
        $attempt++
    } while ((Test-Path $signalFolder) -and ($attempt -lt $maxAttempts))

    if ($attempt -ge $maxAttempts) {
        $attemptOutput
        throw "Could not generate a unique slug after $maxAttempts attempts: $title => $slug"
        exit
    }


    if (!(Test-Path $signalFolder)) {
        New-Item -Path $signalFolder -ItemType Directory | Out-Null
    }

    $signalMarkdownFile = Join-Path  $signalFolder "index.md"
 
    if (!(Test-Path $signalMarkdownFile)) {
        try {
            # Generate a new description using OpenAI
            $bodyPrompt = Get-Prompt -PromptName "signal-linkedin-content.md" -Parameters @{
                content = $post.ShareCommentary
            }
            $BodyContent = Get-OpenAIResponse -Prompt $bodyPrompt
        }
        catch {
            throw "Error generating body content: $_"
        }
        # Parse the post ID from the ShareLink
        $postId = ($ShareLinkDecoded -split ':')[-1]
        # Optional: you could parse these from external analytics data in future
        $performance = [ordered]@{
            impressions     = 0
            members_reached = 0
            reactions       = 0
            comments        = 0
            reposts         = 0
        }
        $platformSignal = @(
            [ordered]@{
                platform    = "LinkedIn"
                post_url    = $ShareLinkDecoded
                post_id     = $postId
                post_date   = $date.ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
                performance = $performance
            }
        )
        # Build frontmatter with nested platform_signal
        $frontMatter = [ordered]@{
            title            = $title
            date             = $date.ToString("yyyy-MM-ddTHH:mm:sszzz")
            slug             = $slug
            draft            = $true
            source           = "LinkedIn"
            platform_signals = $platformSignal
        }
        $hugoMarkdown = [HugoMarkdown]::new($frontMatter, "", $signalMarkdownFile, $signalFolder )
        $hugoMarkdown.BodyContent = $BodyContent
        # Save markdown file    
        Save-HugoMarkdown -hugoMarkdown $hugoMarkdown -Path $hugoMarkdown.FilePath
        Write-Host "Created: $signalMarkdownFile"
    }
    else {
        Write-Host "File already exists: $signalMarkdownFile"
    }

    
}
