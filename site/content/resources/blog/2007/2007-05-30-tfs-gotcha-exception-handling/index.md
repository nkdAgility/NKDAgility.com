---
title: TFS Gotcha (Exception Handling)
description: Learn how to effectively handle non-serializable exceptions in Team Foundation Server with custom solutions for Windows Communication Foundation. Enhance your coding skills!
ResourceId: OMGmyApgm0G
ResourceType: blog
ResourceImport: true
ResourceImportId: 392
ResourceImportSource: Wordpress
ResourceImportOriginalSource: GeeksWithBlogs
date: 2007-05-30
creator: Martin Hinshelwood
layout: blog
resourceTypes: blog
slug: tfs-gotcha-exception-handling
aliases:
- /blog/tfs-gotcha-exception-handling
- /tfs-gotcha-exception-handling
- /tfs-gotcha-(exception-handling)
- /blog/tfs-gotcha-(exception-handling)
- /resources/OMGmyApgm0G
- /resources/blog/tfs-gotcha-exception-handling
aliasesFor404:
- /tfs-gotcha-exception-handling
- /blog/tfs-gotcha-exception-handling
- /tfs-gotcha-(exception-handling)
- /blog/tfs-gotcha-(exception-handling)
- /resources/blog/tfs-gotcha-exception-handling
tags: []
categories: []

---
When coding against team foundation server you must be aware that some of the exceptions thrown by [Team Foundation Server](http://msdn2.microsoft.com/en-us/teamsystem/aa718934.aspx "Team Foundation Server") are not Serilisable! I think that this was an oversite by Microsoft, but it is there none the less.

An example of this is; TeamFoundationServerUnauthorizedException

If you want to handle this exception accross [Windows Communication Foundation](http://wcf.netfx3.com "Windows Communication Foundation") you will need to create a custom exception of the same name and re-throw this accross your services.

<DataContract()> \_  
Public Class TeamFoundationServerUnauthorizedException

Public Sub New()  
    ...  
  End Sub

End Class

Make sure that you mark it as a data contract and then you can throw it when you encounter the [Team Foundation Server](http://msdn2.microsoft.com/en-us/teamsystem/aa718934.aspx "Team Foundation Server") exception:

Try  
  ' [Team Foundation Server](http://msdn2.microsoft.com/en-us/teamsystem/aa718934.aspx "Team Foundation Server") Connection Code  
Catch ex As TeamFoundationServerUnauthorizedException  
  Throw New FaultException(Of FaultContracts.TeamFoundationServerUnauthorizedException)(New FaultContracts.TeamFoundationServerUnauthorizedException())  
Catch ex As System.Exception  
  Throw New FaultException(Of System.Exception)(ex, "Failed to do team server thing", New FaultCode("[Team Foundation Server](http://msdn2.microsoft.com/en-us/teamsystem/aa718934.aspx "Team Foundation Server"):EH:S:0001"))  
End Try

This will allow you to handle [Team Foundation Server](http://msdn2.microsoft.com/en-us/teamsystem/aa718934.aspx "Team Foundation Server") exceptions for your [Windows Communication Foundation](http://wcf.netfx3.com "Windows Communication Foundation") service application on the client.

Technorati Tags: [ALM](http://technorati.com/tags/ALM) [TFS](http://technorati.com/tags/TFS)
