---
title: Rethinking Capacity Planning
short_title: Rethinking Capacity Planning
description: Explores how effective capacity planning shifts focus from individual hours to system-level flow, using Lean and Agile principles to improve predictability and value delivery.
tldr: Capacity planning should focus on optimising system flow and predictability, not tracking individual hours or task assignments. Shifting from micromanagement to managing work as a system at portfolio, category, and team levels helps prevent overload, improves value delivery, and enables reliable forecasting. Development managers should prioritise system-level metrics, enforce work-in-progress limits, and empower teams to pull well-prepared work, creating sustainable and predictable delivery.
date: 2025-07-21T09:00:00Z
lastmod: 2025-07-21T09:00:00Z
weight: 70
sitemap:
  filename: sitemap.xml
  priority: 0.8
  changefreq: weekly
contributors:
  - name: Nigel Thurlow
    external: https://www.linkedin.com/in/nigelthurlow/
  - name: Alex Brown
    external: https://www.linkedin.com/in/alexbrown/
ResourceId: AhxlPTOD1yy
ResourceImport: false
ResourceType: blog
ResourceContentOrigin: hybrid
slug: rethinking-capacity-planning
aliases:
  - /resources/AhxlPTOD1yy
concepts:
  - Principle
categories:
  - Engineering Excellence
  - Product Development
  - Lean
tags:
  - Flow Efficiency
  - Lean Principles
  - Lean Thinking
  - Operational Practices
  - Continuous Improvement
  - Lean Product Development
  - Organisational Physics
  - Pragmatic Thinking
  - Throughput
  - Value Delivery
  - Agile Strategy
  - Portfolio Management
  - Product Delivery
  - Systems Thinking
  - Team Performance
Watermarks:
  description: 2025-05-07T12:48:54Z
  short_title: 2025-07-07T16:43:13Z
  tldr: 2025-07-30T23:22:00Z
creator: Martin Hinshelwood

---
Capacity planning is not about filling calendars or counting resource hours. It is about flow, system constraints, and predictability. And importantly, what we are talking about here applies even within environments of strict budgets, immovable deadlines, and rigorous accountabilities. Lean approaches do not discard discipline; they reframe how we achieve predictability, accountability, and sustainable delivery by focusing on the system, not just the parts. These ideas align directly with the Scrum ethos of empirical process control and the Kanban strategy of observing and managing work-in-progress limits to enhance value delivery.

Too many organisations frame capacity as “how many hours does each person have?” or “how many tasks can we assign this sprint?” They fall into the trap of breaking complex, systemic work into artificial personal quotas, focusing on individual loading rates instead of collective flow. This leads to managers obsessing over how ‘utilised’ each person is, mistaking busyness for progress. Teams become overloaded with microtasks, pulled into multitasking, and lose sight of flow efficiency and value creation. This mindset traps them in local optimisations, overload, and multitasking chaos. Everyone looks busy, but value delivery crumbles. Deadlines slip, work piles up, and predictability collapses.

We need to shift from individual task-level tracking and micromanagement to managing the system of work.

## Three Levels of Capacity Planning: Strategic, Category, Team

Effective capacity planning happens at three distinct but connected levels: portfolio (strategic), category (product or business unit), and team (execution). Each level has its own constraints, its own levers, and its own accountabilities. If you blur these levels, you end up with local optimisations, overloaded systems, and unpredictable delivery. If you handle them deliberately, you enable scalable, reliable flow across the entire organisation. This post lays out what matters at each level, where most organisations fail, and how to focus on the right system levers to improve predictability and value delivery.

### Portfolio Level (Strategic)

At the portfolio level, individual capacity is irrelevant. Portfolio-level delivery is not the sum of people’s hours or team headcounts. It is about the system’s ability to progress and complete major initiatives across the organisation.

Traditional project management has well-established strengths — especially in controlling scope, budget, and schedule — but repeatedly makes the same flawed assumptions when applied to complex, system-wide delivery. To connect better, we should acknowledge where traditional methods excel and then explain why they hit limits at scale or in domains like software engineering, where variability and complexity cannot be fully controlled. It assumes that if you know how many people you have and how many hours they can work, you can calculate how many projects you can run. It treats capacity as a static sum of people, ignoring system dynamics like waiting times, handoffs, coordination overhead, and priority collisions. It assumes that by assigning people to projects and filling calendars, you maximise delivery. In reality, you simply increase work in progress, dilute focus, and create organisational thrashing.

Flow-based, lean thinking demands a different focus. The real constraint at portfolio level is not team speed. It is how many initiatives the organisation can meaningfully progress in parallel before bottlenecks, cross-team dependencies, or funding constraints stall progress. This speaks directly to Lean’s core emphasis on optimising the system as a whole, not optimising local team measures. As Deming stressed, managing parts in isolation leads to suboptimisation — the real improvement comes when leadership steps back and improves the flow and constraints at the system level. It is about how efficiently the system moves work across teams, products, and functions, independent of how busy individuals are.

