---
title: Enable Feedback support for users in Team Foundation Server 2012
description: Learn how to configure email and permissions in Team Foundation Server 2012 to enable user feedback, including group setup and access control for internal and external users.
ResourceId: 7WxWYWI5PI2
ResourceType: blog
ResourceContentOrigin: Human
ResourceImport: true
ResourceImportId: 9494
ResourceImportSource: Wordpress
ResourceImportOriginalSource: Wordpress
date: 2013-05-21
weight: 1000
creator: Martin Hinshelwood
layout: blog
resourceTypes: blog
slug: enable-feedback-support-for-users-in-team-foundation-server-2012
aliases:
- /resources/7WxWYWI5PI2
aliasesArchive:
- /blog/enable-feedback-support-for-users-in-team-foundation-server-2012
- /enable-feedback-support-for-users-in-team-foundation-server-2012
- /resources/blog/enable-feedback-support-for-users-in-team-foundation-server-2012
tags:
- Install and Configuration
categories:
- Uncategorized
Watermarks:
  description: 2025-05-13T15:06:23Z
concepts: []

---
The focus of this article is to show you how to easily enable feedback support for users in Team Foundation Server 2012 with a few simple permissions. This works great with Team Foundation Server and even better with Team Foundation Service.

Team Foundation Server works better because you have an on-premise installed on TFS 2012 therefore, those who you want to grant access require an Active Directory account in your domain. All of your internal users already have this, but you can also give VPN access for externals. However, this does not work for many publicly shippable applications. If however you are using Team Foundation Service from [http://tfs.visualstudio.com](http://tfs.visualstudio.com) all you need is a user Live ID and permission.

![image](images/image.png "image")  
{ .post-img }
Figure: Providing Feedback on an application

There are a couple of things that you need to configure in order to enable feedback support for users in Team Foundation Server 2012. Although these may seem trivial they are a little hidden:

1. **DONE Configure email settings to enable feedback support**
2. **DONE Configure permissions to enable feedback support**

With these complete you are good to go!

## Configure email settings to enable feedback support

The first thing to configure is the email settings in order to make sure that we can both use the service and that email in fact does get sent. If you do not have email settings configured then you should see a bunch of warning messages when you try to use features that depend on them.

![Figure: TF400264: Team Foundation Server is not configured to send email notifications ](images/image1.png "Figure: TF400264: Team Foundation Server is not configured to send email notifications ")  
{ .post-img }
Figure: TF400264: Team Foundation Server is not configured to send email notifications

If this is the case then you need to go into your Team Foundation Server Administration Console on the server and configure the email settings. This will require a mail server to actually send the mail to be prepared with specified details.

Note: Many mail servers restrict the ‘from’ address for sending mail and this can mean that emails don’t send when you think they will be. If an email is not being sent, then check the event log on the server for errors.

![Figure: Enter the mail settings to enable feedback support](images/image2.png "Figure: Enter the mail settings to enable feedback support")  
{ .post-img }
Figure: Enter the mail settings to enable feedback support

Once you have completed and saved this, the email sending feature will work not only for feedback, but also for the built in alerts manager for teams…

## Configure permissions to enable feedback support

The permissions are a bit more complex and may be much more specific to the project. You need two very specific permissions sets, one is obvious and the other… well… not so much.

Note: You do not need any version of Visual Studio nor a CAL for TFS to provide feedback. You simply need to request it.

![Figure: Create a group to to enable feedback support](images/image3.png "Figure: Create a group to to enable feedback support")  
{ .post-img }
Figure: Create a group to enable feedback support

Now, we need to create a group that we can add folks to without having to make them “Contributors”. Unfortunately, “Contributors” get access to our Source Code and builds by default so we really want to lock it down, even if it is just a little.

![Figure: You need ‘create test runs’ to enable feedback support](images/image4.png "Figure: You need ‘create test runs’ to enable feedback support")  
{ .post-img }
Figure: You need ‘create test runs’ to enable feedback support

As mentioned earlier, the non-obvious permission is required to provide feedback. For some reason you need to have the ‘create test runs’ permission at the root of the project. Don’t ask…

![Figure: Join new group to Readers to enable feedback support](images/image5.png "Figure: Join new group to Readers to enable feedback support")  
{ .post-img }
Figure: Join new group to Readers to enable feedback support

This new group should only be “Readers” so that we can grant them access to only what is needed to get feedback submitted. What we have now will allow them to view things within the Team Project but not to edit. Now we need to add explicit permission to our root “Area” node.

![Figure: Edit the security for the root area](images/image6.png "Figure: Edit the security for the root area")  
{ .post-img }
Figure: Edit the security for the root area

Getting into the security settings for an “Area” is simple but a little obscure. There is a little node that only appears when you hover over the node which allows you to get into the Security settings.

![Figure: Add the ‘Feedback Provider’ group](images/SNAGHTML1b65f95.png "Figure: Add the ‘Feedback Provider’ group")  
{ .post-img }
Figure: Add the ‘Feedback Provider’ group

Simply type or select the ‘Feedback Provider’ group from the drop down list and save the changes.

![Figure: Allow edit work items in this node for ‘Feedback Provider’](images/image7.png "Figure: Allow edit work items in this node for ‘Feedback Provider’")  
{ .post-img }
Figure: Allow edit work items in this node for ‘Feedback Provider’

Now we have added permission only to allow the editing of work items. Unfortunately, this current state means that any users in this group can edit work items and requires a CAL.

Make sure that you also add the appropriate users to the ‘Limited” access level which is found in the administration control panel for the collection.

![Figure: Add feedback users to the Limited access level](images/image8.png "Figure: Add feedback users to the Limited access level")  
{ .post-img }
Figure: Add feedback users to the Limited access level

And now everyone in that group has access.

## Conclusion

The feedback features are incredibly useful and require only minimal configuration. There is no excuse for not having tractability from Feedback through your Backlog to the detail of implementation, allowing you to revisit the feedback when complete.

With the added bonus of zero licensing requirements in order to provide feedback, we can safely roll out the Feedback Client internally to whoever is needed.

**Warning: always back up your data before attempting any changes.**

_Originally published at Where Technology Meets Teamwork by [Martin Hinshelwood](http://blog.hinshelwood.com/about), Senior ALM Consultant. ([source](http://blog.nwcadence.com/enable-feedback-support-for-users-in-team-foundation-server-2012/))_
