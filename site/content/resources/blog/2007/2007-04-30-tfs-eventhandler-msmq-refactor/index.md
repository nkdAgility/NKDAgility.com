---
title: 'TFS EventHandler: MSMQ Refactor'
description: Explore the TFS EventHandler MSMQ Refactor as Martin Hinshelwood shares insights on streamlining event handling with a modular approach. Stay tuned for updates!
ResourceId: 1monS4nfW6w
ResourceType: blog
ResourceContentOrigin: Human
ResourceImport: true
ResourceImportId: 407
ResourceImportSource: Wordpress
ResourceImportOriginalSource: GeeksWithBlogs
date: 2007-04-30
weight: 840
creator: Martin Hinshelwood
layout: blog
resourceTypes: blog
slug: tfs-eventhandler-msmq-refactor
aliases:
- /resources/1monS4nfW6w
aliasesArchive:
- /blog/tfs-eventhandler-msmq-refactor
- /tfs-eventhandler-msmq-refactor
- /tfs-eventhandler--msmq-refactor
- /blog/tfs-eventhandler--msmq-refactor
- /resources/blog/tfs-eventhandler-msmq-refactor
tags: []
preview: nakedalm-logo-128-link-1-1.png
categories: []

---
I am half way through the MSMQ Refactor of my [TFS Event Handler](http://www.codeplex.com/TFSEventHandler) project and thing are starting to come together. I have changed it so that instead of one big solution I will have three smaller ones. This will allow me to cross reference the different services.

Essentially the Team Server fires events that a service (TFSEventQueuer) captures and adds them, with a little jiggery porkery, to a message queue. The second service (TFSEventHandlers) reads the Queue and executes the appropriate handlers.

This should be pretty neat once it is complete, and the interface should allow users to easily administer the handlers.

Still a long way to go... But I hope to have a working version by the end of the week...

Technorati Tags: [WIT](http://technorati.com/tags/WIT)