Tracking individual capacity at portfolio level leads to local optimisation and wastes effort. Managing portfolio-level WIP, cross-team flow, and initiative-level progress gives you real, actionable capacity insight. Trying to map individual team throughput directly to portfolio delivery without addressing cross-initiative coordination, system WIP limits, or systemic blockers is a guaranteed failure.

Specifically, leaders fall into the trap of believing:

- That if every team improves throughput, the portfolio improves – false.
- That we can just sum team metrics to get total portfolio capacity – false.
- That we can ignore portfolio-level WIP and still forecast accurately – false.

The shift required is from “how many hours can we extract from people” to “how much value can the system deliver, predictably, given its real constraints.” This is why traditional project management fails at scale. It looks down at tasks and people when it should be looking up at systems and flow.

### Category Level (Product / Business Unit)

At the category level, the biggest mistake is assuming you can simply roll up individual team flow metrics to understand category capacity, without managing cross-team dependencies, shared bottlenecks, or category-level WIP.

Why is this wrong?

Teams within a category rarely operate in isolation. They share architectures, platforms, specialists, and decision-makers. Even if each team shows good local flow, the category’s overall delivery can be blocked by cross-team dependencies, shared capacity limits (such as UX, security, or operations), or coordination overhead (like release alignment or integration cycles).

Traditional thinking assumes category performance equals the sum of teams’ performance. In reality, category performance is governed by the speed of the slowest shared bottleneck and the organisation’s ability to coordinate across flows.

What needs to shift:

- Apply category-level WIP limits on how many initiatives or epics are in play across all teams.
- Focus on improving cross-team flow and dependency management, not just local team throughput.
- Measure flow across the value stream, not within isolated team swimlanes.

The mistake is failing to treat the category as an interconnected system. Local team improvements mean little if the category’s delivery is constrained by systemic coordination, shared services, or unmanaged WIP.

### Team Level (Execution)

The core mistake at the team level when moving to flow metrics is assuming that flow metrics like throughput or cycle time are just “better tracking” of individual performance, rather than system-level indicators of work preparation, flow, and blockers.

Why is this wrong?

Traditional teams apply flow metrics to individuals, asking: “How many tasks did you finish?” or “What’s your personal throughput or cycle time?” This creates local pressure, gaming, and false signals because flow metrics were never designed to evaluate individuals. They measure how well the team system moves work end-to-end.

Teams also often skip the upstream preparation work, thinking that flow metrics alone will fix predictability, without addressing key conditions:

- Right-sizing work
- Defining clear pull-ready conditions
- Setting and respecting WIP limits

What needs to shift:

- Treat flow metrics as team-level health signals, not personal performance measures.
- Focus on improving system conditions — work size, WIP, and dependencies — to improve flow, not squeezing people for more.
- Use metrics to guide improvement conversations, not to monitor or punish individuals.

The mistake is misapplying flow metrics as individual productivity tools instead of using them to improve team system flow. Without addressing preparation, WIP, and collaboration, adding flow metrics just creates new reporting noise.

## What needs to change

The shift from individual capacity thinking to system-level flow demands disciplined, pragmatic changes across the organisation. This is not a matter of adding a few charts or running reports — it’s a change in ethos. It is about treating capacity as an emergent system property, not a mechanical sum of parts.

### Focus on Throughput, Lead Time, and Efficiency

Rather than fixating on individual or team utilisation, shift your measurement to system-level flow. Pay attention to:

- The number of items completed per sprint or delivery cycle (noting this assumes work items are similarly sized; otherwise, throughput comparisons can be misleading).
- The average lead time from work start to completion, helping reveal system bottlenecks and delays.
- Process cycle efficiency (PCE): the proportion of time work actively moves versus all non–value-adding activities (not just waiting), exposing inefficiencies across the system. This includes unnecessary committees, bureaucratic processes, and other activities that exist only to service themselves rather than delivering value.

The goal is not to ask, “Who can take on more?” but to ask, “What does our system reliably deliver, and how can we improve flow without overburdening people or teams?”

### Stop Misusing Estimation, Start Right-Sizing

Stop wasting time trying to predict perfect effort estimates.

Instead, apply the Lean principle of reducing variability and batch size, using queuing theory to improve system flow. But be clear: software engineering lives in the complex domain, not the clear or complicated domain where variability can simply be engineered away. We cannot eliminate variability entirely, but we can reduce unnecessary variability by defining a clear definition of workflow, supported by approaches like One Engineering System (1ES) and platform engineering. These strategies help standardise and stabilise the environment, tools, and pipelines — leaving only the unavoidable, context-driven variability that belongs to the real problem space.

