---
title: Team Foundation Server SharePoint Integration
description: Explore the integration challenges between Team Foundation Server and SharePoint 2007. Discover insights on enhancing workflows and managing work items effectively.
ResourceId: Dn2_7F_mhyC
ResourceType: blog
ResourceImport: true
ResourceImportId: 300
ResourceImportSource: Wordpress
ResourceImportOriginalSource: GeeksWithBlogs
date: 2007-10-16
weight: 995
creator: Martin Hinshelwood
layout: blog
resourceTypes: blog
slug: team-foundation-server-sharepoint-integration
aliases:
- /resources/Dn2_7F_mhyC
aliasesArchive:
- /blog/team-foundation-server-sharepoint-integration
- /team-foundation-server-sharepoint-integration
- /resources/blog/team-foundation-server-sharepoint-integration
tags:
- Practical Techniques and Tooling
- Application Lifecycle Management
- Azure DevOps
- Pragmatic Thinking
- Software Development
categories: []
preview: metro-visual-studio-2005-128-link-1-1.png

---
Why is there not more integration found in Team Foundation Server "out-of-the-box" with SharePoint 2007. It seams obvious to me that you would want to show your Work Items in SharePoint and integrate SharePoint Workflow into Team Foundation Server. It only make sense to be able to initially create a SharePoint Work item that is a request from a user into SharePoint, have some sort of approval workflow before assigning it to a project within [TFS](http://msdn2.microsoft.com/en-us/teamsystem/aa718934.aspx "Team Foundation Server").

I think that [Mike Glaser](http://bloggingabout.net/members/Mike-Glaser.aspx)'s blog [post](http://bloggingabout.net/blogs/mglaser/archive/2007/03/30/how-about-one-team-foundation-server-portal-i-had-a-dream.aspx) on _"_[_How about one Team Foundation Server portal? I had a dream!_](http://bloggingabout.net/blogs/mglaser/archive/2007/03/30/how-about-one-team-foundation-server-portal-i-had-a-dream.aspx)_"_ hits the nail exactly on the head. Why can we not view our bugs in SharePoint and create Change requests there?

What would be excellent would be Mike's hierarchical project space. You should be able to create work items at the root level and then assign them to projects on the way down. This way, user, who have no idea what project a Change Request is for  can create them in the central pool, and then the project manager or technical experts can filter them down into the actual project that the change is for.

As a start, instead of releasing "Web access for Team Foundation Server" as a power tool, it should have been re-engineered into a set of web parts that can be integrated into SharePoint. That way we could have used the default site, or created our own custom components.

Microsoft, if you are listening to either Mike or myself...please do not forget the Workflow integration too....

Technorati Tags: [Fail](http://technorati.com/tags/Fail) [SP 2007](http://technorati.com/tags/SP+2007) [ALM](http://technorati.com/tags/ALM)
