---
title: TFS Gotcha (SP1)
description: Step-by-step guide to resolving common installation and repair issues with Team Foundation Server SP1 on data and application tiers, including rollback options.
ResourceId: ZlJuM9fduW9
ResourceType: blog
ResourceContentOrigin: Human
ResourceImport: true
ResourceImportId: 428
ResourceImportSource: Wordpress
ResourceImportOriginalSource: GeeksWithBlogs
date: 2007-03-15
weight: 1000
creator: Martin Hinshelwood
layout: blog
resourceTypes: blog
slug: tfs-gotcha-sp1
aliases:
- /resources/blog/tfs-gotcha-sp1
- /resources/ZlJuM9fduW9
aliasesArchive:
- /blog/tfs-gotcha-sp1
- /tfs-gotcha-sp1
- /tfs-gotcha-(sp1)
- /blog/tfs-gotcha-(sp1)
- /resources/blog/tfs-gotcha-sp1
preview: nakedalm-logo-128-link-1-1.png
categories:
- Uncategorized
tags:
- Install and Configuration
- Troubleshooting
- System Configuration
Watermarks:
  description: 2025-05-13T16:29:09Z
concepts: []

---
If you are out there and you have installed SP1 for Team Foundation Server you probably went through as much pain as I did...

Solution:

1. Install Data Tier as per documentation.
2. Install Application Tier as per documentation.
3. Install SP1 on data Tier.
4. Repair TFS on data tier
5. Install SP1 on application tier.
6. Repair TFS application tier

If at any point you have a problem. You can always uninstall SP1 from both of the tiers and get the system working again. There are a number of solutions out there, including this one, which can fix the problems you have with TFS SP1... None of them worked for me...

Technorati Tags: [ALM](http://technorati.com/tags/ALM)
