---
title: SharePoint 3.0 and MOSS 2007 Service Pack 1 Update
description: Guidance on resolving SharePoint 3.0 and MOSS 2007 Service Pack 1 installation errors, including database version issues and solutions using stsadm commands.
ResourceId: f9uWaQLg8wR
ResourceType: blog
ResourceContentOrigin: Human
ResourceImport: true
ResourceImportId: 272
ResourceImportSource: Wordpress
ResourceImportOriginalSource: GeeksWithBlogs
date: 2007-12-31
weight: 1000
creator: Martin Hinshelwood
layout: blog
resourceTypes: blog
slug: sharepoint-3-0-and-moss-2007-service-pack-1-update
aliases:
- /resources/blog/sharepoint-3.0-and-moss-2007-service-pack-1-update
- /resources/f9uWaQLg8wR
aliasesArchive:
- /blog/sharepoint-3-0-and-moss-2007-service-pack-1-update
- /sharepoint-3-0-and-moss-2007-service-pack-1-update
- /resources/blog/sharepoint-3-0-and-moss-2007-service-pack-1-update
- /resources/blog/sharepoint-3.0-and-moss-2007-service-pack-1-update
tags:
- Troubleshooting
- Install and Configuration
categories:
- Uncategorized
preview: metro-sharepoint-128-link-1-1.png
Watermarks:
  description: 2025-05-13T16:25:10Z
concepts: []

---
I had a number of problems installing [SharePoint 3.0 Service Pack 1](http://blog.hinshelwood.com/archive/2007/12/13/installing-windows-sharepoint-services-3.0-service-pack-1-sp1.aspx) and then [Microsoft Office SharePoint Server 2007 Service Pack 1](http://blog.hinshelwood.com/archive/2007/12/13/installing-the-2007-microsoft-office-servers-service-pack-1-sp1.aspx). In fact, I managed to put my server completely out of action and I have been trying to fix it off and on for a couple of weeks (I have been on holiday). This being my only day in for the rest of this year, I thought I should give it another go, as I did not want the server down for another week...

Well, I found a little called [kb841216](http://support.microsoft.com/kb/841216/en-us) that describes the problem:

> "0x80040E14" or "HTTP 500" error message when you connect to your Windows SharePoint Services Web site after you install a Windows SharePoint Services service pack or a security update

The reason I get the errors is that the content databases are not at the same version as the application files causing an inability for SharePoint to read the database. You can solve this by running a nice little stsadm command:

> cd /d %commonprogramfiles%Microsoft SharedWeb Server Extensions60Bin
>
> stsadm -o upgrade -forceupgrade

This may not fix your problems, but it sure fixed mine....

Now to get the [Virus Protection problems](http://blog.hinshelwood.com/archive/2007/12/13/no-love-between-mcafee-enterprise-and-moss-2007.aspx) solved....

Technorati Tags: [SP 2007](http://technorati.com/tags/SP+2007) [SP 2010](http://technorati.com/tags/SP+2010) [SharePoint](http://technorati.com/tags/SharePoint)
