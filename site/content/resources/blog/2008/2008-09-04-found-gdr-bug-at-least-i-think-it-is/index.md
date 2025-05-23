---
title: 'Found GDR Bug: At least I think it is.'
description: Describes a bug in GDR and Data Dude where SQL views using derived tables cause unresolved reference errors, impacting database project development and validation.
ResourceId: LjS_IaGaE9R
ResourceType: blog
ResourceContentOrigin: Human
ResourceImport: true
ResourceImportId: 198
ResourceImportSource: Wordpress
ResourceImportOriginalSource: GeeksWithBlogs
date: 2008-09-04
weight: 1000
creator: Martin Hinshelwood
layout: blog
resourceTypes: blog
slug: found-gdr-bug-at-least-i-think-it-is
aliases:
- /resources/blog/found-gdr-bug-at-least-i-think-it-is.
- /resources/LjS_IaGaE9R
aliasesArchive:
- /blog/found-gdr-bug-at-least-i-think-it-is
- /found-gdr-bug-at-least-i-think-it-is
- /found-gdr-bug--at-least-i-think-it-is-
- /blog/found-gdr-bug--at-least-i-think-it-is-
- /resources/blog/found-gdr-bug-at-least-i-think-it-is
- /resources/blog/found-gdr-bug-at-least-i-think-it-is.
tags: []
preview: metro-aggreko-128-link-1-1.png
categories:
- Uncategorized
Watermarks:
  description: 2025-05-13T16:23:22Z
concepts: []

---
This is not isolated to GDR, but seams to exist in Data Dude as well. If you create the following SQL:

```
   1: CREATE VIEW [dbo].[v_SomeView] AS
```

```
   2: SELECT    [BH].[Col1],
```

```
   3:         [BH].[Col2],
```

```
   4:         [BH].[Col3],
```

```
   5:         [BH].[Col4],
```

```
   6:         [BH].[Col5],
```

```
   7:         CASE WHEN [BHPP].[OtherCol1] IS NULL THEN -1 ELSE 1 END As [Col6],
```

```
   8:         CASE WHEN [BHPP].[OtherCol1] IS NULL THEN 'Not Applicable' ELSE 'PowerPack' END As [Col7],
```

```
   9:         CASE WHEN [BHPP].[OtherCol1] IS NULL THEN [BH].[Col5] ELSE [BHPP].[OtherCol2] END As [Col8]
```

```
  10: FROM    [dbo].[Table1] as [BH]
```

```
  11:         LEFT JOIN     (SELECT [OtherCol1], [OtherCol2], [OtherCol3]
```

```
  12:                     FROM    [$(CMD)].[dbo].[Table2]
```

```
  13:                     WHERE    [OtherCol1] <> -1) as [BHPP]
```

```
  14:             ON [BH].[Col2] = [BHPP].[Col2]
```

And add it to your Database project, but using proper table names :) You will get the following error for every use of \[BHPP\]:

> Error    13    SR0029 : Microsoft.Validation : View: \[dbo\].\[v_SomeView\] contains an unresolved reference to an object. Either the object does not exist or the reference is ambiguous because it could refer to any of the following objects:....

This is a show stopper for us as we can't (without good cause) be creating more views just to do a derived table...

I have submitted a [Bug](https://connect.microsoft.com/VisualStudio/feedback/ViewFeedback.aspx?FeedbackID=366059), so vote as you like, but please vote...

Bug: [GDR - derived tables](https://connect.microsoft.com/VisualStudio/feedback/ViewFeedback.aspx?FeedbackID=366059)

Technorati Tags: [ALM](http://technorati.com/tags/ALM)
