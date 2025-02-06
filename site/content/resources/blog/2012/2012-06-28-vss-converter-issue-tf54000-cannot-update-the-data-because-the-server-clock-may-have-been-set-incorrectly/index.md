---
title: 'VSS Converter – Issue: TF54000: Cannot update the data because the server clock may have been set incorrectly'
description: Encountering TF54000 during VSS import? Discover the cause and a simple workaround to resolve the server clock issue for a smooth migration process.
ResourceId: dyEMgbMXhgq
ResourceType: blog
ResourceImport: true
ResourceImportId: 6127
ResourceImportSource: Wordpress
ResourceImportOriginalSource: Wordpress
date: 2012-06-28
creator: Martin Hinshelwood
layout: blog
resourceTypes: blog
slug: vss-converter-issue-tf54000-cannot-update-the-data-because-the-server-clock-may-have-been-set-incorrectly
aliases:
- /blog/vss-converter-issue-tf54000-cannot-update-the-data-because-the-server-clock-may-have-been-set-incorrectly
- /vss-converter-issue-tf54000-cannot-update-the-data-because-the-server-clock-may-have-been-set-incorrectly
- /vss-converter-–-issue--tf54000--cannot-update-the-data-because-the-server-clock-may-have-been-set-incorrectly
- /blog/vss-converter-–-issue--tf54000--cannot-update-the-data-because-the-server-clock-may-have-been-set-incorrectly
- /resources/dyEMgbMXhgq
- /resources/blog/vss-converter-issue-tf54000-cannot-update-the-data-because-the-server-clock-may-have-been-set-incorrectly
aliasesFor404:
- /vss-converter-issue-tf54000-cannot-update-the-data-because-the-server-clock-may-have-been-set-incorrectly
- /blog/vss-converter-issue-tf54000-cannot-update-the-data-because-the-server-clock-may-have-been-set-incorrectly
- /vss-converter-–-issue--tf54000--cannot-update-the-data-because-the-server-clock-may-have-been-set-incorrectly
- /blog/vss-converter-–-issue--tf54000--cannot-update-the-data-because-the-server-clock-may-have-been-set-incorrectly
- /resources/blog/vss-converter-issue-tf54000-cannot-update-the-data-because-the-server-clock-may-have-been-set-incorrectly
tags:
- configuration
- infrastructure
- kb
- tf54000
- tfs
- tfs2010
- tools
- visual-sourcesafe
categories:
- Azure DevOps
- Problems and Puzzles

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
