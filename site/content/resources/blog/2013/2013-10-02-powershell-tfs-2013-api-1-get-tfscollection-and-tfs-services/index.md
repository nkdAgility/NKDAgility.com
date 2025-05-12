---
title: 'PowerShell TFS 2013 API #1 - Get TfsCollection and TFS Services'
description: Learn how to use PowerShell to connect to TFS 2013, import required assemblies, and access core TFS services like Work Item Store, Version Control, and project settings.
ResourceId: kaEC07NAXT7
ResourceType: blog
ResourceContentOrigin: Human
ResourceImport: true
ResourceImportId: 10149
ResourceImportSource: Wordpress
ResourceImportOriginalSource: Wordpress
date: 2013-10-02
weight: 840
creator: Martin Hinshelwood
layout: blog
resourceTypes: blog
slug: powershell-tfs-2013-api-1-get-tfscollection-and-tfs-services
aliases:
- /resources/kaEC07NAXT7
aliasesArchive:
- /blog/powershell-tfs-2013-api-1-get-tfscollection-and-tfs-services
- /powershell-tfs-2013-api-1-get-tfscollection-and-tfs-services
- /powershell-tfs-2013-api--1
- /powershell-tfs-2013-api--1---get-tfscollection-and-tfs-services
- /blog/powershell-tfs-2013-api--1---get-tfscollection-and-tfs-services
- /resources/blog/powershell-tfs-2013-api-1-get-tfscollection-and-tfs-services
tags:
- Software Development
- Install and Configuration
categories:
- Uncategorized
preview: metro-powershell-logo-1-1.png
Watermarks:
  description: 2025-05-12T14:23:02Z
concepts: []

---
Have you ever wanted to use PowerShell to interact with the TFS 2013 API? Well I have been working through a few scenarios and wanted to get them to you so that I can get some feedback.

This will likely be a series of PowerShell posts as I build up my library of PowerShell statements. In order to interact with the TFS API with PowerShell, the first things we need to do is import the types that we are going to use. As there are no real PowerShell comandlets for TFS out of the box we need to import the actual assemblies and then wrap a bunch of functions that we want to use.

```
$pathToAss2 = "C:\Program Files (x86)\Microsoft Visual Studio 12.0\Common7\IDE\ReferenceAssemblies\v2.0"
$pathToAss4 = "C:\Program Files (x86)\Microsoft Visual Studio 12.0\Common7\IDE\ReferenceAssemblies\v4.5"
Add-Type -Path "$pathToAss2\Microsoft.TeamFoundation.Client.dll"
Add-Type -Path "$pathToAss2\Microsoft.TeamFoundation.Common.dll"
#Add-Type -Path "$pathToAss2\Microsoft.TeamFoundation.dll"
Add-Type -Path "$pathToAss2\Microsoft.TeamFoundation.WorkItemTracking.Client.dll"
Add-Type -Path "$pathToAss2\Microsoft.TeamFoundation.VersionControl.Client.dll"
Add-Type -Path "$pathToAss4\Microsoft.TeamFoundation.ProjectManagement.dll"

```

Figure: Referencing Assemblies

Above I have a set of Assembly imports that reflect the breadth of the functions that I am adding. I am continuously adding to this list but there are a few parts of interest. The first 3 assemblies loaded are the core TFS API’s that you will need for almost every interaction. They represent things like the Server and Collection as well as TeamProject and other core concepts that traverse any particular component. It is worth noting that everything here is the same as you would do in .NET.

The last three assemblies provide Work Item Tracking, Version Control and Project Management respectively. The Project Management assemblies are in the v4.5 folder instead of v2.0 as they were only recently added. With more new features coming down the line it is likely that more things will end up in the v4.5 folder.

The very first thing that you will always do when working with the TFS is connect to your TFS server. Really that means that you will be connecting to the Collection that you want to work with. There are some things that you may want to do against the server but not many.

```
function Get-TfsCollection {
 Param(
       [string] $CollectionUrl
       )
    if ($CollectionUrl -ne "")
    {
        #if collection is passed then use it and select all projects
        $tfs = [Microsoft.TeamFoundation.Client.TfsTeamProjectCollectionFactory]::GetTeamProjectCollection($CollectionUrl)
    }
    else
    {
        #if no collection specified, open project picker to select it via gui
        $picker = New-Object Microsoft.TeamFoundation.Client.TeamProjectPicker([Microsoft.TeamFoundation.Client.TeamProjectPickerMode]::NoProject, $false)
        $dialogResult = $picker.ShowDialog()
        if ($dialogResult -ne "OK")
        {
            #exit
        }
        $tfs = $picker.SelectedTeamProjectCollection
    }
    Return $tfs
}

```

Figure: Connecting to the TFS Collection in PowerShell

