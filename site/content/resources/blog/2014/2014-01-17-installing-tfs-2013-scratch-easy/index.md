---
title: Installing TFS 2013 from scratch is easy
description: Step-by-step guide to installing and configuring TFS 2013 using Basic or Standard options, including SQL setup, SharePoint integration, and reporting features overview.
date: 2014-01-17
lastmod: 2014-01-17
weight: 1000
sitemap:
  filename: sitemap.xml
  priority: 0.1
  changefreq: weekly
ResourceId: VfADNDpkNbe
ResourceImport: false
ResourceType: blog
ResourceContentOrigin: Human
slug: installing-tfs-2013-from-scratch-is-easy
aliases:
  - /resources/VfADNDpkNbe
aliasesArchive:
  - /blog/installing-tfs-2013-scratch-easy
  - /installing-tfs-2013-scratch-easy
  - /installing-tfs-2013-from-scratch-is-easy
  - /blog/installing-tfs-2013-from-scratch-is-easy
  - /resources/blog/installing-tfs-2013-scratch-easy
layout: blog
concepts: []
categories:
  - Uncategorized
tags:
  - Install and Configuration
  - System Configuration
Watermarks:
  description: 2025-05-12T14:22:28Z
ResourceImportId: 10332
creator: Martin Hinshelwood
resourceTypes: blog

---
It had been a while since I installed TFS from scratch and I had a few questions from a customer on the subject. So instead of creating yet another installing TFS post I decided to create a couple of videos instead.

In the first video I used the Basic Install option. This installs TFS with SQL Express and is the easiest setup. Instead of having to do a bunch of manual steps you just click and go. Fully configured TFS in no time. On top of that it will even configure SharePoint Foundation 2013 for you (not supported on Server 2012 R2 until SP1.) The only thing that you are missing is Reporting and that is only because SQL Express does not support Reporting Services or Analysis Services. You can however upgrade later if you feel the need easily.

\[youtube=http://www.youtube.com/watch?v=U7wIQk1pus0\]  
Figure: Install & Configure 101 - TFS 2013 Basic Installation

If that's not for you and you like things a little bit more complicated you can install SQL Server first and then use the Standard Single Server install. Here I install SQL Server 2012 with all of the trimmings, Reporting and Analysis Services. I then let TFS do all of the heavy lifting of configuration and setup of all of the features. This results in a full install of TFS with a Cube and Data Warehouse but no SharePoint as it is not supported on Server 2012 R2 until the release of SharePoint 2013 SP1.

\[youtube=http://www.youtube.com/watch?v=U69JMzIZXro\]  
Figure: Install & Configure 101 - TFS 2013 Standard Single Server Install

This should give you some idea on how to install and configure TFS and how easy it is. Managing TFS is mostly, apart from configuring a backup, a leave alone statement. It mostly manages and maintains itself until you get to large database sizes. And by large I mean terabytes :)

How did you get on with your TFS installs?
