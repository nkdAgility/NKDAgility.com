---
id: "422"
title: "TFS Admin Tool 1.2 Gotcha"
date: "2007-03-29"
tags: 
  - "tfs"
author: "MrHinsh"
type: "post"
slug: "tfs-admin-tool-1-2-gotcha"
---

I ran into a small problem with the tfs admin tool.

When you add a user to a project as "Contributer" then it adds only "Publisher" to the reporting services permissions.

![](images/r_TFSAdminRSPermissionsIssue.JPG)
{ .post-img }

This is in fact wrong and should also add "Reader" otherwise you get lots of emails from users who can't view the reports!

This is a minor problem to fix, unless you only notice it after you have created 100 projects... Doh!

Technorati Tags: [ALM](http://technorati.com/tags/ALM) [TFS](http://technorati.com/tags/TFS)
