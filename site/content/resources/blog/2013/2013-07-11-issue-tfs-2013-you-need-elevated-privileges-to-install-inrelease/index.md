---
title: Issue [ TFS 2013 ] You need elevated privileges to install InRelease
description: Learn how to resolve InRelease 3 installation failures on Team Foundation Server 2013 by running the installer with elevated privileges via an elevated command prompt.
date: 2013-07-11
lastmod: 2013-07-11
weight: 1000
sitemap:
  filename: sitemap.xml
  priority: 0.1
  changefreq: weekly
ResourceId: 8WoqmaS6v99
ResourceImport: false
ResourceType: blog
ResourceContentOrigin: Human
slug: issue-tfs-2013-you-need-elevated-privileges-to-install-inrelease
aliases:
  - /resources/8WoqmaS6v99
aliasesArchive:
  - /blog/issue-tfs-2013-you-need-elevated-privileges-to-install-inrelease
  - /issue-tfs-2013-you-need-elevated-privileges-to-install-inrelease
  - /issue-[-tfs-2013-]-you-need-elevated-privileges-to-install-inrelease
  - /blog/issue-[-tfs-2013-]-you-need-elevated-privileges-to-install-inrelease
  - /resources/blog/issue-tfs-2013-you-need-elevated-privileges-to-install-inrelease
layout: blog
concepts: []
categories:
  - Uncategorized
tags:
  - Troubleshooting
  - Install and Configuration
  - Windows
Watermarks:
  description: 2025-05-12T14:23:46Z
ResourceImportId: 9753
creator: Martin Hinshelwood
resourceTypes: blog
preview: puzzle-issue-problem-128-link-3-3.png

---
Installing InRelease 3 fails as you need elevated privileges to install InRelease

When you try to install InRelease as part of your Team Foundation Server 2013 infrastructure you are allowed to fill out all of the fields and then you get a “you need elevated privileges to perform this installation. You can achieve this by running a command prompt”.

[![image[14]](images/image14_thumb-1-1.png "image[14]")](http://nkdagility.com/files/2013/07/image14.png)  
{ .post-img }
Figure: For InRelease you need elevated privileges to perform this installation

## Applies to

- InRelease 3
- Team Foundation Server 2013

## Findings

I don’t know how this got past the testers but even though you are asked to elevate the privileges during the installation the installation will fail with the message that “you need elevated privileges to perform this installation”. It looks like this was built with user account control turned off! Never a good idea…

In order to bypass this you have two options. You can follow the instructions that are presented, open an elevated command prompt and then execute the MSI installer from there using the msiexec command.

## Solution

Forts we need to open a command prompt

![image](images/image15-2-2.png "image")  
{ .post-img }
Figure: Execute MSIEXEC from an elevated command prompt

Once you have the command prompt open you need to execute the following command replacing your location to the MSI. You may want to put it in C:temp to make things easyer but I just copied the UNC path from a file explorer window.

```
msiexec -i "\dahakd$DataDownloads_SoftwareVisual StudioVisual Studio 2013 Preview (NDA)InCycleInRelease_Preview.msi"

```

Now that I have the installer running entirely elevated I can install with no problems…
