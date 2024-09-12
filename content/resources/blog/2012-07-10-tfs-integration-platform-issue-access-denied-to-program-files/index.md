---
id: "6113"
title: "TFS Integration Tools – Issue: Access denied to Program Files"
date: "2012-07-10"
categories: 
  - "problems-and-puzzles"
tags: 
  - "kb"
  - "puzzles"
  - "tfs2012"
  - "tfs-integration-platform"
coverImage: "metro-problem-icon-1-1.png"
author: "MrHinsh"
type: "post"
slug: "tfs-integration-platform-issue-access-denied-to-program-files"
---

You get a Unauthorised Access Exception when the TFS Integration Platform tries to write a file to the ‘C:Program Files (x86)Microsoft Team Foundation Server Integration Tools2768.txt’ folder.

[![image](images/image_thumb9.png "image")](http://vsalm.blob.core.windows.net/blog-store/files/2012/07/image9.png)  
**Figure: Access denied to Program Files?**

This is a runtime error that must be resolved to continue.

### Applies to

- TFS Integration Tools, version 2.2, March 2012

### Finding

We are calling web services and as with all things web, things go awry occasionally. In this case we may not have gotten an timely response from the server. This does not mean that things have gone wrong, but instead that we may need to retry an action. Rather then choke the TFS Integration Platform does a “Code Review” and needs to write to its own local folder in order to save the log file required.

[![7-6-2012 12-52-15 PM](images/7-6-2012-12-52-15-PM_thumb.png "7-6-2012 12-52-15 PM")](http://vsalm.blob.core.windows.net/blog-store/files/2012/07/7-6-2012-12-52-15-PM.png)  
**Figure: Code Review conflict**

Just in case the Integration Platform throws a “Conflict” that needs to be resolved manually to continue. One of the options is to “Retry” and 100% of the times that we got this error that worked a treat.

### Workaround

Right click on the “Microsoft Team Foundation Server Integration Tools” and add permission for the account that you are running the TFS Integration Tools under.

