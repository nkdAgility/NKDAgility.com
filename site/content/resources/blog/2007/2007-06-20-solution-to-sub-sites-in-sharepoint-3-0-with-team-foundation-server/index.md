---
title: Solution to sub sites in Sharepoint 3.0 with Team Foundation Server
description: Discover a practical solution for creating sub sites in SharePoint 3.0 with Team Foundation Server. Streamline your project management today!
ResourceId: B1bu87flA8w
ResourceType: blog
ResourceImport: true
ResourceImportId: 376
ResourceImportSource: Wordpress
ResourceImportOriginalSource: GeeksWithBlogs
date: 2007-06-20
weight: 775
creator: Martin Hinshelwood
layout: blog
resourceTypes: blog
slug: solution-to-sub-sites-in-sharepoint-3-0-with-team-foundation-server
aliases:
- /resources/B1bu87flA8w
aliasesArchive:
- /blog/solution-to-sub-sites-in-sharepoint-3-0-with-team-foundation-server
- /solution-to-sub-sites-in-sharepoint-3-0-with-team-foundation-server
- /resources/blog/solution-to-sub-sites-in-sharepoint-3-0-with-team-foundation-server
tags:
- Install and Configuration
- Practical Techniques and Tooling
- Pragmatic Thinking
- Software Development
- Troubleshooting
- Operational Practices
preview: nakedalm-logo-128-link-1-1.png
categories:
- Engineering Excellence

---
This subject goes back over a number of posts:

- [](http://blog.hinshelwood.com/archive/2007/05/31/Team-Foundation-Server-amp-SharePoint-3.0.aspx "Click To View Entry")[Team Foundation Server & SharePoint 3.0](http://blog.hinshelwood.com/archive/2007/05/31/Team-Foundation-Server-amp-SharePoint-3.0.aspx)
- [Setting up TFS to create project portals as child sites of an existing SharePoint 3.0 site (or sub site)](http://blog.hinshelwood.com/archive/2007/05/31/Setting-up-TFS-to-create-project-portals-as-child-sites.aspx)
- [SharePoint 3.0 TFS Sub-Site creation error.](http://blog.hinshelwood.com/archive/2007/06/07/SharePoint-3.0-TFS-Sub-Site-creation-error.aspx)
- [Sharepoint 3.0 TFS Sub-Site creation investigation result](http://blog.hinshelwood.com/archive/2007/06/16/Sharepoint-3.0-TFS-Sub-Site-creation-investigation-result.aspx)

I will try not to reiterate all that has gone before, but I was trying to get the Project Creation Wizard for Team Foundation server to create project portals as sub sites to an existing Sharepoint 3.0 site, and not as top level sites under a "managed path".

This has proved a bumpy ride and I would like to share with you my solution. First I would like to air some of my assumptions and results:

- Can [TFS](http://msdn2.microsoft.com/en-us/teamsystem/aa718934.aspx "Team Foundation Server") 1.1 support this out of the box? **No!**
- Will "Orcas" support this out of the box? **No!**
- If you write a custom Portal creation wizard for TFS will Sharepoint support this? **No!**
- Will "Rosario" support this out of the box? **Unknown!**

To support this as an automated process you would need to:

1. Write a custom web service for Sharepoint 3.0 that uses the API to create the sub site and set it up on Sharepoint 3.0
2. Write a custom Project Creation Wizard module that uses this web service to create the sub site.
3. Update the process template that you use to use your module instead of the default one.
4. Create a site for each of your existing projects and migrate all of the data.
5. Update the Team Foundation Server application-tier SharePoint Service Registration location entry to point to the new WSS 3.0 location.
6. Install the WSS3 update to all Team Explorers that are going to create projects.

\[If I have missed a step, let me know\]

As a stepping stone to creating this process I have implemented an interim solution:

1. Update the process template to **remove** all Sharepoint site creation.
2. Create a site for each of your existing projects and migrate all of the data.
3. Update the Team Foundation Server application-tier SharePoint Service Registration location entry to point to the new WSS 3.0 location.
4. After the creation of a new TFS Project, visit the site you want the projects to appear under and manually create a site using the project name in the URL and using the TFS Sharepoint 3.0 Template.

Although this is a manual step you need to visit the site anyway to add permissions for users. This way, all of the project portals have the same permissions as the parent site.

This works for us for a number of reasons; firstly only two users have permission to create projects; secondly we have a small total number of projects; thirdly we are not creating projects every day, not even every week. This led us to the opinion that our volume would need a major increase to require spending the time implementing the automated approach.

Works for us: Would it work for you?

Technorati Tags: [ALM](http://technorati.com/tags/ALM) [SP 2007](http://technorati.com/tags/SP+2007)
