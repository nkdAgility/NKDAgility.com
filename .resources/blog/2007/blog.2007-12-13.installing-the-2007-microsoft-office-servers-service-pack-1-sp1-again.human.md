---
title: Installing The 2007 Microsoft Office Servers Service Pack 1 (SP1) ...Again...
description: Documents the installation issues and error logs encountered when applying Microsoft Office Servers 2007 SP1, including timeout exceptions and troubleshooting steps.
ResourceId: RgZYSYc6tNy
ResourceType: blog
ResourceContentOrigin: Human
ResourceImport: true
ResourceImportId: 276
ResourceImportSource: Wordpress
ResourceImportOriginalSource: GeeksWithBlogs
date: 2007-12-13
weight: 1000
creator: Martin Hinshelwood
layout: blog
resourceTypes: blog
slug: installing-the-2007-microsoft-office-servers-service-pack-1-sp1-again
aliases:
- /resources/blog/installing-the-2007-microsoft-office-servers-service-pack-1-sp1-...again...
- /resources/RgZYSYc6tNy
aliasesArchive:
- /blog/installing-the-2007-microsoft-office-servers-service-pack-1-sp1-again
- /installing-the-2007-microsoft-office-servers-service-pack-1-sp1-again
- /installing-the-2007-microsoft-office-servers-service-pack-1-(sp1)----again---
- /blog/installing-the-2007-microsoft-office-servers-service-pack-1-(sp1)----again---
- /resources/blog/installing-the-2007-microsoft-office-servers-service-pack-1-sp1-again
- /resources/blog/installing-the-2007-microsoft-office-servers-service-pack-1-sp1-...again...
tags:
- Troubleshooting
categories:
- Uncategorized
preview: metro-office-128-link-1-1.png
Watermarks:
  description: 2025-05-13T16:25:21Z
concepts: []

---
So far it is exactly the same show as with the WSS update. Installing updates before moving onto the main feature... And it did not ask me to install WSS SP1 this time.. That is another one of those mixed signs...

The installation for MOSS SP1 is identical to that of WSS SP1 so I foresee no problems...

