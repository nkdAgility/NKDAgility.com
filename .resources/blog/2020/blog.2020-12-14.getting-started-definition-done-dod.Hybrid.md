---
title: Getting started with a Definition of Done (DoD)
description: Explains how to create, apply, and improve a Definition of Done (DoD) in Scrum to ensure software quality, transparency, and consistent delivery of working increments.
ResourceId: z18IcQhlD7I
ResourceType: blog
ResourceContentOrigin: Hybrid
ResourceImport: true
ResourceImportId: 38238
ResourceImportSource: Wordpress
ResourceImportOriginalSource: Wordpress
date: 2020-12-14
weight: 315
AudioNative: true
creator: Martin Hinshelwood
layout: blog
resourceTypes: blog
slug: getting-started-definition-done-dod
aliases:
- /blog/getting-started-definition-done-dod
- /getting-started-definition-done-dod
- /getting-started-with-a-definition-of-done-(dod)
- /blog/getting-started-with-a-definition-of-done-(dod)
- /resources/z18IcQhlD7I
- /resources/blog/getting-started-definition-done-dod
- /resources/blog/getting-started-with-a-definition-of-done-dod
aliasesArchive:
- /blog/getting-started-definition-done-dod
- /getting-started-definition-done-dod
- /getting-started-with-a-definition-of-done-(dod)
- /blog/getting-started-with-a-definition-of-done-(dod)
- /resources/blog/getting-started-definition-done-dod
- /resources/blog/getting-started-with-a-definition-of-done-dod
tags:
- Working Software
- Definition of Done
- Increment
- Software Development
- Professional Scrum
- Agile Frameworks
- Agile Product Management
- Scrum Team
- Operational Practices
- Pragmatic Thinking
- Product Delivery
- Engineering Practices
- Team Performance
- Agile Planning
- Transparency
categories:
- Scrum
- Engineering Excellence
- Product Development
preview: naked-Agility-Scrum-Framework-Definition-of-Done-2-1.jpg
Watermarks:
  description: 2025-05-07T13:15:15Z
concepts:
- Artifact

