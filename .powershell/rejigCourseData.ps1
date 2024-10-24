# Define the directory containing the courses
Import-Module PowerShell-Yaml

$courseDir = "site\content\capabilities\training-courses\courses"

# Loop through each course's index.md file
Get-ChildItem -Path "$courseDir\*\index.md" | ForEach-Object {
    $courseFile = $_.FullName

    # Read the content of the file
    $content = Get-Content $courseFile -Raw

    # Separate the front matter from the content
    if ($content -match "(?s)^---(.*?)---") {
        $oldFrontMatter = $matches[1]
        $bodyContent = $content -replace "(?s)^---(.*?)---", ''

        # Convert the old front matter to a hashtable
        $oldYaml = $oldFrontMatter -replace '^---\s*\n', '' -replace '\n---$', ''
        $frontmatterData = ConvertFrom-Yaml $oldYaml

        # Step 1: Add new fields if they do not exist in the source data
        if (-not $frontmatterData.ContainsKey('card')) {
            $frontmatterData.card = @{
                title   = "Course Title"
                content = "Course introduction content."
            }
        }
        if (-not $frontmatterData.ContainsKey('code')) { $frontmatterData.code = "PSPO" }
        if (-not $frontmatterData.ContainsKey('level')) { $frontmatterData.level = "intermediate" }
        if (-not $frontmatterData.ContainsKey('assessment')) {
            $frontmatterData.assessment = @{
                icon    = "Scrumorg-Assessment-PSPO-I.png"
                content = "Certification content."
            }
        }
        if (-not $frontmatterData.ContainsKey('introduction')) { $frontmatterData.introduction = "Introduction content." }
        if (-not $frontmatterData.ContainsKey('overview')) { $frontmatterData.overview = "Overview content." }
        if (-not $frontmatterData.ContainsKey('outcomes')) { $frontmatterData.outcomes = "Outcomes content." }
        if (-not $frontmatterData.ContainsKey('objectives')) { $frontmatterData.objectives = "Objectives content." }
        if (-not $frontmatterData.ContainsKey('previewIcon')) { $frontmatterData.previewIcon = "unknown.png" }
        if (-not $frontmatterData.ContainsKey('brandColour')) { $frontmatterData.brandColour = "#713183" }
        if (-not $frontmatterData.ContainsKey('prerequisites')) { $frontmatterData.prerequisites = "Prerequisites content." }
        if (-not $frontmatterData.ContainsKey('audience')) {
            $frontmatterData.audience = @{
                overview = "Audience overview."
                personas = @("capabilities/training-courses/audiences/product-owners.md")
            }
        }
        if (-not $frontmatterData.ContainsKey('trainers')) { $frontmatterData.trainers = @("/company/people/martin-hinshelwood/") }

        # Step 2: Update new data with information from "offering" if available
        $offering = $frontmatterData.offering
        if ($offering) {
            if ($offering.type) { $frontmatterData.card.title = $offering.type }
            if ($offering.lead) { $frontmatterData.card.content = $offering.lead }
            if ($offering.code) { $frontmatterData.code = $offering.code }
            if ($offering.skilllevel) { $frontmatterData.level = $offering.skilllevel }
            if ($offering.assessmentIcon) { $frontmatterData.assessment.icon = $offering.assessmentIcon }
            if ($offering.certification) { $frontmatterData.assessment.content = $offering.certification }
            if ($offering.details) { $frontmatterData.introduction = $offering.details }
            if ($offering.audience) { $frontmatterData.overview = $offering.audience }
            if ($offering.topics) { $frontmatterData.outcomes = $offering.topics }
            if ($offering.objectives) { $frontmatterData.objectives = $offering.objectives }
            if ($offering.courseIcon) { $frontmatterData.previewIcon = $offering.courseIcon }
            if ($offering.prerequisites) { $frontmatterData.prerequisites = $offering.prerequisites }
        }

        # Convert merged data back to YAML
        $newYaml = ConvertTo-Yaml $frontmatterData

        # Write the updated content back to the file
        $updatedContent = "---`n$newYaml`n---`n$bodyContent"
        Set-Content -Path $courseFile -Value $updatedContent

        Write-Output "Updated $courseFile"
    }
}




