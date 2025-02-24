---
title: Granting access to Team Foundation Server 2012 for diagnostic troubleshooting
description: Learn how to grant access to TFS 2012 for diagnostic troubleshooting without full admin rights. Enhance your efficiency with simple command line solutions!
ResourceId: 8N31NtGZFyB
ResourceType: blog
ResourceImport: true
ResourceImportId: 10002
ResourceImportSource: Wordpress
ResourceImportOriginalSource: Wordpress
date: 2013-09-24
creator: Martin Hinshelwood
layout: blog
resourceTypes: blog
slug: granting-access-team-foundation-server-2012-diagnostic-troubleshooting
aliases:
- /blog/granting-access-team-foundation-server-2012-diagnostic-troubleshooting
- /granting-access-team-foundation-server-2012-diagnostic-troubleshooting
- /granting-access-to-team-foundation-server-2012-for-diagnostic-troubleshooting
- /blog/granting-access-to-team-foundation-server-2012-for-diagnostic-troubleshooting
- /resources/8N31NtGZFyB
- /resources/blog/granting-access-team-foundation-server-2012-diagnostic-troubleshooting
aliasesFor404:
- /granting-access-team-foundation-server-2012-diagnostic-troubleshooting
- /blog/granting-access-team-foundation-server-2012-diagnostic-troubleshooting
- /granting-access-to-team-foundation-server-2012-for-diagnostic-troubleshooting
- /blog/granting-access-to-team-foundation-server-2012-for-diagnostic-troubleshooting
- /resources/blog/granting-access-team-foundation-server-2012-diagnostic-troubleshooting
tags:
- Troubleshooting
- Install and Configuration
- Practical Techniques and Tooling
- System Configuration
categories: []
preview: nakedalm-experts-visual-studio-alm-3-3.png

---
In TFS 2012 the product team added a way to get to the tbl_Command information without needing to connect directly to the SQL Server and having access to the tables. This was an awesome add as being able to diagnose server issues and troubleshoot user reported problems makes us a little more efficient.

![image](images/image11-1-1.png "image")  
{ .post-img }
Figure: Viewing the diagnostic activity logs for troubleshooting

However I had always had to give access by adding the user to the “Team Foundation Administrators” group which is a little too much power just to do a little diagnostic spelunking… so my question is:

How do I give permission to the Activity Log without giving TFS Administrator?

Well, it looks like the command line has the answer. Although there is no representative entry in the GUI to give permission for a user only to the diagnostic troubleshooting page you can grant it explicitly:

```
tfssecurity /a+ Diagnostic Diagnostic Troubleshoot n:domain\username ALLOW /server:http://tfsserver:8080

```

This gives that group explicit access.

![image](images/image12-2-2.png "image")  
{ .post-img }
Figure: Use the command line to grant diagnostic troubleshooting permission

What might be a better and more manageable solution would be to create a group called “Team Foundation Troubleshooters” and instead grant that group permission to that access control. This is done in exactly the same way, you just need to replace the domain account with the TFS Group.
