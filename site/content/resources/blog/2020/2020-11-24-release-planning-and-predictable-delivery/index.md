---
title: Release planning and predictable delivery
description: Master release planning and achieve predictable delivery in agile environments. Discover strategies to enhance quality and streamline your software development process.
ResourceId: 2cOXevMnGb_
ResourceType: blog
ResourceImport: true
ResourceImportId: 9714
ResourceImportSource: Wordpress
ResourceImportOriginalSource: Wordpress
date: 2020-11-24
weight: 270
creator: Martin Hinshelwood
layout: blog
resourceTypes: blog
slug: release-planning-and-predictable-delivery
aliases:
- /blog/release-planning-and-predictable-delivery
- /release-planning-and-predictable-delivery
- /resources/2cOXevMnGb_
- /resources/blog/release-planning-and-predictable-delivery
aliasesArchive:
- /blog/release-planning-and-predictable-delivery
- /release-planning-and-predictable-delivery
- /resources/blog/release-planning-and-predictable-delivery
tags:
- Product Delivery
- Software Development
categories:
- Scrum
- Engineering Excellence
- Social Technologies
preview: nkdAgility-habits-16x9-1280-2-2.jpg

---
Many organisations wrestle with the seeming incompatibility between agile and release management, and they struggle with release planning and predictable delivery.

