---
title: TFS Process Template migration script updated
description: Discover how to easily migrate TFS process templates with our updated script. Follow five simple steps to streamline your Agile and Scrum processes!
ResourceId: __k7mlKoTxt
ResourceType: blog
ResourceImport: true
ResourceImportId: 10558
ResourceImportSource: Wordpress
ResourceImportOriginalSource: Wordpress
date: 2014-06-11
creator: Martin Hinshelwood
layout: blog
resourceTypes: blog
slug: tfs-process-template-migration-script-updated
aliases:
- /blog/tfs-process-template-migration-script-updated
- /tfs-process-template-migration-script-updated
- /resources/__k7mlKoTxt
- /resources/blog/tfs-process-template-migration-script-updated
aliasesFor404:
- /tfs-process-template-migration-script-updated
- /blog/tfs-process-template-migration-script-updated
- /resources/blog/tfs-process-template-migration-script-updated
tags: []
categories:
- Install and Configuration
- Practical Techniques and Tooling
- Application Lifecycle Management
preview: nakedalm-experts-visual-studio-alm-1-1.png

---
Did you know that you can quite easily to do a TFS process template migration? Did you notice I used the "quite" in there. Well if you think of the Process Template as the blueprints then the Team Project that you create is the concrete instance of that blueprint.

Warning: naked ALM Consulting provide no warranties of any type, nor accepts any blame for things you do to your servers in your environments. We will however, at our [standard consulting rates](http://nkdalm.net/ALMTerms), provide best efforts to help you resolve any issues that you encounter.

I have written on this topic before, however it is always worth refreshing it as I discover more every time I do an update. My current customer is wanting to move from a frankintemplate (a mishmash of Agile for MSF Software Development and CMMI for MSF Process Improvement) to a more vanilla Visual Studio Scrum template. In this case it is an upgraded 2010 server with 4.x templates to the 2013.3 (downloaded from VSO) Scrum one.

There are five simple steps that we need to follow:

1. **Select** - Pick the process template that is closest to where you want to be (I recommend the Scrum template is all scenarios)
2. **Customise** - Re-implement any customisations that you made to your old template to the new one taking into account advances in design , new features, and implementation changes. You may need to have duplicate fields to access old data.
3. **Import** - simply overwrite the existing work item types, categories, and process configuration with your new one.  
   _note: if you are changing the names of Work Items (for example User Story or Requirement to Product Backlog Item) then you should do this before you do the import.  
   note: Make sure that you backup your existing work item types by exporting them from your team project._
4. **Migrate data** - Push some data around… for example Stack Rank field is now Backlog Priority and the Story Points field is now Effort. You may also have done that DescriptionHTML in 2010 that you will want to get rid of.
5. **Housekeeping** - if you had to keep some old fields to migrate data you can now remove them

While it is simple, depending on the complexity and customisation of your process, you want to get #2 right to move forward easily. Indeed you are effectively committed when you hit #3. If it is so easy why can't it be scripted, I hear you shout? Well you can and I have, however I always run the script carefully block by block so that there are no mistakes. Indeed I have configured the script so that I can tweek the xml of the template and only re-import the bits that are changes. This is the script I use for #3.

```
$TeamProjectName = "myTeamProject"
$ProcessTemplateRoot = Get-Location
$CollectionUrl = "http://mytfsserver:8080/tfs/mycollection"
```

The first part is to get the variables in there. There are a bunch of things that we need in place such as Collection URL and the name of your Team Project that we will use over and over again.

```
# Make sure we only run what we need
[datetime] $lastImport
$UpdateFilePath = ".\UpdateTemplate.txt"
if ((Test-Path $UpdateFilePath) -eq $true)
{
  $UpdateFile = Get-Item -Path $UpdateFilePath
  $lastImport = $UpdateFile.LastWriteTime
} else {
  $lastImport = [datetime]::MinValue
}
Write-Output "Last Import was $lastImport"
```

Then I do a little trick with the date. I try to load the last date and time that the script was run from a file and set a default if it does not exist. This will allow me to test to see if we have been tweaking the template and only update the latest tweaks. I generally use this heavily in my dev/test cycle when I am building out the template. I tend to create an empty project to hold my process template definition within Visual Studio so that I get access to easy source control and can hook this script up to the build button. If I was doing this for a large company I would also hook up to Release Management and create a pipeline that I can push my changes through and get approvals from the right people in there.

```
$WitAdmin = "${env:ProgramFiles(x86)}\Microsoft Visual Studio 12.0\Common7\IDE\witadmin.exe"
$tfpt = "${env:ProgramFiles(x86)}\Microsoft Visual Studio 2013 Power Tools\tfpt.exe"
```

Next I configure the tools that I am going to use. This is very version specific with the above only working on a computer with 2013 editions of the product installed. Although I am only using the $WitAdmin variable I keep the rest around so that remember where they are.

```
& $WitAdmin renamewitd /collection:$CollectionUrl /p:$TeamProjectName /n:"User Story" /new:"Product Backlog Item"
& $WitAdmin renamewitd /collection:$CollectionUrl /p:$TeamProjectName /n:"Issue" /new:"Impediment"
```

Once, and only once I will run the rename command for data stored in a work item type that I want to keep. For example if I am moving from the Agile to Scrum templates I will rename "User Story" to "Product Backlog Item" and "Issue" to "Impediment". The only hard part here is if you have ended up with more than one work item type that means the same thing as you can't merge types easily or gracefully.

_Note: If you do need to merge data you have a couple of options; a) 'copy' each work item to the new type. This is time consuming and manual. Suitable for less than fifty work items; b) export to excel and then import as the new type. This leaves everything in the new state and they manually have to walk the wokflow. Suitable for less than two hundred work items; c) Spin up the TFS Integration Tools. Pain and suffering this way lies. Greater than a thousand work items only._

