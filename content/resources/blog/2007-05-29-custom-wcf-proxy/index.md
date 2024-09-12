---
id: "394"
title: "Custom WCF Proxy"
date: "2007-05-29"
tags: 
  - "ml"
  - "service-oriented-architecture"
  - "tools"
  - "wcf"
coverImage: "metro-merilllynch-128-link-1-1.png"
author: "MrHinsh"
type: "post"
slug: "custom-wcf-proxy"
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


