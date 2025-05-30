---
title: 'TFS 2012 Issue: Get Workspace already exists connecting with VS 2008 or VS 2010'
description: Explains how to resolve the "workspace already exists" error when connecting Visual Studio 2008 or 2010 to TFS 2012 by manually creating a Server workspace.
ResourceId: ZbdFc4NfQUe
ResourceType: blog
ResourceContentOrigin: Human
ResourceImport: true
ResourceImportId: 9496
ResourceImportSource: Wordpress
ResourceImportOriginalSource: Wordpress
date: 2013-05-06
weight: 1000
creator: Martin Hinshelwood
layout: blog
resourceTypes: blog
slug: tfs-2012-issue-get-workspace-already-exists-connecting-with-vs-2008-or-vs-2010
aliases:
- /resources/ZbdFc4NfQUe
aliasesArchive:
- /blog/tfs-2012-issue-get-workspace-already-exists-connecting-with-vs-2008-or-vs-2010
- /tfs-2012-issue-get-workspace-already-exists-connecting-with-vs-2008-or-vs-2010
- /tfs-2012-issue--get-workspace-already-exists-connecting-with-vs-2008-or-vs-2010
- /blog/tfs-2012-issue--get-workspace-already-exists-connecting-with-vs-2008-or-vs-2010
- /resources/blog/tfs-2012-issue-get-workspace-already-exists-connecting-with-vs-2008-or-vs-2010
tags:
- Troubleshooting
- Install and Configuration
categories:
- Uncategorized
preview: puzzle-issue-problem-128-link-1-1.png
Watermarks:
  description: 2025-05-13T15:06:31Z
concepts: []

---
You may get a "workspace already exists" when you have VS 2008 or VS 2010 installed as well as VS 2012 and you try to connect them to TFS 2012.

[![image](images/image_thumb.png)](http://blog.nwcadence.com/wp-content/uploads/2012/07/image.png)  
{ .post-img }
Figure: The Workspace already exists on computer

This results in this error ever time you start VS 2010 or VS 2008.

### Applies to

- Visual Studio 2008 connecting to Team Foundation Server 2012
- Visual Studio 2010 connecting to Team Foundation Server 2012

### Finding

If Visual Studio 2012 is the first thing that you open to create a new workspace against a new collection a default workspace of “computername;username” will be created as a “**Local**” workspace.

When you subsequently open VS 2008 or VS 2010, which do not support Local Workspaces, you get this error when it tries to create a workspace. Visual Studio does not detect that this workspace already exists as when it queries the server the “agent” filtering does not return local workspaces.

### Workaround

Manually create a “Server” workspace for use in VS 2010 and VS 2008.

[![image](images/image_thumb1.png)](http://blog.nwcadence.com/wp-content/uploads/2012/07/image1.png)  
{ .post-img }
Figure: Create a new Workspace with a new Name

1. Select “File | Source Control | Workspaces… | Add…”
2. Fill out a new name and then select “OK”
3. Select your new Workspace from the drop down

You can now connect to Source Control..

_Originally published at Where Technology Meets Teamwork by [Martin Hinshelwood](http://blog.hinshelwood.com/about), Senior ALM Consultant. ([source](http://blog.nwcadence.com/tfs-2012-issue-get-workspace-already-exists-connecting-with-vs-2008-or-vs-2010/))_
