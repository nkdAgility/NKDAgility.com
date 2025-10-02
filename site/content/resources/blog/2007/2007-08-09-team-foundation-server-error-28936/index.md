---
title: Team Foundation Server Error 28936
description: Explains how Team Foundation Server installation fails with error 28936 due to IIS URLScan filter blocking web services, and how removing it resolves the issue.
date: 2007-08-09
lastmod: 2007-08-09
weight: 1000
sitemap:
  filename: sitemap.xml
  priority: 0.1
  changefreq: weekly
ItemId: pfq93Zq1pW6
ItemType: blog
ItemKind: resource
ItemContentOrigin: Human
slug: team-foundation-server-error-28936
aliases:
  - /resources/pfq93Zq1pW6
aliasesArchive:
  - /blog/team-foundation-server-error-28936
  - /team-foundation-server-error-28936
  - /resources/blog/team-foundation-server-error-28936
layout: blog
concepts: []
categories:
  - Uncategorized
tags:
  - Troubleshooting
  - Install and Configuration
  - Windows
Watermarks:
  description: 2025-05-13T16:26:49Z
ResourceId: pfq93Zq1pW6
ResourceType: blog
ResourceImportId: 337
creator: Martin Hinshelwood
resourceTypes: blog
preview: metro-visual-studio-2005-128-link-1-1.png

---
Some of my colleagues in New York have been working on deploying Team Foundation Server as a change management system and they ran into a little error while installing to the QA (UAT) environment.

> _Log file excerpt:_
>
> 08/08/07 10:59:33 DDSet_Status: Process returned 2336
>
> 08/08/07 10:59:33 DDSet_Status: Found the matching error code  for return value '2336' and it is: '28936'
>
> 08/08/07 10:59:33 DDSet_Error:  2336
>
> MSI (s) (E8!88) \[11:19:18:364\]: Product: Microsoft Visual Studio 2005 Team Foundation Server (services) - ENU -- Error 28936.TFServerStatusValidator: the Team Foundation Server ServerStatus Web service failed with 404 HTTP NotFound status. Verify that Internet Information Services, Windows SharePoint Services, and ASP.NET are configured correctly and that ASP. NET v2.0 Web Service Extensions are allowed . For more information on troubleshooting this error, see the Microsoft Help and Support Center.

[TFS](http://msdn2.microsoft.com/en-us/teamsystem/aa718934.aspx "Team Foundation Server") installed to a point and then through a "28936" error along with a "404 page not found" (I had these [symptoms](http://blog.hinshelwood.com/archive/2007/03/19/TFS_Gotcha_server_name.aspx "TFS Gotcha server name") before but a different cause). This occurred when TFS runs some checks after installing the web services. It try's to call http://server:8080/Services/v1.0/ServerStatus.asmx and can't get access to the URL. There was access to http://server:8080/services/ but when you try to access http://server:8080/services/v1.0 we got the 404.

I tried reinstalling ASP.NET, I checked permissions on folders, I tested asp.net and html from the services physical folder (Program FilesMicrosoft Team Foundation Server/Web Services/Services/). I pulled my hair out...

Then I asked the 6 million dollar question, "Has an IIS lockdown been performed"...

As it turns out the default company server build (sadly we buy source code for windows and cripple change things before deployment) contains an ISAPI filter on IIS called "URLScan" that does some sort of URL jiggery pokery that ultimately stops TFS from working.

Remove this, and the error goes away!

_This is from memory, I will fix any memory lapses tomorrow...Fixed_

Technorati Tags: [ALM](http://technorati.com/tags/ALM) [VS 2005](http://technorati.com/tags/VS+2005)
