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

function Get-UpdatedCategories {
    param (
        [string[]]$CurrentCategories,
        [hashtable]$CatalogCategories,
        [string]$ResourceContent,
        [string]$ResourceTitle,
        [string]$ResourceYear,
        [int]$MaxCategories = 5,
        [int]$MinCategories = 1,
        [int]$ResourceYearLimit = 2014
    )

    # Convert the category catalog into a formatted string
    #$catalogString = ($CatalogCategories.GetEnumerator() | ForEach-Object { "`"$($_.Key)`": $($_.Value)" }) -join "`n"
    $catalogString = $CatalogCategories | ConvertTo-Json -Depth 1

    If ($ResourceYear -lt $ResourceYearLimit) {
        $maxCategories = 2
        $MinCategories = 1
    }

    # Construct a prompt for OpenAI
    $prompt = @"
You are an expert in content classification. Given the resource title, content, and a predefined catalog of categories with descriptions, choose the most relevant categories that accurately capture the core themes, arguments, and principles of the resource.

 ### General Rules:
 1. Do NOT select categories based on superficial keyword matches. Context matters.  
 2. Prioritise categories that match the primary themes and intent of the content, not just words that appear in it.  
 3. Limit the selection to between $MinCategories-$MaxCategories categories for precision.  
 4. Do NOT assign broad, generic categories (e.g., "Agile Coaching") if a more precise category exists (e.g., "Scrum Master" or "Scrum Team").  
 5. If no category is relevant, return an empty string.  

### **Category Selection Rules**
- **You MUST select only from the predefined catalog below.**  
- **You are NOT allowed to create new categories under any circumstance.**  
- **If none of the provided categories match, return an empty string ("").**  
- **Do NOT attempt to modify, rephrase, or infer new categories.**  
- **Ensure output is a comma-separated list without extra characters.**  

### **Valid Categories (Do NOT select anything outside this list)**
$catalogString

### **Final Output Format**
- **Return categories EXACTLY as they appear in the list.**  
- **Return a clean comma-separated list with NO quotes, brackets, or additional text.**  
- **Example correct output:** `Scrum, Scrum Master, Continuous Delivery, Software Increment`  
- **Incorrect examples:**  
  - ❌ `'"Scrum"', '"Technical Excellence"'`  
  - ❌ `'Scrum, "Technical Excellence", [Agile Coaching]'`  
  - ❌ `'[]'` 
  - ❌ `'""'` 
- If no entries are selected return only an empty string with no text or characters.
---

 ### Rules for Scrum, Agile, and Delivery Topics:
 - Scrum-Specific Topics: If the post is about Scrum principles, roles, or accountabilities, prioritise Scrum categories (e.g., "Scrum Master," "Scrum Team," "Scrum Product Development").  
 - Scrum Master Role: If the post discusses Scrum Masters' responsibilities, use ‘Scrum Master’ instead of ‘Agile Coaching’.  
 - Delivery-Focused Content: If the post is about software increments, sprint execution, or CI/CD, prioritise categories like ‘Software Increment’, ‘Continuous Delivery’, or ‘Sprint Planning’.  
 - Agile Transformation Topics: If the content discusses large-scale agile adoption or organisational shifts, use ‘Agile Transformation’ or ‘Organisational Agility’.  
 - Do NOT apply Agile Scaling categories (e.g., SAFe, Scaling Scrum) unless the content specifically discusses scaling frameworks.  

---

 ### Rules for Technical Content (Coding, DevOps, Testing, and Engineering):
 - If the post is about coding, automation, or DevOps, use categories like ‘Technical Excellence’, ‘Automated Testing’, or ‘Azure DevOps’.  
 - If the post is about software development approaches, use ‘Agile Software Development’ or ‘Test Driven Development’.  
 - If the post is about testing or quality, prioritise ‘Definition of Done’, ‘Software Increment’, or ‘Test Automation’.  
 - If the post discusses delivery pipelines, CI/CD, or build automation, use ‘Continuous Integration’ or ‘Azure Pipelines’.  

---

 ### Rules for System Configuration, Hardware, and IT Troubleshooting:
 - If the post is about IT support, Windows, or system recovery, prioritise ‘Windows’, ‘System Configuration’, or ‘Troubleshooting’.  
 - Do NOT apply software development or Agile categories to IT hardware or troubleshooting posts.  

---

 ### Rules for Business, Product, and Strategy Content:
 - If the post is about product ownership or backlog management, prioritise ‘Agile Product Management’, ‘Product Backlog’, or ‘Scrum Product Ownership’.  
 - If the post is about decision-making in Agile, use ‘Evidence Based Management’ or ‘Value Prioritisation’.  
 - If the post discusses organisational change and leadership, use ‘Agile Leadership’, ‘Organisational Agility’, or ‘Lean Principles’.  
 - If the post is about entrepreneurship or Lean Startup approaches, use ‘Lean Startup’ or ‘Business Agility’.  

---

 ### Rules for Excluding Irrelevant Categories:
 - Avoid ‘Evidence Based Improvement’ unless the post explicitly discusses empirical data-driven Agile practices.  
 - Avoid ‘Technical Debt’ unless the post is about managing, reducing, or addressing accumulated development issues.  
 - Avoid ‘Agile Coaching’ unless the post is explicitly about coaching agile teams.  
 - Avoid ‘Agile Product Discovery’ unless the post is about identifying and validating product ideas.  
 - Avoid ‘Agile Digital Tools’ unless the post is focused on software like Jira, Azure DevOps, or collaboration tools.  

---

- **Resource Title:** "$ResourceTitle"
- **Resource Year:** "$ResourceYear"
- **Resource Content:** "$ResourceContent"




"@

    # Get a response from OpenAI
    $updatedCategoriesString = Get-OpenAIResponse -Prompt $prompt
    if ($updatedCategoriesString -eq "" || $updatedCategoriesString -match '^["]+$') {
        return @()
    }

    # Convert the response into an array
    $updatedCategories = $updatedCategoriesString -split ', ' | ForEach-Object { $_.Trim() }

    return $updatedCategories
}



Write-Host "ResourceHelpers.ps1 loaded" -ForegroundColor Green
