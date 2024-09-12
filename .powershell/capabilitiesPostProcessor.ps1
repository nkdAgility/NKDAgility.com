# Load the required module to handle YAML
Import-Module powershell-yaml

# Function to get front matter from a Markdown file
function Get-FrontMatter {
    param (
        [string]$markdownFilePath
    )

    # Read the contents of the Markdown file
    $markdownContent = Get-Content -Path $markdownFilePath -Raw

    # Extract the front matter from the Markdown file (everything between the --- markers)
    if ($markdownContent -match "(?s)^---(.*?)---") {
        $frontMatter = $matches[1]
        $markdownBody = $markdownContent -replace "(?s)^---(.*?)---", ""

        # Convert the front matter to a PowerShell object
        $frontMatterData = ConvertFrom-Yaml -Yaml ($frontMatter)
        
        # Return both the front matter data and the markdown body
        return @{ 
            FrontMatter = $frontMatterData; 
            Body        = $markdownBody 
        }
    }
    else {
        Write-Host "No front matter found in $markdownFilePath"
        return $null
    }
}

# Function to set front matter in a Markdown file
function Set-FrontMatter {
    param (
        [string]$markdownFilePath,
        [hashtable]$frontMatterData,
        [string]$markdownBody
    )

    # Convert the updated front matter back to YAML
    $updatedFrontMatter = ConvertTo-Yaml -Data $frontMatterData

    # Rebuild the Markdown file with the updated front matter and the original content
    $updatedMarkdownContent = "---`n$updatedFrontMatter`n---`n$markdownBody"

    # Write the updated Markdown content back to the file
    Set-Content -Path $markdownFilePath -Value $updatedMarkdownContent
}

# Function to remove the domain from a URL and return the relative path
function Get-RelativePathFromURL {
    param (
        [string]$url
    )

    # Use regex to remove the domain from the URL
    if ($url -match "https?:\/\/[^\/]+(.+)") {
        return $matches[1]
    }
    else {
        return $url
    }
}

# Function to ensure aliases field exists in front matter
function Ensure-AliasesNode {
    param (
        [hashtable]$frontMatterData
    )

    if (-not $frontMatterData.ContainsKey('aliases')) {
        $frontMatterData.aliases = @()
        Write-Host "Added empty aliases structure."
    }
}

# Function to convert duration from days to hours
function Convert-DurationToHours {
    param (
        [string]$durationInDays
    )

    # Assume 8 hours per day
    $days = [int]$durationInDays
    return ($days * 8)
}

# Function to map course type codes to human-readable values
function Convert-CourseType {
    param (
        [string]$courseType
    )

    switch ($courseType) {
        0 { return "Scrum.org (Certified)" }
        1 { return "Scrum" }
        2 { return "Azure DevOps" }
        3 { return "Engineering" }
        4 { return "Kanban (ProKanban.org Certified)" }
        5 { return "Agile Philosophy" }
        default { return "Unknown" }
    }
}

# Function to map skill level codes to human-readable values
function Convert-SkillLevel {
    param (
        [string]$skillLevel
    )

    switch ($skillLevel) {
        0 { return "introductory" }
        1 { return "beginner" }
        2 { return "intermediate" }
        3 { return "advanced" }
        default { return "Unknown" }
    }
}

# Function to update the "Card" node in the front matter, even if data is missing
function Ensure-CardNode {
    param (
        [hashtable]$frontMatterData,
        [string]$cardTitle = "",
        [string]$cardContent = "",
        [string]$cardButtonContent = ""
    )

    # Add or update the "Card" node in the front matter with empty default structure if no data
    if (-not $frontMatterData.ContainsKey('card')) {
        $frontMatterData.card = @{
            title   = $cardTitle;
            content = $cardContent;
            button  = @{
                content = $cardButtonContent
            }
        }
        Write-Host "Added empty card structure."
    }
    else {
        # Ensure all card fields exist
        if (-not $frontMatterData.card.ContainsKey('title')) {
            $frontMatterData.card.title = $cardTitle
        }
        if (-not $frontMatterData.card.ContainsKey('content')) {
            $frontMatterData.card.content = $cardContent
        }
        if (-not $frontMatterData.card.ContainsKey('button')) {
            $frontMatterData.card.button = @{ content = $cardButtonContent }
        }
        elseif (-not $frontMatterData.card.button.ContainsKey('content')) {
            $frontMatterData.card.button.content = $cardButtonContent
        }
        Write-Host "Ensured card structure exists."
    }
}

