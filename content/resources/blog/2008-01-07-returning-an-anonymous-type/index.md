---
id: "268"
title: "Returning an Anonymous type..."
date: "2008-01-07"
categories: 
  - "code-and-complexity"
tags: 
  - "code"
  - "process"
coverImage: "metro-binary-vb-128-link-2-1.png"
author: "MrHinsh"
type: "post"
slug: "returning-an-anonymous-type"
---

[![image](images/ReturninganAnonymoustype_8A86-image_thumb-1-2.png)](http://blog.hinshelwood.com/files/2011/05/GWB-WindowsLiveWriter-ReturninganAnonymoustype_8A86-image_2.png) In VB.NET it is actually possible to return an Anonymous type from a function and use it somewhere else. In VB.NET you need to use late binding so you can't change the "Option strict" compiler option to true as I have always done in the past. This option, that defaults to "Off", is the main reason that C# developers scoff at VB, but this feature is now available, controversially in C#.

In this example I created an anonymous type that has three properties.

> ```
>     Public Function GetTwiterCredentials() As Object
>         If Not My.Settings.TwitterEmail.Length > 3 Then
>             GetSettings()
>         End If
>         If Not My.Settings.TwitterPassword.Length > 3 Then
>             GetSettings()
>         End If
>         If Not My.Settings.TwitterUsername.Length > 3 Then
>             GetSettings()
>         End If
>         Return New With { _
>                     .Email = My.Settings.TwitterEmail, _
>                     .Password = My.Settings.TwitterPassword, _
>                     .Username = My.Settings.TwitterUsername _
>                         }
>     End Function
> ```

The use of this is very simple, although I would like an option other than to return "Object" so Visual Studio knows that it is an anonymous type.

> ```
>             Dim TwiterCredentials = View.GetTwiterCredentials
>             Dim result As String = ""
>             result = Twitter.TwitterAPI.UpdateStatus( _
>                                     status, _
>                                     TwiterCredentials.Email, _
>                                     TwiterCredentials.Password _
>                                     )
> ```

[](http://11011.net/software/vspaste)

There is no intellisense with this, so you have to know what the options are. Hopefully in future versions this will be rectified.

Technorati Tags: [.NET](http://technorati.com/tags/.NET)


