---
title: SharePoint 2013 Issue - After migration from 2010 user permission not working
description: After migrating from SharePoint 2010 to 2013, users may face permission and authentication issues due to changes in claims-based authentication settings.
date: 2013-06-21
lastmod: 2013-06-21
weight: 875
sitemap:
  filename: sitemap.xml
  priority: 0.1
  changefreq: weekly
ItemId: M-S-kXIX-ar
ItemType: blog
ItemKind: resource
ItemContentOrigin: Human
slug: sharepoint-2013-issue-after-migration-from-2010-user-permission-not-working
aliases:
  - /resources/M-S-kXIX-ar
aliasesArchive:
  - /blog/sharepoint-2013-issue-after-migration-from-2010-user-permission-not-working
  - /sharepoint-2013-issue-after-migration-from-2010-user-permission-not-working
  - /sharepoint-2013-issue
  - /sharepoint-2013-issue---after-migration-from-2010-user-permission-not-working
  - /blog/sharepoint-2013-issue---after-migration-from-2010-user-permission-not-working
  - /resources/blog/sharepoint-2013-issue-after-migration-from-2010-user-permission-not-working
layout: blog
concepts: []
categories:
  - Uncategorized
tags:
  - Troubleshooting
  - Install and Configuration
  - System Configuration
Watermarks:
  description: 2025-05-13T15:06:13Z
ResourceId: M-S-kXIX-ar
ResourceType: blog
ResourceImportId: 9906
creator: Martin Hinshelwood
resourceTypes: blog
preview: metro-sharepoint-128-link-1-1.png

---
Users coming from a SharePoint 2010 system that try to access SharePoint 2013 after a migration receive a “this site has not been shared with you” message. This mean that they are not able to authenticate to SharePoint 2013.

Further you see authentication issues with user profiles not matching recent changes to Active Directory.

## Applies to

- SharePoint 2013
- SharePoint 2010 Upgrade to 2013

## Findings

Man this was a hard one. I was searching for ages and pulling my hair out when [Tushar Malu](http://www.linkedin.com/in/tusharmalu) found some awesome information that saved my bacon.

In SharePoint 2013 there is a new authentication mechanism called Claim based authentication. Be default through the UI all Applications are created in this mode. There is a way to [create web applications that use classic mode authentication in SharePoint 2013](http://technet.microsoft.com/en-us/library/gg276326.aspx) but if you have already created your application tier and you import a Collection from a SharePoint 2010 server then you might find that no one can access your server at all.

After you have [imported your SharePoint 2010 data into SharePoint 2013](http://nkdagility.com/integrate-sharepoint-2013-with-team-foundation-server-2012/) with the “Mount-SPContentDatabase” command you then need to update all of the user accounts as per:

- MSDN: [Migrate from classic-mode to claims-based authentication in SharePoint 2013](http://technet.microsoft.com/en-us/library/gg251985.aspx)

This while fairly simple is a little difficult to fins and figure out and I spent many hours trying to configure SharePoint User Profile Synchronisation to no avail. In fact all you need is a simple PowerShell to do the synchronisation.

## Solution

Although finding this was not simple the execution is. I created a PowerShell script that loops through all of your SharePoint 2013 web applications and upgrades each one to claim’s based authentication.

```
 Param(
    [string]  $account = $(Read-Host -prompt "UserAccount")
    )
Add-PSSnapIn Microsoft.SharePoint.PowerShell

foreach ($wa in get-SPWebApplication)
{
    Write-Host "$($wa.Name) | $($wa.UseClaimsAuthentication )"
    #http://technet.microsoft.com/en-us/library/gg251985.aspx
    $wa.UseClaimsAuthentication = $true
    $wa.Update()
    $account = (New-SPClaimsPrincipal -identity $account -identitytype 1).ToEncodedString()
    $zp = $wa.ZonePolicies("Default")
    $p = $zp.Add($account,"PSPolicy")
    $fc=$wa.PolicyRoles.GetSpecialRole("FullControl")
    $p.PolicyRoleBindings.Add($fc)
    $wa.Update()
    $wa.MigrateUsers($true)
    $wa.ProvisionGlobally()
}

```

These commands tool less than 10 minutes to run on 3 content databases with nearly 100GB of data. In addition some bright spark had added “NT AuthorityAuthenticated Users” to one of the main sites '”Contributors” group. While this sounds like something that I would do, if I had done it I would have added them to “Readers”…
