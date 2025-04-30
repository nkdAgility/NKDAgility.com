---
title: Team Foundation Server 2013 is production ready
description: Discover why Team Foundation Server 2013 is production-ready! Learn about its agile journey, major improvements, and why you should upgrade now.
ResourceId: HxDL5HRMiX4
ResourceType: blog
ResourceContentOrigin: Human
ResourceImport: true
ResourceImportId: 9917
ResourceImportSource: Wordpress
ResourceImportOriginalSource: Wordpress
date: 2013-07-23
weight: 390
creator: Martin Hinshelwood
layout: blog
resourceTypes: blog
slug: team-foundation-server-2013-is-production-ready
aliases:
- /resources/HxDL5HRMiX4
aliasesArchive:
- /blog/team-foundation-server-2013-is-production-ready
- /team-foundation-server-2013-is-production-ready
- /resources/blog/team-foundation-server-2013-is-production-ready
tags:
- Technical Debt
- Application Lifecycle Management
- Pragmatic Thinking
- Software Development
- Working Software
categories: []

---
Did you know that Team Foundation Server 2013 is production ready?

I have already deployed it at two customers with a grand total of zero problems so far. The product team are so confident that they have upgraded their main DevDiv server to 2013.

[![](images/728x90_VSvNext_Border_EN_US1-1-1.gif)](http://nkdagility.com/vs2013Preview/)
{ .post-img }

Unfortunately because of the issues around Team Foundation Server 2012 updates #1 and 2 there has been…. resistance to upgrading. To understand why the problems of 2012.1 and 2012.2 are unlikely to affect 2013 you need to look at the history of the TFS team and their path to agility. The TFS  product team, as  part of the 2012 release cycle, moved to 3 week Sprints of working software. It took them less than two years to get there but the journey was really hard. The result has been [http://tfs.visualstudio.com](http://tfs.visualstudio.com) as well as quarterly updates to TFS 2012.

The first two quarterly updates however suffered from what one might in the agile community affectionately refer to as undone work. This undone work is the result of a team that had not fully embraced agility and struggled to be transparent about the undone work that was the result. This is what happens when teams start down the path. Small teams building small products can usually get away with a little undone work, a few unhappy customers and a quick fix. But what about large teams with enormous code bases, well they kinda sucked at it for a while. This is about how hard it is to change and how bumpy that path to agility can be.

If you have been following Brian Harrys posts you will see that he has tried to be as transparent as possible about these problems and what they are doing to fix them. When you usually have a 2 year release cycle is is easy, if expensive, to test quality in. Now if you move to a 3 week release cycle you have to build quality in, not just test it in, and if you don’t, or have problems, it will be radically obvious to your customers in the bugs that slip past you…

> The endgame is very hard to predict, No one knows how much of the iceberg still lies below the water, and therefore how much work remains in the release.Sam Guckenheimer on Technical Debt in [Visual Studio Team Foundation Server 2012: Adopting Agile Software Practices: From Backlog to Continuous Feedback](http://www.amazon.com/gp/product/B00991JRAU/ref=as_li_ss_tl?ie=UTF8&camp=1789&creative=390957&creativeASIN=B00991JRAU&linkCode=as2&tag=martinhinshe-20)![](http://ir-na.amazon-adsystem.com/e/ir?t=martinhinshe-20&l=as2&o=1&a=B00991JRAU)
> { .post-img }

In addition they made some pretty major database changes in 2012.1. That and some automated testing holes that dated back to 2010 caused the team to struggle somewhat under the technical debt that had been built up.

And the net result? If you are currently running 2012.1 or 2012.2 then you should move immediately to 2012.3. With 2012.3 the TFS team have finally gotten **on top of the undone work** and have **paid back most of the technical debt** that had been run up. With the Team Foundation Server 2013 Preview they have gotten ahead of the curve and have perhaps some of the best integrated ALM features on the market today.

The latest fully supported version of Team Foundation Server is 2013… [get it now!](http://nkdagility.com/vs2013Preview/)
