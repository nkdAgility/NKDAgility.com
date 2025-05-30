---
title: 'TFS Event Handler: Coverage & Comments'
description: Discusses feedback and key issues for the TFS Event Handler project, focusing on security for uploaded assemblies and handling of referenced assemblies in internal team use.
ResourceId: PEksFd3ugtL
ResourceType: blog
ResourceContentOrigin: Human
ResourceImport: true
ResourceImportId: 406
ResourceImportSource: Wordpress
ResourceImportOriginalSource: GeeksWithBlogs
date: 2007-05-02
weight: 1000
creator: Martin Hinshelwood
layout: blog
resourceTypes: blog
slug: tfs-event-handler-coverage-comments
aliases:
- /resources/blog/tfs-event-handler-coverage-comments
- /resources/PEksFd3ugtL
aliasesArchive:
- /blog/tfs-event-handler-coverage-comments
- /tfs-event-handler-coverage-comments
- /tfs-event-handler--coverage-&-comments
- /blog/tfs-event-handler--coverage-&-comments
- /resources/blog/tfs-event-handler-coverage-comments
tags: []
categories:
- Uncategorized
preview: metro-visual-studio-2005-128-link-1-1.png
Watermarks:
  description: 2025-05-13T16:28:34Z
concepts: []

---
I am getting some positive feedback on the project from [Richard Berg](http://blogs.msdn.com/richardb), and he had blogged about it under the title of [New CodePlex project: TFS Event Handler](http://blogs.msdn.com/richardb/archive/2007/05/01/new-codeplex-project-tfs-event-handler.aspx "BUGBUG: poor title"). And [John Lambert](http://forums.microsoft.com/MSDN/showpost.aspx?postid=1542164&siteid=1 "Pass a assembly over a web service!") has commented on some issues that he has envisioned with referenced assemblies and security of allowing people to upload Assemblies.

I would like to address both of these issues:

[Security issues on uploaded assemblies](http://www.codeplex.com/TFSEventHandler/WorkItem/View.aspx?WorkItemId=138 "WorkItem: Issue: Security issues on uploaded assemblies")

I do not ever envision that this would be uses when facing the public. It is designed for large internal teams where you want to give them the capability to setup their own Handlers. It may be that all assemblies uploaded must be secured using a key that only I provide to the developers!

[Referenced assemblies issues](http://www.codeplex.com/TFSEventHandler/WorkItem/View.aspx?WorkItemId=139 "WorkItem: Issue: Referenced assemblies issues")

Although not for this version of the application, I would like to use a zip format file to allow the addition of extra files, like .htm templates for emails, or an additional referenced assemblies.

I have raised both of these issues on CodePlex and you can vote for them there. If anyone has any other issues that they would like to point out, please don't hesitate to let me know...

Technorati Tags: [WIT](http://technorati.com/tags/WIT) [Personal](http://technorati.com/tags/Personal) [TFS](http://technorati.com/tags/TFS)
