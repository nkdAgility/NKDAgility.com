---
title: Why Integrated Authentication does not work with host headers!
description: Discover why Integrated Authentication fails with host headers in TFS and learn how to resolve the 401.1 error for smoother access. Get insights now!
ResourceId: WqcZtyTF5t3
ResourceType: blog
ResourceImport: true
ResourceImportId: 296
ResourceImportSource: Wordpress
ResourceImportOriginalSource: GeeksWithBlogs
date: 2007-10-22
creator: Martin Hinshelwood
id: "296"
layout: blog
resourceTypes: blog
slug: why-integrated-authentication-does-not-work-with-host-headers
aliases:
- /blog/why-integrated-authentication-does-not-work-with-host-headers
- /why-integrated-authentication-does-not-work-with-host-headers
- /why-integrated-authentication-does-not-work-with-host-headers-
- /blog/why-integrated-authentication-does-not-work-with-host-headers-
- /resources/WqcZtyTF5t3
- /resources/blog/why-integrated-authentication-does-not-work-with-host-headers
aliasesFor404:
- /why-integrated-authentication-does-not-work-with-host-headers
- /blog/why-integrated-authentication-does-not-work-with-host-headers
- /why-integrated-authentication-does-not-work-with-host-headers-
- /blog/why-integrated-authentication-does-not-work-with-host-headers-
- /resources/blog/why-integrated-authentication-does-not-work-with-host-headers
tags:
- tfs
categories:
- problems-and-puzzles

---
**You receive error 401.1 when you browse a [TFS](http://msdn2.microsoft.com/en-us/teamsystem/aa718934.aspx "Team Foundation Server") Web site that uses Integrated Authentication and is hosted on IIS 5.1 or IIS 6**

This little problem occurs when you have Windows 2003 SP1 or later installed and you try to change your Team Foundation Server to a friendly name, like say tfs01.\[intranet\].\[company\].com.

What I found was that when you tried to view tfs01.\[intranet\].\[company\].com on the local server, it popped up an authentication dialog and would not allow you in. Eventually giving you a 401 error.

I consulted with one of Aggreko's Infrastructure Team guys, Gary Hay (no blog! Gary...Get a blog) , who when I pointed out the problem said, in way more polite terms, "WTF"!

After a surprisingly short time, he sent me a link and told me it was fixed: [http://support.microsoft.com/kb/896861](http://support.microsoft.com/kb/896861 "http://support.microsoft.com/kb/896861")

> _This issue occurs if you install Microsoft Windows XP Service Pack 2 (SP2) or Microsoft Windows Server 2003 Service Pack 1 (SP1). Windows XP SP2 and Windows Server 2003 SP1 include a loopback check security feature that is designed to help prevent reflection attacks on your computer. Therefore, authentication fails if the FQDN or the custom host header that you use does not match the local computer name._

First, why would you want your server called the same as your website, and second, why would you NOT be hosting multiple sites under multiple host headers on the same server. I can only think of a couple of servers I have setup that have only one site, and it is NEVER called the same thing as the server...

After some testing I found that it was indeed fixed. Now, I had this exact same problem at Merrill Lynch and even with their hundreds, if not thousands of technical folk, no one could solve the problem. Just goes to show...just coz you are big and have masses of people, does not mean you have the right people...

![smile_teeth](images/smile_teeth-1-1.gif) Thanks Gary...
{ .post-img }

Technorati Tags: [ALM](http://technorati.com/tags/ALM) [TFS](http://technorati.com/tags/TFS)
