---
title: Adding ToolStripPanel UI Adapter Support to the Composite UI Application Block
date: 2006-06-22
author: MrHinsh
id: "467"
layout: blog
resourceType: blog
slug: hinshelm-on-composite-ui-application-block
aliases:
  - /blog/hinshelm-on-composite-ui-application-block
tags:
  - code
  - tools
categories:
  - code-and-complexity
preview: metro-binary-vb-128-link-1-1.png
---

I was very surprised to find that CAB did not support a higher-level component like the ToolStrip in its basic implementation. I resolved to fix this and added an adapter and factory for the ToolStripPanel initially, but I encountered issues with the ToolStripContainer. As my first post, here is the ToolStripPanel code.

There are two parts to this and two ways to implement it. The first option is to edit the existing ToolStrip UI factory to include the new code, but I prefer not to do this as future CAB updates might require re-implementing the adaptations.

The second option is to inherit from the current classes in your own assembly and adapt the class to support both. This way, you extend the functionality without replacing it.

Here is the code for the new `ToolStripPanelUIAdapterFactory` factory:

```vb
Public Class ToolStripPanelUIAdapter
    Inherits UIElementAdapter(Of ToolStrip)

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

As you can see, this class inherits from the CAB class of the same name, overrides the same methods, and adds support for the new adapter for the `ToolStripPanel`.

Now, you can add the factory to the UI Element Adapter Factory Catalog in the `AfterShellCreated` part of the main shell application:

```vb
Dim catalog As IUIElementAdapterFactoryCatalog = RootWorkItem.Services.Get(Of IUIElementAdapterFactoryCatalog)()
catalog.RegisterFactory(New UIElements.ToolStripUIAdapterFactory())
```

The CAB framework will now handle `ToolStripPanel`s as UI Extension Sites with the appropriate factory. Now, all we need is the adapter...

Here is the code for the `ToolStripPanelAdapter`:

```vb
Public Class ToolStripPanelUIAdapter
    Inherits UIElementAdapter(Of ToolStrip)

    Private innerToolStripPanel As ToolStripPanel
    Private Shared NumberOfAddedControls As Integer = 0

    Public Sub New(ByVal objToolStripPanel As ToolStripPanel)
        Guard.ArgumentNotNull(objToolStripPanel, "objToolStripPanel")
        Me.innerToolStripPanel = objToolStripPanel
    End Sub

    Protected Overrides Function Add(ByVal uiElement As ToolStrip) As ToolStrip
        If Me.innerToolStripPanel Is Nothing Then
            Throw New InvalidOperationException()
        End If
        Dim Row As Integer = 2
        ' TODO: work out how to specify row!
        Me.innerToolStripPanel.Join(uiElement, 0)
        Me.innerToolStripPanel.Controls.SetChildIndex(uiElement, NumberOfAddedControls + 1)
        NumberOfAddedControls += 1
        Return uiElement
    End Function

    Protected Overrides Sub Remove(ByVal uiElement As ToolStrip)
        If Me.innerToolStripPanel.Controls.Contains(uiElement) Then
            Me.innerToolStripPanel.Controls.Remove(uiElement)
        End If
    End Sub
End Class
```

This code registers the top panel, but you can register another or all of them, though only on separate sites. Once you have registered the site, you can create and add `ToolStrips` to it:

```vb
Dim objToolStrip As New System.Windows.Forms.ToolStrip
LocalWorkItem.UIExtensionSites("MainToolStripPanelSiteName").Add(objToolStrip)
LocalWorkItem.UIExtensionSites.RegisterSite("MyCustomToolStripSitename", objToolStrip)
```

Don't forget the second registration that allows you to add a button to the `ToolStrip`.

All done! You should now be able to create dynamic tool strips and populate them. If you want to customize commands, you will need to create a command adapter for the `ToolStripPanel` and add it to CAB.
