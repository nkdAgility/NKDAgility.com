---
title: It's that time again; get ready to upgrade to TFS 2015
description: Prepare for the TFS 2015 upgrade! Discover essential strategies and tips to ensure a smooth transition before support for TFS 2010 ends. Don't wait!
date: 2015-03-17
creator: Martin Hinshelwood
id: "11241"
layout: blog
resourceTypes: blog
slug: its-that-time-again-get-ready-to-upgrade-to-tfs-2015
aliases:
- /blog/its-that-time-again-get-ready-to-upgrade-to-tfs-2015
- /its-that-time-again-get-ready-to-upgrade-to-tfs-2015
- /it's-that-time-again;-get-ready-to-upgrade-to-tfs-2015
- /blog/it's-that-time-again;-get-ready-to-upgrade-to-tfs-2015
tags:
- tfs
- tfs2005
- tfs2008
- tfs2010
- tfs2012
- tfs-2013
- tfs-2015
- upgrade
categories:
- upgrade-and-maintenance
preview: nakedalm-experts-visual-studio-alm-1-1.png

---
With the release of Team Foundation Server 2015 CTP you should be starting to plan your upgrade strategy. It's going to be a tough one but you should get ready to upgrade to TFS 2015 now.

Mainstream support for TFS 2010 ends on 14/07/2015.

If you have been looking enviously at the new features popping up every three weeks on Visual Studio Online (VSO) then you will be waiting for TFS 2015 with baited breath. Now that the TFS 2015 CTP is available you should start planning for your upgrade. It's early yet, but as there are major changes in the schema for the operational store, it is likely to be a very lengthy upgrade. To get a feel for just how long you should restore your databases to your recovery environment and run a trial upgrade.

Not only will this give you access to all of the new features, but it will give you an idea of how much planning you will need for the real upgrade. Don’t wait until you are sitting staring at the upgrade progress bar for hours to find out. As with the TFS 2010 and TFS 2012 Update 1 upgrade the schema changes will require a complete rebuild of your TFS data and that means lots of spare disk space and time to complete the upgrade. If your database is over 1TB in size then you should seriously consider upgrading over a weekend.

Indeed with [mainstream support for TFS 2010 scheduled to stop in July](http://support.microsoft.com/lifecycle/search?sort=PN&alpha=Microsoft+Visual+Studio+Team+Foundation+Server+2010&Filter=FilterNO) there is no better time to start thinking of upgrading that aging TFS instance. Remember that you don’t need to upgrade Visual Studio, so if you still need to support development in Visual Studio 2005, 2008, or 2010 you can continue to do so. Heck, even FoxPro is still supported through the MSSCCI provider.

If you are on a version of TFS prior to 2010 you are so far out of support that a strait upgrade is no longer possible and you will need to stage through TFS 2012. No

Don’t get caught short with no support for your TFS server! Get ready to upgrade to TFS 2015…
