

class HugoMarkdown {
    [System.Collections.Specialized.OrderedDictionary]$FrontMatter
    [string]$BodyContent

    HugoMarkdown([System.Collections.Specialized.OrderedDictionary]$frontMatter, [string]$bodyContent) {
        # Directly assign the front matter to the class property
        $this.FrontMatter = $frontMatter
        # Set the body content
        $this.BodyContent = $bodyContent
    }
}

function Get-HugoMarkdown {
    param (
        [Parameter(Mandatory = $true)]
        [string]$Path
    )

    # Read the entire content of the Markdown file
    $content = Get-Content -Path $Path -Raw

    # Regular expression to match YAML front matter
    if ($content -match '^(?s)---\s*(.*?)\s*---\s*(.*)$') {
        $frontMatterContent = $matches[1]
        $bodyContent = $matches[2]

        # Convert front matter content to an ordered hash table
        $frontMatter = ConvertFrom-Yaml -Yaml $frontMatterContent -Ordered
    }
    else {
        # If no front matter is found, set frontMatter to an empty ordered hash table
        throw "The markdown file in $outputDir is junk"
        exit 1
    }

    return [HugoMarkdown]::new($frontMatter, $bodyContent)
}

# Function to update a  field in the front matter
function Update-Field {
    param (
        [Parameter(Mandatory = $true)]
        [System.Collections.Specialized.OrderedDictionary]$frontMatter,
        [Parameter(Mandatory = $true)]
        [string]$fieldName,
        [Parameter(Mandatory = $true)]
        [object]$fieldValue,
        [string]$addAfter = $null,
        [string]$addBefore = $null,
        [switch]$Overwrite
    )

    # Check if the field already exists
    if ($frontMatter.Contains($fieldName)) {
        if ($Overwrite) {
            # Overwrite the existing value
            $frontMatter[$fieldName] = $fieldValue
            Write-Host "$fieldName overwritten"
        }
        else {
            Write-Host "$fieldName already exists"
        }
        return $frontMatter
    }

    # Determine the position to insert the new field
    if ($addAfter -and $frontMatter.Contains($addAfter)) {
        $index = $frontMatter.Keys.IndexOf($addAfter) + 1
    }
    elseif ($addBefore -and $frontMatter.Contains($addBefore)) {
        $index = $frontMatter.Keys.IndexOf($addBefore)
    }
    else {
        $index = $null
    }

    # Insert or add the field
    if ($index -ne $null) {
        $frontMatter.Insert($index, $fieldName, $fieldValue)
    }
    else {
        $frontMatter[$fieldName] = $fieldValue
    }

    Write-Host "$fieldName added"
    return $frontMatter
}


# Function to save updated HugoMarkdown to a file
function Save-HugoMarkdown {
    param (
        [Parameter(Mandatory = $true)]
        [HugoMarkdown]$hugoMarkdown,
        [Parameter(Mandatory = $true)]
        [string]$Path
    )

    $updatedContent = "---`n$(ConvertTo-Yaml $hugoMarkdown.FrontMatter)`n---`n$($hugoMarkdown.BodyContent)"
    Set-Content -Path $Path -Value $updatedContent
}

Write-Host "HugoHelpers.ps1 loaded" -ForegroundColor Green