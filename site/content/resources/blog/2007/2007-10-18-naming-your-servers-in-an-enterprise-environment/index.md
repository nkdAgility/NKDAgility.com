---
id: "299"
title: "Naming your servers in an enterprise environment"
date: "2007-10-18"
categories: 
  - "code-and-complexity"
tags: 
  - "configuration"
  - "fail"
  - "infrastructure"
  - "tools"
coverImage: "nakedalm-logo-128-link-1-1.png"
author: "MrHinsh"
type: blog
slug: "naming-your-servers-in-an-enterprise-environment"
---

This is an issue of contention in many companies, but I am firmly of the belief that server names should be at least consistent and at most should be able impart a large amount of information at a glance. Information should include:

- Where the server is
- What operating system it is running
- wither it is an application or database server (or a virtual hosting environment server)
- What the application or system it is running
- the environment it is for

This is a tall order, and I have worked many places that have server names like "glasgow1", "glasgow2", "exchange" or "fileserver". I even went through a phase of naming servers "Titan" or "Colossus". This is fine if you have at most 5 servers, but once you get to the data center or multiple data center level you need something more meaningfully.

All this was knocked out of me when I started working for Merrill Lynch. They have thousands of servers and applications and systems that consist of 70-80 servers at a time and you need to be able to identify servers on your network more easily.

I grew to like Merrill's naming convention which is:

> _\[where\]\[virtual?\]\[OS\]\[Application|database\]\[system\]\[environment\]\[identifier\]_

If you had a server in London that runs on a virtual host with a Microsoft operating system that is an application server for SharePoint in the development environment, and it is the first server you would get \[elon\]\[v\]\[m\]\[ap\]\[sp\]\[d\]\[01\] (elonvmapspd01).

Lets look at an example where you have 2 web servers, 1 application server and 1 SQL server for your SharePoint production deployment:

> _Glasgow1, Glasgow2, Glasgow3, Glasgow4_

Now add your development, Quality Assurance and User Acceptance Testing environments:

> _Glasgow1, Glasgow2, Glasgow3, Glasgow4_, _Glasgow5, Glasgow6, Glasgow7, Glasgow8_, _Glasgow9, Glasgow10, Glasgow11, Glasgow12_, _Glasgow13, Glasgow14_

Now, in the intervening time, the company adds a TFS server development environment for testing:

> _Glasgow1, Glasgow2, Glasgow3, Glasgow4_, _Glasgow5, Glasgow6, Glasgow7, Glasgow8_, _Glasgow9, Glasgow10, Glasgow11, Glasgow12_, _Glasgow13, Glasgow14_, Glasgow15, Glasgow16

Do you see the problem. If you now want to add another web server to your production SharePoint it would be "Glasgow17". Oh, and we need to add our TFS UAT environment, and lets not forget a SharePoint disaster recovery environment.

> _Glasgow1, Glasgow2, Glasgow3, Glasgow4_, _Glasgow5, Glasgow6, Glasgow7, Glasgow8_, _Glasgow9, Glasgow10, Glasgow11, Glasgow12_, _Glasgow13, Glasgow14, Glasgow15, Glasgow16, Glasgow17, Glasgow18, Glasgow19, Glasgow20, Glasgow21, Glasgow22, Glasgow23, Glasgow24, Glasgow25_ 

**Do you remember which server is which? Try and identify a development SharePoint application server? :)**

This method just does not work in an enterprise environment...

Technorati Tags: [Fail](http://technorati.com/tags/Fail)



