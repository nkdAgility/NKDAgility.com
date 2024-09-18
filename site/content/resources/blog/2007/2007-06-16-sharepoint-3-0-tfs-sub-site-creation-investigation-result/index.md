---
id: "383"
title: "Sharepoint 3.0 TFS Sub-Site creation investigation result"
date: "2007-06-16"
tags: 
  - "sharepoint"
  - "sp2007"
  - "tfs"
  - "tfs2005"
coverImage: "metro-visual-studio-2005-128-link-1-1.png"
author: "MrHinsh"
type: "post"
slug: "sharepoint-3-0-tfs-sub-site-creation-investigation-result"
---

Well my [sub site investigation](http://blog.hinshelwood.com/archive/2007/06/07/SharePoint-3.0-TFS-Sub-Site-creation-error.aspx) did not go too well! After consulting with blogs, forums and Microsoft the end result is that it will not work in an automated way. You can't create a sub site to and existing site with Sharepoint without customizing the Sharepoint site creation process, which I am not going to get into at the moment. Maybe later. The best I can hope for at this time is to disable the creation of the Sharepoint site during the project creation process and to create the site manually after the project has been created. Although this adds a manual step to the process this is not a problem for us as there are only 2 users allowed to create new projects in our environment.

Extending the project creation wizard may not be that hard! I have only looked at the [examples](http://msdn.microsoft.com/library/default.asp?url=/library/en-us/Extensibility_Guided_Tour/Extending%20Project%20Creation.asp), but it looks doable.  Just don't have the time at the moment as I am trying to concentrate on the [TFS Event Handler](http://www.codeplex.com/TFSEventHandler).

I will just have to add it to my [Wish list of TFS Tools](http://blog.hinshelwood.com/archive/2007/06/06/My-Wish-List-of-Team-Foundation-Server-Tools.aspx)...

Technorati Tags: [SP 2007](http://technorati.com/tags/SP+2007)



