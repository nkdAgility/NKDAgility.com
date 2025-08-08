---
title: Connecting to SQL Server using DNS update
description: Explains how updating DNS and Service Principal Names (SPNs) in Active Directory enables secure Windows Authentication connections to SQL Server instances.
date: 2008-01-31
lastmod: 2008-01-31
weight: 1000
sitemap:
  filename: sitemap.xml
  priority: 0.1
  changefreq: weekly
ResourceId: P0XjI6SRWz-
ResourceImport: false
ResourceType: blog
ResourceContentOrigin: Human
slug: connecting-to-sql-server-using-dns-update
aliases:
  - /resources/P0XjI6SRWz-
aliasesArchive:
  - /blog/connecting-to-sql-server-using-dns-update
  - /connecting-to-sql-server-using-dns-update
  - /resources/blog/connecting-to-sql-server-using-dns-update
layout: blog
concepts: []
categories:
  - Uncategorized
tags: []
Watermarks:
  description: 2025-05-13T16:24:41Z
ResourceImportId: 255
creator: Martin Hinshelwood
resourceTypes: blog
preview: nakedalm-logo-128-link-1-1.png

---
OK, I now have the additional SPN's added to AD that I mentioned in [my post](http://blog.hinshelwood.com/archive/2008/01/31/connecting-to-sql-server-using-dns.aspx "Connecting to SQL Server using DNS") and a listing returns:

> C:>setspn \[servername\]  
> Registered ServicePrincipalNames for CN=\[servername\],OU=Member Servers,DC=\[domain\],DC=biz:  
>     MSSQLSvc/spdata.ep-dev.\[domain\].biz:1422  
>     MSSQLSvc/spdata.ep-dev.\[domain\].biz:1433  
>     MSSQLSvc/\[servername\].\[domain\].biz:1422  
>     MSSQLSvc/\[servername\].\[domain\].biz:1433  
>     SMTPSVC/\[servername\]  
>     SMTPSVC/\[servername\].\[domain\].biz  
>     HOST/\[servername\].\[domain\]onet.biz  
>     HOST/\[servername\]

So when I now try to log into SQL server using spdata.ep-dev.\[domain\].biz/EPDev and Windows Authentication, all is well and I can connect to the server.

When I try moving the databases I will need to move this SPN to the new SQL Cluster, and it should work there as well.

Here's hoping...

Technorati Tags: [SP 2007](http://technorati.com/tags/SP+2007)
