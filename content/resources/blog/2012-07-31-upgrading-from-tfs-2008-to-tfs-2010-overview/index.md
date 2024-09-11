---
id: "6905"
title: "Upgrading from TFS 2008 to TFS 2010 Overview"
date: "2012-07-31"
categories: 
  - "tools-and-techniques"
  - "upgrade-and-maintenance"
tags: 
  - "configuration"
  - "infrastructure"
  - "tfs2005"
  - "tfs2008"
  - "tfs2010"
  - "tfs2012"
  - "tools"
coverImage: "metro-visual-studio-2010-128-link-1-1.png"
author: "MrHinsh"
type: "post"
slug: "upgrading-from-tfs-2008-to-tfs-2010-overview"
---

I have not thought about an upgrade from TFS 2008 to TFS 2010 is quite a while as most if not all of my customers have already made the move to 2010. However one of my colleagues asked if I had done one recently and well… not in a while.

There are really two main parts to any upgrade. The physical upgrade of one version of the product to another. And then the configuration within that product to make everything sing and dance.

The hard part if the singing and dancing so lets tackle the upgrade first.

### #1 Upgrading from TFS 2008 to TFS 2010 / TFS 2012

Although [Brian Harry has an awesome post](http://blogs.msdn.com/b/bharry/archive/2009/10/21/upgrading-from-tfs-2005-2008-to-tfs-2010.aspx) on this I wanted to pull together the experiences that I have had over the years into one place that I can reference.

- [In-Place upgrade of TFS 2008 to TFS 2010 with move to new domain](http://blog.hinshelwood.com/in-place-upgrade-of-tfs-2008-to-tfs-2010-with-move-to-new-domain/)  
    I hate in-place upgrade and you should never do one unless you have to. There is generally no way to back out and a complete rebuild is your disaster plan. Try to use Virtual hardware and snapshots if you have to do an in-place upgrade but insist on moving to new hardware. This has the added benefit of cleaning the server and allows you to upgrade SQL and Windows easily.
- [Upgrading Team Foundation Server 2008 to 2010](http://blog.hinshelwood.com/upgrading-team-foundation-server-2008-to-2010/)  
    This was an upgrade to TFS 2010 Beta 2 in the early days of 2010. I only had one problem even way back then.
- [Upgrading from TFS 2008 and WSS v3.0 with SfTSv2 to TFS 2010 and SF 2010 with SfTSv3](http://blog.hinshelwood.com/upgrading-from-tfs-2008-and-wss-v3-0-with-sftsv2-to-tfs-2010-and-sf-2010-with-sftsv3/)  
    This was probably the largest upgrade I have been responsible for with nearly 500GB of data and servers with 24 cores ![Smile](images/wlEmoticon-smile6-2-2.png). I will get to the process template upgrade woes later…
- [Connecting VS2008 to any TFS2010 Project Collection](http://blog.hinshelwood.com/connecting-vs2008-to-any-tfs2010-project-collection/)  
    In addition your teams may not be upgrading visual studio at the same pace, so make sure you know what they are using other than the latest Visual Studio.

Upgrading from 2005 to 2008 was a very painful experience. So much so that the team at Microsoft spent a lot of time and money on making the experience as slick and easy as possible. TFS 2010 upgrades are a dream and with TFS 2012 I have been speechless at the  smoothness of the upgrade experience.

### #2 Migrating Process Template

Doing something with the Team Projects that you now have in the new version of the product are another matter and a much more complicated one. There are a number of ways to handle this and if you are moving to TFS 2010 then they are all manual:

- [Upgrading from TFS 2008 and WSS v3.0 with SfTSv2 to TFS 2010 and SF 2010 with SfTSv3](http://blog.hinshelwood.com/upgrading-from-tfs-2008-and-wss-v3-0-with-sftsv2-to-tfs-2010-and-sf-2010-with-sftsv3/)  
    Moving from SfTSv2 to SfTSv3 is a very painfully experience and attempt it at your pearl.
- [Upgrading your Process Template in Team Foundation Server](http://blog.hinshelwood.com/do-you-know-how-to-upgrade-a-process-template-but-still-keep-your-data-intact/)  
    I tried to detail as many ways of manipulating the process templates as possible, but I have settled on #7 as my de facto standard!
- [Process Template Upgrade #3 – Destroy all Work Items and Import new ones](http://blog.hinshelwood.com/process-template-upgrade-3-destroy-all-work-items-and-import-new-ones/)  
    This is the cleanest approach but DOES NOT retain any histiory on work item tracking data.
- [Process Template Upgrade #7 – Rename Work Items and Import new ones](http://blog.hinshelwood.com/process-template-upgrade-7-overwrite-retaining-history-with-limited-migration/)  
    #7 is now my recommended norm and includes

My best [documentation of my experience of implementing #7](http://blog.hinshelwood.com/upgrading-tfs-2010-to-tfs-2012-with-vss-migration-and-process-template-consolidation/) was as part of a 2010 to 2012 upgrade, but the process is the same.

In TFS 2012 after the upgrade there is an option on a per-Team Project bases to perform and automatic enablement of the new 2012 features. While this is awesome it does not change the process template hat you are using and instead injects only the bits requires to get the new features working. And it is not available for TFS 2010!

### Conclusion

A TFS 2008 to TFS 2010 upgrade takes no more than a day at the most, but the real hard work is in getting the Process Template to where it is useable for the customer. Take the time here to make and understand the choices.

**How did you get on upgrading TFS 2005/2008 to TFS 2010/2012?**


