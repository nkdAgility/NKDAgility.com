---
title: Team Server Event Handlers made easy...
description: Discover how to easily deploy event handlers for Team Foundation Server with our comprehensive guide. Simplify your coding process and enhance productivity!
ResourceId: NjGpMY3aKfH
ResourceType: blog
ResourceContentOrigin: Human
ResourceImport: true
ResourceImportId: 412
ResourceImportSource: Wordpress
ResourceImportOriginalSource: GeeksWithBlogs
date: 2007-04-27
weight: 855
creator: Martin Hinshelwood
layout: blog
resourceTypes: blog
slug: team-server-event-handlers-made-easy
aliases:
- /blog/team-server-event-handlers-made-easy
- /team-server-event-handlers-made-easy
- /team-server-event-handlers-made-easy---
- /blog/team-server-event-handlers-made-easy---
- /resources/NjGpMY3aKfH
- /resources/blog/team-server-event-handlers-made-easy
aliasesArchive:
- /blog/team-server-event-handlers-made-easy
- /team-server-event-handlers-made-easy
- /team-server-event-handlers-made-easy---
- /blog/team-server-event-handlers-made-easy---
- /resources/blog/team-server-event-handlers-made-easy
categories: []
tags: []
preview: metro-visual-studio-2005-128-link-1-1.png

---
Will, not really...

I work for a rather large organization and I wanted an easy way for power users of team system to deploy event handlers for the [Team Foundation Server](http://msdn2.microsoft.com/en-us/teamsystem/aa718934.aspx "Team Foundation Server") events. Essentially they create an assembly with as many EventHandler classes as they like and they can upload their assembly through an administration system, which in turn executes any handlers that exist on the system for any events.

The Event Handler class format:

> <EventHandler(EventType:=EventTypes.WorkItemChangedEvent, LogEmail:=[someone@company.com](mailto:someone@company.com))>\_
>
> <Logging(Enable:=True, Verbose:=True) \_
>
> Public Class MyEventHandler
>
> Inherits AEventHandler(of WorkItemChangedEvent)
>
> Public Sub Run(TeamServer as TeamFoundation Server, e as EventHandlerArgs(of WorkItemChangedEvent))
>
> ' Run any code for the event
>
> End Sub
>
> Public Sub IsValid(TeamServer as TeamFoundation Server, e as EventHandlerArgs(of WorkItemChangedEvent))
>
> ' Check validity of the event
>
> End Sub
>
> End Class
>
> Public Class EventHandlerArgs(Of TEvent as {ATfsEvent})
>
> ...
>
> ' This is the type of event that is being created as an enumerator
>
> Public Readonly Property EventType as EventTypes
>
> ...
>
> ' This is the actual body of the event as a WorkItemChangedEvent or CheckInEvent etc..
>
> Public Readonly Property \[Event\] as TEvent
>
> ...
>
> ' This holds the URL of the [Team Foundation Server](http://msdn2.microsoft.com/en-us/teamsystem/aa718934.aspx "Team Foundation Server") server that the event originated from
>
> Public Readonly Property Identity as TfsIdentity
>
> ...
>
> ' The subscription info shows information about the subscription options
>
> Public Readonly Property SubscriptionInfo as SubscritpionInfo
>
> ...
>
> Public Sub New(ByVal EventType as EventTypes, ByVal \[Event\] as TEvent, ByVal Identity as TfsIdentity, ByVal SubscriptionInfo as SubscritpionInfo)
>
> ...
>
> End Class

There is then a system that handles all of the events and is subscribed through the Bizsubscribe tool, but that allows a user to administer their own EventHandler's through and admin system (Web, Form or XBAP) through a bunch of web services. There is a lot of code, and not enough room to put it up here, I may start a [CodePlex](http://www.codeplex.com "CodePlex") project. I will be adding the admin system for this to our TeamPlain site and I may set it up to deploy as such. I will also require to create a visual studio project template thingy.

I am afraid I had to code from memory, so any errors or omissions are just my a sign of me getting old, but I hope you get the point and the ease with which you could write and deploy EventHandler's with this.

Technorati Tags: [.NET](http://technorati.com/tags/.NET) [TFS Custom](http://technorati.com/tags/TFS+Custom) [WIT](http://technorati.com/tags/WIT)
