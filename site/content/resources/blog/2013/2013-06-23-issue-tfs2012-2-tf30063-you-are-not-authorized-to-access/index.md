---
title: Issue [ TFS2012.2 ] TF30063 You are not authorized to access
description: Discover how to resolve the TF30063 authorization error in TFS 2012.2 after moving environments. Upgrade to 2012.3 for a seamless experience!
ResourceId: 6o-nqY9A5OP
ResourceType: blog
ResourceImport: true
ResourceImportId: 9910
ResourceImportSource: Wordpress
ResourceImportOriginalSource: Wordpress
date: 2013-06-23
creator: Martin Hinshelwood
layout: blog
resourceTypes: blog
slug: issue-tfs2012-2-tf30063-you-are-not-authorized-to-access
aliases:
- /blog/issue-tfs2012-2-tf30063-you-are-not-authorized-to-access
- /issue-tfs2012-2-tf30063-you-are-not-authorized-to-access
- /issue-[-tfs2012-2-]-tf30063-you-are-not-authorized-to-access
- /blog/issue-[-tfs2012-2-]-tf30063-you-are-not-authorized-to-access
- /resources/6o-nqY9A5OP
- /resources/blog/issue-tfs2012-2-tf30063-you-are-not-authorized-to-access
aliasesFor404:
- /issue-tfs2012-2-tf30063-you-are-not-authorized-to-access
- /blog/issue-tfs2012-2-tf30063-you-are-not-authorized-to-access
- /issue-[-tfs2012-2-]-tf30063-you-are-not-authorized-to-access
- /blog/issue-[-tfs2012-2-]-tf30063-you-are-not-authorized-to-access
- /resources/blog/issue-tfs2012-2-tf30063-you-are-not-authorized-to-access
tags:
- Install and Configuration
- Troubleshooting
- Windows
categories:
- News and Reviews
preview: puzzle-issue-problem-128-link-3-3.png

---
If you have TFS 2012 Update 2 (2012.2) installed you might get an error after you [move Team Foundation Server from one environment to another](http://msdn.microsoft.com/en-us/library/ms404883.aspx) (change domain.)

![image](images/image38-1-1.png "image")  
{ .post-img }
Figure: TF30063 you are not authorised to access server

## Applies to

- Team Foundation Server 2012.2

## Findings

Not only are you unable to change the URL but you are also to edit permissions or in any way connect to TFS even from the server.

![image](images/image39-2-2.png "image")  
{ .post-img }
Figure: TF30063 you are not authorised to access localhost

This is not one that I have encountered before and was at a loss to help the customer. I ran the flag up and got a little help from [Grant Holiday](http://blogs.msdn.com/b/granth/). He identified this as a bug…

## Solution

This bug is fixed in Team Foundation Server 2012.3. 2012.3 is currently  at RC2 but it does come with a Go-Live licence meaning that it is fully supported in production. After installing 2012.3 all of the problems went away and the server started functioning normally.

Woot… yet another reason for 2012.3 and Go-Live…
