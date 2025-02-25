---
title: TFS Event Handler v1.3 released
description: Discover the enhanced TFS Event Handler v1.3, simplifying notifications for Team Foundation Server users. Streamline alerts and improve team collaboration!
ResourceId: 5utkJgImhFT
ResourceType: blog
ResourceImport: true
ResourceImportId: 158
ResourceImportSource: Wordpress
ResourceImportOriginalSource: GeeksWithBlogs
date: 2008-12-02
creator: Martin Hinshelwood
layout: blog
resourceTypes: blog
slug: tfs-event-handler-v1-3-released
aliases:
- /blog/tfs-event-handler-v1-3-released
- /tfs-event-handler-v1-3-released
- /resources/5utkJgImhFT
- /resources/blog/tfs-event-handler-v1-3-released
aliasesArchive:
- /blog/tfs-event-handler-v1-3-released
- /tfs-event-handler-v1-3-released
- /resources/blog/tfs-event-handler-v1-3-released
tags:
- Practical Techniques and Tooling
- Software Development
preview: nakedalm-logo-128-link-1-1.png
categories: []

---
Updated and improved for Team System 2008.

[![vsts_thumb[2]](images/TFSEventHandlerv1.3released_9AE8-vsts_thumb2_-2-2.png)](/Users/martihins/AppData/Local/Temp/WindowsLiveWriter1286139640/supfiles13CE4A31/vsts2.png)
{ .post-img }

[http://www.codeplex.com/TFSEventHandler](http://www.codeplex.com/TFSEventHandler "http://www.codeplex.com/TFSEventHandler")

The TFS Event Handler makes it easier to notify users of changes to Work Items in Team Foundation Server. You will no longer need to add individual alerts to users.

It is developed in .NET 3.5 SP1 for Team Foundation Server 2008 and is deployed as a system service.

**I have added support for groups. If you add a TFS group into the Assigned To drop down all members of that group will receive notifications!**

You will need to allow groups in your Assigned to list. Below is a snippet from me Bug work item type as it stands at the moment.

```
   1: <FIELD reportable="dimension" type="String" name="Assigned To" refname="System.AssignedTo">
```

```
   2:     <HELPTEXT>The person assigned to act on the bug, either to fix it or to verify the fix</HELPTEXT>
```

```
   3:     <ALLOWEXISTINGVALUE />
```

```
   4:     <ALLOWEDVALUES filteritems="excludegroups">
```

```
   5:         <LISTITEM value="[project]Contributors" />
```

```
   6:     </ALLOWEDVALUES>
```

```
   7: </FIELD>
```

You can see on line 4 that there is a filter for excluding the groups from the list. If you are using [TFS Event Handler](http://codeplex.com/tfseventhandler) v1.0 or v1.1 then you will need this line. If you install the new [TFS Event Handler](http://codeplex.com/tfseventhandler) v1.3 then you will be able to remove that and start assigning work items to Groups.

**Note: Although they will now get an email, the work item will not appear in their “My Work items” query. You may want to consider creating a Query for each Group.**

The Alerts that you no longer need users to individually setup are:

- A work item is assigned to you, or a group you are a member of.

- A work item that is assigned to you, or a group you are a member of is, reassigned to someone else.

- A work item that you created is assigned to someone else, or a group.

There is also a framework for [creating and deploying your own event handlers](http://www.codeplex.com/TFSEventHandler/Wiki/View.aspx?title=TFS%20Event%20Handlers%20v1.0&referringTitle=Home) that can do pretty much whatever you want. One of the shipped examples updates “Heat ITSM” whenever a work item that contains a Heat Id is changed.

Technorati Tags: [ALM](http://technorati.com/tags/ALM) [TFS Custom](http://technorati.com/tags/TFS+Custom) [WIT](http://technorati.com/tags/WIT) [TFS](http://technorati.com/tags/TFS)
