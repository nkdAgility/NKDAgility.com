---
title: TFS Admin Tool 1.2 Gotcha
description: Describes an issue in TFS Admin Tool 1.2 where adding a user as "Contributer" fails to grant necessary "Reader" permissions in reporting services, causing access problems.
ResourceId: SmRXtDPyViB
ResourceType: blog
ResourceContentOrigin: Human
ResourceImport: true
ResourceImportId: 422
ResourceImportSource: Wordpress
ResourceImportOriginalSource: GeeksWithBlogs
date: 2007-03-29
weight: 1000
creator: Martin Hinshelwood
layout: blog
resourceTypes: blog
slug: tfs-admin-tool-1-2-gotcha
aliases:
- /resources/blog/tfs-admin-tool-1.2-gotcha
- /resources/SmRXtDPyViB
aliasesArchive:
- /blog/tfs-admin-tool-1-2-gotcha
- /tfs-admin-tool-1-2-gotcha
- /resources/blog/tfs-admin-tool-1-2-gotcha
- /resources/blog/tfs-admin-tool-1.2-gotcha
tags: []
categories:
- Uncategorized
Watermarks:
  description: 2025-05-13T16:28:54Z
concepts: []

---
I ran into a small problem with the tfs admin tool.

When you add a user to a project as "Contributer" then it adds only "Publisher" to the reporting services permissions.

![](images/r_TFSAdminRSPermissionsIssue.JPG)
{ .post-img }

This is in fact wrong and should also add "Reader" otherwise you get lots of emails from users who can't view the reports!

This is a minor problem to fix, unless you only notice it after you have created 100 projects... Doh!

Technorati Tags: [ALM](http://technorati.com/tags/ALM) [TFS](http://technorati.com/tags/TFS)
