---
title: Sync extension for Lists/Collections or whatever
description: Discover how to effortlessly sync two lists in .NET with a simple extension method. Enhance your coding skills and streamline your data management!
ResourceId: hDlrQdNzLp1
ResourceType: blog
ResourceImport: true
ResourceImportId: 188
ResourceImportSource: Wordpress
ResourceImportOriginalSource: GeeksWithBlogs
date: 2008-10-13
creator: Martin Hinshelwood
layout: blog
resourceTypes: blog
slug: sync-extension-for-listscollections-or-whatever
aliases:
- /blog/sync-extension-for-listscollections-or-whatever
- /sync-extension-for-listscollections-or-whatever
- /sync-extension-for-lists-collections-or-whatever
- /blog/sync-extension-for-lists-collections-or-whatever
- /resources/hDlrQdNzLp1
- /resources/blog/sync-extension-for-listscollections-or-whatever
aliasesFor404:
- /sync-extension-for-listscollections-or-whatever
- /blog/sync-extension-for-listscollections-or-whatever
- /sync-extension-for-lists-collections-or-whatever
- /blog/sync-extension-for-lists-collections-or-whatever
- /resources/blog/sync-extension-for-listscollections-or-whatever
tags:
- Software Development
- Technical Mastery
categories:
- Engineering Excellence
preview: metro-binary-vb-128-link-1-1.png

---
I recently found the need to Sync two lists. I have one list that is used for display, and I want to dynamically sync that list with a new one by applying a delta.

I thought that this would be difficult, but I was surprised at its ease.

```
   1: 
```

```
   2: Module SyncExtensions
```

```
   3: 
```

```
   4:     <System.Runtime.CompilerServices.Extension()> _
```

```
   5:     Public Sub Sync(Of TItem)(ByVal targetItems As ICollection(Of TItem), ByVal sourceItems As IEnumerable(Of TItem))
```

```
   6:         Dim o As Object = DirectCast(targetItems, ICollection).SyncRoot
```

```
   7:         If Monitor.TryEnter(o, TimeSpan.FromSeconds(10)) Then
```

```
   8:             ' Find items in source that are not in target
```

```
   9:             Dim itemsToAdd As New Collection(Of TItem)
```

```
  10:             For Each Item In sourceItems
```

```
  11:                 If Not targetItems.Contains(Item) Then
```

```
  12:                     itemsToAdd.Add(Item)
```

```
  13:                 End If
```

```
  14:             Next
```

```
  15:             ' Apply all adds
```

```
  16:             For Each Item In itemsToAdd
```

```
  17:                 targetItems.Add(Item)
```

```
  18:             Next
```

```
  19:             ' Find tags in target that should not be in source
```

```
  20:             Dim itemsToRemove As New Collection(Of TItem)
```

```
  21:             For Each Item In targetItems
```

```
  22:                 If Not sourceItems.Contains(Item) Then
```

```
  23:                     itemsToRemove.Add(Item)
```

```
  24:                 End If
```

```
  25:             Next
```

```
  26:             ' Apply all removes
```

```
  27:             For Each Item In itemsToRemove
```

```
  28:                 targetItems.Remove(Item)
```

```
  29:             Next
```

```
  30:             ' Dispose Timer
```

```
  31:             Monitor.Exit(o)
```

```
  32:         End If
```

```
  33:     End Sub
```

```
  34: 
```

```
  35: End Module
```

You need to remember to lock the object while you sync. This is to allow your threading to take place without incident. The nitty gritty is just a case of comparing the two lists and building a list of changes to make and then removing them :)

Technorati Tags: [.NET](http://technorati.com/tags/.NET)
