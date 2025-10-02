---
title: Xbox Live To Twitter
description: Guide to connecting your Xbox Live gamertag to Twitter using a custom application, including troubleshooting tips and links to source code and downloads.
date: 2008-01-04
lastmod: 2008-01-04
weight: 1000
sitemap:
  filename: sitemap.xml
  priority: 0.1
  changefreq: weekly
ItemId: 7DGS8UR6dab
ItemType: blog
ItemKind: resource
ItemContentOrigin: Human
slug: xbox-live-to-twitter
aliases:
  - /resources/7DGS8UR6dab
aliasesArchive:
  - /blog/xbox-live-to-twitter
  - /xbox-live-to-twitter
  - /resources/blog/xbox-live-to-twitter
layout: blog
concepts: []
categories:
  - Uncategorized
tags: []
Watermarks:
  description: 2025-05-13T16:25:09Z
ResourceId: 7DGS8UR6dab
ResourceType: blog
ResourceImportId: 271
creator: Martin Hinshelwood
resourceTypes: blog
preview: metro-xbox-360-link-1-1.png

---
I had been trying to find an application that provided updates to twitter from my Xbox. There is such an application written by [Duncan Mackenzie](http://duncanmackenzie.net/blog/connect-your-xbox-360-gamertag-to-twitter/default.aspx), but I could not get it to work. I tried everything and ended up decompiling the application to see what was wrong. Well, it seamed that the guts of the application was missing! The source code has all of the UI elements, but none of the bit to do the updates.

I tested the web service and it worked, so the only thing to do (Duncan has not updated the application since May 2007) was to write my own version. As I did not have access to Xbox Live data directly, I have leveraged Duncan's web service and only created the front end.

You can [download the application](http://www.codeplex.com/XboxLiveStatus/Release/ProjectReleases.aspx) from [CodePlex](http://www.codeplex.com "CodePlex") along with all the [source code](http://www.codeplex.com/XboxLiveStatus).

if you have any problems, please create or vote for Issues via the interface![smile_regular](images/smile_regular-2-2.gif).
{ .post-img }

Technorati Tags: [RDdotNet](http://technorati.com/tags/RDdotNet) [Xbox](http://technorati.com/tags/Xbox)
