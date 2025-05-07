---
title: 'Mastering Azure DevOps Migration: A Step-by-Step Guide for Seamless Project Transfers'
description: Learn how to migrate Azure DevOps projects step by step, including tool setup, configuration, handling common issues, and ensuring a smooth transfer of work items.
date: 2023-11-16T12:47:09Z
weight: 1000
ResourceId: Qt1Ywu_KLrc
ResourceType: videos
ResourceContentOrigin: AI
ResourceImport: true
ResourceImportSource: Youtube
videoId: Qt1Ywu_KLrc
url: /resources/videos/:slug
slug: mastering-azure-devops-migration-a-step-by-step-guide-for-seamless-project-transfers
layout: video
aliases:
- /resources/Qt1Ywu_KLrc
- /resources/videos/mastering-azure-devops-migration-a-step-by-step-guide-for-seamless-project-transfers
- /resources/videos/basic-work-item-migration-with-the-azure-devops-migration-tools
aliasesArchive:
- /resources/videos/mastering-azure-devops-migration-a-step-by-step-guide-for-seamless-project-transfers
- /resources/videos/basic-work-item-migration-with-the-azure-devops-migration-tools
- /resources/basic-work-item-migration-with-the-azure-devops-migration-tools
- mastering-azure-devops-migration-a-step-by-step-guide-for-seamless-project-transfers
preview: https://i.ytimg.com/vi/Qt1Ywu_KLrc/maxresdefault.jpg
duration: 2020
isShort: false
tags:
- Azure DevOps
- Install and Configuration
- Software Development
sitemap:
  filename: sitemap.xml
  priority: 0.6
source: youtube
resourceTypes:
- video
categories:
- Uncategorized
Watermarks:
  description: 2025-05-07T13:07:46Z

---
When it comes to migrating projects within Azure [DevOps]({{< ref "/categories/devops" >}}), I often find that the process can seem daunting, especially for those who are new to the platform. However, I’m here to share my personal experience and guide you through a straightforward migration using the [Azure DevOps]({{< ref "/tags/azure-devops" >}}) migration tools. I’ll also address some common exceptions and issues that may arise along the way. So, let’s dive in!

### Getting Started with Azure DevOps Migration Tools

The first step in any migration is to ensure you have the right tools installed. You can find the Azure DevOps migration tools on [GitHub]({{< ref "/tags/github" >}}). Here’s how to get started:

- **Visit the GitHub Repository**: Navigate to the Azure DevOps tools repository and locate the latest release on the right-hand side.
- **Installation Options**: If you’re in an environment without internet access, you can download the release file, unzip it, and run the migration from that folder. However, for most users, I recommend using package managers like **Winget** or **Chocolatey** for installation.

For [Windows]({{< ref "/tags/windows" >}}) Server users, Chocolatey is your go-to option, while Winget is perfect for those on Windows 10 or 11. 

### Setting Up the Migration

Once you have the tools installed, it’s time to set up your migration. Here’s a step-by-step guide:

1. **Open a Command Prompt**: Make sure to use a non-admin command prompt to avoid any issues with the path.
2. **Search for Azure DevOps Tools**: Use the command `winget search Azure DevOps` to find the tools and install them using `winget install <tool-id>`.
3. **Initial Configuration**: Run the command `devops migration init` to create a configuration file. This file will be essential for your migration.

### Configuring the Migration File

After generating the configuration file, you’ll need to make a few adjustments:

- **Field Maps**: If you have an older configuration file, remove all field maps as they can complicate the migration process.
- **Node Paths**: Delete any unnecessary node paths and replace them with `null` to simplify your configuration.

Next, you’ll need to specify your source and target projects. Ensure you have both the URL of the collection and the project URL handy. 

### Connecting to Source and Target Projects

When connecting to your source project, you can use the prompt option for ease. For the target project, create a new project (let’s call it `migration target three`) and ensure it uses the same process as the source.

### Adding Required Fields

For the migration to work seamlessly, you’ll need to add a field called **reflected work item ID** to your target project. This field is crucial for tracking the relationship between work items in the source and target environments.

### Running the Migration

With everything set up, it’s time to execute the migration:

- Use the command `devops migration execute -C <config-file-path>` to start the migration process.
- If you encounter an error stating that the processor is disabled, simply change `processor enabled` to `true` in your configuration file.

### Handling Common Issues

During the migration, you may run into a few common issues:

- **Missing Iteration Paths**: If the migration tool identifies missing iteration paths, you’ll need to create a mapping in your configuration file to address this.
- **Work Item Links**: The tool will only fix links from work items to Git repos, not the other way around. Ensure your Git repo names match between source and target to avoid issues.

### Final Thoughts

Migrating work items between Azure DevOps projects doesn’t have to be a complex task. By following these steps and being mindful of common pitfalls, you can ensure a smooth transition. If you find yourself needing additional help, my team at Naked Agility is here to assist you, or we can help you find a consultant who can.

Remember, the key to a successful migration is preparation and attention to detail. Don’t hesitate to reach out for support, and happy migrating!
