---
title: 'TFS 2012 - Issue: TF250052: Grant access rights already exists after reconfigure of SharePoint'
description: Explains how to resolve the TF250052 error in TFS 2012 after reinstalling SharePoint 2010 by refreshing the access rights list to display existing entries.
date: 2012-08-20
lastmod: 2012-08-20
weight: 1000
sitemap:
  filename: sitemap.xml
  priority: 0.1
  changefreq: weekly
ItemId: KWHN3dnM-5A
ItemType: blog
ItemKind: resource
ItemContentOrigin: Human
slug: tfs-2012-issue-tf250052-grant-access-rights-already-exists-after-reconfigure-of-sharepoint
aliases:
  - /resources/KWHN3dnM-5A
aliasesArchive:
  - /blog/tfs-2012-issue-tf250052-grant-access-rights-already-exists-after-reconfigure-of-sharepoint
  - /tfs-2012-issue-tf250052-grant-access-rights-already-exists-after-reconfigure-of-sharepoint
  - /tfs-2012
  - /tfs-2012---issue--tf250052--grant-access-rights-already-exists-after-reconfigure-of-sharepoint
  - /blog/tfs-2012---issue--tf250052--grant-access-rights-already-exists-after-reconfigure-of-sharepoint
  - /resources/blog/tfs-2012-issue-tf250052-grant-access-rights-already-exists-after-reconfigure-of-sharepoint
layout: blog
concepts: []
categories:
  - Uncategorized
tags:
  - Troubleshooting
Watermarks:
  description: 2025-05-13T15:08:12Z
ResourceId: KWHN3dnM-5A
ResourceType: blog
ResourceImportId: 7247
creator: Martin Hinshelwood
resourceTypes: blog
preview: metro-problem-icon-2-2.png

---
If for some reason you need to re-install SharePoint 2010 as part of your TFS deployment you may get a “TF250052: Grant access rights already exists for the following Team Foundation Server URL: [http://tfs01:8080/tfs](http://tfs01:8080/tfs). You should modify the existing access” but you don’t see anything in the existing list!

[![image](images/image_thumb60-1-1.png "image")](http://blog.hinshelwood.com/files/2012/08/image60.png)  
{ .post-img }
**Figure: Um… where is the existing item and why the TF250052?**

### Applies to

- SharePoint 2010
- Visual Studio 2012 Team Foundation Server

### Findings

Although it is not displayed the previous listing is still there. If you click “Refresh” at the top of the window it will magically appear..

### Solution

Just click “OK” and then “Cancel”. Your display will then refresh with the entry listed! Phew..

**Did this help you?**
