---
id: "3717"
title: "Upgrading your Process Template in Team Foundation Server"
date: "2011-07-28"
categories: 
  - "tools-and-techniques"
  - "upgrade-and-maintenance"
tags: 
  - "configuration"
  - "infrastructure"
  - "nwcadence"
  - "process"
  - "tfs"
  - "tfs2005"
  - "tfs2008"
  - "tfs2010"
  - "tfs2012"
  - "tfs2012-1"
  - "tools"
coverImage: "nakedalm-experts-visual-studio-alm-4-4.png"
author: "MrHinsh"
type: blog
slug: "do-you-know-how-to-upgrade-a-process-template-but-still-keep-your-data-intact"
---

Upgrading your Process Template in Team Foundation Server regardless of the version is pretty hard to achieve. Think of it like changing your mind on the blueprints of a building after you have finished construction. If you are making a small change, like adding a field, then this will be easy. But if you want to fundamentally change the structure of your work items and their workflow then you are looking at a bigger and much more complicated solution.

- Update 2012-05 - Added #7 to the list
- Update 2012-12 – Fixed layout and omissions noted by [Jesse Houwing](http://blog.jessehouwing.nl)
- Update 2012-12 - Updated for TFS 2012

* * *

Here are the 6 7 8 ways to change the Process Template that I have used and all of their pros and cons. Some are easy to implement but may not fit your needs while others have a massive time penalty that you may not be willing to accept. Take my advice and try to implement the simplest solution that you can. Most failed Process Template changes are due to the complexity of the restrictions put in place by folks that don't actually understand what they are asking for. I will often use the above construction metaphor to help customers understand what we are talking about in lue of a solution from the product team that is currently Under Review: [Allow for updating project templates on existing projects in TFS](http://visualstudio.uservoice.com/forums/121579-visual-studio/suggestions/2105201-allow-for-updating-project-templates-on-existing-p) (add your vote if you have any left)

The complexity of the change will depend on the scale and scope of the changes that you have made to your process template and the instance that is used in the Team Project. I would always recommend consolidating your organisation to a single process template as the two evils of maintaining TFS are; Wildly divergent process instances regardless of the original template; what I like to call frankin-templates. Work Items that have been so heavily customised as to be practically unusable by those they are meant for.

There are specific changes, namely worflow and state changes, that will limit your choices severely and you should be aware of all of the ramifications before you make any changes. I would go so far as to say that if you are going to make changes other than just adding some simple fields that you create a set of CodedUI tests for all of your Users paths through the workflow and run a bank of those tests every time you make a change to make sure that you have not broken a necessary activity that folks already use.

If you are making incremental changes to the process that you are already using you can likely upgrade with no issues nor data loss by simply overwriting the new work item types over the old ones. However, if you are making large fundamental changes to the way that the template works (e.g. SfTSv2 to MSF Agile 5.0) then you need another approach:

## #1 Do nothing (0 hours)

![Lazy the Smurph](images/lazy-3-3.jpg "Lazy")
{ .post-img }

Sticking with same template is not a good option as everyone wants to take advantage of the new features.

- Pro Little or no work to achieve
- Con You have to use the old template
    
    Note this is not a con unless there is some feature that people want
    

## #1.1 Enable new features only (5 minutes)

In this scenario you keep the same process template but you "inject" the new platform features. This was done in TFS 2010 with a batch file and in 2012 the Product Team built in a basic capability to the web UI for those that have not modified their process templates much.

- Pro Little or no work to achieve
- Con Same old process in new clothing

Note Does not work if you have made modifications to the workflow

## #2 Create a new Team Project (.5 hours)

![Ripped scroll](images/SNAGHTMLaea788_thumb-5-5.png "Broken history")
{ .post-img }

This is tantamount to doing nothing, but you are using the new process template. You just have to be willing to leave all of your data behind. The real problem here is that with TFS 2010 a “move” or “rename” of files actually results in a “branch” and then a “delete” action that breaks the history chain for folders. The history is still intact, but it only exists on the old Team Project and is deleted or if the permissions are changed then the history is lost.

- Pro Minimal commitment
- Pro Retain access to historical reporting
- Con You are leaving your history behind on the old project
    
    Note reports may be different anyway so this may not be such a bad idea for WI
    
- Con You have to do a move (“Branch” + “Delete”) operation and disconnect you history
    
    Note This really sucks for version control
    

## #3 Destroy all Work Items and Import new ones (2-3 hours)

![Explosion](images/kaboom_256-2-2.jpg "Kaboom")
{ .post-img }

In this scenario you loose all existing Work Item data, but you have not moved your source code, so no nasty history chain.

How-To [Process Template Upgrade #3 - Destroy all Work Items and Import new ones](http://blog.hinshelwood.com/process-template-upgrade-3-destroy-all-work-items-and-import-new-ones/)

- Pro New template with clean data
- Pro no disconnect of version control history
- Con No history on work items (all existing data is lost)

## #4 Use the TFS Integration Platform to move Source and Work Item history to a new team project (1-2 days)

![a distorted clock](images/time-dilation-7-7.jpg "Time-Dilation")
{ .post-img }

This is an ideal solution, but it does result in “time dilation” on your source control. There is no way to fake a check-in date so all dates will be when the actual check-in happens. As the TFS Integration Platform does all of the check-ins concurrently it stores the original date in the comment.

- Pro Keeps all history for both Work Items and Version Control
- Con Time dilation effect, rather like traveling to Alpha Centauri at Light speed; this affects both Work Item and Version Control
    
    Note there are ways to fix this for work items and reporting
    
    Note If you care about this for Version Control you are likely doing something wrong!
    

## #5 Do an in place manual migration (1-¥ days)

![One way sign with a double ended arrow](images/image4-1-1.png "Confusion")
{ .post-img }

This is just plane nasty and take a lot of time. It can take over 8 hours to complete the migration once it has been planned out, and that time depends on the process template you are moving from, the one you are moving to, and the customisations you have made along the way. If all of your Team Projects have different customisations, then this is probably a non-starter.

- Pro Keeps all of your data intact with renames of fields and work item types
- Con Takes a really, really long time
    
    Note There are many circumstance where this is not possible  
    note: Even our most technical TFS Consultant takes 1-2 days to do this (I have never done this)
    

## #6 Do an in-place _export_ migration.

![One arrow going up and another going down](images/sync-6-6.png "Export & Import")
{ .post-img }

This gives us the best of both worlds, with an export of Work Item data to another location, destroying all the existing work item types along with all of the data, then install the new Work Item Types and reload the data. This is still a horrible process, but it keeps the Source Code history intact, and allows for the process template to be completely upgraded.

- Pro Keeps all of your data intact will a small modification to fix time dilation on work items
- Con Takes a really, really long time
    
    Note There are many circumstance where this is not possible
    
    Note Even our most technical TFS Consultant takes 1-2 days to do this (I have never done this)
    

## #7 Rename Work Items and Import new ones (4-5 hours) (Recommended)

![trophy](images/trophy-8-8.jpg "trophy")In this scenario you get to keep all of the history in tact and also get to start afresh with new work item types. It is almost the best of both worlds as you don’t need to move Source Control nor do you end up with new Work Item ID’s.
{ .post-img }

How-To [Process Template Upgrade #7 – Overwrite retaining history with limited migration](http://blog.hinshelwood.com/process-template-upgrade-7-overwrite-retaining-history-with-limited-migration/)

- Pro New template with clean data
- Pro No disconnect of version control history
- Pro History on work items (all existing data accessible through history tab)
- Con leaves old legacy fields in the template

## Conclusion

For me options #7 is the most appropriate for most circumstances and is part of my default arsenal. The rest I only use if I have to, but if a customer is happy with #1, #2 or #3 then I am unlikely to argue as they are easy to implement.


