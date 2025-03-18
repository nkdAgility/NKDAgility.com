---
title: TFS Event Handler for Team Foundation Server 2010
description: Explore the new TFS Event Handler for Team Foundation Server 2010, designed for efficient event processing and enhanced integration. Join the discussion today!
ResourceId: _WmwS96RyDS
ResourceType: blog
ResourceContentOrigin: Human
ResourceImport: true
ResourceImportId: 33
ResourceImportSource: Wordpress
ResourceImportOriginalSource: GeeksWithBlogs
date: 2010-07-07
weight: 855
creator: Martin Hinshelwood
layout: blog
resourceTypes: blog
slug: tfs-event-handler-for-team-foundation-server-2010
aliases:
- /blog/tfs-event-handler-for-team-foundation-server-2010
- /tfs-event-handler-for-team-foundation-server-2010
- /resources/_WmwS96RyDS
- /resources/blog/tfs-event-handler-for-team-foundation-server-2010
aliasesArchive:
- /blog/tfs-event-handler-for-team-foundation-server-2010
- /tfs-event-handler-for-team-foundation-server-2010
- /resources/blog/tfs-event-handler-for-team-foundation-server-2010
tags:
- Software Development
- Practical Techniques and Tooling
categories: []
preview: metro-binary-vb-128-link-3-3.png

