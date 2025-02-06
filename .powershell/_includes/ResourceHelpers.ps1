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
        [string]$ResourceTitle
    )

    # Convert the category catalog into a formatted string
    $catalogString = ($CatalogCategories.GetEnumerator() | ForEach-Object { "`"$($_.Key)`": $($_.Value)" }) -join "`n"

    # Construct a prompt for OpenAI
    $prompt = @"
You are an expert in content classification. Given the resource title, content, and a predefined catalog of categories with descriptions, choose the most relevant categories for this resource.

- **Resource Title:** "$ResourceTitle"
- **Resource Content:** "$ResourceContent"
- **Current Categories:** "$($CurrentCategories -join ', ')"
- **Catalog of Valid Categories and Descriptions:**
$catalogString


### Rules:
1. Select only categories from the provided catalog.
2. Choose the **most relevant** categories based on the resource’s content and title.
3. Assign **no more than 2 categories**.
4. If a current category is valid, keep it. Otherwise, refine it to a more appropriate one.
5. Ensure accuracy by cross-referencing the category descriptions.

Return the updated categories as a comma-separated list.
"@

    # Get a response from OpenAI
    $updatedCategoriesString = Get-OpenAIResponse -Prompt $prompt

    # Convert the response into an array
    $updatedCategories = $updatedCategoriesString -split ', ' | ForEach-Object { $_.Trim() }

    return $updatedCategories
}



Write-Host "ResourceHelpers.ps1 loaded" -ForegroundColor Green
