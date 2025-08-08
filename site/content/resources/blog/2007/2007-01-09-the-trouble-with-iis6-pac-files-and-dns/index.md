---
title: The trouble with IIS6, .pac files and DNS
description: Explains issues with serving .pac proxy files on IIS6 due to missing MIME types and how to resolve DNS for proxy appliances lacking host file support.
date: 2007-01-09
lastmod: 2007-01-09
weight: 1000
sitemap:
  filename: sitemap.xml
  priority: 0.1
  changefreq: weekly
ResourceId: R2MUioX4tLG
ResourceImport: false
ResourceType: blog
ResourceContentOrigin: Human
slug: the-trouble-with-iis6-pac-files-and-dns
aliases:
  - /resources/blog/the-trouble-with-iis6-.pac-files-and-dns
  - /resources/R2MUioX4tLG
aliasesArchive:
  - /blog/the-trouble-with-iis6-pac-files-and-dns
  - /the-trouble-with-iis6-pac-files-and-dns
  - /the-trouble-with-iis6,--pac-files-and-dns
  - /blog/the-trouble-with-iis6,--pac-files-and-dns
  - /the-trouble-with-iis6---pac-files-and-dns
  - /blog/the-trouble-with-iis6---pac-files-and-dns
  - /resources/blog/the-trouble-with-iis6-pac-files-and-dns
  - /resources/blog/the-trouble-with-iis6-.pac-files-and-dns
layout: blog
concepts: []
categories:
  - Uncategorized
tags: []
Watermarks:
  description: 2025-05-13T16:29:32Z
ResourceImportId: 448
creator: Martin Hinshelwood
resourceTypes: blog
preview: nakedalm-logo-128-link-1-1.png

---
Now, I have, up until now, not had any experience with proxy servers. Well, to be honest, I still don't... But I do have some experience with IIS as I have been using it since the sad old days of NT4. Yes that's right, before Active Directory, The bad old days when domains were the work of a craftsman.

Anyhoo, my brother [David](http://www.linkedin.com/pub/0/559/67b "David Hinshelwood's Profile") called with a little problem with .pac files for a proxy server. My first though was that I did not know a dam thing about proxy servers, except that annoying "Access Denied" message you get when you try to go to the one URL that has the exact answer to the problem you have been trying to solve for hours... Well that's not exactly true, I know what a a proxy server does in theory and what a .pac file does, I have just never used one..

[David](http://www.linkedin.com/pub/0/559/67b "David Hinshelwood's Profile") had two problems, well three if you count the network security guru bit.

The first reared its ugly head when he tried to access a .pac file from IIS. 404! WTF! He could see the file, but no download. Change it to a .txt and there it is. It seams that [IIS 6.0 does not serve unknown MIME types](http://support.microsoft.com/default.aspx?scid=kb%3bEN-US%3bq258141 "IIS 6.0 does not serve unknown MIME types"), unlike previous versions. Adding the MIME type solved the problem: David did actually get this far, he just entered an incorrect MIME Type that he found on the web.

Inaccurate information on the web! Never... ;)

The second problem was that he was using a proxy server that was an appliance (i.e. a hardware box that probably said something like "Cisco proxy magic" on it) and it did not support host files. He needed a domain to resolve to something other than the IP stated on the web. As I have had some ups and downs with  Active Directory I had had this problem, among others, before. What he needs to do is add the domain he wants to repoint (say google.co.uk) to the DNS server and enter the IP address that he wants it to resolve to. Now when an internal request for that domain reaches the DNS server it is handled internally instead of being forwarded to the big cloud.

So all problems solved, well theoretically... David still need to try them out side of my little home lab.

Technorati Tags: [Misc](http://technorati.com/tags/Misc)
