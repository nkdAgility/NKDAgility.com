---
id: "467"
title: "Adding ToolStripPanel UI Adapter support to the Composite UI Application Block"
date: "2006-06-22"
categories:
  - "code-and-complexity"
tags:
  - "code"
  - "tools"
coverImage: "metro-binary-vb-128-link-1-1.png"
author: "MrHinsh"
layout: blog
resourceType: blog
slug: "hinshelm-on-composite-ui-application-block"
---

I was very supprised to find that CAB did not support a higher level the the ToolStrip in its basic implementation. I resolved to solve this and I have added an adapter and factory for the ToolStripPanel initialy, but I have been having trouble with the ToolStripContainer. So, as my first post, here is the ToolStripPanel code.

There are two parts to this. And two ways to do it. The first is to edit the existing ToolStrip UI factory to include the new code. But I do not like to do this as I may update CAB in the future and do not want to rely on havign to implement the adaptions again.

The second is to inherit from the current classes in you own assembly and to adapt the class to support both. That way you are extending, not replacing.

Here is the code for the new ToolStripUIAdapterFactory factory:

```
 Public Class ToolStripPanelUIAdapter : Inherits UIElementAdapter(Of ToolStrip)
        Private innerToolStripPanel As ToolStripPanel
        Public Sub New(ByVal objToolStripPanel As ToolStripPanel)
            Guard.ArgumentNotNull(objToolStripPanel, "objToolStripPanel")
            Me.innerToolStripPanel = objToolStripPanel
        End Sub
        Protected Overrides Function Add(ByVal uiElement As ToolStrip) As ToolStrip
            If Me.innerToolStripPanel Is Nothing Then
                Throw New InvalidOperationException()
            End If
            Me.innerToolStripPanel.Join(uiElement, 3)
            Return uiElement
        End Function
        Protected Overrides Sub Remove(ByVal uiElement As ToolStrip)
            If Me.innerToolStripPanel.Controls.Contains(uiElement) Then
                Me.innerToolStripPanel.Controls.Remove(uiElement)
            End If
        End Sub
    End Class
```

As you can see it inherits from the CAB class of the same name and overrides the same methods that it does and adds the support for the new Adapter for the ToolStripPanel.

You can now add the factory to the UI Element Adapter Factory Catalog in the AfterShellCreated part of the main shell application:

```
Dim catalog As IUIElementAdapterFactoryCatalog = RootWorkItem.Services.Get(Of IUIElementAdapterFactoryCatalog)()
        catalog.RegisterFactory(New UIElements.ToolStripUIAdapterFactory())
```

The CAB framework will now handle ToolStripPanel's as UI Extention Sites with the appropriet factory. Now all we need is the adapter...

Here is the code for the ToolStripPanel Adapter:

```
   1:      Public Class ToolStripPanelUIAdapter : Inherits UIElementAdapter(Of ToolStrip)
```

```
   2:
```

```
   3:          Private innerToolStripPanel As ToolStripPanel
```

```
   4:          Private Shared NumberOfAddedControls As Integer = 0
```

```
   5:
```

```
   6:          Public Sub New(ByVal objToolStripPanel As ToolStripPanel)
```

```
   7:              Guard.ArgumentNotNull(objToolStripPanel, "objToolStripPanel")
```

```
   8:              Me.innerToolStripPanel = objToolStripPanel
```

```
   9:          End Sub
```

```
  10:
```

```
  11:
```

```
  12:          Protected Overrides Function Add(ByVal uiElement As ToolStrip) As ToolStrip
```

```
  13:              If Me.innerToolStripPanel Is Nothing Then
```

```
  14:                  Throw New InvalidOperationException()
```

```
  15:              End If
```

```
  16:              Dim Row As Integer = 2
```

```
  17:              'TODO: work out how to specify row!
```

```
  18:              Me.innerToolStripPanel.Join(uiElement, 0)
```

```
  19:              Me.innerToolStripPanel.Controls.SetChildIndex(uiElement, NumberOfAddedControls + 1)
```

```
  20:              NumberOfAddedControls += 1
```

```
  21:              Return uiElement
```

```
  22:          End Function
```

```
  23:
```

```
  24:          Protected Overrides Sub Remove(ByVal uiElement As ToolStrip)
```

```
  25:              If Me.innerToolStripPanel.Controls.Contains(uiElement) Then
```

```
  26:                  Me.innerToolStripPanel.Controls.Remove(uiElement)
```

```
  27:              End If
```

```
  28:          End Sub
```

```
  29:
```

```
  30:      End Class
```

This code registers the Top panel, but you can register another or all of them, but only on seperate sites. Once you have register the site you can create and add ToolStrips to it:

```
Dim objToolStip As New System.Windows.Forms.ToolStrip
LocalWorkItem.UIExtensionSites("MainToolStripPanelSiteName").Add(objToolStip)
LocalWorkItem.UIExtensionSites.RegisterSite("MyCustomToolStripSitename", objToolStip)
```

Don't forget the second registration that allows you to add a button to the ToolStrip.

All done... You should now be able to create dynamic tool strips and populate them. If you want to customise command, you will need to create a command adapter for the ToolStripPanel and add it to CAB.
