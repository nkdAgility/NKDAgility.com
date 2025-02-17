---
title: Serialize Assembly for Service calls over Http
description: Discover how to serialize .NET assemblies for WCF service calls without byte streams. Join the discussion and find solutions to your coding challenges!
ResourceId: TgSz2FK5KBK
ResourceType: blog
ResourceImport: true
ResourceImportId: 415
ResourceImportSource: Wordpress
ResourceImportOriginalSource: GeeksWithBlogs
date: 2007-04-24
creator: Martin Hinshelwood
layout: blog
resourceTypes: blog
slug: serialize-assembly-for-service-calls-over-http
aliases:
- /blog/serialize-assembly-for-service-calls-over-http
- /serialize-assembly-for-service-calls-over-http
- /resources/TgSz2FK5KBK
- /resources/blog/serialize-assembly-for-service-calls-over-http
aliasesFor404:
- /serialize-assembly-for-service-calls-over-http
- /blog/serialize-assembly-for-service-calls-over-http
- /resources/blog/serialize-assembly-for-service-calls-over-http
tags:
- Technical Mastery
- Troubleshooting
- Software Development
categories: []
preview: metro-binary-vb-128-link-1-1.png

---
I want to send a .NET assembly as either an System.Reflection.Assembly or as a string over the wire through a [Windows Communication Foundation](http://wcf.netfx3.com "Windows Communication Foundation") web service. It seems that the class System.Reflection.Assembly can serialize, but is unable to deserialize at the other end. How can this be achieved without sending as a straem of Byte.

I would prefer:

<OperationContract(IsOneWay:=True)> \_  
Sub AddEventHandlerAssembly(ByVal Assembly As System.Reflection.Assembly)

Or:  
<OperationContract(IsOneWay:=True)> \_  
Sub AddEventHandlerAssembly(ByVal Assembly As String)

But not:

<OperationContract(IsOneWay:=True)> \_  
Sub AddEventHandlerAssembly(ByVal Assembly As Byte())

I have tralled the web for a while now, trying to find a solution. I have even decompiled the Assembly class and the problem is that it implements System.Runtime.Serialization.ISerializable but does not provide the constructor for the deserialize.

Does anyone have a solution for this?

Technorati Tags: [.NET](http://technorati.com/tags/.NET)
