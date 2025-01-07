---
title: Continuous Integration and Continuous Delivery CI CD for Quality
description: Unlock the true potential of CI/CD! Join Martin Hinshelwood as he reveals best practices for Continuous Integration and Delivery to enhance quality and speed.
date: 2024-11-22T07:00:08Z
videoId: IZ-FlBbGaSY
url: /resources/videos/:slug
slug: continuous-integration-and-continuous-delivery-ci-cd-for-quality
aliases:
- /resources/videos/IZ-FlBbGaSY
- /resources/videos/continuous-integration-and-continuous-delivery-ci-cd-for-quality
- /resources/continuous-integration-and-continuous-delivery-ci-cd-for-quality
preview: https://i.ytimg.com/vi/IZ-FlBbGaSY/maxresdefault.jpg
duration: 451
isShort: false
tags:
- Continuous integration
- Continous development
- Continuous delivery
- Agile
- Agile product development
- product development
- product management
- project management
- project manager
sitemap:
  filename: sitemap.xml
  priority: 0.6

---
{{< youtube IZ-FlBbGaSY >}} 
   📍  📍 if we want to improve the quality of our product and reduce risk, part of our automation story is going to be CI, CD pipelines. It's, it's worth noting  that most  Most teams don't use CICD for CICD. They use it for an automated build.  Okay?  I see very few  teams  applying engineering excellence and doing CI, CD as it's intended to be done.

Just to clarify a little bit, continuous integration  is  coupled with mainline branching.  It's not integrated if it's not In the main line in with the rest of your code. So if you've got a CI continuous integration on a separate branch. Right? That's not actually a CI. That's just a continuous build on your separate branch, which is great.

Definitely have that. But we want continuous integration. We want to be continuously pulling things into the one true version so we have fewer and fewer integration problems. We have fewer and fewer other problems coming off that because we're having to support multiple versions of our product. If you get DevTest live in branches,  you're just fundamentally doing it wrong.

You might have an older product. I definitely  don't  judge the decisions that led to that in the past, right? You might have made that choice 20 years ago in your product. But you shouldn't be making that choice today. DevTest Live with branches,  nobody, no product anywhere should be making that choice today.

We should be doing continuous integration and continuous delivery. Continuous integration is where you have mainline branching and things are continuously integrating. Into that mainline branch, right? Everything, all the work of all the engineers that are working on your product are continuously integrated every day.

Google is notorious for this one. They have one source control repository for the whole company. Every product, everywhere in the company. is on that one main line. Okay. So that, that,  that's a little bit extreme. That's a mono repo. That's a little bit extreme, but at least for a product you want to have that main line branching model where you're continuously integrating every day.

You should not, I would object to a branch that's around for longer than a day. I'd strenuously, strenuously object to a branch that's around for more than a couple of days. Right. Yeah. Yeah. I'm not saying that they wouldn't happen. It's possible. But I'm just trying to lay objective where people work, right?

People are adding new things, adding new capability  don't shouldn't exist for very long. So that's CI continuous integration.  Continuous delivery is when it hits the main line,  it's going to production.  That, that's, that's continuous delivery is not I'm continuously delivering to my test environment. It's I'm continuously delivering to production, to real users. 

Now, you might use a ring based deployment model where you're protecting and, and limiting the blast radius of any problems behind an audience. Perhaps it could be audience based rings that enable you to, to have your high risk customers in a later ring. So you find the problems first with lower risk customers or, or, or, or, yeah, lower risk customers, but continuous delivery, the delivery part and continuous delivery is production. 

Should be real users really using your product. So if you're doing continuous delivery, you should be seeing every commit to the main repo or a particular branch, right? Let's call it a branch. Could be called main, could be called master, could be called hunk, whatever it's going to be called, is, is, ends up in production.

And that's where people continuously integrate. So you see, I. into that, and then you CD from there to production. And most teams in most organizations don't seem to do that. They say they're doing CI CD but they're just using the terminology and the tools that are part of it to do something. Else, which is just an automated build, which is also fine, right?

You gotta have the right technology for the right thing.  I recommend CICD, I recommend continuous integration, mainline branching, and continuous delivery into production. For example, on products that I use that I build I might not use true cd. I think I'm almost, almost there. I'm not quite there.

I think my, it's a little bit too much risk for me, but because of my ability to test, right? But continuous, you know,  I continuously integrate to main and, no, it ships to production. I have CD on, on main, ships to production. It's a preview, so the smaller number of users, so controlling the blast radius.

And then when I feel like preview has enough telemetry to tell me that it's good, that it's Not, I don't have a lot, a larger number of errors. I don't have people not being able to do the stuff that they, they're supposed to be able to do in the tool. When I have enough data then I push the button and it, it rolls out to the next ring, which is everybody.

So I effectively have a two ring system pre or CD system preview, which is a smaller subset of people that opt in to be using the preview version. And then everybody else, and I'll sometimes.  Somebody asks for a new thing, I'll get it into preview and I'll tell them it's in preview and they can try it there and kick the tires, right?

So I'll bring new stuff that's never been tried into preview, people will come and kick the tires and then it will only go to, to The rest of the world once it's been successful, and that's generally how windows works. That's generally how Microsoft teams works. Office 365  all of most of most of Microsoft's products are now in a ring based.

Audience based deployment model and that seems to be the most effective for services that you deliver to your customers. I think websites are a little bit different for like commercial websites, but  again, these are all things that we can talk about and figure out what the most effective model is.

CD might not be the most effective model for you. CI might not be the most effective model. We might just want some. automated builds.  Having the expertise to understand your product, understand its architecture, understand what the business is trying to achieve with the product will help create that indication of how Naked Agility can support you in creating CI, CD, or just some automation to enable you to be as effective as possible and increase the your release frequency and reduce your cost of deployment.

At [NKD Agility](https://www.nkdagility.com), we specialize in helping organizations design and implement CI/CD pipelines that fit their needs. Whether it’s full automation, ring-based deployments, or just a reliable build system, we can help you optimize your processes and deliver better software, faster. Visit us today to get started!  

#agile #agileproductdevelopment #agileprojectmanagement #productdevelopment #productmanagement #productmanager #projectmanager #continuousimprovement #continuousintegration 
