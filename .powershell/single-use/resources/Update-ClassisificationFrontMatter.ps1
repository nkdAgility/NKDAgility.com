
# Helpers
. ./.powershell/_includes/LoggingHelper.ps1
. ./.powershell/_includes/OpenAI.ps1
. ./.powershell/_includes/HugoHelpers.ps1
. ./.powershell/_includes/ResourceHelpers.ps1
. ./.powershell/_includes/ClassificationHelpers.ps1


$levelSwitch.MinimumLevel = 'Debug'

# Get list of directories and select the first 10
$classes = @();
$classes += Get-ChildItem -Path ".\site\content\concepts\" -Recurse -Filter "_index.md" | Sort-Object { $_ } -Descending | Select-Object -First 300 
$classes += Get-ChildItem -Path ".\site\content\tags\" -Recurse -Filter "_index.md" | Sort-Object { $_ } -Descending | Select-Object -First 300 
$classes += Get-ChildItem -Path ".\site\content\categories\" -Recurse -Filter "_index.md" | Sort-Object { $_ } -Descending | Select-Object -First 300 
$hugoMarkdownList = @()
$classes | ForEach-Object { 
    $hugoMarkdown = Get-HugoMarkdown -Path $_.FullName
    $hugoMarkdownList += $hugoMarkdown
}


$distinctClassificationTypes = $hugoMarkdownList |
ForEach-Object { $_.FrontMatter.ClassificationType } |
Sort-Object -Unique

$classificationPeers = @{}

foreach ($type in $distinctClassificationTypes) {
    $peers = $hugoMarkdownList |
    Where-Object { $_.FrontMatter.ClassificationType -eq $type } |
    ForEach-Object { $_.FrontMatter.Title } |
    Sort-Object

    $classificationPeers[$type] = $peers -join ', '
}
$classificationPeers | ConvertTo-Json -Depth 5 | Set-Content -Path ".\.resources\classificationPeers.json" -Encoding UTF8




$ResourceCatalogue = @{};

# Total count for progress tracking
$TotalFiles = $hugoMarkdownList.Count
$Counter = 0

