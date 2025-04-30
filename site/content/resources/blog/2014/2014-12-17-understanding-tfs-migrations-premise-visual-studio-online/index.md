---
title: Understanding TFS migrations from on-premise to Visual Studio Online
description: Explore effective strategies for migrating TFS from on-premise to Visual Studio Online. Discover scenarios, tools, and insights to streamline your transition.
ResourceId: lov38doo6uB
ResourceType: blog
ResourceContentOrigin: Human
ResourceImport: true
ResourceImportId: 10987
ResourceImportSource: Wordpress
ResourceImportOriginalSource: Wordpress
date: 2014-12-17
weight: 1000
creator: Martin Hinshelwood
layout: blog
resourceTypes: blog
slug: understanding-tfs-migrations-premise-visual-studio-online
aliases:
- /resources/lov38doo6uB
aliasesArchive:
- /blog/understanding-tfs-migrations-premise-visual-studio-online
- /understanding-tfs-migrations-premise-visual-studio-online
- /understanding-tfs-migrations-from-on-premise-to-visual-studio-online
- /blog/understanding-tfs-migrations-from-on-premise-to-visual-studio-online
- /resources/blog/understanding-tfs-migrations-premise-visual-studio-online
tags:
- Software Development
categories: []
preview: nakedalm-experts-visual-studio-alm-5-5.png

---
I have recently been doing a lot of migrations and [Willy](http://blogs.msdn.com/b/willy-peter_schaub/) asked me to write a white-paper about understanding TFS migrations from on-premise to Visual Studio Online.

![clip_image001](images/clip_image0012-1-1.png "clip_image001")
{ .post-img }

On writing and understanding TFS migrations from on-premise to Visual Studio Online we found that the story was so poor that we broke it into two parts. The first part is ready and focuses on what the options are and the stories for migrating. Its interesting as many people believe that it is Microsoft's job to provide tools to migrate from any other product into their own product. While I would love to agree there are just way to many products out there to make that a realistic situation.

- PDF: [Understanding TFS migrations from on-premise to Visual Studio Online](https://vsarguidance.codeplex.com/releases/view/178488)

We kind of looked at a number of scenarios:

- **Team Project to Team Project** – While not common it is the simplest situation.  
   ![clip_image002](images/clip_image0022-2-2.png "clip_image002")
  { .post-img }
- **Consolidating Team Projects** – With the move to 2012+ this is the most common ask I have from customers. Wither on-premises or while moving to VSO, many folks are taking the time to pay back the technical cruft that has built up over the years.  
   ![clip_image003](images/clip_image0032-3-3.png "clip_image003")
  { .post-img }
- **Splitting Team Projects** – While not as common I have seen this as well. Splitting your data is an interesting situation and can be the result of selling parts of your portfolio or just some teams moving on or changing process. Maybe you use it as a staged migration to VSO.  
   ![clip_image004](images/clip_image0042-4-4.png "clip_image004")
  { .post-img }
- **Consolidating Platforms on VSO** - Many customers have Perforce, Git, TFS, SVN, or any of 50 different systems. I have customer that have one of everything.

Like I said the story is not currently that good but you can read about each of the scenarios and see what the main issues are. We have also mapped tools to scenarios so that you can try to get started solving whatever your problems are:

- PDF: [Understanding TFS migrations from on-premise to Visual Studio Online](https://vsarguidance.codeplex.com/releases/view/178488)

The ALM Rangers will also be releasing a walk-through for the simplest of migrations which is to use Excel for work items and do a tip migration of code. That will be coming real soon.
