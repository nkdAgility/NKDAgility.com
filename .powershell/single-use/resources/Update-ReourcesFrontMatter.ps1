# Helpers
. ./.powershell/_includes/OpenAI.ps1
. ./.powershell/_includes/HugoHelpers.ps1
. ./.powershell/_includes/ResourceHelpers.ps1

# Iterate through each blog folder and update markdown files
$outputDir = "site\content\resources\blog\2025"

# Get list of directories and select the first 10
$resources = Get-ChildItem -Path $outputDir  -Recurse -Filter "index.md" #| Select-Object -First 10

# Initialize a hash table to track counts of each ResourceType
$resourceTypeCounts = @{}

$resources | ForEach-Object {
    $resourceDir = (Get-Item -Path $_).DirectoryName
    $markdownFile = $_
    Write-Host "--------------------------------------------------------"
    Write-Host "Processing post: $resourceDir"
    if ((Test-Path $markdownFile)) {

        # Load markdown as HugoMarkdown object
        $hugoMarkdown = Get-HugoMarkdown -Path $markdownFile

        #=================CLEAN============================
        Remove-Field -frontMatter $hugoMarkdown.FrontMatter -fieldName 'id'
        #=================description=================
        if (-not $hugoMarkdown.FrontMatter.description -or $hugoMarkdown.FrontMatter.description -match "no specific details provided") {
            # Generate a new description using OpenAI
            $prompt = "Generate a concise, engaging description of no more than 160 characters for the following resource: '$($videoData.snippet.title)'. The Resource details are: '$($hugoMarkdown.BodyContent)'"
            $description = Get-OpenAIResponse -Prompt $prompt
            # Update the description in the front matter
            Update-Field -frontMatter $hugoMarkdown.FrontMatter -fieldName 'description' -fieldValue $description -addAfter 'title' -
        }

        #=================ResourceId=================
        $ResourceId = $null;
        if ($hugoMarkdown.FrontMatter.Contains("ResourceId")) {
            $ResourceId = $hugoMarkdown.FrontMatter.ResourceId
        }
        elseif ($hugoMarkdown.FrontMatter.Contains("videoId")) {
            $ResourceId = $hugoMarkdown.FrontMatter.videoId
        }
        else {
            $ResourceId = New-ResourceId
        }
        Update-Field -frontMatter $hugoMarkdown.FrontMatter -fieldName 'ResourceId' -fieldValue $ResourceId -addAfter 'description'
        #=================ResourceType=================
        $ResourceType = Get-ResourceType  -FilePath  $resourceDir
        Update-Field -frontMatter $hugoMarkdown.FrontMatter -fieldName 'ResourceType' -fieldValue $ResourceType -addAfter 'ResourceId' -Overwrite

        #=================ResourceImport+=================
        if (Test-Path (Join-Path $resourceDir "data.yaml" ) || Test-Path (Join-Path $resourceDir "data.json" )) {
            $ResourceImport = $true
        }
        Update-Field -frontMatter $hugoMarkdown.FrontMatter -fieldName 'ResourceImport' -fieldValue $ResourceImport -addAfter 'ResourceId' -Overwrite
        if ($hugoMarkdown.FrontMatter.ResourceImport) {
            switch ($ResourceType) {
                "blog" { 
                    Update-Field -frontMatter $hugoMarkdown.FrontMatter -fieldName 'ResourceImportSource' -fieldValue "Wordpress" -addAfter 'ResourceImport'
                    If (([datetime]$hugoMarkdown.FrontMatter.date) -lt ([datetime]'2011-02-16')) {
                        Update-Field -frontMatter $hugoMarkdown.FrontMatter -fieldName 'ResourceImportOriginalSource' -fieldValue "GeeksWithBlogs" -addAfter 'ResourceImportSource' -Overwrite
                    }
                    else {
                        Update-Field -frontMatter $hugoMarkdown.FrontMatter -fieldName 'ResourceImportOriginalSource' -fieldValue "Wordpress" -addAfter 'ResourceImportSource' -Overwrite
                    }     
                }
                "videos" { 
                    
                }
            }
        }
        else {
            Remove-Field -frontMatter $hugoMarkdown.FrontMatter -fieldName 'ResourceImportSource'
            Remove-Field -frontMatter $hugoMarkdown.FrontMatter -fieldName 'ResourceImportOriginalSource'
        }
        # =================Add aliases===================
        $aliases = @()
        switch ($ResourceType) {
            "blog" { 
            }
            "podcast" { 
            }
            "videos" { 
            }
        }
        # Always add the ResourceId as an alias
        if ($hugoMarkdown.FrontMatter.Contains("ResourceId")) {
            $aliases += "/resources/$($hugoMarkdown.FrontMatter.ResourceId)"
        }
        Update-StringList -frontMatter $hugoMarkdown.FrontMatter -fieldName 'aliases' -values $aliases -addAfter 'slug'
        # =================Add 404 aliases===================
        $404aliases = @()
        $404aliases += $hugoMarkdown.FrontMatter.aliases | Where-Object { $_ -notmatch $hugoMarkdown.FrontMatter.ResourceId }
        switch ($ResourceType) {
            "blog" { 
                if ($hugoMarkdown.FrontMatter.Contains("slug")) {
                    $slug = $hugoMarkdown.FrontMatter.slug
                    $404aliases += "/$slug"
                    $404aliases += "/blog/$slug"
                }
                if ($hugoMarkdown.FrontMatter.Contains("title")) {
                    $slug = $hugoMarkdown.FrontMatter.slug
                    $urlSafeTitle = ($hugoMarkdown.FrontMatter.title -replace '[:\/\\*?"<>|#%.!,]', '-' -replace '\s+', '-').ToLower()
                    if ($urlSafeTitle -ne $slug) {
                        $404aliases += "/$urlSafeTitle"
                        $404aliases += "/blog/$urlSafeTitle"
                    }           
                }
            }
            "podcast" { 
                
            }
            "videos" { 
                
            }
            default { 
                
            }
        }
        if ($404aliases -is [array] -and $404aliases.Count -gt 0) {
            Update-StringList -frontMatter $hugoMarkdown.FrontMatter -fieldName 'aliasesFor404' -values $404aliases -addAfter 'aliases'
        }

        #================Catsagories==========================
        $CatalogCategories = @{
            "Organisational Agility"           = "The ability of an organisation to rapidly adapt to market changes, customer needs, and emerging opportunities."
            "Application Lifecycle Management" = "Managing the development, maintenance, and governance of software applications throughout their lifecycle."
            "Azure DevOps"                     = "A set of development tools and services by Microsoft for CI/CD, collaboration, and agile project management."
            "Code and Complexity"              = "Discussions around software code quality, complexity management, and best practices in development."
            "Complexity Thinking"              = "An approach to understanding and managing organisations, systems, and uncertainty using complexity science, emergence, and nonlinear dynamics."
            "Decision Theory"                  = "Decision-making in uncertain environments using heuristics, probability, and behavioural economics."
            "Value Delivery"                   = "Strategies for iterative and continuous value delivery to customers."
            "DevOps"                           = "The integration of engineering, operations, and security practices to enable continuous delivery of value."
            "Discovery and Learning"           = "Exploring new ideas, innovation, and continuous learning in product and software development."
            "Events and Presentations"         = "Talks, conferences, webinars, and presentations related to Agile, DevOps, and software engineering."
            "Install and Configuration"        = "Guides and discussions around setting up, installing, and configuring tools, software, and platforms."
            "Kanban"                           = "A strategy for making work observable, managing flow, and continuously improving value delivery."
            "Lean"                             = "A strategy focused on maximising value while minimising waste, originating from the Toyota Production System."
            "Metrics and Learning"             = "Using data, metrics, and feedback to drive continuous improvement in teams and processes."
            "News and Reviews"                 = "Industry news, updates, and reviews of tools, books, and trends in Agile, DevOps, and technology."
            "Resilience and Change"            = "Strategies for organisational resilience and adaptive change."
            "Organisational Psychology"        = "Understanding motivation, engagement, leadership, and team dynamics."
            "People and Process"               = "The intersection of human factors and structured processes in technology and product development."
            "Scaling Agility"                  = "Building unique scaling approaches with a focus on LeSS, Nexus, and custom scaling strategies."
            "Market Adaptability"              = "Enhancing an organisation’s ability to respond to market shifts and competitive pressures."
            "Products and Books"               = "Reviews and discussions about books, tools, and software products related to Agile and DevOps."
            "Scrum"                            = "A social technology for iterative and adaptive value delivery in complex environments."
            "Systems Thinking"                 = "A holistic approach to problem-solving and decision-making that focuses on interdependencies, feedback loops, and systemic behaviour."
            "Flow Efficiency"                  = "Optimising the throughput of work across the value stream to improve speed and reduce bottlenecks."
            "Technical Excellence"             = "Engineering practices that enable agility, including TDD, CI/CD, modular architecture, and emergent design."
            "Practical Techniques and Tooling" = "Exploring different tools, methodologies, and frameworks to improve Agile and DevOps practices."
            "Transparency and Accountability"  = "Fostering openness, responsibility, and alignment in Agile teams."
            "Value Stream Management"          = "A strategic approach to improving the flow of value through an organisation, optimising efficiency, reducing waste, and aligning work with customer outcomes."
            "Sociotechnical Systems"           = "Understanding how technology and organisational structures interact to shape software delivery and team effectiveness."
            "Agile Product Management"         = "Strategies for maximising value through iterative discovery, delivery, and outcome-driven development."
            "Enterprise Agility"               = "Scaling agility beyond teams to drive organisational responsiveness and adaptability."
            "AI and Automation in Agility"     = "Leveraging AI-driven automation to enhance agility, decision-making, and software delivery."
        }          
        $newCatagories = Get-UpdatedCategories -CurrentCategories $hugoMarkdown.FrontMatter.categories -CatalogCategories $CatalogCategories -ResourceContent $hugoMarkdown.BodyContent -ResourceTitle $hugoMarkdown.FrontMatter.title


        # =================COMPLETE===================
        Save-HugoMarkdown -hugoMarkdown $hugoMarkdown -Path $markdownFile
    }
    else {
        Write-Host "Skipping folder: $blogDir (missing index.md)"
    }
    # Track count of ResourceType
    if ($resourceTypeCounts.ContainsKey($ResourceType)) {
        $resourceTypeCounts[$ResourceType]++
    }
    else {
        $resourceTypeCounts[$ResourceType] = 1
    }
}

Write-Host "All markdown files processed."
Write-Host "--------------------------------------------------------"
Write-Host "Summary of updated Resource Types:"
$resourceTypeCounts.GetEnumerator() | ForEach-Object { Write-Host "$($_.Key): $($_.Value)" }