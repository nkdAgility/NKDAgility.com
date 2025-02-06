---
title: Deployment documentation
description: Explore effective deployment strategies for complex applications across multiple environments. Learn how to gain control and streamline updates with ease.
ResourceId: 154BNVcnbaU
ResourceType: blog
ResourceImport: true
ResourceImportId: 363
ResourceImportSource: Wordpress
ResourceImportOriginalSource: GeeksWithBlogs
date: 2007-07-23
creator: Martin Hinshelwood
id: "363"
layout: blog
resourceTypes: blog
slug: deployment-documentation
aliases:
- /blog/deployment-documentation
- /deployment-documentation
- /resources/154BNVcnbaU
- /resources/blog/deployment-documentation
aliasesFor404:
- /deployment-documentation
- /blog/deployment-documentation
- /resources/blog/deployment-documentation
categories:
- code-and-complexity
preview: metro-binary-vb-128-link-1-1.png

---
Over the past week I have been working on creating and documenting a deployment process for our new main business application. This application is very complicated and requires twenty servers per four environments. We need to track and control deployment to UAT, pre-production, production and C&R (disaster recovery site), but my company as a larger organization only requires control of production.

Now at the moment all the deployments are done by the vendor and is done by updating Assemblies on various servers, then running a custom tool that updates the config files based on the version of the assembly that has been updated. All database updates are currently done manually, and I rather doubt that there is any pre scripted rollback for the schema changes.

I have been tasked with coming up with a solution that allows us and not the vendor to easily update and rollback any deployments necessary. Now, this project has been one of those "Of-The-Shelf" products that has required eight months of "configuration" (I can configure any system with Visual Studio too) and is not yet stable.

The application is made up of over twenty components that exist on multiple servers over multiple environments and soon over multiple instances.

Once it is stable however, I would like to see the vendor providing their updates the same way that any major application is delivered:

- The Major Release (v1.0 to v2.0) + rollup of all Service Packs and Hotfixes
- the Service Pack (v1.0 to v1.1) + rollup of Hotfixes
- and the Hotfix (v1.0 to v1.0.1)

If it works :) then we will be able to do deploy any number of instances of the solution and be able to replicate any version of the solution.

I want the vendor to provide MSI or EXE's for all releases of each of the components, but the rollback function must be implemented religiously. This will reduce the risk in any deployment as it currently takes two to three days to do a clean build of the application. It should also force the vendor to invest in the quality of their application, because if any of the installations or rollbacks go wrong in the Dev environment then we will "return to sender" for a recheck or rebuild.

**Has anyone ever tried to get their vendor to do this?**

**Has anyone been successfully?**

Technorati Tags: [.NET](http://technorati.com/tags/.NET)
