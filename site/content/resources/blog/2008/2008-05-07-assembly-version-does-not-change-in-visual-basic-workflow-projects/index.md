---
title: Assembly Version does not change in Visual Basic Workflow projects
description: Discover how to resolve the assembly version issue in Visual Basic Workflow projects. Learn the manual fix to ensure your changes are applied correctly!
ResourceId: k9UAGHKPtUz
ResourceImport: true
ResourceImportId: 231
ResourceImportSource: Wordpress
ResourceImportOriginalSource: GeeksWithBlogs
date: 2008-05-07
creator: Martin Hinshelwood
id: "231"
layout: blog
resourceTypes: blog
slug: assembly-version-does-not-change-in-visual-basic-workflow-projects
aliases:
- /blog/assembly-version-does-not-change-in-visual-basic-workflow-projects
- /assembly-version-does-not-change-in-visual-basic-workflow-projects
- /resources/k9UAGHKPtUz
- /resources/blog/assembly-version-does-not-change-in-visual-basic-workflow-projects
aliasesFor404:
- /assembly-version-does-not-change-in-visual-basic-workflow-projects
- /blog/assembly-version-does-not-change-in-visual-basic-workflow-projects
tags:
- develop
- sp2007
- tools
categories:
- code-and-complexity
preview: nakedalm-logo-128-link-4-4.png

---
[![image](images/AssemblyVersiondoesnotchangeinVisualBasi_EE73-image_thumb-3-3.png)](http://blog.hinshelwood.com/files/2011/05/GWB-WindowsLiveWriter-AssemblyVersiondoesnotchangeinVisualBasi_EE73-image_2.png) If you are having an issue with the assembly version in your compiled assembly not updating after a rebuild then you are not alone. The is a bug in the Visual Basic compiler that causes this problem and it requires a manual fix:
{ .post-img }

[http://kbalertz.com/952628/Assembly-Version-change-Visual-Basic-Workflow-projects.aspx](http://kbalertz.com/952628/Assembly-Version-change-Visual-Basic-Workflow-projects.aspx "http://kbalertz.com/952628/Assembly-Version-change-Visual-Basic-Workflow-projects.aspx")

Not hard, but annoying...

[![image](images/AssemblyVersiondoesnotchangeinVisualBasi_EE73-image_thumb_1-1-1.png)](http://blog.hinshelwood.com/files/2011/05/GWB-WindowsLiveWriter-AssemblyVersiondoesnotchangeinVisualBasi_EE73-image_4.png)To check the problem, double click on the assembly in your bin folder and open out the version tag.
{ .post-img }

[![image](images/AssemblyVersiondoesnotchangeinVisualBasi_EE73-image_thumb_4-2-2.png)](http://blog.hinshelwood.com/files/2011/05/GWB-WindowsLiveWriter-AssemblyVersiondoesnotchangeinVisualBasi_EE73-image_10.png)You can see from the image below what I am getting at. This causes no end of problems with signed assemblies. The KBAlertz article above implies that this only affects Workflow assemblies. But I have has t6his problem in other types of Visual Basic project.
{ .post-img }

This is not a big problem unless you are creating custom assemblies for SharePoint and have a convoluted deployment process before you can test, and can't figure out why you changes are not going through...

Technorati Tags: [.NET](http://technorati.com/tags/.NET) [SP 2007](http://technorati.com/tags/SP+2007)
