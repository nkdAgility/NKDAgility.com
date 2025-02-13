---
title: Why Handoffs Are Killing Your Agility
description: Explore the detrimental impact of handoffs in software development and discover strategies to eliminate them for better agility.
ResourceId: pDvDdIEi9sj
ResourceType: blog
ResourceImport: false
date: 2025-01-13
AudioNative: true
creator: Martin Hinshelwood
layout: blog
resourceTypes: blog
slug: why-handoffs-are-killing-your-agility
aliases:
- /resources/pDvDdIEi9sj
- /why-handoffs-are-killing-your-agility
- /blog/why-handoffs-are-killing-your-agility
aliasesFor404:
- /why-handoffs-are-killing-your-agility
- /blog/why-handoffs-are-killing-your-agility
tags:
- Agile Frameworks
- Agile Planning
- Agile Project Management
- Agile Strategy
- Agile Transformation
- Cross Functional Teams
- Cycle Time
- Engineering Excellence
- Engineering Practices
- Lean Principles
- Lean Product Development
- Lean Thinking
- Operational Practices
- Pragmatic Thinking
- Software Developers
- Software Development
- Strategy
- Team Collaboration
- Team Performance
- Working Software
categories:
- Organisational Agility
- Product Delivery
- Value Delivery
preview: 2025-01-11-why-handoffs-are-killing-your-agility.jpg

---
Many organisations attempt to adopt Lean practices without fully understanding their implications in software development. This often leads to excessive handoffs, which fragment communication and reduce agility.

Here's the kicker: handoffs are _not_ Lean, Agile, or DevOps. They are an anti-pattern that introduces waste, increases cycle time, and makes collaboration difficult.

### TL;DR

Handoffs are a silent killer in software development. They create inefficiencies, reduce quality, and destroy agility. If your organisation is still riddled with handoffs between siloed teams, you are doing it wrong. Embrace cross-functional teams, optimise for flow, and maintain organisational hygiene to ensure only the minimal set of rules and alignments needed to deliver value effectively. Together, these practices protect your ability to focus on creating value.

### What Are Handoffs?

Handoffs occur when one team or individual completes a task and passes it to another team for further work. Examples include:

- Developers handing off features to testers.
- Testers handing off validated features to operations.
- Business analysts tossing requirements over the fence to developers.

Each of these transitions is a point of failure, introducing delays, miscommunication, and opportunities for rework.

### The Hidden Costs of Handoffs

Handoffs come with a plethora of hidden costs that undermine agility and efficiency. Compounding these challenges is the build-up of organisational cruft—rules and processes that outlive their usefulness. This cruft can further slow progress and obscure value delivery. Each of these costs impacts not only the immediate work but also the organisation's ability to deliver value quickly and sustainably.

1. **Loss of Context**: Valuable information is lost when tasks move from one team to another. Teams waste time trying to re-establish the original intent. Moreover, the cost of context switching exacerbates this issue. When questions arise that cannot be answered immediately, team members often feel compelled to start new tasks, increasing work in progress (WIP) which in turn increases cycle time. This leads to further delays and amplifies the loss of context, making it even harder to regain clarity and focus on the original work.

2. **Increased Cycle Time**: Every handoff introduces a delay, pushing your delivery timelines further out. This delay often stems from an increase in batch size as teams attempt to locally optimise for handoffs, which ironically leads to even longer cycle times. Larger batch sizes also bring significantly higher risk, as larger changes are more prone to defects and harder to integrate.

3. **Reduced Quality**: Misunderstandings and lack of accountability often lead to defects and lower overall product quality. The increase in cycle time and the loss of context also contribute to growing technical debt, making it much harder to identify and fix bugs in larger deployments. This, in turn, further degrades the overall quality and increases the risk of failures in production.

4. **Decreased Morale**: Team members stuck in silos feel disconnected from the bigger picture, leading to frustration and burnout. This disconnect erodes their sense of **purpose**, a critical element in achieving "autonomy, mastery, and purpose" as described in Daniel Pink's _Drive_. Without a clear connection to the end-to-end delivery of value, team members lose motivation and struggle to see the impact of their work.

Together, these hidden costs act as multipliers, compounding each other and magnifying the negative impact on your organisation's ability to deliver high-quality software efficiently. Addressing one cost often reduces others, making it crucial to tackle these issues holistically.

### Why Do Handoffs Persist?

