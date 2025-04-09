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
    [string]$FilePath
    [string]$FolderPath

    HugoMarkdown([System.Collections.Specialized.OrderedDictionary]$frontMatter, [string]$bodyContent, [string]$FilePath, [string]$FolderPath) {
        # Directly assign the front matter to the class property
        if ($frontMatter -eq $null) {
            Write-ErrorLog "Front matter is null"
            exit 1
        }
        $this.FrontMatter = $frontMatter
        # Set the body content
        $this.BodyContent = $bodyContent
        $this.FilePath = $FilePath
        $this.FolderPath = $FolderPath
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
        if ([string]::IsNullOrEmpty($frontMatterContent)) {
            throw "The markdown file in $Path is junk"
            exit 1
        }
        # Convert front matter content to an ordered hash table
        try {
            $frontMatter = ConvertFrom-Yaml -Yaml $frontMatterContent -Ordered
        }
        catch {
            Write-Host "Error: Failed to convert YAML. Stopping execution." -ForegroundColor Red
            throw
        }
    }
    else {
        # If no front matter is found, set frontMatter to an empty ordered hash table
        
        throw "The markdown file in $Path is junk"
        exit 1
    }

    return [HugoMarkdown]::new($frontMatter, $bodyContent, $Path, (Get-Item -Path $Path).DirectoryName)
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
        Write-Debug "$fieldName removed"
    }
    else {
        Write-Debug "$fieldName does not exist"
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
            Write-Debug "$fieldName overwritten"
        }
        else {
            Write-Debug "$fieldName already exists and is not empty"
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

    Write-Debug "$fieldName added"
    return 
}

function Update-HashtableList {
    param (
        [Parameter(Mandatory = $true)]
        [System.Collections.Specialized.OrderedDictionary]$frontMatter,
        [Parameter(Mandatory = $true)]
        [string]$fieldName,
        [Parameter(Mandatory = $true)]
        [AllowEmptyCollection()]
        [hashtable[]]$values, # Accepts only an array of hashtables
        [string]$addAfter = $null,
        [string]$addBefore = $null,
        [switch]$Overwrite
    )

    # Ensure values are always an array and remove any null values
    $values = @($values | Where-Object { $_ -ne $null })

    # Convert all input hashtables to ordered hashtables while keeping their order intact
    $values = $values | ForEach-Object {
        if ($_ -is [System.Collections.Specialized.OrderedDictionary]) { $_ }
        else { 
            $orderedHash = [ordered]@{}
            $_.GetEnumerator() | ForEach-Object { $orderedHash[$_.Key] = $_.Value }
            $orderedHash
        }
    }

    # If the field doesn't exist, create it with position handling
    if (-not $frontMatter.Contains($fieldName)) {
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

        Write-Debug "$fieldName added"
    }
    else {
        # Ensure the field is always an array
        if (-not ($frontMatter[$fieldName] -is [System.Collections.IEnumerable])) {
            $frontMatter[$fieldName] = @($frontMatter[$fieldName])
        }

        if ($Overwrite) {
            $frontMatter[$fieldName] = $values
        }
        else {
            # Preserve the existing values as an ordered array
            $existingValues = @($frontMatter[$fieldName])

            # Create a lookup table of existing hashtables for deduplication
            $existingHashtablesJson = @{}
            foreach ($hash in $existingValues) {
                $existingHashtablesJson[(ConvertTo-Json $hash -Compress)] = $true
            }

            # Append only unique hashtables in original order
            foreach ($hash in $values) {
                $hashJson = ConvertTo-Json $hash -Compress
                if (-not $existingHashtablesJson.ContainsKey($hashJson)) {
                    $existingHashtablesJson[$hashJson] = $true
                    $existingValues += $hash
                }
            }

            # Maintain the original order exactly
            $frontMatter[$fieldName] = $existingValues
            Write-Debug "$fieldName updated with new unique values"
        }
    }

    # Ensure the field remains an array even if it has only one value
    if ($frontMatter[$fieldName] -isnot [array]) {
        $frontMatter[$fieldName] = @($frontMatter[$fieldName])
    }
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
        [AllowEmptyCollection()]
        [string[]]$values,
        [string]$addAfter = $null,
        [string]$addBefore = $null,
        [switch]$Overwrite
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
        
        Write-Debug "$fieldName added"
    }
    else {
        # Ensure the field is always an array
        if (-not ($frontMatter[$fieldName] -is [System.Collections.IEnumerable] -and $frontMatter[$fieldName] -isnot [string])) {
            $frontMatter[$fieldName] = @($frontMatter[$fieldName])
        }
        
        if ($Overwrite) {
            $frontMatter[$fieldName] = $values
        }
        else {
            # Update list if it already exists, adding only unique values
            $existingValues = $frontMatter[$fieldName]
            $newValues = $values | Where-Object { -not ($existingValues -icontains $_) }
            if ($newValues.Count -ne 0) {
                $frontMatter[$fieldName] += $newValues
                Write-Debug "$fieldName updated with new unique values"
            }
            else {
                Write-Debug "$fieldName already contains all values"
            }
        }       
    }
    
    # Remove any null values
    $frontMatter[$fieldName] = @($frontMatter[$fieldName] | Where-Object { $_ -ne $null })

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
        Write-Debug "Duplicate value: $($duplicate.Name) appears $($duplicate.Count) times"
        exit
    }
}

# Function to save updated HugoMarkdown to a file only if the content differs
function Save-HugoMarkdown {
    param (
        [Parameter(Mandatory = $true)]
        [HugoMarkdown]$hugoMarkdown,
        [Parameter(Mandatory = $true)]
        [string]$Path
    )

    # Generate the updated content
    $updatedContent = "---`n$(ConvertTo-Yaml $hugoMarkdown.FrontMatter)`n---`n$($hugoMarkdown.BodyContent.TrimEnd())"
    $updatedContent = $updatedContent -replace "`r`n", "`n"  # Normalize line endings
    $updatedContent += "`n"

    # Check if the file exists and read its current content
    if (Test-Path $Path) {
        $currentContent = Get-Content -Path $Path -Raw -Encoding UTF8
        $currentContent = $currentContent -replace "`r`n", "`n"  # Normalize line endings

        # Only save if the content differs
        if ($currentContent -ne $updatedContent) {
            Set-Content -Path $Path -Value $updatedContent -Encoding UTF8NoBOM -NoNewline
        }
    }
    else {
        # If the file doesn't exist, create it
        Set-Content -Path $Path -Value $updatedContent -Encoding UTF8NoBOM -NoNewline
    }
}


function Get-HugoMarkdownList {
    param (
        [string]$FolderPath
    )

    $mdFiles = Get-ChildItem -Path $FolderPath -Recurse -Filter "*.md" -File
    $metadataList = @()

    foreach ($markdownFile in $mdFiles) {
        # Load Markdown data using Get-HugoMarkdown
        $hugoMarkdown = Get-HugoMarkdown -Path $markdownFile.FullName
        $metadataList += $hugoMarkdown
    }

    return $metadataList
}

Write-InfoLog "HugoHelpers.ps1 loaded"