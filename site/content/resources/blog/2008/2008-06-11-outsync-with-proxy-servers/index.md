---
title: OutSync with proxy servers
description: Learn how to configure OutSync for Outlook behind a proxy server. Follow our guide to sync your contacts effortlessly and enhance your mobile experience!
ResourceId: juUxY8REuRz
ResourceType: blog
ResourceImport: true
ResourceImportId: 220
ResourceImportSource: Wordpress
ResourceImportOriginalSource: GeeksWithBlogs
date: 2008-06-11
creator: Martin Hinshelwood
id: "220"
layout: blog
resourceTypes: blog
slug: outsync-with-proxy-servers
aliases:
- /blog/outsync-with-proxy-servers
- /outsync-with-proxy-servers
- /resources/juUxY8REuRz
- /resources/blog/outsync-with-proxy-servers
aliasesFor404:
- /outsync-with-proxy-servers
- /blog/outsync-with-proxy-servers
- /resources/blog/outsync-with-proxy-servers
tags:
- fail
categories:
- me
preview: nakedalm-logo-128-link-2-1.png

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
