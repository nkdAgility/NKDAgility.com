---
title: TFS Event Handler Progress
description: Discover the latest progress on the TFS Event Handler project, tackling key work items and exploring WCF error handling solutions. Join the journey!
ResourceId: MY8gn3hmXhh
ResourceType: blog
ResourceImport: true
ResourceImportId: 402
ResourceImportSource: Wordpress
ResourceImportOriginalSource: GeeksWithBlogs
date: 2007-05-07
creator: Martin Hinshelwood
layout: blog
resourceTypes: blog
slug: tfs-event-handler-progress
aliases:
- /blog/tfs-event-handler-progress
- /tfs-event-handler-progress
- /resources/MY8gn3hmXhh
- /resources/blog/tfs-event-handler-progress
aliasesFor404:
- /tfs-event-handler-progress
- /blog/tfs-event-handler-progress
- /resources/blog/tfs-event-handler-progress
tags:
- Technical Excellence
- Continuous Delivery
categories:
- Azure DevOps
preview: metro-binary-vb-128-link-1-1.png

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
