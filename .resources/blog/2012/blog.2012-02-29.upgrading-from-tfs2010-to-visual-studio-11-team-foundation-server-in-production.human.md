---
title: Upgrading from TFS2010 to Visual Studio 2012 Team Foundation Server in production
description: Step-by-step guide to upgrading from TFS 2010 to Visual Studio 2012 Team Foundation Server, including prerequisites, SQL updates, configuration, and troubleshooting tips.
ResourceId: _KGEsIMh-nJ
ResourceType: blog
ResourceContentOrigin: Human
ResourceImport: true
ResourceImportId: 4709
ResourceImportSource: Wordpress
ResourceImportOriginalSource: Wordpress
date: 2012-02-29
weight: 1000
creator: Martin Hinshelwood
layout: blog
resourceTypes: blog
slug: upgrading-from-tfs2010-to-visual-studio-11-team-foundation-server-in-production
aliases:
- /resources/_KGEsIMh-nJ
aliasesArchive:
- /blog/upgrading-from-tfs2010-to-visual-studio-11-team-foundation-server-in-production
- /upgrading-from-tfs2010-to-visual-studio-11-team-foundation-server-in-production
- /upgrading-from-tfs2010-to-visual-studio-2012-team-foundation-server-in-production
- /blog/upgrading-from-tfs2010-to-visual-studio-2012-team-foundation-server-in-production
- /resources/blog/upgrading-from-tfs2010-to-visual-studio-11-team-foundation-server-in-production
tags:
- Install and Configuration
- Software Development
- Windows
- System Configuration
categories:
- Uncategorized
Watermarks:
  description: 2025-05-13T15:09:16Z
concepts: []

