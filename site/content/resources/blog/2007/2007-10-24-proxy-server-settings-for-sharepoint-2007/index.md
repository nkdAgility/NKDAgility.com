---
title: Proxy server settings for SharePoint 2007
description: Explains how to configure proxy server settings in SharePoint 2007, including passing user credentials and setting bypass rules for specific domains in the config file.
date: 2007-10-24
lastmod: 2007-10-24
weight: 1000
sitemap:
  filename: sitemap.xml
  priority: 0.1
  changefreq: weekly
ItemId: 5_4fz8bD4UU
ItemType: blog
ItemKind: resource
ItemContentOrigin: Human
slug: proxy-server-settings-for-sharepoint-2007
aliases:
  - /resources/5_4fz8bD4UU
aliasesArchive:
  - /blog/proxy-server-settings-for-sharepoint-2007
  - /proxy-server-settings-for-sharepoint-2007
  - /resources/blog/proxy-server-settings-for-sharepoint-2007
layout: blog
concepts: []
categories:
  - Uncategorized
tags:
  - System Configuration
Watermarks:
  description: 2025-05-13T16:25:44Z
ResourceId: 5_4fz8bD4UU
ResourceType: blog
ResourceImportId: 295
creator: Martin Hinshelwood
resourceTypes: blog
preview: metro-sharepoint-128-link-1-1.png

---
Well this was fun... All the [examples](http://dotnet.org.za/jpfouche/archive/2007/03/23/sharepoint-2007-rss-viewer-and-proxy-configuration.aspx "Missing details") of how to connect through a proxy from SharePoint are missing a crucial piece of information!

```
<system.net>
   <defaultProxy>
      <proxy usesystemdefault = "false" proxyaddress="http://proxyservername" bypassonlocal="true" />
   </defaultProxy>
</system.net>
```

This is the accepted route, with an exception to e added to the proxy to use anonymous authentication...

But is you use:

```
<defaultProxy useDefaultCredentials="true">
  <proxy usesystemdefault="false" proxyaddress=http://proxyservername" bypassonlocal="true" />
  <bypasslist>
    <add address="[a-z]+.domain.biz" />
    <add address="[a-z]+.domain2.biz" />
  </bypasslist>
</defaultProxy>
```

The required bit of which is the useDefaultCredentials parameter that passes the logged on users credentials on to the proxy server.

![smile_regular](images/smile_regular-2-2.gif) Now all I need to do is get the double-hop authentication to work...
{ .post-img }

Technorati Tags: [SP 2007](http://technorati.com/tags/SP+2007) [SP 2010](http://technorati.com/tags/SP+2010) [SharePoint](http://technorati.com/tags/SharePoint)
