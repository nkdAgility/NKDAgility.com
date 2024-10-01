---
id: "96"
title: "A perfect match TFS and DLR"
date: "2009-07-27"
categories: 
  - "code-and-complexity"
  - "me"
tags: 
  - "code"
  - "tfs-event-handler"
  - "tools"
  - "visual-studio"
  - "vs2010"
coverImage: "metro-visual-studio-2010-128-link-3-3.png"
author: "MrHinsh"
type: "blog"
slug: "a-perfect-match-tfs-and-dlr"
---

[![ConfigurationRequired](images/Aperfictmatch_701B-ConfigurationRequired_thumb-2-2.jpg)](http://blog.hinshelwood.com/files/2011/05/GWB-WindowsLiveWriter-Aperfictmatch_701B-ConfigurationRequired_2.jpg) I have always been annoyed with the mechanics of the Team Foundation Server check-in policies. I understand the limitations, but having to have a specific policy installed on every developers computer before you can use it is slightly ridicules and practically unmanageable. Why is there not a way to have a single installation that allows you to select any policy you want and have it execute in the desired manor on every client, including web clients?
{ .post-img }

I think it is. With the advent of the Dynamic Language Runtime (DLR) it should be possible to have a single (well one for each version of Visual Studio) policy that allows you to pick a DLR policy and have it run. One better would be to have a site that encapsulated those policies and you could just pick the one you want from a list. This could then open up a bunch of other features, like saved policy sets or composite policies for specific methodologies, or many others. But keeping to the KISS (Keep It Simple Stupid) principal all I need are two or three things, a Web Service based data store, a Policy and an editor.

I am currently working on the Web Services and how to pass and store the data I will need, but it looks promising and my initial investigations certainly worked quite well even though I am hampered by my lack of IronPython or IronRuby experience.

[![ar123456585516148](images/Aperfictmatch_701B-ar123456585516148_thumb-1-1.jpg)](http://blog.hinshelwood.com/files/2011/05/GWB-WindowsLiveWriter-Aperfictmatch_701B-ar123456585516148_2.jpg)Once I have the web services up to scratch (WCF by the way) I will try my hand at the Editor (WPF) and then move onto the Web interface (ASP.NET MVC) all in Visual Studio 2010.  A mammoth task, but one I think I can manage… famous last words…
{ .post-img }

I might need to learn a little Ruby :)

Technorati Tags: [ALM](http://technorati.com/tags/ALM) [TFS Custom](http://technorati.com/tags/TFS+Custom) [Developing](http://technorati.com/tags/Developing) [WIT](http://technorati.com/tags/WIT) [Version Control](http://technorati.com/tags/Version+Control) [WCF](http://technorati.com/tags/WCF) [WPF](http://technorati.com/tags/WPF) [VS 2010](http://technorati.com/tags/VS+2010)


