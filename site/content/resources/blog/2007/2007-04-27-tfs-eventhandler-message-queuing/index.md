---
id: "411"
title: "TFS EventHandler: Message Queuing"
date: "2007-04-27"
tags: 
  - "tfs-event-handler"
  - "wit"
coverImage: "nakedalm-logo-128-link-1-1.png"
author: "MrHinsh"
type: blog
slug: "tfs-eventhandler-message-queuing"
---

As I mentioned in my previous post I am currently building an [EventHandler](http://blog.hinshelwood.com/archive/2007/04/27/Team-Server-Event-Handlers-made-easy.aspx) infrastructure for [Team Foundation Server](http://msdn2.microsoft.com/en-us/teamsystem/aa718934.aspx "Team Foundation Server").

I am currently toying with the idea of re-engineering to two system services. The first that handles the [Team Foundation Server](http://msdn2.microsoft.com/en-us/teamsystem/aa718934.aspx "Team Foundation Server") events and puts them onto an event specific message queue and another that handles the reading the messages and action all the event handlers. The reason that I am thinking this way is that when a new EventHandler is added I will need to unload any existing Assemblies and then load them again, and any events that occur during this interval would be lost otherwise.

This can be easily achievable in .NET 3.0 and will not require much work to implement...

Technorati Tags: [WIT](http://technorati.com/tags/WIT) [Windows](http://technorati.com/tags/Windows)



