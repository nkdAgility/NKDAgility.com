# Define the directory containing the courses
$courseDir = "site\content\capabilities\training-courses\courses"

# Loop through each course's index.md file
Get-ChildItem -Path "$courseDir\*\index.md" | ForEach-Object {
    $courseFile = $_.FullName

    # Read the content of the file
    $content = Get-Content $courseFile -Raw

    # Separate the front matter from the content
    if ($content -match '^(---\s*\n.*?\n---)') {
        $oldFrontMatter = $matches[1]
        $bodyContent = $content -replace '^(---\s*\n.*?\n---)', ''

        # Convert the old front matter to a hashtable
        $oldYaml = $oldFrontMatter -replace '^---\s*\n', '' -replace '\n---$', ''
        $oldData = ConvertFrom-Yaml $oldYaml

        # Define the new structure and preserve existing values
        $newData = @{
            card          = @{
                title   = if ($oldData.Title?) { $oldData.Title } else { "Course Title" }
                content = if ($oldData.offering?.lead) { $oldData.offering.lead } else { "Course introduction content." }
            }
            code          = if ($oldData.offering?.code) { $oldData.offering.code } else { "PSPO" }
            level         = if ($oldData.offering?.skilllevel) { $oldData.offering.skilllevel } else { "intermediate" }
            assessment    = @{
                icon    = if ($oldData.offering?.assessmentIcon) { $oldData.offering.assessmentIcon } else { "Scrumorg-Assessment-PSPO-I.png" }
                content = if ($oldData.offering?.certification) { $oldData.offering.certification } else { "Certification content." }
            }
            introduction  = if ($oldData.offering?.details) { $oldData.offering.details } else { "Introduction content." }
            overview      = if ($oldData.offering?.audience) { $oldData.offering.audience } else { "Overview content." }
            outcomes      = if ($oldData.offering?.topics) { $oldData.offering.topics } else { "Outcomes content." }
            objectives    = if ($oldData.offering?.objectives) { $oldData.offering.objectives } else { "Objectives content." }
            previewIcon   = if ($oldData.offering?.courseIcon) { $oldData.offering.courseIcon } else { "PSPO-400x.png" }
            brandColour   = if ($oldData.brand?.colour) { $oldData.brand.colour } else { "#749335" }
            prerequisites = if ($oldData.offering?.prerequisites) { $oldData.offering.prerequisites } else { "Prerequisites content." }
            audience      = @{
                overview = if ($oldData.offering?.audience) { $oldData.offering.audience } else { "Audience overview." }
                personas = @("capabilities/training-courses/audiences/product-owners.md")
            }
            trainers      = @("/company/people/martin-hinshelwood/")
        }

        # Convert new structure back to YAML
        $newYaml = $newData | ConvertTo-Yaml

        # Write the updated content back to the file
        $updatedContent = "---`n$newYaml`n---`n$bodyContent"
        Set-Content -Path $courseFile -Value $updatedContent

        Write-Output "Updated $courseFile"
    }
}

# Helper function to convert from YAML
function ConvertFrom-Yaml {
    param (
        [string]$yaml
    )
    # Parse YAML to hashtable
    $serializer = [YamlDotNet.Serialization.Deserializer]::new()
    return $serializer.Deserialize([string]$yaml)
}

# Helper function to convert to YAML
function ConvertTo-Yaml {
    param (
        [object]$data
    )
    # Convert hashtable to YAML
    $serializer = [YamlDotNet.Serialization.Serializer]::new()
    return $serializer.Serialize([object]$data)
}
