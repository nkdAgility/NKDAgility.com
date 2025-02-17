---
title: Upgrading to TFS 2010 Beta 1 and SQL Collation
description: Learn how to tackle collation conflicts when upgrading to TFS 2010 Beta 1 from TFS 2008. Discover solutions to ensure a smooth transition!
ResourceId: NdEr9LWJ2ti
ResourceType: blog
ResourceImport: true
ResourceImportId: 109
ResourceImportSource: Wordpress
ResourceImportOriginalSource: GeeksWithBlogs
date: 2009-05-26
creator: Martin Hinshelwood
layout: blog
resourceTypes: blog
slug: upgrading-to-tfs-2010-beta-1-and-sql-collation
aliases:
- /blog/upgrading-to-tfs-2010-beta-1-and-sql-collation
- /upgrading-to-tfs-2010-beta-1-and-sql-collation
- /resources/NdEr9LWJ2ti
- /resources/blog/upgrading-to-tfs-2010-beta-1-and-sql-collation
aliasesFor404:
- /upgrading-to-tfs-2010-beta-1-and-sql-collation
- /blog/upgrading-to-tfs-2010-beta-1-and-sql-collation
- /resources/blog/upgrading-to-tfs-2010-beta-1-and-sql-collation
tags:
- Troubleshooting
- Software Development
- System Configuration
- Windows
preview: metro-visual-studio-2005-128-link-1-1.png
categories:
- Install and Configuration

---
I have just finished installing [TFS](http://msdn2.microsoft.com/en-us/teamsystem/aa718934.aspx "Team Foundation Server") 2010 beta 1 and doing an upgrade of out TFS 2008 data. This did not go well…

Due to a collation mismatch between my original SQL Server 2005 and my new SQL Server 2008 I received an error when upgrading…

> \[Error  @13:57:23.665\] TF255184: An error occurred during operation.  Message=Cannot resolve the collation conflict between "SQL_Latin1_General_CP1_CI_AS" and "Latin1_General_CI_AS" in the equal to operation.  
> Transaction count after EXECUTE indicates a mismatching number of BEGIN and COMMIT statements. Previous count = 0, current count = 1.. Exception=.  
> \[Error  @13:57:23.681\] TF254026: An error occurred during the following operation: Upgrade. The error occurred during the following step group: Upgrade.TfsTeamBuild. It occurred on the following step: Check In Build Process Templates. The following message was returned: Cannot resolve the collation conflict between "SQL_Latin1_General_CP1_CI_AS" and "Latin1_General_CI_AS" in the equal to operation.  
> Transaction count after EXECUTE indicates a mismatching number of BEGIN and COMMIT statements. Previous count = 0, current count = 1..  
> \[Info   @13:57:23.681\] CollectionServicingMonitor - \[5/25/2009 2:56:55 PM\] Servicing step Check In Build Process Templates failed. (ServicingOperation: Upgrade; Step group: Upgrade.TfsTeamBuild)

And then the roll back of the transaction did not quite work as expected, so although the TFS Administration does not know about my OldTfs2008Test1 project collection.

[![image](images/SQLCollationproblemInstallingTFS2010_D181-image_thumb_1-2-2.png)](http://blog.hinshelwood.com/files/2011/05/GWB-WindowsLiveWriter-SQLCollationproblemInstallingTFS2010_D181-image_4.png)
{ .post-img }

My client has it listed but with a TF31001 error.…

[![image](images/SQLCollationproblemInstallingTFS2010_D181-image_thumb-3-3.png)](http://blog.hinshelwood.com/files/2011/05/GWB-WindowsLiveWriter-SQLCollationproblemInstallingTFS2010_D181-image_2.png)
{ .post-img }

Solution? Suck it up and reinstall everything, including SQL and change the collation to the same on both servers. :(

Technorati Tags: [ALM](http://technorati.com/tags/ALM) [TFS 2010](http://technorati.com/tags/TFS+2010) [TFS 2008](http://technorati.com/tags/TFS+2008)
