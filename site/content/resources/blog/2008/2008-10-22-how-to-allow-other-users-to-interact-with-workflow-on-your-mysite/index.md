---
title: 'How-To: Allow other users to interact with workflow on your MySite'
description: Learn how to give colleagues access to workflow tasks on your MySite by setting permissions on task lists in SharePoint, including adding users to the Contributors group.
date: 2008-10-22
lastmod: 2008-10-22
weight: 1000
sitemap:
  filename: sitemap.xml
  priority: 0.1
  changefreq: weekly
ItemId: JUQrPR1RNmh
ItemType: blog
ItemKind: resource
ItemContentOrigin: Human
slug: how-to-allow-other-users-to-interact-with-workflow-on-your-mysite
aliases:
  - /resources/JUQrPR1RNmh
aliasesArchive:
  - /blog/how-to-allow-other-users-to-interact-with-workflow-on-your-mysite
  - /how-to-allow-other-users-to-interact-with-workflow-on-your-mysite
  - /how-to--allow-other-users-to-interact-with-workflow-on-your-mysite
  - /blog/how-to--allow-other-users-to-interact-with-workflow-on-your-mysite
  - /resources/blog/how-to-allow-other-users-to-interact-with-workflow-on-your-mysite
layout: blog
concepts: []
categories:
  - Uncategorized
tags:
  - Install and Configuration
Watermarks:
  description: 2025-05-13T16:22:58Z
ResourceId: JUQrPR1RNmh
ResourceType: blog
ResourceImportId: 185
creator: Martin Hinshelwood
resourceTypes: blog
preview: metro-sharepoint-128-link-15-15.png

---
If you want to be able to use workflow on you're my site that will allow you to assign tasks to your colleagues, then you need to take a couple of thing into consideration. The most important is to give any users assigned tasks access to the tasks list that you are using for your workflow.

You will need to think hard about wither the workflow you are considering would be better as part of your team's site, or as part of another site in the Sharepoint farm as adding permission to other people on your MySite is a security risk. But the benefit may well be worth the risk.

What we will be doing is adding any users you will be assigning workflow to the "Contributors" group so they will be able to delete tasks.

When you setup your workflow you will be asked what task list you want to use for it. If you selected "New Task List" the system will create a task list of the name "\[Workflow Name\] Tasks".

