---
title: 'TFS EventHandler: Message Queuing'
description: Explains using message queues in Team Foundation Server EventHandler to manage events reliably, ensuring no data loss during handler updates or service changes.
date: 2007-04-27
lastmod: 2007-04-27
weight: 840
sitemap:
  filename: sitemap.xml
  priority: 0.1
  changefreq: weekly
ItemId: SLkPRSid1iJ
ItemType: blog
ItemKind: resource
ItemContentOrigin: Human
slug: tfs-eventhandler-message-queuing
aliases:
  - /resources/SLkPRSid1iJ
aliasesArchive:
  - /blog/tfs-eventhandler-message-queuing
  - /tfs-eventhandler-message-queuing
  - /tfs-eventhandler--message-queuing
  - /blog/tfs-eventhandler--message-queuing
  - /resources/blog/tfs-eventhandler-message-queuing
layout: blog
concepts: []
categories:
  - Uncategorized
tags: []
Watermarks:
  description: 2025-05-13T16:28:41Z
ResourceId: SLkPRSid1iJ
ResourceType: blog
ResourceImportId: 411
creator: Martin Hinshelwood
resourceTypes: blog
preview: nakedalm-logo-128-link-1-1.png

---
As I mentioned in my previous post I am currently building an [EventHandler](http://blog.hinshelwood.com/archive/2007/04/27/Team-Server-Event-Handlers-made-easy.aspx) infrastructure for [Team Foundation Server](http://msdn2.microsoft.com/en-us/teamsystem/aa718934.aspx "Team Foundation Server").

I am currently toying with the idea of re-engineering to two system services. The first that handles the [Team Foundation Server](http://msdn2.microsoft.com/en-us/teamsystem/aa718934.aspx "Team Foundation Server") events and puts them onto an event specific message queue and another that handles the reading the messages and action all the event handlers. The reason that I am thinking this way is that when a new EventHandler is added I will need to unload any existing Assemblies and then load them again, and any events that occur during this interval would be lost otherwise.

This can be easily achievable in .NET 3.0 and will not require much work to implement...

Technorati Tags: [WIT](http://technorati.com/tags/WIT) [Windows](http://technorati.com/tags/Windows)
