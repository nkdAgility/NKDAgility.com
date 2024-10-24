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

        # Convert the old front matter to an ordered hashtable
        $oldYaml = $oldFrontMatter -replace '^---\s*\n', '' -replace '\n---$', ''
        $frontmatterData = ConvertFrom-Yaml $oldYaml -Ordered

        # Desired key order
        $orderedKeys = @('title', 'date', 'creator', 'id', 'type', 'slug', 'url', 'aliases', 'course-topics', 'course-vendors', 'tags', 'categories', 'preview', 'previewIcon', 'brandColour', 'card', 'code', 'level', 'assessment', 'objectives', 'prerequisites', 'audience', 'trainers', 'roadmap', 'syllabus', 'events')

        # Loop through desired keys and insert missing keys at the appropriate position
        $previousIndex = -1
        foreach ($key in $orderedKeys) {
            if (-not $frontmatterData.Contains($key)) {
                $insertIndex = if ($previousIndex -eq -1) { 0 } else { $previousIndex + 1 }
                $frontmatterData.Insert($insertIndex, $key, $null)
            }
            $previousIndex = $frontmatterData.Keys.IndexOf($key)
        }

        # Step 2: Update new data with information from "offering" if available
        $offering = $frontmatterData.offering
        if ($offering) {
            if ($offering.type) { $frontmatterData.card.title = $frontmatterData.Title }
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
        $newYaml = ConvertTo-Yaml -Force $frontmatterData

        # Write the updated content back to the file
        $updatedContent = "---`n$newYaml`n---`n$bodyContent"
        Set-Content -Path $courseFile -Value $updatedContent

        Write-Output "Updated $courseFile"
        exit
    }
}
