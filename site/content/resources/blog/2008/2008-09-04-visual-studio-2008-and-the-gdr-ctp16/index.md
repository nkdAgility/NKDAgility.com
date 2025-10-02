---
title: Visual Studio 2008 and the GDR CTP16
description: Discusses issues with Visual Studio 2008 GDR CTP16 handling complex stored procedure dependencies during database import, and challenges faced when uninstalling the GDR.
date: 2008-09-04
lastmod: 2008-09-04
weight: 1000
sitemap:
  filename: sitemap.xml
  priority: 0.1
  changefreq: weekly
ItemId: BgrdMISXI4W
ItemType: blog
ItemKind: resource
ItemContentOrigin: Human
slug: visual-studio-2008-and-the-gdr-ctp16
aliases:
  - /resources/BgrdMISXI4W
aliasesArchive:
  - /blog/visual-studio-2008-and-the-gdr-ctp16
  - /visual-studio-2008-and-the-gdr-ctp16
  - /resources/blog/visual-studio-2008-and-the-gdr-ctp16
layout: blog
concepts: []
categories:
  - Uncategorized
tags: []
Watermarks:
  description: 2025-05-13T16:23:20Z
ResourceId: BgrdMISXI4W
ResourceType: blog
ResourceImportId: 199
creator: Martin Hinshelwood
resourceTypes: blog
preview: metro-visual-studio-2005-128-link-1-1.png

---
Well we have been having a few problems with the [GDR](http://blogs.msdn.com/gertd/archive/2008/08/20/vstsdb-2008-gdr-ctp16-is-here.aspx). Essentially when we import our database it complains about dependencies.

We have many stored procedures that call stored procedures that call stored procedures! This seams to give the GDR fits. Maybe we are doing something that we are not supposed to, but SQL does not complain.

I tried uninstalling the GDR, but that left me with NO data dude :(

SO I have reinstalled and will try again....

Technorati Tags: [ALM](http://technorati.com/tags/ALM) [VS 2008](http://technorati.com/tags/VS+2008)
