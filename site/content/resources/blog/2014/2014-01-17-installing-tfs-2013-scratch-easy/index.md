---
title: Installing TFS 2013 from scratch is easy
description: Learn how to easily install TFS 2013 from scratch with step-by-step videos. Discover basic and advanced setups for efficient configuration and management.
ResourceId: VfADNDpkNbe
ResourceType: blog
ResourceImport: true
ResourceImportId: 10332
ResourceImportSource: Wordpress
ResourceImportOriginalSource: Wordpress
date: 2014-01-17
creator: Martin Hinshelwood
layout: blog
resourceTypes: blog
slug: installing-tfs-2013-scratch-easy
aliases:
- /blog/installing-tfs-2013-scratch-easy
- /installing-tfs-2013-scratch-easy
- /installing-tfs-2013-from-scratch-is-easy
- /blog/installing-tfs-2013-from-scratch-is-easy
- /resources/VfADNDpkNbe
- /resources/blog/installing-tfs-2013-scratch-easy
aliasesFor404:
- /installing-tfs-2013-scratch-easy
- /blog/installing-tfs-2013-scratch-easy
- /installing-tfs-2013-from-scratch-is-easy
- /blog/installing-tfs-2013-from-scratch-is-easy
- /resources/blog/installing-tfs-2013-scratch-easy
tags:
- System Configuration
categories:
- Install and Configuration

---
It had been a while since I installed TFS from scratch and I had a few questions from a customer on the subject. So instead of creating yet another installing TFS post I decided to create a couple of videos instead.

In the first video I used the Basic Install option. This installs TFS with SQL Express and is the easiest setup. Instead of having to do a bunch of manual steps you just click and go. Fully configured TFS in no time. On top of that it will even configure SharePoint Foundation 2013 for you (not supported on Server 2012 R2 until SP1.) The only thing that you are missing is Reporting and that is only because SQL Express does not support Reporting Services or Analysis Services. You can however upgrade later if you feel the need easily.

\[youtube=http://www.youtube.com/watch?v=U7wIQk1pus0\]  
Figure: Install & Configure 101 - TFS 2013 Basic Installation

If that's not for you and you like things a little bit more complicated you can install SQL Server first and then use the Standard Single Server install. Here I install SQL Server 2012 with all of the trimmings, Reporting and Analysis Services. I then let TFS do all of the heavy lifting of configuration and setup of all of the features. This results in a full install of TFS with a Cube and Data Warehouse but no SharePoint as it is not supported on Server 2012 R2 until the release of SharePoint 2013 SP1.

\[youtube=http://www.youtube.com/watch?v=U69JMzIZXro\]  
Figure: Install & Configure 101 - TFS 2013 Standard Single Server Install

This should give you some idea on how to install and configure TFS and how easy it is. Managing TFS is mostly, apart from configuring a backup, a leave alone statement. It mostly manages and maintains itself until you get to large database sizes. And by large I mean terabytes :)

How did you get on with your TFS installs?
