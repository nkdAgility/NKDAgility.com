---
title: Migrating source from Perforce to Git on VSO
description: Learn how to migrate from Perforce to Git on VSO with expert tips and strategies for a smooth transition to modern version control. Start your journey now!
ResourceId: bvuzuOYg8gs
ResourceType: blog
ResourceImport: true
ResourceImportId: 10677
ResourceImportSource: Wordpress
ResourceImportOriginalSource: Wordpress
date: 2014-08-20
weight: 675
creator: Martin Hinshelwood
layout: blog
resourceTypes: blog
slug: migrating-source-perforce-git-vso
aliases:
- /blog/migrating-source-perforce-git-vso
- /migrating-source-perforce-git-vso
- /migrating-source-from-perforce-to-git-on-vso
- /blog/migrating-source-from-perforce-to-git-on-vso
- /resources/bvuzuOYg8gs
- /resources/blog/migrating-source-perforce-git-vso
aliasesArchive:
- /blog/migrating-source-perforce-git-vso
- /migrating-source-perforce-git-vso
- /migrating-source-from-perforce-to-git-on-vso
- /blog/migrating-source-from-perforce-to-git-on-vso
- /resources/blog/migrating-source-perforce-git-vso
tags:
- Software Development
- Modern Source Control
- Install and Configuration
- Practical Techniques and Tooling
- Azure DevOps
- Azure Repos
- Continuous Integration
- Pragmatic Thinking
- Technical Excellence
- Technical Mastery
categories:
- DevOps
- Engineering Excellence
preview: naked-alm-git-1-1.png

---
I have been working with a customer in London this week that is using TFS 2010 for work item tracking and Perforce for source control. Here is how I got on migrating source from Perforce to Git on VSO.

It is rare for European companies to be OK with cloud but these guys are very progressive. They create software that the legal profession uses and even have a cloud offering of their own. They currently use Office 365 and don't really want to have to run anything locally. They have a last few servers in a rack in their office which only serves to heat it up in the summer. Perforce is one of those last local servers.

There is a script that part of the Git codebase to migrate history from Perforce to Git. However, you would have to take your code as is and would easily run into the problems that are described below with the conflicting workflows of Server based and Node based source control.

