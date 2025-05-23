---
title: Deploying Team Server
description: Discusses the challenges, costs, and benefits of implementing Team Foundation Server (TFS) for large development teams in a corporate investment banking environment.
ResourceId: BcNPa5LLzLX
ResourceType: blog
ResourceContentOrigin: Human
ResourceImport: true
ResourceImportId: 440
ResourceImportSource: Wordpress
ResourceImportOriginalSource: GeeksWithBlogs
date: 2007-01-30
weight: 630
creator: Martin Hinshelwood
layout: blog
resourceTypes: blog
slug: deploying-team-server
aliases:
- /resources/BcNPa5LLzLX
aliasesArchive:
- /blog/deploying-team-server
- /deploying-team-server
- /resources/blog/deploying-team-server
tags: []
preview: nakedalm-logo-128-link-1-1.png
categories:
- Uncategorized
Watermarks:
  description: 2025-05-13T16:29:21Z
concepts: []

---
Sorry that I have not posted on this subject in a while, but I am lazy. After that last elongated post I am in the mood to write again...

Our TFS implementation is moving forward. I did a presentation on Friday to my peers and  bosses on the need for TFS and the appropriate uses of it. This has all come about as the scope of the project I have been asked to undertake has increased. Instead of 6 developers an 4 project managers, I have been asked to spec for 10 developers and 20 other users. This requires the sourcing of desktops for all as not only do the current computers not have corporate builds (my company buys the windows source and does strange things with it) but the 20 users have thin clients, which will not support Office 2003 (physically yes, but our infrastructure requires Office 2000). More cost..

I will also have to put in a dev environment and a disaster recovery environment, more cost, and get servers hosted in our datacenters. All in, not including the desktops (which we need anyway to comply with corporate policy) the current implementation of TFS will cost around £100,000 ($200,000). Thus, rightly so, I have higher-uppers questioning the cost and need for the system.

The result is that for a company of our size, 75,000 est., with over 5,000 developers alone, I do not think that we can operate effectively in the cut throat world of investment banking without the advantages that TFS will provide.

Sure, we can calculate the metrics yourself, but we will miss things.

Sure, we can have each team build website   wiki's to manage their content so other developers can see what is going on, but with that many developers how will we keep track.

Sure, we can implement some sort of open source source control system (Subversion or ClearCase), but will we really be able to see all the code, or incorporate local and global changes?

I think not.

It would be far better to have a complete solution that covers all aspects of the development life cycle, instead of having piecemeal system knitted together by a variety of technologies.

Technorati Tags: [SOA](http://technorati.com/tags/SOA) [ALM](http://technorati.com/tags/ALM) [TFBS](http://technorati.com/tags/TFBS)
