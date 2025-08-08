---
title: Connecting to SQL Server using DNS
description: Explains how to enable Windows Authentication for SQL Server connections via DNS by configuring the SQL Server Browser service and setting up Service Principal Names (SPNs).
date: 2008-01-31
lastmod: 2008-01-31
weight: 1000
sitemap:
  filename: sitemap.xml
  priority: 0.1
  changefreq: weekly
ResourceId: tV0-x7E8IQc
ResourceImport: false
ResourceType: blog
ResourceContentOrigin: Human
slug: connecting-to-sql-server-using-dns
aliases:
  - /resources/tV0-x7E8IQc
aliasesArchive:
  - /blog/connecting-to-sql-server-using-dns
  - /connecting-to-sql-server-using-dns
  - /resources/blog/connecting-to-sql-server-using-dns
layout: blog
concepts: []
categories:
  - Uncategorized
tags:
  - Troubleshooting
  - Install and Configuration
  - System Configuration
Watermarks:
  description: 2025-05-13T16:24:43Z
ResourceImportId: 256
creator: Martin Hinshelwood
resourceTypes: blog
preview: nakedalm-logo-128-link-6-6.png

---
If you want to connect to a SQL server using DNS you will need to have both the "_SQL Server Browser_" service and an SPN setup in your domain to allow authentication.

This allows the DNS name that you have setup to authenticate against the SQL Server using integrated authentication.

> setspn MSSQLSvc/spdata.ep-dev.\[domain\].biz:1422 \[servername\]  
> setspn MSSQLSvc/spdata.ep-dev.\[domain\].biz:1433 \[servername\]

You will know that you need to do this if all of the below is true:

1. Pining your domain brings back the correct IP of the server
2. You can connect to the SQL Server using the server name with Windows Authentication.
3. You can connect to the SQL server using the IP address with Windows Authentication.
4. You can NOT connect to the SQL server using the spdata.ep-dev.\[domain\].biz with Windows Authentication.
5. You can connect to the SQL server using the spdata.ep-dev.\[domain\].biz with SQL Server Authentication.

[![image](images/ConnectingtoSQLServerusingDNS_B317-image_thumb_1-1-1.png)](http://blog.hinshelwood.com/files/2011/05/GWB-WindowsLiveWriter-ConnectingtoSQLServerusingDNS_B317-image_4.png)[![image](images/ConnectingtoSQLServerusingDNS_B317-image_thumb_3-3-3.png)](http://blog.hinshelwood.com/files/2011/05/GWB-WindowsLiveWriter-ConnectingtoSQLServerusingDNS_B317-image_8.png)  [![image](images/ConnectingtoSQLServerusingDNS_B317-image_thumb-5-5.png)](http://blog.hinshelwood.com/files/2011/05/GWB-WindowsLiveWriter-ConnectingtoSQLServerusingDNS_B317-image_2.png)  [![image](images/ConnectingtoSQLServerusingDNS_B317-image_thumb_2-2-2.png)](http://blog.hinshelwood.com/files/2011/05/GWB-WindowsLiveWriter-ConnectingtoSQLServerusingDNS_B317-image_6.png)  
{ .post-img }
[![image](images/ConnectingtoSQLServerusingDNS_B317-image_thumb_5-4-4.png)](http://blog.hinshelwood.com/files/2011/05/GWB-WindowsLiveWriter-ConnectingtoSQLServerusingDNS_B317-image_12.png)
{ .post-img }

You can get he setspn tool from the Windows Server 2003 Admin Pack.

Use it to see what SPN's already exist and to see how you can utilise them. For example calling setspn on my \[servername\] produced:

> C:>setspn \[servername\]  
> Registered ServicePrincipalNames for CN=\[servername\],OU=Member Servers,DC=\[domain\],DC=biz:  
>     MSSQLSvc/\[servername\].\[domain\].biz:1422  
>     MSSQLSvc/\[servername\].\[domain\].biz:1433  
>     SMTPSVC/\[servername\]  
>     SMTPSVC/\[servername\].\[domain\].biz  
>     HOST/\[servername\].\[domain\]onet.biz  
>     HOST/\[servername\]

this information helped me identify that the first two "MSSQLSvc" spn's would need to be added to this server. You can add SPN's to accounts as well, but if you only need to access a single server then adding it to an account is a little overkill and probably a security risk.

I'm off to make a request for infrastructure to run this...![smile_speedy](images/smile_speedy-7-7.gif)
{ .post-img }

Technorati Tags: [SP 2007](http://technorati.com/tags/SP+2007)
