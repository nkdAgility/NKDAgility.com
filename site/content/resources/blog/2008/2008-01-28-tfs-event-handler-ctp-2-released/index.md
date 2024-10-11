---
title: TFS Event Handler CTP 2 Released
date: 2008-01-28
creator: Martin Hinshelwood
id: "260"
layout: blog
resourceType: blog
slug: tfs-event-handler-ctp-2-released
aliases:
  - /blog/tfs-event-handler-ctp-2-released
tags:
  - code
  - infrastructure
  - service-oriented-architecture
  - tfs
  - tfs2008
  - tools
  - wit
categories:
  - code-and-complexity
preview: metro-visual-studio-2005-128-link-1-1.png
---

I have just uploaded [CTP 2](http://www.codeplex.com/TFSEventHandler/Release/ProjectReleases.aspx) of the [TFS Event Handler](http://www.codeplex.com/TFSEventHandler).This is a fully functional version of the application and I will be releasing documentation for this in due course, but all configuration of team servers and events is handled through the [TFS](http://msdn2.microsoft.com/en-us/teamsystem/aa718934.aspx "Team Foundation Server") Event Handler Explorer, but all Event Handlers are setup manually.

I have attached two executables:

- **TFSEventHandlerServerSetup** - This file includes the system service as well as the client for running on the same computer.
- **TFSEventHandlerExplorerSetup** - This contains only the Explorer client that can be installed on any computer for managing any TFS Event Handler deployment.
- **v0.2.0 (CTP2)** - All of the source for this version.

You will require Team Explorer 2008 for all variations as well as .NET 3.5

I know that there was a long time between the [Prototype](http://www.codeplex.com/TFSEventHandler/Release/ProjectReleases.aspx?ReleaseId=5057) and [CTP1](http://www.codeplex.com/TFSEventHandler/Release/ProjectReleases.aspx?ReleaseId=3910), but for quite a while I did not have access to a Team Server. Now I am in a big push, but [CTP3](http://www.codeplex.com/TFSEventHandler/Release/ProjectReleases.aspx?ReleaseId=10253) may be a while in coming. There are major changes between [CTP1](http://www.codeplex.com/TFSEventHandler/Release/ProjectReleases.aspx?ReleaseId=3910) and [CTP2](https://www.codeplex.com/Release/ProjectReleases.aspx?ProjectName=TFSEventHandler&ReleaseId=3926), but I will be bug fixing and updating [CTP2](https://www.codeplex.com/Release/ProjectReleases.aspx?ProjectName=TFSEventHandler&ReleaseId=3926) for a while.

Now I have the engine relatively stable I want to concentrate on building some Event Handlers. Over the coming weeks I will be using the latest version in a production environment and testing it to the limits. I am pretty positive that I will find problems, but I would be gratefully for feedback on what I have so far. There were nearly 200 downloads of my prototype version, yet little or know feedback... I don't know if that is because it was rubbish or if it was so good there was no need for feedback or bug reports ![smile_wink](images/smile_wink-2-2.gif). I will assume the latter...
{ .post-img }

You can report [issues](http://www.codeplex.com/TFSEventHandler/WorkItem/List.aspx) and enter into [discussions](http://www.codeplex.com/TFSEventHandler/Thread/List.aspx) on the [CodePlex](http://www.codeplex.com "CodePlex") site for the project.

Technorati Tags: [.NET](http://technorati.com/tags/.NET) [SOA](http://technorati.com/tags/SOA) [ALM](http://technorati.com/tags/ALM) [WIT](http://technorati.com/tags/WIT)

