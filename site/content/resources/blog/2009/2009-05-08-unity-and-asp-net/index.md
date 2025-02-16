---
title: Unity and ASP.NET
description: Discover how to implement Dependency Injection in ASP.NET using Unity, enhancing your web app's flexibility and efficiency without recompiling. Learn more!
ResourceId: ga9A29v5JJk
ResourceType: blog
ResourceImport: true
ResourceImportId: 122
ResourceImportSource: Wordpress
ResourceImportOriginalSource: GeeksWithBlogs
date: 2009-05-08
creator: Martin Hinshelwood
layout: blog
resourceTypes: blog
slug: unity-and-asp-net
aliases:
- /blog/unity-and-asp-net
- /unity-and-asp-net
- /resources/ga9A29v5JJk
- /resources/blog/unity-and-asp-net
aliasesFor404:
- /unity-and-asp-net
- /blog/unity-and-asp-net
- /resources/blog/unity-and-asp-net
tags:
- Technical Mastery
- Software Development
- Engineering Excellence
categories:
- Practical Techniques and Tooling
- Technical Excellence
preview: metro-binary-vb-128-link-1-1.png

---
Using Dependency Injection in a website can get a little dodgy, but in my ASP.NET site use the same base code as my WPF app, I needed a little dependency injection to resolve references at runtime when the application type is known. Now in your ASP.NET page just like in your WPF application you need a little extra bit to get it all going. Finding this for WPF is easy, not so much in ASP.

```
Imports System.Web
Imports System.Web.UI
Imports Microsoft.Practices.Unity
''' <summary>
''' C# version and source
''' http://blogs.msdn.com/mpuleio/archive/2008/07/17/proof-of-concept-a-simple-di-solution-for-asp-net-webforms.aspx
''' </summary>
''' <remarks></remarks>
Public Class UnityHttpModule
    Implements IHttpModule

    Public Sub Dispose() Implements System.Web.IHttpModule.Dispose

    End Sub

    Public Sub Init(ByVal context As System.Web.HttpApplication) Implements System.Web.IHttpModule.Init
        AddHandler context.PreRequestHandlerExecute, AddressOf OnPreRequestHandlerExecute
    End Sub

    Private Sub OnPreRequestHandlerExecute(ByVal sender As Object, ByVal e As EventArgs)
        Dim handler As IHttpHandler = HttpContext.Current.Handler
        If TypeOf handler Is Page Then
            My.Unity.Container.BuildUp(handler.GetType(), handler)

            ' User Controls are ready to be built up after the page initialization is complete
            Dim page As Page = handler
            If Not page Is Nothing Then
                AddHandler page.InitComplete, AddressOf OnPageInitComplete
            End If
        End If
    End Sub

    Private Sub OnPageInitComplete(ByVal sender As Object, ByVal e As EventArgs)
        Dim page As Web.UI.Page = sender
        For Each c In BuildControlTree(page)
            Try
                My.Unity.Container.BuildUp(c.GetType(), c)
            Catch ex As Exception
                ' TODO: Some sort of error handling if important
                WebPortalTrace.Verbose(WebPortalTraceType.Unity, "Unity unable to build up {0}", c.GetType)
            End Try
        Next
    End Sub

    ' Get the controls in the page's control tree excluding the page itself
    Private Function BuildControlTree(ByVal root As Control) As List(Of Control)
        Dim ct As New List(Of Control)
        For Each c In root.Controls
            ct.Add(c)
            ct.AddRange(BuildControlTree(c))
        Next
        Return ct
    End Function

End Class
```

All you need is to put a reference into your config file:

```
  <system.web>
    <httpModules>
      <add name="UnityHttpModule" type="Company.Product.UnityHttpModule, Company.Product"/>
    </httpModules>
  </system.web>
```

And off you go, before you know it you will have dependency injection coming out of your ears.

One of the advantages to using dependency injection is that you could change a piece of functionality without having to recompile and redeploy your site! How about this…

```
<unity>
    <containers>
      <container>
        <types>
          <type type="Company.Product.ViewModels.IRecentItemsViewModel, Company.Product" mapTo="Company.Product.ViewModels.RecentItemsViewModel, Company.Product" />
        </types>
      </container>
    </containers>
</unity>
```

The business then decide that they have to have the order of the recent items list changed but that it needs to go into production immediately, so your testing cycle is extremely tight. No problem… fire up a new solution and create a new class that inherits from IRecentItemsViewModel and implement the new functionality. Then compile it as “Company.Product.Hotfix1”, drop it into your test site bin folder and change line above to:

```
<unity>
    <containers>
      <container>
        <types>
          <type type="Company.Product.ViewModels.IRecentItemsViewModel, Company.Product" mapTo="Company.Product.Hotfix1.ViewModels.RecentItemsViewModel, Company.Product.Hotfix1" />
        </types>
      </container>
    </containers>
</unity>
```

The site will then load your new code and you can test the only functionality that you have changed, before deploying to production. Now this may not seam like much, but if your system is made up of thousands of views then you may just need this functionality. And it is so easy to achieve that even for small projects it is fantastic.

P.S. Works with MVC… shhhh…

Technorati Tags: [Software Development](http://technorati.com/tags/Software+Development) [.NET](http://technorati.com/tags/.NET) [CodeProject](http://technorati.com/tags/CodeProject) [WPF](http://technorati.com/tags/WPF)