_Note: If you are moving from TFVC to Git then you can do the same using a tool called Git-TF. You [clone a TFVC repository and push to Git](http://nkdagility.com/migrating-source-code-with-history-to-tfs-2012-with-git-tf/)._

## Migrating source from Perforce to Git on VSO

Currently the Source Control adapters in the TFS Integration tools do not support Git migration and I do not believe they ever will. And that is how it should be. Why you might ask... Well if you are moving to Git then you are moving to an entirely new premise for version control. Instead of living in the linear world of server based source control you will be moving to the node based source control where there just happens to be a bit that sits on the server. Trust me, its a big deal.

With Git you can check in locally many times before you push those changes to the server. Indeed you can merge your changes with one of your colleagues local repositories and when you both eventually push to the server it will just all work out (mostly). The other awesome features of Git, like local branches or pull requests, are beyond the scope of this post, however they are all things that you are going to want and soon. You are going to hear tell, from other developers, of this wonderful world where merging and branching is easy and you can roll-back changes locally. You are going to want it even if you don't yet know you will. Short circuit this and plan your move today...

There are however a number of caveats that make an automated tool, or taking history difficult if not impossible.

- **Repository Size** - You really want to keep the repository small for Git. This means that we need to break large code bases down into smaller parts. This is going to be often hard, but will make things more manageable in the long run.
- **No binaries** - you should not have any binaries stored in Git. It dramatically reduces performance. However getting that crape out of source control can only benefit everyone from Coders to Testers, Build servers and DevOps.

I worked with one of my clients (Ted) who understood his product to break it down into this component parts. Components that we can build together and separately. We started by looking for something in our applications that many things depended on. In this case we had a set of Core components that many applications used. You need to start at the bottom of the dependency tree for your application and see what logical groupings you can make.

In their VSO account we created a single Team Project called 'main' within which all of their applications and teams will reside. They are starting with two teams, the Development Team and the Business Team, and they may very well end up with product specific teams for backlog management specific to a product. There is a simple formula for doing a Git migration:

1. **Create new Git repository in VSO** - I tend to create one of the same name as the solution that I want in there. And, yes, if you are new to Git then stick to the 'one-solution-one-repository' mantra.
2. **Clone the Git repository** - This puts a local copy of the new and empty repository on disk. If you connect to the repository in Visual Studio then you will be offered a clone button.
3. **Copy/Create Solution and Projects** - Getting the files into Git is as easy as copying t hem in. In this case we were picking about 10 of the 30 projects to go into a new Core solution.
4. **Get your Solution to build** - While I have seen many errors before and can help speed up the process of diagnostics I don't know your code base. My guy (Ted) is an expert in his own code and was tasked with getting everything to build. There are a few common errors here. First is reference errors. We had a bunch of places where the projects referenced the output of the project rather than the project as a reference. Remove as many direct dell references as you can. Once you can get your application to build its time to move to the next stage.
5. **Strip binaries to NuGet** - Performance in Git degrades as the repository size increases so don't overly burden it with binaries. Get them out by moving them to a NuGet Repository. If you can then you should replace all your manual references with public NuGet ones ([http://nuget.org](http://nuget.org)). Of the five references to assorted other DLL's we found two of them on NuGet, so an easy replace. For another we created a brand new NuGet packages with the DLL's we needed and published temp to a private feed on [http://myget.com](http://myget.com). MyGet is a hosted NuGet Repository that you can quickly spin up and is cloud based. If you are an enterprise they do offer an on-premises version. We did encounter one problem of needing to have a signed version of an unsigned assembly. We had a batch file to sign it ourselves and we manually solved it, but there are more elegant ways. If we had tens of requirements for this then we could have built a PowerShell that downloaded the NuGet Packages, signed them, re-packaged them with a 'signed' postfix, and uploaded them to our private repository.
6. **Get your Solution to build** - Again, now that we have all of the dependencies replaced you may have broken our solution. We did, a bunch, and found that building after every change helped identify issues, and their cause, early.
7. **Commit and Push** - now that we have the solution building we can check in. This is done in Git with a Commit to your local repository and then a Push to the TFS Git Repository.
8. **Create CI Build** - With code now in the repository we can create a CI build to make sure we have everything right, and keep it right. We quickly used up the 50 minutes of build for free a month so we configured a private build server in an Azure VM. This is just like setting up an on-premises build server except the machine runs on Azure. Just remote desktop in and install the bits and dependencies. You may have to do this if you have custom components that you need to install on the build server. These guys use InstalliShield so they would always have had to go down this road.

   _Note: if your vendor does not provide a 'no-install' version for build servers you should put pressure on them to change their ways. If they will not then consider changing vendor. WIX is an open source installer product that is used by Microsoft to build its own installers. It will build on a build server out-of-the-box._

9. **Get your solution to build on the build server** - Build servers can be a little more... Unforgiving... Than local builds. Paths are different and if things that are installed locally on the developer workstation don't exist in source you can hit issues. Remember that NuGet and Chocolatey are your friends. NuGet for internal dependencies and Chocolaty for the external ones.
10. **DONE**

While there is some work in this approach it is eminently worth it. In order to move to Git you need to think more about how your application is composed. You need to streamline the build process and fix all of the dependencies. Your builds should be faster, your components more robust, and you should start getting fewer bugs. All this from a slightly different workflow with your source. Its easy to check in a pile of crap to a server based source control system... But a little more though and deliberation is required from a node based one.

_Note: If you are migrating ChangeSets then you may want to write a script to move all of the Check-in to work item associations to the comments as #\[ID\]. When you push to Git on the server TFS will automatically link any hashtag work item ID's to the Check-in. Good for reporting._

## Conclusion

There are huge benefits from moving to VSO and Git from an on-premises TFS that start with cloud infrastructure. You get AD integration through Azure so you can integrate with your local AD as well as being able to add foreign principals (Microsoft ID) as well. This gives you easy control over external resources with ease. Add to that features appear first, as much as three months to a year before they are available on-premises you can get ahead of the curve.

_Note: If you are in Europe and concerned about the patriot act look up the recent court cases with Microsoft going to bat, all in, for data privacy in Europe on this exact issue. Microsoft has vowed (along with the other cloud providers) to fight the US state department on this with the assertion (correct in my opinion) that US law ends at US borders._

All in I would recommend any organisation that can move to VSO to do so.
