---
title: Installing Visual Studio 2008 Team Suite on Windows 7
description: "Learn how to install Visual Studio 2008 Team Suite on Windows 7 with step-by-step guidance, troubleshooting tips, and insights for a smooth setup experience."
date: 2009-01-09
creator: Martin Hinshelwood
id: "147"
layout: blog
resourceType: blog
slug: installing-visual-studio-2008-team-suite-on-windows-7
aliases:
  - /blog/installing-visual-studio-2008-team-suite-on-windows-7
tags:
  - tools
  - visual-studio
  - vs2008
preview: metro-visual-studio-2005-128-link-9-9.png
---

I am installing VS2008 in a virtual environment, so this may not be exactly what you would get, but the purpose is to identify if VS2008 does indeed work on Windows 7 and what the experience is like.

The first problem is that the auto run does not seam to function.

[![Windows 7 with Visual Studio 2008: Auto-Run](images/InstallingVisualStudio2008TeamSuitonWind_C6BE-image_thumb-8-8.png)](http://blog.hinshelwood.com/files/2011/05/GWB-WindowsLiveWriter-InstallingVisualStudio2008TeamSuitonWind_C6BE-image_2.png)
{ .post-img }

This can be rectified by browsing the CD / Image and running setup.exe

[![Windows 7 with Visual Studio 2008: Setup](images/InstallingVisualStudio2008TeamSuitonWind_C6BE-image_thumb_1-1-1.png)](http://blog.hinshelwood.com/files/2011/05/GWB-WindowsLiveWriter-InstallingVisualStudio2008TeamSuitonWind_C6BE-image_4.png)
{ .post-img }

So far so good.

[![Windows 7 with Visual Studio 2008: Welcome to the Microsoft Visual Studio 2008 installation wizard](images/InstallingVisualStudio2008TeamSuitonWind_C6BE-image_thumb_2-2-2.png)](http://blog.hinshelwood.com/files/2011/05/GWB-WindowsLiveWriter-InstallingVisualStudio2008TeamSuitonWind_C6BE-image_6.png)
{ .post-img }

After you have accepted the licence agreement you need to select the installation components.

[![Windows 7 with Visual Studio 2008: Welcome to the Microsoft Visual Studio 2008 feature selection](images/InstallingVisualStudio2008TeamSuitonWind_C6BE-image_thumb_3-3-3.png)](http://blog.hinshelwood.com/files/2011/05/GWB-WindowsLiveWriter-InstallingVisualStudio2008TeamSuitonWind_C6BE-image_8.png)
{ .post-img }

I am selecting Full so we can make sure it all goes on, but usually I remove SQL Express as I would add SQL Server developer edition later.

[![Windows 7 with Visual Studio 2008: Welcome to the Microsoft Visual Studio 2008 Installing Components](images/InstallingVisualStudio2008TeamSuitonWind_C6BE-image_thumb_4-4-4.png)](http://blog.hinshelwood.com/files/2011/05/GWB-WindowsLiveWriter-InstallingVisualStudio2008TeamSuitonWind_C6BE-image_10.png)
{ .post-img }

It’s that guy again :), we need to let this cook for “some time, or considerably longer”…

[![Windows 7 with Visual Studio 2008: Welcome to the Microsoft Visual Studio 2008 Installing Components](images/InstallingVisualStudio2008TeamSuitonWind_C6BE-image_thumb_5-5-5.png)](http://blog.hinshelwood.com/files/2011/05/GWB-WindowsLiveWriter-InstallingVisualStudio2008TeamSuitonWind_C6BE-image_12.png)
{ .post-img }

Some time later….

[![Windows 7 with Visual Studio 2008: Welcome to the Microsoft Visual Studio 2008 Install Complete](images/InstallingVisualStudio2008TeamSuitonWind_C6BE-image_thumb_6-6-6.png)](http://blog.hinshelwood.com/files/2011/05/GWB-WindowsLiveWriter-InstallingVisualStudio2008TeamSuitonWind_C6BE-image_14.png)
{ .post-img }

After some 2 hours (remember I am in a virtual computer)

I now have Visual Studio 2008 Team Suit installed…

[![Windows 7 with Visual Studio 2008: Welcome to the Microsoft Visual Studio 2008](images/InstallingVisualStudio2008TeamSuitonWind_C6BE-image_thumb_7-7-7.png)](http://blog.hinshelwood.com/files/2011/05/GWB-WindowsLiveWriter-InstallingVisualStudio2008TeamSuitonWind_C6BE-image_16.png)
{ .post-img }

I will need to service pack it and check functionality, probably by working on the [TFS Sticky Buddy](http://codeplex.com/tfsstickybuddy) project on it and making sure that I an still deploy and run on other platforms! That is for another day though…

Technorati Tags: [Windows](http://technorati.com/tags/Windows) [ALM](http://technorati.com/tags/ALM) [VS 2008](http://technorati.com/tags/VS+2008) [TFS](http://technorati.com/tags/TFS)

