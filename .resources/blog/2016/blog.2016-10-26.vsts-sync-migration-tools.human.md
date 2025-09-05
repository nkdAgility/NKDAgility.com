---
title: VSTS Sync Migration Tools
short_title: VSTS Sync Migration Tools
description: Open-source tools for migrating work items, test plans, teams, and project structures between TFS and VSTS, supporting consolidation and flexible data transfer.
tldr: VSTS Sync Migration Tools help teams move work items, test plans, and team structures between TFS and VSTS or consolidate projects without migrating code. The tool focuses on essential data like work items and test configurations, with ongoing improvements based on user needs. Development managers can use or contribute to these free tools to streamline migrations and reduce manual setup when moving to VSTS.
date: 2016-10-26
lastmod: 2016-10-26
weight: 840
sitemap:
  filename: sitemap.xml
  priority: 0.1
  changefreq: weekly
ResourceId: UjyqYjINUfp
ResourceImport: false
ResourceType: blog
ResourceContentOrigin: Human
slug: vsts-sync-migration-tools
aliases:
  - /resources/UjyqYjINUfp
aliasesArchive:
  - /blog/vsts-sync-migration-tools
  - /vsts-sync-migration-tools
  - /resources/blog/vsts-sync-migration-tools
layout: blog
concepts:
  - Tool
categories:
  - Uncategorized
tags: []
Watermarks:
  description: 2025-05-07T13:16:41Z
  short_title: 2025-07-07T17:58:57Z
  tldr: 2025-08-07T13:24:10Z
ResourceImportId: 11634
creator: Martin Hinshelwood
resourceTypes: blog
preview: image_thumb-1-1.png

---
I have been working with a number of customers in the last year that want to move to VSTS. While many of them want to do the full Collection import, many do not.

[![image](images/image_thumb-1-1.png "image")](https://nkdagility.com/wp-content/uploads/2016/10/image.png)
{ .post-img }

Maybe they have too many Team Projects and they want to consolidate, maybe they just have too much baggage. Whatever the reason I needed to be able to push data around between TFS and VSTS… or even TFS to TFS. That is when the [VSTS Sync Migration tools](https://marketplace.visualstudio.com/items?itemName=nkdagility.vsts-sync-migration) were born.

I initially had but a single goal of migrating work items, but since then it has broadened out to include many different types of data:

- **Work Items** - I only ever worry about the Tip of Work Item tracking. Apart from the History (comments) field which I do migrate there is really no long term value in it aside from reporting. Since most migration tool mess up the dates the reporting value disappears as does the value in the history.
  Note: I do have some ideas around this and the new API capabilities since TFS 2012 should allow a higher fidelity of data migration, however I have not yet been unable to talk a customer out of History, and thus I have not had the need to build. So if you want to migrate with history and have the budget…
- **Test Plans & Suits** - The Test data is a lot trickier, but I managed to get Configurations, Variables, as well as Plans and Suits migrated. There are still some bugs but its way better than having to go make everything from scratch.
  Note: Test Runs are not currently migrated but I have been noodling on that problem. Again, once someone is desperate enough to give me a reason to go dive in…
- **Teams** \- Really simple, just the team names, but there is scope for a lot more.
- Area & Iteration Paths - Simply replicated the existing layout. I would love to have all of the Team Meta data but again, time…

Since most teams migrate from TFVC to Git in TFS I was not interested in migrating code. There are some really good solutions for that already with Git-TF and Git-TFS being the best. I wanted the tools to be free as well, so while I always work in VSTS I publish the code and releases out to [GitHub]({{< ref "/tags/github" >}}) so others can participate.

You are welcome to Fork the repository on GitHub and I will happily accept pull requests, but know that my MASTER is in VSTS and not GitHub along with the entire automated build and release system. I release to [NuGet](https://www.nuget.org/packages/VSTS.DataBulkEditor.Engine/), [Chocolatey](https://chocolatey.org/packages/vsts-sync-migrator), [GitHub](https://github.com/nkdAgility/vsts-sync-migration), and the [VSTS Marketplace](https://marketplace.visualstudio.com/items?itemName=nkdagility.vsts-sync-migration).

Let me know what you think of the tools…
