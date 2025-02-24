---
title: 'TFS Integration Tools - Issue: TFS WIT bypass-rule submission is enabled'
description: Resolve TFS WIT bypass-rule submission errors with our guide. Learn how to add accounts to the Service Accounts Group and streamline your TFS Integration.
ResourceId: sb9e7R72Ioq
ResourceType: blog
ResourceImport: true
ResourceImportId: 7104
ResourceImportSource: Wordpress
ResourceImportOriginalSource: Wordpress
date: 2012-08-09
creator: Martin Hinshelwood
layout: blog
resourceTypes: blog
slug: tfs-integration-tools-issue-tfs-wit-bypass-rule-submission-is-enabled
aliases:
- /blog/tfs-integration-tools-issue-tfs-wit-bypass-rule-submission-is-enabled
- /tfs-integration-tools-issue-tfs-wit-bypass-rule-submission-is-enabled
- /tfs-integration-tools
- /tfs-integration-tools---issue--tfs-wit-bypass-rule-submission-is-enabled
- /blog/tfs-integration-tools---issue--tfs-wit-bypass-rule-submission-is-enabled
- /resources/sb9e7R72Ioq
- /resources/blog/tfs-integration-tools-issue-tfs-wit-bypass-rule-submission-is-enabled
aliasesFor404:
- /tfs-integration-tools-issue-tfs-wit-bypass-rule-submission-is-enabled
- /blog/tfs-integration-tools-issue-tfs-wit-bypass-rule-submission-is-enabled
- /tfs-integration-tools---issue--tfs-wit-bypass-rule-submission-is-enabled
- /blog/tfs-integration-tools---issue--tfs-wit-bypass-rule-submission-is-enabled
- /tfs-integration-tools
- /resources/blog/tfs-integration-tools-issue-tfs-wit-bypass-rule-submission-is-enabled
tags:
- Troubleshooting
categories:
- DevOps
- Engineering Excellence
preview: metro-problem-icon-5-5.png

---
When you run the TFS Integration Platform for the first time with TFS WIT bypass-rule submission enabled you will likely get the following error:

[![image](images/image_thumb37-2-2.png "image")](http://blog.hinshelwood.com/files/2012/09/image37.png)  
{ .post-img }
**Figure: A Runtime Error**

> Microsoft.TeamFoundation.Migration.Tfs2010WitAdapter.PermissionException: TFS WIT bypass-rule submission is enabled. However, the migration service account 'TFSService' is not in the Service Accounts Group on server 'http://tfsserver:8080/tfs/msf_migrate'.
>
> at Microsoft.TeamFoundation.Migration.Tfs2010WitAdapter.VersionSpecificUtils.CheckBypassRulePermission(TfsTeamProjectCollection tfs)
>
> at Microsoft.TeamFoundation.Migration.Tfs2010WitAdapter.TfsCore.CheckBypassRulePermission()
>
> at Microsoft.TeamFoundation.Migration.Tfs2010WitAdapter.TfsWITMigrationProvider.InitializeTfsClient()
>
> at Microsoft.TeamFoundation.Migration.Tfs2010WitAdapter.TfsWITMigrationProvider.InitializeClient()
>
> at Microsoft.TeamFoundation.Migration.Toolkit.MigrationEngine.Initialize(Int32 sessionRunId)

### ![](images/metro-applies-to-label-3-3.png)Applies To

{ .post-img }

- TFS Integration Platform

### ![](images/metro-findings-label-4-4.png)Findings

{ .post-img }

Only accounts in the Team Foundation Service Accounts are aloud to access the web services directly. By default the account used to install TFS is not added to this group.

In addition you will also be unable to add the account through the UI as editing this group directly is disables. It is meant to be used under the covers for Lab or Build accounts, but the TFS Integration Platform is not an out-of-the-box tool.

[![clip_image002](images/clip_image002_thumb-1-1.jpg "clip_image002")](http://blog.hinshelwood.com/files/2012/08/clip_image002.jpg)  
{ .post-img }
**Figure: You can’t edit Team Foundation Service Accounts**

This is a special group that does not allow you to populate it through the UI. You can however view it and all of the accounts that you use for your Build Agents, Build Controllers and other bits and bobs will all be in this list already.

You need to use the the command line ![Sad smile](images/wlEmoticon-sadsmile-7-7.png)
{ .post-img }

### ![](images/metro-solution-label-6-6.png)Solution

{ .post-img }

Use the tfssecurity.exe tool to update the Service Accounts Group and add the “TfsAdmin”.

[![image](images/image_thumb2.png "image")](http://vsalm.blob.core.windows.net/blog-store/files/2012/07/image2.png)  
{ .post-img }
**Figure: Updating the TFS Security group**

You use our old friend the command line. There is an application called TfsSecurity that will allow you to add an account directly to that group.

```
tfssecurity /g+ "Team Foundation Service Accounts" n:domainusername ALLOW /server:http://myserver:8080/tfs

```

Now you have that sorted you are ready to rock…

**Did this help you?**