[Updated to reflect the 2020 Scrum Guide!](https://nkdagility.com/the-2020-scrum-guide/)

## TL;DR;

Without working software, you can't build trust and you don't know when you will get the next piece of working software.

Any software that you create is an organisational asset and decisions to cut quality need to be reflected in your company accounts and as such those decisions need to made by your executive leadership and should not be made by [Developers](/the-2020-scrum-guide/#developers). Once you accept this, and quality becomes non-negotiable, your [Dev](/the-2020-scrum-guide/#developers)[e](/the-2020-scrum-guide/#developers)[lopers](/the-2020-scrum-guide/#developers) can focus on creating usable increments of working software. Once you have usable increments of working software, you can then start to look with interest at the progress being made on features and goals.

Without a regular cadence of delivery of working software any belief that you will get a usable increment is misguided at best. [Professional Developers](/the-2020-scrum-guide/#developers) create working software.

## Release planning and predictable delivery

The incompatibility between predictable delivery and agility is fictitious ([tweet this](http://clicktotweet.com/Ub4K3)) and while usually created by an organisation and structure that is unwilling to let go of the old ways and embrace the tenants of agile it can also be the result of a [Scrum Teams](/the-2020-scrum-guide/#scrum-team) fervour to divest themselves of all things that smack of prior planning. There is a lack of understanding that agile and the path to agility is far more than just a change in the way that you build software, it is a fundamental shift in the way that you run your business. Much like the lean movement in manufacturing, companies that embraced it wholeheartedly were the ones that ultimately see the competitive edge that it provides. If one is unwilling to let go of the old ways, then one can’t attain the value of the new. This change will take hard work and courage as the fundamental transparency required to inspect and adapt effectively is at odds with the measures of the past. The lack of predictability of software development is the key to understanding the new model.

## Why is software so unpredictable

**All software development is product development.** In lean manufacturing, we can optimise the production of pre-developed products through the nature of its predictable production. Each unit of work takes the same amount of materials and time to produce so any changes that we make to the process, time, or materials can easily be qualified and the benefit demonstrated. **Manufacturing lives in the predictive world.**

With software everything that we create takes its own amount of time: You can really only know how long something took after it has been completed. Even in manufacturing if you asked an engineer how long it would take to develop a new type of unit of work they would not be able to tell you with any certainty. Once they have developed it however they can tell you exactly how long it will take to make each one, and then systematically optimise the process that you use to make it. In software development we are always doing new product design, therefore, we have no certainty...and this often results in chaos. **Software lives in the empirical world.**

All is not lost however as we can, by looking at our history of delivery for similar things, make a pretty good **forecast**…

The best thing we can then do is to expend effort to make that forecast as accurate as possible while accepting that more time spent planning does not necessarily affect the accuracy of that forecast.

![image](images/image80-1-1.png)  
{ .post-img }
Figure: Diminishing returns from [Agile Estimating – Estimation Approaches](http://leadinganswers.typepad.com/leading_answers/2007/11/agile-estimatin.html)

Ultimately Software Development is a creative endeavour and has the same lack of predictability that painting a picture, writing a book or making a movie has. Yet movies get made all of the time. How can that possibly be! Well, they have a Director ([Product Owner](/the-2020-scrum-guide/#product-owner)) that has a bunch of money and a delivery plan, a Producer (Scrum Master) to make sure that everyone has the skills, knowledge and assets available at the right time and place and one or more Units (Scrum Teams) that have all of the skills necessary to turn the Directors ideas into a working movie. They create Storyboards of what they expect to create so that they can run it past the stakeholders and get feedback. They take those storyboards to the Units who collaboratively work together with the stunt, prop, lighting, camera, sound and wardrobe crews to get estimates and costs and ultimately coordinating to create the movie. Sometimes they don’t know how to do stuff and have to have a go and see what they get.

Making a movie is just like building software, you need a budget, you need a plan, and you are trying to reach a ship date. And just like making a movie, you have to make money at the end of the day so that you can do it all over again.

## Accept the lack of predictability

While I hope by now you understand that the lack of predictability is part of the nature of building software, there are many things that we can do to lessen the impact of that chaos. Indeed if you were to estimate all of the discreet things that you need to do to achieve a goal (let us call them backlog items) in Small, Medium and Large what would your standard deviation of actual hours be? I would wager that it is fairly large. So large in fact that at least half of all mediums would be more accurately classified as Large. But that reclassification can only be done with hindsight. This is indeed one of the tenants of the No-Estimates movement, as really there are only three classifications of size: **small,** **fits** in a Sprint, or **too big** to fit in a Sprint.

This difficulty in estimation is normal for organisations that move towards agility as the transparency that it brings uncovers these sorts of problems. In order to increase the accuracies of our forecasts, there are a number of simple activities that we can perform. These activities, while easy to understand, are very hard to do as they require a culture shift within your organisation as well as the courage of the participants to make them work.

## Focus on continuous quality

Most software lacks quality for the simple reason that you can not easily see the quality in software like you could with a table or a painting. I am not talking about the quality of the User Interface, but the quality under the covers; the quality of the code.

> If you put developers under pressure to deliver they will continuously and increasingly cut quality to meet deadlines.\-Unknown ([Tweet this](http://clicktotweet.com/0U2be))

A lack of quality of the code results in an increase in [Technical Debt](/blog/professional-scrum-teams-build-software-works/) (or more accurately an unhedged fund) which in turn results in two nasties. The first is the teams increasingly have to spend more time struggling with the complexity of your software rather than on new features. If you are still pushing your teams to deliver the same feature level every year you are only encouraging them to cut more quality and thus incurring more technical debt which becomes a vicious cycle. The second is an increasing number of bugs found in production. Bugs found in production also directly impact on the number of features that the team can deliver and any bug, no matter how small, costs ten times and much to fix in production than it does in development.

The only way to handle technical debt is to stop creating it, and then pay a little back each iteration. If however, you are so drowning in technical debt that you cant create working software at the end of the iteration then:

1. Create a **[short measurable checklist](/blog/getting-started-definition-done-dod/)** that mirrors minimum releasable product ([Defenition of Done](/blog/getting-started-definition-done-dod/))
2. Stop adding new features and **make your product meet that checklist** and release your product
3. While you have an increment of working software ([Sprint](/the-2020-scrum-guide/#the-sprint))
   1. **Work to create something of value ([Increment](/the-2020-scrum-guide/#increment))**
      1. Work towards a new goal while meeting the DOD ([Sprint Goal](/blog/the-sprint-goal-is-a-commitment-for-the-sprint-backlog/))
      2. Leave things better than you found them (Engineering Excellence)
   2. **Review that thing of value with your stakeholders ([Sprint Review](/the-2020-scrum-guide/#sprint-review), Backlog Adaption)**
      1. Get feedback on at least one new thing for stakeholders
      2. Update the Backlog to reflect this new information
   3. **Reflect on how you worked with your entire team ([Sprint Retrospective](/the-2020-scrum-guide/#sprint-retrospective), Kaizen)**
      1. Is quality increasing?
      2. Is the DOD increasing?
      3. What can we change to make things better?
4. Go to #1

You can call the activity that results from dropping out of the while loop of working software to be a **Scrumble**; You need to stop piling more features on top of the features that don’t work and fix things so that you can make new things. Ultimately [professional teams build software that works](/blog/professional-scrum-teams-build-software-works/).

There are a number of strategies that can help you both stop creating and start paying back technical-debt:

- **Sufficient requirements** – If your backlog has things in it that are too big or too vague then your team will not really be able to understand them and this, in turn, creates a multiplier for uncertainty. Follow the INVEST (Independent, Negotiable, Valued, Estimable, Small, Testable ) model for every single thing that you ask the team to deliver. If you invest in you backlog in this way you will find it much easier to deliver the contents and thus predict that delivery. This will require you to spend a significant amount of time in refinement. Backlog refinement is key to facilitating a flow of actionable Backlog Items to your team.
- **The [Developers](/the-2020-scrum-guide/#developers) choose what they can deliver** – this implies that the [Developers](/the-2020-scrum-guide/#developers) can reject any item on the backlog that they do not understand. If we accept that every [Developer](/the-2020-scrum-guide/#developers) is trying to do their best to deliver for their [Product Owner](/the-2020-scrum-guide/#product-owner) then the only reason to reject anything would be if an item is too big or does not have enough detail to understand. These Backlog Items can be put on the queue for refinement and refined over the next Sprint. Remember that there is [no such thing as a rejected backlog item](/blog/the-fallacy-of-the-rejected-backlog-item/), only actionable feedback and continuous improvement.
- **Definition of Done (DoD)** – Along with having sufficient requirements the single biggest blocker to predictability is a lack of common understanding of DONE. Done for [Developers](/the-2020-scrum-guide/#developers) should equal what it means to complete an item with no further work required to ship it. If [you cant ship working software](/blog/professional-scrum-teams-build-software-works/) then you need to stop sprinting, Scrumble, and focus on getting your software into a shape that can be delivered in a Sprint.
- **Test First** - Focus on [Test First practices like TDD or ATDD](/blog/you-are-doing-it-wrong-if-you-are-not-using-test-first/) to help you make sure that not only did your engineers build what they expect, but that you ultimately built what the customer expects.
- **Fixed length iterations** – If you have variable length iterations you can’t be sure what you can do in a particular timeframe. How much decomposition do you need to do to the backlog? How much can the team deliver in a single iteration? You can’t be sure unless you have fixed length iteration, and [you reject the idea of staggered iterations](/blog/a-better-way-than-staggered-iterations-for-delivery/).
- **No separate teams** – This means no separate test teams, configuration management teams and definitely no separate maintenance teams. It's hard for folks to grasp, especially with the recent focus on DevOps but if you have separate teams then why would your [Developers](/the-2020-scrum-guide/#developers), those best placed to fix any problems, care about the problems of other teams. The most successful organisations at creating software have development teams that own the entire application lifecycle (Amazon AWS | Visual Studio | Azure DevOps.)
- **Manage dependencies** - Managing dependencies is a hard task and my advice would always be to minimise the number of dependencies that you have. [Developers](/the-2020-scrum-guide/#developers) should have all of the skills required to deliver what you want at the quality level that you want. So if you need to have productionised databases or scripting for production delivery then you might need a DBA or an Operations administrator or two. This can be hard for many teams or organisations but you will have far less success creating silos like Configuration Management or DevOps. Rather add those individuals that you need to the team. However, if you have a dependency on a separate team, maybe you have an application upon which all of your other applications depend, then you may need another way. This is not a silo of types of individual skills, but of a domain and that team just has something in their backlog upon which you are dependent. It is up to the team's respective [Product Owners](/the-2020-scrum-guide/#product-owner) to fight negotiate over when these things get done.
- **Use a modern source control system** - A [modern source control system is more than just code management](/blog/getting-started-with-modern-source-control-system-and-devops/), it should include all of the goodies talked about in DevOps practices and beyond.

If you can, do them all, and many more…
