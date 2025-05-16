
# Helpers
. ./.powershell/_includes/LoggingHelper.ps1
. ./.powershell/_includes/TokenServer.ps1
. ./.powershell/_includes/OpenAI.ps1
. ./.powershell/_includes/HugoHelpers.ps1
. ./.powershell/_includes/ResourceHelpers.ps1
. ./.powershell/_includes/ClassificationHelpers.ps1

# Paths
$inputPath = ".\.data\matched_resource_posts_with_comments.json"
$outputRoot = "site\content\resources\signals"

# Load matched posts
$entries = Get-Content $inputPath -Raw | ConvertFrom-Json

foreach ($entry in $entries) {
    $post = $entry.Post
    $date = [datetime]::Parse($post.Date)

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

    $title = ($BodyContent -split "`r?`n" | Select-Object -First 1).Trim(".- ")
    
    if ([string]::IsNullOrWhiteSpace($title) -or $title.Length -gt 60) {

        try {
            # Generate a new title using OpenAI
            $titlePrompt = Get-Prompt -PromptName "signal-linkedin-title.md" -Parameters @{
                content = $post.ShareCommentary
            }
            $title = Get-OpenAIResponse -Prompt $titlePrompt
        }
        catch {
            throw "Error generating title: $_"
        }

    }

    # Clean up title 
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

    
    $slug = ($title -replace '[:\/\\\*\?"<>\|#%\.,!—&‘’“”;()\[\]\{\}\+=@^~`]', '-' `
            -replace '\s+', '-' `
            -replace '-{2,}', '-' `
    ).Trim('-').ToLower()


    # Construct folder path
    $folderName = "{0:yyyy-MM-dd}-{1}" -f $date, $slug
    $signalFolder = Join-Path $outputRoot $folderName

    # Ensure folder exists
    if (-not (Test-Path  $signalFolder)) {
        New-Item -ItemType Directory -Path  $signalFolder | Out-Null
    }

    $signalMarkdownFile = Join-Path  $signalFolder "index.md"

    Add-Type -AssemblyName System.Web
    $ShareLinkDecoded = [System.Web.HttpUtility]::UrlDecode($post.ShareLink)
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
        title           = $title
        date            = $date.ToString("yyyy-MM-ddTHH:mm:sszzz")
        slug            = $slug
        draft           = $true
        source          = "LinkedIn"
        platform_signal = $platformSignal
    }

   
    $hugoMarkdown = [HugoMarkdown]::new($frontMatter, "", $signalMarkdownFile, $signalFolder )

    $hugoMarkdown.BodyContent = $BodyContent

    # Save markdown file    
    Save-HugoMarkdown -hugoMarkdown $hugoMarkdown -Path $hugoMarkdown.FilePath


    Write-Host "Created: $signalMarkdownFile"
}
