. ./.powershell/_includes/OpenAI.ps1
function New-ResourceId {
    param (
        [int]$Length = 11  # Default length of YouTube-style ID
    )

    # Define YouTube-style character set (Base64-like but URL-friendly)
    $charSet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_"

    # Generate a random ID
    $resourceId = -join ((1..$Length) | ForEach-Object { $charSet[(Get-Random -Minimum 0 -Maximum $charSet.Length)] })

    return $resourceId
}

function Get-ResourceType {
    param (
        [string]$FilePath
    )

    # Define regex pattern to match resource type
    $pattern = '\\content\\resources\\(?<ResourceType>[^\\]+)\\'

    # Run regex match
    if ($FilePath -match $pattern) {
        return $matches['ResourceType']
    }
    else {
        Write-Debug "No match found." -ForegroundColor Red
        return $null
    }
}


function Get-ResourceThemes {
    param (
        [string]$ResourceContent,
        [string]$ResourceTitle
    )

    # Step 1: Extract core themes
    $themePrompt = @"
You are an expert in content analysis. Given the resource title, content, and year, extract the **core themes, principles, and arguments** that best describe the essence of the content.

### General Rules:
- Extract key themes based on intent, not just keywords.
- Try to decide if this is a technical, business, or agile-related content.
- If this seams like a code snippet , return "code and complexity" as the theme alone.
- Summarise the main focus of the content in a **clean, comma-separated list**.
- Do NOT include extra text, explanations, or formatting.
- Example output: `Scrum Master role, Continuous Delivery, Sprint Planning, Agile Transformation`

**Resource Title:** "$ResourceTitle"  
**Resource Content:** "$ResourceContent"
"@
    
    $themesString = Get-OpenAIResponse -Prompt $themePrompt
    if (-not $themesString) { return @() }
    
    $themes = $themesString -split ', ' | ForEach-Object { $_.Trim() }
    return $themes
}

function Get-RelevantCatalogItems {
    param (
        [string[]]$themes,
        [string[]]$catalog,
        [int]$maxItems = 5,
        [int]$minItems = 1
    )

    # Convert the category catalog into a formatted JSON string
    $catalogString = ($catalog | ConvertTo-Json -Depth 1)

    # Construct the prompt with stricter formatting rules
    $categoryPrompt = @"
You are an expert in content classification. Given the identified themes and a predefined catalog of categories, map the themes to the most relevant categories.

### **Rules:**
1. **Match themes to categories by meaning, not keywords.** Prioritise intent over exact word matches.  
2. **Only select from the predefined category catalog.** You are NOT allowed to create new categories.  
3. **Do NOT select categories if they do not clearly align with the themes.**  
4. **Return between $minItems and $maxItems categories for precision.** If fewer than $minItems are relevant, return only those that fit.  
5. **If no relevant categories exist except Miscellaneous, return only `Miscellaneous`.**  
6. **Ensure output format is strictly correct:**
   - **Comma-separated list of exact category names**  
   - **No additional text, no quotes, no brackets.**  
   - **Correct Example:** `Scrum, Scrum Master, Continuous Delivery`  
   - **Incorrect Examples:**  
     - ❌ `"Scrum", "Scrum Master"`  
     - ❌ `[Scrum, Scrum Master]`  
     - ❌ `['Scrum', 'Scrum Master']`  
     - ❌ `"Miscellaneous"` (unless it is the only valid category)

### **Identified Themes:**
$($themes -join ", ")

### **Valid Categories (Choose only from this list):**
$catalogString

### **Final Output Format**
- Return **EXACTLY** as specified in the rules.
- Return a **clean, comma-separated list**.
- If no categories match, return `Miscellaneous`.
- If no valid category exists and Miscellaneous is not in the list, return an empty string.
"@

    # Get response from OpenAI
    $updatedCategoriesString = Get-OpenAIResponse -Prompt $categoryPrompt

    # Ensure the response meets the required format
    if ($updatedCategoriesString -eq "" -or $updatedCategoriesString -eq "Miscellaneous") {
        return @()
    }

    # Convert the response into an array
    $updatedCategories = $updatedCategoriesString -split ', ' | ForEach-Object { $_.Trim() }

    return $updatedCategories
}


