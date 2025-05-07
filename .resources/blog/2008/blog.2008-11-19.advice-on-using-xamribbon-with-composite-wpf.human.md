---
title: Advice on using XamRibbon with Composite WPF
description: Discover expert advice on integrating XamRibbon with Composite WPF. Enhance your applications with practical tips and code examples from Martin Hinshelwood.
ResourceId: gEnb0c6i-3I
ResourceType: blog
ResourceContentOrigin: Human
ResourceImport: true
ResourceImportId: 164
ResourceImportSource: Wordpress
ResourceImportOriginalSource: GeeksWithBlogs
date: 2008-11-19
weight: 840
creator: Martin Hinshelwood
layout: blog
resourceTypes: blog
slug: advice-on-using-xamribbon-with-composite-wpf
aliases:
- /resources/gEnb0c6i-3I
aliasesArchive:
- /blog/advice-on-using-xamribbon-with-composite-wpf
- /advice-on-using-xamribbon-with-composite-wpf
- /resources/blog/advice-on-using-xamribbon-with-composite-wpf
tags:
- Software Development
categories:
- Uncategorized
preview: metro-binary-vb-128-link-2-2.png

---
[![image](images/AdviceonusingXamRibbonwithCompositeWPF_EBA6-image_thumb-1-1.png)](http://blog.hinshelwood.com/files/2011/05/GWB-WindowsLiveWriter-AdviceonusingXamRibbonwithCompositeWPF_EBA6-image_2.png)
{ .post-img }

If, like me, you are interested in using all the new fangled controls produced by every man and his dog, you will probably have come across the [Infragistics](http://infragistics.com) WPF control. My mission, that I stupidly accepted, was to update the [TFS Sticky Buddy](http://hinshelwood.com/TFSStickyBuddy.aspx) application with their [XamRibbon](http://www.infragistics.com/dotnet/netadvantage/wpf/xamRibbon.aspx) and [XamDockManager](http://www.infragistics.com/dotnet/netadvantage/wpf/xamdockmanager.aspx) controls, and anything else I can stuff in there.

![](images/pnp.gif)
{ .post-img }

The “anything else” I decided to use was the [Composite WPF](http://www.codeplex.com/CompositeWPF) guidance. This is a newer WPF version of the Client Application Block (CAB) packages provided by the Patterns and Practices teams at Microsoft.

Anyhoo, I though I should give some advice for those of you mixing these technologies. I seam to have licked the [XamRibbon](http://www.infragistics.com/dotnet/netadvantage/wpf/xamRibbon.aspx) implementation, but I am still working on the [XamDockManager](http://www.infragistics.com/dotnet/netadvantage/wpf/xamdockmanager.aspx) bits.

Note: You will need to be familiar with the Composite WPF bits for this all to make sense.

```
   1: <igRibbon:XamRibbon  x:Name="uxXamRibbon" cal:RegionManager.RegionName="{x:Static inf:RegionNames.Shell_Ribbon}"

                           AllowMinimize="True" AutoHideEnabled="False" IsMinimized="False">
```

```
   2:         <igRibbon:XamRibbon.ApplicationMenu>
```

```
   3:           <igRibbon:ApplicationMenu cal:RegionManager.RegionName="{x:Static inf:RegionNames.Shell_RibbonApplicationMenu}"

                                           Image="/Hinshelwood.TFSStickyBuddy;component/RDIcon.ico">
```

```
   4:             <igRibbon:ApplicationMenu.FooterToolbar>
```

```
   5:               <igRibbon:ApplicationMenuFooterToolbar cal:RegionManager.RegionName="{x:Static inf:RegionNames.Shell_RibbonApplicationMenuFooterToolbar}">
```

```
   6:               </igRibbon:ApplicationMenuFooterToolbar>
```

```
   7:            </igRibbon:ApplicationMenu.FooterToolbar>
```

```
   8:         </igRibbon:ApplicationMenu>
```

```
   9:      </igRibbon:XamRibbon.ApplicationMenu>
```

```
  10: </igRibbon:XamRibbon>
```

As you can see there are a number of regions here, for the Tabs, the Application Menu and the FooterToolbar. You will need both a XamRibbon and a RibbonTabItem adapter.

```
   1: Public Class RibbonRegionAdapter
```

```
   2:     Inherits RegionAdapterBase(Of XamRibbon)
```

```
   3:
```

```
   4:     Private m_regionTarget As XamRibbon
```

```
   5:
```

```
   6:     Protected Overrides Sub Adapt(ByVal region As Microsoft.Practices.Composite.Regions.IRegion, ByVal regionTarget As XamRibbon)
```

```
   7:         m_regionTarget = regionTarget
```

```
   8:         regionTarget.Tabs.Clear()
```

```
   9:         AddHandler region.ActiveViews.CollectionChanged, AddressOf OnActiveViewsChanged
```

```
  10:         For Each v As RibbonTabItem In region.ActiveViews
```

```
  11:             regionTarget.Tabs.Add(v)
```

```
  12:         Next
```

```
  13:
```

```
  14:     End Sub
```

```
  15:
```

```
  16:     Private Sub OnActiveViewsChanged(ByVal sender As Object, ByVal e As NotifyCollectionChangedEventArgs)
```

```
  17:         Select Case e.Action
```

```
  18:             Case NotifyCollectionChangedAction.Add
```

```
  19:                 For Each v In e.NewItems
```

```
  20:                     m_regionTarget.Tabs.Add(v)
```

```
  21:                 Next
```

```
  22:             Case NotifyCollectionChangedAction.Remove
```

```
  23:                 For Each v In e.OldItems
```

```
  24:                     m_regionTarget.Tabs.Remove(v)
```

```
  25:                 Next
```

```
  26:         End Select
```

```
  27:     End Sub
```

```
  28:
```

```
  29:     Protected Overrides Function CreateRegion() As Microsoft.Practices.Composite.Regions.IRegion
```

```
  30:         Return New AllActiveRegion
```

```
  31:     End Function
```

```
  32:
```

```
  33: End Class
```

```
   1: Public Class RibbonTabItemRegionAdapter
```

```
   2:     Inherits RegionAdapterBase(Of RibbonTabItem)
```

```
   3:
```

```
   4:     Private m_regionTarget As RibbonTabItem
```

```
   5:
```

```
   6:     Protected Overrides Sub Adapt(ByVal region As Microsoft.Practices.Composite.Regions.IRegion, ByVal regionTarget As RibbonTabItem)
```

```
   7:         m_regionTarget = regionTarget
```

```
   8:         regionTarget.Content.Clear()
```

```
   9:         AddHandler region.ActiveViews.CollectionChanged, AddressOf OnActiveViewsChanged
```

```
  10:         For Each v As Object In region.ActiveViews
```

```
  11:             regionTarget.Content.Add(v)
```

```
  12:         Next
```

```
  13:
```

```
  14:     End Sub
```

```
  15:
```

```
  16:     Private Sub OnActiveViewsChanged(ByVal sender As Object, ByVal e As NotifyCollectionChangedEventArgs)
```

```
  17:         Select Case e.Action
```

```
  18:             Case NotifyCollectionChangedAction.Add
```

```
  19:                 For Each v In e.NewItems
```

```
  20:                     m_regionTarget.Content.Add(v)
```

```
  21:                 Next
```

```
  22:             Case NotifyCollectionChangedAction.Remove
```

```
  23:                 For Each v In e.OldItems
```

```
  24:                     m_regionTarget.Content.Remove(v)
```

```
  25:                 Next
```

```
  26:         End Select
```

```
  27:     End Sub
```

```
  28:
```

```
  29:     Protected Overrides Function CreateRegion() As Microsoft.Practices.Composite.Regions.IRegion
```

```
  30:         Return New AllActiveRegion
```

```
  31:     End Function
```

```
  32:
```

```
  33: End Class
```

I am pretty sure that these can be augmented, and I can think of a few Ideas already, including adding a re-parenting ability to allow menu items to be added to the XAML as well as programmatically added.

I think I might have to go away and try this…

Technorati Tags: [WPF](http://technorati.com/tags/WPF) [CodeProject](http://technorati.com/tags/CodeProject)
