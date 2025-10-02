---
title: TFS Gotcha (server name)
description: Explains how to fix TFS installation issues caused by server name and proxy settings by editing the hosts file and renaming the server to its fully qualified domain name.
date: 2007-03-19
lastmod: 2007-03-19
weight: 1000
sitemap:
  filename: sitemap.xml
  priority: 0.1
  changefreq: weekly
ItemId: l7s81fXVkty
ItemType: blog
ItemKind: resource
ItemContentOrigin: Human
slug: tfs-gotcha-server-name
aliases:
  - /resources/l7s81fXVkty
aliasesArchive:
  - /blog/tfs-gotcha-server-name
  - /tfs-gotcha-server-name
  - /tfs-gotcha-(server-name)
  - /blog/tfs-gotcha-(server-name)
  - /resources/blog/tfs-gotcha-server-name
layout: blog
concepts: []
categories:
  - Uncategorized
tags:
  - Troubleshooting
  - Install and Configuration
  - Windows
  - System Configuration
Watermarks:
  description: 2025-05-13T16:29:06Z
ResourceId: l7s81fXVkty
ResourceType: blog
ResourceImportId: 427
creator: Martin Hinshelwood
resourceTypes: blog
preview: nakedalm-logo-128-link-1-1.png

---
If you are installing TFS in a large network that utilises proxy servers, especialy those that strip network credentials for what it thinks are internet sites, then you may run into problems..

The instalation program always uses the netbios name of you server. But in my enviroment navigating to thsi in a browser produces a DNS error even on the local machiene.

To solve this problem and actualy get an install, you will need to add:

> 127.0.0.1       \[servername\]

To the local hosts file, which you can find at:

> c:windowssystem32driversetchost

This will solve the problem on teh local box, but your users will still be unable to access TFS. You require to rename teh server using the instructions: [How to: Rename an Application-Tier Server](<http://msdn2.microsoft.com/en-us/library/ms252469(VS.80).aspx> "Rename an Application-Tier Server") but make sure that you do not actualy rename the physical box.

You will probably need to rename the server to your fully qualified domain name.

You will probably need to rename TFS to the fully qualified domain name of your server.

Have fun...

Technorati Tags: [ALM](http://technorati.com/tags/ALM)
