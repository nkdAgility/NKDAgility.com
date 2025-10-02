---
title: TFS Service Credential Viewer
description: Tool for retrieving service credentials from Team Foundation Service (TFS Preview), enabling secure automated API access without manual credential management. Requires Team Explorer 2012.
date: 2012-03-30
lastmod: 2012-03-30
weight: 1000
sitemap:
  filename: sitemap.xml
  priority: 0.1
  changefreq: weekly
ItemId: X946f3k8qX8
ItemType: blog
ItemKind: resource
ItemContentOrigin: Human
slug: tfs-service-credential-viewer
aliases:
  - /resources/X946f3k8qX8
aliasesArchive:
  - /blog/tfs-service-credential-viewer
  - /tfs-service-credential-viewer
  - /resources/blog/tfs-service-credential-viewer
layout: blog
concepts: []
categories:
  - Uncategorized
tags:
  - Install and Configuration
Watermarks:
  description: 2025-05-13T15:09:05Z
ResourceId: X946f3k8qX8
ResourceType: blog
ResourceImportId: 5032
creator: Martin Hinshelwood
resourceTypes: blog
preview: metro-cloud-azure-link-4-4.png

---
If you want to connect to the Team Foundation Service (TFS Preview) API you are going to need some credentials in order to connect. That's right, where do you expect to store your Live ID for connecting? Do you expect to add it to the windows credentials store? What about having the user manually add it? Both these options suck… so introducing the TFS Service Credential Viewer.

[![image](images/image_thumb21-1-1.png "image")](http://blog.hinshelwood.com/files/2012/03/image21.png)
{ .post-img }

The TFS Service Credential Viewer connects to your Team Foundation Service account on [http://tfspreview.com](http://tfspreview.com) and using your credentials it retrieves credentials that you can use for an automated service to connect and authenticate correctly.

### Download TFS Service Credential Viewer

The following prerequisites are required:

- Team Explorer 2012 Visual Studio 11 (any version)
- .NET 4.5

If these components are already installed, you can [launch](http://nkdagility.com/downloads/tools/tfs2012/TfsServiceCredentialViewer/TfsServiceCredentialsUI.application) the application now. Otherwise, click install below to install the prerequisites and run the application.

#### [install](http://nkdagility.com/downloads/tools/tfs2012/TfsServiceCredentialViewer/setup.exe) or [launch via clickonce](http://nkdagility.com/downloads/tools/tfs2012/TfsServiceCredentialViewer/TfsServiceCredentialsUI.application)

### How it works

Once you have authenticated as a TFS Collection Administrator to your hosted TFS Collection we use the Access Control Service to provision a service identity that you can use for unattended connections to Team Foundation Service (TFS Preview).

[![SNAGHTML85af783](images/SNAGHTML85af783_thumb-5-5.png "SNAGHTML85af783")](http://blog.hinshelwood.com/files/2012/03/SNAGHTML85af783.png)  
{ .post-img }
**Figure: A quick #1, #2 to get your credentials**

http://youtu.be/Fkn6V0\_zz28  
**Video: How to get your credentials**

### Troubleshooting

If you are using Windows 8 Consumer Preview you will not get an automatic launch of the application due to an extra security check for applications that come from the internet.

1.  Click or Press “Start” and Scroll all the way to the right
2.  Select the TFS Service Credential Viewer
3.  When the security dialog pops up click “More Info”
    [![image](images/image_thumb22-2-2.png "image")](http://blog.hinshelwood.com/files/2012/03/image22.png)
    { .post-img }
    **Figure: Select More Info  
     **
4.  Click “Run anyway” to launch the application and add it to the safe list
    [![image](images/image_thumb23-3-3.png "image")](http://blog.hinshelwood.com/files/2012/03/image23.png)
    { .post-img }
    Figure;
5.  Done

If you encounter an exception when clicking "Connect" the most likely cause if that you do not have Team Explorer 2012 installed
