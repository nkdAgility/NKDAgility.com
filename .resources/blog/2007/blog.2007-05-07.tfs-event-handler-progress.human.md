---
title: TFS Event Handler Progress
description: Update on TFS Event Handler project progress, focusing on resolving security issues, improving error handling in WCF services, and finalising the admin system.
ResourceId: MY8gn3hmXhh
ResourceType: blog
ResourceContentOrigin: Human
ResourceImport: true
ResourceImportId: 402
ResourceImportSource: Wordpress
ResourceImportOriginalSource: GeeksWithBlogs
date: 2007-05-07
weight: 840
creator: Martin Hinshelwood
layout: blog
resourceTypes: blog
slug: tfs-event-handler-progress
aliases:
- /resources/MY8gn3hmXhh
aliasesArchive:
- /blog/tfs-event-handler-progress
- /tfs-event-handler-progress
- /resources/blog/tfs-event-handler-progress
tags: []
categories:
- Uncategorized
preview: metro-binary-vb-128-link-1-1.png
Watermarks:
  description: 2025-05-13T16:28:28Z
concepts: []

---
I am making lots of progress with this project and I have only a couple of work items left for CTP1:

- 138 [Security issues on uploaded assemblies](http://www.codeplex.com/TFSEventHandler/WorkItem/View.aspx?WorkItemId=138)
- 203 [Error handling on service](http://www.codeplex.com/TFSEventHandler/WorkItem/View.aspx?WorkItemId=203)
- 204 [Create Admin system as Application](http://www.codeplex.com/TFSEventHandler/WorkItem/View.aspx?WorkItemId=204)

Now [204](http://www.codeplex.com/TFSEventHandler/WorkItem/View.aspx?WorkItemId=204) is nearly complete, with only testing to go and that is dependant on [203](http://www.codeplex.com/TFSEventHandler/WorkItem/View.aspx?WorkItemId=203).

The error handling is an interesting issue as you really have to hand craft exceptions using the FaultException class otherwise your [Windows Communication Foundation](http://wcf.netfx3.com "Windows Communication Foundation") services will enter the dreaded faulted state.

I have been reading up on these FaultException thingies, here is the article I have been reading:

[Willy-Peter Schaub's Cave of Chamomile Simplicity - WCF FaultException … why use it?](http://dotnet.org.za/willy/archive/2006/12/19/WCF-FaultException-_2620_-why-use-it_3F00_.aspx)

This makes for good reading, and although a little scary on the output side, does highlight the problem and the solution!

Technorati Tags: [WIT](http://technorati.com/tags/WIT) [WCF](http://technorati.com/tags/WCF)
