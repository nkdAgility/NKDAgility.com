---
title: The High of Release
short_title: Microsoft Web-Based Release Management
description: Overview of Microsoft’s new web-based Release Management tools for building flexible, integrated DevOps pipelines in VSTS and TFS, supporting diverse deployment options.
date: 2015-12-05
weight: 480
ResourceId: akntzjbRQe2
ResourceImport: false
ResourceType: blog
ResourceContentOrigin: Human
slug: the-high-of-release
aliases:
- /resources/akntzjbRQe2
aliasesArchive:
- /blog/the-high-of-release
- /the-high-of-release
- /resources/blog/the-high-of-release
layout: blog
concepts:
- Tool
categories:
- DevOps
tags:
- Release Management
- Software Development
Watermarks:
  description: 2025-05-07T13:16:55Z
  short_title: 2025-07-07T17:59:06Z
ResourceImportId: 11398
creator: Martin Hinshelwood
resourceTypes: blog
preview: 2016-01-04_15-52-31-1-1.png

---
Just a week or so ago I was at Microsoft Future Decoded event in London to talk about the new [Release Management]({{< ref "/tags/release-management" >}}) tools that will be made available at [Connect()](https://channel9.msdn.com/Events/Visual-Studio/Connect-event-2015/) and that might make it in to TFS 2015 Update 2. Here is hoping! The focus of the track was on [DevOps]({{< ref "/categories/devops" >}}) and the focus of my session was on both Build and Release.

Microsoft have created a rich set of web based tooling that can allow you to build reliable release pipelines that meet the needs of your teams striving towards [engineering excellence]({{< ref "/categories/engineering-excellence" >}}). My favourite thing about the new tooling is that rather than focus on building full stack tools, they are focusing on orchestration and integration. If you want to use Chef, Puppet, or Docker to physically release your software then that's up to you. If you want to use PowerShell DSC, or just plain old PowerShell, then you can do that as well. And if you just want to build a custom task to deploy your software using PowerShell, ShellScript, or anything else you desire, then you can do that to.

They are getting out of the game of forcing you to use their tachtical toolset while providing a versatile tool to help orchastrate your strategic vision. In short... its awesome! Check out my video below for a full demo...

<iframe width="960" height="540" src="https://channel9.msdn.com/Events/FutureDecoded/Future-Decoded-2015-UK/15/player?format=html5" allowfullscreen="allowfullscreen" frameborder="0"></iframe>

The new Release Management tools are completely web based and allow you to create a professional release pipeline right inside VSTS without the need for any other tools. The new Release Management tools are now in Public Preview on Visual Studio Team Services (VSTS) and you can use them to deploy from your on-premises TFS servers as well.

Many of my larger customers might still be working on being able to put their code in the cloud, but they have no problems with deploying the output of their builds to cloud environments on Azure or elsewhere.

Over the next few months I am hoping to get some local build output deployed to Azure where I can spin up 100 servers to deploy my application for the local testers. I will let you know how I get on...
