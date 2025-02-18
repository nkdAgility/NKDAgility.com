---
title: Visual Studio Team System 2008 Database Edition GDR has been released!
description: Discover the new Visual Studio Team System 2008 Database Edition GDR, featuring enhanced scalability, extensibility, and a standalone deployment engine. Download now!
ResourceId: VkCGOULM8GF
ResourceType: blog
ResourceImport: true
ResourceImportId: 162
ResourceImportSource: Wordpress
ResourceImportOriginalSource: GeeksWithBlogs
date: 2008-11-26
creator: Martin Hinshelwood
layout: blog
resourceTypes: blog
slug: visual-studio-team-system-2008-database-edition-gdr-has-been-released
aliases:
- /blog/visual-studio-team-system-2008-database-edition-gdr-has-been-released
- /visual-studio-team-system-2008-database-edition-gdr-has-been-released
- /visual-studio-team-system-2008-database-edition-gdr-has-been-released-
- /blog/visual-studio-team-system-2008-database-edition-gdr-has-been-released-
- /resources/VkCGOULM8GF
- /resources/blog/visual-studio-team-system-2008-database-edition-gdr-has-been-released
aliasesFor404:
- /visual-studio-team-system-2008-database-edition-gdr-has-been-released
- /blog/visual-studio-team-system-2008-database-edition-gdr-has-been-released
- /visual-studio-team-system-2008-database-edition-gdr-has-been-released-
- /blog/visual-studio-team-system-2008-database-edition-gdr-has-been-released-
- /resources/blog/visual-studio-team-system-2008-database-edition-gdr-has-been-released
tags:
- Products and Books
- Software Development
- News and Reviews
- Practical Techniques and Tooling
- Install and Configuration
- Technical Mastery
- Technical Excellence
- Release Management
- Deployment Strategies
categories:
- Engineering Excellence
- DevOps

---
What a mouthful! Has there ever been any products with names as long as the Team System toolset ;), Maybe thats why it is just called [Data Dude](http://www.microsoft.com/downloads/details.aspx?FamilyID=bb3ad767-5f69-4db9-b1c9-8f55759846ed&displaylang=en).

Anyway, congratulations to the [Data Dude](http://www.microsoft.com/downloads/details.aspx?FamilyID=bb3ad767-5f69-4db9-b1c9-8f55759846ed&displaylang=en) team for this wonderful piece of work. I have been following the GDR for a while and I have been very impressed with the capabilities on offer.

Although this is billed as a new release of [Data Dude](http://www.microsoft.com/downloads/details.aspx?FamilyID=bb3ad767-5f69-4db9-b1c9-8f55759846ed&displaylang=en), it is really a completely new product with a brand new architecture. They have made many improvements to scalability, and they have added many extensibility  points (Microsoft speak for places where you can inject your own functionality).

### Model based architecture

Everything underneath the covers is based on a true model representation of the SQL Server schema. This facilitates a true offline declarative database development system where the source code defines the shapes of the schema objects.

### **Database Schema Providers**

Models are implemented by **Database Schema Providers**, DSP's for short. - The introduction of a provider model enables multiple things at once. First of all the decoupling of release vehicles. For example when SQL Server will release a new version or adds new functionality in a service pack, like they did in SQL Server 2005 SP2 when adding "vardecimal" support, we can simply update an existing provider or provide a new one in case of a new SQL Server release. Overtime we will go to a model where the SQL Server providers will be an integral part of the SQL Server release. The provider model is also a key extensibility point, allowing 3rd parties to extend database project ecosystem and add support for other database platforms in Visual Studio Team System 2010.

### Tool extensibility

In this release external tool writers have full access to the T-SQL parsers (for SQL Server 2000, 2005 and 2008), the SQL Script DOM and the schema model (when inside Visual Studio). This adds on top of the ability to write extend the tools inside the platform. You can extend T-SQL refactoring by writing your own refactoring types (operations) and refactoring targets; add T-SQL Static Code Analysis rules, data generators, data distributions and test conditions. Database Projects (.dbproj) now provide a truly extensible declarative database development platform.

### Separation of BUILD and DEPLOY

The separation of build & deploy makes it possible to deploy the output of your database project to many different targets and different points in time. Build now produces a single artifact file hat describes the schema inside your database, called a .DBSCHEMA file. This file is used by the deployment engine to deploy your schema.

### **Standalone Deployment Engine**.

The inclusion of a standalone and [redistributable](http://blogs.msdn.com/gertd/archive/2008/08/22/redist.aspx) deployment engine makes it possible to deploy the output of your database projects (.DBSCHEMA files) to a target database without the need of having Visual Studio Team System Database Edition installed. This enables key scenarios like the inclusion of database schema deployment as part of your application installation.

Get it now :)

> **Download page**  
> [http://www.microsoft.com/downloads/details.aspx?FamilyID=bb3ad767-5f69-4db9-b1c9-8f55759846ed&displaylang=en](http://www.microsoft.com/downloads/details.aspx?FamilyID=bb3ad767-5f69-4db9-b1c9-8f55759846ed&displaylang=en)  
> **Setup**  
> [http://download.microsoft.com/download/0/a/e/0ae1153a-8798-474a-93e6-d19299f37c8b/setup.exe](http://download.microsoft.com/download/0/a/e/0ae1153a-8798-474a-93e6-d19299f37c8b/setup.exe)
>
> - **Read Me**  
>    [http://download.microsoft.com/download/0/a/e/0ae1153a-8798-474a-93e6-d19299f37c8b/Readme.mht](http://download.microsoft.com/download/0/a/e/0ae1153a-8798-474a-93e6-d19299f37c8b/Readme.mht)
> - **Documentation:**  
>    [http://download.microsoft.com/download/0/a/e/0ae1153a-8798-474a-93e6-d19299f37c8b/Documentation.zip](http://download.microsoft.com/download/0/a/e/0ae1153a-8798-474a-93e6-d19299f37c8b/Documentation.zip)

Technorati Tags: [ALM](http://technorati.com/tags/ALM) [TFS](http://technorati.com/tags/TFS)
