---
id: "395"
title: "TFS Speed Problems"
date: "2007-05-28"
coverImage: "nakedalm-logo-128-link-1-1.png"
author: "MrHinsh"
type: blog
slug: "tfs-speed-problems"
---

I am finding a lot of people who are having problems with the speed of Team Foundation Server! I have to say, that I have had none of these problems and I use both a locally hosted team server and [CodePlex](http://www.codeplex.com "CodePlex") hosted projects. I do have some users in the office who have a very slow connection to [Team Foundation Server](http://msdn2.microsoft.com/en-us/teamsystem/aa718934.aspx "Team Foundation Server"), but they are on a remote network and use a 2mb link to the main network, so I am not surprised by this.

If you are having problems with the speed or responsiveness of your team server there are a couple of things you can try!

Ping: do a "ping -n 20" from the command line to see if there are any problems connecting to your server over a longer time than 4 pings. On a local network you should get an average of 0 to 1 ms ping time with a max of 4-8 ms depending on the size of your network. If you are getting more than this you need to check with your infrastructure team and see if there is something they can do..

Server Spec: I think that I am spoiled as my server speck is a lot more than the min for [Team Foundation Server](http://msdn2.microsoft.com/en-us/teamsystem/aa718934.aspx "Team Foundation Server"). This was not deliberate, but the minimum spec I can get from my company for a dedicated server is dual xeon processors and 8gb of RAM. The RAM is way above spec but this helps when many people hit the team server at the same time, and I have a dual server installation with the same spec on both servers.

I can only guess what the [CodePlex](http://www.codeplex.com "CodePlex") servers spec's are, but I am sure that they are beefy.

If you have a slow team server, check the network and then check the performance spec's on your server and see where the bottle neck is...

**Do you have a slow team server?**

Technorati Tags: [ALM](http://technorati.com/tags/ALM)
