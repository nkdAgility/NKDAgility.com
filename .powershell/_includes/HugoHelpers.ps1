

class HugoMarkdown {
    [hashtable]$FrontMatter
    [string]$BodyContent

    HugoMarkdown([hashtable]$frontMatter, [string]$bodyContent) {
        $this.FrontMatter = $frontMatter
        $this.BodyContent = $bodyContent
    }
}


function Get-HugoMarkdown {
    param (
        [string]$MarkdownPath
    )

    # Read the entire content of the Markdown file
    $content = Get-Content -Path $MarkdownPath -Raw

    # Regular expression to match YAML front matter
    if ($content -match '^(?s)---\s*(.*?)\s*---\s*(.*)$') {
        $frontMatterContent = $matches[1]
        $bodyContent = $matches[2]

        # Convert front matter content to an ordered hash table
        $frontMatter = ConvertFrom-Yaml -Yaml $frontMatterContent -Ordered
    }
    else {
        # If no front matter is found, set frontMatter to an empty ordered hash table
        $frontMatter = [ordered]@{}
        $bodyContent = $content
    }

    return [HugoMarkdown]::new($frontMatter, $bodyContent)
}

# Function to update a  field in the front matter
function Update-Field {
    param (
        [hashtable]$frontMatter,
        [string]$fieldName,
        [object]$fieldValue,
        [string]$addAfter = $null,
        [string]$addBefore = $null
    )

    # Check if the field already exists
    if ($frontMatter.Contains($fieldName)) {
        Write-Host "$fieldName already exists"
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