---
id: "257"
title: "The SharePoint Plan: Database move headache mitigation"
date: "2008-01-31"
categories:
  - "code-and-complexity"
  - "problems-and-puzzles"
tags:
  - "configuration"
  - "fail"
  - "infrastructure"
  - "sharepoint"
  - "sp2007"
  - "tools"
coverImage: "metro-sharepoint-128-link-1-1.png"
author: "MrHinsh"
layout: blog
resourceType: blog
slug: "the-sharepoint-plan-database-move-headache-mitigation"

aliases:
  - /blog/the-sharepoint-plan-database-move-headache-mitigation
---

SharePoint requires SQL Server. That's a given, but what if you want to move the SQL Server databases to another server? [TFS](http://msdn2.microsoft.com/en-us/teamsystem/aa718934.aspx "Team Foundation Server") is easy enough to move between servers, but SharePoint is NOT. The only answer I can find is to do a full backup and restore from SharePoint, which takes time and effort.

> **The Plan**
>
> I will use a local SQL server with a named instance of "EPDev", but I will also use a DNS name for the server "_dpdata.ep-dev.\[domain\].biz_". This will allow me to, hopefully, move the databases without having to spend the weekend doing it. I should be able to backup and turn off the SQL server. Re-point "_dpdata.ep-dev.\[domain\].biz_" to the new SQL Cluster and restore the databases to the "_dpdata.ep-dev.\[domain\].biz/EPDev_" instance on that server. Then I will bring up the SharePoint server. This should work, but I have not as yet tested it...

Hopefully this will not screw up, but I will take steps to provide for that

probability possibility...

Microsoft: if you are listening, please make moving a SharePoint database as easy as TFS!

Technorati Tags: [Fail](http://technorati.com/tags/Fail) [SP 2007](http://technorati.com/tags/SP+2007)

