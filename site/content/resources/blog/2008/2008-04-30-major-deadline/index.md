---
title: Major deadline
description: Discover the challenges of managing a SharePoint migration project and the urgent solutions needed to meet a tight deadline. Join the journey of innovation!
ResourceId: qNeovUSRj-o
ResourceType: blog
ResourceImport: true
ResourceImportId: 233
ResourceImportSource: Wordpress
ResourceImportOriginalSource: GeeksWithBlogs
date: 2008-04-30
creator: Martin Hinshelwood
id: "233"
layout: blog
resourceTypes: blog
slug: major-deadline
aliases:
- /blog/major-deadline
- /major-deadline
- /resources/qNeovUSRj-o
- /resources/blog/major-deadline
aliasesFor404:
- /major-deadline
- /blog/major-deadline
- /resources/blog/major-deadline
tags:
- moss2007
- sharepoint
- sp2007
categories:
- me
preview: metro-sharepoint-128-link-5-5.png

---
![image](images/Majordeadline_13060-image_thumb_6-4-4.png)Well the faeces hit the fan at work today...let me explain...
{ .post-img }

We have a completely unmanaged Sharepoint Portal server at work. It was installed in early 2004 and has been running in self service mode ever since. Not all of the company is using it, but those that are, are using it heavily. Particularly areas that service customers and one customer specifically use it so completely that that area of the business would find it hard to function if it was not available.

So early this year I started a project to migrate / rewrite for Microsoft Office Sharepoint Server (MOSS) and we now have a proof of concept site online that demos the features and architecture of a finished portal. This POC version was scheduled for go live in Q4...

This had been ticking over for a while with a number of project requests getting in the way, the [TFS Sticky Buddy](http://www.codeplex.com/TFSStickyBuddy) for one, along with many others. As the only .NET developer in EMEA it can get a little hectic.

[![image](images/Majordeadline_13060-image_thumb_1-1-1.png)](http://blog.hinshelwood.com/files/2011/05/GWB-WindowsLiveWriter-Majordeadline_13060-image_4.png)Recently I had a project to make a copy of one of the Sharepoint 2003 portals and I ran into a number of problems... now, I am not a Sharepoint 2003 guru, having had most of my exposure to it with Team Foundation Server deployments, but I followed all of the documented approaches for copying a site, to no avail. For each attempt, of which there were many, and for each approach, again there were many, I ran into problem after problem. Either the export commands failed, or the import command failed, and the resultant restore looked nothing like the original having been mangled during the process.
{ .post-img }

The result of my efforts was a custom APS.NET application that replicated the functionality provided by Sharepoint (it is worth noting that the site did not use much of SharePoint to do its job). Problem solved...

But not really... I still had a soon to be mangled Sharepoint 2003 portal server with over a thousand users on it.

[![image](images/Majordeadline_13060-image_thumb_2-2-2.png)](http://blog.hinshelwood.com/files/2011/05/GWB-WindowsLiveWriter-Majordeadline_13060-image_6.png) Then the bomb shell landed... I had been getting some reports of problems for the users of a site that is used to handle a customers contract, these users were running into real performance issues and functionality limitations. They were aware of the proof of concept MOSS deployment and wanted a look, so when some of the guys were in the office I stupidly, as I always do, started showing off MOSS features and functionality that puts Sharepoint Portal server to shame. How stupid of me... in my zeal to get MOSS deployed to the business I inadvertently stepped on a land mine. They went home, spoke to a few people and lo and behold, my deadline has been moved up from Q4 to now.... or at leas as soon as possible, and specifically for the aforementioned site.
{ .post-img }

**The Plan**

[![image](images/Majordeadline_13060-image_thumb_5-3-3.png)](http://blog.hinshelwood.com/files/2011/05/GWB-WindowsLiveWriter-Majordeadline_13060-image_12.png)
{ .post-img }

Apart from quitting, having a nervous breakdown and ultimately committing [Seppuku](http://en.wikipedia.org/wiki/Seppuku) I had to come up with a way of fulfilling this insane idea of a deployment schedule.

To do this I plan to use the Business Data Catalog to connect to customer data, and create a portal site that dynamically build sites using an as yet non existent site template for a specified customer. This way there is system data available for creating excel services reports and stats along with document library and InfoPath forms. The site should look exactly like the My Sites, but for a customer. It can then be branched out for other entitles like products (we build them and then rent and service them) and contracts.

In the immortal words of the Windows 2003 Active Directory Installer:

> _This may take some time, or considerably longer..._

Technorati Tags: [Personal](http://technorati.com/tags/Personal) [SP 2007](http://technorati.com/tags/SP+2007) [MOSS](http://technorati.com/tags/MOSS) [SharePoint](http://technorati.com/tags/SharePoint)
