---
title: Infragistics WPF
description: Overview of using Infragistics WPF controls, focusing on dynamic menu generation with data binding and templates, and challenges with documentation and template selection.
date: 2008-10-28
lastmod: 2008-10-28
weight: 1000
sitemap:
  filename: sitemap.xml
  priority: 0.1
  changefreq: weekly
ItemId: qNzd15yz5fn
ItemType: blog
ItemKind: resource
ItemContentOrigin: Human
slug: infragistics-wpf
aliases:
  - /resources/qNzd15yz5fn
aliasesArchive:
  - /blog/infragistics-wpf
  - /infragistics-wpf
  - /resources/blog/infragistics-wpf
layout: blog
concepts: []
categories:
  - Uncategorized
tags: []
Watermarks:
  description: 2025-05-13T16:22:46Z
ResourceId: qNzd15yz5fn
ResourceType: blog
ResourceImportId: 179
creator: Martin Hinshelwood
resourceTypes: blog

---
![](images/logo-1-1.gif) 
{ .post-img }

I am currently getting to grips with the Infragistics WPF controls that they call [NetAdvantage for WPF](http://www.infragistics.com/dotnet/netadvantage/wpf.aspx). So far I have found them easy to use, but the documentation of examples is very lax. Do not mistake me, these components are fantastic and do way more work for me than I would care to do myself, but if you Google a particular piece of their API invariable you will get pure documentation and no samples. If you are lucky someone has asked a specific question about it and you can skim their answers, but the likely hood of finding an answer to your question is negligible in my experience.

I still love the components, it just makes it a little more difficult to develop with them…

An example would maybe get us all on the same page:

I am using their Ribbon components in one of my applications and wanted to dynamically generate (using a binding) the menu options.

```
   1: <igRibbon:XamRibbon.ApplicationMenu>
```

```
   2: 
```

```
   3:             <igRibbon:ApplicationMenu>
```

```
   4:                 <igRibbon:MenuTool x:Name="uxTeamServerMenuTool" Caption="Team Server" ItemsSource="{Binding AvailableServers}"                                           ItemTemplate="{DynamicResource tAvailableServers}" ButtonType="DropDown"                                           LargeImage="ResourcesImagesTeamServerSelectIcon.png">
```

```
   5:                 </igRibbon:MenuTool>
```

```
   6:                 <igRibbon:MenuTool x:Name="uxTeamProjectMenuTool" Caption="Team Project" ItemsSource="{Binding AvailableProjects}"                                             ButtonType="DropDown" SmallImage="ResourcesImagesTeamProjectSelectIcon.png">
```

```
   7:                 </igRibbon:MenuTool>
```

```
   8:                 <igRibbon:MenuTool x:Name="uxHeatConnectionMenuTool" Caption="Heat Server" ButtonType="DropDown">
```

```
   9:                 </igRibbon:MenuTool>
```

```
  10:                 <igRibbon:MenuTool x:Name="uxHeatApplicationMenuTool" Caption="Heat App" ButtonType="DropDown" >
```

```
  11:                 </igRibbon:MenuTool>
```

```
  12:                 <!-- Place a button in the footer of the ApplicationMenu that allows the user to quit the application. -->
```

```
  13:                 <igRibbon:ApplicationMenu.FooterToolbar>
```

```
  14:                     <igRibbon:ApplicationMenuFooterToolbar>
```

```
  15:                         <igRibbon:ButtonTool Caption="Settings" Command="local:Commands.ClearSettingsCommand" />
```

```
  16:                         <igRibbon:ButtonTool Caption="Exit" />
```

```
  17:                     </igRibbon:ApplicationMenuFooterToolbar>
```

```
  18:                 </igRibbon:ApplicationMenu.FooterToolbar>
```

```
  19:             </igRibbon:ApplicationMenu>
```

```
  20:         </igRibbon:XamRibbon.ApplicationMenu>
```

As you can see in line 4 there is a binding that does indeed populate the list. But I am having trouble getting the template to take. I want the Items listed as a set of radio buttons (kinda) and so I added a Template:

```
   1: <DataTemplate x:Key="tAvailableServers" DataType="{x:Type tfs:TeamFoundationServer}">
```

```
   2:            <igRibbon:RadioButtonTool
```

```
   3:                            Caption="{Binding Name}"
```

```
   4:                            Tag="{Binding}"
```

```
   5:                            LargeImage="ResourcesImagesTeamServerSelectIcon.png"
```

```
   6:                            igRibbon:MenuToolBase.MenuItemDescription="{Binding Url.ToString}"/>
```

```
   7:        </DataTemplate>
```

This should have displayed what I wanted, but it seams to be ignored.

To allow this to work, all I needed to do was remove the x:Key from the template. But why can't I specify a template by name. What if I wanted to have two templates and choose which one was displayed…

Technorati Tags: [ALM](http://technorati.com/tags/ALM) [WPF](http://technorati.com/tags/WPF) [TFS](http://technorati.com/tags/TFS)
