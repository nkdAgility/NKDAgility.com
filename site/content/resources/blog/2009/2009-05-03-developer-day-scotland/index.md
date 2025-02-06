---
title: Developer Day Scotland
description: Join Developer Day Scotland for insights on refactoring, dynamic languages, and MVVM in WPF. Enhance your coding skills and connect with fellow developers!
ResourceId: qtc58tBJRtL
ResourceType: blog
ResourceImport: true
ResourceImportId: 125
ResourceImportSource: Wordpress
ResourceImportOriginalSource: GeeksWithBlogs
date: 2009-05-03
creator: Martin Hinshelwood
id: "125"
layout: blog
resourceTypes: blog
slug: developer-day-scotland
aliases:
- /blog/developer-day-scotland
- /developer-day-scotland
- /resources/qtc58tBJRtL
- /resources/blog/developer-day-scotland
aliasesFor404:
- /developer-day-scotland
- /blog/developer-day-scotland
- /resources/blog/developer-day-scotland
tags:
- code
- events-and-presentations
- mvvm
- wpf
categories:
- code-and-complexity
- events-and-presentations
- me
preview: metro-event-128-link-1-1.png

---
The [Developer Developer Developer](http://developerdayscotland.com) event held at [Glasgow Caledonian University](http://www.gcal.ac.uk/) (my University) yesterday was excellent. Kudos to [Colin Angus Mackay](http://blog.colinmackay.net/) and the other organisers for all of the effort they have put in once again.

**Everything you wanted to know about refactoring but were afraid to ask!**

I attended [Gary Short](http://www.garyshort.org)'s session on refactoring and found pretty much everything he had to say had merit. This session was more about the mechanics of refactoring than the theory, but the theory he did cover was very useful. I especially liked is analogy about code debt. Those things that you just do quickly or in a less than optimal way incur a kind of code debt that you have to pay back at some point otherwise your software will be to waited down to maintain properly.

I only wish that some of my companies developers and especially the IT management had attended. I for one will be taking away that refactoring necessary to part of your iterations. Having a full iteration for refactoring every few iterations may seam like a lot, but it allows you to pay back that debt in manageable chunks.

**Embracing a new world - Dynamic languages and .NET**

[Ben Hall](http://blog.benhall.me.uk/)'s session on dynamic languages was very interesting even though he did get heckled by Gary after having a dig about Gary's “[IronSmalltalk](http://garyshortblog.wordpress.com/2009/03/11/microblogging-for-march-10-2009/)” project...

Ben talked about IronRuby and IronPython, both built by Microsoft on top of the new DLR ([Dynamic Language Runtime](http://www.codeplex.com/dlr)) that allows dynamic languages to be built on top of .NET easily. I for one, being a philistine and liking my comfort zone would like to see IronBasic making an appearance. This is not just for my own benefit, but Ben presented a scenario where you would get a user to enter some code into a textbox and have it executed to provide a grater level of customization to your users without them having to compile an assembly. I feel a [TFS](http://msdn2.microsoft.com/en-us/teamsystem/aa718934.aspx "Team Foundation Server") Check in Policy coming on :) ) This I feel would benefit from a VB style language that business users, familiar with VB for Office Applications and the macros, could more easily interact with. For example a Check in Policy could allow a project manager to create a custom policy on the fly and have it apply across their project without having to compile an assembly and have it distributed to all of the developer computers...

**Make Patterns With Patterns - Introducing the MVVM design pattern for WPF**

The main event for me was **[Ray Booysen](http://vistasquad.co.uk/blogs/nondestructive/)**’s session on [MVVM](http://vistasquad.co.uk/blogs/nondestructive/archive/tags/MVVM/default.aspx). I found his delivery excellent and although there was at least one guy that did not get it, this is the pattern that I have been looking for with WPF. I had been looking at Prism, but this is an MVC WPF implementation and I much prefer the MVVM style, although I think that the Prism framework will support MVVM and it brings dependency injection along with some other mice bits . Ray was compelling and informative and his enthusiasm for this topic pulled most of us in immediately. But, before I can fully commit to MVVM I will need to give it a go, and I have a few ideas…

[Get the slides](http://vistasquad.co.uk/blogs/nondestructive/archive/2009/05/02/demo-code-and-slides-from-ddd-scotland.aspx)

**Grok Talks**

I missed most of the talks, but I got back just in time to see a session about XmlSerilizer verses XamlSerilizer and the sped benefits of using the XamlSerilizer. This was interesting as I had run into some of the same problems myself and opted for the third way which is the WcfSerilizer which provides the benefit over the XamlSerilizer that it can sterilize generic types and over the XmlSerilizer that it can sterilize IDictionary objects as well.

**When good architecture goes bad**

Taking a different approach than Gary's session on code debt [Mark Dalgarno](http://blog.software-acumen.com/) went further and provided an interactive session on architectural atrophy that showed why a long running product can suffer for a kind of Architectural degradation if the architectural team is not strong enough to make sure that the developers do not deviate from the architecture over time. If the developers have an architectural change that is necessary then it should be presented to the architects who take this on board and modify the overall architecture allowing the change to be incorporated more fully into the overall solution. Again a session that my management and team leads should attend. Especially when either of the scenarios used could have applied to them. In fact the whole talk could have been based on my company.

**ASP.NET 4.0**

Although I was in the room, I could not say that I attended this session as I was suffering from a late night and an early rise, and by the time this session started I was starting to drift off. Sorry [Mike](http://mikeo.co.uk/), it was not you, it was me...

Technorati Tags: [Personal](http://technorati.com/tags/Personal) [Software Development](http://technorati.com/tags/Software+Development) [Windows](http://technorati.com/tags/Windows) [WPF](http://technorati.com/tags/WPF) [MVVM](http://technorati.com/tags/MVVM)
