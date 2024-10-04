---
id: "182"
title: "MSBuild and Business Intelligence Packages, Ahhhhhh!"
date: "2008-10-24"
tags:
  - "tfs-build"
  - "tools"
coverImage: "nakedalm-logo-128-link-1-1.png"
author: "MrHinsh"
layout: blog
resourceType: blog
slug: "msbuild-and-business-intelligence-packages-ahhhhhh"
---

I have been trying to get a handle on doing an automated build of our Business Intelligence solutions and I am always running into problems around the (IMO badly build) BI Packages that are installed via SQL. They do not support Test, they do not support build. There has been no thought given to how people working on them are going to build test and support them and even the project files are not written in the same schema as the rest of the Visual Studio bits. I would have thought, with Team Foundation Server in its third year and second version that this would have been rectified in SQL 2008, but no such luck.

Today there are enormous BI solutions out there. Some built using these tools, and everyone needs to come up with their own solutions to this problem.

Here are some of the problems:

- How do you automate the deployment of SSIS packages?
- How do you Unit test, load test and analyse the performance of SSIS packages?
- How do you automate those tests of SSIS packages?
- How do you automate the deployment of SSAS cubes?
- How do you Unit test, load test and analyse the performance of SSAS cubes?
- How do you automate those tests of SSAS cubes?
- How do you automate the deployment of script packages?
- How do you Unit test, load test and analyse the performance of script packages?
- How do you automate those tests of script packages?

There are some answers. The visual studio team has taken on board the database piece with Visual Studio Team Edition for Databases. But the rest are languishing in perdition and there are no elegant solutions.

I am bookmarking my investigation on [delicious](http://delicious.com/hinshelm/MSBuild), but it will be a long slog…

Technorati Tags: [ALM](http://technorati.com/tags/ALM) [TFBS](http://technorati.com/tags/TFBS)