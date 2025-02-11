
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
      
        # Generate a new Instructions using OpenAI
        $prompt = @"
            You are an expert in Agile, Scrum, DevOps, and Evidence-Based Management. 
            
            Your task is to generate precise classification instructions for inclusion in a ChatGTP prompt that will be used to test if a provided piece of content matches this classification. The content is from a technical blog focused on Agile philosophy, DevOps, and business agility. 
            
            Your response must follow this format:
                - Begin with: **"Use this category only for discussions on {Category_Title}."**
                - Clearly **define the category’s scope and purpose**.
                - List **key topics** that should be discussed under this category.
                - Ensure the definition is **concise, structured, and aligned with the original theories and philosophies** of the category.
                - **Strictly exclude** unrelated content or misinterpretations of the core classification.
            
            For specific topics favour the original theory and philosophies based on these general contexts:
             - Kanban Context: Kanban Guide, Daniel Vacanti, Donald Reinertsen, John Little
             - Agile & Scrum Context:  Scrum Guide, Ken Schwaber, Martin Fowler, Mike Beedle, Ron Jeffries 
             - DevOps Context: Gene Kim, Jez Humble, Patrick Debois, John Willis
             - Lean Context: Taiichi Ohno, SEliyahu M. Goldratt, W. Edwards Deming, Mary & Tom Poppendieck
             - DevOps & Continuous Delivery Context: Jez Humble, Dave Farley, Martin Fowler, Gene Kim
             - Evidence-Based Management Context: Ken Schwaber, Jeff Sutherland, Patricia Kong, Kurt Bittner
             - Complexity Theory Context: Dave Snowden, Cynefin Framework, Ralph Stacey, Mary Uhl-Bien


            Category: $($hugoMarkdown.FrontMatter.title)
            Current Description: $($hugoMarkdown.FrontMatter.description)

            Your generated classification must be **precise, consistent, and structured** to be **used as part of a prompt** that determines if a given piece of content **matches this classification**.
"@
        $Instructions = Get-OpenAIResponse -Prompt $prompt
        # Update the description in the front matter
        Update-Field -frontMatter $hugoMarkdown.FrontMatter -fieldName 'Instructions' -fieldValue $Instructions -addAfter 'description' -Overwrite
       

      
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