---
title: The fallacy of the rejected backlog item
description: Explore the fallacy of rejecting backlog items in Scrum. Understand the impact on development and learn how to enhance collaboration and transparency.
ResourceId: Ewu5coIz9qm
ResourceType: blog
ResourceImport: true
ResourceImportId: 9876
ResourceImportSource: Wordpress
ResourceImportOriginalSource: Wordpress
date: 2020-07-13
weight: 415
creator: Martin Hinshelwood
layout: blog
resourceTypes: blog
slug: the-fallacy-of-the-rejected-backlog-item
aliases:
- /blog/the-fallacy-of-the-rejected-backlog-item
- /the-fallacy-of-the-rejected-backlog-item
- /resources/Ewu5coIz9qm
- /resources/blog/the-fallacy-of-the-rejected-backlog-item
aliasesArchive:
- /blog/the-fallacy-of-the-rejected-backlog-item
- /the-fallacy-of-the-rejected-backlog-item
- /resources/blog/the-fallacy-of-the-rejected-backlog-item
tags:
- Agile Project Management
- Scrum Product Development
- Software Development
- Professional Scrum
- Empirical Process Control
- Working Software
- Product Delivery
- Agile Product Management
- Scrum Team
- Transparency and Accountability
categories:
- Scrum
- Social Technologies
preview: nkdAgility-backlog-item-approve-1-1.jpg

---
There is a frustrating misunderstanding of reality when one thinks that the Product Owner can reject a single story at the Sprint Review. This is the fallacy of the rejected backlog item and the misguided belief that this backlog item can just be left out of this delivery. That backlog item that was chosen by the Development Team at the Sprint Planning event to help them achieve the Sprint Goal. The Sprint Goal that created focus and has the entire Development Team working in the same area of the codebase.

**The fallacy is that without this single Backlog Item, one of many, the code will still function as intended.**

## TL;DR;

Since the Development Team is held accountable for quality, but not quantity, and they sure can't be held accountable for meeting forecast. It was, after all, a forecast. There are only two states that the product increment can be in at the end of the sprint:

- **DONE** - If in the pursuit of the Sprint Goal the output of the Sprint is a DONE Increment of working software then the Development Team did everything they were required to do. Any gap between what was delivered and expectation is merely a learning opportunity. At the Sprint Review, the Scrum Team investigates this gap and updates the Product Backlog (Transparency of the Future) to reflect what is now needed next.

