---
title: "TFS Event Handler: CTP 1 Delayed"
description: "Discover the delays in the TFS Event Handler CTP 1 and explore enhancements made to improve functionality. Stay updated on development progress!"
date: 2007-06-17
creator: Martin Hinshelwood
id: "381"
layout: blog
resourceTypes: blog
slug: tfs-event-handler-ctp-1-delayed
aliases:
  - /blog/tfs-event-handler-ctp-1-delayed
tags:
  - tfs-event-handler
  - wit
categories:
  - me
preview: nakedalm-logo-128-link-1-1.png
---

Due to a number of reasons:

- My wife is due to give birth this week some time
- I only have access to [TFS](http://msdn2.microsoft.com/en-us/teamsystem/aa718934.aspx "Team Foundation Server") at work, and my development time has been cut down.
- I'm lazy...

The first CTP of the Team Foundation Server Event Handler has been delayed. I have, however made a number of enhancements of the surrounding framework that will allow the smother function of this and other releases.

Currently I have completed:

- [RDdotNet](http://www.rddotnet.com "RDdotNet - Reality Dysfunction .NET") Server Factory - this set of classes and interfaces allows the management, connection and creation of multiple services (both local and remote) even if they are in multiple physical locations.
- [RDdotNet](http://www.rddotnet.com "RDdotNet - Reality Dysfunction .NET") TFS Event Handler Queuer - this architecture captures all of the events from a particular team server and feeds those events onto a MSMQ [Windows Communication Foundation](http://wcf.netfx3.com "Windows Communication Foundation") service that enables the processing service to be restarted without loosing any events.
- [RDdotNet](http://www.rddotnet.com "RDdotNet - Reality Dysfunction .NET") TFS Event Manager - this is a tree based structure for managing your servers and uploaded event handlers.
- [RDdotNet](http://www.rddotnet.com "RDdotNet - Reality Dysfunction .NET") Services Framework - a quick method of creating [Windows Communication Foundation](http://wcf.netfx3.com "Windows Communication Foundation") services that does most of the work for you. This in purely for programmatic implementations as, obviously, the config route is the easiest, but does not fit every bill!

What I have not yet completed:

- Getting it all working together :)
- An effective way of managing the TFS Subscriptions
- Testing and debugging the whole thing.

I do have an implementation of the event handler idea that requires hard coded implementation of assemblies. This works, but has no redundancy and is not robust. I have been using it for a couple of months with no problems. I will try to package this up for you guys when I get a moment - unless I have to rush to the hospital, in which case, tough!

_note:_

_If I get into work tomorrow I will try my best to upload the installer for the current Alfa version. It is slightly configurable with Event Handlers listed in a config file. Not what I am trying to achieve and you have to restart the service manually when you add a event handler. Oh, and this MUST be installed on the team server and you need to enter a TFS Server Administrator password into the config file. I will call this the "TFS Rubbishy manual Event Handler", and it **will** need some installation instructions..._

Technorati Tags: [Personal](http://technorati.com/tags/Personal) [WIT](http://technorati.com/tags/WIT)
