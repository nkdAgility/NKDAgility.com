$CatalogCategories = @{
    "Organisational Agility"           = "The ability of an organisation to rapidly adapt to market changes, customer needs, and emerging opportunities."
    "Application Lifecycle Management" = "Managing the development, maintenance, and governance of software applications throughout their lifecycle."
    "Azure DevOps"                     = "A set of development tools and services by Microsoft for CI/CD, collaboration, and agile project management."
    "Code and Complexity"              = "Discussions around software code, code quality, code complexity management, and coding best practices in development."
    "Complexity Thinking"              = "An approach to understanding and managing organisations, systems, and uncertainty using complexity science, emergence, and nonlinear dynamics."
    "Decision Theory"                  = "Decision-making in uncertain environments using heuristics, probability, and behavioural economics."
    "Value Delivery"                   = "Strategies for iterative and continuous value delivery to customers."
    "Product Delivery"                 = "The process of delivering usable working software products to customers, including planning, development, testing, and deployment."
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

function Create-MarkdownFiles {
    param (
        [Parameter(Mandatory = $true)]
        [hashtable]$CatalogCategories
    )
    
    # Define the output directory
    $OutputDirectory = "site\content\categories"
    
    # Ensure the directory exists
    if (!(Test-Path -Path $OutputDirectory)) {
        New-Item -ItemType Directory -Path $OutputDirectory | Out-Null
    }
    
    # Loop through each category and create a markdown file
    foreach ($Category in $CatalogCategories.Keys) {
        $Slug = ($Category -replace '\s+', '-' -replace '[^a-zA-Z0-9-]', '').ToLower();
        $markdownFile = "$OutputDirectory/$Slug.md"
    
        if (Test-Path -Path $markdownFile) {
            $hugoMarkdown = Get-HugoMarkdown -Path $markdownFile
        }
        else {
            $FrontMatter = [ordered]@{
                title       = "$Category"
                description = "$($CatalogCategories[$Category])"
            }
            $hugoMarkdown = [HugoMarkdown]::new($FrontMatter, "")
        }
    
        
        # Write the front matter to the file
        Save-HugoMarkdown -hugoMarkdown $hugoMarkdown -Path $markdownFile
        Write-Host "Created or Updated: $markdownFile"
    }
}

#Create-MarkdownFiles $CatalogCategories