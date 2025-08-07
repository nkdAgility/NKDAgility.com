---
title: 'VSS Converter – Issue: TF54000: Cannot update the data because the server clock may have been set incorrectly'
description: Explains the TF54000 error during VSS to TFS migration, its cause due to server time sync issues, and provides a simple workaround to resume the migration process.
date: 2012-06-28
lastmod: 2012-06-28
weight: 1000
sitemap:
  filename: sitemap.xml
  priority: 0.1
  changefreq: weekly
ResourceId: dyEMgbMXhgq
ResourceImport: false
ResourceType: blog
ResourceContentOrigin: Human
slug: vss-converter-–-issue-tf54000-cannot-update-the-data-because-the-server-clock-may-have-been-set-incorrectly
aliases:
  - /resources/blog/vss-converter-issue-tf54000-cannot-update-the-data-because-the-server-clock-may-have-been-set-incorrectly
  - /resources/dyEMgbMXhgq
aliasesArchive:
  - /blog/vss-converter-issue-tf54000-cannot-update-the-data-because-the-server-clock-may-have-been-set-incorrectly
  - /vss-converter-issue-tf54000-cannot-update-the-data-because-the-server-clock-may-have-been-set-incorrectly
  - /vss-converter-–-issue--tf54000--cannot-update-the-data-because-the-server-clock-may-have-been-set-incorrectly
  - /blog/vss-converter-–-issue--tf54000--cannot-update-the-data-because-the-server-clock-may-have-been-set-incorrectly
  - /resources/blog/vss-converter-issue-tf54000-cannot-update-the-data-because-the-server-clock-may-have-been-set-incorrectly
layout: blog
concepts: []
categories:
  - Uncategorized
tags:
  - Troubleshooting
Watermarks:
  description: 2025-05-13T15:08:52Z
ResourceImportId: 6127
creator: Martin Hinshelwood
resourceTypes: blog

---
### Issue

During a VSS import you get a TF54000 error with a message of “Cannot update the data because the server clock may have been set incorrectly”

[![image](images/image_thumb63-1-1.png "image")](http://blog.hinshelwood.com/files/2012/06/image81.png)  
{ .post-img }
**Figure: TF54000: Cannot update the data because the server clock may have been set incorrectly**

### Applies to

- VSSConverter.exe
- Visual Studio 2010 Team Foundation Server

### Finding

What looks to have happened is that the scheduled time synchronisation just happened to occur during the migration and threw TFS a curve ball. Essentially you cant add data in the past when there is data in the future. I have blogged about [Full-fidelity history and data migration are mutually exclusive](http://blog.hinshelwood.com/full-fidelity-history-and-data-migration-are-mutually-exclusive/) and the tractability features in TFS that require this if you are interested. The root cause of this is likely to be the normal time sync from Active Directory being applied mid migration. While this is not normally going to cause a glitch, if you are making the number of calls that a migration does and the clock is set back only a few seconds you can encounter this.

### Workaround

Just wait for a minute (or so) and resume (thanks Cheryl) the migration by re-running the command.
