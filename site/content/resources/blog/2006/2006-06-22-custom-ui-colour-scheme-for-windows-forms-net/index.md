---
id: "466"
title: "Custom UI colour scheme for Windows Forms .NET"
date: "2006-06-22"
categories:
  - "code-and-complexity"
tags:
  - "code"
coverImage: "metro-binary-vb-128-link-1-1.png"
author: "MrHinsh"
layout: blog
resourceType: blog
slug: "custom-ui-colour-scheme-for-windows-forms-net"

aliases:
  - /blog/custom-ui-colour-scheme-for-windows-forms-net
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

