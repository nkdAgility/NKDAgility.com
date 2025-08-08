---
title: Team Foundation Server & SharePoint 3.0
description: Guidance on configuring Team Foundation Server to create project sites under a SharePoint 3.0 subsite, enabling a central intranet portal with project dashboards.
date: 2007-05-31
lastmod: 2007-05-31
weight: 1000
sitemap:
  filename: sitemap.xml
  priority: 0.1
  changefreq: weekly
ResourceId: vIsHKPxOtz-
ResourceImport: false
ResourceType: blog
ResourceContentOrigin: Human
slug: team-foundation-server-sharepoint-3-0
aliases:
  - /resources/blog/team-foundation-server-sharepoint-3.0
  - /resources/vIsHKPxOtz-
aliasesArchive:
  - /blog/team-foundation-server-sharepoint-3-0
  - /team-foundation-server-sharepoint-3-0
  - /team-foundation-server-&-sharepoint-3-0
  - /blog/team-foundation-server-&-sharepoint-3-0
  - /resources/blog/team-foundation-server-sharepoint-3-0
  - /resources/blog/team-foundation-server-sharepoint-3.0
layout: blog
concepts: []
categories:
  - Uncategorized
tags: []
Watermarks:
  description: 2025-05-13T16:28:11Z
ResourceImportId: 391
creator: Martin Hinshelwood
resourceTypes: blog
preview: metro-visual-studio-2005-128-link-1-1.png

---
I have managed to install SharePoint 3.0 on my dev Team server box in side by side mode by using  [Brian Keller's](http://blogs.msdn.com/briankel/default.aspx "Brian Keller: Technical Evangelist for Team System") blog on "[Configuring Visual Studio 2005 Team Foundation Server with Windows SharePoint Services 3.0](http://blogs.msdn.com/briankel/archive/2007/04/14/Configuring-Visual-Studio-2005-Team-Foundation-Server-with-Windows-SharePoint-Services-3.0.aspx "Team Foundation Server with Windows SharePoint Services 3.0")".

I have not yet updated Team Server, but I got as far as having a working version of SharePoint 3.0 running side by side with 2.0. This has worked grate for me as I have had time to evaluate SharePoint as an Intranet for my department. What I would like to achieve is to have and intranet site on http://department.internal.company.com with a sub site called "projects". I would then like Team Server to create all of its sites under this Projects site so as to provide a mini portal for my projects with links to documentation, best practices and tools on the parent http://department.internal.company.com/Projects site along with a reporting services dashboard, with customer reports that cover all of the projects, like RAG reports among other things.

**Does anyone know if this is achievable?**

My idea is that in the documentation I replace:

`<RegistrationEntries>`  
`<RegistrationEntry>`  
        `<Type>Wss</Type>`  
        `<ChangeType>Change</ChangeType>`  
        `<ServiceInterfaces>`  
        `<ServiceInterface>`  
                `<Name>WssAdminService</Name>`  
                `<Url>[protocol]://[WSS Server 3.0]:[WSS 3.0 admin port]/_vti_adm/admin.asmx</Url>`  
        `</ServiceInterface>`  
        `<ServiceInterface>`  
                `<Name>BaseServerUrl</Name>`  
                `<Url>[protocol]://[ WSS Server 3.0]:[port]</Url>`  
        `</ServiceInterface>`  
        `<ServiceInterface>`  
                `<Name>BaseSiteUrl</Name>`  
                `<Url>[protocol]://[ WSS Server 3.0]:[port]/sites</Url>`  
        `</ServiceInterface>`  
        `<ServiceInterface>`  
                `<Name>BaseSiteUnc</Name>`  
                `<Url>[ WSS Server 3.0]sites</Url>`  
        `</ServiceInterface>`  
        `</ServiceInterfaces>`  
`</RegistrationEntry>`  
`</RegistrationEntries>`

`With the information for the sub site:`

`<RegistrationEntries>`  
`<RegistrationEntry>`  
        `<Type>Wss</Type>`  
        `<ChangeType>Change</ChangeType>`  
        `<ServiceInterfaces>`  
        `<ServiceInterface>`  
                `<Name>WssAdminService</Name>`  
                `<Url>[protocol]://[WSS Server 3.0]:[WSS 3.0 admin port]/_vti_adm/admin.asmx</Url>`  
        `</ServiceInterface>`  
        `<ServiceInterface>`  
                `<Name>BaseServerUrl</Name>`  
                `<Url>[protocol]://[ WSS Server 3.0]:[port]</Url>`  
        `</ServiceInterface>`  
        `<ServiceInterface>`  
                `<Name>BaseSiteUrl</Name>`  
                `<Url>[protocol]://[ WSS Server 3.0]:[port]/**Projects**/sites</Url>`  
        `</ServiceInterface>`  
        `<ServiceInterface>`  
                `<Name>BaseSiteUnc</Name>`  
                `<Url>[ WSS Server 3.0]**Projects**sites</Url>`  
        `</ServiceInterface>`  
        `</ServiceInterfaces>`  
`</RegistrationEntry>`  
`</RegistrationEntries>`

`**Anyone else have a better idea of what to try?**`

`**Any reason what this should not work?**`

Technorati Tags: [ALM](http://technorati.com/tags/ALM) [SP 2007](http://technorati.com/tags/SP+2007) [TFS](http://technorati.com/tags/TFS) [VS 2005](http://technorati.com/tags/VS+2005)
