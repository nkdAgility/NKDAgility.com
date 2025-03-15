---
title: Installing Windows SharePoint Services 3.0 Service Pack 1 (SP1)
description: Learn how to install Windows SharePoint Services 3.0 SP1 with ease. Troubleshoot common issues and enhance your SharePoint experience effectively!
ResourceId: kTx0ZCg43dC
ResourceType: blog
ResourceImport: true
ResourceImportId: 275
ResourceImportSource: Wordpress
ResourceImportOriginalSource: GeeksWithBlogs
date: 2007-12-13
weight: 1000
creator: Martin Hinshelwood
layout: blog
resourceTypes: blog
slug: installing-windows-sharepoint-services-3-0-service-pack-1-sp1
aliases:
- /blog/installing-windows-sharepoint-services-3-0-service-pack-1-sp1
- /installing-windows-sharepoint-services-3-0-service-pack-1-sp1
- /installing-windows-sharepoint-services-3-0-service-pack-1-(sp1)
- /blog/installing-windows-sharepoint-services-3-0-service-pack-1-(sp1)
- /resources/kTx0ZCg43dC
- /resources/blog/installing-windows-sharepoint-services-3-0-service-pack-1-sp1
aliasesArchive:
- /blog/installing-windows-sharepoint-services-3-0-service-pack-1-sp1
- /installing-windows-sharepoint-services-3-0-service-pack-1-sp1
- /installing-windows-sharepoint-services-3-0-service-pack-1-(sp1)
- /blog/installing-windows-sharepoint-services-3-0-service-pack-1-(sp1)
- /resources/blog/installing-windows-sharepoint-services-3-0-service-pack-1-sp1
tags:
- Windows
- Install and Configuration
categories: []
preview: metro-sharepoint-128-link-6-6.png

---
- wssv3sp1-kb936988-x86-fullfile-en-us.exe

[http://www.microsoft.com/downloads/details.aspx?FamilyId=4191A531-A2E9-45E4-B71E-5B0B17108BD2&displaylang=en#filelist](http://www.microsoft.com/downloads/details.aspx?FamilyId=4191A531-A2E9-45E4-B71E-5B0B17108BD2&displaylang=en#filelist "http://www.microsoft.com/downloads/details.aspx?FamilyId=4191A531-A2E9-45E4-B71E-5B0B17108BD2&displaylang=en#filelist")

[![image_thumb3](images/InstallingWindowsShareP.0ServicePack1SP1_9B2F-image_thumb3_thumb-2-2.png)](http://blog.hinshelwood.com/files/2011/05/GWB-WindowsLiveWriter-InstallingWindowsShareP.0ServicePack1SP1_9B2F-image_thumb3_2.png)
{ .post-img }

Not realy installing updates, more like unpacking...

[![image_thumb2](images/InstallingWindowsShareP.0ServicePack1SP1_9B2F-image_thumb2_thumb-1-1.png)](http://blog.hinshelwood.com/files/2011/05/GWB-WindowsLiveWriter-InstallingWindowsShareP.0ServicePack1SP1_9B2F-image_thumb2_2.png)
{ .post-img }

Ah, the usual fun... Good thin this is on a dev box otherwise I would need to be restarting services out of hours...or just tell my users it was a tempourary glitch ![smile_wink](images/smile_wink-8-8.gif)
{ .post-img }

[![image_thumb4](images/InstallingWindowsShareP.0ServicePack1SP1_9B2F-image_thumb4_thumb-3-3.png)](http://blog.hinshelwood.com/files/2011/05/GWB-WindowsLiveWriter-InstallingWindowsShareP.0ServicePack1SP1_9B2F-image_thumb4_2.png)
{ .post-img }

Got loads of options, but no way to change them...typical service pack build of the base installer...Not a problem with me, familiar. Makes those production guys feel at home.

[![image_thumb7](images/InstallingWindowsShareP.0ServicePack1SP1_9B2F-image_thumb7_thumb-5-5.png)](http://blog.hinshelwood.com/files/2011/05/GWB-WindowsLiveWriter-InstallingWindowsShareP.0ServicePack1SP1_9B2F-image_thumb7_2.png)
{ .post-img }

_Well, first attempt failed. I will try a reboot and see if there are any pending updates or just general trash interfering. If you have ever had to read a SharePoint install log, you will know that they are next to useless. Roll on TFS install style logs for SharePoint. Hint, hint..._

[![image_thumb5](images/InstallingWindowsShareP.0ServicePack1SP1_9B2F-image_thumb5_thumb-4-4.png)](http://blog.hinshelwood.com/files/2011/05/GWB-WindowsLiveWriter-InstallingWindowsShareP.0ServicePack1SP1_9B2F-image_thumb5_2.png)
{ .post-img }

Uoh..Now this could either be really bad, or really good. I just tried to run WSS 3.0 SP1 again and I was told it was already installed...![smile_sarcastic](images/smile_sarcastic-7-7.gif)
{ .post-img }

UPDATE:

Check out [this post](http://blog.hinshelwood.com/archive/2007/12/31/sharepoint-3.0-and-moss-2007-service-pack-1-update.aspx "Click To View Entry") for a solution that fixed my problems...

Technorati Tags: [SP 2007](http://technorati.com/tags/SP+2007) [SP 2010](http://technorati.com/tags/SP+2010) [SharePoint](http://technorati.com/tags/SharePoint)
