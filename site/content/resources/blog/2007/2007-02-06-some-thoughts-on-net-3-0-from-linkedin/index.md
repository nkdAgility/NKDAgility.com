---
title: Some thoughts on .NET 3.0 from LinkedIn
date: 2007-02-06
author: MrHinsh
id: "436"
layout: blog
resourceType: blog
slug: some-thoughts-on-net-3-0-from-linkedin
aliases:
  - /blog/some-thoughts-on-net-3-0-from-linkedin
tags:
  - wpf
categories:
  - code-and-complexity
preview: metro-binary-vb-128-link-1-1.png
---

I was asked on LinkedIn:

> "Are you planning to adopt .NET 3.0 in H1 2007?
>
> Several clients have asked me if their existing web systems can be upgraded to .NET 3.0. After some investigation, it seems that much of .NET 3.0 is available in other forms. For example, Windows Workflow looks like Biztalk in new clothes while Windows Communication Foundation does not improve on the performance of existing Web Services (though could be useful when setting up new ones). Windows Presentation Foundation/E is still only in CTP form and may require the end user to install a plugin (which removes the main advantage it may have over Flex 2/Flash 9) while I still don't see the USP for Cardspace.  
> Are your companies using .NET 3.0 purely for new applications?  
> Is it being used in place of other comparable technologies (e.g. Biztalk)? If so, how does .NET 3.0 compare?  
> Have you found .NET 3.0's XML-based approach simpler to use?  
> I am personally waiting for the official .NET 3.0 (Visual Studio "Orcas" + C# 3.0 including LINQ) release later this year before recommending .NET 3.0-based systems."
>
> By [Franco Milazzo](http://www.linkedin.com/in/eyetie)

I answered:

My company is using .NET 3.0, where appropriate for new applications. We even have Microsoft’s Evangelists doing weekly presentations on WPF, [Windows Communication Foundation](http://wcf.netfx3.com "Windows Communication Foundation"), and WF to get all of the developers and IT management up to speed.  
We have around 20,000+ IT staff and need to do this as quickly as possible as we are rolling out Vista and Office 2007 to 75,000 employees this year. As Vista has .NET 3.0 built-in, there is not even a support issue.

WF is not Biztalk, it will not replace Biztalk, nor will it have comparable features. However the next version of Biztalk will use WF as its internal orchestration engine as will many of Microsoft’s future products.  
WF requires coding and integration work while Biztalk provides a much larger package that has masses of automation that is not provided in WF.

WPF/e is essentially Microsoft’s replacement for Flash. WPF/e has a number of advantages over Flash the main one being integration; Flash sucks at communicating with other platforms, such as .NET or Java, while WPF/e uses native .NET thus providing the functionality of this platform in the animation environment; no more (non) action script.

CardSpace provides something that has never been available for all internet sites before. Single sign on! Yes, it has been available in various proprietary and expensive forms before. CardSpace allows the users to manage their identify themselves and to control what information is used by sites. It use open source xml to be platform independent and I believe there is already a Linux version along with Firefox support. Its mainstream use will be dependant on developer uptake and not users, so it will probably have a slow market penetration.

There is no reason why you should not use .NET 3.0 on new projects. The only reason to upgrade .NET 2.0 projects would be to simplify support and increase flexibility if you are using web services, remoting, message queuing, workflow or single-sign-on. Upgrading to .NET 3.0 is not really the way to think about it as you are still using the .NET 2.0 runtime. When ‘Orcas’ is released so will .NET 3.5 which will bring a new version of the CLR as well. This will not be the same product and even Vista will need updating to support it!

Go with .NET 3.0!

I also sugested an expert:

[Daniel Moth](http://www.danielmoth.com/Blog/ "The Moth")

Technorati Tags: [.NET](http://technorati.com/tags/.NET) [WPF](http://technorati.com/tags/WPF)
