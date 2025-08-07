---
title: It's that time again; get ready to upgrade to TFS 2015
short_title: Upgrade to Team Foundation Server 2015
description: Plan your upgrade to Team Foundation Server 2015 as support for TFS 2010 ends soon. Prepare for major schema changes, lengthy upgrades, and new feature access.
tldr: Mainstream support for TFS 2010 ends in July 2015, so you should start planning your upgrade to TFS 2015 now. The upgrade will be complex and time-consuming due to major schema changes, especially for large databases, so run a trial upgrade in a recovery environment to estimate the effort required. Begin preparations early to avoid downtime and ensure continued support for your development teams.
date: 2015-03-17
lastmod: 2015-03-17
weight: 1000
sitemap:
  filename: sitemap.xml
  priority: 0.1
  changefreq: weekly
ResourceId: 7gr-fTIcGUp
ResourceImport: false
ResourceType: blog
ResourceContentOrigin: Human
slug: it's-that-time-again-get-ready-to-upgrade-to-tfs-2015
aliases:
  - /resources/blog/it-s-that-time-again-get-ready-to-upgrade-to-tfs-2015
  - /resources/7gr-fTIcGUp
aliasesArchive:
  - /blog/its-that-time-again-get-ready-to-upgrade-to-tfs-2015
  - /its-that-time-again-get-ready-to-upgrade-to-tfs-2015
  - /it's-that-time-again;-get-ready-to-upgrade-to-tfs-2015
  - /blog/it's-that-time-again;-get-ready-to-upgrade-to-tfs-2015
  - /resources/blog/its-that-time-again-get-ready-to-upgrade-to-tfs-2015
  - /resources/blog/it-s-that-time-again-get-ready-to-upgrade-to-tfs-2015
layout: blog
concepts: []
categories:
  - Uncategorized
tags: []
Watermarks:
  description: 2025-05-12T14:19:55Z
  tldr: 2025-08-07T13:25:24Z
  short_title: 2025-08-07T13:25:25Z
ResourceImportId: 11241
creator: Martin Hinshelwood
resourceTypes: blog
preview: nakedalm-experts-visual-studio-alm-1-1.png

---
With the release of Team Foundation Server 2015 CTP you should be starting to plan your upgrade strategy. It's going to be a tough one but you should get ready to upgrade to TFS 2015 now.

Mainstream support for TFS 2010 ends on 14/07/2015.

If you have been looking enviously at the new features popping up every three weeks on Visual Studio Online (VSO) then you will be waiting for TFS 2015 with baited breath. Now that the TFS 2015 CTP is available you should start planning for your upgrade. It's early yet, but as there are major changes in the schema for the operational store, it is likely to be a very lengthy upgrade. To get a feel for just how long you should restore your databases to your recovery environment and run a trial upgrade.

Not only will this give you access to all of the new features, but it will give you an idea of how much planning you will need for the real upgrade. Don’t wait until you are sitting staring at the upgrade progress bar for hours to find out. As with the TFS 2010 and TFS 2012 Update 1 upgrade the schema changes will require a complete rebuild of your TFS data and that means lots of spare disk space and time to complete the upgrade. If your database is over 1TB in size then you should seriously consider upgrading over a weekend.

Indeed with [mainstream support for TFS 2010 scheduled to stop in July](http://support.microsoft.com/lifecycle/search?sort=PN&alpha=Microsoft+Visual+Studio+Team+Foundation+Server+2010&Filter=FilterNO) there is no better time to start thinking of upgrading that aging TFS instance. Remember that you don’t need to upgrade Visual Studio, so if you still need to support development in Visual Studio 2005, 2008, or 2010 you can continue to do so. Heck, even FoxPro is still supported through the MSSCCI provider.

If you are on a version of TFS prior to 2010 you are so far out of support that a strait upgrade is no longer possible and you will need to stage through TFS 2012. No

Don’t get caught short with no support for your TFS server! Get ready to upgrade to TFS 2015…
