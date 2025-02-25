---
title: Custom WCF Proxy
description: Learn how to create custom WCF proxies to streamline your web services and eliminate the need for converters. Enhance your .NET development toolkit today!
ResourceId: hfv2zp8Q-i4
ResourceType: blog
ResourceImport: true
ResourceImportId: 394
ResourceImportSource: Wordpress
ResourceImportOriginalSource: GeeksWithBlogs
date: 2007-05-29
weight: 775
creator: Martin Hinshelwood
layout: blog
resourceTypes: blog
slug: custom-wcf-proxy
aliases:
- /blog/custom-wcf-proxy
- /custom-wcf-proxy
- /resources/hfv2zp8Q-i4
- /resources/blog/custom-wcf-proxy
aliasesFor404:
- /custom-wcf-proxy
- /blog/custom-wcf-proxy
- /resources/blog/custom-wcf-proxy
tags:
- Technical Mastery
- Software Development
preview: metro-merilllynch-128-link-1-1.png
categories:
- Engineering Excellence

---
The think that always annoys me with web services is that when you connect to it and generate the proxy it always generates proxies for all of the extra classes and interfaces as well, even when you have them available. This means that you always have to write convertors or adapters to convert one object type to another even though they are the same object (only core class and proxy of that class).

I decided to solve the problem by creating custom proxies for my Windows Communication Foundation services. What you need to do is add a reference to your DataContract and ServceContract assemblies and do the following:

> Friend Class SubscriptionsClient  
>       Inherits System.ServiceModel.DuplexClientBase(Of Services.Contracts.ISubscriptions)  
>       Implements Services.Contracts.ISubscriptions
>
> ...
>
> End Class

This way you have no need of a convertors or adapters between object types. Obviously this only works for .NET to .NET implementations of servers, you Java guys are still on your own, but it a usefully tool to add to your arsenal.

Technorati Tags: [.NET](http://technorati.com/tags/.NET) [SOA](http://technorati.com/tags/SOA) [WCF](http://technorati.com/tags/WCF)
