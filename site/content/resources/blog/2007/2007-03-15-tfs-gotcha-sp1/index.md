---
id: "428"
title: "TFS Gotcha (SP1)"
date: "2007-03-15"
coverImage: "nakedalm-logo-128-link-1-1.png"
author: "MrHinsh"
type: "post"
slug: "tfs-gotcha-sp1"
---

If you are out there and you have installed SP1 for Team Foundation Server you probably went through as much pain as I did...

Solution:

1. Install Data Tier as per documentation.
2. Install Application Tier as per documentation.
3. Install SP1 on data Tier.
4. Repair TFS on data tier
5. Install SP1 on application tier.
6. Repair TFS application tier

If at any point you have a problem. You can always uninstall SP1 from both of the tiers and get the system working again. There are a number of solutions out there, including this one, which can fix the problems you have with TFS SP1... None of them worked for me...

Technorati Tags: [ALM](http://technorati.com/tags/ALM)