$hugoMarkdownList | ForEach-Object {

    $Counter++
    $PercentComplete = ($Counter / $TotalFiles) * 100
    $markdownFile = $_.FilePath
    $hugoMarkdown = $_
    Write-InfoLog "--------------------------------------------------------"
    Write-InfoLog "Processing post: $(Resolve-Path -Path $markdownFile -Relative)"
    $peerTitleList = ($hugoMarkdownList | Where-Object { $_.FrontMatter.ClassificationType -eq $hugoMarkdown.FrontMatter.ClassificationType -and $_.FrontMatter.Title -ne $hugoMarkdown.FrontMatter.Title } | ForEach-Object { $_.FrontMatter.Title } | Sort-Object) -join ', '

    Write-Progress -id 1 -Activity "Processing Markdown Files" -Status "Processing $Counter ('$($hugoMarkdown.FrontMatter.title)') of $TotalFiles" -PercentComplete $PercentComplete

        
    Update-Field -frontMatter $hugoMarkdown.FrontMatter -fieldName 'trustpilot' -fieldValue $false -addAfter 'title' 

    $ClassificationType = "Classification"
    $ClassificationType = Split-Path $hugoMarkdown.FolderPath -Parent | Split-Path -Leaf
    Update-Field -frontMatter $hugoMarkdown.FrontMatter -fieldName 'ClassificationType' -fieldValue $ClassificationType -addAfter 'title' -Overwrite

    #=================description=================
    if (-not $hugoMarkdown.FrontMatter.description -or $hugoMarkdown.FrontMatter.description -match "no specific details provided") {
        # Generate a new description using OpenAI
        $prompt = "Generate a concise, engaging description of no more than 160 characters for the following classification: '$($hugoMarkdown.FrontMatter.title)'. \n\n$($hugoMarkdown.BodyContent)"
        $description = Get-OpenAIResponse -Prompt $prompt
        # Update the description in the front matter
        Update-Field -frontMatter $hugoMarkdown.FrontMatter -fieldName 'description' -fieldValue $description -addAfter 'title' 
    }
    if (-not $hugoMarkdown.FrontMatter.Instructions) {
        # Generate a new Instructions using OpenAI
        $prompt = @"
            You are a classification systems architect working on a knowledge taxonomy for agile, DevOps, and modern product development.
            
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


            **Classification Title:** $($hugoMarkdown.FrontMatter.title)  
            **Classification Description:** $($hugoMarkdown.FrontMatter.description)
            **Classification Content:** 
            ~~~
            $($hugoMarkdown.BodyContent)
            ~~~

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

**Classification Title:** $($hugoMarkdown.FrontMatter.title)  
**Classification Description:** $($hugoMarkdown.FrontMatter.description)
**Classification Content:** 
~~~
$($hugoMarkdown.BodyContent)
~~~

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

**Classification Title:** $($hugoMarkdown.FrontMatter.title)  
**Classification Description:** $($hugoMarkdown.FrontMatter.description)
**Classification Content:** 
~~~
$($hugoMarkdown.BodyContent)
~~~

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

    # =================CONTENT====================
    

    $classificationContentPrompt = @"
You are a classification systems architect working on a knowledge taxonomy for agile, lean, DevOps, and modern product development.

Write a concise, authoritative explanation of the concept **$($hugoMarkdown.FrontMatter.title)** as used in an organisational knowledge taxonomy.

This concept is part of the "$($hugoMarkdown.FrontMatter.ClassificationType)" classification group, which also includes: $peerTitleList

Ensure your explanation distinguishes this concept clearly from the others listed above, even where there may be thematic overlap.

Do not begin the response with contextual phrases like “In the context of…” or “Within this classification…”. Begin directly by discussing the concept itself.

Content Requirements:
- Define the concept clearly and explain why it matters.
- Focus on how it enables teams to deliver value predictably and sustainably.
- Emphasise its long-term, systemic, and enabling nature.
- Make the writing suitable for internal knowledgebases or help documentation.
- Avoid academic or abstract language—speak with clarity and precision.
- Avoid unnecessary background—only provide historical or theoretical context if essential.
- Avoid common misconceptions, but only clarify where needed—do not over-explain.
- Do not refer to it as a “classification” or “category”; treat it as a concept being explained to an informed reader.
- Use a free-flowing style without headings or structured sections.
- Maintain a professional, direct tone—every sentence should add value.
- Never use any summary or closing transition phrases such as “in conclusion,” “in summary,” “to conclude,” “ultimately,” “as a final point,” or anything similar. These phrases are forbidden.  
- Do not imply or announce that the explanation is ending. Just stop when the point is fully made.  
- The writing must end mid-flow—cut off naturally as if the next sentence was never needed. The last sentence should deliver value, not closure.
- Do not exceed 200 words.

Keep it concise, natural, and engaging. Do not generate a title. Do not enclose text in quotes.

Classification Title: $($hugoMarkdown.FrontMatter.title)  
Classification Description: $($hugoMarkdown.FrontMatter.description)  
Classification Instruction:
~~~
$($hugoMarkdown.Instructions)
~~~

Guidance for Generating the Content:
Assume the reader already understands Agile, Scrum, and DevOps—get straight to the point.
When referencing theory or practices, favour these contexts:

- Kanban: Kanban Guide, Daniel Vacanti, Donald Reinertsen, John Little
- Agile & Scrum: Scrum Guide, Ken Schwaber, Martin Fowler, Mike Beedle, Ron Jeffries 
- DevOps: Gene Kim, Jez Humble, Patrick Debois, John Willis
- Lean: Taiichi Ohno, Eliyahu M. Goldratt, W. Edwards Deming, Mary & Tom Poppendieck
- Continuous Delivery: Jez Humble, Dave Farley, Martin Fowler, Gene Kim
- Evidence-Based Management: Ken Schwaber, Jeff Sutherland, Patricia Kong, Kurt Bittner
- Complexity Theory: Dave Snowden, Cynefin Framework, Ralph Stacey, Mary Uhl-Bien

Your response should be a fully-formed blog post—natural, sharp, and ready to publish. The post must end without summary, closure, or finality—just finish with a final valuable point and stop.
"@





    # =================COMPLETE===================
    Save-HugoMarkdown -hugoMarkdown $hugoMarkdown -Path $markdownFile 
        
    if (-not $hugoMarkdown.BodyContent) {
        $ClassificationContent = Get-OpenAIResponse -Prompt $classificationContentPrompt

        $hugoMarkdown.BodyContent = $ClassificationContent
        $updateDate = Get-Date -Format "yyyy-MM-ddTHH:mm:ss"
        Update-Field -frontMatter $hugoMarkdown.FrontMatter -fieldName 'BodyContentGenDate' -fieldValue $updateDate -Overwrite
        Update-Field -frontMatter $hugoMarkdown.FrontMatter -fieldName 'ClassificationContentOrigin' -fieldValue "AI" -addAfter 'ClassificationType'
    }

    if ($hugoMarkdown.BodyContent) {
        $priority = 0.7
    }
    else {
        $priority = 0.5
    }                 
    $hugoMarkdown.FrontMatter["sitemap"] = [ordered]@{ filename = "sitemap.xml"; priority = $priority }  # Update sitemap filename

    if ($hugoMarkdown.BodyContent -and $hugoMarkdown.FolderPath -notlike "*concepts*") {
        $typesClassification = Get-ClassificationsForType -updateMissing -ClassificationType "concepts" -hugoMarkdown $hugoMarkdown
        $typesClassificationOrdered = Get-ClassificationOrderedList -minScore 60 -byLevel -classifications $typesClassification | Select-Object -First 1
        $types = $typesClassificationOrdered | ForEach-Object { $_.category }
        Update-StringList -frontMatter $hugoMarkdown.FrontMatter -fieldName 'concepts' -values @($types) -Overwrite
    }

       
    # =================COMPLETE===================
    Save-HugoMarkdown -hugoMarkdown $hugoMarkdown -Path $markdownFile 

    if ($hugoMarkdown.BodyContent) {
        #=================ResourceCatalogue=================
        # Aggregate yearly content per ResourceType
        $classificationType = Split-Path -Path (Split-Path -Path (Split-Path -Path $hugoMarkdown.FilePath -Parent) -Parent) -Leaf
        if (-not $ResourceCatalogue.Contains($classificationType)) {
            $ResourceCatalogue[$classificationType] = @()
        }
        $ResourceCatalogue[$classificationType] += $hugoMarkdown
    }

}
Write-Progress -id 1 -Completed
Write-InfoLog "All markdown files processed."
Write-InfoLog "--------------------------------------------------------"

# Iterate over each ResourceType in the catalogue
foreach ($ResourceType in $ResourceCatalogue.Keys) {
    
    $directoryPath = [System.IO.Path]::Combine(".\.resources", $ResourceType)
    # Ensure the directory exists
    if (-not (Test-Path -Path $directoryPath -PathType Container)) {
        New-Item -Path $directoryPath -ItemType Directory -Force | Out-Null
    }

    foreach ($hugoMarkdown in $ResourceCatalogue[$ResourceType]) {
        $slug = $hugoMarkdown.FrontMatter.slug

        # Ensure slug is formatted properly
        if (-not $slug) {
            $slug = $hugoMarkdown.FrontMatter.title -replace '[:\/\\*?"<>| #%.!,]', '-' -replace '\s+', '-'
        }

        # Save individual post file
        $SaveLocation = [System.IO.Path]::Combine($directoryPath)
        if (-not (Test-Path -Path $SaveLocation -PathType Container)) {
            New-Item -Path $SaveLocation -ItemType Directory -Force | Out-Null
        }
        $SavedFile = [System.IO.Path]::Combine($SaveLocation, "$ResourceType.$slug.$origin.md")
        Save-HugoMarkdown -hugoMarkdown $hugoMarkdown -Path $SavedFile
    }

    # Save aggregated  content
    $FilePath = [System.IO.Path]::Combine($directoryPath, "$ResourceType.yaml")
    $count = $ResourceCatalogue[$ResourceType].Count
    $Content = $ResourceCatalogue[$ResourceType] | ConvertTo-Yaml
    $tokens = Get-TokenCount -Content $Content
    Set-Content -Path $FilePath -Value $Content -Encoding UTF8
    Write-InfoLog "$ResourceType : {files}/{tokens} : {yearlyFilePath}" -PropertyValues $count, $tokens, $FilePath
  
}