Here I am doing a couple of things. If you pass a URL to a TFS Collection as a string into the function it will create a TFS Collection object based on that URL by calling the static GetTeamProjectCollection method on the built in factory class. That is the easy way. If you don’t specify the URL the PowerShell script above hooks into the built in API’s to show the same Collection Picker dialog that you get in Visual Studio when you try to connect. This actually has three modes, but here i am only using the “NoProject” mode to select a Collection only.

```
function Get-TfsCommonStructureService {
 Param(
       [Microsoft.TeamFoundation.Client.TfsTeamProjectCollection] $TfsCollection
       )
    Return $TfsCollection.GetService("Microsoft.TeamFoundation.Server.ICommonStructureService3")
}

```

Figure: Connecting to the TFS Common Structure Service with PowerShell

Now that we have our TFS server object we can start exercising it. However everything in TFS is pretty much done through a collection of servers that you get from that Collection object. Here we are doing a get on the [Common Structure Service](http://msdn.microsoft.com/en-us/library/microsoft.teamfoundation.server.icommonstructureservice3.aspx) which is responsible for some of the underlying structures like Team Projects, Area Paths and Iteration Paths.

```
$global:TfsWorkItemStoreCache
function Get-TfsWorkItemStore {
 Param(
       [Microsoft.TeamFoundation.Client.TfsTeamProjectCollection] $TfsCollection,
       [switch] $refresh
       )
       If ($global:TfsWorkItemStoreCache -eq $null -or $refresh -eq $true)
       {
       $global:TfsWorkItemStoreCache= $TfsCollection.GetService([Microsoft.TeamFoundation.WorkItemTracking.Client.WorkItemStore])
       }
    Return $global:TfsWorkItemStoreCache
}

```

Figure: Connecting to the TFS Work Item Store with PowerShell

Another component that you will get a lot of use out of is the [Work Item Store](http://msdn.microsoft.com/en-us/library/microsoft.teamfoundation.workitemtracking.client.workitemstore.aspx). This is where all of the magic happens with Work Items. We can use it to access queries, create our own queries as well as create and edit Work Items. If you are just a little crazy you can also edit the work item types…

```
function Get-TfsVersionControlServer {
    Param(
        [Microsoft.TeamFoundation.Client.TfsTeamProjectCollection] $TfsCollection
        )
    Return $TfsCollection.GetService("Microsoft.TeamFoundation.VersionControl.Client.VersionControlServer")
}

```

Figure: Connecting to TFS Version Control with PowerShell

If you are seeking to work with the Source Code then [Version Control Server](http://msdn.microsoft.com/en-us/library/microsoft.teamfoundation.versioncontrol.client.versioncontrolserver.aspx) is the service you are looking for. It allows you to work with all of the files in source control and to add more. Simple to work with once you accept that you need a Local Workspace to do anything.

```
function Get-TfsProjectProcessConfigurationService {
    Param(
        [Microsoft.TeamFoundation.Client.TfsTeamProjectCollection] $TfsCollection
        )
    return $TfsCollection.GetService([Microsoft.TeamFoundation.ProcessConfiguration.Client.ProjectProcessConfigurationService]);
}

```

Figure: Connecting to TFS Project Process Configuration with PowerShell

There are many new features in 2012 and 2013 that required new API’s to edit and configure. The [Project Process Configuration](http://msdn.microsoft.com/en-us/library/microsoft.teamfoundation.processconfiguration.client.projectprocessconfigurationservice.aspx) is one such entity that comes from the new “Microsoft.TeamFoundation.ProjectManagement.dll”. This allows you to configure and work with the Process Configuration for your Team Project. This is the configuration and layout of your Backlogs and Boards. You can just read the settings or you can set them as well.

```
function Get-TfsTeamSettingsConfigurationService {
    Param(
        [Microsoft.TeamFoundation.Client.TfsTeamProjectCollection] $TfsCollection
        )
    return $TfsCollection.GetService([ Microsoft.TeamFoundation.ProcessConfiguration.Client.TeamSettingsConfigurationService]);
}

```

Figure: Connecting to TFS Team Settings Configuration with PowerShell

While you can use the Process configuration above to change the process template there are also settings that are specific to the Teams that are created with TFS. Not only can you create new teams but there are a plethora of configuration options. Use the [Team Settings Configuration services](http://msdn.microsoft.com/en-us/library/microsoft.teamfoundation.processconfiguration.client.teamsettingsconfigurationservice.aspx) to access and edit these new features. It a little more convoluted an API than I would have liked, but it does have some awesome capabilities.

## Conclusion

Have you been playing with the TFS API in PowerShell? The advantage of a scripting language is obvious in the versatility of both edit-ability and runtime execution of commands to figure out what you need to do. I would have loved for TFS to have built in commands, but with access to the API’s there really is no need. You can do whatever you want.
