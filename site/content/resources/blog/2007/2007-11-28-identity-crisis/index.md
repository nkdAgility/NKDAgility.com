---
title: Identity crisis
date: 2007-11-28
creator: Martin Hinshelwood
id: "285"
layout: blog
resourceType: blog
slug: identity-crisis
aliases:
  - /blog/identity-crisis
tags:
  - infrastructure
  - off-topic
  - tools
categories:
  - code-and-complexity
preview: nakedalm-logo-128-link-1-1.png
---

I am having a look at Microsoft's [Identity Lifecycle Manager 2007](http://www.microsoft.com/windowsserver/ilm2007/default.mspx) as a solution to our disparate user identity problem. Some of the bigger companies out there have solved this problem, and in many of the smaller companies it just does not exist, but we have many system that hold meta data about our employees. From HR systems to Active Directory and custom web based address books. Because of Aggreko's unprecedented growth these systems have outgrown our capacity to maintain the consistency of the data, with small groups responsible for each repository and everyone not knowing where ALL the repository's are or who controls them.

The idea of [ILM](http://www.microsoft.com/windowsserver/ilm2007/default.mspx) server is to provide a single "metaverse" where all of the data is stored that has agents and adapters for all of the systems that you have. These agents and adapters are responsible for pulling and pushing the data between the stores in a consistent manor, so if HR in France updates a users job title it gets pulled into the "metaverse" and then pushed out to all of other system connected to [ILM](http://www.microsoft.com/windowsserver/ilm2007/default.mspx).

> #### **How Identity Lifecycle Manager 2007 Works**
>
> [![](images/48505_375x262_miis_f.jpg)](http://www.microsoft.com/windowsserver/ilm2007/overview.mspx)
> { .post-img }

Out of the box ILM 2007 [supports](http://www.microsoft.com/windowsserver/ilm2007/overview.mspx) the following agents and connectors:

> **_Network Operating Systems and Directory Services_**
>
> _Microsoft Active Directory Windows Server 2003 R2, 2003, and 2000  
> Microsoft Active Directory Application Mode Windows Server 2003 R2 and 2003  
> Microsoft Windows NT 4.0  
> IBM Tivoli Directory Server  
> Novell eDirectory 8.6.2, 8.7, and 8.7.x  
> Sun Directory Server (Netscape/iPlanet/SunONE) 4.x and 5.x_
>
> **_Mainframe_**
>
> _IBM Resource Access Control Facility  
> Computer Associates eTrust ACF2  
> Computer Associates eTrust Top Secret_
>
> **_Email and Messaging_**
>
> _Microsoft Exchange 2007, 2003, 2000, and 5.5  
> Lotus Notes 6.x, 5.0, and 4.6_
>
> **_Applications_**
>
> _SAP 5.0 and 4.7  
> Telephone switches  
> XML-based systems  
> DSML-based systems_
>
> **_Databases_**
>
> _Microsoft SQL Server 2005, 2000, and 7  
> IBM DB2  
> Oracle 10g, 9i, and 8i_
>
> **_File-Based_**
>
> _Attribute value Pairs  
> CSV  
> Delimited  
> Fixed Width  
> Directory Services Markup Language (DSML) 2.0  
> LDAP Interchange Format (LDIF)_
>
> **_All Other_**
>
> _Extensible Management Agent for connectivity to all other systems_

But [ILM](http://www.microsoft.com/windowsserver/ilm2007/default.mspx) supports way more than just data consistency. It will even provision Active Directory accounts and mail accounts automatically if an employee is added by HR enabling this process to be automated. You could have HR create a user in their system and set the relevant "profile" that the relates to the user and have their AD and mail setup along with permissions for SharePoint sites, folder shares and any other custom system you care to name ![smile_regular](images/smile_regular-2-2.gif) I like this system already... even if it only does half of what it says on the box it could be a very effective tool in the arsenal of any companies automation strategies.
{ .post-img }

A good point to note is wither the Data protection Act covers information about a person stored by the company they work for! I am not sure wither the same rules apply, but it is of benefit to any company if users details are accurate across all of their systems.

The [benefits](http://www.microsoft.com/windowsserver2003/technologies/idm/default.mspx) according to Microsoft's

propaganda marketing:

> - _**Improve Operational Efficiency**  
>    Now businesses can aggregate identities across the enterprise into a single view, simplify user access to multiple applications, reduce IT costs, and increase productivity._
> - _**Boost Compliance**  
>    Companies can ensure that every user has proper access to resources, create auditable processes for access rights, and deploy single sign-on capabilities that comply with company policy._
> - _**Heighten Security**  
>    Businesses can reduce the risk of security leaks by ensuring that only authorized users can gain access to company resources and that people know who they are dealing with electronically._
> - _**Enable Business Success**  
>    By securely sharing identities across organizational boundaries, businesses can collaborate more efficiently with partners and customers._

We will see! I am currently installing a dev box and I will evaluate it according to the specific needs of our business...

Technorati Tags: [Misc](http://technorati.com/tags/Misc)

