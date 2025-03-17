---
title: Your Evolving Definition of Done
description: Evolve your Definition of Done (DoD) to align with organisational goals, ensuring quality and strategic value in every product increment.
ResourceId: 5wIEg7lD_Xd
ResourceType: blog
ResourceImport: false
date: 2025-03-31T09:00:00
weight: 225
AudioNative: true
creator: Martin Hinshelwood
layout: blog
resourceTypes: blog
aliases:
- /resources/5wIEg7lD_Xd
aliasesArchive:
- /your-evolving-definition-of-done
- /blog/your-evolving-definition-of-done
categories:
- Social Technologies
- Scrum
tags:
- Definition of Done
- Software Development
- Scrum Product Development
- Strategy
- Professional Scrum
- Value Delivery
- Engineering Practices
- Product Delivery
- Agile Product Management
- Practical Techniques and Tooling

---
The [Definition of Done (DoD)]({{< ref "/tags/definition-of-done" >}}) is not a static artefact; it evolves over time as a [Scrum Team]({{< ref "/tags/scrum-team" >}}) gains experience and capability. While the [Scrum Guide]({{< ref "/resources/guides/scrum-guide" >}}) acknowledges that teams may refine their DoD to improve product quality, there’s an often overlooked piece: Organisations should also provide an organisational Definition of Done that reflects their needs. This organisational perspective ensures that Scrum Teams build on a solid foundation, aligning technical execution with strategic goals.

The [Definition of Done (DoD) is an objective, measurable standard of quality]({{< ref "/resources/blog/2025/2025-01-03-definition-of-done-objective-vs-subjective" >}})—not a negotiable target. Keep it clear, enforceable, and automated to ensure every Increment meets professional expectations.

## Definition of Done - The Organisational quotient

For a product to deliver real value, its quality criteria must align with organisational and market expectations. It should meet a minimum quality standard that ensures usability while safeguarding the organisation, its employees, and its users. Any failure to do so could damage the organisation’s reputation and trust in the product.

This means organisations should define a business DoD that may include:

- Regulatory compliance
- Market readiness (e.g., beta testing completion, go-to-market strategies)
- Customer experience and feedback incorporation
- Financial viability assessment
- Alignment with broader company objectives

Without this business-level perspective, teams risk optimising for technical completeness while missing the broader value delivery picture. The result of many iterations of the organisational definition of done for a product might look like:

> Live an in production
>
> gathering telemetry
>
> supporting or diminishing
>
> the starting hypothesis

This short sentence packs a lot into it, and it's a commercial product definition of "done" for a team I have collaborated closely with for over 17 years.

1. "Live an in production" - done here mean that it is in the hands of real users

2. "gathering telemetry" - done here mean that the Developers must add code that collects relevant information from usage, performance, and such...

3. "supporting or diminishing the starting hypothesis" - Done here means that the team must define success metrics before building a feature or capability, ensuring that the collected data provides clear evidence of whether the intended outcomes are being achieved.

None of these elements define the "why" or "what" of what we're building—those are captured in the backlogs. Instead, they establish the minimum quality standard required for work to be considered done.

## Definition of Done - Translating Organisational Standards into Team Practice

While Scrum Teams are self-managing, that doesn’t mean they can do whatever they want. They operate within a structured environment, within a [balance of leadership and control]({{< ref "/resources/blog/2025/2025-03-12-balance-of-leadership-and-control-in-scrum" >}}) that upholds both autonomy and accountability. Scrum isn’t anarchy; it’s a [social technology]({{< ref "/categories/social-technologies" >}}) that enables self-management within clear constraints—Scrum events, commitments, and organisational expectations.

Each Scrum Team must interpret the organisational Definition of Done within their context, shaping an engineering-level DoD that aligns with it. While examples can guide them, it's the team’s responsibility to determine what Done means within organisational constraints.

In addition to supporting the organisational definition of done, a robust DoD ensures that work meets a consistent level of quality before it is considered complete. This includes [engineering practices]({{< ref "/tags/engineering-practices" >}}), preferably within the bounds of a [shift-left strategy]({{< ref "/tags/shift-left-strategy" >}}), such as:

