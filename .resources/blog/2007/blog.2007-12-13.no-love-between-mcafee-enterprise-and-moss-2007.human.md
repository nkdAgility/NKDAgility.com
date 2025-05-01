---
title: No love between McAfee Enterprise and MOSS 2007
description: Discover the issues between McAfee Enterprise and MOSS 2007 that hinder SharePoint performance. Learn how to resolve conflicts for smoother operations.
ResourceId: uprMOboloWH
ResourceType: blog
ResourceContentOrigin: Human
ResourceImport: true
ResourceImportId: 274
ResourceImportSource: Wordpress
ResourceImportOriginalSource: GeeksWithBlogs
date: 2007-12-13
weight: 1000
creator: Martin Hinshelwood
layout: blog
resourceTypes: blog
slug: no-love-between-mcafee-enterprise-and-moss-2007
aliases:
- /resources/uprMOboloWH
aliasesArchive:
- /blog/no-love-between-mcafee-enterprise-and-moss-2007
- /no-love-between-mcafee-enterprise-and-moss-2007
- /resources/blog/no-love-between-mcafee-enterprise-and-moss-2007
tags:
- Troubleshooting
categories:
- Uncategorized
preview: metro-sharepoint-128-link-1-1.png

---
Well I think I have found the root of the problem with my Microsoft office SharePoint Server 2007 dev box! It was McAfee  plain and simple.

> _Event Type:    Error  
> Event Source:    Windows SharePoint Services 3 Search  
> Event Category:    Gatherer  
> Event ID:    2424  
> Date:        13/12/2007  
> Time:        09:36:06  
> User:        N/A  
> Computer:    GLA1VS09  
> Description:  
> The update cannot be started because the content sources cannot be accessed. Fix the errors and try the update again._
>
> _Context: Application 'Search', Catalog 'index file on the search server Search'_
>
> _For more information, see Help and Support Center at_ [_http://go.microsoft.com/fwlink/events.asp_](http://go.microsoft.com/fwlink/events.asp)_._

I get the above error about the Search Catalog repeatedly during the installation of SP1, and wrapped around it I get a bunch of IRC port block information items from McAfee. This is more than coincidence and I have requested that our infrastructure team remove McAfee from all SharePoint servers so we don't have this kind of problem in the future.

Now, McAfee say that they support SharePoint Services 3.0, but MOSS has a bunch of extra features (Enterprise Search being one) that are not around in WSS. It seams that there are specific versions of Anti-Virus products for SharePoint Portal Servers and for good reason...

Hopefully I can get this sorted soon.

Technorati Tags: [SP 2007](http://technorati.com/tags/SP+2007) [MOSS](http://technorati.com/tags/MOSS) [SharePoint](http://technorati.com/tags/SharePoint)
