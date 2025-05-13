---
title: 'VSS Converter – Issue: TF60014 & TF60087: Failed to initialise user mapper'
description: Explains how to resolve TF60014 and TF60087 errors in VSSConverter.exe during VSS to TFS import by ensuring mapped users have permissions in the target TFS project.
ResourceId: a2ptmGZFk8P
ResourceType: blog
ResourceContentOrigin: Human
ResourceImport: true
ResourceImportId: 6124
ResourceImportSource: Wordpress
ResourceImportOriginalSource: Wordpress
date: 2012-06-28
weight: 1000
creator: Martin Hinshelwood
layout: blog
resourceTypes: blog
slug: vss-converter-issue-tf60014-tf60087-failed-to-initialise-user-mapper
aliases:
- /resources/blog/vss-converter-issue-tf60014-tf60087-failed-to-initialise-user-mapper
- /resources/a2ptmGZFk8P
aliasesArchive:
- /blog/vss-converter-issue-tf60014-tf60087-failed-to-initialise-user-mapper
- /vss-converter-issue-tf60014-tf60087-failed-to-initialise-user-mapper
- /vss-converter-–-issue--tf60014-&-tf60087--failed-to-initialise-user-mapper
- /blog/vss-converter-–-issue--tf60014-&-tf60087--failed-to-initialise-user-mapper
- /resources/blog/vss-converter-issue-tf60014-tf60087-failed-to-initialise-user-mapper
tags:
- Troubleshooting
categories:
- Uncategorized
preview: metro-problem-icon-2-2.png
Watermarks:
  description: 2025-05-13T15:08:51Z
concepts: []

---
When running a VSS to TFS import using the VSSConverter.exe you may recieve a “TFTF60014: The username domainusername in the user map file c:tempusermap.xml is invalid”.

[![image](images/image_thumb62-1-1.png "image")](http://blog.hinshelwood.com/files/2012/06/image80.png)  
{ .post-img }
**Figure: TF60014 & TF60087: Failed to initialise user mapper**

### Applies to

- VSSConverter.exe
- Visual Studio 2010 Team Foundation Server

### Finding

When you are doing a mapping and you map a user that is valid as far as Active Directory is concerned, but has not been granted permission against the Team Project Collection to which you are doing the import you will receive this message.

### Workaround

Adding the mapped users to the Contributors group on the target server will remove this error.

> Add a further error, or change the wording to make it clear where the user does not exist. First check AD, then check that it can access TFS.  
> \-Suggestion to TFS Team

**Did this deal with your problem?**
