---
id: "9495"
title: "TFS Integration Tools - Issue: unable to find a unique local path"
date: "2013-05-13"
categories: 
  - "problems-and-puzzles"
tags: 
  - "kb"
  - "puzzles"
  - "tfs-11"
  - "tfs-integration-platform"
  - "tools"
coverImage: "puzzle-issue-problem-128-link-2-2.png"
author: "MrHinsh"
type: "post"
slug: "tfs-integration-tools-issue-unable-to-find-a-unique-local-path"
---

When you are doing a Source Control migration using the TFS Integration Platform you receive a “unable to find a unique local path” runtime conflict.

[![image](images/image_thumb2.png)](http://blog.nwcadence.com/wp-content/uploads/2012/07/image2.png)  
Figure: You get a “MigrationException: unable to find a unique local path”

At this point the migration fails and you are unable to continue.

### Applies to

- TFS Integration Tools, version 2.2, March 2012
- TFS Team Explorer \[All Versions\]

### Finding

In order for the TFS Integration Platform to minimise the likelihood of hitting the 258 character limit of Windows it shortens the mapped path.

[![image](images/image_thumb3.png)](http://blog.nwcadence.com/wp-content/uploads/2012/07/image3.png)  
Figure: Shortened Local Folders

This works only when there are enough characters after the last “” to be able to get a distinct path. If there are no enough characters then a Local path is unable to be mapped and the exception results.

### Workarounds

The duplicates tend to come from multiple applications being stored under a single Team Project and all being mapped at once. If you chop your list of migrations down to a smaller list you are less likely to get duplicates.

[![image](images/image_thumb4.png)](http://blog.nwcadence.com/wp-content/uploads/2012/07/image4.png)  
Figure: ![](images/metro-icon-cross-1-1.png)Bad example, chance of collision is very high

Reduce the number of mappings by grouping them. You still want to include all of the things within a branch structure together, but make sure that you have distinct names.

_Originally published at Where Technology Meets Teamwork by [Martin Hinshelwood](http://blog.hinshelwood.com/about), Senior ALM Consultant. ([source](http://blog.nwcadence.com/tfs-integration-tools-issue-unable-to-find-a-unique-local-path/))_

