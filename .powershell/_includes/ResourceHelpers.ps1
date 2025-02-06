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
    $catalogString = ($CatalogCategories.GetEnumerator() | ForEach-Object { "`"$($_.Key)`": $($_.Value)" }) -join "`n"

    If ($ResourceYear -lt $ResourceYearLimit) {
        $maxCategories = 2
        $MinCategories = 1
    }

    # Construct a prompt for OpenAI
    $prompt = @"
You are an expert in content classification. Given the resource title, content, and a predefined catalog of categories with descriptions, choose the most relevant categories that capture the core themes, arguments, and principles of the resource.

- **Resource Title:** "$ResourceTitle"
- **Resource Year:** "$ResourceYear"
- **Resource Content:** "$ResourceContent"
- **Catalog of Valid Categories and Descriptions:**
$catalogString


### Rules:
1. Prioritise categories related to Scrum when discussing Scrum concepts (e.g., ‘Scrum Master’, ‘Definition of Done’, ‘Scrum Team’).
2. For quality-focused discussions, prioritise categories like ‘Definition of Done’, ‘Software Increment’, ‘Continuous Delivery’, and ‘Technical Excellence’.
3. Do NOT assign broad Agile categories (e.g., ‘Agile Coaching’) if the content is specifically about Scrum principles.
4. Avoid assigning categories based on isolated words—focus on the context and main arguments.
5. Limit the selection to "$MinCategories"-"$MaxCategories" categories to ensure precision.
6. Do not assign a category if it is not meaningfully reflected in theme and intent of the content.
7. Ensure that you match the case and spelling of the categories in the catalog.

Return only the updated categories as a comma-separated list with no additional characters.
"@

    # Get a response from OpenAI
    $updatedCategoriesString = Get-OpenAIResponse -Prompt $prompt

    # Convert the response into an array
    $updatedCategories = $updatedCategoriesString -split ', ' | ForEach-Object { $_.Trim() }

    return $updatedCategories
}



Write-Host "ResourceHelpers.ps1 loaded" -ForegroundColor Green
