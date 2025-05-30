---
title: Windows Live ID and OpenID
description: Explains how to set up and link a Windows Live ID with OpenID for testing, enabling single sign-on and unified authentication across supported web services like Plaxo.
ResourceId: OsETJoX5w_V
ResourceType: blog
ResourceContentOrigin: Human
ResourceImport: true
ResourceImportId: 165
ResourceImportSource: Wordpress
ResourceImportOriginalSource: GeeksWithBlogs
date: 2008-11-19
weight: 1000
creator: Martin Hinshelwood
layout: blog
resourceTypes: blog
slug: windows-live-id-and-openid
aliases:
- /resources/OsETJoX5w_V
aliasesArchive:
- /blog/windows-live-id-and-openid
- /windows-live-id-and-openid
- /resources/blog/windows-live-id-and-openid
tags: []
categories:
- Uncategorized
preview: nakedalm-logo-128-link-7-1.png
Watermarks:
  description: 2025-05-13T16:22:25Z
concepts: []

---
It seams that Microsoft is making an attempt to integrate with OpenID. With the announcement that “[Windows Live ID commits to support of OpenID](http://winliveid.spaces.live.com/Blog/cns!AEE1BB0D86E23AAC!1745.entry)” I thought a little investigation would be in order.

You need to setup a new Live ID on the Live-INT service, you can use any email, but make sure that you do not use your production password!

- Go to [https://login.live-INT.com/](https://login.live-INT.com/) and use the sign-up button to set up a Windows Live ID test account in the INT environment.
- Go to [https://login.live-int.com/beta/ManageOpenID.srf](https://login.live-int.com/beta/ManageOpenID.srf) to set up your OpenID test alias.
  [![image](images/WindowsLiveIDandOpenID_9E73-image_thumb-6-7.png)](http://blog.hinshelwood.com/files/2011/05/GWB-WindowsLiveWriter-WindowsLiveIDandOpenID_9E73-image_2.png)
  { .post-img }
  You alias will be “http://openid.live-int.com/\[yourAlias\].

      You can then associate an open ID with a site. Here is the experience with Plaxo:

      [![image](images/WindowsLiveIDandOpenID_9E73-image_thumb_1-1-2.png)](http://blog.hinshelwood.com/files/2011/05/GWB-WindowsLiveWriter-WindowsLiveIDandOpenID_9E73-image_4.png)

  { .post-img }
  From the Plaxo homepage, click “Settings”…

      [![image](images/WindowsLiveIDandOpenID_9E73-image_thumb_2-2-3.png)](http://blog.hinshelwood.com/files/2011/05/GWB-WindowsLiveWriter-WindowsLiveIDandOpenID_9E73-image_6.png)

  { .post-img }
  Then select “Identities” and “Manage your OpenID’s”.

      [![image](images/WindowsLiveIDandOpenID_9E73-image_thumb_3-3-4.png)](http://blog.hinshelwood.com/files/2011/05/GWB-WindowsLiveWriter-WindowsLiveIDandOpenID_9E73-image_8.png)

  { .post-img }
  You can then attach any number of OpenIDs to your Plaxo account. So lets click “Attach a new OpenID”.

      [![image](images/WindowsLiveIDandOpenID_9E73-image_thumb_5-4-5.png)](http://blog.hinshelwood.com/files/2011/05/GWB-WindowsLiveWriter-WindowsLiveIDandOpenID_9E73-image_12.png)

  { .post-img }
  And then “SignIn”.

      [![image](images/WindowsLiveIDandOpenID_9E73-image_thumb_7-5-6.png)](http://blog.hinshelwood.com/files/2011/05/GWB-WindowsLiveWriter-WindowsLiveIDandOpenID_9E73-image_16.png)

  { .post-img }
  This is where Windows Live takes over from the main sites, and you enter your password for your Live account.

      I am hoping that they will be releasing a version that works for .NET applications and not just websites. This would allow application developers to join the ranks of interconnected authentication application with single sign-on.

      It is a dream I have…

      Technorati Tags: [Windows Live](http://technorati.com/tags/Windows+Live),[OpenID](http://technorati.com/tags/OpenID)
