---
title: Fail a build if tests fail
description: Explains how to configure TFS 2008 builds to automatically fail if any tests fail by setting TreatTestFailureAsBuildFailure to true in the build project file.
ResourceId: VuY5udPg1uD
ResourceType: blog
ResourceContentOrigin: Human
ResourceImport: true
ResourceImportId: 127
ResourceImportSource: Wordpress
ResourceImportOriginalSource: GeeksWithBlogs
date: 2009-05-01
weight: 690
creator: Martin Hinshelwood
layout: blog
resourceTypes: blog
slug: fail-a-build-if-tests-fail
aliases:
- /resources/VuY5udPg1uD
aliasesArchive:
- /blog/fail-a-build-if-tests-fail
- /fail-a-build-if-tests-fail
- /resources/blog/fail-a-build-if-tests-fail
tags:
- Software Development
preview: metro-visual-studio-2005-128-link-1-1.png
categories:
- Uncategorized
Watermarks:
  description: 2025-05-13T15:24:14Z
concepts: []

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
