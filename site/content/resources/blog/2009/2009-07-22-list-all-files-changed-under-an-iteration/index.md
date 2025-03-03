---
title: List all files changed under an Iteration
description: Discover how to list all files changed under a specific iteration using TFS API calls. Streamline your version control process with this practical guide!
ResourceId: M07b_KU6l8f
ResourceType: blog
ResourceImport: true
ResourceImportId: 99
ResourceImportSource: Wordpress
ResourceImportOriginalSource: GeeksWithBlogs
date: 2009-07-22
weight: 775
creator: Martin Hinshelwood
layout: blog
resourceTypes: blog
slug: list-all-files-changed-under-an-iteration
aliases:
- /blog/list-all-files-changed-under-an-iteration
- /list-all-files-changed-under-an-iteration
- /resources/M07b_KU6l8f
- /resources/blog/list-all-files-changed-under-an-iteration
aliasesArchive:
- /blog/list-all-files-changed-under-an-iteration
- /list-all-files-changed-under-an-iteration
- /resources/blog/list-all-files-changed-under-an-iteration
tags:
- Practical Techniques and Tooling
- Azure DevOps
- Azure Repos
- Software Development
categories:
- DevOps
- Engineering Excellence
preview: metro-visual-studio-2005-128-link-1-1.png

---
I was asked by a colleague to provide a list of all files that were changed under a particular iteration. Rather than delving into the data, I made a couple of API calls to TFS to output a text file with the list.

This is probably not the most efficient method and it is hard coded, but it does output the goods:

```
Dim tfs As New TeamFoundationServer("http://testtfs01:8080")
Dim store As WorkItemStore = tfs.GetService(GetType(WorkItemStore))
Dim version As VersionControlServer = tfs.GetService(GetType(VersionControlServer))
' Query for work items
Dim query As String = "SELECT [System.Id], [System.Title] " _
                     & "FROM WorkItems " _
                     & "WHERE [System.TeamProject] = @Project  " _
                     & "AND  [System.IterationPath] UNDER @IterationPath  " _
                     & "ORDER BY [System.Id]"
Dim paramiters As New Hashtable
paramiters.Add("Project", "TestProject1")
paramiters.Add("IterationPath", "TestProject1TestIteration1")
Dim y As WorkItemCollection = store.Query(query, paramiters)
Console.WriteLine(String.Format("Found {0} work items", y.Count))
' Query work items for attachments
Dim wiats = From wi As WorkItem In y, l As Link In wi.Links Where l.BaseType = BaseLinkType.ExternalLink Select l, wi
Console.WriteLine(String.Format("Loading {0} changesets...", wiats.Count))
Dim ChangeSets As New List(Of Changeset)
If Not wiats Is Nothing Then
    Dim els = From i In wiats Where LinkingUtilities.DecodeUri(CType(i.l, ExternalLink).LinkedArtifactUri).ArtifactType = "Changeset"
    For Each i In wiats
        Dim el As ExternalLink = CType(i.l, ExternalLink)
        Dim artifact As ArtifactId = LinkingUtilities.DecodeUri(el.LinkedArtifactUri)
        If artifact.ArtifactType = "Changeset" Then
            Dim cs As Changeset = version.ArtifactProvider.GetChangeset(New Uri(el.LinkedArtifactUri))
            ChangeSets.Add(cs)
        End If
    Next
    ' ------------------------------
    Console.WriteLine(String.Format("{0} changesets loaded", ChangeSets.Count))
    Dim files = From f In ChangeSets, c In f.Changes Select c.Item Distinct
    Using x = System.IO.File.CreateText("c:Tempfiles.txt")
        For Each f In files
            x.WriteLine(f.ServerItem)
        Next

    End Using

End If
If Debugger.IsAttached Then
    Console.ReadKey()
End If
```

As you can see I have very bad naming and layout, but this is a one time use version of the code, so quick and dirty. If I am asked to do this again I would create a proper command line utility, or even a WPF interface to display the data prettily.

Technorati Tags: [ALM](http://technorati.com/tags/ALM) [WIT](http://technorati.com/tags/WIT) [TFS Custom](http://technorati.com/tags/TFS+Custom) [TFBS](http://technorati.com/tags/TFBS) [Version Control](http://technorati.com/tags/Version+Control) [WPF](http://technorati.com/tags/WPF) [TFS](http://technorati.com/tags/TFS)
