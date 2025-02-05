---
title: Install TFS 2015 today
description: Learn how to install and configure TFS 2015 effortlessly. Upgrade your system with essential tips and insights from expert Martin Hinshelwood. Get started now!
ResourceId: v-m2PYvEaWx
ResourceType: blogpost
ResourceImport: true
ResourceImportId: 11286
ResourceImportSource: Wordpress
ResourceImportOriginalSource: Wordpress
date: 2015-04-30
creator: Martin Hinshelwood
id: "11286"
layout: blog
resourceTypes: blog
slug: install-tfs-2015-today
aliases:
- /blog/install-tfs-2015-today
- /install-tfs-2015-today
- /resources/v-m2PYvEaWx
- /resources/blog/install-tfs-2015-today
aliasesFor404:
- /install-tfs-2015-today
- /blog/install-tfs-2015-today
tags:
- configuration
- install
- tfs
- tfs-2015
categories:
- install-and-configuration
preview: nakedalm-experts-visual-studio-alm-11-11.png

---
It has been a while since I had to install, configure, or upgrade TFS. Most of my customers have been moving to Visual Studio Online (VSO) which is effectively TFS in the cloud, and that requires "migration" of data rather than "upgrade". Although there are [great reasons to pick VSO over TFS, even for enterprise](http://nkdagility.com/benefits-visual-studio-online-enterprise/), many companies have a cultural issue with the cloud and are not ready to go there yet. For this we still have TFS and all of its fantastic features are updated and improved for 2015.

If you are on TFS 2010 (or any prior version) then remember that support ends at the end of July and that you should upgrade. If you are upgrading anyway then you should upgrade to TFS 2015.

\[pl_button type="info" link="https://www.visualstudio.com/en-us/downloads/visual-studio-2015-downloads-vs.aspx" target="blank"\]Download 2015 today\[/pl_button\]

I like to do a few practice installs before I go for the main event, and I always like to document what I am doing so…

## Installing TFS 2015

First, Microsoft have radically reduced the size of the bits. The ISO is under 500mb and that included the old agents.

![clip_image001[6]](images/clip_image0016-1-1.png "clip_image001[6]")
{ .post-img }

If you are on, and you should be, Server 2012, 2012 R2, or the Technical Preview then you can just open the ISO and it will be mounted by Windows natively.

![clip_image002[6]](images/clip_image0026-2-2.png "clip_image002[6]")
{ .post-img }

Some folks like to install the bits to another drive, however there is no need in the modern world. In the old days we put apps on another drive to improve performance, but as we have fast disks and virtual machines that need has gone. Staying as close to the defaults is always the best option.

The [System Requirements for TFS 2015](https://msdn.microsoft.com/en-us/library/dd578592.aspx?f=255&MSPPError=-2147217396) have not yet been announced and the link will take you to the latest version of the requirements, so when they get updates it should be automatic.

![clip_image003[6]](images/clip_image0036-3-3.png "clip_image003[6]")
{ .post-img }

On my Technical Preview server the installation was completed in only a few minutes and did not require a restart. As you will be installing a new version of .NET a restart seemed likely, but it looks like the TFS team have come through on minimising this from earlier versions.

![clip_image004[6]](images/clip_image0046-4-4.png "clip_image004[6]")
{ .post-img }

And that’s it! The TFS team, since TFS 2008, have taken the idea of a zero configuration install to heart and you have no options at install. The bits are laid down and then the configuration wizard, pictured above, is launched. This allows you to have an Ops team do the install, or to put the bits on chocolatey for an automated process.

In the Configuration Center not much has changed and the usual suspects are available. There are four options for installing the main parts of TFS, the application tier.

- **Basic Server** - This is the one that I will be using as it will lay down all of the pre-requisites and install everything automatically for you. It will install SQL Express and configure TFS to use that.
- **Full Server** \- This is the old "Advanced Install" and represents the works. You will be asked for SQL, Reporting Services, Analysis Services, and SharePoint integration options. You will be able to choose if you will be using Reporting, and SharePoint during this wizard. If you want those things up front, or you want to use your own SQL instance then you need to pick this option.
- **Application Tier Only** - If you are adding an additional Application Tier to your existing TFS Server or you are moving either your Application Tier or Data Tier to another server then this option just enabled the Application Tier to work against an existing instance.
- **Upgrade** - If TFS detects an existing instance that is a previous version of TFS then it will automatically pop this option for you. Here is where you get lead through "upgrading" from one version to another. If you, like me, don’t like to do in-place upgrades and have restored your TFS databases to a new server then you will need to install TFS and pick this option to upgrade and move hardware at the same time.

If you have an existing TFS server and you want to add a Proxy server, used to cache TFVC data for performance in remote locations, or configure the SharePoint extensions for your SharePoint farm then you run the same install, but pick the additional options above the line.

In addition there are a number of tools that can be used with TFS. If, perish the thought, you still have some Visual SourceSafe (VSS) data lying around then you should immediately install the Visual SourceSafe Upgrade tool and get that data into TFS. If you still want to use the old Xaml Build format, there is a new build system in TFS 2015, then you can access the old 2013 Xaml Build Agents here.

## Configuring a TFS 2015 Server using the Basic Server option

The Basic install of TFS fulfils two scenarios. First, if you have a blank server, as I do, it will lay down everything you need to just get started. This will install SQL Express and setup a default build agent on your TFS server. It’s the getting started option.

![clip_image005[6]](images/clip_image0056-5-5.png "clip_image005[6]")
{ .post-img }

Your first option is to select your SQL Server. You can either select an existing SQL Server that you have installed yourself, or you can let TFS install and configure Express for you.

You get a complimentary copy of SQL Server Standard to run your TFS Server on in a single server instance. As long as you don’t put any other databases other than those used by TFS then you are covered.

You can always upgrade to full SQL later…

![clip_image006[6]](images/clip_image0066-6-6.png "clip_image006[6]")
{ .post-img }

The new build system in TFS 2015 comes with a new agent. This agent does not run the old Xaml legacy builds but a new task based build system. You will get an agent installed, but you get to choose if it is started automatically or not.

The new agent is awesome and you can [configure as many agents as you like](http://nkdagility.com/configure-a-build-vnext-agent-on-vso/) by just running a little bit of PowerShell.

![clip_image007[6]](images/clip_image0076-7-7.png "clip_image007[6]")
{ .post-img }

As usual you get to review the configuration and you have to run a bunch of readiness checks that will validate that you can configure all of the bits correctly on this system. The old days of hard installs of TFS 2005 and 2008 are gone… if the checks go OK you can then click "Configure".

![clip_image008[6]](images/clip_image0086-8-8.png "clip_image008[6]")
{ .post-img }

The configuration will perform all of the tasks, with prepping the system as well as installing SQL Express and configuring the new TFS configuration and collection databases…

![clip_image009[6]](images/clip_image0096-9-9.png "clip_image009[6]")
{ .post-img }

When done you will have a nice new TFS server to start working in.

![clip_image010[6]](images/clip_image0106-10-10.png "clip_image010[6]")
{ .post-img }

Creating a new Team Project is the test of a TFS server and this can still only be done in Visual Studio (Team Explorer). TFS, unlike VSO, still depends on Reporting Services, and optionally SharePoint for some of its services and the server work required to get the Team Project wizard running server side is just silly work. So time to pop open Visual Studio and create your first team project.
