---
title: Removing a dead Solution Deployment from MOSS 2007
description: Learn how to effectively remove a stuck solution deployment in MOSS 2007. Follow our step-by-step guide to resolve deployment issues with ease!
ResourceId: JD6-7WEsi2d
ResourceType: blog
ResourceContentOrigin: Human
ResourceImport: true
ResourceImportId: 155
ResourceImportSource: Wordpress
ResourceImportOriginalSource: GeeksWithBlogs
date: 2008-12-10
weight: 1000
creator: Martin Hinshelwood
layout: blog
resourceTypes: blog
slug: removing-a-dead-solution-deployment-from-moss-2007
aliases:
- /blog/removing-a-dead-solution-deployment-from-moss-2007
- /removing-a-dead-solution-deployment-from-moss-2007
- /resources/JD6-7WEsi2d
- /resources/blog/removing-a-dead-solution-deployment-from-moss-2007
aliasesArchive:
- /blog/removing-a-dead-solution-deployment-from-moss-2007
- /removing-a-dead-solution-deployment-from-moss-2007
- /resources/blog/removing-a-dead-solution-deployment-from-moss-2007
tags:
- Troubleshooting
- Install and Configuration
- Software Development
- System Configuration
preview: metro-sharepoint-128-link-1-1.png
categories: []

---
If, like me, you tried to deploy a solution to Microsoft Office SharePoint Server 2007 and it ether failed or hung you will need to remove it somehow. But once the status has moved to “deploying”, if you receive an error like this:

> Error: The web.config is invalid on this IIS Web Site: C:InetpubwwwrootwssVirtualDirectoriessearch.xxx.xxx.biz80web.config.

You will need to manually remove the job.

To do this, go to the Central Administration portal and under the “Global Configuration” section on the “Operations” tab select “Job Timer definitions”

[![image](images/RemovingadeadSolutionDeploymentfromMOSS2_C4E5-image_thumb-4-4.png)](http://blog.hinshelwood.com/files/2011/05/GWB-WindowsLiveWriter-RemovingadeadSolutionDeploymentfromMOSS2_C4E5-image_2.png)
{ .post-img }

This will take you to a massive list of all the scheduled and on demand jobs. Check down the list to find the job you want to kill, the Deployment operations will have “one-time” in the last column.

![image](images/RemovingadeadSolutionDeploymentfromMOSS2_C4E5-image_thumb_1-2-2.png)
{ .post-img }

Click the title to bring up the job definition and status and you should have the kill switch readily available

[![image](images/RemovingadeadSolutionDeploymentfromMOSS2_C4E5-image_thumb_2-3-3.png)](http://blog.hinshelwood.com/files/2011/05/GWB-WindowsLiveWriter-RemovingadeadSolutionDeploymentfromMOSS2_C4E5-image_6.png)
{ .post-img }

Once killed you can check the deployments page and you will see that there is nothing trying to “deploy”.

Technorati Tags: [MOSS](http://technorati.com/tags/MOSS) [SharePoint](http://technorati.com/tags/SharePoint)
