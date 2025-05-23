---
title: Creating a better TFS Sticky Buddy (Core)
description: Explains building a flexible WPF data model in VB.NET for visualising hierarchical relationships using generics, ObservableCollections, and INotifyPropertyChanged.
ResourceId: NNnyeihSpHg
ResourceType: blog
ResourceContentOrigin: Human
ResourceImport: true
ResourceImportId: 241
ResourceImportSource: Wordpress
ResourceImportOriginalSource: GeeksWithBlogs
date: 2008-04-14
weight: 790
creator: Martin Hinshelwood
layout: blog
resourceTypes: blog
slug: creating-a-better-tfs-sticky-buddy-core
aliases:
- /resources/blog/creating-a-better-tfs-sticky-buddy-core
- /resources/NNnyeihSpHg
aliasesArchive:
- /blog/creating-a-better-tfs-sticky-buddy-core
- /creating-a-better-tfs-sticky-buddy-core
- /creating-a-better-tfs-sticky-buddy-(core)
- /blog/creating-a-better-tfs-sticky-buddy-(core)
- /resources/blog/creating-a-better-tfs-sticky-buddy-core
tags: []
categories:
- Uncategorized
preview: metro-binary-vb-128-link-2-2.png
Watermarks:
  description: 2025-05-13T16:24:24Z
concepts: []

---
[![TFSStickyBuddy_Core_ClassDiagram](images/CreatingabetterTFSStickyBuddyCore_8719-TFSStickyBuddy_Core_ClassDiagram_thumb_1-1-1.png)](http://blog.hinshelwood.com/files/2011/05/GWB-WindowsLiveWriter-CreatingabetterTFSStickyBuddyCore_8719-TFSStickyBuddy_Core_ClassDiagram_4.png) Over the last week I have been looking at the source for the [Family.Show](http://www.vertigo.com/familyshow.aspx) application from [Vertigo](http://www.vertigo.com/). I needed to look at methods of presentation of hierarchical information graphically using WPF and I saw this as a good representation of that sort of data. So I se about not only converting it to VB.NET but adding generics to the mix.
{ .post-img }

The first part of the application is the core objects that represent the data and allow interaction in a way that WPF can handle. This means using Observable Collections and implementing INotifyPropertyChanged to allow a higher level of interaction. I wanted to support any Source object type as well as my own custom types, so the type needed to be nested with a Wrapper that gives the illusion that it is a solid type, but in actual fact it is a soft wrapper that allows the system to interact with it without really understanding the type. The specific understanding of the type is done at a much higher level.

You will need to open this diagram in a new window to get the effect, but it is a completely generic representation of Parent, Child and  Sibling relationships for any object regardless of wither you have access to the source or not.

This is not currently designed to be an editable object, but inheriting from the [ItemWrapper](http://www.codeplex.com/TFSStickyBuddy/SourceControl/FileView.aspx?itemId=157013&changeSetId=10168) class would allow this, but would require a modification to the framework to handle the inherited type. Maybe v2...

Technorati Tags: [.NET](http://technorati.com/tags/.NET) [WPF](http://technorati.com/tags/WPF) [Design](http://technorati.com/tags/Design) [WIT](http://technorati.com/tags/WIT) [Developing](http://technorati.com/tags/Developing)
