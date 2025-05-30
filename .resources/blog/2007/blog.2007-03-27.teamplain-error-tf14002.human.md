---
title: 'TeamPlain Error: TF14002'
description: Explains the TF14002 error in TeamPlain, where NT AUTHORITY\NETWORK SERVICE lacks valid user group access, and discusses possible causes like proxy server settings.
ResourceId: PHs0D35ZIo4
ResourceType: blog
ResourceContentOrigin: Human
ResourceImport: true
ResourceImportId: 424
ResourceImportSource: Wordpress
ResourceImportOriginalSource: GeeksWithBlogs
date: 2007-03-27
weight: 1000
creator: Martin Hinshelwood
layout: blog
resourceTypes: blog
slug: teamplain-error-tf14002
aliases:
- /resources/PHs0D35ZIo4
aliasesArchive:
- /blog/teamplain-error-tf14002
- /teamplain-error-tf14002
- /teamplain-error--tf14002
- /blog/teamplain-error--tf14002
- /resources/blog/teamplain-error-tf14002
preview: nakedalm-logo-128-link-1-1.png
categories:
- Uncategorized
tags: []
Watermarks:
  description: 2025-05-13T16:28:58Z
concepts: []

---
Some prople have encountered this error when viewing the source control tab in TeamPlain:

> System.Web.Services.Protocols.SoapException: TF14002: The identity NT AUTHORITYNETWORK SERVICE is not a member of the Team Foundation Valid Users group.
>
> at Microsoft. TeamFoundation. VersionControl. Server. Repository. GetRepositoryProperties()

Now in the TeamPlain forums a couple of posts defign the problem, but no solution:

[SoapException with Source tab](http://dev.devbiz.com/forums/AddPost.aspx?PostID=3229) posted 03-27-2007 4:39 AM

[TF14002: The identity NT AUTHORITYNETWORK SERVICE is not a member of the Team Foundation Valid Users group.](http://dev.devbiz.com/forums/thread/1362.aspx) posted 05-17-2006, 4:31 AM

[1.1 Problems](http://dev.devbiz.com/forums/thread/2084.aspx) posted 10-14-2006, 12:37 AM

It seams that this is an internitant problem and may be caused by proxy server settings.

This has only hapened to one of my users sos far and not to me at all.

We will see...

Technorati Tags: [ALM](http://technorati.com/tags/ALM)
