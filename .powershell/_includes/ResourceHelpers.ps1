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
        Write-Host "No match found." -ForegroundColor Red
        return $null
    }
}

# function Get-UpdatedCategories {
#     param (
#         [string[]]$CurrentCategories,
#         [string[]]$CatalogCategories,
#         [string]$ResourceContent,
#         [string]$ResourceTitle,
#         [string]$ResourceYear,
#         [int]$MaxCategories = 5,
#         [int]$MinCategories = 1,
#         [int]$ResourceYearLimit = 2014
#     )

#     # Convert the category catalog into a formatted string
#     #$catalogString = ($CatalogCategories.GetEnumerator() | ForEach-Object { "`"$($_.Key)`": $($_.Value)" }) -join "`n"
#     $catalogString = $CatalogCategories | ConvertTo-Json -Depth 1

#     If ($ResourceYear -lt $ResourceYearLimit) {
#         $maxCategories = 2
#         $MinCategories = 1
#     }

#     # Construct a prompt for OpenAI
#     $prompt = @"
# You are an expert in content classification. Given the resource title, content, and a predefined catalog of categories with descriptions, choose the most relevant categories that accurately capture the core themes, arguments, and principles of the resource.

#  ### General Rules:
#  1. Do NOT select categories based on superficial keyword matches. Context matters.  
#  2. Prioritise categories that match the primary themes and intent of the content, not just words that appear in it.  
#  3. Limit the selection to between $MinCategories-$MaxCategories categories for precision.  
#  4. Do NOT assign broad, generic categories (e.g., "Agile Coaching") if a more precise category exists (e.g., "Scrum Master" or "Scrum Team").  
#  5. If no category is relevant, return an empty string.  

# ### **Category Selection Rules**
# - **You MUST select only from the predefined catalog below.**  
# - **You are NOT allowed to create new categories under any circumstance.**  
# - **If none of the provided categories match, return an empty string ("").**  
# - **Do NOT attempt to modify, rephrase, or infer new categories.**  
# - **Ensure output is a comma-separated list without extra characters.**  

# ### **Valid Categories (Do NOT select anything outside this list)**
# $catalogString

# ### **Final Output Format**
# - **Return categories EXACTLY as they appear in the list.**  
# - **Return a clean comma-separated list with NO quotes, brackets, or additional text.**  
# - **Example correct output:** `Scrum, Scrum Master, Continuous Delivery, Software Increment`  
# - **Incorrect examples:**  
#   - ❌ `'"Scrum"', '"Technical Excellence"'`  
#   - ❌ `'Scrum, "Technical Excellence", [Agile Coaching]'`  
#   - ❌ `'[]'` 
#   - ❌ `'""'` 
# - If no entries are selected return only an empty string with no text or characters.
# ---

#  ### Rules for Scrum, Agile, and Delivery Topics:
#  - Scrum-Specific Topics: If the post is about Scrum principles, roles, or accountabilities, prioritise Scrum categories (e.g., "Scrum Master," "Scrum Team," "Scrum Product Development").  
#  - Scrum Master Role: If the post discusses Scrum Masters' responsibilities, use ‘Scrum Master’ instead of ‘Agile Coaching’.  
#  - Delivery-Focused Content: If the post is about software increments, sprint execution, or CI/CD, prioritise categories like ‘Software Increment’, ‘Continuous Delivery’, or ‘Sprint Planning’.  
#  - Agile Transformation Topics: If the content discusses large-scale agile adoption or organisational shifts, use ‘Agile Transformation’ or ‘Organisational Agility’.  
#  - Do NOT apply Agile Scaling categories (e.g., SAFe, Scaling Scrum) unless the content specifically discusses scaling frameworks.  

# ---

#  ### Rules for Technical Content (Coding, DevOps, Testing, and Engineering):
#  - If the post is about coding, automation, or DevOps, use categories like ‘Technical Excellence’, ‘Automated Testing’, or ‘Azure DevOps’.  
#  - If the post is about software development approaches, use ‘Agile Software Development’ or ‘Test Driven Development’.  
#  - If the post is about testing or quality, prioritise ‘Definition of Done’, ‘Software Increment’, or ‘Test Automation’.  
#  - If the post discusses delivery pipelines, CI/CD, or build automation, use ‘Continuous Integration’ or ‘Azure Pipelines’.  