# Function to update the card front matter
function Update-MarkdownWithCard {
    param (
        [string]$baseDirectory
    )

    # Loop through each subdirectory (each capability or course folder)
    Get-ChildItem -Path $baseDirectory -Directory | ForEach-Object {
        $capabilityFolder = $_.FullName
        $yamlFilePath = Join-Path $capabilityFolder "data.yaml"
        $markdownFilePath = Join-Path $capabilityFolder "index.md"

        # Check if both the YAML and Markdown files exist
        if ((Test-Path $yamlFilePath) -and (Test-Path $markdownFilePath)) {
            # Read the YAML data from data.yaml
            $yamlData = Get-Content -Path $yamlFilePath -Raw | ConvertFrom-Yaml
            $postMetaData = $yamlData.post.postmeta

            # Get the front matter and body from the Markdown file
            $markdownData = Get-FrontMatter -markdownFilePath $markdownFilePath

            if ($markdownData) {
                $frontMatterData = $markdownData.FrontMatter
                $markdownBody = $markdownData.Body

                # Extract the necessary data from the YAML file for the Card node
                $cardTitle = $postMetaData | Where-Object { $_.meta_key -eq 'wpcf-card-title' } | Select-Object -ExpandProperty meta_value
                $cardContent = $postMetaData | Where-Object { $_.meta_key -eq 'wpcf-card-copy' } | Select-Object -ExpandProperty meta_value
                $cardButtonContent = $postMetaData | Where-Object { $_.meta_key -eq 'wpcf-card-button-text' } | Select-Object -ExpandProperty meta_value

                # Ensure that the card structure exists, even if no data
                Ensure-CardNode -frontMatterData $frontMatterData -cardTitle $cardTitle -cardContent $cardContent -cardButtonContent $cardButtonContent

                # Save the updated front matter
                Set-FrontMatter -markdownFilePath $markdownFilePath -frontMatterData $frontMatterData -markdownBody $markdownBody
                Write-Host "Updated card front matter for $markdownFilePath"
            }
        }
        else {
            Write-Host "YAML or Markdown file not found in $capabilityFolder"
        }
    }
}

# Function to update the course metadata in the front matter
function Update-MarkdownWithCourseData {
    param (
        [string]$baseDirectory
    )

    # Loop through each subdirectory (each capability or course folder)
    Get-ChildItem -Path $baseDirectory -Directory | ForEach-Object {
        $capabilityFolder = $_.FullName
        $yamlFilePath = Join-Path $capabilityFolder "data.yaml"
        $markdownFilePath = Join-Path $capabilityFolder "index.md"

        # Check if both the YAML and Markdown files exist
        if ((Test-Path $yamlFilePath) -and (Test-Path $markdownFilePath)) {
            # Read the YAML data from data.yaml
            $yamlData = Get-Content -Path $yamlFilePath -Raw | ConvertFrom-Yaml
            $postMetaData = $yamlData.post.postmeta

            # Get the front matter and body from the Markdown file
            $markdownData = Get-FrontMatter -markdownFilePath $markdownFilePath

            if ($markdownData) {
                $frontMatterData = $markdownData.FrontMatter
                $markdownBody = $markdownData.Body

                # Extract necessary metadata fields
                $code = $postMetaData | Where-Object { $_.meta_key -eq 'wpcf-code' } | Select-Object -ExpandProperty meta_value
                $courseType = $postMetaData | Where-Object { $_.meta_key -eq 'wpcf-course-type' } | Select-Object -ExpandProperty meta_value
                $duration = $postMetaData | Where-Object { $_.meta_key -eq 'wpcf-duration' } | Select-Object -ExpandProperty meta_value
                $skillLevel = $postMetaData | Where-Object { $_.meta_key -eq 'wpcf-skill-level' } | Select-Object -ExpandProperty meta_value
                $lead = $postMetaData | Where-Object { $_.meta_key -eq 'wpcf-course-lead' } | Select-Object -ExpandProperty meta_value
                $audience = $postMetaData | Where-Object { $_.meta_key -eq 'wpcf-cource-target-audience' } | Select-Object -ExpandProperty meta_value
                $format = $postMetaData | Where-Object { $_.meta_key -eq 'wpcf-course-format' } | Select-Object -ExpandProperty meta_value
                $prerequisites = $postMetaData | Where-Object { $_.meta_key -eq 'wpcf-course-prerequisites' } | Select-Object -ExpandProperty meta_value
                $details = $postMetaData | Where-Object { $_.meta_key -eq 'wpcf-more-details' } | Select-Object -ExpandProperty meta_value
                $colour = $postMetaData | Where-Object { $_.meta_key -eq 'wpcf-course-colour-primary' } | Select-Object -ExpandProperty meta_value
                $vendor = $postMetaData | Where-Object { $_.meta_key -eq 'wpcf-vendor' } | Select-Object -ExpandProperty meta_value
                $topics = $postMetaData | Where-Object { $_.meta_key -eq 'wpcf-course-topics' } | Select-Object -ExpandProperty meta_value
                $objectives = $postMetaData | Where-Object { $_.meta_key -eq 'wpcf-course-objectives' } | Select-Object -ExpandProperty meta_value
                $certification = $postMetaData | Where-Object { $_.meta_key -eq 'wpcf-course-assessment-and-certification' } | Select-Object -ExpandProperty meta_value

                # Convert values as necessary
                $courseType = Convert-CourseType -courseType $courseType
                $duration = Convert-DurationToHours -durationInDays $duration
                $skillLevel = Convert-SkillLevel -skillLevel $skillLevel

                # Update the "delivery" node in the front matter
                $frontMatterData.delivery = @{
                    code          = $code
                    type          = $courseType
                    duration      = $duration
                    skilllevel    = $skillLevel
                    lead          = $lead
                    audience      = $audience
                    format        = $format
                    prerequisites = $prerequisites
                    details       = $details
                    brand         = @{
                        colour = $colour
                        vendor = $vendor
                    }
                    topics        = $topics
                    objectives    = $objectives
                    certification = $certification
                }

                # Save the updated front matter back to the Markdown file
                Set-FrontMatter -markdownFilePath $markdownFilePath -frontMatterData $frontMatterData -markdownBody $markdownBody
                Write-Host "Updated front matter for $markdownFilePath with course data."
            }
        }
        else {
            Write-Host "YAML or Markdown file not found in $capabilityFolder"
        }
    }
}

