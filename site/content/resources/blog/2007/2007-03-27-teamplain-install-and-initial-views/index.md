---
title: TeamPlain - Install and initial views
description: Covers installing TeamPlain, initial setup experience, project name display issues, and early observations on user access control and web-based project management features.
date: 2007-03-27
lastmod: 2007-03-27
weight: 1000
sitemap:
  filename: sitemap.xml
  priority: 0.1
  changefreq: weekly
ItemId: SlsFZ5kO1Jc
ItemType: blog
ItemKind: resource
ItemContentOrigin: Human
slug: teamplain-install-and-initial-views
aliases:
  - /resources/SlsFZ5kO1Jc
aliasesArchive:
  - /blog/teamplain-install-and-initial-views
  - /teamplain-install-and-initial-views
  - /teamplain---install-and-initial-views
  - /blog/teamplain---install-and-initial-views
  - /resources/blog/teamplain-install-and-initial-views
layout: blog
concepts: []
categories:
  - Uncategorized
tags: []
Watermarks:
  description: 2025-05-13T16:28:56Z
ResourceId: SlsFZ5kO1Jc
ResourceType: blog
ResourceImportId: 421
creator: Martin Hinshelwood
resourceTypes: blog
preview: metro-visual-studio-2005-128-link-1-1.png

---
Well, I got TeamPlain installed in about 30 seconds on my dev servers. In fact, it went so well that after about 10 minutes of messing around with it, I installed it in production as well.

This is a fantastic piece of web work, it has all of the features that you could want from web access. The only problem I have encountered is that My project names are quite long! "XXEMEA-UK-Area-Dept-BusinessUnit-\[Project Name\]" and this does not display in the project drop down list provided, it cuts off around "XXEMEA-UK-Area-Dept-BusinessUn.." so you have to guess on the project it is referring to! I will probably have to rename the projects, no mean feet, to remove at least "XXEMEA-UK-" to make this usable, but at least my users will stop complaining about VS2005.![](images/r_teamddl.JPG)
{ .post-img }

I am still trying to work out how you control access to projects! Even though users have no permissions for a particular project: I am thinking that removing "Team Foundation Valid Users" from the project will work, I just have not had time to test it...

Technorati Tags: [ALM](http://technorati.com/tags/ALM) [VS 2005](http://technorati.com/tags/VS+2005)
