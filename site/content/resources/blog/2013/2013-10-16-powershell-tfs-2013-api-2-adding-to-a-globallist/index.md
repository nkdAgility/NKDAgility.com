---
title: 'PowerShell TFS 2013 API #2 - Adding to a GlobalList'
description: Learn how to enhance your TFS 2013 Global List using PowerShell. Automate team field additions effortlessly with our step-by-step guide and reusable functions.
ResourceId: Y2XTGIaY_Os
ResourceType: blog
ResourceImport: true
ResourceImportId: 10151
ResourceImportSource: Wordpress
ResourceImportOriginalSource: Wordpress
date: 2013-10-16
creator: Martin Hinshelwood
layout: blog
resourceTypes: blog
slug: powershell-tfs-2013-api-2-adding-to-a-globallist
aliases:
- /blog/powershell-tfs-2013-api-2-adding-to-a-globallist
- /powershell-tfs-2013-api-2-adding-to-a-globallist
- /powershell-tfs-2013-api--2
- /powershell-tfs-2013-api--2---adding-to-a-globallist
- /blog/powershell-tfs-2013-api--2---adding-to-a-globallist
- /resources/Y2XTGIaY_Os
- /resources/blog/powershell-tfs-2013-api-2-adding-to-a-globallist
aliasesFor404:
- /powershell-tfs-2013-api-2-adding-to-a-globallist
- /blog/powershell-tfs-2013-api-2-adding-to-a-globallist
- /powershell-tfs-2013-api--2---adding-to-a-globallist
- /blog/powershell-tfs-2013-api--2---adding-to-a-globallist
- /powershell-tfs-2013-api--2
- /resources/blog/powershell-tfs-2013-api-2-adding-to-a-globallist
tags:
- Application Lifecycle Management
- Azure DevOps
- DevOps
- Engineering Excellence
- Engineering Practices
- Modern Source Control
- Pragmatic Thinking
- Software Developers
- Software Development
- Software Increment
- System Configuration
- Technical Excellence
- Technical Mastery
- Working Software
categories:
- Code and Complexity
- Practical Techniques and Tooling
- Technical Excellence
preview: metro-powershell-logo-1-1.png

---
Using the TFS 2013 API along with a little PowerShell we can add a ‘team field’ to our global list.

I have been working a lot with PowerShell recently and I have been stuck by its flexibility even when calling standard .NET API’s.  You should start with g[eting the TFS Collection](http://nkdagility.com/powershell-tfs-2013-api-0-get-tfscollection-and-tfs-services/ "Get TFS Collection") which will give you basic connectivity and imports required to get started. If we want to use 'team field' we may want to automate some of the activities that we need to make it happen slickly. You will have created a Global List for your 'team field' and you will want to add new entries. You can add them manually, or you can hit the TFS API to give you a leg up...

In order to add an entry to a global list we unfortunately need to export all of the global lists locally as XML, edit it and then upload it back in. I have been trying to create as many reusable functions as possible in my PowerShell exploits and I am building up a rather hearty set of components. I have not yet figured out how to create reusable components that can be easily imported but I have figured out functions:

```
function Add-TfsGlobalListItem {
    Param(
        [parameter(Mandatory=$true)][Microsoft.TeamFoundation.Client.TfsTeamProjectCollection] $TfsCollection,
        [parameter(Mandatory=$true)][String] $GlobalListName,
        [parameter(Mandatory=$true)][String] $GlobalEntryValue
        )
    # Get Global List
    $store = Get-TfsWorkItemStore $TfsCollection
    [xml]$export = $store.ExportGlobalLists();

    $globalLists = $export.ChildNodes[0];
    $globalList = $globalLists.SelectSingleNode("//GLOBALLIST[@name='$GlobalListName']")

    # if no GL then add it
    If ($globalList -eq $null)
    {
        $globalList = $export.CreateElement("GLOBALLIST");
        $globalListNameAttribute = $export.CreateAttribute("name");
        $globalListNameAttribute.Value = $GlobalListName
        $globalList.Attributes.Append($globalListNameAttribute);
        $globalLists.AppendChild($globalList);
    }

    #Create a new node.
    $GlobalEntry = $export.CreateElement("LISTITEM");
    $GlobalEntryAttribute = $export.CreateAttribute("value");
    $GlobalEntryAttribute.Value = $GlobalEntryValue
    $GlobalEntry.Attributes.Append($GlobalEntryAttribute);

    #Add new entry to list
    $globalList.AppendChild($GlobalEntry)
    # Import list to server
    $store.ImportGlobalLists($globalLists)
}

```

Figure: Adding to a GlobalList with PowerShell

Here you can see that we are first getting the Work Item Store service, which is where all of the magic around Work Item Tracking occurs. Once we have that we need to export the XML using the “ExportGlobalLists” (#9) method which effectively just pucks up the entire XML tree for the global lists. We can then parse and edit it like any other piece of XML. We can find the list that we want, as all of the lists are exported, using a little XPath (#11)  and determine wither the required global list even exists. If it does not then my script goes ahead and adds one (#14-21) so that we don’t get an error. If this is the first time that you are added and element to a list it only makes sense that you would want the list to exist so creating it is not a stretch.

Once we have the list, wither it is a new or existing one, we can go ahead and create and add the new element (#24-27.) Once we have everything in place we can import the entire set of global lists back into the server using the Import method.
