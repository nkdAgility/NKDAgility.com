---
title: Installing Team Explorer 2008 on Windows 7
description: Learn how to install Team Explorer 2008 on Windows 7, troubleshoot common issues, and enhance your development experience with helpful tips and tools.
ResourceId: eriIolF997p
ResourceType: blog
ResourceImport: true
ResourceImportId: 145
ResourceImportSource: Wordpress
ResourceImportOriginalSource: GeeksWithBlogs
date: 2009-01-13
creator: Martin Hinshelwood
layout: blog
resourceTypes: blog
slug: installing-team-explorer-2008-on-windows-7
aliases:
- /blog/installing-team-explorer-2008-on-windows-7
- /installing-team-explorer-2008-on-windows-7
- /resources/eriIolF997p
- /resources/blog/installing-team-explorer-2008-on-windows-7
aliasesArchive:
- /blog/installing-team-explorer-2008-on-windows-7
- /installing-team-explorer-2008-on-windows-7
- /resources/blog/installing-team-explorer-2008-on-windows-7
aliasesFor404:
- /installing-team-explorer-2008-on-windows-7
- /blog/installing-team-explorer-2008-on-windows-7
- /resources/blog/installing-team-explorer-2008-on-windows-7
tags:
- Windows
- Install and Configuration
- Troubleshooting
- System Configuration
categories: []

---
I was a little lazy last time and did not install either Team Explorer, or SP1 on my visual studio instance. So, lets get to it…

[![Installing Team Explorer 2008 on Windows 7](images/InstallingTeamExplorerandVisualStudio200_E718-image_thumb-7-7.png)](http://blog.hinshelwood.com/files/2011/05/GWB-WindowsLiveWriter-InstallingTeamExplorerandVisualStudio200_E718-image_2.png)
{ .post-img }

Everything fine with the Team Explorer install so far, but I have seen other people with this working as well. The fun seams to start when you get SP1 out of the bag, so we will start by Connecting to [CodePlex](http://www.codeplex.com "CodePlex"), and using [TFS Sticky Buddy](http://codeplex.com/tfsstickybuddy)…

[![Team Explorer 2008 installed sucessfully on Windows 7](images/InstallingTeamExplorerandVisualStudio200_E718-image_thumb_1-1-1.png)](http://blog.hinshelwood.com/files/2011/05/GWB-WindowsLiveWriter-InstallingTeamExplorerandVisualStudio200_E718-image_4.png)
{ .post-img }

Yea baby!

[![Team Explorer Proxy problems](images/InstallingTeamExplorerandVisualStudio200_E718-image_thumb_2-2-2.png)](http://blog.hinshelwood.com/files/2011/05/GWB-WindowsLiveWriter-InstallingTeamExplorerandVisualStudio200_E718-image_6.png)
{ .post-img }

Well it looks like I have been hampered by my proxy server at work… no way round that one… I can get web pages, but application can’t connect…

[![Connected to Codeplex](images/InstallingTeamExplorerandVisualStudio200_E718-image_thumb_3-3-3.png)](http://blog.hinshelwood.com/files/2011/05/GWB-WindowsLiveWriter-InstallingTeamExplorerandVisualStudio200_E718-image_8.png)
{ .post-img }

And, not a proxy issue after all, but a firewall issue! Still can’t get the “Send Feedback” to sign in… now that is probably a proxy/websence issue…

[![Failed to connect to Source Control](images/InstallingTeamExplorerandVisualStudio200_E718-image_thumb_4-4-4.png)](http://blog.hinshelwood.com/files/2011/05/GWB-WindowsLiveWriter-InstallingTeamExplorerandVisualStudio200_E718-image_10.png)
{ .post-img }

This is a new one on me, and I needed to threaten Visual Studio with the “End Task” button to get it to respond… Maybe I need SP1 on Windows 7?

Tune in next time for some SP1 antics…

P.S. [TFS Sticky Buddy](http://codeplex.com/tfsstickybuddy) works, but I think I am going to need a blue theme…

[![TFS Sticky Buddy on Windows 7](images/InstallingTeamExplorerandVisualStudio200_E718-image_thumb_5-5-5.png)](http://blog.hinshelwood.com/files/2011/05/GWB-WindowsLiveWriter-InstallingTeamExplorerandVisualStudio200_E718-image_12.png)
{ .post-img }

Ewww, and check out that nasty logo…

[![image](images/InstallingTeamExplorerandVisualStudio200_E718-image_thumb_6-6-6.png)](http://blog.hinshelwood.com/files/2011/05/GWB-WindowsLiveWriter-InstallingTeamExplorerandVisualStudio200_E718-image_14.png)
{ .post-img }

Technorati Tags: [ALM](http://technorati.com/tags/ALM) [Personal](http://technorati.com/tags/Personal) [Windows](http://technorati.com/tags/Windows) [TFS](http://technorati.com/tags/TFS)