---
In my last post about [Professional software teams creating working software](https://nkdagility.com/blog/professional-scrum-teams-build-software-works/) [David Corbin](https://www.scrum.org/david-corbin) made a good point. How do you determining what "Free from fault or defect" means? Since that is different for each Product and may change over time you need to focus on Quality and reflecting that quality in a [Definition of Done]({{< ref "/tags/definition-of-done" >}}) (DoD).

[Updated to reflect the 2020 Scrum Guide!](https://nkdagility.com/blog/update-scrum-guide-25th-anniversary-scrum-framework/)

## TL;DR;

Your [Developers](/the-2020-scrum-guide/#developers) are ultimately responsible for creating done increments of [working software]({{< ref "/tags/working-software" >}}). Done Increments. **Done**.

![](images/naked-Agility-Scrum-Framework-Definition-of-Done-920x720-1-2.jpg)
{ .post-img }

[Developers](/the-2020-scrum-guide/#developers) needs to decide what Done means within the organisational context and the product domain. They need to sit down and create a list of things that must be true for every [Increment]({{< ref "/tags/increment" >}}) of software that they deliver. Working Software is not specific to a PBI; it's applied regardless of PBI to the entire delivery. Not just for each PBI.

> "The Definition of Done creates [transparency]({{< ref "/tags/transparency" >}}) by providing everyone a shared understanding of what work was completed as part of the Increment. If a [Product Backlog]({{< ref "/tags/product-backlog" >}}) item does not meet the Definition of Done, it cannot be released or even presented at the [Sprint Review]({{< ref "/tags/sprint-review" >}}). Instead, it returns to the Product Backlog for future consideration."
>
> \-[The 2020 Scrum Guide](https://nkdagility.com/the-2020-scrum-guide/)

If you can't ship working software at least every 30 days then by its very definition, you are not yet doing [Scrum]({{< ref "/categories/scrum" >}}). Since [Professional Scrum Teams build software that works](/blog/professional-scrum-teams-build-software-works/), stop, create a working increment of software that meets your definition of done (DoD), and then start Sprinting, and review what you mean by "working" continuously, and at least on a regular cadence.

## What is a Definition of Done (DoD)

You need to start somewhere, and most often we don’t have a greenfield product. Either we are handed an existing product, or we are the team that built it and are switching to Scrum. Wherever your product originated, the code, and thus the product, will not currently be working software. How can it be when you don't have a definition of what working means? So what do you do?

Before you cut a single line of code, you need to decide what done means for your product and your company. It will be defined very differently if you are building firmware for pacemakers or if you are creating an e-commerce portal. Here are some characteristics of a Definition of Done:

- **A short, measurable checklist** - try and have things on your DoD that can be measured, that you can test the outcome, preferably in an automated fashion.
- **Mirrors shippable** - While you might not have shipped your product, [although we recommended it](https://nkdagility.com/blog/continuous-deliver-sprint/), you should have that choice. Your [Product Owner](https://nkdagility.com/the-2020-scrum-guide/#product-owner) should be able to say, at the [Sprint Review](https://nkdagility.com/the-2020-scrum-guide/#sprint-review): "That’s Awesome… lets ship it.".
- **No further work** - There should be no further work required from the [Developers](https://nkdagility.com/the-2020-scrum-guide/#developers) to ship your product to production. Any additional work means that you were not Done, and it takes away from the [Product Owner](https://nkdagility.com/the-2020-scrum-guide/#product-owner) capacity for the next iteration. Ideally, you have a fully automated process for delivering software, and [never use staggered iterations for delivery](https://nkdagility.com/blog/a-better-way-than-staggered-iterations-for-delivery/).

Your short, measurable checklist that mirrors usable and results in no further work required to ship your product needs to be defined. I find the best way to do this is to get the [Scrum Team](https://nkdagility.com/the-2020-scrum-guide/#scrum-team) (the [Product Owner](/the-2020-scrum-guide/#product-owner) plus the [Developers](https://nkdagility.com/the-2020-scrum-guide/#developers) and any relevant [Stakeholders](https://nkdagility.com/training/audiences/stakeholders/)) into a facilitated [DoD Workshop](https://nkdagility.com/training/courses/engineering-practices-workshop/). Without a Defenition of Done we don't understand what working software means, and [without working software we cant have predictable delivery](https://nkdagility.com/blog/release-planning-and-predictable-delivery/). Your [Product Owner can't reject a Backlog Item](https://nkdagility.com/blog/the-fallacy-of-the-rejected-backlog-item/), only whether the Increment is working or not.

## My first Definition of Done (DoD)

Your [Definition of Done](https://nkdagility.com/the-2020-scrum-guide/#commitment-definition-of-done) does not just magically appear, and your software does not magically comply. Making your Software comply with your definition of done is hard work, and while your definition of done should organically grow, you need to create the seed that you can build on.

I recommend that you run a workshop with the entire [Scrum Team](https://nkdagility.com/the-2020-scrum-guide/#scrum-team), and likely some other domain experts. If there are Stage Gates that your software has to pass after [Developers](https://nkdagility.com/the-2020-scrum-guide/#developers) are Done, then you need representatives from those Gates to participate in the workshop. Regardless of your product you likely need representatives with the following expertise; Code, Test, Security, UX, UI, Architecture, etc. You may have this expertise on your team, or you may need to bring in an expert from your organisation, or even external to your organisation.

Some examples of things to put on your definition of done:

- **Increment Passes SonarCube checks with no Critical errors** - You will be increasing over time, so maybe you need to say "_Code Passes SonarCube checks with no more than 50 Critical errors_" then work on it over time.
- **Increment's Code Coverage stays the same or gets higher** - Looking at a specific measure, like 90%, of code coverage is a read hearing and tells you nothing of code quality. However, it might be advantageous to monitor and measure for adverse change in code coverage, and we [always advocate for TDD practices](https://nkdagility.com/blog/you-are-doing-it-wrong-if-you-are-not-using-test-first/).
- **Increment meets agreed engineering standards** - You should decide rules for naming of methods, tests, variables and everything in-between. Start small and add over time. Link to your agreed standards on a Wiki and continuously improve and expand your rules. Automate if possible.
- **Acceptance Criteria for Increment pass** - Making sure you at least meet the prescribed criteria is a laudable goal and [automating them with ATDD practices](https://nkdagility.com/blog/you-are-doing-it-wrong-if-you-are-not-using-test-first/) is even better.
- **Acceptance Tests for Increment are Automated** - Make sure that you automate all of your tests. If you think something will break, then you should have a test for it.
- **Security Checks Pass on Increment** - Use an automated tool as part of your build and check for known security vulnerabilities. You will not find all of your security issues, but at least don’t do things we know to be reflective of poor Security.
- **Increment meets agreed UX standards** - Again, have a Wiki page and make sure that you check it twice. If you are not using an automated DoD entry, then you need to agree as a Team that you have met the criteria.
- **Increment meets agreed Architectural Guidelines** - Wiki's are fantastic for this, but automate what you can.

Whatever [Definition of Done](https://nkdagility.com/the-2020-scrum-guide/#commitment-definition-of-done) you come up with it is unlikely that your entire Product currently meets the criteria. You are not yet doing Scrum. Before you start Sprinting, you need to focus on making sure that your current Increment meets your new Definition of Done. Focus on Quality, which is what the [Developers](https://nkdagility.com/the-2020-scrum-guide/#developers) are accountable for, and make sure that your [Increment](https://nkdagility.com/the-2020-scrum-guide/#increment) meets that new quality bar before you start. The next Increment can only reach the quality bar of all those that came before do, but you can and should [add to that quality bar](https://nkdagility.com/blog/can-the-definition-of-done-change-per-sprint/).

**_The [Definition of Done](https://nkdagility.com/the-2020-scrum-guide/#commitment-definition-of-done) is the commitment to quality for the [Increment](https://nkdagility.com/the-2020-scrum-guide/#increment)!_**

Create a usable increment that meets your definition of done and then start sprinting. Keeping your software in a working state [will require a modern source control system that provides you with the facility to implement good DevOps](https://nkdagility.com/getting-started-with-modern-source-control-system-and-devops/) practices.

## Growing your Definition of Done (DoD)

It's super important that quality is always increasing, and that means that you will need to at least reflect on your [Definition of Done](/the-2020-scrum-guide/#commitment-definition-of-done) on a regular cadence. In [Scrum](/the-2020-scrum-guide/), this cadence is defined by your Sprint length, and you have a Kaizen moment at the [Sprint Retrospective](/the-2020-scrum-guide/#sprint-retrospective). That does not mean that you don’t reflect on your DOD all the time, you do. You reflect continuously on whether your increment currently meets your DoD, and what you need to do to get it there. You should always be reflecting on whether your DoD fits your needs. If your [Developers](/the-2020-scrum-guide/#developers) finds that something is missing from the DoD halfway through the Sprint, then they should go ahead and add it, making sure that they are not endangering the [Sprint Goal](/the-2020-scrum-guide/#commitment-sprint-goal).

You may discover that you have a performance problem with your product as David Corbin pointed out in my previous post. How do we make sure that we fix that issue? As I see it there are two pieces to this once you are in flight. You can Scrumble (stop Sprinting because of poor quality), and fix it, or you can integrate this new knowledge into your product cycle.

If it is a significant issue that results in you not having working software, then you need to stop and fix. In Scrum, this is called a Scrumble, as a reflection that the [Developers](/the-2020-scrum-guide/#developers) stumbled because something is missing. You should stop adding new features and create a usable increment before you continue Sprinting and adding new features. Once you have repaired the issue, you can increase your [Definition of Done](/the-2020-scrum-guide/#commitment-definition-of-done) to make sure that all future [Increments](/the-2020-scrum-guide/#increment) meet the new requirements.

If it is less significant, you might want to keep working and add what you need to your [Product Backlog](/the-2020-scrum-guide/#product-backlog). You can then deliver improvements over the next few Sprints that mitigate and then resolve the identified issue. Once you have resolved it, you can then pin the outcome by adding something to your DoD.

**Always look for ways that you can increase your quality. What does your definition of done look like today?**
