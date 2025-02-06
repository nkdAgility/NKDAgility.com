---
title: Creating a custom proxy class
description: Learn to create a custom proxy class in .NET 3.0 for better maintainability and less code. Enhance your service-oriented architecture skills today!
ResourceId: S4XG-Is-FHq
ResourceType: blog
ResourceImport: true
ResourceImportId: 326
ResourceImportSource: Wordpress
ResourceImportOriginalSource: GeeksWithBlogs
date: 2007-08-20
creator: Martin Hinshelwood
layout: blog
resourceTypes: blog
slug: creating-a-custom-proxy-class
aliases:
- /blog/creating-a-custom-proxy-class
- /creating-a-custom-proxy-class
- /resources/S4XG-Is-FHq
- /resources/blog/creating-a-custom-proxy-class
aliasesFor404:
- /creating-a-custom-proxy-class
- /blog/creating-a-custom-proxy-class
- /resources/blog/creating-a-custom-proxy-class
tags:
- code
- service-oriented-architecture
- tools
categories:
- application-lifecycle-management
preview: metro-binary-vb-128-link-1-1.png

---
Instead of using the proxy generation features of Visual Studio you can create a custom proxy in .NET 3.0 to handle all of your needs in a more maintainable manor and with less code. This method works best when you have access to the interfaces that created the service.

Here is an example:

> ```
> Namespace TeamFoundation.Proxies
>
>     Public Class TeamServersClient
>         Inherits System.ServiceModel.DuplexClientBase(Of Services.Contracts.ITeamServers)
>         Implements RDdotNet.Proxies.IClientProxy
>         Implements Services.Contracts.ITeamServers
>
>         Public Sub New(ByVal callbackInstance As System.ServiceModel.InstanceContext, ByVal binding As System.ServiceModel.Channels.Binding, ByVal remoteAddress As System.ServiceModel.EndpointAddress)
>             MyBase.New(callbackInstance, binding, remoteAddress)
>         End Sub
>
>         Public Sub AddServer(ByVal TeamServerName As String, ByVal TeamServerUri As String) Implements Services.Contracts.ITeamServers.AddServer
>             MyBase.Channel.AddServer(TeamServerName, TeamServerUri)
>         End Sub
>
>         Public Function GetServers() As String() Implements Services.Contracts.ITeamServers.GetServers
>             Return MyBase.Channel.GetServers
>         End Function
>
>         Public Sub RemoveServer(ByVal TeamServerName As String) Implements Services.Contracts.ITeamServers.RemoveServer
>             MyBase.Channel.RemoveServer(TeamServerName)
>         End Sub
>
>         Public Function ServceUrl() As System.Uri Implements Services.Contracts.ITeamServers.ServceUrl
>             Return MyBase.Channel.ServceUrl()
>         End Function
>
>     End Class
>
> End Namespace
> ```

Because your classes implements the service's interface when that interface changes you will be notified in Visual Studio that this has happened. This is a boon during development as changes can happen often.

This particular class is a duplex proxy, so communication can go both ways. You can download the source code for this from [here](http://www.codeplex.com/TFSEventHandler/SourceControl/DownloadSourceCode.aspx?changeSetId=8644).

Technorati Tags: [.NET](http://technorati.com/tags/.NET) [SOA](http://technorati.com/tags/SOA)
