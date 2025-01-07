---
title: Performance Engineering for Optimal User Experience
description: Discover how performance engineering enhances user experience! Join Martin Hinshelwood as he shares strategies for optimising software in production.
date: 2024-11-23T07:00:12Z
videoId: DSIXtHZTirA
url: /resources/videos/:slug
slug: performance-engineering-for-optimal-user-experience
aliases:
- /resources/videos/DSIXtHZTirA
- /resources/videos/performance-engineering-for-optimal-user-experience
- /resources/performance-engineering-for-optimal-user-experience
preview: https://i.ytimg.com/vi/DSIXtHZTirA/maxresdefault.jpg
duration: 704
isShort: false
tags:
- Agile
- Product development
- Product management
- software engineering
- project management
- agile product development
- agile product management
- agile project management
sitemap:
  filename: sitemap.xml
  priority: 0.6

---
{{< youtube DSIXtHZTirA >}} 
 # Performance Engineering and Testing in Production: A Modern Approach | Martin Hinshelwood  

  📍  📍 If you want to be able to ensure that your software performs well and creates a great user experience, you're going to have to put in a lot of effort in making that happen. It is not going to mag, you're not gonna magically has have awesome software with an awesome experience and fa and, and fast and responsive without actually putting in the effort.

To figure out how to do that and performance engineering has a huge impact on user satisfaction on the business goals. You're trying to achieve right? Without.  A focus on performance engineering, and this is also shifting left, right, towards where the, the, the team is doing the work. Without, without that, you're not,  you're not going to be able to build. 

You're not going to be able to build a product that suits your customers. Customers are going to leave because it doesn't perform well, or customers are going to leave because it doesn't do what they need it to do, or customers are going to leave because it's, it's, it's  buggy and doesn't, you're not getting things there fast enough, right?

So performance engineering, where we're looking at how  quickly  Users are able to do things and that some of that some of that could be user experience based taking steps out of the process and some of it can be, does the software actually function at speed? Does it function at load?  And while some of these things can be load and stress tested, I'm going to quote  one of my favorite product managers, Brian Harry, who said there's no place like production. 

No matter how much  testing  you do prior to production,  you're going to have problems that only exist in production.  You can't simulate real users. It's not possible. You can only synthetically simulate users. So no matter how much of that stuff you do, You're going to have problems when you hit production.

They can be performance problems, they can be the way people use it problems, right? The order that people do things, or the amount they do this particular thing is different from what we had in the simulation. And that's where you run into a lot of your, your, your major performance problems.  My  philosophy  is that we want to get into production as quickly as possible so that we can figure out the impact of the changes that we've made and  analyze  the load that and stress testing within the context of real usage, real users using it for real.

And this is, this is the story of, of testing in production, which doesn't mean you're not testing before production. Holy moly, no. Don't ship this. stuff that's not tested to production. That's a bad idea, right?  We need to get into production as quickly as possible, which means we need to automate and create fast, sleek, automated testing for all of the normal stuff that we need to test, right?

Does the software actually function the way we expect it to? And then we want a ring based or audience based Deployment model so that we can control the exposure of these new capabilities and features on. We do load and stress testing effectively in production. So what that might look like. I'm going to use an example because I love the way that they've done this.

So DevOps team at Microsoft Azure DevOps MVP and Seeing how they do things has been really, really, really enlightening because they've, they've got quite a big product. It's quite a big scaling problem. They've got millions of users. And what they effectively do is  they have  some, some of the rings that you're deploying to are physical rings like environments, but even once you've deployed a new capability to all of your  production environments.

Let's say you have six  areas around the world. You've deployed to them all. Those features that are deployed might not be accessible by people, right? So they're not impacting production in any way. They're off. Feature flag is off. But  then they  the team that owns that feature that's deploying that feature wants to ensure that that feature is load tested, stress tested, is the right and you've also got is the right thing  is the right thing resonates with customers, provides the right capability, but also  works load tested, stress tested and we agreed.

Well, I agreed that  we can't do load testing and stress testing.  Very well, not in production. So what we need to be able to do is we need to be able to limit the number of users that are accessing this new feature and then expand it over time. So there's various ways to do that. What they would do  is their first. 

ring that they would create. And this is actually a ring for each feature. So  they, they're creating an audience based deployment model pair feature. If it's big enough, right? You might have features that you just ship. You might have changes that you just ship. You don't do this with everything. It's as expensive, right? 