```
$lts = Get-ChildItem "$ProcessTemplateRoot\WorkItem Tracking\LinkTypes" -Filter "*.xml"
foreach( $lt in $lts)
{
    if ($lt.LastWriteTime -gt $lastImport)
    {
        Write-Host "+Importing $lt"
        & $WitAdmin importlinktype /collection:$CollectionUrl /f:$($lt.FullName)
    } else {
        Write-Host "-Skipping $lt"
    }
}
```

Importing the link types tends to be unnecessary but I always do it as I have caught out a couple of times. Its mostly like for like and has no effect. If you have custom relationships, like "Releases \\ Released By" for a "Release" work item type to Backlog Items you may need this.

```
$witds = Get-ChildItem "$ProcessTemplateRoot\WorkItem Tracking\TypeDefinitions" -Filter "*.xml"
foreach( $witd in $witds)
{
    if ($witd.LastWriteTime -gt $lastImport)
    {
        Write-Host "+Importing $witd"
        & $WitAdmin importwitd /collection:$CollectionUrl /p:$TeamProjectName /f:$($witd.FullName)
    } else {
        Write-Host "-Skipping $witd"
    }
}
```

Now I want to update the physical work items in your Team Project. This will overwrite the existing definition so make really sure that you have a backup. No really, go take a backup now by using the "witadmin exportwitd" and running it for each of your existing types. Yes.. All of them… now you can run this part of the script.

After this you will have the correct work item types however we have not updated the categories or the process configuration so things may be a little weird in TFS until we finish up. The Work Item type provides the list of fields contained within the work item, the form layout, and the workflow of the state changes. All of these will now have been upgrade to the new version. Features will be broken at this point until we get a little further.

```
$Cats = Get-Item "$ProcessTemplateRoot\WorkItem Tracking\Categories.xml"
if ($Cats.LastWriteTime -gt $lastImport)
{
    Write-Host "+Importing $Cats"
    & $WitAdmin importcategories /collection:$CollectionUrl /p:$TeamProjectName /f:$($cats.FullName)
} else {
    Write-Host "-Skipping $($Cats.name)"
}
```

The categories file determines which work items are viable and what they are used for. After TFS 2010 the TFS team moved to categorising work item types so that reporting and feature implementation became both easier and less error prone. This is a simple import of a single file. Not much will change in the UI.

```
$ProcessConfig = Get-Item "$ProcessTemplateRoot\WorkItem Tracking\Process\ProcessConfiguration.xml"
if ($ProcessConfig.LastWriteTime -gt $lastImport)
{
    Write-Host "+Importing $($ProcessConfig.name)"
    & $WitAdmin importprocessconfiguration /collection:$CollectionUrl /p:$TeamProjectName /f:"$($ProcessConfig.FullName)"
} else {
    Write-Host "-Skipping $($ProcessConfig.name)"
}
```

If you have TFS 2013 there is only one Process Configuration file. This controls how all of the Agile Planning tools interact with your work items and many other configurations, even the colour of the work items. This is the glue that holds everything together and makes it work. Once this is updated your are effectively upgraded. If you still have errors then you have done something wrong.

_Note: You may need to a full refresh in Web Access and on Client API's (VS and Eclipse) to see these changes._

```
$AgileConfig = Get-Item "$ProcessTemplateRoot\WorkItem Tracking\Process\AgileConfiguration.xml"
if ($AgileConfig.LastWriteTime -gt $lastImport)
{
    Write-Host "+Importing $($AgileConfig.name)"
    & $WitAdmin importagileprocessconfig /collection:$CollectionUrl /p:$TeamProjectName /f:"$($AgileConfig.FullName)"
} else {
    Write-Host "-Skipping $($AgileConfig.name)"
}
$CommonConfig = Get-Item "$ProcessTemplateRoot\WorkItem Tracking\Process\CommonConfiguration.xml"
if ($CommonConfig.LastWriteTime -gt $lastImport)
{
    Write-Host "+Importing $($CommonConfig.name)"
    & $WitAdmin importcommonprocessconfig /collection:$CollectionUrl /p:$TeamProjectName /f:"$($CommonConfig.FullName)"
} else {
    Write-Host "-Skipping $($CommonConfig.name)"
}
```

If you are on TFS 2012 then you have the same thing but instead of one consolidated file there are two files… for no reason whatsoever that I can determine…which is why it's one in 2013. Same, without the colours, configuration though.

\[code\]

$lastImport = \[datetime\]::Now

Out-File -filepath ".\\UpdateTemplate.txt" -InputObject $lastImport

\[/code\]

The final piece of the puzzle is to update the datetime file we tried to load at the start. This will allow us to update a single xml file that we imported above and the script, when re-run in part or in its entirety, will only update what it needs. It just makes things a little quicker.

And there you have it. Contrary to popular belief you can upgrade or migrate from one process template to another in TFS. It may be because you want to use the new features or it may be because you are radically changing you process, it can be done.

Good luck with your changes…
