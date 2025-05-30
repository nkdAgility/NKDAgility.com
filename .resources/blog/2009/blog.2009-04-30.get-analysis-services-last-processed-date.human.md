---
title: Get Analysis Services last processed date
description: Provides code to retrieve the last processed date of cubes on an Analysis Services server, highlighting performance considerations and error handling in .NET environments.
ResourceId: _Pa-Z4LIvzg
ResourceType: blog
ResourceContentOrigin: Human
ResourceImport: true
ResourceImportId: 129
ResourceImportSource: Wordpress
ResourceImportOriginalSource: GeeksWithBlogs
date: 2009-04-30
weight: 1000
creator: Martin Hinshelwood
layout: blog
resourceTypes: blog
slug: get-analysis-services-last-processed-date
aliases:
- /resources/_Pa-Z4LIvzg
aliasesArchive:
- /blog/get-analysis-services-last-processed-date
- /get-analysis-services-last-processed-date
- /resources/blog/get-analysis-services-last-processed-date
tags: []
preview: nakedalm-logo-128-link-1-1.png
categories:
- Uncategorized
Watermarks:
  description: 2025-05-13T15:24:15Z
concepts: []

---
I need a little bit of code to get the last processed date for the cube that my site connects to:

```
Public Function GetCubeLastProcessedDates(ByVal AnalysisServer As String) As Collection(Of CubeInfo)
    Dim result As Collection(Of CubeInfo)
    Dim identity As WindowsIdentity = WindowsIdentity.GetCurrent()
    Dim eCode As Integer = CommonUtility.RevertToSelf()
    Dim oServer As New Server
    Try
        result = New Collection(Of CubeInfo)
        oServer.Connect(String.Format(CultureInfo.InvariantCulture, "data Source = {0};", AnalysisServer))

        For Each d As Database In oServer.Databases
            For Each c As Cube In d.Cubes
                result.Add(New CubeInfo(d.Name, c.Name, c.LastProcessed))
            Next
        Next

        oServer.Disconnect()
    Catch e As ConnectionException
        ' Do some error handling
    Catch e As AdomdErrorResponseException
        ' Do some error handling
    Catch e As AdomdConnectionException
        ' Do some error handling
    Catch e As Microsoft.AnalysisServices.AmoException
        ' Do some error handling
    Catch e As Exception
        Throw
    Finally
        oServer.Dispose()
        identity.Impersonate()
    End Try
    '------------------------------
    Return result
End Function
```

The only problem I have with this is that while it takes no longer than 5 seconds to return a negative result, it can take as much as 30 seconds to return when in the positive (i.e. you can access the cube).

This makes it a threading only, and more than that, a nice to have only. If this is critical information then you will just have to wait…

Technorati Tags: [.NET](http://technorati.com/tags/.NET)
