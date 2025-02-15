---
title: Writing .NET in PowerShell and creating TFS Teams
description: Discover how to leverage PowerShell for .NET and TFS API to create teams programmatically. Unlock new coding possibilities with practical insights!
ResourceId: 52GnS0fI67Q
ResourceType: blog
ResourceImport: true
ResourceImportId: 9903
ResourceImportSource: Wordpress
ResourceImportOriginalSource: Wordpress
date: 2013-06-13
creator: Martin Hinshelwood
layout: blog
resourceTypes: blog
slug: writing-net-in-powershell-and-creating-tfs-teams
aliases:
- /blog/writing-net-in-powershell-and-creating-tfs-teams
- /writing-net-in-powershell-and-creating-tfs-teams
- /writing--net-in-powershell-and-creating-tfs-teams
- /blog/writing--net-in-powershell-and-creating-tfs-teams
- /resources/52GnS0fI67Q
- /resources/blog/writing-net-in-powershell-and-creating-tfs-teams
aliasesFor404:
- /writing-net-in-powershell-and-creating-tfs-teams
- /blog/writing-net-in-powershell-and-creating-tfs-teams
- /writing--net-in-powershell-and-creating-tfs-teams
- /blog/writing--net-in-powershell-and-creating-tfs-teams
- /resources/blog/writing-net-in-powershell-and-creating-tfs-teams
tags: []
categories:
- Practical Techniques and Tooling
- Azure DevOps
preview: image11-1-1.png

---
Did you know that you could be writing .NET in PowerShell? PowerShell can be used to instanciate and call any .NET object and that includes the TFS API.

On of my [colleagues](http://b4root.com/) today suggested that it was harder to create a new Team programmatically in PowerShell than it would in c#. Well I have been playing with PowerShell a lot recently and I decided to give it a go… And do you know what… it is harder… that is.. until you know how.

I have been confused by PowerShell for a while now. I have struggled and struggled to create and run PowerShell until just a few days ago I had an epiphany:

> PowerShell is just c# with all of the bad bits taken out. No case sensitivity, no pointless semi-colon at the end of lines and no unnecessary parentheses to tell the compiler something that it should already know.  
> \-Martin Hinshelwood, 2013

Now I am not all there with the syntax and there are a bunch of things I think are really silly and hard, but if you squint at PowerShell just right it is really just the syntax of c# with all of the good bits of VB rolled into a nice code pie.

The first thing that In need to do to create a Team in TFS is to get a hold of a collection object and this resulted in my first problem…

```
TfsTeamProjectCollectionFactory.GetTeamProjectCollection(new Uri(CollectionUri));

```

Not only does the code above (c#) have a static method call, but the object that is called has been shortened by using an Include in the c# code. So how do we both reference an object and ask PowerShell to do something with it.

```
[Microsoft.TeamFoundation.Client.TfsTeamProjectCollectionFactory]::GetTeamProjectCollection($CollectionUrlParam)

```

Interesting… so we just bracket the object and do the old double colon to get that effect. Not what I thought but I have seen this before (not sure where) and I can work with that… so is that the same for an enum?

```
[Microsoft.TeamFoundation.Client.TeamProjectPickerMode]::NoProject

```

So it is...

And thus we hit the second problem that I alluded to earlier… how do we import a namespace to gain access to the classes. We need to reference the DLL in a project so there must be some way to do that here. A little searching around and you will find the Add-Type command that will add any assembly as a reference.

```
Add-Type -AssemblyName "Microsoft.TeamFoundation.Client, Version=11.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a",
                       "Microsoft.TeamFoundation.Common, Version=11.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a",
                       "Microsoft.TeamFoundation, Version=11.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a"


```

So now we can add assemblies we can do pretty much whatever we like. PowerShell is a little more flexible than .NET directly sometime as you can just quote a type and it will get converted for you. This was especially painful in c#…

So… my final script to add a new Team to TFS looked something like.

```
 Param(
       [string] $CollectionUrlParam = $(Read-Host -prompt "Collection"),
       [string] $TeamName = $(Read-Host -prompt "Team"),
       [string] $project = $(Read-Host -prompt "Project")
       )

# load the required dlls
Add-Type -AssemblyName "Microsoft.TeamFoundation.Client, Version=11.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a",
                       "Microsoft.TeamFoundation.Common, Version=11.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a",
                       "Microsoft.TeamFoundation, Version=11.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a"

# Get TFS
$tfs = [Microsoft.TeamFoundation.Client.TfsTeamProjectCollectionFactory]::GetTeamProjectCollection($CollectionUrlParam)
$tfs.EnsureAuthenticated()
# Get Team Project
$cssService = $tfs.GetService("Microsoft.TeamFoundation.Server.ICommonStructureService3")
$teamProject += $cssService.GetProjectFromName($project)
# Create Team
$teamService = $tfs.GetService("Microsoft.TeamFoundation.Client.TfsTeamService")
$Team = $teamService.CreateTeam($teamProject.Uri, $TeamName, "", $null)
# Show what we created
$team

```

But wait… you must be thinking ‘well what about the other programming constructs’? What I have done able is all fairly simple what if I want to go ahead and call the TFS built in project picker so that I don’t have to do all that variable nonsense. Now we are talking ‘if’ and dialogs…

```
$picker = New-Object Microsoft.TeamFoundation.Client.TeamProjectPicker([Microsoft.TeamFoundation.Client.TeamProjectPickerMode]::NoProject, $false)
$dialogResult = $picker.ShowDialog()
if ($dialogResult -ne "OK")
{
    exit
}
$tfs = $picker.SelectedTeamProjectCollection
$projectList = $picker.SelectedProjects

```

But what about if you make it mad? YOu can’t just throw a Try Catch in there we would have to do some crazy “On Error” and “GOTO” wouldn't we?

```
try
{
    $tfs.EnsureAuthenticated()
}
catch
{
    Write-Error "Error occurred trying to connect to project collection: $_ "
    exit 1
}

```

Now we begin to get a picture of what is possible inside PowerShell. Would the above be easier if  there were nice easy commands like “Add-Team” or “Add-TeamProject” existed? Well yes it would, but that they don’t is not going to cripple us. We can get buy without them..

In short, anything you can do in code you can do in PowerShell.
