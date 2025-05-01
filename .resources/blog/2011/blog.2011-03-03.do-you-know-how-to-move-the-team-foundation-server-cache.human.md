---
title: Do you know how to move the Team Foundation Server cache
description: Learn how to efficiently move the Team Foundation Server cache to optimize server space and improve performance with this easy step-by-step guide.
ResourceId: aF0H8q5h-Yg
ResourceType: blog
ResourceContentOrigin: Human
ResourceImport: true
ResourceImportId: 9894
ResourceImportSource: Wordpress
ResourceImportOriginalSource: Wordpress
date: 2011-03-03
weight: 840
creator: Martin Hinshelwood
layout: blog
resourceTypes: blog
slug: do-you-know-how-to-move-the-team-foundation-server-cache
aliases:
- /resources/aF0H8q5h-Yg
aliasesArchive:
- /blog/do-you-know-how-to-move-the-team-foundation-server-cache
- /do-you-know-how-to-move-the-team-foundation-server-cache
- /resources/blog/do-you-know-how-to-move-the-team-foundation-server-cache
tags:
- Install and Configuration
- Windows
- System Configuration
categories:
- Uncategorized

---
[![question mark](images/Do-you-know-how-to-move-the-Team-Foundat_DD94-ErrorOcurred1_thumb-1-1.jpg)](http://blog.hinshelwood.com/files/2011/05/GWB-Windows-Live-Writer-Do-you-know-how-to-move-the-Team-Foundat_DD94-ErrorOcurred1_2.jpg)There are a number of reasons why you may want to change the folder that you store the TFS Cache. It can take up “some” amount of room so moving it to another drive can be beneficial. This is the source control Cache that TFS uses to cache data from the database.
{ .post-img }

---

Moving the Cache is pretty easy and should allow you to organise your server space a little more efficiently. You may also get a performance improvement (although small) by putting it on another drive..

1.  Create a new directory to store the Cache. e.g. “d:TfsCache”
    [![SNAGHTML1b76e16](images/Do-you-know-how-to-move-the-Team-Foundat_DD94-SNAGHTML1b76e16_thumb-3-3.png)](http://blog.hinshelwood.com/files/2011/05/GWB-Windows-Live-Writer-Do-you-know-how-to-move-the-Team-Foundat_DD94-SNAGHTML1b76e16.png) **Figure: Create a new folder**
    { .post-img }
2.  Give the local TFS WPG group full control of the directory
    [![image](images/Do-you-know-how-to-move-the-Team-Foundat_DD94-image_thumb_1-2-2.png)](http://blog.hinshelwood.com/files/2011/05/GWB-Windows-Live-Writer-Do-you-know-how-to-move-the-Team-Foundat_DD94-image_4.png) **Figure: You need to use the App Tier Service WPG**
    { .post-img }
3.  In the application tier web.config (~Application TierWeb Servicesweb.config) add the following setting (to the appSettings section).
    [![SNAGHTML1be463c](images/Do-you-know-how-to-move-the-Team-Foundat_DD94-SNAGHTML1be463c_thumb-4-4.png)](http://blog.hinshelwood.com/files/2011/05/GWB-Windows-Live-Writer-Do-you-know-how-to-move-the-Team-Foundat_DD94-SNAGHTML1be463c.png) **Figure: The web.config for TFS is stored in the application folder**
    { .post-img } > ` > <appsettings>

    >     ...
    >     <add value="D:" key="dataDirectory" />
    >     ...
    >
    > </appsettings>
    > `

        **Figure: Adding this to the web.config will trigger a restart of the app pool**

        [![SNAGHTML1c223fd](images/Do-you-know-how-to-move-the-Team-Foundat_DD94-SNAGHTML1c223fd_thumb-5-5.png)](http://blog.hinshelwood.com/files/2011/05/GWB-Windows-Live-Writer-Do-you-know-how-to-move-the-Team-Foundat_DD94-SNAGHTML1c223fd.png)

    { .post-img }
    **Figure: Your web.config should look something like this**

4.  The app pool will automatically recycle and Team Web Access will start using the new location.

If you then download a file (not via a proxy) a folder with a GUID should be created immediately in the folder from #1.  If the folder doesn’t appear, then you probably don’t have permissions set up properly.
