---
title: What about hosting the Tfs Automation Platform
date: 2011-05-31
creator: Martin Hinshelwood
id: "3365"
layout: blog
resourceType: blog
slug: what-about-hosting-the-tfs-automation-platform-2
aliases:
  - /blog/what-about-hosting-the-tfs-automation-platform-2
tags:
  - nwcadence
  - tfs
  - tfs2010
  - tfsap
  - tools
  - visual-studio
  - vs2010
  - vsalmrangers
preview: metro-visual-studio-2010-128-link-1-1.png
---

[![](images/4810.TFSonAzure.jpg)](http://blogs.msdn.com/cfs-file.ashx/__key/communityserver-blogs-components-weblogfiles/00-00-01-44-14/4810.TFSonAzure.jpg)I have been asked what would be the process or support for hosting the Tfs Automation Platform either from a hosting provider, or in the cloud if we have server side components. If you are not familiar with TFS on Azure make sure you read:
{ .post-img }

- [Update on TFS on Azure](http://blogs.msdn.com/b/bharry/archive/2011/05/18/update-on-tfs-on-azure.aspx) from [Brian Harry](http://blogs.msdn.com/b/bharry)
- [“To the cloud” with TFS](http://blogs.msdn.com/b/bryang/archive/2011/05/20/to-the-cloud-with-tfs.aspx) from [Bryan Group](http://blogs.msdn.com/b/bryang)
- [The Future of Microsoft Visual Studio Application Lifecycle Management](http://channel9.msdn.com/Events/TechEd/NorthAmerica/2011/FDN03) on [Channel 9](http://channel9.msdn.com/)
- [Team Foundation Server on Windows Azure Preview](http://www.microsoft.com/visualstudio/en-us/team-foundation-server-on-windows-azure-preview "http://www.microsoft.com/visualstudio/en-us/team-foundation-server-on-windows-azure-preview")

**note: This product is still under development and this document is subject to change. There is also the strong possibility that these are just rambling fantasies of a mad programmer with an architect complex.**

---

The Platform architecture currently involves extensive server side components. In fact almost all of the functionality is provided from the server from configuration to implementation.

I have thought about this a lot and although I recognise the problem I would not want to sacrifice functionality for this scenario. Although some of the functionality would be possible a large chuck of possible features as well as all of the resilience would be severely impaired by removing the server side components.

It would be up to the hosting provider to install the server-side components to enable the user to use this system. Think of it like the Wordpress Plugin system. Some hosting providers allow you to have any plugin you like, while others require that you can only select from a list of approved plugins.

I would want to make it as easy as possible to configure the hosted TFS server to only load “Automation packages” from a Store provided by the host themselves. For example if they deployed a managed server on “nwcadence.tfsazure.com” they would also deploy the server side components and configure it to look at “automationstore.tfsazure.com” that would provide a vetted list of add-ons. I do want to look at the possibility of having a kind of “validated proxy” as part of the store so a “Super Admin” can log into the proxy and approve updates and new Automations from the central store.

In saying that, although I have thought about it, that by no means guarantees that this feature will be above the cut line for Release 1.

_Boy, I am sounding more Microsoft by the year!_

I would be very interested in what you think of the option to have a client only install.

What functionality would we loose if we settled for client ony:

- **No additional client installs (apart from framework updates)** If components are  not loading from a server then there would need to be frequent updated to the client tool. This would not be so bad with a small user base (<5) but once you get more (>5) then it becomes unworkable and no longer a viable solution.
- **Resilience from communication or infrastructure problems** What happens when the server is rebooted, or a user looses VPN?
- **Multi-User support** What if two users perform the same task at the same time. We have customers who have 500+ users, the chances of a conflict are high. How does one user change the configuration setup by another user?
- **more…**

What do you think, are the features above important?
