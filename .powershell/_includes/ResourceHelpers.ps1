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
        Write-Debug "No match found."
        return $null
    }
}

function Get-NewPostBasedOnTranscript {
    param (
        [string]$ResourceTranscript
    )
    $prompt = Get-Prompt -PromptName "resource-content.md" -Parameters @{
        content = $ResourceTranscript
    }
    return Get-OpenAIResponse -Prompt $prompt
}

function Get-NewTitleBasedOnContent {
    param (
        [string]$Content
    )
    $prompt = Get-Prompt -PromptName "content-title.md" -Parameters @{
        content = $ResourceTranscript
    }
    return Get-OpenAIResponse -Prompt $prompt
}

function Get-NewDescriptionBasedOnContent {
    param (
        [string]$Content,
        [string]$Title

    )

    $prompt = Get-Prompt -PromptName "content-description.md" -Parameters @{
        title    = $Title
        abstract = ""
        content  = $ResourceTranscript
    }
    return Get-OpenAIResponse -Prompt $prompt

}


Write-Debug "ResourceHelpers.ps1 loaded"