# function Get-CategoryConfidence {
#     param (
#         [string]$ResourceContent, # The article content
#         [string]$ResourceTitle, # The article title
#         [hashtable]$Catalog, # A predefined dictionary of categories
#         [int]$MinConfidence = 50, # Minimum confidence score required to be selected
#         [int]$MaxCategories = 3    # Maximum number of categories to return
#     )

#     # Store AI results
#     $categoryScores = @{}

#     foreach ($category in $Catalog.Keys) {
#         $prompt = @"
# You are an AI expert in content classification. Evaluate how well the given content aligns with the category **"$category"**.

# ### **Instructions:**
# 1. **Assess Relevance:** Determine if the content is a **strong**, **moderate**, or **weak** match for this category.
# 2. **Score the Confidence Level (0-100).**
#    - **0-30**: Weak (content barely relates)
#    - **31-60**: Moderate (content touches on this but is not the focus)
#    - **61-100**: Strong (this category is a clear match for the content)
# 3. **Provide a short reasoning** for the confidence score.
# 4. **Return only a JSON object with the fields:**
#    - `"category"`: The category name.
#    - `"confidence"`: The confidence level (integer 0-100).
#    - `"reasoning"`: A brief explanation of the score.

# **Content Details**
# - **Title:** "$ResourceTitle"  
# - **Content:** "$ResourceContent"
# "@

#         # Call AI API to get category confidence score
#         $responseJson = Get-OpenAIResponse -Prompt $prompt | ConvertFrom-Json

#         # Ensure we have valid AI response
#         if ($responseJson.PSObject.Properties["confidence"] -and $responseJson.confidence -ge $MinConfidence) {
#             $categoryScores[$category] = $responseJson
#         }
#     }

#     # Sort by confidence and return the top categories
#     $sortedCategories = $categoryScores.Values | Sort-Object confidence -Descending | Select-Object -First $MaxCategories
#     return $sortedCategories | ConvertTo-Json -Depth 1
# }


function Get-NewPostBasedOnTranscript {
    param (
        [string]$ResourceTranscript
    )

    $prompt = @"
Act as a professional ghostwriter and SEO specialist, crafting a compelling blog post using the following video transcript. Write in the first person as Martin Hinshelwood, ensuring that the writing style, tone, and structure align with my existing blog posts.

Key Guidelines:

- **Maintain My Unique Voice**: Mirror my natural language, tone, and phrasing as found in my previous writings and video transcripts.
- **Emphasize Personal Experience**: Bring my personal stories, experiences, recommendations, and advice to life in a way that helps the reader understand their real-world relevance.
- **Readable & Engaging**: Use bullet points, short paragraphs, and lists to enhance readability and skimmability.
- **SEO Optimised**: Ensure the post is well-structured, with strategic keyword placement, meta descriptions, and headers for search engine visibility.
- Do not include any other tags or content, just the blog post.
- Do not include a starting title, just the blog post content.

Additional Context for Style Matching:

Here are a few sample excerpts from my past blog posts for reference:
- *Excerpt 1*: "In Scrum Events across the world, I hear repeated the phrase “that’s how agile works” when describing behaviours that are both unprofessional and the very opposite of an agile mindset. These behaviours will inhibit agility and are a result of a lack of understanding of the underlying principles. We need to stop normalising unprofessional behaviour and call it out whenever we hear it. In order for agility to function, we need professionalism; a focus on doing things right so that we don’t end up with our beards caught in the mailbox (Norwegian saying). Agility requires more planning, more knowledge, more diligence, more discipline, and more competence… not less! It’s harder to use agile practices as we are expected to have a usable product at all times, well, at least every iteration of a few weeks"
- *Excerpt 2*: "Prior to the industrial revolution, goods were made in small cottage industries and people worked close to their home. Customers were local, and both the producer and the consumer knew each other well. Mastery in ones chosen profession was paramount and rewards for the master craftsman were earned through increased money, or more time to pursue other interests. What is Taylorism, and why Waterfall is just the tip of the iceberg! When the industrial revolution came along, massive mechanisation was needed to produce goods at scale. However the technology of the time was unable to automate at that scale, so the only available “machines” were people. When, in pursuit of higher production volumes, you take away from people their autonomy, mastery, and purpose in your pursuit, you take away their soul. When you take away the essential elements of rewarding work, people become mindless automatons."
- *Excerpt 3*: "I am not saying that there is no value in Story Points or Planning Poker. When a team is just starting out they need to keep things simple and iterate towards better outcomes. We often start from typical traditional practices and Planning Poker becomes a good learning point. Story Points use rough sizing as a way to analyze the work and break it down. Because really, the scores are made up and the points don’t matter. It’s the conversation that is a valuable thing. The shared understanding that the participants get by having some way to know when they don’t understand the same things. That is awesome. However, agile teams try to use Story Points and Velocity for future predictability and this is a fallacy. While I would be OK with a team using it for a while, if an Agile Team is still using Velocity and Story Points after they have 5 or 10 sprints under their belt then I would have serious concerns about their ability to adapt to change and their sincerity towards that change. What I mean is that they just don’t understand their work or its nature; This is what I mean by immaturity, and not that something else is a sign of maturity! Indeed as the Scrum Team using Story Points really has no consistent reference they are just shooting in the dark the same as they were before. While they have gained an understanding of the goals, they still don’t have an understanding of the predictability and thus no confidence in their predictions. We need concrete data to build trust with stakeholders that we know what we are talking about."
- *Excerpt 4*: "The incompatibility between predictable delivery and agility is fictitious ( tweet this  ) and while usually created by an organisation and structure that is unwilling to let go of the old ways and embrace the tenants of agile it can also be the result of a Scrum Teams fervour to divest themselves of all things that smack of prior planning. There is a lack of understanding that agile and the path to agility is far more than just a change in the way that you build software, it is a fundamental shift in the way that you run your business. Much like the lean movement in manufacturing, companies that embraced it wholeheartedly were the ones that ultimately see the competitive edge that it provides. If one is unwilling to let go of the old ways, then one can’t attain the value of the new. This change will take hard work and courage as the fundamental transparency required to inspect and adapt effectively is at odds with the measures of the past. The lack of predictability of software development is the key to understanding the new model. Why is software so unpredictable! All software development is product development. In lean manufacturing, we can optimise the production of pre-developed products through the nature of its predictable production. Each unit of work takes the same amount of materials and time to produce so any changes that we make to the process, time, or materials can easily be qualified and the benefit demonstrated. Manufacturing lives in the predictive world."

Use the following transcript as the basis for the blog post:

$ResourceTranscript
"@
    return Get-OpenAIResponse -Prompt $prompt


}

