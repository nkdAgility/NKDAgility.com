---
title: What the 0x80072020?
description: Explains the 0x80072020 error in .NET 3.5 PrincipalContext when using ASP.NET impersonation with Active Directory, its cause, and security concerns with workaround.
date: 2008-03-04
lastmod: 2008-03-04
weight: 1000
sitemap:
  filename: sitemap.xml
  priority: 0.1
  changefreq: weekly
ResourceId: ts3nKVfoy1j
ResourceImport: false
ResourceType: blog
ResourceContentOrigin: Human
slug: what-the-0x80072020
aliases:
  - /resources/ts3nKVfoy1j
aliasesArchive:
  - /blog/what-the-0x80072020
  - /what-the-0x80072020
  - /what-the-0x80072020-
  - /blog/what-the-0x80072020-
  - /resources/blog/what-the-0x80072020
layout: blog
concepts: []
categories:
  - Uncategorized
tags: []
Watermarks:
  description: 2025-05-13T16:24:27Z
ResourceImportId: 243
creator: Martin Hinshelwood
resourceTypes: blog
preview: metro-binary-vb-128-link-1-1.png

---
I have found a small bug (as in, "Not working as expected!") in the new .NET 3.5 PrincipalContext classes. When you are running on an ASP.NET site in impersonation mode you cannot retrieve information from active directory without the following error:

> _System.Runtime.InteropServices.COMException (0x80072020): An operations error occurred. at System.DirectoryServices.DirectoryEntry.Bind(Boolean throwIfFail) at System.DirectoryServices.DirectoryEntry.Bind() at System.DirectoryServices.DirectoryEntry.get_AdsObject() at System.DirectoryServices.PropertyValueCollection.PopulateList() at System.DirectoryServices.PropertyValueCollection..ctor(DirectoryEntry entry, String propertyName) at System.DirectoryServices.PropertyCollection.get_Item(String propertyName) at System.DirectoryServices.AccountManagement.PrincipalContext.DoLDAPDirectoryInitNoContainer() at System.DirectoryServices.AccountManagement.PrincipalContext.DoDomainInit() at System.DirectoryServices.AccountManagement.PrincipalContext.Initialize() at System.DirectoryServices.AccountManagement.PrincipalContext.get_QueryCtx() at System.DirectoryServices.AccountManagement.Principal.FindByIdentityWithTypeHelper(PrincipalContext context, Type principalType, Nullable\`1 identityType, String identityValue, DateTime refDate) at System.DirectoryServices.AccountManagement.Principal.FindByIdentityWithType(PrincipalContext context, Type principalType, IdentityType identityType, String identityValue) at System.DirectoryServices.AccountManagement.UserPrincipal.FindByIdentity(PrincipalContext context, IdentityType identityType, String identityValue) at UI_Controls_SharepointControl.Page_Load(Object sender, EventArgs e)_

You need to specify a fixed account to access AD using:

> Dim ctx As New PrincipalContext(ContextType.Domain, "\[domain\]", "\[accountName\]", "\[password\]")
>
> [](http://11011.net/software/vspaste)

This is not so good! What if I wanted to use the current users credentials to update only fields that they are allowed to update in AD? If I use a static account that can access any users fields then this becomes a security risk.

Ahh well, I will live with it for now, but if anyone has another suggestion...

Technorati Tags: [.NET](http://technorati.com/tags/.NET) [WCF](http://technorati.com/tags/WCF)
