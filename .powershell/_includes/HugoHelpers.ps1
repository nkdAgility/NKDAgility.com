# Ensure PowerShell-YAML module is available
if (-not (Get-Module -ListAvailable -Name PowerShell-Yaml)) {
    Install-Module -Name PowerShell-Yaml -Force -Scope CurrentUser
    Import-Module -Name PowerShell-Yaml
}
else {
    Import-Module -Name PowerShell-Yaml
}

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
    if ($content -match '^(?s)---\s*\n(.*?)\n---\s*\n(.*)$') {
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

function Remove-Field {
    param (
        [Parameter(Mandatory = $true)]
        [System.Collections.Specialized.OrderedDictionary]$frontMatter,
        [Parameter(Mandatory = $true)]
        [string]$fieldName
    )

    if ($frontMatter.Contains($fieldName)) {
        $frontMatter.Remove($fieldName)
        Write-Host "$fieldName removed"
    }
    else {
        Write-Host "$fieldName does not exist"
    }
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
        if ($Overwrite -or ([string]::IsNullOrEmpty($frontMatter[$fieldName]))) {
            # Overwrite the existing value
            $frontMatter[$fieldName] = $fieldValue
            Write-Host "$fieldName overwritten"
        }
        else {
            Write-Host "$fieldName already exists and is not empty"
        }
        return
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
    return 
}

# Update-List function to have the same signature as Update-Field
# Update-List -frontMatter $frontMatter -fieldName 'tags' -values @('DevOps', 'Agile', 'Scrum')
function Update-StringList {
    param (
        [Parameter(Mandatory = $true)]
        [System.Collections.Specialized.OrderedDictionary]$frontMatter,
        [Parameter(Mandatory = $true)]
        [string]$fieldName,
        [Parameter(Mandatory = $true)]
        [string[]]$values,
        [string]$addAfter = $null,
        [string]$addBefore = $null
    )

    # Ensure the input values are unique and always an array
    $values = @($values | Select-Object -Unique)

    if (-not $frontMatter.Contains($fieldName)) {
        # Add property if it doesn't exist with position logic
        $index = $null
        if ($addAfter -and $frontMatter.Contains($addAfter)) {
            $index = $frontMatter.Keys.IndexOf($addAfter) + 1
        }
        elseif ($addBefore -and $frontMatter.Contains($addBefore)) {
            $index = $frontMatter.Keys.IndexOf($addBefore)
        }
        
        if ($index -ne $null) {
            $frontMatter.Insert($index, $fieldName, $values)
        }
        else {
            $frontMatter[$fieldName] = $values
        }
        
        Write-Host "$fieldName added"
    }
    else {
        # Ensure the field is always an array
        if (-not ($frontMatter[$fieldName] -is [System.Collections.IEnumerable] -and $frontMatter[$fieldName] -isnot [string])) {
            $frontMatter[$fieldName] = @($frontMatter[$fieldName])
        }
        
        # Update list if it already exists, adding only unique values
        $existingValues = $frontMatter[$fieldName]
        $newValues = $values | Where-Object { -not ($existingValues -icontains $_) }
        if ($newValues.Count -ne 0) {
            $frontMatter[$fieldName] += $newValues
            Write-Host "$fieldName updated with new unique values"
        }
        else {
            Write-Host "$fieldName already contains all values"
        }
    }

    # Ensure uniqueness while preserving the first occurrence’s casing
    $seen = @{}
    $frontMatter[$fieldName] = @(
        $frontMatter[$fieldName] | Where-Object { 
            $lower = $_.ToLower()
            -not $seen.ContainsKey($lower) -and ($seen[$lower] = $_)  # Store the first occurrence's original case
        }
    )
    
    $frontMatter[$fieldName] = @($frontMatter[$fieldName] | Select-Object -Unique)

    # Ensure the field remains an array even if it has only one value
    if ($frontMatter[$fieldName] -isnot [array]) {
        $frontMatter[$fieldName] = @($frontMatter[$fieldName])
    }
    
    # Check for duplicates in the updated array
    $duplicates = $frontMatter[$fieldName] | Group-Object | Where-Object { $_.Count -gt 1 }
    foreach ($duplicate in $duplicates) {
        Write-Host "Duplicate value: $($duplicate.Name) appears $($duplicate.Count) times"
        exit
    }
}



# Function to save updated HugoMarkdown to a file
function Save-HugoMarkdown {
    param (
        [Parameter(Mandatory = $true)]
        [HugoMarkdown]$hugoMarkdown,
        [Parameter(Mandatory = $true)]
        [string]$Path
    )

    $updatedContent = "---`n$(ConvertTo-Yaml $hugoMarkdown.FrontMatter)`n---`n$($hugoMarkdown.BodyContent.TrimEnd())"
    $updatedContent = $updatedContent -replace "`r`n", "`n"  # Normalize line endings
    $updatedContent += "`n"
    Set-Content -Path $Path -Value $updatedContent -Encoding UTF8NoBOM -NoNewline
}

Write-Host "HugoHelpers.ps1 loaded" -ForegroundColor Green
