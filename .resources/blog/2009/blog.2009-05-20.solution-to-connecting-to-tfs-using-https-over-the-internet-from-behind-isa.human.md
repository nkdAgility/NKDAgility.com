---
title: Solution to connecting to TFS using HTTPS over the Internet from behind ISA
description: Explains how to resolve TFS connection issues over HTTPS from behind an ISA server by updating Visual Studio registry settings for proxy configuration.
ResourceId: 4uyTp0ETt2H
ResourceType: blog
ResourceContentOrigin: Human
ResourceImport: true
ResourceImportId: 112
ResourceImportSource: Wordpress
ResourceImportOriginalSource: GeeksWithBlogs
date: 2009-05-20
weight: 1000
creator: Martin Hinshelwood
layout: blog
resourceTypes: blog
slug: solution-to-connecting-to-tfs-using-https-over-the-internet-from-behind-isa
aliases:
- /resources/4uyTp0ETt2H
aliasesArchive:
- /blog/solution-to-connecting-to-tfs-using-https-over-the-internet-from-behind-isa
- /solution-to-connecting-to-tfs-using-https-over-the-internet-from-behind-isa
- /resources/blog/solution-to-connecting-to-tfs-using-https-over-the-internet-from-behind-isa
tags:
- Troubleshooting
- Install and Configuration
preview: metro-visual-studio-2010-128-link-1-1.png
categories:
- Uncategorized
Watermarks:
  description: 2025-05-13T15:23:47Z
concepts: []

---
This problem it seams is to do with the way Visual Studio 2010 connects to your [TFS](http://msdn2.microsoft.com/en-us/teamsystem/aa718934.aspx "Team Foundation Server") server over HTTPS. The default value for “BypassProxyOnLocal” in Visual Studio 2008 was “False”, but it has been changed to “True” for Visual Studio 2010 Beta 1. It should be noted that this is currently a Beta 1 workaround and this behaviour may be updated for Beta 2 and RTM.

You can fix this by adding the following registry keys and restarting Visual Studio 2010:

You need to add a “RequestSettings” key to both of the following location that contains a string value pair of “BypassProxyOnLocal=’False’”.

32bit OS Key Locations:

```
HKEY_LOCAL_MACHINESOFTWAREMicrosoftTeamFoundationServer10.0RequestSettings

HKEY_LOCAL_MACHINESOFTWAREMicrosoftVisualStudio10.0TeamFoundationRequestSettings
```

64bit key locations:

```
HKEY_LOCAL_MACHINESOFTWAREWow6432NodeMicrosoftTeamFoundationServer10.0RequestSettings

HKEY_LOCAL_MACHINESOFTWAREWow6432NodeMicrosoftVisualStudio10.0TeamFoundationRequestSettings
```

You can find out more on the “[How to: Change the BypassProxyOnLocal Configuration](<http://msdn.microsoft.com/en-us/library/bb909716(loband).aspx>)” documentation on MSDN.

Technorati Tags: [ALM](http://technorati.com/tags/ALM) [VS 2010](http://technorati.com/tags/VS+2010) [VS 2008](http://technorati.com/tags/VS+2008)
