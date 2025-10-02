---
title: Setting up TFS to create project portals as child sites of an existing SharePoint 3.0 site (or sub site)
description: Guide to integrating Team Foundation Server with SharePoint 3.0 by creating project portals as child sites, including setup steps, permissions, and troubleshooting tips.
date: 2007-05-31
lastmod: 2007-05-31
weight: 1000
sitemap:
  filename: sitemap.xml
  priority: 0.1
  changefreq: weekly
ItemId: jFAz7uP6k-J
ItemType: blog
ItemKind: resource
ItemContentOrigin: Human
slug: setting-up-tfs-to-create-project-portals-as-child-sites-of-an-existing-sharepoint-3-0-site-or-sub-site
aliases:
  - /resources/blog/setting-up-tfs-to-create-project-portals-as-child-sites-of-an-existing-sharepoint-3.0-site-or-sub-site
  - /resources/jFAz7uP6k-J
aliasesArchive:
  - /blog/setting-up-tfs-to-create-project-portals-as-child-sites-of-an-existing-sharepoint-3-0-site-or-sub-site
  - /setting-up-tfs-to-create-project-portals-as-child-sites-of-an-existing-sharepoint-3-0-site-or-sub-site
  - /setting-up-tfs-to-create-project-portals-as-child-sites-of-an-existing-sharepoint-3-0-site-(or-sub-site)
  - /blog/setting-up-tfs-to-create-project-portals-as-child-sites-of-an-existing-sharepoint-3-0-site-(or-sub-site)
  - /resources/blog/setting-up-tfs-to-create-project-portals-as-child-sites-of-an-existing-sharepoint-3-0-site-or-sub-site
  - /resources/blog/setting-up-tfs-to-create-project-portals-as-child-sites-of-an-existing-sharepoint-3.0-site-or-sub-site
layout: blog
concepts: []
categories:
  - Uncategorized
tags: []
Watermarks:
  description: 2025-05-13T16:28:12Z
ResourceId: jFAz7uP6k-J
ResourceType: blog
ResourceImportId: 390
creator: Martin Hinshelwood
resourceTypes: blog

---
Well, I spoke to [Brian Keller](http://blogs.msdn.com/briankel/default.aspx "Brian Keller: Technical Evangelist for Team System") about [Connecting TFS to a SharePoint 3.0 sub site](http://blog.martin.hinshelwood.com/archive/2007/05/31/Team-Foundation-Server-amp-SharePoint-3.0.aspx "Connecting Team Foundation Server to a SharePoint 3.0 sub site")... His answer? _Try it and see._ So I did.

I updated the dev server with the details I provided in my previous post and Manually created Sites under that http://server:888/Projects site with the same name as the project. I tested this by both clicking "Show Project Portal" and creating a new document library in a project. These two features worked a treat.

This allows us to seamlessly integrate TFS with our intranet, and have a decent project portal for things like TFS Global reports and links to TeamPlain among other things.

The real test will come once I get my hands on the Hotfix detailed in KB article #932544 (watch out for the [gotcha](http://forums.microsoft.com/MSDN/ShowPost.aspx?PostID=1658067&SiteID=1 "Configuring TFS with Windows SharePoint Services 3.0")) and I can try creating projects on the new server and in the new location. If this does not work, I will probably have the projects created in WSS 2.0 and manually create projects in WSS 3.0. This will be a minor inconvenience as only two people have permission to create projects.

Hopefully it will work...

_Something to check will be the permissions that are setup! I have the parent site setup to inherit from the root, that gives permission to anyone in our company._

Technorati Tags: [ALM](http://technorati.com/tags/ALM) [SP 2007](http://technorati.com/tags/SP+2007) [TFS](http://technorati.com/tags/TFS)