function Get-NewTitleBasedOnContent {
    param (
        [string]$Content
    )

    $titlePrompt = @"
Act as a professional ghostwriter and SEO specialist to craft a compelling, SEO-friendly blog post title based on the following content. The title should be attention-grabbing, concise, and reflective of the blog's content while maintaining my distinct writing style.

**Key Guidelines:**

- **Match My Voice & Style**: Mirror my natural language, tone, and phrasing as found in my previous writings and content. Keep the title conversational yet authoritative.
- **SEO Optimised**: Include relevant, high-impact keywords that resonate with my target audience and improve search engine rankings.
- **Engaging & Click-Worthy**: The title should spark curiosity or convey clear value to the reader, keep it simple and direct.
- **Title Only**: Provide only the final title without any additional commentary, tags, or explanations.
- do not wrap in quotes

**Content for Context:**

$Content
"@

    return Get-OpenAIResponse -Prompt $titlePrompt


}

function Get-NewDescriptionBasedOnContent {
    param (
        [string]$Content
    )

    $descriptionPrompt = @"
Act as a professional ghostwriter and SEO specialist to craft a compelling, SEO-friendly meta description for a blog post based on the following video transcript. The description should be engaging, concise, and reflective of the blog's content while maintaining my distinct writing style.

**Key Guidelines:**

- **Match My Voice & Style**: Mirror my natural language, tone, and phrasing as found in my previous writings and video transcripts.
- **SEO Optimised**: Include relevant, high-impact keywords to improve search engine rankings and attract clicks.
- **Engaging & Concise**: The description should spark curiosity or convey clear value to the reader. Use action words or questions when relevant.
- **Character Limit**: The description must be no more than 160 characters.
- **Description Only**: Provide only the final description without any additional commentary, tags, or explanations.

**Transcript for Context:**

$Content
"@


    return Get-OpenAIResponse -Prompt $descriptionPrompt


}


Write-Debug "ResourceHelpers.ps1 loaded"
