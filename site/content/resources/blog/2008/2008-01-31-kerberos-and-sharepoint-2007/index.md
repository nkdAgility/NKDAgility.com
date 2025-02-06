---
title: Kerberos and SharePoint 2007
description: Learn how to configure Kerberos authentication for SharePoint 2007, including essential SPN setup steps for a secure and efficient environment.
ResourceId: REHiKbbVOD8
ResourceType: blog
ResourceImport: true
ResourceImportId: 254
ResourceImportSource: Wordpress
ResourceImportOriginalSource: GeeksWithBlogs
date: 2008-01-31
creator: Martin Hinshelwood
layout: blog
resourceTypes: blog
slug: kerberos-and-sharepoint-2007
aliases:
- /blog/kerberos-and-sharepoint-2007
- /kerberos-and-sharepoint-2007
- /resources/REHiKbbVOD8
- /resources/blog/kerberos-and-sharepoint-2007
aliasesFor404:
- /kerberos-and-sharepoint-2007
- /blog/kerberos-and-sharepoint-2007
- /resources/blog/kerberos-and-sharepoint-2007
tags:
- Technical Strategy
- Site Reliability Engineering
categories:
- Install and Configuration
preview: metro-sharepoint-128-link-1-1.png

---
If you want to use Kerberos authentication and not NTLM with SharePoint then there are some extra tasks that you need to get someone with Domain Admin privileges to perform. For EVERY dns / port combination a SPN needs to be added to Active Directory to tell it that it  is allowed to use Kerberos to authenticate a specific account or server to that URL. In a production environment with a farm of multiple server you will need to use the account option.

The account option lets you create an Active Directory account called..say... svc_Sharepoint and add a bunch of SPN's to it. This account then needs to be used to run the application you are trying to connect to. So if it is an IIS website then the AppPool needs to run under that account. if it is SQL Server then the services need to run under that account.

You need to add an SPN for each protocol URL and port combination:

> setspn -a admin.ep-dev.\[domain\].biz \[domain\]svc_sharepoint  
> setspn -a admin.ep-dev.\[domain\].biz:8080 \[domain\]svc_sharepoint  
> setspn -a bi.ep-dev.\[domain\].biz \[domain\]svc_sharepoint  
> setspn -a nrcdashboard.ep-dev.\[domain\].biz \[domain\]svc_sharepoint  
> setspn -a ep-dev.\[domain\].biz     \[domain\]svc_sharepoint  
> setspn -a team.ep-dev.\[domain\].biz \[domain\]svc_sharepoint  
> setspn -a search.ep-dev.\[domain\].biz \[domain\]svc_sharepoint  
> setspn -a my.ep-dev.\[domain\].biz \[domain\]svc_sharepoint  
> setspn -a technet.ep-dev.\[domain\].biz \[domain\]svc_sharepoint  
> setspn -a tfs01.ep-dev.\[domain\].biz \[domain\]svc_tfsservices  
> setspn -a tfs01.ep-dev.\[domain\].biz:8080 \[domain\]svc_tfsservices  
> setspn -a [TFS](http://msdn2.microsoft.com/en-us/teamsystem/aa718934.aspx "Team Foundation Server").ep-dev.\[domain\].biz \[domain\]svc_tfsservices

These SPN's will allow authentication to work on these domains, but it does require Domain Admin to run them. And these are only my initial FQDN for this environment. We will be having a production environment soon and most likely a UAT environment before we start any development work on our Enterprise Portal.

Technorati Tags: [SP 2007](http://technorati.com/tags/SP+2007) [MOSS](http://technorati.com/tags/MOSS) [SP 2010](http://technorati.com/tags/SP+2010) [TFS](http://technorati.com/tags/TFS) [SharePoint](http://technorati.com/tags/SharePoint)
