
# Helpers
. ./.powershell/_includes/LoggingHelper.ps1
. ./.powershell/_includes/OpenAI.ps1
. ./.powershell/_includes/HugoHelpers.ps1
. ./.powershell/_includes/ResourceHelpers.ps1
. ./.powershell/_includes/ClassificationHelpers.ps1


$levelSwitch.MinimumLevel = 'Debug'

# Get list of directories and select the first 10
$classes = Get-ChildItem -Path ".\site\content\tags\" -Recurse -Filter "_index.md" | Sort-Object { $_ } -Descending | Select-Object -First 300 
$classes += Get-ChildItem -Path ".\site\content\categories\" -Recurse -Filter "_index.md" | Sort-Object { $_ } -Descending | Select-Object -First 300 



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


        Update-Field -frontMatter $hugoMarkdown.FrontMatter -fieldName 'trustpilot' -fieldValue $false -addAfter 'title' 
        #=================description=================
        if (-not $hugoMarkdown.FrontMatter.description -or $hugoMarkdown.FrontMatter.description -match "no specific details provided") {
            # Generate a new description using OpenAI
            $prompt = "Generate a concise, engaging description of no more than 160 characters for the following classification: '$($hugoMarkdown.FrontMatter.title)'. "
            $description = Get-OpenAIResponse -Prompt $prompt
            # Update the description in the front matter
            Update-Field -frontMatter $hugoMarkdown.FrontMatter -fieldName 'description' -fieldValue $description -addAfter 'title' 
        }
        if (-not $hugoMarkdown.FrontMatter.Instructions) {
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
            Update-Field -frontMatter $hugoMarkdown.FrontMatter -fieldName 'date' -fieldValue (Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ") -addAfter 'title' 
        } 
        if (-not $hugoMarkdown.FrontMatter.headline -or (([datetime]$hugoMarkdown.FrontMatter.headline.updated) -lt ([datetime]::Parse("2025-02-13T11:58:02Z")))) {

            $classificationHeadlinePrompt = @"
You are an expert in Agile, Scrum, DevOps, and Evidence-Based Management.

Your task is to generate a **headline subtitle** for a **classification** used to categorise blog posts.
The subtitle should:

- **Concisely convey the scope and purpose** of the classification.
- **Fit within 160 characters**.
- **Help users quickly understand** what topics fall under this classification.
- Avoid using the words Agile, Lean, and DevOps and instead focus on the intent of the classification.

Classification Title: $($hugoMarkdown.FrontMatter.title)
Current Description: $($hugoMarkdown.FrontMatter.description)

Generate the classification headline subtitle only with no additional text. 
- Do not enclose in quotes

When generating the subtitle, consider the following contexts and include relevant connections if applicable:

- Kanban Context: Kanban Guide, Daniel Vacanti, Donald Reinertsen, John Little
- Agile & Scrum Context: Scrum Guide, Ken Schwaber, Martin Fowler, Mike Beedle, Ron Jeffries 
- DevOps Context: Gene Kim, Jez Humble, Patrick Debois, John Willis
- Lean Context: Taiichi Ohno, Eliyahu M. Goldratt, W. Edwards Deming, Mary & Tom Poppendieck
- DevOps & Continuous Delivery Context: Jez Humble, Dave Farley, Martin Fowler, Gene Kim
- Evidence-Based Management Context: Ken Schwaber, Jeff Sutherland, Patricia Kong, Kurt Bittner
- Complexity Theory Context: Dave Snowden, Cynefin Framework, Ralph Stacey, Mary Uhl-Bien
"@
            $ClassificationHeadline = Get-OpenAIResponse -Prompt $classificationHeadlinePrompt
            
            $classificationDescriptionPrompt = @"
You are an expert in Agile, Scrum, DevOps, and Evidence-Based Management.

Your task is to generate a **short description** for a **classification** used to categorise blog posts.
The description should:
- Use more detail and specific language than "$ClassificationHeadline"
- **Define the scope and relevance** of the classification.
- **Be clear and concise**, with **no more than 50 words**.
- **Outline the key topics** that posts in this classification should cover.
- Avoid using the words Agile, Lean, and DevOps and instead focus on the intent of the classification.
- Do not use "This classification focuses.." just describe it
- Do not use "Key topics in this classification.."
- Do not start with "$($hugoMarkdown.FrontMatter.title): "
- 

Classification Title: $($hugoMarkdown.FrontMatter.title)
Current Description: $($hugoMarkdown.FrontMatter.description)

Generate the classification description only with no additional text.
- Do not enclose in quotes
- Never use the term "best practices" only "practices"

When generating the description, consider the following contexts and include relevant connections if applicable:

- Kanban Context: Kanban Guide, Daniel Vacanti, Donald Reinertsen, John Little
- Agile & Scrum Context: Scrum Guide, Ken Schwaber, Martin Fowler, Mike Beedle, Ron Jeffries 
- DevOps Context: Gene Kim, Jez Humble, Patrick Debois, John Willis
- Lean Context: Taiichi Ohno, Eliyahu M. Goldratt, W. Edwards Deming, Mary & Tom Poppendieck
- DevOps & Continuous Delivery Context: Jez Humble, Dave Farley, Martin Fowler, Gene Kim
- Evidence-Based Management Context: Ken Schwaber, Jeff Sutherland, Patricia Kong, Kurt Bittner
- Complexity Theory Context: Dave Snowden, Cynefin Framework, Ralph Stacey, Mary Uhl-Bien
"@
            $ClassificationDescription = Get-OpenAIResponse -Prompt $classificationDescriptionPrompt



            $headline = [ordered]@{
                cards    = @()
                title    = $hugoMarkdown.FrontMatter.title
                subtitle = $ClassificationHeadline
                content  = $ClassificationDescription
                updated  = (Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ")
            }
            Update-Field -frontMatter $hugoMarkdown.FrontMatter -fieldName 'headline' -fieldValue  $headline -addAfter 'Instructions' -Overwrite
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