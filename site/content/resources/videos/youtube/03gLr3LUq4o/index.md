---
title: 'Mastering Azure DevOps Migration: A Step-by-Step Guide to Seamless Project Transfers'
description: Master Azure DevOps migration with ease! Discover essential tools, step-by-step guidance, and troubleshooting tips for a seamless project transition.
date: 2023-11-14T15:24:59Z
ResourceId: 03gLr3LUq4o
ResourceType: videos
ResourceImport: true
ResourceImportSource: Youtube
videoId: 03gLr3LUq4o
source: youtube
url: /resources/videos/:slug
slug: basic-work-item-migration
draft: true
aliases:
- /resources/videos/03gLr3LUq4o
- /resources/videos/basic-work-item-migration
- /resources/basic-work-item-migration
- /resources/03gLr3LUq4o
aliasesFor404:
- /resources/videos/basic-work-item-migration
- /resources/basic-work-item-migration
preview: https://i.ytimg.com/vi/03gLr3LUq4o/maxresdefault.jpg
duration: 2001
isShort: false
sitemap:
  filename: sitemap.xml
  priority: 0.6
layout: video
resourceTypes:
- video
tags: []
categories:
- DevOps

---
When it comes to migrating projects within Azure DevOps, I often find that the process can seem daunting at first glance. However, with the right tools and a clear step-by-step approach, it can be a straightforward task. Today, I want to share my personal experience with the Azure DevOps migration tools, guiding you through a simple migration while addressing common issues that may arise along the way.

### Getting Started with Azure DevOps Migration Tools

The first step in any migration is to ensure you have the necessary tools installed. You can find the Azure DevOps migration tools on GitHub. Here’s how to get started:

- **Visit the GitHub Repository**: Navigate to the Azure DevOps tools repository and locate the latest release on the right-hand side. Always opt for the latest version, as it includes the most recent updates and fixes.
- **Installation Options**: If you're in an environment with limited internet access, you can download the release file, unzip it, and run the migration from that folder. However, for most users, I recommend using package managers like **Chocolatey** or **Winget** for a smoother installation process.

### Setting Up Your Environment

Once the tools are installed, it’s time to set up your migration environment. Here’s a quick rundown of the steps:

1. **Open Command Prompt**: Make sure to use a non-admin Command Prompt to avoid any issues with the installation path.
2. **Search for Azure DevOps Tools**: Use the command `winget search Azure DevOps` to find the tools and install them using `winget install <tool-id>`.
3. **Create a Configuration File**: Run the command `DevOps migration init` to generate a default configuration file. This file is crucial as it dictates how your migration will proceed.

### Customising Your Configuration

The default configuration file is a great starting point, but it often requires some tweaks to suit your specific migration needs. Here are a couple of essential adjustments:

- **Field Maps**: If you’re migrating between different processes, you might need to adjust the field maps. However, for a straightforward migration, I recommend removing unnecessary field maps to avoid complications.
- **Skip Final Revised Work Item Type**: Ensure this is set to `false` to prevent any issues during the migration.
- **Node Paths**: If they’re not relevant, simply delete them or set them to `null`.

### Connecting to Source and Target Projects

Next, you’ll need to establish connections to both your source and target projects:

- **Source Project**: You’ll need the URL for both the collection and the project. It’s essential to ensure that you’re only reading from the source, so set the reflected work item ID to `prompt`.
- **Target Project**: Create a new target project and ensure it’s set up with the same process as the source. This consistency is key to a successful migration.

### Running the Migration

With your configuration set, it’s time to execute the migration. Here’s how to do it:

1. **Execute the Migration Command**: Use the command `DevOps migration execute -C C:\temp\<config-file>.json` to start the migration process.
2. **Troubleshooting**: If you encounter an unhandled exception, it’s often due to a misconfiguration. Double-check your project names and ensure that the processor is enabled in your config file.

### Handling Common Issues

During my migrations, I’ve encountered a few common issues that are worth noting:

- **Missing Iteration Paths**: If the migration tool identifies missing iteration paths, you’ll need to create mappings in your configuration file to resolve these discrepancies.
- **Work Item Links**: The tool will only fix links from work items to Git repos, not the other way around. Ensure that your links are correctly set up in the target environment.

### Final Thoughts

Migrating work items between Azure DevOps projects doesn’t have to be a complex process. By following these steps and being mindful of common pitfalls, you can ensure a smooth transition. Remember, the key is in the preparation and configuration of your migration tools.

If you’re looking for more detailed guidance or updates, don’t hesitate to check out the GitHub repository for the Azure DevOps migration tools. Happy migrating!
