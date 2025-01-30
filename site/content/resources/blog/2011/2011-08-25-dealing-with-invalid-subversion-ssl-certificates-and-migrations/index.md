---
title: 'Subversion to TFS 2010: Dealing with invalid Subversion SSL certificates and migrations'
description: Learn how to tackle invalid Subversion SSL certificates during your migration to TFS 2010. Overcome common errors and streamline your version control process!
ResourceId: OqcEk7HmSwT
date: 2011-08-25
creator: Martin Hinshelwood
id: "3736"
layout: blog
resourceTypes: blog
slug: dealing-with-invalid-subversion-ssl-certificates-and-migrations
aliases:
- /blog/dealing-with-invalid-subversion-ssl-certificates-and-migrations
- /dealing-with-invalid-subversion-ssl-certificates-and-migrations
- /subversion-to-tfs-2010--dealing-with-invalid-subversion-ssl-certificates-and-migrations
- /blog/subversion-to-tfs-2010--dealing-with-invalid-subversion-ssl-certificates-and-migrations
- /resources/OqcEk7HmSwT
tags:
- nwcadence
- ssl
- svn
- tfs
- tfs2010
- tools
- version-control

---
![subversion](images/subversion-7-7.png "subversion")
{ .post-img }

Migrating data from SVN to TFS can be both a timely and a costly business. I was trying out the two tools [TFS Integration Platform](http://tfsintegration.codeplex.com/) & [Timely Migration](http://www.timelymigration.com/) but I ran into what looked like the same problem in both if them.

- Acknowledgement: Thorsten Dralle - Thorsten helped me figure out what the heck was going on when I could not connect

---

Although I do have permission I can’t get the tools to talk and load from Subversion with the following effect / error messages:

- **TFS Integration Platform  
   **  
   ![image](images/image1-4-4.png "image")  
  { .post-img }
  **Figure: Unable to validate the URL  
   **
- **Timely Migration  
   **  
   And I am now very confused as I have tried Timely Migrations tool as well and it has an error that is similar enough to not be coincidence.
  ![clip_image004](images/clip_image004-1-1.jpg "clip_image004")
  { .post-img }
  **Figure: Also unable to validate the repository URL  
   **
- **Internet Explorer  
   **  
   I will go back to the admins and make sure that everything is correct, but I am not sure if they are going to have any other advice.  
   ![image](images/image3-6-6.png "image")  
  { .post-img }
  **Figure: Unable to validate the certificate. (From an internal server)  
   **  
   I have even looked at making sure that the url is correct and putting it into the browser results in a list of the folders which looks right to me.
  ![clip_image006](images/clip_image006-2-2.jpg "clip_image006")
  { .post-img }
  **Figure: This is expected  
   **
- **SmartSVN**
  This is very odd and I am having some trouble figuring it out. I can access SVN through SmartSVN.

      ![clip_image007](images/clip_image007-3-3.jpg "clip_image007")

  { .post-img }
  **Figure: SmartSVN worked just fine after I accepted the fingerprint**

So, what is the problem?

Well, Thorsten figured it out that the invalid digital certificate used for Subversion is blocking the ability for the tool to access it and throwing up very misleading error messages. If you run the standard SVN tool against that repository and try to access any of the files you will be asked what to do about the problem:

```
svn.exe co https://host/PathToYourRepo c:somethinglocalfolder
```

This command will download the latest sources locally if you let it run but it will also, If there is a certificate mismatch / error the command line tool will ask you what to do.

![image](images/image2-5-5.png "image")
{ .post-img }

**Figure: Options for accepting certificate**

Typically you have three options:

- Accept Temporarily

- **Accept forever**

- Reject

If you select “**_(p)ermenantly_**” you will then be able to run the migration tools successfully. You will need to do this for every Subversion Repository you want to migrate from. Or, you can fix the certificate or just remove it.
