---
id: "435"
title: "VS2005 - Signtool requires CAPICOM version 2.1.0.1"
date: "2007-02-07"
tags:
  - "vs2005"
coverImage: "metro-visual-studio-2005-128-link-1-1.png"
author: "MrHinsh"
type: blog
slug: "vs2005-signtool-requires-capicom-version-2-1-0-1"
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