# ---

#  ### Rules for System Configuration, Hardware, and IT Troubleshooting:
#  - If the post is about IT support, Windows, or system recovery, prioritise ‘Windows’, ‘System Configuration’, or ‘Troubleshooting’.  
#  - Do NOT apply software development or Agile categories to IT hardware or troubleshooting posts.  

# ---

#  ### Rules for Business, Product, and Strategy Content:
#  - If the post is about product ownership or backlog management, prioritise ‘Agile Product Management’, ‘Product Backlog’, or ‘Scrum Product Ownership’.  
#  - If the post is about decision-making in Agile, use ‘Evidence Based Management’ or ‘Value Prioritisation’.  
#  - If the post discusses organisational change and leadership, use ‘Agile Leadership’, ‘Organisational Agility’, or ‘Lean Principles’.  
#  - If the post is about entrepreneurship or Lean Startup approaches, use ‘Lean Startup’ or ‘Business Agility’.  

# ---

#  ### Rules for Excluding Irrelevant Categories:
#  - Avoid ‘Evidence Based Improvement’ unless the post explicitly discusses empirical data-driven Agile practices.  
#  - Avoid ‘Technical Debt’ unless the post is about managing, reducing, or addressing accumulated development issues.  
#  - Avoid ‘Agile Coaching’ unless the post is explicitly about coaching agile teams.  
#  - Avoid ‘Agile Product Discovery’ unless the post is about identifying and validating product ideas.  
#  - Avoid ‘Agile Digital Tools’ unless the post is focused on software like Jira, Azure DevOps, or collaboration tools.  

# ---

# - **Resource Title:** "$ResourceTitle"
# - **Resource Year:** "$ResourceYear"
# - **Resource Content:** "$ResourceContent"




# "@

#     # Get a response from OpenAI
#     $updatedCategoriesString = Get-OpenAIResponse -Prompt $prompt
#     if ($updatedCategoriesString -eq "") {
#         return @()
#     }
#     if ($updatedCategoriesString -match '^["]+$' ) {
#         return @()
#     }
#     if ($updatedCategoriesString -match "^'`"`"'$") {
#         return @()
#     }

#     # Convert the response into an array
#     $updatedCategories = $updatedCategoriesString -split ', ' | ForEach-Object { $_.Trim() }

#     return $updatedCategories
# }


##############################################################



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


function Get-CategoryConfidence {
    param (
        [string]$ResourceContent, # The article content
        [string]$ResourceTitle, # The article title
        [hashtable]$Catalog, # A predefined dictionary of categories
        [int]$MinConfidence = 50, # Minimum confidence score required to be selected
        [int]$MaxCategories = 3    # Maximum number of categories to return
    )

    # Store AI results
    $categoryScores = @{}

    foreach ($category in $Catalog.Keys) {
        $prompt = @"
You are an AI expert in content classification. Evaluate how well the given content aligns with the category **"$category"**.

### **Instructions:**
1. **Assess Relevance:** Determine if the content is a **strong**, **moderate**, or **weak** match for this category.
2. **Score the Confidence Level (0-100).**
   - **0-30**: Weak (content barely relates)
   - **31-60**: Moderate (content touches on this but is not the focus)
   - **61-100**: Strong (this category is a clear match for the content)
3. **Provide a short reasoning** for the confidence score.
4. **Return only a JSON object with the fields:**
   - `"category"`: The category name.
   - `"confidence"`: The confidence level (integer 0-100).
   - `"reasoning"`: A brief explanation of the score.

**Content Details**
- **Title:** "$ResourceTitle"  
- **Content:** "$ResourceContent"
"@

        # Call AI API to get category confidence score
        $responseJson = Get-OpenAIResponse -Prompt $prompt | ConvertFrom-Json

        # Ensure we have valid AI response
        if ($responseJson.PSObject.Properties["confidence"] -and $responseJson.confidence -ge $MinConfidence) {
            $categoryScores[$category] = $responseJson
        }
    }

    # Sort by confidence and return the top categories
    $sortedCategories = $categoryScores.Values | Sort-Object confidence -Descending | Select-Object -First $MaxCategories
    return $sortedCategories | ConvertTo-Json -Depth 1
}





Write-Host "ResourceHelpers.ps1 loaded" -ForegroundColor Green
