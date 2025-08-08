---
title: Custom UI colour scheme for Windows Forms .NET
description: Learn how to customise Windows Forms ToolStrip, MainMenu, and StatusBar colours in .NET by creating a custom ColorTable and applying it with a custom renderer.
date: 2006-06-22
lastmod: 2006-06-22
weight: 1000
sitemap:
  filename: sitemap.xml
  priority: 0.1
  changefreq: weekly
ResourceId: 2vSr2gsP4Rt
ResourceImport: false
ResourceType: blog
ResourceContentOrigin: Human
slug: custom-ui-colour-scheme-for-windows-forms-net
aliases:
  - /resources/blog/custom-ui-colour-scheme-for-windows-forms-.net
  - /resources/2vSr2gsP4Rt
aliasesArchive:
  - /blog/custom-ui-colour-scheme-for-windows-forms-net
  - /custom-ui-colour-scheme-for-windows-forms-net
  - /custom-ui-colour-scheme-for-windows-forms--net
  - /blog/custom-ui-colour-scheme-for-windows-forms--net
  - /resources/blog/custom-ui-colour-scheme-for-windows-forms-net
  - /resources/blog/custom-ui-colour-scheme-for-windows-forms-.net
layout: blog
concepts: []
categories:
  - Uncategorized
tags:
  - Windows
Watermarks:
  description: 2025-05-13T16:30:06Z
ResourceImportId: 466
creator: Martin Hinshelwood
resourceTypes: blog
preview: metro-binary-vb-128-link-1-1.png

---
The easyest way to customise you display of your ToolStrip, MainMenu and StatusBar is to use a custom ColorTable.

Just inherit from the ProfessionalColorRenderer and override what you want, with the colors you want:

```
   1:  Public Class MortgagesPlcColorTable
```

```
   2:          Inherits ProfessionalColorTable
```

```
   3:   
```

```
   4:          Public Overrides ReadOnly Property ButtonCheckedHighlightBorder() As System.Drawing.Color
```

```
   5:              Get
```

```
   6:                  Return MyBase.ButtonCheckedHighlightBorder
```

```
   7:              End Get
```

```
   8:          End Property
```

```
   9:   
```

```
  10:          Public Overrides ReadOnly Property MenuItemPressedGradientMiddle() As System.Drawing.Color
```

```
  11:              Get
```

```
  12:                  Return Color.FromArgb(91, 91, 91)
```

```
  13:              End Get
```

```
  14:          End Property
```

```
  15:   
```

```
  16:          Public Overrides ReadOnly Property ToolStripContentPanelGradientBegin() As System.Drawing.Color
```

```
  17:              Get
```

```
  18:                  Return Color.FromArgb(80, 80, 80)
```

```
  19:              End Get
```

```
  20:          End Property
```

```
  21:   
```

```
  22:          Public Overrides ReadOnly Property ToolStripContentPanelGradientEnd() As System.Drawing.Color
```

```
  23:              Get
```

```
  24:                  Return Color.WhiteSmoke
```

```
  25:              End Get
```

```
  26:          End Property
```

```
  27:   
```

```
  28:          Public Overrides ReadOnly Property ToolStripDropDownBackground() As System.Drawing.Color
```

```
  29:              Get
```

```
  30:                  Return Color.FromArgb(91, 91, 91)
```

```
  31:              End Get
```

```
  32:          End Property
```

```
  33:   
```

```
  34:          Public Overrides ReadOnly Property ToolStripGradientBegin() As System.Drawing.Color
```

```
  35:              Get
```

```
  36:                  Return Color.FromArgb(80, 80, 80)
```

```
  37:              End Get
```

```
  38:          End Property
```

```
  39:   
```

```
  40:      End Class
```

Once you have done this, all you need now is to add it to your contols:

```
   1:          System.Windows.Forms.ToolStripManager.Renderer = New ToolStripProfessionalRenderer(New MortgagesPlc.Windows.Forms.MortgagesPlcColorTable)
```

All done! If you have problems you can inherit from the ToolStrip control and change the renderer in the constructor...

Technorati Tags: [.NET](http://technorati.com/tags/.NET)
