---
title: 'TFS Integration Tools – Issue: Error occurred during the code review of change group'
description: Explains causes and solutions for the "Error occurred during the code review of change group" in TFS Integration Tools, including common triggers and recommended workarounds.
ResourceId: De3YYSzEfJk
ResourceType: blog
ResourceContentOrigin: Human
ResourceImport: true
ResourceImportId: 6117
ResourceImportSource: Wordpress
ResourceImportOriginalSource: Wordpress
date: 2012-07-11
weight: 790
creator: Martin Hinshelwood
layout: blog
resourceTypes: blog
slug: tfs-integration-tools-issue-error-occurred-during-the-code-review-of-change-group
aliases:
- /resources/blog/tfs-integration-tools-issue-error-occurred-during-the-code-review-of-change-group
- /resources/De3YYSzEfJk
aliasesArchive:
- /blog/tfs-integration-tools-issue-error-occurred-during-the-code-review-of-change-group
- /tfs-integration-tools-issue-error-occurred-during-the-code-review-of-change-group
- /tfs-integration-tools-–-issue--error-occurred-during-the-code-review-of-change-group
- /blog/tfs-integration-tools-–-issue--error-occurred-during-the-code-review-of-change-group
- /resources/blog/tfs-integration-tools-issue-error-occurred-during-the-code-review-of-change-group
tags:
- Troubleshooting
categories:
- Uncategorized
preview: metro-problem-icon-2-2.png
Watermarks:
  description: 2025-05-13T15:08:47Z
concepts: []

---
As part of the Migration process the TFS Integration Platform does a whole bunch of checks to make sure that what is being written in indeed what we want to write and what the destination is excepting. as a result, on occasion you will get a “Error occurred during the code review of change group”.

[![7-6-2012 12-52-15 PM](images/7-6-2012-12-52-15-PM_thumb1-1-1.png "7-6-2012 12-52-15 PM")](http://blog.hinshelwood.com/files/2012/07/7-6-2012-12-52-15-PM1.png)  
{ .post-img }
{ .post-img }
**Figure: Error occurred during the code review of change group**

### Applies to

- TFS Integration Tools, version 2.2, March 2012

### Finding

Before the TFS Integration Platform does a checkin it will run a bunch of checks to make sure that everything is on track. If any of those “code review” checks fail then you will receive this error. Even if you are running locally, web services, while robust run inside of IIS and can occasionally drop requests. Stuff happens, and this is not that unusual and in this case can cause a request not to be processed correctly.

### Workaround

Using the “Auto Resolve” will usually fix the problem as it is likely caused b y a glitch in the web. Luckily TFS is an Atomic check-in system and you will not damage your server. Just running the request again will usually result in success.

Once on the rerun I did get another conflict stating that the data being pushed across was already done which is likely the same cause as the first message just on the response and not the request. ![Smile](images/wlEmoticon-smile1-3-3.png)
{ .post-img }
{ .post-img }

**Did this fix your problem?**
