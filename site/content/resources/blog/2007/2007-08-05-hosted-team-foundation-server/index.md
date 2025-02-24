---
title: Hosted Team Foundation Server
description: Explore the challenges of Hosted Team Foundation Server and discover solutions for project partitioning. Learn about TFS Now and upcoming improvements!
ResourceId: uP5FXaFL6Lx
ResourceType: blog
ResourceImport: true
ResourceImportId: 342
ResourceImportSource: Wordpress
ResourceImportOriginalSource: GeeksWithBlogs
date: 2007-08-05
creator: Martin Hinshelwood
layout: blog
resourceTypes: blog
slug: hosted-team-foundation-server
aliases:
- /blog/hosted-team-foundation-server
- /hosted-team-foundation-server
- /resources/uP5FXaFL6Lx
- /resources/blog/hosted-team-foundation-server
aliasesFor404:
- /hosted-team-foundation-server
- /blog/hosted-team-foundation-server
- /resources/blog/hosted-team-foundation-server
tags:
- Products and Books
- Software Development
- Practical Techniques and Tooling
- News and Reviews
- Modern Source Control
- Software Developers
- Azure DevOps
- Troubleshooting
- Application Lifecycle Management
categories: []

---
I have [posted](http://blog.hinshelwood.com/archive/2007/05/31/Hosted-Team-Foundation-Server.aspx "Hosted Team Foundation Server") about Hosted Team Foundation server before and I have had a few discussions with [Jon Pratt](http://blogs.msdn.com/ukvsts/pages/jon-pratt.aspx) from the [Microsoft UK Development Tools Team](http://blogs.msdn.com/ukvsts/default.aspx) on the subject. The issue with Hosted [TFS](http://msdn2.microsoft.com/en-us/teamsystem/aa718934.aspx "Team Foundation Server") is that there is no real partitioning of projects within the system and thus if you had two clients on the same server they would be able to view each others data.

I even asked a [question](http://www.linkedin.com/answers/technology/software-development/TCH_SFT/46649-1363184?browseIdx=0&sik=1186315050351&goback=%2Eahp%2Eamq) on LinkedIn and got an amazing response.

You may think that this is an oversight, but TFS was not really designed for the hosted environment. The problem is that in my company we would need to keep different areas of the business separate. This requires separate instances of Team Foundation Server for this to work.

There are changes coming in Orcas that will help with this and ones in Rosario that should solve the problems and allow proper hosting.

At this time there is only one commercial hosted team server called [TFS Now](http://www.tfsnow.com/) that has been blogged about by [Jeff Beehler](http://blogs.msdn.com/jeffbe/archive/2007/07/31/hosted-tfs-available-from-readify.aspx "hosted team foundation server") and [Brian Harry](http://blogs.msdn.com/bharry/archive/2007/07/30/the-first-commercial-tfs-hosting-service-is-live.aspx) last month.

Check out [TFS Now](http://www.tfsnow.com/ "TFS Now")...

Technorati Tags: [ALM](http://technorati.com/tags/ALM) [TFS](http://technorati.com/tags/TFS)
