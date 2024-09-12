---
id: "155"
title: "Removing a dead Solution Deployment from MOSS 2007"
date: "2008-12-10"
tags: 
  - "moss2007"
  - "sharepoint"
  - "tools"
coverImage: "metro-sharepoint-128-link-1-1.png"
author: "MrHinsh"
type: "post"
slug: "removing-a-dead-solution-deployment-from-moss-2007"
---

If, like me, you tried to deploy a solution to Microsoft Office SharePoint Server 2007 and it ether failed or hung you will need to remove it somehow. But once the status has moved to “deploying”, if you receive an error like this:

> Error: The web.config is invalid on this IIS Web Site: C:InetpubwwwrootwssVirtualDirectoriessearch.xxx.xxx.biz80web.config.

You will need to manually remove the job.

To do this, go to the Central Administration portal and under the “Global Configuration” section on the “Operations” tab select “Job Timer definitions”

[![image](images/RemovingadeadSolutionDeploymentfromMOSS2_C4E5-image_thumb-4-4.png)](http://blog.hinshelwood.com/files/2011/05/GWB-WindowsLiveWriter-RemovingadeadSolutionDeploymentfromMOSS2_C4E5-image_2.png)

This will take you to a massive list of all the scheduled and on demand jobs. Check down the list to find the job you want to kill, the Deployment operations will have “one-time” in the last column.

![image](images/RemovingadeadSolutionDeploymentfromMOSS2_C4E5-image_thumb_1-2-2.png)

Click the title to bring up the job definition and status and you should have the kill switch readily available

[![image](images/RemovingadeadSolutionDeploymentfromMOSS2_C4E5-image_thumb_2-3-3.png)](http://blog.hinshelwood.com/files/2011/05/GWB-WindowsLiveWriter-RemovingadeadSolutionDeploymentfromMOSS2_C4E5-image_6.png)

Once killed you can check the deployments page and you will see that there is nothing trying to “deploy”.

Technorati Tags: [MOSS](http://technorati.com/tags/MOSS) [SharePoint](http://technorati.com/tags/SharePoint)


