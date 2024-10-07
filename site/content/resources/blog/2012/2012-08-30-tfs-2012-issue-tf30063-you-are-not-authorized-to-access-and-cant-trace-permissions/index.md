---
id: "8018"
title: "TFS 2012 - Issue: TF30063: You are not authorized to access and can’t trace permissions"
date: "2012-08-30"
categories:
  - "problems-and-puzzles"
tags:
  - "puzzles"
  - "tf30063"
  - "tfs"
  - "tfs2012"
coverImage: "metro-problem-icon-7-7.png"
author: "MrHinsh"
layout: blog
resourceType: blog
slug: "tfs-2012-issue-tf30063-you-are-not-authorized-to-access-and-cant-trace-permissions"

aliases:
  - /blog/tfs-2012-issue-tf30063-you-are-not-authorized-to-access-and-cant-trace-permissions
---

No matter what permissions you set or what permissions you have you get a “TF30063: You are not authorized to access /Services/v3.0/LocationService.asmx” in SharePoint 2010.

[![image](images/image_thumb115-1-1.png "image")](http://blog.hinshelwood.com/files/2012/08/image116.png)  
{ .post-img }
**Figure: Errors on the TFS components**

And you have checked all of the usual suspects and even use the new TFS 2012 permission tracing features to no avail.

[![image](images/image_thumb116-2-2.png "image")](http://blog.hinshelwood.com/files/2012/08/image117.png)  
{ .post-img }
**Figure: Cannot trace permissions on this item**

### Applies to

- Visual Studio 2012 Team Foundation Server
- Microsoft SharePoint 2010

### Findings

I don't know how unique my case is, but if you have searched the heck out of “[TF30063: You are not authorized to access LocationService](http://bit.ly/NzeeoM "http://bit.ly/NzeeoM")” and you still can’t find the issue then it is simple.

You do not have permission to read items in TFS from SharePoint!

[![tearing_hair_out-300x271](images/tearing_hair_out-300x271_thumb-8-8.jpg "tearing_hair_out-300x271")](http://blog.hinshelwood.com/files/2012/08/tearing_hair_out-300x271.jpg)  
{ .post-img }
**Figure: Ahhhhhhhhhh**

But I am logged in as the TFS Service account, TFS Administrator account and a SharePoint Farm Admin… how many more permission do I need! Here is the deal… you have a “deny” in your permission list somewhere. Deny takes presidence over any other permission. So if you have a deny high up but an allow lower down then this is just tough… denied. And if it is doing this for all of your users regardless of permissions or groups then I have a suspension that there is some deny high up in TFS. There are only two groups that apply to everyone…

[![image](images/image_thumb117-3-3.png "image")](http://blog.hinshelwood.com/files/2012/08/image118.png)  
{ .post-img }
**Figure: \[TEAM FOUNDATION\]Team Foundation Valid User**

There are two places to look for global deny’s and that is the “Valid User” groups at either the server or at the collection level.

[![image](images/image_thumb118-4-4.png "image")](http://blog.hinshelwood.com/files/2012/08/image119.png)  
{ .post-img }
**Figure: \[DefaultCollection\]Project Collection Valid Users**

In this case we upgraded from Team Foundation Server 2008 to 2012 so any permissions carried over would be at the Collection level, so lets start there…

[![image](images/image_thumb119-5-5.png "image")](http://blog.hinshelwood.com/files/2012/08/image120.png)  
{ .post-img }
**Figure: Really… denied at the Project Collection Level**

I can’t imagine what was trying to be achieved by this… so I will leave you with…

[![ImpliedFacePalm](images/ImpliedFacePalm_thumb-6-6.jpg "ImpliedFacePalm")](http://blog.hinshelwood.com/files/2012/08/ImpliedFacePalm.jpg)
{ .post-img }

