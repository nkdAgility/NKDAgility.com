---
title: Definition of Done - Objective vs Subjective
description: Learn the critical distinction between subjective goals and the objective Definition of Done (DoD) in Scrum. This guide dives into why a measurable, automated DoD is essential for consistent quality, stakeholder trust, and professional-grade product delivery.
ResourceId: -Z5GGUOjc-d
ResourceType: blog
ResourceImport: false
date: 2025-01-03
AudioNative: true
creator: Martin Hinshelwood
layout: blog
resourceTypes: blog
slug: definition-of-done-objective-vs-subjective
aliases:
- /resources/-Z5GGUOjc-d
- /definition-of-done-objective-vs-subjective
- /blog/definition-of-done-objective-vs-subjective
- /definition-of-done---objective-vs-subjective
- /blog/definition-of-done---objective-vs-subjective
aliasesFor404:
- /definition-of-done-objective-vs-subjective
- /blog/definition-of-done-objective-vs-subjective
- /definition-of-done---objective-vs-subjective
- /blog/definition-of-done---objective-vs-subjective
tags:
- Definition of Done
- Increment
- Software Development
- Scrum Product Development
- Professional Scrum
- Working Software
- Operational Practices
- Agile Planning
- Software Developers
- Agile Frameworks
- Engineering Excellence
- Pragmatic Thinking
- Agile Project Management
categories:
- Scrum
- Product Delivery
- Value Delivery
- Agile Product Management
preview: 2025-01-03-definition-of-done-objective-vs-subjective.jpg

---
In countless teams, there’s a recurring mix-up between “what” we’re building, “how” it aligns with business objectives, and the objective quality criteria by which it should be measured. The result? Chaos masquerading as agility. To clear the air: in Scrum, the “what” and “how” are driven by Product and Sprint Goals. These provide directional clarity but remain inherently subjective—a north star guiding your path, not a litmus test of quality.

Contrast this with the Definition of Done (DoD). The DoD is your team’s objective compass—a binary, quantifiable checklist that ensures every Increment meets professional-grade quality. It’s non-negotiable and should be firmly rooted in your product’s brand, user expectations, and technical robustness.

#### TL;DR:

Don’t confuse subjective goals with objective quality. In Scrum, the Definition of Done (DoD) is a crucial, measurable bar of quality, not a negotiable outcome. Keep it clear, objective, and automated wherever possible to ensure that every Increment meets professional standards.

### Product and Sprint Goals: Subjective by Design

Goals in Scrum are aspirational, meant to challenge teams and align efforts towards strategic outcomes. The Product Goal represents a long-term objective, while the Sprint Goal offers a short-term milestone. Together, they guide the team like a compass through the wilderness., helping maintain direction even through surprise obstacles and side quests. However, achieving these goals isn’t always guaranteed. Progress is iterative, incremental, and constantly adapting to new insights - a bit like chasing a moving target.

### Definition of Done: The Objective Measure

Unlike goals, the Definition of Done is a steadfast benchmark for quality. It defines the bare minimum for an Increment to be considered complete. Without it, teams risk releasing poorly constructed, subpar products that erode user trust and damage the brand. A solid DoD ensures consistent quality across all deliverables, instilling confidence in both internal teams and end users.

### Establishing a Solid Definition of Done

There is a key message in the Scrum Guide that is often overlooked that plays a critical role in establishing the DoD.

> If the Definition of Done for an increment is part of the standards of the organization, all Scrum Teams must follow it as a minimum. If it is not an organizational standard, the Scrum Team must create a Definition of Done appropriate for the product. - Scrum Guide 2020

For me this suggests that there should be some kind of Organizational or Product DoD. I think of this as comming from the business. This is driven by the business and should reflect the businesses intent for quality in the product. That might be the minimum level of quality required by the business to protect their brand, their customers, and their employees.

An example of a Organizational or Product DoD for a team working on a cloud product might be:

> “Live and in production, gathering telemetry that supports or diminishes the starting hypothesis.”

This sets a clear bar for delivery while supporting empirical learning and iterative improvement. It stays clear of the technical detail and jargon of an individual teams DoD and focuses on its objective and purpose for the product. It implies much, from ideation to delivery while minimizing imposition on the teams. It creates alignment of intent while maintaining autonomy of implementation. It recognizes that every team needs a unique DoD that is relevant for their context.

Each team working on a product would then be responsible for creating a DoD that is appropriate for their context within that product.

This is the seed that will grow into each teams unique quality bar that reflects this DoD. A robust reflection should be:

1. **Objective and Measurable**: Avoid vague criteria and instead focus on things that you can measure.
2. **Comprehensive**: What are all the things that need to be true for a production deployment of your product to be deployed to production?
3. **Living Document**: The teams DoD as needed to reflect evolving standards, technologies, and stakeholder expectations of the product as it grows.

### Common Pitfalls

Despite its critical importance, the DoD is often misunderstood, undervalued, or even undermined. Teams frequently:

- **Blur Subjective and Objective**: Adding criteria like “approved by the Product Owner”, which shifts focus from quality to stakeholder satisfaction. Any "approved by ... person or department" should be strictly avoided.
- **Overlook Automation**: Relying on manual checks leads to inconsistencies and slower feedback loops.
- **Treat the DoD as a Maximum**: Viewing it as a ceiling instead of a floor hampers innovation and improvement.

### Practices for Defining Done

To maintain focus on quality, consider the following practices:

1. **Automate Everything:** Automated tests and CI/CD pipelines should validate DoD compliance as part of the development process. If you have things that cant be automated right now, plan the work to change the product to enable those activities to be automated.
2. **Review Regularly**: Incorporate DoD reviews in retrospectives to ensure its relevance and alignment with current product and organizational needs. Keep a list of "things that need to be true to deploy to production that we cant do yet", and regularly move these to Done.
3. **Train Teams**: Ensure every team member understands the DoD and its importance in delivering professional-grade Increments.
4. **Separate Quality from Approval**: Keep subjective approval processes distinct from the DoD to avoid undermining its objectivity.

### Conclusion: The Quality of Done

In Scrum, the Definition of Done is your minimum bar for quality. It’s the safeguard against technical debt, the foundation for stakeholder trust, and the cornerstone of professional-grade delivery. By keeping your DoD objective, measurable, and focused on quality, you empower your team to build products that meet—and often exceed—user expectations. Remember, the DoD is a minimum bar, not a maximum aspiration. Raise it periodically and watch your product’s quality soar.

**What’s Your Take?**

We’d love to hear your thoughts! How does your team define and enforce the Definition of Done? Have you faced challenges distinguishing subjective goals from objective quality measures? Share your experiences and insights in the comments below!
