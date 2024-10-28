---
title: RDdotNET Project Created
description: "Discover the RD.NET Community Foundation, a powerful new project enhancing service-oriented architecture with globalisation, relationship, and shell services."
date: 2006-11-22
creator: Martin Hinshelwood
id: "460"
layout: blog
resourceType: blog
slug: rddotnet-project-created
aliases:
  - /blog/rddotnet-project-created
tags:
  - service-oriented-architecture
preview: nakedalm-logo-128-link-1-1.png
---

I have now created a new project within [CodePlex](http://www.codeplex.com "CodePlex") that encompases all of the features of WhiteLabel, but with a whole host of extras. The WhiteLabel project is now complete and a release will be uploaded as soon as [CodePlex](http://www.codeplex.com "CodePlex") starts working again.

[http://www.codeplex.com/RDdotNET](http://www.codeplex.com/RDdotNET)[](http://www.codeplex.com/Wiki/View.aspx?ProjectName=RDdotNET)

The new project is called "RD.NET Community Foundation" and will provide a building block for a number of types of community site. I plan to build a number of services for this system in addition to WhiteLabel.

- **GlobalisationService** - This service will handle text and other localisation elements for any site. It will allow the user to have multiple languages on one site and hopefully implement such things a LHS/RHS and posibly coloquial layouts as a extention to the WhiteLabel service.
- **RelationshipService** - The ralationship service will handle multiple types of relationships for multiple sites. e.g. Contact Management, Dating, Networking among others.
- **ShellService** - The shell service will provide access to an application built using the Client Application block that will load modules on demand from a sql server backend. It will implement versioning and user authentication. I hope to manage the failier of any modules so that other modules are not affected.

The whole system will be fully extensable in teh same vain as the current WhiteLabel service in that all the services have a set of client assemblies that allow the developer to configure which services he is connecting to and where he is connecting to them from a simple one line config section.

This is a big chalange for me and will take some time. I will not be giving up... I may write some documentation as well.

Technorati Tags: [.NET](http://technorati.com/tags/.NET) [SOA](http://technorati.com/tags/SOA)