- **Writing Unit and Integration Tests** – with a preference for shifting testing earlier by adopting Test-Driven Development (TDD) and automated integration testing, ensuring issues are caught before coding progresses too far—and preferably making tests a prerequisite for writing new code.

- **Performing Code Reviews** – Rather than manual code reviews create automate code quality checks using static analysis and enforce good practices before manual reviews, allowing developers to focus on deeper logic and architectural concerns—and preferably integrating peer reviews into the development workflow, such as pair or mob programming.

- **Adhering to Security and Compliance Requirements** – try embeding security scanning into [CI/CD pipelines]({{< ref "/tags/continuous-delivery" >}}) with automated dependency checks and policy enforcement, catching vulnerabilities before they reach production—and preferably treating security as code, ensuring it evolves alongside development.

- **Maintaining Updated Documentation** – Automate as much of your documentation updates as possible using tools that generate API references and architecture diagrams directly from code, keeping documentation relevant and accurate—and preferably making documentation a non-negotiable part of the Definition of Done (DoD).

- **Ensuring Deployments are Automated and Repeatable** – Implement Infrastructure as Code (IaC) and continuous deployment pipelines to guarantee consistent, error-free releases—and preferably shifting validation left with feature flags, automated rollback strategies, and deployment previews.

Each aspect contributes to quality, reducing the likelihood of defects and [technical debt]({{< ref "/tags/technical-debt" >}}). However, quality isn’t just a technical concern—it is an economic and strategic one.

## The Evolution of Done Over Time

New teams often start with a weak DoD that doesn’t yet guarantee releasability. A brownfield product with legacy constraints may have a DoD that initially excludes automation, testing, or [continuous deployment]({{< ref "/tags/deployment-frequency" >}}) due to existing technical debt. Over time, through Sprint Retrospectives and deliberate improvements, the DoD should:

1. Start at a minimal viable level (e.g., basic testing, peer reviews).
2. Expand to include automated testing, security checks, and CI/CD.
3. Reach a state where every increment is truly releasable.

An experienced Scrum Team should aim for a DoD that ensures shippability at the end of every Sprint. Anything less introduces unnecessary risk and delays value realisation.

#### Common Misconceptions

1. **Can the DoD Change Per Sprint?**\
   Yes, but only to **increase quality**. The Sprint Retrospective is the right place to discuss DoD improvements, not reductions. However, if an issue arises, address it immediately—don’t wait for the Retrospective.

2. **Can the DoD Be Lowered to Deliver More Features?**

   No. Quality is a long-term investment, not a short-term lever to pull for speed. A Scrum Team has no authority to cut quality—that's a financial and risk decision made at the highest level. This authority rarely sits with project managers or middle management. If someone asks you to lower quality, tell them to get it in writing from the financial director.

3. **Can We Have Different DoDs Per Backlog Item?**

   No. The DoD is a universal standard applied to all work, ensuring consistency in quality. Acceptance Criteria define specific conditions for a backlog item, but these conditions do not belong in the DoD.

4. **Should the DoD Be Fluid and Change Every Sprint?**

   No. A fluctuating DoD signals dysfunction unless it’s always improving. Constant changes undermine transparency and disrupt planning. Evolution should be deliberate, incremental, and focused on raising quality—not shifting goalposts.

## DoD as a Strategic Lever

A strong DoD isn’t just about engineering—it’s about protecting revenue, managing risk, and ensuring predictable delivery. Weak DoD practices lead to costly rework, delayed releases, and customer dissatisfaction. By embedding security, compliance, and quality checks into the development cycle, organisations reduce their exposure to financial and reputational risks. Teams that consistently meet a well-defined DoD can deliver with greater confidence, improving forecasting and market responsiveness.

A strong DoD reduces rework, increases predictability, and aligns technical work with business value. As organisations evolve, so should their quality expectations. This continuous refinement is not just a technical necessity—it’s a competitive advantage.