---
Upgrading from Visual Studio 2010 Team Foundation Server to Visual Studio 11 Team Foundation Server beta is very easy and as we have seen, [fully supported in production](http://blog.nwcadence.com/go-live-with-visual-studio-11-beta-3/). Today I got the new bits and I an going to upgrade our Northwest Cadence production server.

You need a couple of things before you get started:

- **Admin on your Team Foundation Server environments**  
   That includes your data tier and app tiers
- **Your TFS account details**  
   This means TFSService & TFSReports accounts at the least.
- **Download Updates**

- SQL Server 2008 R2 SP1 (Windows Update)
- [SQL Server 2008 R2 SP1 CU1 (Download here)](http://hotfixv4.microsoft.com/SQL%20Server%202008%20R2/sp1/SQLServer2008R2_SP1_CU1_2544793_10_50_27/10.50.2769.0/free/434892_intl_x64_zip.exe "http://hotfixv4.microsoft.com/SQL%20Server%202008%20R2/sp1/SQLServer2008R2_SP1_CU1_2544793_10_50_27/10.50.2769.0/free/434892_intl_x64_zip.exe")

Here is my TODO list for this install:

- **DONE - Unpacking Visual Studio 11 Team Foundation Server**
- **DONE -** **Uninstalling Visual Studio 2010 Team Foundation Server**
- **DONE -** **Installing Visual Studio 11 Team Foundation Server**
- **DONE -** **Upgrading SQL Server 2008 R2 to SQL Server 2008 R2 SP1**
- **DONE -** **Apply SQL Server 2008 R2 SP1 CU1**
- **DONE -** **Upgrading to Visual Studio 11 Team Foundation Server**
- **DONE -** **Test your environment**
- **Email Everyone in your company to go check**

Once you have those things you can move on to the good bits:

1.  **Unpacking Visual Studio 11 Team Foundation Server**
    This is one of the longest processes as you need to unpack over 1gb of data from your ISO. I use [WinRAR](http://rarlabs.com), but you can use anything you like.

        [![image](images/image_thumb10-1-1.png "image")](http://blog.hinshelwood.com/files/2012/02/image10.png)

    { .post-img }
    **Figure: Unpacking Visual Studio 11 Team Foundation Server ISO**
    Yes, you heard me right, its only a 1GB iso for TFS11. The team has done some amazing work pairing down the install (It was over 2GB in 2010.)

2.  **Uninstalling Visual Studio 2010 Team Foundation Server**
    When you run the install on a box that has Visual Studio 2010 Team Foundation Server you will need to uninstall it first. But don’t worry, all you data will be left alone.

        [![image](images/image_thumb11-2-2.png "image")](http://blog.hinshelwood.com/files/2012/02/image11.png)

    { .post-img }
    **Figure: You need to uninstall Visual Studio 2010 Team Foundation Server**
    This is an easy process and is completed in a couple of minutes.

        [![image](images/image_thumb12-3-3.png "image")](http://blog.hinshelwood.com/files/2012/02/image12.png)

    { .post-img }
    **Figure: Its an easy thing to Uninstall**
    Once it is off you computer you can start with the Visual Studio 11 Team Foundation Server upgrade.

3.  **Installing Visual Studio 11 Team Foundation Server**
    Installing TFS 11 is quick and easy. It takes only a few minutes, although you may need to make sure that you have the latest updates and service packs for all of the affected products as I would always recommend that you do.

        [![image](images/image_thumb13-4-4.png "image")](http://blog.hinshelwood.com/files/2012/02/image13.png)

    { .post-img }
    **Figure: Accepting the Visual Studio 11 Team Foundation Server**
    You will see that even the Install has become cleaner and less cluttered. This may change when for the release, but it looks pretty good.

        [![image](images/image_thumb14-5-5.png "image")](http://blog.hinshelwood.com/files/2012/02/image14.png)

    { .post-img }
    **Figure: Only a few customisation points  
     **  
     The only customization is the folder that you are installing to and I ALWAYS use the default.
    [![image](images/image_thumb15-6-6.png "image")](http://blog.hinshelwood.com/files/2012/02/image15.png)
    { .post-img }
    **Figure: make sure that you get any updates**
    This is checked by default, but it is always good to get all of the updates before you start.

        [![image](images/image_thumb16-7-7.png "image")](http://blog.hinshelwood.com/files/2012/02/image16.png)

    { .post-img }
    **Figure: Upgrading to .NET Framework 4.5 Beta  
     **  
     Now the install only takes a few minutes, but .NET 4.5 takes up most of that.
    [![image](images/image_thumb17-8-8.png "image")](http://blog.hinshelwood.com/files/2012/02/image17.png)
    { .post-img }
    **Figure: As usual, .NET installs require a restart**
    Always prep the machines with .NET prior to starting if you can. If you do that, you are doing this in minutes.

        [![image](images/image_thumb18-9-9.png "image")](http://blog.hinshelwood.com/files/2012/02/image18.png)

    { .post-img }
    **Figure: After a reboot the install kicks of again**
    After that the install automatically starts after you log in and carries on.

        [![image](images/image_thumb19-10-10.png "image")](http://blog.hinshelwood.com/files/2012/02/image19.png)

    { .post-img }
    **Figure: After the install the the configuration window will pop**
    Now that you have everything installed you need to begin the configuration. In TFS 2010 you had to stop here and install the Service Pack but as we just got these bits there is no SP, so … wooohooo..Done.

4.  **Upgrading to Visual Studio 11 Team Foundation Server**
    But not really. Now we need to get to the real hard stuff. I am upgrading our current TFS 2010 server, so I need to select the Upgrade Wizard. There are many other options but I don’t need them for now.

        [![image](images/image_thumb20-11-11.png "image")](http://blog.hinshelwood.com/files/2012/02/image20.png)

    { .post-img }
    **Figure: Select “Upgrade | Start Wizard” to get going**
    Once you get into the wizard you will only see the options and be lead through the story that you want. Make sure that you select the correct story, and often the “Advanced” wizard is the most appropriate.

        [![image](images/image_thumb21-12-12.png "image")](http://blog.hinshelwood.com/files/2012/02/image21.png)

    { .post-img }
    **Figure: The only options for Upgrade is to select the database**
    You need access to the database server for the next bit.The upgrade wizard is going to upgrade the schema of your server and you need “sysadmin” in order to do that. I forgot and had to get [Steven Borg](http://blog.nwcadence.com/author/stevenborg/) to add me.

        [![image](images/image_thumb22-13-13.png "image")](http://blog.hinshelwood.com/files/2012/02/image22.png)

    { .post-img }
    **Figure: Select your TFS 2010 database**
    The wizard will check to make sure that you have a data base that you can import. It will list all of your DB’s but you can only do one through the interface. There is a command line for upgrading subsequent databases if you have more than one configuration database.

        note: You only need to do this ONCE per TFS Instance and not per team Project Collection. It will upgrade all of your collections.

        You then need to specify the TFS Service account to use. Now I forgot this as well and had to ask [Shad Timm](https://twitter.com/#!/shadtimm) (get a blog Shad) to get the password , which he provided with the speed that only Shad can.

        [![image](images/image_thumb23-14-14.png "image")](http://blog.hinshelwood.com/files/2012/02/image23.png)

    { .post-img }
    **Figure: Configure the TFS Service Account**
    I have very few circumstances where anything other then NTLM is not appropriate and as we have a separate data tier and app tier I have to use AD credentials. To be honest every time that I have used “network service” I have run into many problems. Just suck it up and use AD Credentials.

        [![image](images/image_thumb24-15-15.png "image")](http://blog.hinshelwood.com/files/2012/02/image24.png)

    { .post-img }
    **Figure: We are going to configure reporting**
    If you have TFS basic (or express) then you don’t get reporting, but this is an enterprise solution that has both reporting services and analysis services to configure.

        [![image](images/image_thumb25-16-16.png "image")](http://blog.hinshelwood.com/files/2012/02/image25.png)

    { .post-img }
    **Figure: Select the server that is running Reporting Services**
    In my case Reporting Services runs on the same server as the App Tier and it prepopulates the data. Remember that we already selected a TFS 2010 configuration database, so everything except the accounts is pre populated.

        [![image](images/image_thumb26-17-17.png "image")](http://blog.hinshelwood.com/files/2012/02/image26.png)

    { .post-img }
    **Figure: Your reports database might not be on the same environment as Reporting Services**
    You need to select your warehouse, but enter your server and it will find it.

        [![image](images/image_thumb27-18-18.png "image")](http://blog.hinshelwood.com/files/2012/02/image27.png)

    { .post-img }
    **Figure: Select your Analysis Services database**
    My Analysis Services database is sitting on my Data Tier so I have to enter that server name here. I love the “Test” feature on the pages so that you make less mistakes.

        [![image](images/image_thumb28-19-19.png "image")](http://blog.hinshelwood.com/files/2012/02/image28.png)

    { .post-img }
    Figure: Enter your TFS Reports  Account
    [![image](images/image_thumb29-20-20.png "image")](http://blog.hinshelwood.com/files/2012/02/image29.png)
    { .post-img }
    **Figure: Setting up SharePoint is also easy**
    We use an Enterprise SharePoint farm so I will be leaving it configured as is.

        [![image](images/image_thumb30-21-21.png "image")](http://blog.hinshelwood.com/files/2012/02/image30.png)

    { .post-img }
    **Figure: Review your setting**
    If you have not done a TFS upgrade since 2008 you will love the readiness checks that the TFS team added. It looks at all of the things that it can to make sure that we catch any errors NOW, before we go any further.

        [![image](images/image_thumb31-22-22.png "image")](http://blog.hinshelwood.com/files/2012/02/image31.png)

    { .post-img }
    **Figure: All of the readiness checks then run**
    The readiness checks run…. and…

        [![image](images/image_thumb32-23-23.png "image")](http://blog.hinshelwood.com/files/2012/02/image32.png)

    { .post-img }
    **Figure: F\*ck, I need to update SQL Server.**
    My SQL server does not have SP1 or the required CU…. let me go do that….

        WARNING: While I can get SP1 from Windows Update I need to jump though a bunch of hoops in order to get the CU, so:- [SQL Server 2008 R2 SP1 CU1 Download](http://hotfixv4.microsoft.com/SQL%20Server%202008%20R2/sp1/SQLServer2008R2_SP1_CU1_2544793_10_50_27/10.50.2769.0/free/434892_intl_x64_zip.exe "http://hotfixv4.microsoft.com/SQL%20Server%202008%20R2/sp1/SQLServer2008R2_SP1_CU1_2544793_10_50_27/10.50.2769.0/free/434892_intl_x64_zip.exe")

        [![image](images/image_thumb33-24-24.png "image")](http://blog.hinshelwood.com/files/2012/02/image33.png)

    { .post-img }
    **Figure: You can just rerun the checks once you have changed something**
    Now that you have fixed the problem, you just need to rerun the Readiness Checks to before you can Configure your server.
    [![SNAGHTMLf0fc8](images/SNAGHTMLf0fc8_thumb-31-31.png "SNAGHTMLf0fc8")](http://blog.hinshelwood.com/files/2012/02/SNAGHTMLf0fc8.png)
    { .post-img }
    **Figure: If you have express you get upgraded  
     **  
     [![image](images/image_thumb34-25-25.png "image")](http://blog.hinshelwood.com/files/2012/02/image34.png)  
    { .post-img }
    **Figure: Depending on your hardware the upgrade may take some time**
    Some updated take longer than other, but it really depends on your feature usage and hardware.

        [![image](images/image_thumb35-26-26.png "image")](http://blog.hinshelwood.com/files/2012/02/image35.png)

    { .post-img }
    **Figure: All of the collections are upgraded**
    Each collection is upgraded individually after the configuration database has been completed and these again depend on the size and complexity. In this case the first collection has very little data and was upgraded quickly, but the second one is the main collection so will take a little longer.

        [![image](images/image_thumb36-27-27.png "image")](http://blog.hinshelwood.com/files/2012/02/image36.png)

    { .post-img }
    **Figure: Warning for Lab Management**

    ````
    [2012-02-29 19:55:43Z][Warning] Team Foundation Server could not tear down the existing deployment rigs.
    Delete the Visual Studio 2010 Team Foundation Build Agents associated with your environments manually using Team Foundation Server Administrator Console.
    Exception Details:
    TF259046: Team Foundation Server could not complete the operation because of an internal error. Try the operation again.
    If the problem persists, contact your system administrator.

        ```

        **Figure: Warning message for Lab Management integrate collections**

        This is just to let me know that it did not do something against the Lab environment that is setup. I am going to leave it for now, but I will tell Shad that it happened ![Smile](images/wlEmoticon-smile3-32-32.png)

    { .post-img }
    [![image](images/image_thumb37-28-28.png "image")](http://blog.hinshelwood.com/files/2012/02/image37.png)
    { .post-img }
    **Figure: SharePoint config failed**
    It looks like the existing configuration settings for SharePoint were not honoured in the beta. So it is worth noting that you will need to manually configure the if you get this error.

        [![image](images/image_thumb38-29-29.png "image")](http://blog.hinshelwood.com/files/2012/02/image38.png)

    { .post-img }
    **Figure: SharePoint is actually OK**
    It looks like it is just a false message. When I looked in the admin tool all was well.
    ````

### DONE

You will want to do lots of exercising of the features to make sure that everything works so we only have a few tasks left:

[![image](images/image_thumb39-30-30.png "image")](http://blog.hinshelwood.com/files/2012/02/image39.png)  
{ .post-img }
**Figure: All looks well from an admin  
**

Remember that there is [Go-Live for Visual Studio 11 Team Foundation Server](http://blog.nwcadence.com/go-live-with-visual-studio-11-beta-3/)!

Go on… be a kid again!