---
I am looking at re-working the [TFS](http://msdn2.microsoft.com/en-us/teamsystem/aa718934.aspx "Team Foundation Server") Event Handler and I was hoping that you would help me decide what handlers to build!

\[[Request an event handler](http://tfseventhandler.codeplex.com/WorkItem/Create.aspx?ProjectName=TFSEventHandler)\]

The original Event Handler sends emails when:

- A work item is assigned to you
- A work item that is assigned to you is reassigned to someone else
- A work item that you created is assigned to someone else.

The TFS Event Handler that I built for Team Foundation Server 2005 and Team Foundation Server 2008 used a service subscription to then handle events in a separate service host. This posed its own problems of writing the wrapper, API and host for the handlers. Well, now the Team Foundation Server team have stepped up and created their own.

The new TFS Event Handler will use these new Server Event Sinks to process the events more efficiently and quickly, but there is also the option to handle certain decision points on the server. This opens the window for Server Side check-in policies as well as a whole host of other options. These events should run more efficiently and benefit from the entire TFS Object Model that was extremely inefficient to load in the old Event Handlers.

There are lots of new integration points so I have listed all of the events here so you can get an idea what can be achieved.

\[[Request an event handler](http://tfseventhandler.codeplex.com/WorkItem/Create.aspx?ProjectName=TFSEventHandler)\]

<table border="1" cellspacing="0" cellpadding="2"><tbody><tr><td valign="top" width="230"><strong>Version Control</strong></td><td valign="top" width="63"><strong>Decision</strong></td><td valign="top" width="108"><strong>Notification</strong></td></tr><tr><td valign="top" width="230">CheckinNotification</td><td valign="top" width="63"><img style="margin: 0px 20px" alt="Has this feature" src="images/GWB-5366-o_Tick-icon-2-2.png"></td><td valign="top" width="108"><img style="margin: 0px 20px" alt="Has this feature" src="images/GWB-5366-o_Tick-icon-2-2.png"></td></tr><tr><td valign="top" width="230">PendChangesNotification</td><td valign="top" width="63"><img style="margin: 0px 20px" alt="Has this feature" src="images/GWB-5366-o_Tick-icon-2-2.png"></td><td valign="top" width="108"><img style="margin: 0px 20px" alt="Does not have this feature" src="images/GWB-5366-o_Error-icon-1-1.png"></td></tr><tr><td valign="top" width="230">UndoPendingChangesNotification</td><td valign="top" width="63"><img style="margin: 0px 20px" alt="Has this feature" src="images/GWB-5366-o_Tick-icon-2-2.png"></td><td valign="top" width="108"><img style="margin: 0px 20px" alt="Has this feature" src="images/GWB-5366-o_Tick-icon-2-2.png"></td></tr><tr><td valign="top" width="230">ShelvesetNotification</td><td valign="top" width="63"><img style="margin: 0px 20px" alt="Has this feature" src="images/GWB-5366-o_Tick-icon-2-2.png"></td><td valign="top" width="108"><img style="margin: 0px 20px" alt="Has this feature" src="images/GWB-5366-o_Tick-icon-2-2.png"></td></tr><tr><td valign="top" width="230">WorkspaceNotification</td><td valign="top" width="63"><img style="margin: 0px 20px" alt="Has this feature" src="images/GWB-5366-o_Tick-icon-2-2.png"></td><td valign="top" width="108"><img style="margin: 0px 20px" alt="Has this feature" src="images/GWB-5366-o_Tick-icon-2-2.png"></td></tr><tr><td valign="top" width="230">LabelNotification</td><td valign="top" width="63"><img style="margin: 0px 20px" alt="Does not have this feature" src="images/GWB-5366-o_Error-icon-1-1.png"></td><td valign="top" width="108"><img style="margin: 0px 20px" alt="Has this feature" src="images/GWB-5366-o_Tick-icon-2-2.png"></td></tr><tr><td valign="top" width="230">CodeChurnCompletedNotification</td><td valign="top" width="63"><img style="margin: 0px 20px" alt="Does not have this feature" src="images/GWB-5366-o_Error-icon-1-1.png"></td><td valign="top" width="108"><img style="margin: 0px 20px" alt="Has this feature" src="images/GWB-5366-o_Tick-icon-2-2.png"></td></tr></tbody></table>

**Figure: Version Control events**

<table border="1" cellspacing="0" cellpadding="2"><tbody><tr><td valign="top" width="230"><strong>Build</strong></td><td valign="top" width="63"><strong>Decision</strong></td><td valign="top" width="108"><strong>Notification</strong></td></tr><tr><td valign="top" width="230">BuildCompletionNotificationEvent</td><td valign="top" width="63"><img style="margin: 0px 20px" alt="Does not have this feature" src="images/GWB-5366-o_Error-icon-1-1.png"></td><td valign="top" width="108"><img style="margin: 0px 20px" alt="Has this feature" src="images/GWB-5366-o_Tick-icon-2-2.png"></td></tr><tr><td valign="top" width="230">BuildQualityChangedNotificationEvent</td><td valign="top" width="63"><img style="margin: 0px 20px" alt="Does not have this feature" src="images/GWB-5366-o_Error-icon-1-1.png"></td><td valign="top" width="108"><img style="margin: 0px 20px" alt="Has this feature" src="images/GWB-5366-o_Tick-icon-2-2.png"></td></tr></tbody></table>

**Figure: Work Item Tracking events**

<table border="1" cellspacing="0" cellpadding="2"><tbody><tr><td valign="top" width="230">Work Item Tracking</td><td valign="top" width="63"><strong>Decision</strong></td><td valign="top" width="108">&nbsp;</td></tr><tr><td valign="top" width="230">WorkItemChangedEvent</td><td valign="top" width="63"><img style="margin: 0px 20px" alt="Does not have this feature" src="images/GWB-5366-o_Error-icon-1-1.png"></td><td valign="top" width="108"><img style="margin: 0px 20px" alt="Has this feature" src="images/GWB-5366-o_Tick-icon-2-2.png"></td></tr><tr><td valign="top" width="230">WorkItemMetadataChangedNotification</td><td valign="top" width="63"><img style="margin: 0px 20px" alt="Does not have this feature" src="images/GWB-5366-o_Error-icon-1-1.png"></td><td valign="top" width="108"><img style="margin: 0px 20px" alt="Has this feature" src="images/GWB-5366-o_Tick-icon-2-2.png">minimal</td></tr><tr><td valign="top" width="230">WorkItemsDestroyedNotification</td><td valign="top" width="63"><img style="margin: 0px 20px" alt="Does not have this feature" src="images/GWB-5366-o_Error-icon-1-1.png"></td><td valign="top" width="108"><img style="margin: 0px 20px" alt="Has this feature" src="images/GWB-5366-o_Tick-icon-2-2.png">minimal</td></tr></tbody></table>

**Figure: Team Build Events**

<table border="1" cellspacing="0" cellpadding="2"><tbody><tr><td valign="top" width="230"><strong>Test Management</strong></td><td valign="top" width="63"><strong>Decision</strong></td><td valign="top" width="108"><strong>Notification</strong></td></tr><tr><td valign="top" width="230">TestSuiteChangedNotification</td><td valign="top" width="63"><img style="margin: 0px 20px" alt="Does not have this feature" src="images/GWB-5366-o_Error-icon-1-1.png"></td><td valign="top" width="108"><img style="margin: 0px 20px" alt="Has this feature" src="images/GWB-5366-o_Tick-icon-2-2.png"></td></tr><tr><td valign="top" width="230">TestRunChangedNotification</td><td valign="top" width="63"><img style="margin: 0px 20px" alt="Does not have this feature" src="images/GWB-5366-o_Error-icon-1-1.png"></td><td valign="top" width="108"><img style="margin: 0px 20px" alt="Has this feature" src="images/GWB-5366-o_Tick-icon-2-2.png"></td></tr><tr><td valign="top" width="230">TestPlanChangedNotification</td><td valign="top" width="63"><img style="margin: 0px 20px" alt="Does not have this feature" src="images/GWB-5366-o_Error-icon-1-1.png"></td><td valign="top" width="108"><img style="margin: 0px 20px" alt="Has this feature" src="images/GWB-5366-o_Tick-icon-2-2.png"></td></tr><tr><td valign="top" width="230">TestCaseResultChangedNotification</td><td valign="top" width="63"><img style="margin: 0px 20px" alt="Does not have this feature" src="images/GWB-5366-o_Error-icon-1-1.png"></td><td valign="top" width="108"><img style="margin: 0px 20px" alt="Has this feature" src="images/GWB-5366-o_Tick-icon-2-2.png"></td></tr><tr><td valign="top" width="230">TestPointChangedNotification</td><td valign="top" width="63"><img style="margin: 0px 20px" alt="Does not have this feature" src="images/GWB-5366-o_Error-icon-1-1.png"></td><td valign="top" width="108"><img style="margin: 0px 20px" alt="Has this feature" src="images/GWB-5366-o_Tick-icon-2-2.png"></td></tr><tr><td valign="top" width="230">TestRunCoverageUpdatedNotification</td><td valign="top" width="63"><img style="margin: 0px 20px" alt="Does not have this feature" src="images/GWB-5366-o_Error-icon-1-1.png"></td><td valign="top" width="108"><img style="margin: 0px 20px" alt="Has this feature" src="images/GWB-5366-o_Tick-icon-2-2.png"></td></tr><tr><td valign="top" width="230">BuildCoverageUpdatedNotification</td><td valign="top" width="63"><img style="margin: 0px 20px" alt="Does not have this feature" src="images/GWB-5366-o_Error-icon-1-1.png"></td><td valign="top" width="108"><img style="margin: 0px 20px" alt="Has this feature" src="images/GWB-5366-o_Tick-icon-2-2.png"></td></tr><tr><td valign="top" width="230">TestConfigurationChangedNotification</td><td valign="top" width="63"><img style="margin: 0px 20px" alt="Does not have this feature" src="images/GWB-5366-o_Error-icon-1-1.png"></td><td valign="top" width="108"><img style="margin: 0px 20px" alt="Has this feature" src="images/GWB-5366-o_Tick-icon-2-2.png"></td></tr></tbody></table>

**Figure: Test Manager Events**

<table border="1" cellspacing="0" cellpadding="2"><tbody><tr><td valign="top" width="230"><strong>Framework</strong></td><td valign="top" width="63"><strong>Decision</strong></td><td valign="top" width="108"><strong>Notification</strong></td></tr><tr><td valign="top" width="230">StructureChangedNotification</td><td valign="top" width="63"><img style="margin: 0px 20px" alt="Does not have this feature" src="images/GWB-5366-o_Error-icon-1-1.png"></td><td valign="top" width="108"><img style="margin: 0px 20px" alt="Has this feature" src="images/GWB-5366-o_Tick-icon-2-2.png"></td></tr><tr><td valign="top" width="230">AuthorizationChangedNotification</td><td valign="top" width="63"><img style="margin: 0px 20px" alt="Does not have this feature" src="images/GWB-5366-o_Error-icon-1-1.png"></td><td valign="top" width="108"><img style="margin: 0px 20px" alt="Has this feature" src="images/GWB-5366-o_Tick-icon-2-2.png"></td></tr><tr><td valign="top" width="230">IdentityChangedNotification</td><td valign="top" width="63"><img style="margin: 0px 20px" alt="Does not have this feature" src="images/GWB-5366-o_Error-icon-1-1.png"></td><td valign="top" width="108"><img style="margin: 0px 20px" alt="Has this feature" src="images/GWB-5366-o_Tick-icon-2-2.png"></td></tr><tr><td valign="top" width="230">SecurityChangedNotification</td><td valign="top" width="63"><img style="margin: 0px 20px" alt="Has this feature" src="images/GWB-5366-o_Tick-icon-2-2.png"></td><td valign="top" width="108"><img style="margin: 0px 20px" alt="Has this feature" src="images/GWB-5366-o_Tick-icon-2-2.png"></td></tr><tr><td valign="top" width="230">SendEmailNotification</td><td valign="top" width="63"><img style="margin: 0px 20px" alt="Has this feature" src="images/GWB-5366-o_Tick-icon-2-2.png"></td><td valign="top" width="108"><img style="margin: 0px 20px" alt="Does not have this feature" src="images/GWB-5366-o_Error-icon-1-1.png"></td></tr><tr><td valign="top" width="230">HostReadyEvent</td><td valign="top" width="63"><img style="margin: 0px 20px" alt="Does not have this feature" src="images/GWB-5366-o_Error-icon-1-1.png"></td><td valign="top" width="108"><img style="margin: 0px 20px" alt="Has this feature" src="images/GWB-5366-o_Tick-icon-2-2.png"></td></tr></tbody></table>

**Figure: Framework Events**

I will do a series of blog posts as I build the handlers so you can build your own, but I wanted to get the most common cases pre-built and ready to go. I know that emailing an assignment is a good one to start with, but what else do you see on the cards?

The Email handlers would not work so well in the Scrum environment, but what would?

\[[Request an event handler](http://tfseventhandler.codeplex.com/WorkItem/Create.aspx?ProjectName=TFSEventHandler)\]

Technorati Tags: [TFS](http://technorati.com/tags/TFS),[TFS 2010](http://technorati.com/tags/TFS+2010),[TFS Custom](http://technorati.com/tags/TFS+Custom)
