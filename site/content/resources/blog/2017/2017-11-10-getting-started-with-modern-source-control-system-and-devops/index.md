---
id: "11456"
title: "Getting started with a modern source control system and DevOps"
date: "2017-11-10"
categories:
  - "measure-and-learn"
tags:
  - "developers"
  - "devops"
  - "engineering-excellence"
  - "homepage"
  - "software-engineering"
  - "versioncontrol"
coverImage: "excellence-1-1.jpg"
author: "MrHinsh"
layout: blog
resourceType: blog
slug: "getting-started-with-modern-source-control-system-and-devops"
---

There are a number of things that you have to think about when selecting a modern source control system. Some of that is purely about code, but modern source control systems are about way more than code. They are about your entire application lifecycle and supporting DevOps practices, they are about the metadata that you use to understand and manage your development processes and deliver great software. The tools you choose should compliment the professional people and practices that you use.

> DevOps is the union of people, processes, and practices to enable continious delivery of value to your end users
>
> Donovan Brown

## TL;DR

I have been teaching the [Professional Scrum Developer (PSD) training](https://nkdagility.com/training/courses/professional-scrum-developer-training/) and working with software teams for 7 years. I have never encountered a better platform than [Visual Studio Team Services (VSTS)](https://www.visualstudio.com/team-services/) for managing the metadata required to facilitate the building of professional software on a regular cadence in any technology that is deployed to any platform. I have seen Java, .NET, Web, Android, iOS, and Mainframe teams all working together in VSTS with a shared vision and access to the same metadata. If you have many teams I did a webcast for Scrum.org on [Scaling Professional Scrum with VSTS.](https://nkdagility.com/scaling-professional-scrum-visual-studio-team-services/)

## Let's get some things out the way first

If you are writing code then it SHOULD be in Source Control. More specifically, if you are writing code for your company then it MUST be in Source Control. Every line of code that you write or change is an asset of your organisation and should be reflected on a balance sheet somewhere. Any value you add is capital expenditure, of which your shareholders/owners should care, and any maintenance is operational expenditure, which your accountants can write off.

**Put your code in source control…** and yes, I still meet organisations that DON’T use source control. No, not only small sweatshops but banks as well. Would you want your real-time transactional banking system under source control? Coz I would!

Another thing to get out of the way is that deploying directly to production is a BAD IDEA! If you are deploying from your local workstation then you are introducing significant risk to your business and reducing the quality of the organisational asset. Any reduction of quality is a decision that needs to be taken by your executive board on advice from your accountant. Again, organisational asses sitting on a balance sheet. Its fraud to incorrectly represent the value of an asset, ignorance is not an excuse. Even if you have automated builds; if you ship irregularly, or with a lot of time between releases, then you likely have a way to bug-fix production quickly. Bypassing your usual checks and balances for shipping software reduces quality and shows an inherent lack of engineering excellence in your organisation.

**Deploy software through an automated release pipeline…** and yes, I have met companies that deploy directly to production from workstations. I even worked with one company that had operations using trial and error mixing and matching DLL's to get the software working in production. One customer required to do 9000+ hours of manual testing to validate that

**Modern source control is more than just code...** in the past, just like operating systems used to be simple things, you could stick your code in source control and call it good. In the past, you used VSS, Subversion, or Perforce and it was good enough. Not anymore. Just as you expect a browser to ship with your OS, you now expect a build engine, release management, and planning tools to ship with your source control system and for them all to be integrated. So don't base your choice on that one thing, think of the integration and other tools that you need to support your modern software development pipeline.

I would expect my release tools to understand exactly; what changes have been made to the code, which features of the system are affected, and what the resulting impact of that release had on both the user experience and system performance through telemetry. I would expect my work tracking tools to understand exactly; what branches are related to this work, which build include the changes, and who approved the pull requests that brought that code into the system. This is the type of metadata, regardless of the implementation technology, that I would expect to be available to Engineering and Management to help them understand their process and how things are going.

That all said it is important to remember to focus on [becoming a professional Scrum team](https://nkdagility.com/scrum-tapas-importance-professionalism/) rather than an amateur one. While you need to focus on the Scrum Guide, you also need Engineering Excellence and a set of Values and Principles.

## Recommended good practices for a modern software team

I almost never use the term "best practices", especially for software delivery and anyone that gives you a best practice is generally talking out their ass. There are only good practices that fit the current needs of the business or the situation at hand. In the modern software development world, you need to accept that any process or practice that you adopt is imperfectly defined and will need to be adapted to meet your needs. That said, having source control and an automated release pipeline is not optional if you want to continue to be competitive. You need to be able to monitor both your Lead Time and your Cycle Time.

Some general guidelines you should consider:

- **Never code without Source Control** - Ultimately the tool does not matter but if you are building Open Source Software (OSS) then you need to be on GitHub. GitHub has cornered the OSS market and has not near competitor. If however, you are building closed source software then there is no better platform than Visual Studio Team Services (VSTS). You get unlimited private repositories and if you have MSDN licences, as most organisations building on the Microsoft stack does, then it is already included in your licence. If you are not on the Microsoft Stack then I would still recommend VSTS as the cheapest and most featureful platform available that supports any platform and any environment.
- **Use feature flags to minimise branches** - Branches introduce waste with merging and often introduce quality issues. Bypass the whole issue by using Feature flags and other software patterns to avoid it. If you are using a distributed source control system (DVCS) only ever release from MASTER with fully tested code, but you can have an unlimited number of topic and personal branches, as long as they are short lived. If you are using a server-based source control system (SVCS) then you should completely avoid branches where possible, and work to move towards a DVCS. Maybe you need only \[trunk/master/main\] and \[dev/work\] branches but focus on a zero branch policy.
- **Move to Git** \- Regardless of the scale of the software that you are building, you should be developing on Git. If you are clinging to your SVCS (TFVC, Perforce, SVN, whatever) then you are merely clinging to the past and relying on outmoded technology. Even the Windows team at Microsoft has moved to Git, as has Bing, Xbox, & the entire Developer Division.
- **Meet your Definition of Done at least every 30 days** - Create a definition of done that represents the minimum bar of quality for everything your develop. Make sure that definition reflects everything that you need to do to ship your software to production, and get there at least every 30 days. If you can get there more regularly that better, and if you can [practice continuous delivery inside of your planning Sprints](https://nkdagility.com/continuous-deliver-sprint/) then that's even better.
- **Get feedback from your users at least every 30 days** - Part of the trick of delivering awesome software is building just what your customers need, just as they need it. The only way to do this is to get what you have just built into your customer's hands so they can tell you is it is right, then pivot as soon as they give you feedback. Continuous delivery to production is the best way to achieve this.
- **Create tests first so you build what was asked the first time** - You should always work towards test-first practices. While for many this means Test Driven Development (TDD) I like to look it as any form of test-first. How can your coders ever hope to pass the quality gates when the testers build the test cases separately and only show the coders after they are finished. Get your test cases written first and have the coders make them pass. I also recommend that coders use TDD and pair programming. Following Test First will help you move from testing quality in at the end to building quality in from the start.
- **Automate every test you can** - Automation is key to a successful delivery because you can't run all your tests every 30 days. Every 30 days you add more tests and without automation, you can't keep up. Ideally, all of your tests are automated from the start. An interesting example is that Microsoft moved all of its testing efforts into the Development Teams around 3 years ago, and got rid of their last external test team about 2 years ago. Make your Development Team(s) accountable for Quality and give them the tools to make it happen.
- **Create automated release pipeline** - Creating an automated release pipeline is hard but the benefits are numerable. From quality to resilience you just must have one to support modern development practices. You should focus on delivering to production (start with as close as you can get) at least every 30 days, but expect to need to ship many times a day. Automation will make your process quick and easy an lets you focus on improving the pipeline over time as you his issues. This is where lean practices and focusing on flow can really help minimise the waste and improve the process.

In order to support these things, I use VSTS as my software development platform. With the move by Microsoft to distance its platform from execution and focus on orchestration we get a system that can support any team developing with any technology for any platform. This allows us to have a single unified organisational vision and tool for our orchestration of portfolio, planning, execution, coding, build, test management, and release while leaving the execution of these tasks and the technologies used in and to build our software up to the team. You might have one team that used Nuget and another than uses NPM, or one using Maven and another on Gulp. Regardless of your implementation choice, VSTS can support your teams doing Scrum and deploying anything on a regular cadence to anywhere. When I am teaching a [Professional Scrum Developer (PSD)](https://nkdagility.com/training/courses/professional-scrum-developer-training/) class I always use VSTS regardless of the technology that the students are working on.

**Don’t get locked into a limited set of technologies, VSTS supports every technology on every platform.**

Find out more on [Visual Studio Team Services](https://nkdagility.com/training/) from [naked Agility - Martin Hinshelwood](https://nkdagility.com/company/about-martin-hinshelwood/).
