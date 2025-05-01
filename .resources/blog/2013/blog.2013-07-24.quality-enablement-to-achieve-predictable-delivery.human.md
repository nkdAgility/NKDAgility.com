---
title: Quality enablement to achieve predictable delivery
description: Achieve predictable software delivery by establishing quality enablement. Learn key strategies to enhance your development process and reduce bugs.
ResourceId: Qvzmat4E5NB
ResourceType: blog
ResourceContentOrigin: Human
ResourceImport: true
ResourceImportId: 9737
ResourceImportSource: Wordpress
ResourceImportOriginalSource: Wordpress
date: 2013-07-24
weight: 315
creator: Martin Hinshelwood
layout: blog
resourceTypes: blog
slug: quality-enablement-to-achieve-predictable-delivery
aliases:
- /resources/Qvzmat4E5NB
aliasesArchive:
- /blog/quality-enablement-to-achieve-predictable-delivery
- /quality-enablement-to-achieve-predictable-delivery
- /resources/blog/quality-enablement-to-achieve-predictable-delivery
tags:
- Operational Practices
- Pragmatic Thinking
- Product Delivery
- Software Development
- Engineering Practices
- Working Software
- Value Delivery
- Continuous Delivery
- Technical Excellence
categories:
- Engineering Excellence
preview: nakedalm-experts-professional-scrum-2-2.png

---
You need quality enablement to achieve predictable delivery for your organisation which takes effort to achieve.

I do a lot of ALM Assessments for companies and almost every customer that I speak to has unpredictable quality in the software delivery that they receive from their teams. This is not always the Development Teams fault and is often the result of an organisation that is finely tuned to minimise the ability to have a defined and predictable level of quality. In most cases this is due to a lack of a bar that quantifies the minimum things that need to be completed in order for and organisation to understand what i involved in each delivery.

If you have no bar for delivery and thus no idea what needs to be completed for each thing to be delivered then how can you expect to make accurate (or at least as good as we can get) prediction on when things are going to be delivered? You would effectively have no empirical evidence to rely on for predictability of delivery. In addition, the varied quality level results in more bugs in production, which then puts those individuals’ responsible for adding features under more pressure. If you put developers under pressure they will consistently and increasingly cut quality to meet the same deliverable.

![image](images/image11-1-1.png "image")  
{ .post-img }
Figure: The Iron Triangle

In addition many product backlogs lack acceptance criteria leaving the Development Team to guess at the basis by which the customer will accept that something is complete. Indeed because if this lack of acceptance criteria backlog items can often be deceptively large which puts the development team under greater pleasure for delivery and thus the cut quality.

## Fix quality for improved predictability

The only way to successfully create predictable software delivery is to fix 3 of the 4 points of the Iron Triangle. In traditional software development quality is the hidden value and if you fix everything else it is Quality that suffers. Quality should be anchored with an explicit definition.

- **Definition of Done** – Your DoD is the fixed measure or explicit definition of quality for your software development process. It is a short measurable checklist which mirrors shippable that can and is applied to every unit of work delivered. It can be hard to define but without it we don’t know how much work needs to be done in order to ship any backlog item. Apply it at least to the output of the iteration and ideally to every backlog item that you complete.
- **Acceptance Criteria** – While the DoD is applied equally to every backlog item acceptance criteria only applies to an individual item. All conversations between the Development Team, Product Owner and the Business should be reflected in the acceptance criteria so that things that are discussed are mot missed. This also serves to understand scale and encourages breaking down backlog items into smaller units of work. Once you understand what needs to be done to complete an item, overly large items become transparently obvious.
- **Automated Builds –** Having automated builds that can measure the quality of your software is paramount to minimising the amount of work that the team needs to do to verify the software and creating automated acceptance tests and unit tests increase the validity of those builds. Ideally you should have an automated test (UI or Unit) for every acceptance criteria that was added to the backlog item.
- **Automated Deployment** – Having automated deployment will force the team to create working software and allow you to build and maintain something that will minimize the cost of delivery. If the Development Team knows that the business can choose to ship at any time they are then under pressure to maintain that ship-ability and thus quality.

Doing all of these things will serve to make quality the goal not the lack of it.

## Conclusion

The way that we have traditionally measured our development teams have finely tuned them to fluctuate quality in order to meet aggressive delivery schedules. However this fluctuating quality only serves to reduce our ability to deliver and annoy our customers when they find the resulting bugs.

The goal is to increase quality not reduce it but first we need to be able to measure that quality and enforce it.
