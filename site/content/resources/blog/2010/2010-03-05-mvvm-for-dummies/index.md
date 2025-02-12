---
title: MVVM for Dummies
description: Master MVVM with this essential guide for developers. Learn best practices in WPF and Silverlight to achieve clean, maintainable code. Dive in now!
ResourceId: __7oXNKjdWP
ResourceType: blog
ResourceImport: true
ResourceImportId: 65
ResourceImportSource: Wordpress
ResourceImportOriginalSource: GeeksWithBlogs
date: 2010-03-05
creator: Martin Hinshelwood
layout: blog
resourceTypes: blog
slug: mvvm-for-dummies
aliases:
- /blog/mvvm-for-dummies
- /mvvm-for-dummies
- /resources/__7oXNKjdWP
- /resources/blog/mvvm-for-dummies
aliasesFor404:
- /mvvm-for-dummies
- /blog/mvvm-for-dummies
- /resources/blog/mvvm-for-dummies
tags: []
categories: []
preview: metro-binary-vb-128-link-1-1.png

---
I think that I have found one of the best articles on MVVM that I have ever read:

[http://jmorrill.hjtcentral.com/Home/tabid/428/EntryId/432/MVVM-for-Tarded-Folks-Like-Me-or-MVVM-and-What-it-Means-to-Me.aspx](http://jmorrill.hjtcentral.com/Home/tabid/428/EntryId/432/MVVM-for-Tarded-Folks-Like-Me-or-MVVM-and-What-it-Means-to-Me.aspx)

This article sums up what is in MVVM and what is outside of MVVM. Note, when I and most other people say MVVM, they really mean MVVM, Commanding, Dependency Injection + any other Patterns you need to create your application.

In WPF a lot of use is made of the Decorator and Behaviour pattern as well. The goal of all of this is to have pure separation of concerns. This is what every code behind file of every Control / Window / Page  should look like if you are engineering your WPF and Silverlight correctly:

### C# – Ideal

```
  public partial class IdealView : UserControl
  {
      public IdealView()
      {
          InitializeComponent();
      }
  }
```

**Figure: This is the ideal code behind for a Control / Window / Page when using MVVM.**

### C# – Compromise, but works

```
  public partial class IdealView : UserControl
  {
      public IdealView()
      {
          InitializeComponent();

          this.DataContext = new IdealViewModel();
      }
  }
```

**Figure: This is a compromise, but the best you can do without Dependency Injection**

### VB.NET – Ideal

```
Partial Public Class ServerExplorerConnectView

End Class
```

**Figure: This is the ideal code behind for a Control / Window / Page when using MVVM.**

### VB.NET – Compromise, but works

```
Partial Public Class ServerExplorerConnectView

    Private Sub ServerExplorerConnectView_Loaded(ByVal sender As Object, ByVal e As System.Windows.RoutedEventArgs) Handles Me.Loaded
        Me.DataContext = New ServerExplorerConnectViewModel
    End Sub

End Class
```

**Figure: This is a compromise, but the best you can do without Dependency Injection**

Technorati Tags: [.NET](http://technorati.com/tags/.NET) [WPF](http://technorati.com/tags/WPF) [Silverlight](http://technorati.com/tags/Silverlight) [MVVM](http://technorati.com/tags/MVVM)
