---
title: My first Extension method...
description: Explains how to create and use extension methods in VB.NET, with an example for enhancing the XboxInfo class to display and track Xbox Live status changes.
ResourceId: QJ6lF5ONMCD
ResourceType: blog
ResourceContentOrigin: Human
ResourceImport: true
ResourceImportId: 269
ResourceImportSource: Wordpress
ResourceImportOriginalSource: GeeksWithBlogs
date: 2008-01-07
weight: 840
creator: Martin Hinshelwood
layout: blog
resourceTypes: blog
slug: my-first-extension-method
aliases:
- /resources/blog/my-first-extension-method...
- /resources/QJ6lF5ONMCD
aliasesArchive:
- /blog/my-first-extension-method
- /my-first-extension-method---
- /blog/my-first-extension-method---
- /my-first-extension-method
- /resources/blog/my-first-extension-method
- /resources/blog/my-first-extension-method...
tags: []
categories:
- Uncategorized
preview: metro-binary-vb-128-link-1-1.png
Watermarks:
  description: 2025-05-13T16:25:05Z
concepts: []

---
I decided as part of my .NET 3.5 learning curve to rebuild [Duncan Mackenzie](http://duncanmackenzie.net/blog/connect-your-xbox-360-gamertag-to-twitter/default.aspx)'s [Xbox to Twitter application](http://www.duncanmackenzie.net/blog/using-the-xbox-to-twitter-app-please-update-your-client/default.aspx) just for fun...

When you call his web service you get a XboxInfo class back that contains all of your Xbox Live Information. I wanted to be able to add a method to this called "ToInstanceString" that I would use to both display your Status, and to detect when it had changed.

In VB.NET you add Extension methods to a Module. One thing worth noting is that you can control the scope of the extension method with the Namespace. If you add a namespace of "MyApp.Mynamespace" your method will only be available within that namespace and not at the "MyApp" level.

> ```
> Public Module XboxExtensions
>
>     <System.Runtime.CompilerServices.Extension()> _
>     Friend Function ToPresenceString(ByVal Value As DMXIProxy.XboxInfo) As String
>         If Value.PresenceInfo.Info = "" Then
>             Return ""
>         ElseIf Value.PresenceInfo.Info2 = "" Then
>             Return Value.PresenceInfo.Info
>         Else
>             Return String.Format("{0} ({1})", Value.PresenceInfo.Info, Value.PresenceInfo.Info2)
>         End If
>     End Function
>
> End Module
> ```

You need to annotate the method with  the "System.Runtime.CompilerServices.Extension()" attribute, and make sure that the first parameter of the method is the type that you want to extend...

You can add extension methods randomly within your code, but it makes sense to put them all together in categorised module for future use. Although this one is specific to this application, you can probably see many circumstances where you could create generic and useful methods to add to things like collections and the like...

Have fun...

Technorati Tags: [.NET](http://technorati.com/tags/.NET)
