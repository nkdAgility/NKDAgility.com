
# Helpers
. ./.powershell/_includes/LoggingHelper.ps1
. ./.powershell/_includes/OpenAI.ps1
. ./.powershell/_includes/HugoHelpers.ps1
. ./.powershell/_includes/ResourceHelpers.ps1
. ./.powershell/_includes/ClassificationHelpers.ps1


$levelSwitch.MinimumLevel = 'Debug'

# Iterate through each blog folder and update markdown files
$outputDir = ".\site\content\categories\"

# Get list of directories and select the first 10
$classes = Get-ChildItem -Path $outputDir | Sort-Object { $_ } -Descending | Select-Object -First 300 


# Total count for progress tracking
$TotalFiles = $classes.Count
$Counter = 0

$classes | ForEach-Object {

    $Counter++
    $PercentComplete = ($Counter / $TotalFiles) * 100
    $markdownFile = $_
    Write-InfoLog "--------------------------------------------------------"
    Write-InfoLog "Processing post: $(Resolve-Path -Path $markdownFile -Relative)"
    if ((Test-Path $markdownFile)) {

        # Load markdown as HugoMarkdown object
        $hugoMarkdown = Get-HugoMarkdown -Path $markdownFile

        Write-Progress -id 1 -Activity "Processing Markdown Files" -Status "Processing $Counter ('$($hugoMarkdown.FrontMatter.title)') of $TotalFiles" -PercentComplete $PercentComplete

        #=================description=================
        if (-not $hugoMarkdown.FrontMatter.description -or $hugoMarkdown.FrontMatter.description -match "no specific details provided") {
            # Generate a new description using OpenAI
            $prompt = "Generate a concise, engaging description of no more than 160 characters for the following classification: '$($hugoMarkdown.FrontMatter.title)'. "
            $description = Get-OpenAIResponse -Prompt $prompt
            # Update the description in the front matter
            Update-Field -frontMatter $hugoMarkdown.FrontMatter -fieldName 'description' -fieldValue $description -addAfter 'title' -
        }
        if (-not $hugoMarkdown.FrontMatter.Instructions -or $hugoMarkdown.FrontMatter.Instructions -match "Please ensure that the") {
            # Generate a new Instructions using OpenAI
            $prompt = @"
            You are an expert in Agile, Scrum, DevOps, and Evidence-Based Management. Your task is to generate precise category instructions for a technical blog focused on Agile methodologies, DevOps, and business agility. Maintain a structured, professional tone. Instructions should follow this format: 
                - Start with 'Use this category only for discussions on $($hugoMarkdown.FrontMatter.title)'.
                - Define the category's scope and purpose.
                - List key topics that should be discussed.
                - Ensure clarity, conciseness, and relevance.

            Category: $($hugoMarkdown.FrontMatter.title)
"@
            $Instructions = Get-OpenAIResponse -Prompt $prompt
            # Update the description in the front matter
            Update-Field -frontMatter $hugoMarkdown.FrontMatter -fieldName 'Instructions' -fieldValue $Instructions -addAfter 'description' -Overwrite
        }

      
        # =================COMPLETE===================
        Save-HugoMarkdown -hugoMarkdown $hugoMarkdown -Path $markdownFile
    }
    else {
        Write-InfoLog "Skipping folder: $markdownFile (missing index.md)"
    }
}
Write-Progress -id 1 -Completed
Write-InfoLog "All markdown files processed."
Write-InfoLog "--------------------------------------------------------"