---
id: "357"
title: "Installing the .NET Framework 3.5 Beta 2 on Vista"
date: "2007-07-29"
categories:
  - "code-and-complexity"
tags:
  - "visual-studio"
  - "vs2008"
coverImage: "metro-visual-studio-2005-128-link-1-1.png"
author: "MrHinsh"
type: blog
slug: "installing-the-net-framework-3-5-beta-2-on-vista"
---

As you may have seen from my previous [post](http://blog.hinshelwood.com/archive/2007/07/27/Installing-Visual-Studio-2008-Beta-2.aspx "Installing Visual Studio 2008 Beta 2 on XP"), I have just installed VS2008B2 onto my old work computer, well it is now time to hit my Vista laptop with it:

I just tried to install Visual Studio 2008 Team Suit on my Vista laptop, but it failed on the first hurdle; installing the .NET Framework 3.5 Beta 2

After an hour of searching the web for answers and trying about three different options, finding about ten more, and getting increasingly frustrated, I gave up for a while...

On my second attempt I managed to find a solution: I switched to trying to install the .NET Framework 3.5 Beta 2 on its own because it starts quicker than the full Visual Studio install process.

**The Solution**

In order to install the .NET Framework 3.5 Beta 2 on Vista I had to uninstall some previously installed Hotfixes using these instructions:

> 1\. Open the Control Panel, select Programs & Features, click on the “View installed updates” located on the Tasks pane. Select and uninstall the following Windows updates:
>
> \- Hotfix for Microsoft Windows (KB110806)
>
> \- Hotfix for Microsoft Windows (KB930264)
>
> \- Hotfix for Microsoft Windows (KB929300)
>
> 2\. Reboot
>
> 3\. Reattempts installing .NET Framework 3.5.
>
> [From MSDN Forum post](http://forums.microsoft.com/MSDN/ShowPost.aspx?PostID=1705630&SiteID=1&pageid=0#1734475 "Re: [ ERROR ] Can't install .NET Framework 3.5") by [Gus Perez](http://blogs.msdn.com/gusperez/)

I did however find more that one hotfix with the same KB number, so I got rid of them both.

After this I tried VS2008 again...

Technorati Tags: [ALM](http://technorati.com/tags/ALM) [VS 2008](http://technorati.com/tags/VS+2008)
