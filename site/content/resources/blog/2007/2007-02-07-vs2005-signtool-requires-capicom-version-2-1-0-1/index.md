---
title: VS2005 - Signtool requires CAPICOM version 2.1.0.1
description: Resolve SignTool errors in VS2005 by installing CAPICOM 2.1.0.1. Follow our step-by-step guide to ensure smooth project publishing with ClickOnce.
ResourceId: XiAV2LaArje
ResourceType: blog
ResourceImport: true
ResourceImportId: 435
ResourceImportSource: Wordpress
ResourceImportOriginalSource: GeeksWithBlogs
date: 2007-02-07
weight: 1000
creator: Martin Hinshelwood
layout: blog
resourceTypes: blog
slug: vs2005-signtool-requires-capicom-version-2-1-0-1
aliases:
- /blog/vs2005-signtool-requires-capicom-version-2-1-0-1
- /vs2005-signtool-requires-capicom-version-2-1-0-1
- /vs2005
- /vs2005---signtool-requires-capicom-version-2-1-0-1
- /blog/vs2005---signtool-requires-capicom-version-2-1-0-1
- /resources/XiAV2LaArje
- /resources/blog/vs2005-signtool-requires-capicom-version-2-1-0-1
aliasesArchive:
- /blog/vs2005-signtool-requires-capicom-version-2-1-0-1
- /vs2005-signtool-requires-capicom-version-2-1-0-1
- /vs2005
- /vs2005---signtool-requires-capicom-version-2-1-0-1
- /blog/vs2005---signtool-requires-capicom-version-2-1-0-1
- /resources/blog/vs2005-signtool-requires-capicom-version-2-1-0-1
tags:
- Troubleshooting
- Install and Configuration
- Windows
preview: metro-visual-studio-2005-128-link-1-1.png
categories: []

---
If you get the following error publishing a project,

Error    32    SignTool reported an error SignTool Error: Signtool requires CAPICOM version 2.1.0.1 or higher. Please copy the latest version of CAPICOM.dll into the directory that contains SignTool.exe. If CAPICOM.dll exists, you may not have proper permissions to install CAPICOM.  
Follow these steps

1. Download a self-extracting zip file from [here](http://www.microsoft.com/downloads/details.aspx?FamilyID=860ee43a-a843-462f-abb5-ff88ea5896f6&DisplayLang=en).
2. Extract capicom.dll from this zip file
3. Copy Paste capicom.dll into your "C:/windows/system32" directory
4. click Start -> Run and type "REGSVR32 capicom.dll" and press OK
5. You should now be able to publish via ClickOnce.

Technorati Tags: [.NET](http://technorati.com/tags/.NET)