- **NOT DONE** - If the Development Team is not “Done” at the end of the Sprint then there are some consequences:
  - An increase in Technical Debt that is going to make future work slower
  - Removing the option for the Product Owner to release the product if they so choose.
  - With undone work, you have to fix it next Sprint and thus interfere with the next Sprint Goal and the Product Owners delivery expectations.
  - Remove any chance of [predictability for future sprints](https://nkdagility.com/release-planning-and-predictable-delivery/) until the undone work is under control.

**If it is DONE,** then there is no rejection of the Backlog Item there is only feedback. There is just a learning opportunity that can be used to reduce the expectations gap for future Sprints. Reflect on that during the Sprint Review, engage with Stakeholders to better understand both their intent and their expectations.

Empirical process control is not about doing everything correctly first time, it's about transparency, inspecting, and adapting.

## The fallacy of the rejected backlog item

At the end of the Sprint, the Product Owner can deny that the Development Team met DONE. This would mean that the Development Team failed their accountability to meet the minimum quality bar as set down and agreed in the Definition of Done.

At the end of the Sprint, the Product Owner can deny that the work represents a significant enough return on investment to warrant shipping it to production. This likely means that either the Goal was not useful, or that the Development Team did not understand the Backlog Item enough. This would mean that the Product Owner failed in their accountability to maximise value delivery.

At the end of the Sprint, based on either of these two outcomes, the Product Owner can choose to reject the entire Sprint and loose all of the work for that Sprint.

My point is that it is neither physically nor technically possible to remove a single Backlog Item from a Sprint without incurring significant rework.

> A Sprint Review is held at the end of the Sprint to inspect the Increment and adapt the Product Backlog if needed. During the Sprint Review, the Scrum Team and stakeholders collaborate about what was done in the Sprint. Based on that and any changes to the Product Backlog during the Sprint, attendees collaborate on the next things that could be done to optimize value.  
> \-[Scrum Guide - Sprint Review](http://www.scrumguides.org/scrum-guide.html#events-review)

**The [Scrum Guide 2017](https://www.scrum.org/Scrum-Guides) mentions nothing of rejecting anything at the Sprint Review.**

This is the reality of product development that gets in the way of the idea of the rejected backlog item. The software that we are producing is complex and only works together in its entirety, the whole increment. The Sprint Goal provides the Scrum Team with purpose and focus, and selecting items that go towards this Goal means that many of the selected backlog items, the forecast, are related. This related set of ideas created an interconnected network of interdependent code that realises on the existence of each other. If we then decide to rip one of those interconnected items out of this complex web of classes and methods, then we are increasing risk, and we are also unlikely to have working software at the end of the Sprint.

Oh, I am sure that there are exceptions, but it will take time to remove no matter how good the team's engineering practices.

Just to be clear, this is not about Done. I expect every team to produce work that meets whatever definition of done that they have agreed as the Scum Team. If the Development Team calls Done when they are not then that is a wholly separate problem… because [Professional Scrum Teams build software that works](https://nkdagility.com/professional-scrum-teams-build-software-works/).

## Rejecting a Backlog Item is missing the point

If you are considering rejecting backlog items last the Sprint Review then it is likely that you are missing the point of the Review in the first place. It is not about acceptance or rejection of the increment by the Product Owner, but instead, it is about discovery and understanding between the Product Owner, the Development Team, and Stakeholders. It's about inspecting the last 2 weeks and making sure that we still have transparency of the future reflected in the Product Backlog. Did the market, our competitors, our business, or our ideas just change based on the latest Increment of the product?

Since [the only constant is change](https://nkdagility.com/blog/evolution-not-transformation-this-is-the-inevitability-of-change/), it is absolutely possible that the Scrum Team created something that meets Done, meets the Acceptance Criteria, and still does not meet the needs of the business. Is this the Development Teams fault? Of course not… it is a learning point, and inspect and adaption of understanding between the Scrum Team and the Stakeholders. This is intensely valuable learning for the Scrum Team as a whole.

There are only three actions open to the Scrum Team at the Sprint Review:

1. **Update the Product Backlog to reflect what we now need to do to achieve the vision**

2. **Choose to ship the current increment or not**

3. **Choose to end the project or continue**

## Making it easier with feature flags or toggles

All of that being said it is the job of the Development Team to make things as flexible for the Product Owner as possible. They should implement what capabilities they need, into each increment, to make it possible for them to turn a new feature off and still deploy. This will not only make the Scrum team happy; it will get the newly built features in front of the Stakeholders as quickly as possible for feedback.

There are a few things that can make this as easy as possible:

- **Communication** – Good communication between the Product Owner and the Development Team can help alleviate these sorts of issues. However, continued interfering in the Development Team by the Product Owner will make it harder to deliver what was estimated. The Development Team should deliver their understanding of what the Product Owner presented to them at the Sprint Planning meeting while collaborating were timely and appropriate.

- **INVEST**– Making sure that your PBI’s are all following the INVEST \[Independent | Negotiable | Valuable | Estimable | Sized appropriately | Testable\] model. If you follow this guide, then you can minimise any misunderstanding between the Product Owner and the Development Team.

- **Feature Flippers/toggles/flags** – The single most valuable thing in your developer's arsenal is the ability to turn the things that you are adding on and off at will. This should be applied both to a feature and the multiple layers of that feature that are added to each pass delivering PBI’s. You may think of each PBI’s as requiring a switch to be able to turn it on or off. It is usually not perfect as there are some things that are iterations of the same feature. More advanced implementations may allow you to enable or disable features by account or user.

**If you can do all of these things as they will all add value by making it easier to give the Product Owner flexibility, give the Scrum Team as much feedback as possible.**
