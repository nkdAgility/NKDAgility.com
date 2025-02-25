---
title: TFS Stick Buddy v0.4.0 CTP2 released
description: Discover the latest TFS Stick Buddy v0.4.0 CTP2 release! Customize your work item display and enhance your project management experience. Download now!
ResourceId: G2LTuEadTg9
ResourceType: blog
ResourceImport: true
ResourceImportId: 238
ResourceImportSource: Wordpress
ResourceImportOriginalSource: GeeksWithBlogs
date: 2008-04-17
weight: 1000
creator: Martin Hinshelwood
layout: blog
resourceTypes: blog
slug: tfs-stick-buddy-v0-4-0-ctp2-released
aliases:
- /blog/tfs-stick-buddy-v0-4-0-ctp2-released
- /tfs-stick-buddy-v0-4-0-ctp2-released
- /resources/G2LTuEadTg9
- /resources/blog/tfs-stick-buddy-v0-4-0-ctp2-released
aliasesArchive:
- /blog/tfs-stick-buddy-v0-4-0-ctp2-released
- /tfs-stick-buddy-v0-4-0-ctp2-released
- /resources/blog/tfs-stick-buddy-v0-4-0-ctp2-released
tags:
- Products and Books
- Practical Techniques and Tooling
- News and Reviews
- Frequent Releases
- Windows
- Working Software
- Software Development
categories: []
preview: metro-binary-vb-128-link-1-1.png

---
All to soon and it is that time again...I have been developing, hell bent on getting a [working sticky buddy](http://www.codeplex.com/TFSStickyBuddy) online, and here it is...

[**Download TFS Stick Buddy v0.4.0 CTP2 Now**](http://www.codeplex.com/TFSStickyBuddy/Release/ProjectReleases.aspx)**...**

[![image_thumb23](images/TFSStickBuddyv0.4.0CTP2released_12E38-image_thumb23_thumb-8-8.png)](http://blog.hinshelwood.com/files/2011/05/GWB-WindowsLiveWriter-TFSStickBuddyv0.4.0CTP2released_12E38-image_thumb23_2.png)
{ .post-img }

With this version you can select what work items you want to display by choosing a Query from the list. You can add queries to your list through Visual Studio and the TFS Web Access power tool to allow customisation of the display for your needs and project template types. If you do not have a work item called "Requirement" and instead use one called "Customer Request" then you just need to make a query that pulls this information back.

[![image_thumb24](images/TFSStickBuddyv0.4.0CTP2released_12E38-image_thumb24_thumb-9-9.png)](http://blog.hinshelwood.com/files/2011/05/GWB-WindowsLiveWriter-TFSStickBuddyv0.4.0CTP2released_12E38-image_thumb24_2.png)
{ .post-img }

When you open [TFS Sticky Buddy](http://www.codeplex.com/TFSStickyBuddy) you will be asked to select a Team Server to connect to. If you have a proxy, like I do in the office, you will not be able to connect to an external TFS server through it as your credentials will be wrong... maybe I need a [work item](http://www.codeplex.com/TFSStickyBuddy/WorkItem/List.aspx) for that ![smile_regular](images/smile_regular-2-2.gif)
{ .post-img }

Once you have selected your team server you will need to wait for it to authenticate, but I added a little "loading" window to keep you happy as it may take a little while to authenticate depending on the speed on your network and the load on your TFS server.

When the load it complete you will have access to the menu options, but it will have automatically loaded the first Team Project on your server and the first work item query on your project (which tends to be "Active bugs").

[![image_thumb25](images/TFSStickBuddyv0.4.0CTP2released_12E38-image_thumb25_thumb-10-10.png)](http://blog.hinshelwood.com/files/2011/05/GWB-WindowsLiveWriter-TFSStickBuddyv0.4.0CTP2released_12E38-image_thumb25_2.png)
{ .post-img }

If you have this many bugs, you may need to invest more in quality control...

The application will load all of your Areas and their hierarchy by default and display any work items in your selected query on that Area. You can see that it will display everything on the node and colour code it depending on the state of the work item:

[](/Documents%20and%20Settings/martihins/Application%20Data/Windows%20Live%20Writer/PostSupportingFiles/2ff3b0d5-a59c-458f-bfa4-db62663069a7/image22.png)

- Proposed = Blue [![image_thumb22](images/TFSStickBuddyv0.4.0CTP2released_12E38-image_thumb22_thumb-7-7.png)](http://blog.hinshelwood.com/files/2011/05/GWB-WindowsLiveWriter-TFSStickBuddyv0.4.0CTP2released_12E38-image_thumb22_2.png)
  { .post-img }
- Active = Red [![image_thumb20](images/TFSStickBuddyv0.4.0CTP2released_12E38-image_thumb20_thumb-5-5.png)](http://blog.hinshelwood.com/files/2011/05/GWB-WindowsLiveWriter-TFSStickBuddyv0.4.0CTP2released_12E38-image_thumb20_2.png)
  { .post-img }
- Resolved = Amber [![image_thumb21](images/TFSStickBuddyv0.4.0CTP2released_12E38-image_thumb21_thumb-6-6.png)](http://blog.hinshelwood.com/files/2011/05/GWB-WindowsLiveWriter-TFSStickBuddyv0.4.0CTP2released_12E38-image_thumb21_2.png)
  { .post-img }
- Closed = Green [![image_thumb19](images/TFSStickBuddyv0.4.0CTP2released_12E38-image_thumb19_thumb-4-4.png)](http://blog.hinshelwood.com/files/2011/05/GWB-WindowsLiveWriter-TFSStickBuddyv0.4.0CTP2released_12E38-image_thumb19_2.png)
  { .post-img }

[](/Documents%20and%20Settings/martihins/Application%20Data/Windows%20Live%20Writer/PostSupportingFiles/2ff3b0d5-a59c-458f-bfa4-db62663069a7/image22.png)

I plan to have other options, but I will need to make some changes to the skining files, but you get the picture...

[![image_thumb18](images/TFSStickBuddyv0.4.0CTP2released_12E38-image_thumb18_thumb-3-3.png)](http://blog.hinshelwood.com/files/2011/05/GWB-WindowsLiveWriter-TFSStickBuddyv0.4.0CTP2released_12E38-image_thumb18_2.png)
{ .post-img }

I hope everyone "team servery" has a go, and don't be shy about [reporting bugs](http://www.codeplex.com/TFSStickyBuddy/WorkItem/List.aspx) and [requesting features](http://www.codeplex.com/TFSStickyBuddy/WorkItem/List.aspx).

You can even use the [discussion forums](http://www.codeplex.com/TFSStickyBuddy/Thread/List.aspx)...

[**Download TFS Stick Buddy v0.4.0 CTP2 Now**](http://www.codeplex.com/TFSStickyBuddy/Release/ProjectReleases.aspx)**...**

Technorati Tags: [.NET](http://technorati.com/tags/.NET) [Personal](http://technorati.com/tags/Personal) [ALM](http://technorati.com/tags/ALM) [WPF](http://technorati.com/tags/WPF) [WIT](http://technorati.com/tags/WIT)