[![image_thumb[7]](images/MOSSSP1InstallNoteswithasadending_98B5-image_thumb7_thumb-5-5.png)](http://blog.hinshelwood.com/files/2011/05/GWB-WindowsLiveWriter-MOSSSP1InstallNoteswithasadending_98B5-image_thumb7_2.png)
{ .post-img }

Well, except maybe the same one that I has from WSS SP1. The message clearly states, as it did in WSS SP1 that I should correct the problem and run the update again, but if I run it again I am told that it is already installed! WTF?

here ist he relevent section of the log file (see what I mean about Sharepoint Logs) in the hopes that someone else has had the same problem:

> 12/13/2007 10:01:42  7  INF                        Entering function ServiceHelper.Stop  
> 12/13/2007 10:01:42  7  INF                          Trying to stop service OSearch and waiting 120 sec to do so  
> 12/13/2007 10:01:42  7  INF                          service OSearch is Running, so will stop it  
> 12/13/2007 10:01:42  7  INF                          stopping service OSearch (it may already be stopped)  
> 12/13/2007 10:03:42  7  ERR                          An exception was encountered when trying to stop service OSearch  
> 12/13/2007 10:03:42  7  INF                          Entering function Common.BuildExceptionInformation  
> 12/13/2007 10:03:42  7  INF                            Entering function Common.BuildExceptionMessage  
> 12/13/2007 10:03:42  7  INF                              Entering function StringResourceManager.GetResourceString  
> 12/13/2007 10:03:42  7  INF                                Resource id to be retrieved is ExceptionInfo for language English (United States)  
> 12/13/2007 10:03:42  7  INF                                Resource retrieved id ExceptionInfo is An exception of type {0} was thrown.  Additional exception information: {1}  
> 12/13/2007 10:03:42  7  INF                              Leaving function StringResourceManager.GetResourceString  
> 12/13/2007 10:03:42  7  INF                            Leaving function Common.BuildExceptionMessage  
> 12/13/2007 10:03:42  7  INF                          Leaving function Common.BuildExceptionInformation  
> 12/13/2007 10:03:42  7  ERR                          An exception of type System.ServiceProcess.TimeoutException was thrown.  Additional exception information: Time out has expired and the operation has not been completed.  
> System.ServiceProcess.TimeoutException: Time out has expired and the operation has not been completed.  
>    at System.ServiceProcess.ServiceController.WaitForStatus(ServiceControllerStatus desiredStatus, TimeSpan timeout)  
>    at Microsoft.SharePoint.PostSetupConfiguration.ServiceHelper.Stop(String serviceName)  
> 12/13/2007 10:03:42  7  INF                        Leaving function ServiceHelper.Stop  
> 12/13/2007 10:03:42  7  INF                      Leaving function InitializeTask.StopServicesListedInRegistry  
> 12/13/2007 10:03:42  7  ERR                      Task initialize has failed with an unknown exception  
> 12/13/2007 10:03:42  7  ERR                      Exception: System.ServiceProcess.TimeoutException: Time out has expired and the operation has not been completed.  
>    at System.ServiceProcess.ServiceController.WaitForStatus(ServiceControllerStatus desiredStatus, TimeSpan timeout)  
>    at Microsoft.SharePoint.PostSetupConfiguration.ServiceHelper.Stop(String serviceName)  
>    at Microsoft.SharePoint.PostSetupConfiguration.InitializeTask.StopServicesListedInRegistry(RegistryHelper registry)  
>    at Microsoft.SharePoint.PostSetupConfiguration.InitializeTask.StopAllServices()  
>    at Microsoft.SharePoint.PostSetupConfiguration.InitializeTask.PrepareForUpgrade()  
>    at Microsoft.SharePoint.PostSetupConfiguration.InitializeTask.Run()  
>    at Microsoft.SharePoint.PostSetupConfiguration.TaskThread.ExecuteTask()  
> 12/13/2007 10:03:42  7  INF                      Entering function Common.BuildExceptionMessage  
> 12/13/2007 10:03:42  7  INF                        Entering function StringResourceManager.GetResourceString  
> 12/13/2007 10:03:42  7  INF                          Resource id to be retrieved is ExceptionInfo for language English (United States)  
> 12/13/2007 10:03:42  7  INF                          Resource retrieved id ExceptionInfo is An exception of type {0} was thrown.  Additional exception information: {1}  
> 12/13/2007 10:03:42  7  INF                        Leaving function StringResourceManager.GetResourceString  
> 12/13/2007 10:03:42  7  INF                      Leaving function Common.BuildExceptionMessage  
> 12/13/2007 10:03:42  7  INF                      Entering function Common.BuildExceptionInformation  
> 12/13/2007 10:03:42  7  INF                        Entering function Common.BuildExceptionMessage  
> 12/13/2007 10:03:42  7  INF                          Entering function StringResourceManager.GetResourceString  
> 12/13/2007 10:03:42  7  INF                            Resource id to be retrieved is ExceptionInfo for language English (United States)  
> 12/13/2007 10:03:42  7  INF                            Resource retrieved id ExceptionInfo is An exception of type {0} was thrown.  Additional exception information: {1}  
> 12/13/2007 10:03:42  7  INF                          Leaving function StringResourceManager.GetResourceString  
> 12/13/2007 10:03:42  7  INF                        Leaving function Common.BuildExceptionMessage  
> 12/13/2007 10:03:42  7  INF                      Leaving function Common.BuildExceptionInformation  
> 12/13/2007 10:03:42  7  ERR                      An exception of type System.ServiceProcess.TimeoutException was thrown.  Additional exception information: Time out has expired and the operation has not been completed.  
> System.ServiceProcess.TimeoutException: Time out has expired and the operation has not been completed.  
>    at System.ServiceProcess.ServiceController.WaitForStatus(ServiceControllerStatus desiredStatus, TimeSpan timeout)  
>    at Microsoft.SharePoint.PostSetupConfiguration.ServiceHelper.Stop(String serviceName)  
>    at Microsoft.SharePoint.PostSetupConfiguration.InitializeTask.StopServicesListedInRegistry(RegistryHelper registry)  
>    at Microsoft.SharePoint.PostSetupConfiguration.InitializeTask.StopAllServices()  
>    at Microsoft.SharePoint.PostSetupConfiguration.InitializeTask.PrepareForUpgrade()  
>    at Microsoft.SharePoint.PostSetupConfiguration.InitializeTask.Run()  
>    at Microsoft.SharePoint.PostSetupConfiguration.TaskThread.ExecuteTask()  
> 12/13/2007 10:03:42  7  INF                      Entering function Common.BuildExceptionInformation  
> 12/13/2007 10:03:42  7  INF                        Entering function Common.BuildExceptionMessage  
> 12/13/2007 10:03:42  7  INF                          Entering function StringResourceManager.GetResourceString  
> 12/13/2007 10:03:42  7  INF                            Resource id to be retrieved is ExceptionInfo for language English (United States)  
> 12/13/2007 10:03:42  7  INF                            Resource retrieved id ExceptionInfo is An exception of type {0} was thrown.  Additional exception information: {1}  
> 12/13/2007 10:03:42  7  INF                          Leaving function StringResourceManager.GetResourceString  
> 12/13/2007 10:03:42  7  INF                        Leaving function Common.BuildExceptionMessage  
> 12/13/2007 10:03:42  7  INF                      Leaving function Common.BuildExceptionInformation  
> 12/13/2007 10:03:42  7  INF                      Entering function TaskBase.OnTaskStop  
> 12/13/2007 10:03:42  7  INF                        Creating the OnTaskStop event for task initialize  
> 12/13/2007 10:03:42  7  ERR                        Task initialize has failed  
> 12/13/2007 10:03:42  7  INF                        friendlyMessage for task initialize is An exception of type System.ServiceProcess.TimeoutException was thrown.  Additional exception information: Time out has expired and the operation has not been completed.  
> 12/13/2007 10:03:42  7  INF                        debugMessage for task initialize is An exception of type System.ServiceProcess.TimeoutException was thrown.  Additional exception information: Time out has expired and the operation has not been completed.  
> System.ServiceProcess.TimeoutException: Time out has expired and the operation has not been completed.  
>    at System.ServiceProcess.ServiceController.WaitForStatus(ServiceControllerStatus desiredStatus, TimeSpan timeout)  
>    at Microsoft.SharePoint.PostSetupConfiguration.ServiceHelper.Stop(String serviceName)  
>    at Microsoft.SharePoint.PostSetupConfiguration.InitializeTask.StopServicesListedInRegistry(RegistryHelper registry)  
>    at Microsoft.SharePoint.PostSetupConfiguration.InitializeTask.StopAllServices()  
>    at Microsoft.SharePoint.PostSetupConfiguration.InitializeTask.PrepareForUpgrade()  
>    at Microsoft.SharePoint.PostSetupConfiguration.InitializeTask.Run()  
>    at Microsoft.SharePoint.PostSetupConfiguration.TaskThread.ExecuteTask()

[![image_thumb[8]](images/MOSSSP1InstallNoteswithasadending_98B5-image_thumb8_thumb-6-6.png)](http://blog.hinshelwood.com/files/2011/05/GWB-WindowsLiveWriter-MOSSSP1InstallNoteswithasadending_98B5-image_thumb8_2.png)
{ .post-img }

Yup, will not run again, just like WSS3 SP1...

Well, I better get to testing this mongrel.

[![image_thumb[9]](images/MOSSSP1InstallNoteswithasadending_98B5-image_thumb9_thumb-7-7.png)](http://blog.hinshelwood.com/files/2011/05/GWB-WindowsLiveWriter-MOSSSP1InstallNoteswithasadending_98B5-image_thumb9_2.png)
{ .post-img }

This is not what I was expecting..

oh well...Debug mode:

- Is Server Gubbed:= Yes
- Google error in log: Solution found: [http://sharepointxperience.blogspot.com/2007/03/kb932091-crashed-my-moss-2007.html](http://sharepointxperience.blogspot.com/2007/03/kb932091-crashed-my-moss-2007.html "http://sharepointxperience.blogspot.com/2007/03/kb932091-crashed-my-moss-2007.html")
- Restart IIS
- Is Server Gubbed:= Yes
- Uninstall MOSS SP1

[![image_thumb[11]](images/MOSSSP1InstallNoteswithasadending_98B5-image_thumb11_thumb-2-2.png)](http://blog.hinshelwood.com/files/2011/05/GWB-WindowsLiveWriter-MOSSSP1InstallNoteswithasadending_98B5-image_thumb11_2.png)
{ .post-img }

Oh, no I can't...

So you can't reinstall it, and you can't remove it!

[![image_thumb[12]](images/MOSSSP1InstallNoteswithasadending_98B5-image_thumb12_thumb-3-3.png)](http://blog.hinshelwood.com/files/2011/05/GWB-WindowsLiveWriter-MOSSSP1InstallNoteswithasadending_98B5-image_thumb12_2.png)
{ .post-img }

Well its a repair for SharePoint then...

[![image_thumb[13]](images/MOSSSP1InstallNoteswithasadending_98B5-image_thumb13_thumb-4-4.png)](http://blog.hinshelwood.com/files/2011/05/GWB-WindowsLiveWriter-MOSSSP1InstallNoteswithasadending_98B5-image_thumb13_2.png)
{ .post-img }

Bugger...

**_Note: This is why we have development servers!_**

UPDATE:

Check out [this post](http://blog.hinshelwood.com/archive/2007/12/31/sharepoint-3.0-and-moss-2007-service-pack-1-update.aspx "Click To View Entry") for a solution that fixed my problems...

Technorati Tags: [SP 2007](http://technorati.com/tags/SP+2007) [MOSS](http://technorati.com/tags/MOSS) [SP 2010](http://technorati.com/tags/SP+2010) [SharePoint](http://technorati.com/tags/SharePoint)
