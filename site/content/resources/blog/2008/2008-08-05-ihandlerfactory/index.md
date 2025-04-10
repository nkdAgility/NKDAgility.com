---
title: IHandlerFactory
description: Discover how to implement a BlogRedirectHandler in ASP.NET to manage URL redirects effectively, ensuring a smooth transition for your users.
ResourceId: kYNSKaqUYb7
ResourceType: blog
ResourceContentOrigin: Human
ResourceImport: true
ResourceImportId: 214
ResourceImportSource: Wordpress
ResourceImportOriginalSource: GeeksWithBlogs
date: 2008-08-05
weight: 840
creator: Martin Hinshelwood
layout: blog
resourceTypes: blog
slug: ihandlerfactory
aliases:
- /blog/ihandlerfactory
- /ihandlerfactory
- /resources/kYNSKaqUYb7
- /resources/blog/ihandlerfactory
aliasesArchive:
- /blog/ihandlerfactory
- /ihandlerfactory
- /resources/blog/ihandlerfactory
tags:
- Software Development
categories: []
preview: metro-binary-vb-128-link-1-1.png

---
As you have probably noticed I have moved URL’s (sorry to all you feed readers with the duplicate entries). The reason I moved my blog was to free up the [http://hinshelwood.com](http://hinshelwood.com) URL for use as a personal site that then links to my blog. When you do this you need to consider all of your current users, bookmarks, feeds, links and all that malarkey.

So, I created a WebRedirect (thanks to DynDNS.org) that means that all hinshelwood.com traffic is automatically redirected to blog.hinshelwood.com including all of the sub pages. This is fine until I actually put up a site on hinshelwood.com and brake all of the links… HttpHandler to the rescue…

The first step was to create a “BlogRedirectHandler” to redirect all of those pesky URL’s to the new site.

```
Imports System.Text.RegularExpressions
Imports System.Web

Namespace Core.Handlers

    Public Class BlogRedirectHandler
        Implements IHttpHandler

        Private Shared m_Patterns() As String = {"/archive/*", _
                                                 "/Tag/*/default.aspx", _
                                                 "/category/*"}

        Public Shared Function IsValidToRun(ByVal context As System.Web.HttpContext, _
                                            ByVal requestType As String, _
                                            ByVal virtualPath As String, _
                                            ByVal path As String) As Boolean
            For Each p In m_Patterns
                If Regex.IsMatch(context.Request.Url.ToString, p) Then Return True
            Next
            Return False
        End Function

        Public ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
            Get
                Return True
            End Get
        End Property

        Public Sub ProcessRequest(ByVal context As System.Web.HttpContext) Implements IHttpHandler.ProcessRequest
            Dim oldurl As String = context.Request.Url.ToString
            If oldurl.Contains("/archive/") Then
                Dim newurl As String = "http://blog.hinshelwood.com" & context.Request.Url.AbsolutePath
                context.Response.StatusCode = System.Net.HttpStatusCode.MovedPermanently ' permanent HTTP 301
                context.Response.RedirectLocation = newurl
                context.Response.StatusDescription = "Moved Permanently"
                context.Response.ContentType = "text/html"
                context.Response.Write("<html><head><title>Object Moved</title></head><body>")
                context.Response.Write("<h2>Object moved to <a href=" & newurl & " >here</a>.</h2>")
                context.Response.Write("</body></html>")
                context.Response.End()
            End If

        End Sub

    End Class

End Namespace
```

This little piece of code has two important pieces, the “IsValidToRun” which makes sure that we need to run it, and the “ProcessRequest” method that does the actual dog work of the redirect.

I have chosen to use a “MovedPermanently“ status so that the search engines will catch on more quickly and the new URL should quite quickly replace the old.

If we just added this handler to the web application we would loose all of our .aspx pages and only see a blank page for those that are not valid for this handler.

To handle this the easiest way is to inherit from the existing “PageHandlerFactory” that is the default in ASP.NET.

```
Imports System.Web

Namespace Core.Handlers

    Public Class CustomPageHandlerFactory
        Inherits PageHandlerFactory

        Public Overrides Function GetHandler(ByVal context As System.Web.HttpContext, _
                                             ByVal requestType As String, _
                                             ByVal virtualPath As String, _
                                             ByVal path As String) As IHttpHandler
            If BlogRedirectHandler.IsValidToRun(context, requestType, virtualPath, path) Then
                Return New BlogRedirectHandler
            Else
                Return MyBase.GetHandler(context, requestType, virtualPath, path)
            End If
        End Function
    End Class

End Namespace
```

Then all we need to do is call our IsValidToRun method and either run the base (default) GetHandler or return our new handler…

> Technorati Tags: [.NET 3.5](http://technorati.com/tags/.NET+3.5),[.NET 2.0](http://technorati.com/tags/.NET)
