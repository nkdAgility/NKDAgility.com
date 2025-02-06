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
- **Current Categories:** "$($CurrentCategories -join ', ')"
- **Catalog of Valid Categories and Descriptions:**
$catalogString


### Rules:
1. Categories must strictly align with the primary thesis of the resource.
2. Do not select categories based on superficial keyword matches.
3. Prioritise broad conceptual categories first before specific techniques.
4. Limit the selection to "$MinCategories"-"$MaxCategories" categories to ensure precision.
5. Do not assign a category if it is not meaningfully reflected in the content.

Return only the updated categories as a comma-separated list with no additional characters.
"@

    # Get a response from OpenAI
    $updatedCategoriesString = Get-OpenAIResponse -Prompt $prompt

    # Convert the response into an array
    $updatedCategories = $updatedCategoriesString -split ', ' | ForEach-Object { $_.Trim() }

    return $updatedCategories
}



Write-Host "ResourceHelpers.ps1 loaded" -ForegroundColor Green
