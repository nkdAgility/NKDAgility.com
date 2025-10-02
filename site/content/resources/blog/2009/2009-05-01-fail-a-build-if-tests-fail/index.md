---
title: Fail a build if tests fail
description: Explains how to configure TFS 2008 builds to automatically fail if any tests fail by setting TreatTestFailureAsBuildFailure to true in the build project file.
date: 2009-05-01
lastmod: 2009-05-01
weight: 690
sitemap:
  filename: sitemap.xml
  priority: 0.2
  changefreq: weekly
ItemId: VuY5udPg1uD
ItemType: blog
ItemKind: resource
ItemContentOrigin: Human
slug: fail-a-build-if-tests-fail
aliases:
  - /resources/VuY5udPg1uD
aliasesArchive:
  - /blog/fail-a-build-if-tests-fail
  - /fail-a-build-if-tests-fail
  - /resources/blog/fail-a-build-if-tests-fail
layout: blog
concepts: []
categories:
  - Uncategorized
tags:
  - Software Development
Watermarks:
  description: 2025-05-13T15:24:14Z
ResourceId: VuY5udPg1uD
ResourceType: blog
ResourceImportId: 127
creator: Martin Hinshelwood
resourceTypes: blog
preview: metro-visual-studio-2005-128-link-1-1.png

---
It took me longer than I thought it would to find this, but is you are using TFS2008 and you want builds to fail if any of the tests fail then you can add the following to the tests properties group in your build project (TFSBuild.prof)

```
<PropertyGroup>
  <!-- TEST ARGUMENTS
   If the RunTest property is set to true, then particular tests within a
   metadata file or test container may be specified here.  This is
   equivalent to the /test switch on mstest.exe.

   <TestNames>BVT;HighPriority</TestNames>
  -->
  <TreatTestFailureAsBuildFailure>true</TreatTestFailureAsBuildFailure>
</PropertyGroup>
```

Very handy…

Technorati Tags: [TFBS](http://technorati.com/tags/TFBS) [ALM](http://technorati.com/tags/ALM) [TFS 2008](http://technorati.com/tags/TFS+2008)
