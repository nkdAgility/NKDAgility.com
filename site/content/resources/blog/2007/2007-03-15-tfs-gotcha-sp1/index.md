---
title: TFS Gotcha (SP1)
description: Step-by-step guide to resolving common installation and repair issues with Team Foundation Server SP1 on data and application tiers, including rollback options.
date: 2007-03-15
lastmod: 2007-03-15
weight: 1000
sitemap:
  filename: sitemap.xml
  priority: 0.1
  changefreq: weekly
ResourceId: ZlJuM9fduW9
ResourceImport: false
ResourceType: blog
ResourceContentOrigin: Human
slug: tfs-gotcha-sp1
aliases:
  - /resources/ZlJuM9fduW9
aliasesArchive:
  - /blog/tfs-gotcha-sp1
  - /tfs-gotcha-sp1
  - /tfs-gotcha-(sp1)
  - /blog/tfs-gotcha-(sp1)
  - /resources/blog/tfs-gotcha-sp1
layout: blog
concepts: []
categories:
  - Uncategorized
tags:
  - Install and Configuration
  - Troubleshooting
  - System Configuration
Watermarks:
  description: 2025-05-13T16:29:09Z
ResourceImportId: 428
creator: Martin Hinshelwood
resourceTypes: blog
preview: nakedalm-logo-128-link-1-1.png

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
