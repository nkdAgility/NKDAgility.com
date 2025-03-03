---
title: The Sprint is a container for Planning and not necessarily for Delivery
description: Explore how Scrum can enhance planning without strict delivery schedules. Learn to embrace Continuous Delivery for better software development practices.
ResourceId: 6USQKO75YgH
ResourceType: blog
ResourceImport: true
ResourceImportId: 4092
ResourceImportSource: Wordpress
ResourceImportOriginalSource: Wordpress
date: 2011-11-29
weight: 275
creator: Martin Hinshelwood
layout: blog
resourceTypes: blog
slug: the-sprint-is-a-container-for-planning-and-not-necessarily-for-delivery
aliases:
- /blog/the-sprint-is-a-container-for-planning-and-not-necessarily-for-delivery
- /the-sprint-is-a-container-for-planning-and-not-necessarily-for-delivery
- /resources/6USQKO75YgH
- /resources/blog/the-sprint-is-a-container-for-planning-and-not-necessarily-for-delivery
aliasesArchive:
- /blog/the-sprint-is-a-container-for-planning-and-not-necessarily-for-delivery
- /the-sprint-is-a-container-for-planning-and-not-necessarily-for-delivery
- /resources/blog/the-sprint-is-a-container-for-planning-and-not-necessarily-for-delivery
tags:
- Definition of Done
- Agile Product Management
- Continuous Delivery
- Product Delivery
- Software Development
- Technical Debt
- Value Delivery
- Agile Frameworks
- Agile Project Management
- Agile Transformation
categories:
- Scrum
- DevOps
- Engineering Excellence
preview: nakedalm-logo-128-link-2-2.png

---
I have been told time and again in the office that Scrum is an inflexible platform for developing software as it is way too prescriptive. This is far from reality and represents an invalid interpretation in the rules of the game. This fault lies not with those that have been turned away from the light, but with the fanatics that have brandished the burning torch and pitchfork at your door chanting "that is not Scrum because...".

[![Image(1)](images/Image1_thumb-1-1.png "Image(1)")](http://blog.hinshelwood.com/files/2011/11/Image1.png)  
{ .post-img }
**Figure: Please ignore these guys**

Many of us in the community have a vision of making Scrum more accessible to all and to that end, one of the goals of the entire Scrum community should be to help the misguided back to the light and re-educate the Scrum Coaches ( read Inquisitors here ) that have corrupted them.

Let me ask you a question;

> **If the Scrum Guide is the rules by which the game of Scrum is played, then where is it written that your delivery schedule must match up with your planning schedule?**

It does say that you should be meeting your definition of done for each PBI and at least each Sprint. As your definition of done is the quality bar set by the Development Team and negotiated with the Product Owner, what is to stop you having the following DoD:

- Acceptance Tests have been turned into Test Cases
- Functional Tests have been turned into Test Cases
- Code coverage percentage is the same or better than the last build
- All Tests Cases pass
- All Test Cases have been turned into Coded UI Tests
- Deployed to QA and full automated test suit run
- **Deployed to Production**

If you are deploying to production every Sprint and even for every PBI then you are one step away from doing it for every build, which is Continuous Deployment. Does Scrum say that you can't do this? Hell no, it encourages it without mandating it. As long as you meet a [simple measurable checklist](http://blog.hinshelwood.com/are-you-doing-scrum-really/), you can say that you are doing Scrum.

> "Businesses rely on getting valuable new software into the hands of users as fast as possible, while making sure that they keep their production environments stable. Continuous Delivery is a revolutionary and scalable agile methodology that enables any team, including teams within enterprise IT organizations, to achieve rapid, reliable releases through better collaboration between developers, testers, DBAs and operations, and automation of the build, deploy, test and release process."  
> \-Jez Humble

Even if you are not practicing Continuous Delivery, I would encourage you to deploy more regularly than just once a Sprint. I am not saying that it is easy, because it is not.

You can't do this with immature software either. I see customers fail time and again with institutional technical debt and software teams that are highly tuned to create it. In order to achieve Continuous Delivery your organisation must be committed to minimizing technical debt and to maximizing the value delivered to your business. Apart from technical debt there are a quandary of things that need to be in place in order to achieve Continuous Delivery. Think about the ability to have different versions of the same code running in production at the same time while maintaining the contracts and separation of concerns that go to make that possible.

There are only a few organisations that have mastered Continuous Delivery, but the benefit that they achieve in being able to get features into production almost as fast as the business can think of it.

But if you do want to get there, or at least take a journey down that road and see how far you want to go then there are things that must happen. There are waypoints along the road and provide a simple guide to your maturity in this area:

- Automated Build
- Build Verification Tests
- Automated Acceptance Tests
- Automated Functional Tests
- Automated Unit Tests
- Automated Deployment

Only once you have all of these thing should you then be thinking of what more do you need for your software in your environment to be able to successfully deploy your software to production and be happy that you have met the correct quality level to achieve this.

I never tell teams that you MUST do a thing but instead encourage them to do the right thing for their organisation in a journey to build better software.

Now, that is something that we can all aspire to.
