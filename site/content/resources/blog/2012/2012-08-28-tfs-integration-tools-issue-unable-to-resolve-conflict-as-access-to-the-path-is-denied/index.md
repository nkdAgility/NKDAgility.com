---
title: 'TFS Integration Tools - Issue: Unable to resolve conflict as Access to the path is denied'
description: Resolve TFS Integration Tools conflicts effortlessly! Learn how to fix 'Access to the path is denied' errors by adjusting permissions in your configuration.
date: 2012-08-28
creator: Martin Hinshelwood
id: "7744"
layout: blog
resourceTypes: blog
slug: tfs-integration-tools-issue-unable-to-resolve-conflict-as-access-to-the-path-is-denied
aliases:
- /blog/tfs-integration-tools-issue-unable-to-resolve-conflict-as-access-to-the-path-is-denied
- /tfs-integration-tools-issue-unable-to-resolve-conflict-as-access-to-the-path-is-denied
- /tfs-integration-tools---issue--unable-to-resolve-conflict-as-access-to-the-path-is-denied
- /blog/tfs-integration-tools---issue--unable-to-resolve-conflict-as-access-to-the-path-is-denied
tags:
- puzzles
- tfs
- tfs-integration-platform
categories:
- problems-and-puzzles
preview: metro-problem-icon-4-4.png

---
If you change the WorkSpaceRoot in “C:Program Files (x86)Microsoft Team Foundation Server Integration ToolsMigrationToolServers.config” you may get an access to path is denied when manually resolving conflicts as per [TFS Integration Tools – Issue: TF10141 No Files checked in as a result of a TFS check-in failure](http://blog.hinshelwood.com/tfs-integration-tools-issue-tf10141-no-files-checked-in-as-a-result-of-a-tfs-check-in-failure/).

[![image](images/image_thumb106-1-1.png "image")](http://blog.hinshelwood.com/files/2012/08/image107.png)  
{ .post-img }
**Figure: Sorry we were unable to resolve the conflict**

### Applies to

- TFS Integration Tools, version 2.2, March 2012

### Findings

If you altered WorkSpaceRoot  in MigrationToolServers.config because you encountered some path problems then you will not have the correct permissions on the folder.

[![image](images/image_thumb107-2-2.png "image")](http://blog.hinshelwood.com/files/2012/08/image108.png)  
{ .post-img }
**Figure: Permission for TFSIPEXEC_WPG is missing**

This is because when you changed the path the TFS Integration Platform did not add the required permissions to it.

### Solution

Add the TFSIPEXEC_WPG permission to the folder with full rights.

[![image](images/image_thumb108-3-3.png "image")](http://blog.hinshelwood.com/files/2012/08/image109.png)  
{ .post-img }
**Figure: Model dialog galore**

Once you have added permissions you will be able to resolve the conflicts…
