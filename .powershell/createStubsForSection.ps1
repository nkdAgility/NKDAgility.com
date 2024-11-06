function Create-StubIndexForSection {
    param (
        [Parameter(Mandatory = $true)]
        [array]$sections, # List of sections with slugs, titles, and content

        [Parameter(Mandatory = $true)]
        [string]$baseFolder  # Base folder location to process
    )

    # Iterate over each section and create the appropriate .md files if they don't exist
    foreach ($section in $sections) {
        $folderPath = Join-Path $baseFolder $section["slug"]
        $filePath = Join-Path $folderPath "index.md"

        # Ensure the folder exists
        if (-not (Test-Path $folderPath)) {
            New-Item -Path $folderPath -ItemType Directory
        }

        # Only create the index.md file if it doesn't already exist
        if (-not (Test-Path $filePath)) {
            # Define the content for the .md file with custom card content
            $content = @"
---
slug: $($section["slug"])
creator: Martin Hinshelwood
title: $($section["title"])
aliases:
  - $($section["aliases"])
date: $(Get-Date -Format yyyy-MM-dd)
resourceTypes: method
layout: methods
card:
  title: $($section["title"])
  content: $($section["content"])
  button:
    content: Start Optimizing Now
---

Coming soon!

"@

            # Write the content to the index.md file
            Set-Content -Path $filePath -Value $content

            Write-Host "Created: $filePath"
        }
        else {
            Write-Host "Skipped: $filePath (already exists)"
        }
    }
}

# Example usage of Create-StubIndexForSection

# Define the list of sections with their corresponding slugs, titles, aliases, and card content
$methods = @(
    @{ "slug" = "scrum-framework"; "title" = "Scrum Framework"; "aliases" = "/methods/scrum-framework/"; "content" = "Master the Scrum Framework with our expert-led training. Empower your team to deliver high-value increments and ensure product success through iterative development and continuous feedback." },
    @{ "slug" = "kanban-strategy"; "title" = "Kanban Strategy"; "aliases" = "/methods/kanban-strategy/"; "content" = "Optimize your workflow with Kanban strategies tailored for your team. Visualize work, limit work-in-progress, and enhance overall efficiency." },
    @{ "slug" = "evidence-based-management"; "title" = "Evidence-Based Management"; "aliases" = "/methods/ebm/"; "content" = "Make data-driven decisions with Evidence-Based Management (EBM). Use metrics to guide your team toward continuous improvement and increased value delivery." },
    @{ "slug" = "beta-codex-cell-structure-design"; "title" = "Beta Codex Cell Structure Design"; "aliases" = "/methods/beta-codex-cell-structure-design/"; "content" = "Implement Beta Codex cell structure design to decentralize and scale your organization. Create a flexible, adaptive team structure that promotes innovation." },
    @{ "slug" = "open-space-agile"; "title" = "Open Space Agile"; "aliases" = "/methods/open-space-agile/"; "content" = "Harness the power of Open Space Agile to enable dynamic self-organization. Facilitate meaningful discussions and collaborative decision-making across your team." },
    @{ "slug" = "one-engineering-system"; "title" = "One Engineering System"; "aliases" = "/methods/one-engineering-system/"; "content" = "Unify your development pipeline with One Engineering System. Ensure seamless collaboration and integration across all engineering teams and workflows." },
    @{ "slug" = "liberating-structures"; "title" = "Liberating Structures"; "aliases" = "/methods/liberating-structures/"; "content" = "Unlock creativity and innovation through Liberating Structures. Engage your team in dynamic, inclusive conversations that drive impactful outcomes." }
)

$principles = @(
    @{ "slug" = "competence"; "title" = "Competence"; "aliases" = "/principles/competence/"; "content" = "Foster a culture of competence where skills and expertise are continuously developed to drive excellence in every aspect of the organization." },
    @{ "slug" = "first-principles-thinking"; "title" = "First Principles Thinking"; "aliases" = "/principles/first-principles-thinking/"; "content" = "Apply First Principles Thinking to break down complex problems and find innovative solutions by understanding the fundamental truths." },
    @{ "slug" = "continuous-improvement"; "title" = "Continuous Improvement"; "aliases" = "/principles/continuous-improvement/"; "content" = "Commit to a mindset of Continuous Improvement, always seeking ways to enhance processes, products, and team performance." },
    @{ "slug" = "customer-focus"; "title" = "Customer Focus"; "aliases" = "/principles/customer-focus/"; "content" = "Maintain a strong Customer Focus to ensure that the needs and feedback of the customer are at the heart of everything we do." },
    @{ "slug" = "innovation"; "title" = "Innovation"; "aliases" = "/principles/innovation/"; "content" = "Encourage Innovation by creating an environment where new ideas and approaches are explored to solve challenges and create value." }
)

$outcomes = @(
    @{ "slug" = "increased-team-productivity"; "title" = "Increased Team Productivity"; "aliases" = "/outcomes/increased-team-productivity/"; "content" = "Boost your team's productivity through effective collaboration, streamlined workflows, and enhanced focus on value delivery." },
    @{ "slug" = "improved-collaboration"; "title" = "Improved Collaboration"; "aliases" = "/outcomes/improved-collaboration/"; "content" = "Foster improved collaboration across teams and departments, leading to better communication, transparency, and project success." },
    @{ "slug" = "faster-delivery-of-value"; "title" = "Faster Delivery of Value"; "aliases" = "/outcomes/faster-delivery-of-value/"; "content" = "Accelerate the delivery of value by adopting agile practices that reduce time-to-market and improve responsiveness to change." },
    @{ "slug" = "enhanced-product-quality"; "title" = "Enhanced Product Quality"; "aliases" = "/outcomes/enhanced-product-quality/"; "content" = "Improve product quality by embedding continuous testing, feedback, and iterative development into your product lifecycle." }
)



# Call the function with the methods list and the base folder location
Create-StubIndexForSection -sections $methods -baseFolder "site\content\methods"
Create-StubIndexForSection -sections $principles -baseFolder "site\content\principles"
Create-StubIndexForSection -sections $outcomes -baseFolder "site\content\outcomes"
