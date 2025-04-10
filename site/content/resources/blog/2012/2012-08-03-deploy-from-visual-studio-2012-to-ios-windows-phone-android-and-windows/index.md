---
title: Deploy from Visual Studio 2012 to iOS, Windows Phone, Android and Windows
description: Discover how to deploy apps from Visual Studio 2012 to multiple platforms like iOS, Android, and Windows, streamlining your development process effectively.
ResourceId: n5gPXqsSzYn
ResourceType: blog
ResourceContentOrigin: Human
ResourceImport: true
ResourceImportId: 6950
ResourceImportSource: Wordpress
ResourceImportOriginalSource: Wordpress
date: 2012-08-03
weight: 690
creator: Martin Hinshelwood
layout: blog
resourceTypes: blog
slug: deploy-from-visual-studio-2012-to-ios-windows-phone-android-and-windows
aliases:
- /blog/deploy-from-visual-studio-2012-to-ios-windows-phone-android-and-windows
- /deploy-from-visual-studio-2012-to-ios-windows-phone-android-and-windows
- /deploy-from-visual-studio-2012-to-ios,-windows-phone,-android-and-windows
- /blog/deploy-from-visual-studio-2012-to-ios,-windows-phone,-android-and-windows
- /resources/n5gPXqsSzYn
- /deploy-from-visual-studio-2012-to-ios--windows-phone--android-and-windows
- /blog/deploy-from-visual-studio-2012-to-ios--windows-phone--android-and-windows
- /resources/blog/deploy-from-visual-studio-2012-to-ios-windows-phone-android-and-windows
aliasesArchive:
- /blog/deploy-from-visual-studio-2012-to-ios-windows-phone-android-and-windows
- /deploy-from-visual-studio-2012-to-ios-windows-phone-android-and-windows
- /deploy-from-visual-studio-2012-to-ios,-windows-phone,-android-and-windows
- /blog/deploy-from-visual-studio-2012-to-ios,-windows-phone,-android-and-windows
- /deploy-from-visual-studio-2012-to-ios--windows-phone--android-and-windows
- /blog/deploy-from-visual-studio-2012-to-ios--windows-phone--android-and-windows
- /resources/blog/deploy-from-visual-studio-2012-to-ios-windows-phone-android-and-windows
tags:
- Software Development
- Application Lifecycle Management
- Working Software
- Windows
- Pragmatic Thinking
- Product Delivery
categories: []
preview: nakedalm-experts-visual-studio-alm-5-5.png

---
Today I saw a demonstration by [ITR Mobility](http://itr-mobility.com/) of their line of business application support for having one code base, written in C# that can be deployed to practically any platform you like. Does that should like it would be of use to you? Coz it sure as hell sounds like I could use it. I want to build an app… but I want to build in Visual Studio and that would limit me to Windows Phone and I really don’t want to lead Objective C!

[![image](images/image_thumb12-1-1.png "image")](http://blog.hinshelwood.com/files/2012/08/image13.png)
{ .post-img }

This solves that problem and although their marketing concentrates on mobile devices, the demo I saw showed c# running on Android, iOS, Windows and Windows CE and even on a terminal.

There seams to be two main ways they allow you to implement :

- **Generic UI**  
   You can let them handle the UI and define how your application should look in  a generic manor but loose the ability to use that nifty feature that only Android supports.. or…
- **Platform Specific UI  
   **You can code specific UI logic for each platform to take advantage of the differences.  
   [![image](images/image_thumb13-2-2.png "image")](http://blog.hinshelwood.com/files/2012/08/image14.png)  
  { .post-img }
  **Figure: Application Specific UI if you want**

So if you have an application with only a few pages and lots of logic you can have full control, however if you have thousands of views to write across tens of application than you should probably think of using the more generic, but less sexy, approch to ge the job done.

The demo that I saw showed the same application and codebase compiled and running on:

- Windows
- Windows Phone
- iOS
- iPad
- iPhone
- Android
- Linux
- Terminal

That in its self knocked my socks off and allows for a standardisation on a single technology platform for all of your engineers for all of your applications. They also announced that they would support Windows 8 RT and Windows Phone 8 and Visual Studio 2012 within a short time of the release and they have been working with the Product Teams for a while to get that right.

You can code everything using the features provided in Visual Studio, arguably the most powerful and easiest to use IDE; store your source in Team Foundation Server; have your application automatically built using Team Foundation Build; and then have it automatically deployed to the app store of your choice.

[**![image](images/image_thumb14-3-3.png "image")**](http://blog.hinshelwood.com/files/2012/08/image15.png)  
{ .post-img }
**Figure: Building on Mac and deploy to App Store**

From an ALM perspective this gives you a number of capabilities that you did not have before:

- You get to have one set of trained developers who can build for any of your target platforms.
- You now have a holistic build process leveraging a single set of technologies.
- You can trace from a line of code written, to the requirement / bug that elicited that change in one way.
- You can report across all of your teams and see the true effort involved in delivering your software to the customer

http://youtu.be/lbH9rIHyCp4?hd=1

**Figure: Video Overview and Demonstration**

They have added a bunch of nifty framework logic to allow you to have your application running locally on a device, maybe offline, and another user working in a version deployed to Azure with full data synchronisation accross the platfomrs… amasing…

[![image](images/image_thumb15-4-4.png "image")](http://blog.hinshelwood.com/files/2012/08/image16.png)  
{ .post-img }
**Figure: Building code for iOS right in Visual Studio**

If you are a user wanting to build line of business application for your organisation and you cant get agreement on a platform then this is for you. I will be recommending this to any and all of my customers that are building in the mobile space.

This is a demonstration of what can be done in the ALM space to solve a real need for customer and allow them to deliver more value more quickly to their customers.

**Do you build mobile applications? Would this help you?**
