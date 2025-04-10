---
title: Scott Guthrie in Glasgow
description: Join Scott Guthrie in Glasgow as he unveils the latest in Visual Studio 2010, Silverlight 4, and Windows Phone 7. Discover key insights and innovations!
ResourceId: JkUaXsGbwTq
ResourceType: blog
ResourceContentOrigin: Human
ResourceImport: true
ResourceImportId: 58
ResourceImportSource: Wordpress
ResourceImportOriginalSource: GeeksWithBlogs
date: 2010-03-29
weight: 1000
creator: Martin Hinshelwood
layout: blog
resourceTypes: blog
slug: scott-guthrie-in-glasgow
aliases:
- /blog/scott-guthrie-in-glasgow
- /scott-guthrie-in-glasgow
- /resources/JkUaXsGbwTq
- /resources/blog/scott-guthrie-in-glasgow
aliasesArchive:
- /blog/scott-guthrie-in-glasgow
- /scott-guthrie-in-glasgow
- /resources/blog/scott-guthrie-in-glasgow
tags: []
categories: []
preview: metro-visual-studio-2010-128-link-2-1.png

---
![redshirt[1]](images/ScottGuthrieinGlagsow_8765-redshirt1_-3-2.jpg)Last week Scott Guthrie was in Glasgow for his new [Guathon](http://developerdeveloperdeveloper.com/guglas/) tour, which was a roaring success. Scott did talks on the new features in Visual Studio 2010, Silverlight 4, ASP.NET MVC 2 and Windows Phone 7. Scott talked from 10am till 4pm, so this can only contain what I remember and I am sure lots of things he discussed just went in one ear and out another, however I have tried to capture at least all of my Ohh’s and Ahh’s.
{ .post-img }

### Visual Studio 2010

Right now you can download and install [Visual Studio 2010 Candidate Release](http://msdn.microsoft.com/en-us/vstudio/dd582936.aspx), but soon we will have the final product in our hands. With it there are some amazing improvements, and not just in the IDE. New versions of VB and C# come out of the box as well as Silverlight 4 and SharePoint 2010 integration.

The new Intellisense features allow inline support for Types and Dictionaries as well as being able to type just part of a name and have the list filter accordingly. Even better, and my personal favourite is one that Scott did not mention, and that is that it is not case sensitive so I can actually find things in C# with its reasonless case sensitivity (Scott, can we please have an option to turn that off.)

Another nice feature is the Routing engine that was created for ASP.NET MVC is now available for WebForms which is good news for all those that just imported the MVC DLL’s to get at it anyway. Another fantastic feature that will need some exploring is the ability to add validation rules to your entities and have them validated automatically on the front end. This removes the need to add your own validators and means that you can control an objects validation rules from a single location, the object. A simple command “GridView.EnableDynamicData(gettype(product))“ will enable this feature on controls.

What was not clear was wither there would be support for this in WPF and WinForms as well. If there is, we can write our validation rules once and use everywhere.

I was disappointed to here that there would be no inbuilt support for the Dynamic Language Runtime (DLR) with VS2010, but I think it will be there for .vNext. Because I have been concentrating on the Visual Studio ALM enhancements to VS2010 I found this section invaluable as I now know at least some of what I missed.

### Silverlight 4

I am not a big fan of Silverlight. There I said it, and I will probably get lynched for it. My big problem with Silverlight is that most of the really useful things I leaned from WPF do not work. I am only going to mention one thing and that is “x:Type”. If you are a WPF developer you will know how much power these 6 little letters provide; the ability to target templates at object types being the the most magical and useful.

But, and this is a massive but, if you are developing applications that MUST run on platforms other than windows then Silverlight is your only choice (well that and Flash, but lets just not go there). And Silverlight has a huge install base as well.. 60% of all internet connected devices have Silverlight. Can Adobe say that?

Even though I am not a fan of it my current project is a Silverlight one. If you start your XAML experience with Silverlight you will not be disappointed and neither will the users of the applications you build. Scott showed us a fantastic application called “Silverface” that is a Silverlight 4 Out of Browser application. I have looked for a link and can’t find one, but true to form, here is a fantastic WPF version called [Fish Bowl](http://www.fishbowlclient.com/) from Microsoft.

### ASP.NET MVC 2

ASP.NET MVC is something I have played with but never used in anger. It is definitely the way forward, but WebForms is not dead yet. there are still circumstances when WebForms are better. If you are starting from greenfield and you are using TDD, then MVC is ultimately the only way you can go.

New in version 2 are Dynamic Scaffolding helpers that let you control how data is presented in the UI from the Entities. Adding validation rules and other options that make sense there can help improve the overall ease of developing the UI.

Also the Microsoft team have heard the cries of help from the larger site builders and provided “Areas” which allow a level of categorisation to your Controllers and Views. These work just like add-ins and have their own folder, but also have sub Controllers and Views. Areas are totally pluggable and can be dropped onto existing sites giving the ability to have boxed products in MVC, although what you do with all of those views is anyone's guess.

They have been listening to everyone again with the new option to encapsulate UI using the Html.Action or Html.ActionRender. This uses the existing  .ascx functionality in ASP.NET to render partial views to the screen in certain areas. While this was possible before, it makes the method official thereby opening it up to the masses and making it a standard.

At the end of the session Scott pulled out some IIS goodies including the [IIS SEO Toolkit](http://www.iis.net/expand/SEOToolkit) which can be used to verify your own site is “good” for search engine consumption. Better yet he suggested that you run it against your friends sites and shame them with how bad they are. note: make sure you have fixed yours first.

### Windows Phone 7 Series

I had already seen the new UI for WP7 and heard about the developer story, but Scott brought that home by building a twitter application in about 20 minutes using the emulator.

Scott’s only mistake was loading [@plip](http://twitter.com/plip)’s tweets into the app…

And guess what, it was written in Silverlight. When Windows Phone 7 launches you will be able to use about 90% of the codebase of your existing Silverlight application and use it on the phone!

There are two downsides to the new WP7 architecture:

1. No, your existing application WILL NOT work without being converted to either a Silverlight or XNA UI.
2. NO, you will not be able to get your applications onto the phone any other way but through the Marketplace.

Do I think these are problems? No, not even slightly. This phone is aimed at consumers who have probably never tried to install an application directly onto a device. There will be support for enterprise apps in the future, but for now enterprises should stay on Windows Phone 6.5.x devices.

### Post Event drinks

At the after event drinks gathering Scott was checking out my HTC HD2 (released to the US this month on T-Mobile) and liked the Windows Phone 6.5.5 build I have on it. We discussed why Microsoft were not going to allow Windows Phone 7 Series onto it with my understanding being that it had 5 buttons and not 3, while Scott was sure that there was more to it from a hardware standpoint. I think he is right, and although the HTC HD2 has a DX9 compatible processor, it was never built with WP7 in mind. However, as if by magic Saturday brought fantastic news for all those that have already bought an HD2:

> Yes, this _appears_ to be Windows Phone 7 running on a HTC HD2. The HD2 itself [won't](http://www.coolsmartphone.com/news5567.html) be getting an official upgrade to Windows Phone 7 Series, so all eyes are on the ROM chefs at the moment. The rather massive photos have been posted by [Tom Codon](http://htcpedia.com/forum/showthread.php?t=2381) on [HTCPedia](http://htcpedia.com/forum/showthread.php?t=2381) and they've apparently got WiFi, GPS, Bluetooth and other bits working. The ROM isn't online yet but according to the post there's a beta version coming soon.  
> **Leigh Geary** - [http://www.coolsmartphone.com/news5648.html](http://www.coolsmartphone.com/news5648.html "http://www.coolsmartphone.com/news5648.html")

What _was_ Scott working on on his flight back to the US? ![Tongue out](images/ScottGuthrieinGlagsow_8765-wlEmoticon-tongueout_2-1-3.png)
{ .post-img }

Follow: [@CAMURPHY](http://twitter.com/CAMURPHY "http://twitter.com/CAMURPHY"), [@ColinMackay](http://twitter.com/ColinMackay "http://twitter.com/ColinMackay"), [@plip](http://twitter.com/plip "http://twitter.com/plip") and of course [@ScottGu](http://twitter.com/ScottGu)

Technorati Tags: [.NET](http://technorati.com/tags/.NET) [VS 2010](http://technorati.com/tags/VS+2010) [WP7](http://technorati.com/tags/WP7) [WPF](http://technorati.com/tags/WPF) [Silverlight](http://technorati.com/tags/Silverlight)
