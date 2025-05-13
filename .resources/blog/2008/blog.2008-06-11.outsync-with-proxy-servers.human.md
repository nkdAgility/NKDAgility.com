---
title: OutSync with proxy servers
description: Explains how to configure .NET applications, like OutSync, to work with proxy servers by editing the config file for proxy authentication and connectivity.
ResourceId: juUxY8REuRz
ResourceType: blog
ResourceContentOrigin: Human
ResourceImport: true
ResourceImportId: 220
ResourceImportSource: Wordpress
ResourceImportOriginalSource: GeeksWithBlogs
date: 2008-06-11
weight: 1000
creator: Martin Hinshelwood
layout: blog
resourceTypes: blog
slug: outsync-with-proxy-servers
aliases:
- /resources/juUxY8REuRz
aliasesArchive:
- /blog/outsync-with-proxy-servers
- /outsync-with-proxy-servers
- /resources/blog/outsync-with-proxy-servers
tags: []
categories:
- Uncategorized
preview: nakedalm-logo-128-link-2-1.png
Watermarks:
  description: 2025-05-13T16:23:56Z
concepts: []

---
[![image](images/OutSyncwithproxyservers_B70A-image_thumb-1-2.png)](http://blog.hinshelwood.com/files/2011/05/GWB-WindowsLiveWriter-OutSyncwithproxyservers_B70A-image_2.png)If like me you want to try the rather [groovy sync tool for Outlook](http://blogs.msdn.com/lokeuei/archive/2007/09/12/outsync-outlook-facebook-sync-released.aspx) that syncs your contacts (and pictures ) with your outlook contacts, which will then be displayed on your mobile phone, and you are behind a proxy server, then this info is for you…
{ .post-img }

**NOTE: This will work for any .NET application where the developer has not already set it…**

Open the \[applicationname\].config file in the install location and add:

> <system.net>  
>   <defaultProxy useDefaultCredentials="true">  
>     <proxy usesystemdefault="True" />  
>   </defaultProxy>  
> </system.net>

Just above the closing </configuration> tags. This will allow your application to authenticate with a proxy server…

Technorati Tags: [.NET](http://technorati.com/tags/.NET) [Personal](http://technorati.com/tags/Personal)
