---
title: Error creating listener in Team Build
description: Explains how to resolve AddressAccessDeniedException when running tests in Team Build by granting the Build Agent service account permission to create IIS listeners.
date: 2008-07-04
lastmod: 2008-07-04
weight: 1000
sitemap:
  filename: sitemap.xml
  priority: 0.1
  changefreq: weekly
ItemId: Eonka3snrWz
ItemType: blog
ItemKind: resource
ItemContentOrigin: Human
slug: error-creating-listener-in-team-build
aliases:
  - /resources/Eonka3snrWz
aliasesArchive:
  - /blog/error-creating-listener-in-team-build
  - /error-creating-listener-in-team-build
  - /resources/blog/error-creating-listener-in-team-build
layout: blog
concepts: []
categories:
  - Uncategorized
tags:
  - Troubleshooting
Watermarks:
  description: 2025-05-13T16:23:53Z
ResourceId: Eonka3snrWz
ResourceType: blog
ResourceImportId: 218
creator: Martin Hinshelwood
resourceTypes: blog
preview: nakedalm-logo-128-link-1-1.png

---
If, like me you are trying to run tests against your web services and you the error below, you will need to give permission to the service account that runs your Build Agent to create listeners in IIS.

> Class Initialization method TestServiceProjects.RentalCentreServiceRemoteTest.MyClassInitialize threw exception. System.ServiceModel.AddressAccessDeniedException:  System.ServiceModel.AddressAccessDeniedException: HTTP could not register URL [http://+:3456/RentalCentreServiceRemoteTest/](http://+:3456/RentalCentreServiceRemoteTest/). Your process does not have access rights to this namespace (see [http://go.microsoft.com/fwlink/?LinkId=70353](http://go.microsoft.com/fwlink/?LinkId=70353) for details). --->  System.Net.HttpListenerException: Access is denied.

I first tried giving the service account administrator rights, and this did not work, so I added “Act as part of operating system”. Lo and behold, that worked…

Happy now…

Technorati Tags: [ALM](http://technorati.com/tags/ALM)