[![image](images/HowToAllowotheruserstointeractwithworkfl_D4EB-image_thumb_13-5-5.png)](http://blog.hinshelwood.com/files/2011/05/GWB-WindowsLiveWriter-HowToAllowotheruserstointeractwithworkfl_D4EB-image_28.png)
{ .post-img }

You will need to give users permission to this Task list, but you could have multiple task lists to allow more refined permission for different workflows.

[![image](images/HowToAllowotheruserstointeractwithworkfl_D4EB-image_thumb_12-4-4.png)](http://blog.hinshelwood.com/files/2011/05/GWB-WindowsLiveWriter-HowToAllowotheruserstointeractwithworkfl_D4EB-image_26.png)
{ .post-img }

## Finding the task list name

First you need to find the Task list. If you have already setup the workflow, the changes are that you have used the default, which is "Tasks". You can check by going to the list or document library that has the workflow and click the "Settings" tab and then the "Manage" option.

[![image](images/HowToAllowotheruserstointeractwithworkfl_D4EB-image_thumb_11-3-3.png)](http://blog.hinshelwood.com/files/2011/05/GWB-WindowsLiveWriter-HowToAllowotheruserstointeractwithworkfl_D4EB-image_24.png)
{ .post-img }

You will then be presented with all of the options for your list or library. The option you are looking for is the "Workflow Settings" option under "Permissions and Management".

[![image](images/HowToAllowotheruserstointeractwithworkfl_D4EB-image_thumb_10-2-2.png)](http://blog.hinshelwood.com/files/2011/05/GWB-WindowsLiveWriter-HowToAllowotheruserstointeractwithworkfl_D4EB-image_22.png)
{ .post-img }

This will take you to a list of all of the workflows that are currently setup (or the create workflow page if there are none) where you need to select the workflow that you want.

[![image](images/HowToAllowotheruserstointeractwithworkfl_D4EB-image_thumb_9-13-13.png)](http://blog.hinshelwood.com/files/2011/05/GWB-WindowsLiveWriter-HowToAllowotheruserstointeractwithworkfl_D4EB-image_20.png)
{ .post-img }

This will take you to the change a workflow page and you will be able to see the name of the task list, in this case "Example Workflow Tasks".

[![image](images/HowToAllowotheruserstointeractwithworkfl_D4EB-image_thumb_8-12-12.png)](http://blog.hinshelwood.com/files/2011/05/GWB-WindowsLiveWriter-HowToAllowotheruserstointeractwithworkfl_D4EB-image_18.png)
{ .post-img }

Now we have that information we need to return to the top level of your MySite to set the permissions on your Task List.

[![image](images/HowToAllowotheruserstointeractwithworkfl_D4EB-image_thumb_7-11-11.png)](http://blog.hinshelwood.com/files/2011/05/GWB-WindowsLiveWriter-HowToAllowotheruserstointeractwithworkfl_D4EB-image_16.png)
{ .post-img }

## Setting the permissions on a Task list

Now we know the name of the task list we can set the permission on the correct list. Click on the "View All Site Content" button to see a list of all the bits and bobs that have already been created.

[![image](images/HowToAllowotheruserstointeractwithworkfl_D4EB-image_thumb_6-10-10.png)](http://blog.hinshelwood.com/files/2011/05/GWB-WindowsLiveWriter-HowToAllowotheruserstointeractwithworkfl_D4EB-image_14.png)
{ .post-img }

Under the "Lists" Heading you will see the "Example Workflow Tasks" list which is not displayed by default on the left navigation of your MySite homepage. If you click the name you will be taken directly to the list so we can edit the permissions.

[![image](images/HowToAllowotheruserstointeractwithworkfl_D4EB-image_thumb_5-9-9.png)](http://blog.hinshelwood.com/files/2011/05/GWB-WindowsLiveWriter-HowToAllowotheruserstointeractwithworkfl_D4EB-image_12.png)
{ .post-img }

As before we will need to get to the lists options, so click the "List Settings".

[![image](images/HowToAllowotheruserstointeractwithworkfl_D4EB-image_thumb_4-8-8.png)](http://blog.hinshelwood.com/files/2011/05/GWB-WindowsLiveWriter-HowToAllowotheruserstointeractwithworkfl_D4EB-image_10.png)
{ .post-img }

And again under "Permissions and Management" select "Permissions for this list".

[![image](images/HowToAllowotheruserstointeractwithworkfl_D4EB-image_thumb_3-7-7.png)](http://blog.hinshelwood.com/files/2011/05/GWB-WindowsLiveWriter-HowToAllowotheruserstointeractwithworkfl_D4EB-image_8.png)
{ .post-img }

By default all lists created use the same permissions as the parent site. We need to override this so we can set specific permission for our workflow tasks. To enable specific permissions we click the "Edit Permissions" button which makes a copy of the existing permissions and detached the list's permission from your MySite. You will get a warning box to make you aware of this and that any changes to the top level site will no longer affect the permissions of this list.

[![image](images/HowToAllowotheruserstointeractwithworkfl_D4EB-image_thumb_2-6-6.png)](http://blog.hinshelwood.com/files/2011/05/GWB-WindowsLiveWriter-HowToAllowotheruserstointeractwithworkfl_D4EB-image_6.png)
{ .post-img }

You now have the option to delete, edit and add users to **_this list only_** as you would on any site. Add the users who you will be assigning workflow tasks to and delete any others that you do not want access.

[![image](images/HowToAllowotheruserstointeractwithworkfl_D4EB-image_thumb_1-1-1.png)](http://blog.hinshelwood.com/files/2011/05/GWB-WindowsLiveWriter-HowToAllowotheruserstointeractwithworkfl_D4EB-image_4.png)
{ .post-img }

Make sure that you have the correct users listed in the "Users/Groups" box and that you only have the "Contribute" permission enabled. Then decide wither to send people an email to let them know that they now have access.

[![image](images/HowToAllowotheruserstointeractwithworkfl_D4EB-image_thumb-14-14.png)](http://blog.hinshelwood.com/files/2011/05/GWB-WindowsLiveWriter-HowToAllowotheruserstointeractwithworkfl_D4EB-image_2.png)
{ .post-img }

Easy J

Technorati Tags: [MOSS](http://technorati.com/tags/MOSS) [SP 2007](http://technorati.com/tags/SP+2007) [Answers](http://technorati.com/tags/Answers) [SharePoint](http://technorati.com/tags/SharePoint)