But what they do is the team will go, ah, we want to start getting real users into kicking the tires on this feature. It's just us so far, just internal people. So what we're going to do is we're going to publish a blog post. So they publish a blog post that says we're working on this new feature. It's, it's, it's going to provide this capability.

Here's what it currently looks like.  And if you would like to help us kick the tires, send an email to this email address. And we'll, we'll with your account name and, and your, your either org, an account or just org or just account, depending on how they're, how they're doing it.  So you give them the data of who you are, and then they enable it for you.

So you can then go in the tool, you would then have a little feature flag that you can turn on and off. So you can choose to turn it off. And when you turn, choose to turn it off when you choose to turn it off, it's you get asked for a comment and it goes to the team, right? So they can find out why you don't like it, right?

Why you're not using it.  It's slow. It's this, it's that, and then they can go look at the telemetry. But that's, that's a very private preview, right? People have to actively opt in.  Once they have enough data to say that they think this is a good feature, they think it performs well, at least with the small number of users, once we have enough telemetry, they then.

open it out, and they'll turn it,  they'll have it off for everybody that's using the service, but with the feature flag enabled for everybody, so everybody can go turn it on. And they'll do another blog post that says, we're now ready for more people to try this. You don't have to email us anymore. You can just go switch it on, go try it out and tell us what you think. 

So that encourages a bunch of people to go turn it on.  And then they get a bunch of telemetry for people using it. And either people then continue to use it or they turn it off because they don't like it. Right? Maybe it overrides the existing functionality and they don't like the way it is because something's missing.

So they go to turn it off. They're asked what the problem is. They type in, I don't like it because it's slow. I don't like it because this feature is missing. I don't like it because I don't like it. My cheese being moved, whatever the reason is, right?  And that's, they then collecting more telemetry. And if they get enough data, they maybe go to the next stage, or maybe they need to do more things, more iterations on the, the, the capabilities, improve the performance.

Maybe they need to turn it off because it's not performing well. And then they need to do some performance improvements and then turn it back on again.  Eventually, if they've got enough telemetry, they'll turn it on by default for everybody. With the option for people to go in and turn it off.  So everybody gets it forcibly turned on  and then we're collecting data and telemetry from the people that turn it off to find out why they don't like it.

Why do they go turn it off? What do we need to do to get those folks on board?  Once they have enough telemetry, they see there's not so many people turning it off. There's always going to be people who don't like what you're doing, right? So you can't,  it's not a unanimous thing. They then have it on by default.

You can't turn it off. Right? They maybe disable the option to turn it off see what complaints roll in for people that want to be able to turn it off and then eventually they get rid of the feature flag and it's on for everybody in production.  That's a  modern software engineering implementation. 

Of continuous delivery to production and then an audience based rollout and expansion and testing story to allow you to do load testing and performance testing and stress testing in production.  That  takes discipline, that takes effort.  It's definitely has a cost, right? There's a lot of things that had to happen there and things that had to be organized and things that had to be done. 

But Azure DevOps. Using that capability that they built into the system, using that story, they created a massive following from their users that their users expected excellence, expected new things, expected those new things to work. And as those new things rolled out, because you have an expectation if you opt into a private preview, that there might be some You know,  things that don't work quite as well, or we don't know yet, right?

So you're not  testing in production with users that haven't chosen to be part of that test story.  You're soliciting for people to come in and help you. And because they want to help you, one, they're more forgiving, and they'll give more feedback, right? Because they're choosing to be there. And that's how you create a story of Performance improvements and enhancing user experience in a progressive, modern.

engineering excellence manner. And this is something that naked agility can help you build within your teams, build within your product. Don't expect it to be magically overnight. These things take effort. They take discipline. Sometimes mistakes are made, but with a focus on delivering high quality usable working product continuously to our users, we can build some of the best products you've ever seen.
 

At [NKD Agility](https://www.nkdagility.com), we specialize in helping teams adopt modern engineering practices like performance engineering, testing in production, and audience-based deployments. Ready to build high-quality, high-performance software? Visit us today to learn how we can support your journey to engineering excellence.  

#agile #scrum #agileproductdevelopment #agileprojectmanagement #projectmanagement #projectmanager #productdevelopment #productmanager #productowner #scrummasters 
 [Watch on Youtube](https://www.youtube.com/watch?v=DSIXtHZTirA)
