---
title: SharePoint 3.0 TFS Sub-Site creation error.
description: Encountering issues with SharePoint 3.0 TFS sub-site creation? Discover solutions and share your experiences in this insightful blog post by Martin Hinshelwood.
ResourceId: x5FZPMNJgBF
ResourceType: blog
ResourceImport: true
ResourceImportId: 388
ResourceImportSource: Wordpress
ResourceImportOriginalSource: GeeksWithBlogs
date: 2007-06-07
weight: 1000
creator: Martin Hinshelwood
layout: blog
resourceTypes: blog
slug: sharepoint-3-0-tfs-sub-site-creation-error
aliases:
- /blog/sharepoint-3-0-tfs-sub-site-creation-error
- /sharepoint-3-0-tfs-sub-site-creation-error
- /sharepoint-3-0-tfs-sub-site-creation-error-
- /blog/sharepoint-3-0-tfs-sub-site-creation-error-
- /resources/x5FZPMNJgBF
- /resources/blog/sharepoint-3-0-tfs-sub-site-creation-error
aliasesArchive:
- /blog/sharepoint-3-0-tfs-sub-site-creation-error
- /sharepoint-3-0-tfs-sub-site-creation-error
- /sharepoint-3-0-tfs-sub-site-creation-error-
- /blog/sharepoint-3-0-tfs-sub-site-creation-error-
- /resources/blog/sharepoint-3-0-tfs-sub-site-creation-error
tags:
- Install and Configuration
- System Configuration
- Troubleshooting
- Software Development
preview: metro-visual-studio-2005-128-link-1-1.png
categories: []

---
As you will know from my previous [post](http://blog.hinshelwood.com/archive/2007/05/31/Setting-up-TFS-to-create-project-portals-as-child-sites.aspx "Setting up TFS to create project portals as child sites of an existing SharePoint 3.0 site (or sub site)") I have been trying to get TFS to create sub sites in SharePoint 3.0.

I now have the hotfix specified by [Brian Keller](http://blogs.msdn.com/briankel/archive/2007/04/14/Configuring-Visual-Studio-2005-Team-Foundation-Server-with-Windows-SharePoint-Services-3.0.aspx "Configuring Visual Studio 2005 Team Foundation Server with Windows SharePoint Services 3.0") for my Team Explorer client that allows me to communicate with WSS3.0, but I am still having a problem with my sub site attempts!

Hey Brian, you said "try it and see", so I did, but it only half works ![](images/regular_smile.gif).
{ .post-img }

AT the moment I am getting the error:

> Another site already exists at http://\[server\]:8888. Delete this site before attempting to create a new site with the same URL, choose a new URL, or create a new inclusion at the path you originally specified.

My registration entries for [TFS](http://msdn2.microsoft.com/en-us/teamsystem/aa718934.aspx "Team Foundation Server") are:

> ```
> <RegistrationEntry>
>   <Type>Wss</Type>
>   <ServiceInterfaces>
>     <ServiceInterface>
>       <Name>BaseServerUrl</Name>
>       <Url>http://[server]:8888</Url>
>     </ServiceInterface>
>     <ServiceInterface>
>       <Name>BaseSiteUnc</Name>
>       <Url>[server]:Projects</Url>
>     </ServiceInterface>
>     <ServiceInterface>
>       <Name>BaseSiteUrl</Name>
>       <Url>http://[server]::8888/Projects</Url>
>     </ServiceInterface>
>     <ServiceInterface>
>       <Name>WssAdminService</Name>
>       <Url>http://[server]::32831/_vti_adm/admin.asmx</Url>
>     </ServiceInterface>
>   </ServiceInterfaces>
>   <Databases />
>   <EventTypes />
>   <ArtifactTypes />
>   <RegistrationExtendedAttributes />
>   <ChangeType>NoChange</ChangeType>
> </RegistrationEntry>
> ```

What I am essentially trying to achieve is that all sites are created as sub-sites of the SharePoint 3.0 site http://\[server\]::8888/Projects.

Now, I am not sure if the problem is the creation of the site, or if it created the site, but can't upload documents. Here is the full Module message:

> Module: Engine  
> Event Description: TF30162: Task "SharePointPortal" from Group "Portal" failed  
> Exception Type: Microsoft.TeamFoundation.Client.PcwException  
> Exception Message: The Project Creation Wizard encountered an error while uploading documents to the Windows SharePoint Services server on team.worldnet-dev.ml.com.  
> Exception Details: The Project Creation Wizard encountered a problem while uploading  
> documents to the Windows SharePoint Services server on team.worldnet-dev.ml.com.  
> The reason for the failure cannot be determined at this time.  
> Because the operation failed, the wizard was not able to finish  
> creating the Windows SharePoint Services site.  
> Stack Trace:  
>    at Microsoft.VisualStudio.TeamFoundation.WssSiteCreator.Execute(ProjectCreationContext context, XmlNode taskXml)  
>    at Microsoft.VisualStudio.TeamFoundation.ProjectCreationEngine.TaskExecutor.PerformTask(IProjectComponentCreator componentCreator, ProjectCreationContext context, XmlNode taskXml)  
>    at Microsoft.VisualStudio.TeamFoundation.ProjectCreationEngine.RunTask(Object taskObj)  
> \--   Inner Exception   --
> Exception Type: System.Web.Services.Protocols.SoapException  
> Exception Message: Exception of type 'Microsoft.SharePoint.SoapServer.SoapServerException' was thrown.  
> SoapException Details: <detail><errorstring xmlns="http://schemas.microsoft.com/sharepoint/soap/"\>Another site already exists at http://\[server\]:8888. Delete this site before attempting to create a new site with the same URL, choose a new URL, or create a new inclusion at the path you originally specified.</errorstring></detail>  
> Stack Trace:  
>    at System.Web.Services.Protocols.SoapHttpClientProtocol.ReadResponse(SoapClientMessage message, WebResponse response, Stream responseStream, Boolean asyncCall)  
>    at System.Web.Services.Protocols.SoapHttpClientProtocol.Invoke(String methodName, Object\[\] parameters)  
>    at Microsoft.TeamFoundation.Proxy.Portal.Admin.CreateSite(String Url, String Title, String Description, Int32 Lcid, String WebTemplate, String OwnerLogin, String OwnerName, String OwnerEmail, String PortalUrl, String PortalName)  
>    at Microsoft.VisualStudio.TeamFoundation.WssSiteCreator.CreateSite(WssSiteData siteCreationData, ProjectCreationContext context)  
>    at Microsoft.VisualStudio.TeamFoundation.WssSiteCreator.Execute(ProjectCreationContext context, XmlNode taskXml)  
> \-- end Inner Exception --
> \--- end Exception entry ---

I have 3 question that you may be able to help me with:

- **Has anyone tried to do this?**
- **And if so, how did you get round this problem?**
- **Or, even, what is the problem?**

Technorati Tags: [ALM](http://technorati.com/tags/ALM) [SP 2007](http://technorati.com/tags/SP+2007) [SP 2010](http://technorati.com/tags/SP+2010) [SharePoint](http://technorati.com/tags/SharePoint) [VS 2005](http://technorati.com/tags/VS+2005)
