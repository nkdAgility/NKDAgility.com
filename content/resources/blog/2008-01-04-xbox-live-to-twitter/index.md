---
id: "271"
title: "Xbox Live To Twitter"
date: "2008-01-04"
categories: 
  - "me"
tags: 
  - "xbox"
coverImage: "metro-xbox-360-link-1-1.png"
author: "MrHinsh"
type: "post"
slug: "xbox-live-to-twitter"
---

I had been trying to find an application that provided updates to twitter from my Xbox. There is such an application written by [Duncan Mackenzie](http://duncanmackenzie.net/blog/connect-your-xbox-360-gamertag-to-twitter/default.aspx), but I could not get it to work. I tried everything and ended up decompiling the application to see what was wrong. Well, it seamed that the guts of the application was missing! The source code has all of the UI elements, but none of the bit to do the updates.

I tested the web service and it worked, so the only thing to do (Duncan has not updated the application since May 2007) was to write my own version. As I did not have access to Xbox Live data directly, I have leveraged Duncan's web service and only created the front end.

You can [download the application](http://www.codeplex.com/XboxLiveStatus/Release/ProjectReleases.aspx) from [CodePlex](http://www.codeplex.com "CodePlex") along with all the [source code](http://www.codeplex.com/XboxLiveStatus).

if you have any problems, please create or vote for Issues via the interface![smile_regular](images/smile_regular-2-2.gif).

Technorati Tags: [RDdotNet](http://technorati.com/tags/RDdotNet) [Xbox](http://technorati.com/tags/Xbox)


