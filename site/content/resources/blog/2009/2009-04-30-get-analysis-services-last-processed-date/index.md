---
title: Get Analysis Services last processed date
date: 2009-04-30
creator: Martin Hinshelwood
id: "129"
layout: blog
resourceType: blog
slug: get-analysis-services-last-processed-date
aliases:
  - /blog/get-analysis-services-last-processed-date
tags:
  - ssas
  - tools
preview: nakedalm-logo-128-link-1-1.png
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

