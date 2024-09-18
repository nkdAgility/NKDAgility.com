---
id: "255"
title: "Connecting to SQL Server using DNS update"
date: "2008-01-31"
categories: 
  - "code-and-complexity"
tags: 
  - "configuration"
  - "infrastructure"
  - "sp2007"
  - "tools"
coverImage: "nakedalm-logo-128-link-1-1.png"
author: "MrHinsh"
type: "post"
slug: "connecting-to-sql-server-using-dns-update"
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



