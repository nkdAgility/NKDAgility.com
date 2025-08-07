---
title: 'Mastering VSTS Sync Migration Tools: Your Ultimate Guide to Seamless TFS to VSTS Transitions'
short_title: VSTS Sync Migration Tools for TFS to VSTS
description: Learn how to use VSTS sync migration tools for flexible, selective TFS to VSTS migrations, including setup, configuration, field mapping, and community support.
tldr: When migrating from TFS to VSTS, use Microsoft's migration service for full database moves, but choose VSTS sync migration tools if you need flexibility to migrate or restructure specific projects. The sync tools allow selective migration, field mapping, and bulk updates, and are supported by a strong community; install them via Chocolatey and always test with a small dataset first. Decide which approach fits your needs, and leverage available documentation and community support for a smooth migration.
date: 2017-12-30T18:57:40Z
lastmod: 2017-12-30T18:57:40Z
weight: 1000
sitemap:
  filename: sitemap.xml
  priority: 0.1
  changefreq: monthly
ResourceId: ZxDktQae10M
ResourceImport: true
ResourceType: videos
ResourceContentOrigin: AI
ResourceImportSource: Youtube
slug: mastering-vsts-sync-migration-tools-your-ultimate-guide-to-seamless-tfs-to-vsts-transitions
aliases:
  - /resources/ZxDktQae10M
aliasesArchive:
  - /resources/videos/-vsts-sync-migration-tools-overview
  - /resources/videos/2018-vsts-sync-migration-tools-overview
  - /resources/2018-vsts-sync-migration-tools-overview
  - /resources/videos/mastering-vsts-sync-migration-tools-your-ultimate-guide-to-seamless-tfs-to-vsts-transitions
  - mastering-vsts-sync-migration-tools-your-ultimate-guide-to-seamless-tfs-to-vsts-transitions
source: youtube
layout: video
concepts:
  - Tool
categories:
  - Uncategorized
tags:
  - Install and Configuration
  - Azure DevOps
Watermarks:
  description: 2025-05-07T13:16:23Z
  short_title: 2025-07-07T17:58:39Z
  tldr: 2025-08-07T13:13:26Z
videoId: ZxDktQae10M
url: /resources/videos/:slug
preview: https://i.ytimg.com/vi/ZxDktQae10M/maxresdefault.jpg
duration: 1977
resourceTypes:
  - video
isShort: false

---
My name is Martin Hinshelwood, and I work for Naked Agility in Scotland, where we specialise in digital transformations, [DevOps]({{< ref "/categories/devops" >}}), and agile methodologies for a variety of clients. Today, I want to share my insights on the VSTS sync migration tools, a topic that has garnered much interest in our community. 

### Understanding Your Migration Options

When it comes to migrating from TFS (Team Foundation Server) to VSTS (Visual Studio Team Services), it’s crucial to know that you have multiple options at your disposal. If your goal is to migrate your entire organisation from TFS to VSTS, the **VSTS migration services** provided by Microsoft should be your primary consideration. This tool offers a full fidelity service, meaning it can import your entire database and collection into VSTS. 

- **Downtime Considerations**: Depending on the size of your collection, you may experience some downtime. For instance, I’ve successfully migrated collections as small as 50 GB in just a couple of hours, while larger collections—like a 2.5 TB one—took around 40 hours. The larger the data, the more complex the migration process becomes, as it involves transferring data to Azure before Microsoft processes it into VSTS.

However, if your needs are more specific—perhaps you only want to migrate a few team projects or restructure your projects—then the VSTS migration service may not meet your requirements. This is where the **VSTS sync migration tools** come into play.

### The VSTS Sync Migration Tools

I created the VSTS sync migration tools to address scenarios where users need more flexibility. These tools allow you to migrate data based on queries, meaning you can selectively choose what to migrate. Here are some key features:

- **Versatile Migration**: You can migrate from TFS to VSTS, VSTS to TFS, split team projects, merge them, or even perform bulk updates. For example, I’ve assisted clients in migrating from the agile template in TFS to the [scrum]({{< ref "/categories/scrum" >}}) template using a bulk update processor.

- **Community Support**: While I primarily support these tools, I’m fortunate to have contributions from various Microsoft MVPs and other TFS/VSTS consultants. This collaborative effort enriches the toolset and provides a wealth of knowledge for users.

### Installation and Usage

To get started with the VSTS sync migration tools, you can find them on the Visual Studio Marketplace. Here’s a quick guide on how to install and run them:

1. **Finding the Tools**: Search for "VSTS migration" and look for the VSTS sync migration tool. You can also find it on the Visual Studio Marketplace, which provides links to documentation and the [GitHub]({{< ref "/tags/github" >}}) repository.

2. **Installation via Chocolatey**: The recommended installation method is through Chocolatey, a package management system for [Windows]({{< ref "/tags/windows" >}}). With over 3,000 downloads, it’s the most common way to install the tools. Simply run the command `choco install VSTS sync migrator` in your PowerShell window.

3. **Running the Tools**: After installation, navigate to the VSTS migration folder and run the executable. The tool will provide you with version information and a session ID, which is useful for [troubleshooting]({{< ref "/tags/troubleshooting" >}}).

### Configuration and Execution

Once you have the tools installed, you’ll need to configure them using a JSON file. This file dictates how the migration will proceed, including which fields to map and how to handle work items. Here are some important points to consider:

- **Field Mapping**: The tools allow for extensive field mapping, enabling you to convert data from one format to another. For instance, you can map states from the old work item to the new work item format.

- **Execution Order**: The order in which you run the migration processes is critical. For example, you must first create the node structures before migrating work items, as the latter relies on the former’s existence.

- **Testing and Validation**: Always test your configuration with a small dataset before executing a full migration. This helps to identify any potential issues without risking your entire dataset.

### Community and Support

The VSTS sync migration tools are supported by a vibrant community. If you encounter any issues, I encourage you to reach out on GitHub. While support is ad-hoc, there are many knowledgeable individuals willing to help.

### Conclusion

In summary, whether you’re looking to perform a full migration or just need to move specific projects, understanding your options is key. The VSTS migration services from Microsoft are excellent for full fidelity migrations, while the VSTS sync migration tools offer the flexibility needed for more tailored scenarios. 

I hope this overview provides you with the insights you need to get started with your migration journey. If you have any questions or need further assistance, don’t hesitate to reach out. Happy migrating!
