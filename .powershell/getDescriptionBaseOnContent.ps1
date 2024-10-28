# Set the folder path containing your Markdown files
$folderPath = "C:\Users\MartinHinshelwoodNKD\source\repos\NKDAgility.com\site\content\resources\blog\2024"
# Set your OpenAI API key
$apiKey = $Env:OPEN_AI_KEY

# Function to call OpenAI and get a meta description
function Call-OpenAI {
    param (
        [Parameter(Mandatory = $false)]
        [string]$system,
        
        # Prompt text
        [Parameter(Mandatory = $true)]
        [string]$prompt,
    
        # OpenAI API Key
        [Parameter(Mandatory = $true)]
        [string]$OPEN_AI_KEY
    )

    # Set the API endpoint and API key
    $apiUrl = "https://api.openai.com/v1/chat/completions"

    # Set default system prompt if not provided
    if ([string]::IsNullOrEmpty($system)) {
        $system = "You are a helpful assistant who generates meta descriptions for Hugo Markdown pages."
    }

    # Create the body for the API request
    $body = @{
        "model"       = "gpt-4o-mini"
        "messages"    = @(
            @{
                "role"    = "system"
                "content" = $system
            },
            @{
                "role"    = "user"
                "content" = $prompt
            }
        )
        "temperature" = 0
        "max_tokens"  = 16000  # Based on model's max output capacity
    } | ConvertTo-Json
    
    # Send the request to the ChatGPT API
    $response = Invoke-RestMethod -Uri $apiUrl -Method Post -Headers @{
        "Content-Type"  = "application/json"
        "Authorization" = "Bearer $OPEN_AI_KEY"
    } -Body $body

    # Extract and return the response content
    return $response.choices[0].message.content
}

# Iterate through all .md files in the folder
Get-ChildItem -Path $folderPath -Filter "*.md" -Recurse | ForEach-Object {
    $filePath = $_.FullName
    $content = Get-Content -Path $filePath -Raw

    # Check if description already exists in the front matter
    if ($content -match "^---[\s\S]*?---" -and $matches[0] -match "description:") {
        Write-Output "Description already exists for $($_.Name). Skipping..."
        return
    }

    # Prepare the prompt for meta description generation
    $prompt = @"
Prompt: Generate Meta Description for Hugo Markdown Page

Take the following Hugo Markdown data with front matter and create a compelling and engaging meta description for the page. The meta description should be between 150 and 160 characters, concisely summarize the core content, and appeal to the intended audience to improve SEO and click-through rates.

content:
```
$content
```

Instructions:

Extract the key information from the front matter (e.g., title, card.content).

Create a description that captures the page's main topic and its value proposition in an engaging way.

Ensure the description is within 150-160 characters.

Output:
A concise, compelling meta description summarizing the page content and encouraging user engagement, formatted as a single line without any markdown or YAML syntax.

Example Output:
"Transform your development with Azure DevOps Migration Services. NKD Agility offers seamless migration to boost productivity and efficiency. Start today!"
"@

    # Get meta description from ChatGPT
    $metaDescription = Call-OpenAI -prompt $prompt -OPEN_AI_KEY $apiKey
    
    # Add the meta description to the front matter of the markdown file, after the title
    if ($content -match "^---[\s\S]*?---") {
        $frontMatter = $matches[0]
        $newFrontMatter = $frontMatter -replace "(?m)(^title:.*$)", "`$1`ndescription: '$metaDescription'"
        $newContent = $newFrontMatter + $content.Substring($frontMatter.Length)
    }
    else {
        $newContent = "---`ntitle: 'Untitled'`ndescription: '$metaDescription'`n---`n" + $content
    }

    # Save the updated content back to the file
    Set-Content -Path $filePath -Value $newContent -Force

    Write-Output "Updated front matter for $($_.Name)"
}

# Note: Make sure to replace YOUR_OPEN_AI_KEY with your actual API key.
