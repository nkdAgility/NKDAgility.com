---
title: Getting a service account for VSO with TFS Service Credential Viewer
description: "Learn how to obtain a service account for Visual Studio Online using the TFS Service Credential Viewer. Streamline your automation tasks effortlessly!"
date: 2014-06-18
creator: Martin Hinshelwood
id: "10596"
layout: blog
resourceType: blog
slug: getting-service-account-vso-tfs-service-credential-viewer
aliases:
  - /blog/getting-service-account-vso-tfs-service-credential-viewer
tags:
  - tfs
  - vsteamservices
categories:
  - tools-and-techniques
preview: nakedalm-experts-visual-studio-alm-1-1.png
---

Have you tried to get a service account for Visual Studio Online (VSO)? Did you know that you can use the TFS Service Credential Viewer to get it.

When you join a local or azure build server to your VSO account you are asked to log in with an account that is an administrator to get credentials. However it cant continue to use your credentials as your Microsoft ID token expires after 2 days and you would have to login again. Not a good experience. However there is a little bit of code that the build server uses to get a basic service username and password that it uses instead. I have used this to create unit tests that hit the TFS API’s in VSO as well as do all sorts of automated tasks that I need.

I created the TFS Service Credential Viewer when the service was still in Preview but it is no less required now. Its your gateway to automation with VSO.

### Download TFS Service Credential Viewer

The following prerequisites are required:

- Team Explorer 2013 Visual Studio 11 (any version)
- .NET 4.5

If these components are already installed, you can [launch](http://nkdagility.com/downloads/tools/tfs2012/TfsServiceCredentialViewer/TfsServiceCredentialsUI.application) the application now. Otherwise, click install below to install the prerequisites and run the application.

###### [install](http://nkdagility.com/downloads/tools/tfs2012/TfsServiceCredentialViewer/setup.exe) or [launch via clickonce](http://nkdagility.com/downloads/tools/tfs2012/TfsServiceCredentialViewer/TfsServiceCredentialsUI.application)

### How it works

Once you have authenticated as a TFS Collection Administrator using your Microsoft ID to your hosted VSO instance we use the Access Control Service to provision a service identity that you can use for unattended connections to VSO.

[![SNAGHTML85af783](http://i1.wp.com/blog.hinshelwood.com/files/2012/03/SNAGHTML85af783_thumb.png?zoom=1.5&resize=460%2C461 "SNAGHTML85af783")](http://i0.wp.com/blog.hinshelwood.com/files/2012/03/SNAGHTML85af783.png)  
{ .post-img }
**Figure: A quick #1, #2 to get your credentials**

http://youtu.be/Fkn6V0\_zz28  
**Video: How to get your credentials**

### Troubleshooting

If you are using Windows 8 you will not get an automatic launch of the application due to an extra security check called Smart Screen for applications that come from the internet.

1.  Click or Press “Start” and Scroll all the way to the right
2.  Select the TFS Service Credential Viewer
3.  When the security dialog pops up click “More Info”
    [![image](http://i2.wp.com/blog.hinshelwood.com/files/2012/03/image_thumb22.png?zoom=1.5&resize=640%2C268 "image")](http://i1.wp.com/blog.hinshelwood.com/files/2012/03/image22.png)
    { .post-img }
    **Figure: Select More Info  
     **
4.  Click “Run anyway” to launch the application and add it to the safe list
    [![image](http://i2.wp.com/blog.hinshelwood.com/files/2012/03/image_thumb23.png?zoom=1.5&resize=640%2C270 "image")](http://i2.wp.com/blog.hinshelwood.com/files/2012/03/image23.png)
    { .post-img }
    Figure;
5.  Done

If you encounter an exception when clicking “Connect” the most likely cause if that you do not have Team Explorer 2013 installed (it should also work with 2012).

