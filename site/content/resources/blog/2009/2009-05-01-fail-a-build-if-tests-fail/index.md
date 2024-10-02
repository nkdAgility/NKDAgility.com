---
id: "127"
title: "Fail a build if tests fail"
date: "2009-05-01"
tags:
  - "tfs-build"
  - "tfs"
  - "tfs2008"
  - "tools"
coverImage: "metro-visual-studio-2005-128-link-1-1.png"
author: "MrHinsh"
type: blog
slug: "fail-a-build-if-tests-fail"
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
