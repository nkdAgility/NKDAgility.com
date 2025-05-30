---
title: 'TFS Integration Tools: TF237165: The Team Foundation Server could not update the work item'
description: Explains how to resolve the TF237165 error in TFS Integration Tools, caused by validation or mapping issues when updating work items during data migration.
ResourceId: -dhZywZGtrn
ResourceType: blog
ResourceContentOrigin: Human
ResourceImport: true
ResourceImportId: 6179
ResourceImportSource: Wordpress
ResourceImportOriginalSource: Wordpress
date: 2012-07-16
weight: 1000
creator: Martin Hinshelwood
layout: blog
resourceTypes: blog
slug: tfs-integration-tools-tf237165-the-team-foundation-server-could-not-update-the-work-item
aliases:
- /resources/-dhZywZGtrn
aliasesArchive:
- /blog/tfs-integration-tools-tf237165-the-team-foundation-server-could-not-update-the-work-item
- /tfs-integration-tools-tf237165-the-team-foundation-server-could-not-update-the-work-item
- /tfs-integration-tools--tf237165--the-team-foundation-server-could-not-update-the-work-item
- /blog/tfs-integration-tools--tf237165--the-team-foundation-server-could-not-update-the-work-item
- /resources/blog/tfs-integration-tools-tf237165-the-team-foundation-server-could-not-update-the-work-item
tags:
- Troubleshooting
categories:
- Uncategorized
preview: metro-problem-icon-2-2.png
Watermarks:
  description: 2025-05-13T15:08:39Z
concepts: []

---
While running an integration platform import you get a “TF237165: The Team Foundation Server could not update the work item because of a validation error on the server. This may happen because the work item has been modified or destroyed, or that you do not have permission to update that work item.”

[![image](images/image_thumb22-1-1.png "image")](http://blog.hinshelwood.com/files/2012/07/image22.png)  
{ .post-img }
**Figure: TF237165: The Team Foundation Server could not update the work item**

Unfortunately it does not tell you what it was trying to save.

### Applies To

- TFS Integration Tools 2.2, March 2012

### Finding

This was a Configuration error that was not really presented effectively. I found it by reducing the dataset to a few known failing items and commenting out all of the field before re-running the migration. I then added each field in one at a time until the error occurred.

I had a missing field migration to map a data value into reason:

And I had an incorrect mapping in the ValueMap:

**Figure: Value mapping for Reason field**

You can see on lines 2 and 3 of the code above I had incorrectly specified the mapping as having a left value for the field that I was mapping as a @@MISSINGFIELD@@.

### Workaround

The mentioned field either needs removed from the mapping or added to the work item. In this case I will be removing it from the mapping as I don’t need that field on the Task WIT.

**Did this solve your problem?**
