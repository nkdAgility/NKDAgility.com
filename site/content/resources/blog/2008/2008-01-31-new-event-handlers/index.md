---
title: New Event Handlers
description: Discover new event handlers for TFS that enhance work item tracking. Learn how to implement the Assigned To and Reassigned handlers easily!
ResourceId: kofEeioSTH9
ResourceType: blog
ResourceImport: true
ResourceImportId: 258
ResourceImportSource: Wordpress
ResourceImportOriginalSource: GeeksWithBlogs
date: 2008-01-31
weight: 855
creator: Martin Hinshelwood
layout: blog
resourceTypes: blog
slug: new-event-handlers
aliases:
- /blog/new-event-handlers
- /new-event-handlers
- /resources/kofEeioSTH9
- /resources/blog/new-event-handlers
aliasesArchive:
- /blog/new-event-handlers
- /new-event-handlers
- /resources/blog/new-event-handlers
tags:
- Install and Configuration
- Practical Techniques and Tooling
- Software Development
- System Configuration
- Technical Mastery
categories: []
preview: nakedalm-logo-128-link-1-1.png

---
I have added an extra event handler to the [TFS Event Handler (Prototype)](https://www.codeplex.com/Release/ProjectReleases.aspx?ProjectName=TFSEventHandler&ReleaseId=5057), and this makes two.

**Assigned To Handler**

The Assigned to handler send a users an email when a work item is assigned to them unless they did the assigning themselves.

**Reassigned Handler**

The reassigned handler send an email to a user to whom a work item used to be assigned, letting them know that they no longer have that piece of work in their list.

These handlers are easily added to a current deployment and are packaged together. You will need to update the version of your prototype deployment by [downloading](https://www.codeplex.com/Release/ProjectReleases.aspx?ProjectName=TFSEventHandler&ReleaseId=5057) the latest version, but it does fix a number of found bugs.

Once you have the new version, download the Assignment Handlers rar file from the release page and extract them into the "_c:Program FilesRDdotNetRDdotNet Team Server Event Handler (Prototype)EventHandlersWorkItemTracking_" folder.

Stop the "_[TFS](http://msdn2.microsoft.com/en-us/teamsystem/aa718934.aspx "Team Foundation Server") Event Handler (Prototype)_" service and open the "_[RDdotNet](http://www.rddotnet.com "RDdotNet - Reality Dysfunction .NET").TFSEventHandler.exe.config_" file with notepad.

if you want the AssignedToHandler to work ad the following line:

> ```
> <Handler type="RDdotNet.TeamFoundation.WorkItemTracking.AssignedToHandler"
>          assemblyFileName="RDdotNet.TeamFoundation.WorkItemTracking.Assignement.dll"
>          assemblyFileLocation="~EventHandlersWorkItemTracking">
> </Handler>
> ```

And if you want the Reassigned handler to work add the following line:

> <Handler type\="[RDdotNet](http://www.rddotnet.com "RDdotNet - Reality Dysfunction .NET").TeamFoundation.WorkItemTracking.ReAssignedHandler"  
>         assemblyFileName\="[RDdotNet](http://www.rddotnet.com "RDdotNet - Reality Dysfunction .NET").TeamFoundation.WorkItemTracking.Assignement.dll"  
>         assemblyFileLocation\="~EventHandlersWorkItemTracking"\>  
> </Handler\>

[](http://11011.net/software/vspaste)

If you want both to work...then add both...easy.

Technorati Tags: [ALM](http://technorati.com/tags/ALM) [WIT](http://technorati.com/tags/WIT)
