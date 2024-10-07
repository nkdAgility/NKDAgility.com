---
id: "98"
title: "Disable a timer at every level of your ASP.NET control hierarchy"
date: "2009-07-22"
categories:
  - "code-and-complexity"
tags:
  - "aggreko"
  - "code"
  - "codeproject"
  - "tools"
  - "web"
coverImage: "metro-binary-vb-128-link-1-1.png"
author: "MrHinsh"
layout: blog
resourceType: blog
slug: "disable-a-timer-at-every-level-of-your-asp-net-control-hierarchy"

aliases:
  - /blog/disable-a-timer-at-every-level-of-your-asp-net-control-hierarchy
---

Even though this sounds like a really simple thing, what if you do not know the name of the controls, and you do not want to have to add a bit of code that you, or another may developer may forget to every piece of code with a timer in it. The problem I have is that if you have a DropDownList on the same page as a update panel that updates based on a timer, you get a little interference.

If the user has the DropDownList open when the update occurs then the DropDownList closes. Very annoying.

The standard FindControl does not work as it requires an ID, so what if all you have is a type?

Well, you need a little extension method :)

```
Imports System.Runtime.CompilerServices
Imports System.Web
Imports System.Web.UI

Module WebExtensions

    <Extension()> _
    Friend Sub FindControls(Of T)(ByVal control As Control, ByVal list As List(Of T))
        If control.HasControls Then
            Dim timers = control.Controls.OfType(Of T)()
            list.AddRange(timers)
            Dim subcontrols = From c In control.Controls Where Not timers.Cast(Of Control).Contains(c)
            For Each c In subcontrols.Cast(Of Control)()
                c.FindControls(Of T)(list)
            Next
        End If
    End Sub

    <Extension()> _
    Friend Function FindControls(Of T)(ByVal control As Control) As List(Of T)
        Dim l As New List(Of T)
        control.FindControls(Of T)(l)
        Return l
    End Function

End Module
```

I am pretty sure this is not the most efficient of code, and any recommendation on improving it are welcome…

Once this is in place it is easily called and actioned upon:

```
Sub OnPagePreRender(ByVal sender As Object, ByVal e As EventArgs)

    ' Fix for pages with drop down lists
    FixForDropdownListsAndTimers()
End Sub

Private Sub FixForDropdownListsAndTimers()
    ' Provcess timers
    Me.FindControls(Of System.Web.UI.Timer).ForEach(New Action(Of System.Web.UI.Timer)(AddressOf ProcessTimers))
End Sub

Private Sub ProcessTimers(ByVal t As System.Web.UI.Timer)
    t.Enabled = Not DisableTimers
End Sub
```

DisableTimers is set at the page level and filters down to the control so we can now disable all timers on a page when we want.

The FindControls method can find a list of all instances of a control type from an entire page, regardless of the nesting…

UPDATE: OK, so you have probably guessed that I am a complete **_muppet_**.. I have changes my UpdatePanels to UpdateMode=“Conditional” and with a few extra lines of code solved my problem the correct way! I will be keeping this little bit of code as you never know when you need to find all instances of a type of control :)… I am such a donkey…

Technorati Tags: [.NET](http://technorati.com/tags/.NET) [CodeProject](http://technorati.com/tags/CodeProject)

