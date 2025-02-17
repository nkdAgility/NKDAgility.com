---
title: TFS Sticky Buddy Codeplex project
description: Explore the TFS Sticky Buddy project, a digital whiteboard solution for Team Foundation Server that enhances project visibility and team collaboration.
ResourceId: g0bjuq5cIqX
ResourceType: blog
ResourceImport: true
ResourceImportId: 250
ResourceImportSource: Wordpress
ResourceImportOriginalSource: GeeksWithBlogs
date: 2008-02-05
creator: Martin Hinshelwood
layout: blog
resourceTypes: blog
slug: tfs-sticky-buddy-codeplex-project
aliases:
- /blog/tfs-sticky-buddy-codeplex-project
- /tfs-sticky-buddy-codeplex-project
- /resources/g0bjuq5cIqX
- /resources/blog/tfs-sticky-buddy-codeplex-project
aliasesFor404:
- /tfs-sticky-buddy-codeplex-project
- /blog/tfs-sticky-buddy-codeplex-project
- /resources/blog/tfs-sticky-buddy-codeplex-project
tags:
- Software Development
- Team Collaboration
- Transparency
- Collaboration Tools
- Operational Practices
- Pragmatic Thinking
categories:
- Practical Techniques and Tooling
- Application Lifecycle Management
preview: metro-binary-vb-128-link-1-1.png

---
I hade been looking with envy at the [digital whiteboard experiment](http://www.agilemanagement.net/Articles/Weblog/DigitalWhiteboardExperime.html), and with dismay at the lack of open source for the project. So...

[![DigitalWhiteboardJune2007](images/TFSStickyBuddyCodeplexproject_9FDC-DigitalWhiteboardJune2007_thumb-2-2.png)](http://blog.hinshelwood.com/files/2011/05/GWB-WindowsLiveWriter-TFSStickyBuddyCodeplexproject_9FDC-DigitalWhiteboardJune2007_2.png) I will be creating a version of the [Sticky Buddy idea](http://www.visualbuilder.com/viewdetail.php?group_id=43&id=532&type=1) that will run off Team Foundation Server and allow teams to display information on the status of their development on one or many projects.
{ .post-img }

The application will be able to be displayed on a projector or large TV screen. The application will consist of a main screen that queries a [TFS](http://msdn2.microsoft.com/en-us/teamsystem/aa718934.aspx "Team Foundation Server") Server and pulls a list of projects that the user can select for display and within each project it will display the iteration tree. This tree will be displayed as a set of concentric columns that are populated with "Change Requests" and "Requirements" that are currently within that iteration path.

Each of the Work Items displayed will show limited information about itself, which user it is assigned to, its Area and title. But it will also display the number of sub items within each item. This will give an indication of the length of time necessary to complete all of the sub-work items within that iteration so it can be moved on to the next.

A set of rules will determine the colour or icons associated with each item based on their status. These rules may include:

- Is this item overdue?
- Does this work item have any blocked work items associated with it?
- Does this work item have any risks associated with it?

The resultant Digital Whiteboard will be displayed in our main offices so we will be dogfooding :)

Technorati Tags: [.NET](http://technorati.com/tags/.NET) [Personal](http://technorati.com/tags/Personal) [ALM](http://technorati.com/tags/ALM) [WIT](http://technorati.com/tags/WIT)