Handoffs are a symptom of functional silos. Organisations that structure themselves by discipline (e.g., separate teams for development, testing, and operations) create natural barriers to collaboration. This approach is a holdover from the "Scientific Management Method" developed during the Industrial Revolution when workers were mechanised to optimise for narrow, repetitive tasks rather than holistic, value-driven outcomes. Even well-meaning attempts to implement Agile often retain these silos, resulting in what I like to call "hybrid Agile" — a mismatched combination of Agile practices and traditional command-and-control management. This ineffective blend perpetuates the very silos and inefficiencies that Agile aims to eliminate.

## The Solution: Eliminate Handoffs

Eliminating handoffs requires a mix of modern engineering practices and a commitment to automation. By automating repetitive tasks and adopting strategies like "testing in production," organisations can significantly reduce the friction and delays associated with traditional handoffs. This approach enables faster feedback loops, improved quality, and a seamless delivery pipeline.

To achieve true agility, a focus on eliminating handoffs is necessary by implementing cross-functional teams and optimising flow. Here's how:

1. **Create Cross-Functional Teams** - Bring together individuals with all the skills needed to deliver end-to-end value. A cross-functional team might include developers, testers, designers, and operations personnel working collaboratively towards a shared goal. No sub-teams. No silos.

   > **Pro Tip:** Co-locate teams in timezones and use collaboration tools like Microsoft Teams or Slack to ensure seamless communication.

2. **Adopt Continuous Delivery Practices** - Automation is a cornerstone of Continuous Delivery (CD). By integrating automated testing, deployment, and monitoring into your pipeline, you ensure quality at every step while reducing manual intervention. Moving towards "testing in production" becomes a natural evolution of this strategy, allowing teams to gather real-world feedback quickly and address issues proactively.

Continuous Delivery (CD) eliminates the need for separate testing or deployment phases. Build pipelines that automatically validate and deploy changes, ensuring quality at every step.

3. **Leverage Test-First Development** - Adopt Test-Driven Development (TDD), Behaviour-Driven Development (BDD), or Acceptance Test-Driven Development (ATDD). Writing tests first ensures clarity and reduces rework, as discussed in [You are doing it wrong if you are not using test first](https://nkdagility.com/blog/you-are-doing-it-wrong-if-you-are-not-using-test-first/).

4. **Minimise Work in Progress (WIP)** - Limit WIP to reduce context switching and improve focus. A lower WIP means fewer handoffs and faster delivery cycles.

5. **Invest in Collaborative Refinement** - Backlog refinement should be a team sport. The entire Scrum Team — including the Product Owner and Developers — must collaborate to clarify and break down work items. See more in [If your backlog is not refined then you are doing it wrong](https://nkdagility.com/blog/if-your-backlog-is-not-refined-then-you-are-doing-it-wrong/).

6. **Shift Left and Own It** - All of these practices contribute to a "shift left" strategy, where quality, security, and deployment considerations are addressed earlier in the development lifecycle. Ultimately, the team that creates a feature should also own it in production, including gathering and acting on feedback. This end-to-end ownership fosters accountability, ensures quicker feedback loops, and allows teams to continuously improve based on real-world usage.

Organisations inevitably accumulate cruft—unnecessary rules, outdated processes, and misaligned practices. These accumulate quietly over time and, if left unchecked, undermine agility and the ability to focus on value creation. To combat this, periodic acts of organisational hygiene are essential. These involve critically assessing and removing unnecessary constraints, ensuring the organisation maintains only the minimal set of rules and alignment required to deliver value effectively. When combined with a shift-left approach and a relentless focus on flow, these practices help organisations stay lean, adaptive, and aligned with their goals.

Handoffs might seem inevitable in large organisations, but they are a choice. By reorganising your teams, adopting modern engineering practices, and embracing a Lean-Agile mindset, you can minimise handoffs and unlock true agility.

Remember: every handoff is an opportunity for waste. Eliminate them, and watch your teams thrive.

## References

1. Daniel Pink, _Drive: The Surprising Truth About What Motivates Us_
2. The 2020 Scrum Guide - [Scrum.org](https://scrum.org/)
3. Martin Hinshelwood, _You are doing it wrong if you are not using test first_ - [NKD Agility](https://nkdagility.com/blog/you-are-doing-it-wrong-if-you-are-not-using-test-first/)
4. Martin Hinshelwood, _If your backlog is not refined then you are doing it wrong_ - [NKD Agility](https://nkdagility.com/blog/if-your-backlog-is-not-refined-then-you-are-doing-it-wrong/)
5. The Agile Manifesto - [AgileManifesto.org](https://agilemanifesto.org/)
6. Don Reinertsen, _Principles of Product Development Flow_

**What challenges has your team faced in eliminating handoffs?** _Share your experiences and thoughts in the comments below._ Let’s start a conversation about how we can all build better, faster, and more collaborative teams!