# Function to update the old slugs and post.link as aliases
function Update-OldSlugsAsAliases {
    param (
        [string]$baseDirectory
    )

    # Loop through each subdirectory (each capability or course folder)
    Get-ChildItem -Path $baseDirectory -Directory | ForEach-Object {
        $capabilityFolder = $_.FullName
        $yamlFilePath = Join-Path $capabilityFolder "data.yaml"
        $markdownFilePath = Join-Path $capabilityFolder "index.md"

        # Check if both the YAML and Markdown files exist
        if ((Test-Path $yamlFilePath) -and (Test-Path $markdownFilePath)) {
            # Read the YAML data from data.yaml
            $yamlData = Get-Content -Path $yamlFilePath -Raw | ConvertFrom-Yaml
            $postMetaData = $yamlData.post.postmeta

            # Get the front matter and body from the Markdown file
            $markdownData = Get-FrontMatter -markdownFilePath $markdownFilePath

            if ($markdownData) {
                $frontMatterData = $markdownData.FrontMatter
                $markdownBody = $markdownData.Body

                # Extract all old slugs
                $oldSlugs = @()
                $postMetaData | ForEach-Object {
                    if ($_.meta_key -eq '_wp_old_slug') {
                        $oldSlugs += $_.meta_value
                    }
                }

                # Ensure that aliases field exists, even if no data
                Ensure-AliasesNode -frontMatterData $frontMatterData

                # Add old slugs to aliases if they don't already exist
                foreach ($oldSlug in $oldSlugs) {
                    if ($frontMatterData.aliases -notcontains $oldSlug) {
                        Write-Host "Adding old slug '$oldSlug' to aliases."
                        $frontMatterData.aliases += $oldSlug
                    }
                    else {
                        Write-Host "Slug '$oldSlug' already exists in aliases."
                    }
                }

                # Extract the post.link and remove the domain
                $postLink = $yamlData.post.link
                if ($postLink) {
                    $relativePath = Get-RelativePathFromURL -url $postLink

                    # Add the relative path from post.link to aliases if not already present
                    if ($frontMatterData.aliases -notcontains $relativePath) {
                        Write-Host "Adding relative path '$relativePath' from post.link to aliases."
                        $frontMatterData.aliases += $relativePath
                    }
                    else {
                        Write-Host "Relative path '$relativePath' already exists in aliases."
                    }
                }

                # Save updated front matter
                Set-FrontMatter -markdownFilePath $markdownFilePath -frontMatterData $frontMatterData -markdownBody $markdownBody
                Write-Host "Updated aliases front matter for $markdownFilePath"
            }
        }
        else {
            Write-Host "YAML or Markdown file not found in $capabilityFolder"
        }
    }
}

# Example: Run all updates against the courses and capabilities directories
$courseDirectory = "content\capabilities\training-courses"
$capabilityDirectory = "content\capabilities"
$peopleDirectory = "content\company\people"

Update-MarkdownWithCard -baseDirectory $peopleDirectory
Update-OldSlugsAsAliases -baseDirectory $peopleDirectory

# # Run each update function sequentially for both directories
# Update-MarkdownWithCourseData -baseDirectory $courseDirectory
# Update-MarkdownWithCard -baseDirectory $courseDirectory
# Update-OldSlugsAsAliases -baseDirectory $courseDirectory

# #Update-MarkdownWithCourseData -baseDirectory $capabilityDirectory
# Update-MarkdownWithCard -baseDirectory $capabilityDirectory
# Update-OldSlugsAsAliases -baseDirectory $capabilityDirectory
