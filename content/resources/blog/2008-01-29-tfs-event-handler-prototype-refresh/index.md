---
id: "259"
title: "TFS Event Handler (Prototype) Refresh"
date: "2008-01-29"
categories: 
  - "code-and-complexity"
tags: 
  - "code"
  - "infrastructure"
  - "tfs"
  - "tfs2008"
  - "tfs-event-handler"
  - "tools"
  - "visual-studio"
  - "vs2008"
  - "wit"
coverImage: "metro-visual-studio-2005-128-link-1-1.png"
author: "MrHinsh"
type: "post"
slug: "tfs-event-handler-prototype-refresh"
---

I found a couple of bugs in the [TFS Event Handler Prototype release](https://www.codeplex.com/Release/ProjectReleases.aspx?ProjectName=TFSEventHandler&ReleaseId=5057). As I am still supporting this release (many people use it in production) I have fixed the bugs and uploaded new installers.

The config files have not changed, so you should make a copy of your config file before you uninstall the application. Then reinstall it and copy the config files back and you will be sorted. I have this version working on a server and sending emails with the default event handler.

I had already upgraded the solution to Visual Studio 2008, so I went all the way and .Net 3.5 'ed all of the projects as well. The [documentation](http://www.codeplex.com/TFSEventHandler/Wiki/View.aspx?title=TFS%20Event%20Handler%20(Prototype):%20Documentation) already exists for you to create your own event handlers and apply them to you team server, but let me know what you are getting your Team Server's to do.

Some ideas for Event Handlers:

- Send someone an email when they are assigned a Work Item.(Included in the [Prototype release](https://www.codeplex.com/Release/ProjectReleases.aspx?ProjectName=TFSEventHandler&ReleaseId=5057)...)
- Notify project managers when a new work item is added.
- If a user checks in code and bypasses the check-in policies, send an email to the entire team to name and shame them ![smile_omg](images/smile_omg-2-2.gif)
- Send an email to all of the developers when a check-in occurs...
- ...

**Can you think of any more you would like?** [Send them on a postcard to...](https://www.codeplex.com/Thread/View.aspx?ProjectName=TFSEventHandler&ThreadId=21219 "Send me your ideas for new Event Handlers")

Technorati Tags: [.NET](http://technorati.com/tags/.NET) [ALM](http://technorati.com/tags/ALM) [WIT](http://technorati.com/tags/WIT) [VS 2008](http://technorati.com/tags/VS+2008)