To right-size effectively:

- Break work into small, similarly sized, meaningful slices that fit smoothly through your system.
- Focus on cutting work to a shape the system can absorb predictably — not wasting time on abstract story points or inflated complexity debates.
- Use historical throughput and cycle time data to calibrate what 'small enough' looks like in practice, not in theory.
- Make right-sizing part of your working agreements and backlog preparation, ensuring teams only pull work that meets clear, shared readiness standards.

The issue isn't estimation itself—it's turning estimation into something it was never meant to be. Right-sizing is still estimation, just done in a simpler and more honest way. This is not about squeezing people harder; it is about designing a steady, sustainable system where predictability is built directly into the shape and handling of the work.

### Apply WIP Limits and Enforce Pull

Stop treating WIP limits as a mechanical cap or a reportable metric. They are a deliberate, disciplined strategy to protect system flow and predictability. Set clear limits on how many initiatives, epics, or stories are in play — not on how many tasks an individual can juggle. Once the system reaches its limit, stop adding work. Enforce pull: nothing new enters until capacity is truly available. Multitasking is toxic; kill it without hesitation. This is not about pushing people harder; it’s about designing the system so work flows cleanly and teams can focus, finish, and deliver predictably.

### Forecast With Empirical Data

Stop pretending forecasts are about precision. Forecasting is about understanding what the system consistently delivers and using that to set realistic expectations, with the important caveat that this relies on the assumption of a relatively stable system, as Lean approaches depend on system stability for predictability. This also means recognising how system constraints align with legal mandates, statutory requirements, and interdepartmental dependencies — especially in public sector or regulated environments where external obligations shape the boundaries of what can be delivered and when. If your teams typically deliver 6–8 items per sprint, then forecast 6–8 — no sandbagging, no overpromising, no wishful thinking. Use past variance to shape your delivery ranges and confidence levels. Forecasting is not about heroic assumptions; it is about respecting the boundaries of what your system can actually achieve. Teach leadership that predictability comes from protecting system health, not demanding unrealistic outputs or pushing teams beyond sustainable limits.

### Monitor Flow Health Holistically

Flow health is not just a dashboard; it is the living pulse of your system. Go beyond counting throughput and look deeper:

- Rising cycle or lead times — these are your early-warning signals of hidden bottlenecks creeping into the system (and, as noted earlier, low PCE includes more than just waiting — it also covers other forms of systemic waste and non–value-adding activities).
- Aging WIP — when work lingers without progress, it is a red flag that something is stalled or blocked.
- Low PCE — when too much time is spent waiting instead of progressing, it signals waste accumulating across the system.

These are not vanity metrics. They reveal how your system is truly performing, regardless of how full calendars look or how busy people appear. Build regular inspection of these health indicators into your operating rhythm. Use them not for blame or micromanagement, but as fuel for system-wide conversations: Where is flow breaking down? What needs to change? Where can we intervene to unblock, simplify, or improve?

Healthy flow is not a side effect; it is a deliberate, ongoing outcome you must design, monitor, and continuously tune.

The change is not cosmetic — it’s a fundamental rethink of how you approach planning, forecasting, and delivering across all levels of the organisation.

### The Role of Leadership

Leadership is not about control or oversight; it is about creating the conditions where teams and systems can thrive. Lean leadership models humility, removes systemic obstacles, and relentlessly focuses on delivering customer value, not just improving internal measures. Leaders must step back from the temptation to manage individuals and instead take accountability for enabling the system of work. That means:

- Enabling true autonomy at the team level, giving teams the space to own their work and delivery, without micromanagement.
- Actively protecting WIP limits and pull discipline across the system, even when external pressures or senior stakeholders demand more.
- Investing in backlog refinement, right-sizing, and preparation so that teams pull only well-shaped, high-value work — and have the capacity to deliver it predictably.
- Focusing measurement on system health — time-to-market (TTM), process cycle efficiency (PCE), throughput, and lead time — not individual utilisation, heroics, or busyness.

Leaders are accountable for creating an environment where flow is deliberate, predictable, and sustainable. This is not about pushing people to work harder; it is about tuning the system so teams can focus, collaborate, and deliver value without unnecessary friction or disruption. True leadership means enabling the system, not extracting from the people.

## Reframing the Conversation

Lean capacity planning reshapes how we think about delivery, focus, predictability, and most critically, continuous learning and relentless improvement — the true core of Lean thinking.

Stop asking, “How many tasks or hours can we assign?” Start asking, “How much value can the system deliver, at what lead time, and with what efficiency?”

If you’re not measuring system health indicators like PCE or TTM, you are flying blind.

This is not about making teams go faster. It is about creating smarter, healthier flow. Get the fundamentals right, and you unlock sustainable, reliable delivery that serves both your customers and your organisation.
