---
title: Estimating Better in an Overloaded System Is a Poor Man’s Strategy
short_title: Why Limiting WIP Beats Better Estimation
description: High work in progress (WIP) causes delays and unpredictability; improving estimates won’t help. Limiting WIP and focusing on flow is key to reliable delivery.
tldr: Trying to improve estimates in an overloaded system is ineffective because high work in progress causes delays and unpredictability, regardless of estimation accuracy. Real improvements in predictability and throughput come from limiting work in progress, fostering collaboration, and focusing on finishing work rather than starting more. To achieve reliable delivery, reduce WIP and prioritize flow over planning.
date: 2025-09-08T09:00:00Z
lastmod: 2025-09-08T09:00:00Z
weight: 235
sitemap:
  filename: sitemap.xml
  priority: 0.7
  changefreq: weekly
ResourceId: 9asj2UApmVM
ResourceImport: false
ResourceType: blog
ResourceContentOrigin: hybrid
slug: estimating-better-in-an-overloaded-system-is-a-poor-man-s-strategy
aliases:
  - /resources/9asj2UApmVM
concepts:
  - Practice
categories:
  - Product Development
  - Kanban
  - Engineering Excellence
tags:
  - Flow Efficiency
  - Software Development
  - Team Performance
  - Operational Practices
  - Cycle Time
  - Organisational Physics
  - Value Delivery
  - Continuous Improvement
  - Metrics and Learning
  - Lean Principles
  - Social Technologies
  - Pragmatic Thinking
  - Project Management
  - Lean Thinking
  - Product Delivery
Watermarks:
  description: 2025-06-18T18:22:38Z
  short_title: 2025-07-07T16:43:05Z
  tldr: 2025-07-30T23:12:31Z

---
Just a regular reminder that predictability and the accuracy of any estimate deteriorate rapidly as you increase the amount of Work in Progress (WIP) in the system. And yet, most teams still try to compensate for unpredictability by estimating better, rather than addressing the actual problem: the system is overloaded and cannot flow.

This isn’t a theoretical issue. It’s not about mindset. It’s a systemic constraint. The more you load a delivery system, the slower and more unpredictable it becomes. The more you try to force progress by starting new work, the less likely it is that anything will finish.

At a certain point, no estimate matters because wait time is dominating lead time.

## Estimation and flow are not interchangeable

It’s tempting to believe that delivery problems are caused by poor estimation. If only the team were better at sizing or forecasting, things would be more predictable. But the underlying assumption here is flawed: it assumes the issue lies with how the team understands the work, not with how the system behaves under load.

A team may estimate that a task will take two days of effort. That estimate might be reasonable, given what they know. But if that task sits in a review queue, or is waiting on test, or is delayed due to someone being pulled onto another “high priority” initiative, then that two-day effort turns into a ten-day cycle time. The estimate wasn’t wrong. It was irrelevant.

In a system where most of the time is spent waiting, refining the accuracy of the effort estimate achieves very little. It’s a distraction from the core issue, which is that the system is too congested to behave predictably.

## Little’s Law doesn’t care about your process

The relationship between WIP, throughput, and cycle time is not arbitrary. It’s defined by **[Little’s Law](https://en.wikipedia.org/wiki/Little%27s_law)**:

> WIP = Throughput × Cycle Time

This relationship always holds, but it depends on a key assumption: that throughput is reasonably stable. And this is where many teams fall over.

In most software teams, throughput **does** fluctuate — sometimes significantly. That variability comes from inconsistent work item sizes, unclear requirements, frequent interruptions, blockers, technical debt, lack of test automation, and reactive priorities.

Unless a team is managing WIP aggressively, working in collaboration, and applying consistent flow policies, the idea of “stable throughput” is optimistic at best and misleading at worst. This is exactly why [Scrum]({{< ref "/resources/guides/scrum-guide" >}}), [Kanban]({{< ref "/resources/guides/kanban-guide" >}}), and other flow-based systems place so much emphasis on visualising work and limiting WIP: to stabilise throughput _so_ you can get the benefits of predictability.

So yes, [Little’s Law](https://en.wikipedia.org/wiki/Little%27s_law) is always valid. But applying it usefully requires more than a theoretical understanding. It requires operational discipline. It requires systems that dampen variability rather than amplify it.

In fact, multiple industry studies and real-world examples have consistently validated this behaviour. One case study by [Troy Magennis](https://focusedobjective.com) describes a team that introduced WIP limits and began swarming on blocked work. As a result, their 85th percentile cycle time dropped from 35 days to 14 days, even after halving the team size. Meanwhile, their throughput increased from 1.07 to 1.41 stories per day (Magennis, T., _Impact of WIP Limits on Throughput and Predictability_, 2016).

Another example comes from Ultimate Software, documented in _[Making Work Visible](https://itrevolution.com/products/making-work-visible)_[ by Dominica DeGrandis](https://itrevolution.com/products/making-work-visible), where a payroll team implemented WIP limits lower than the number of developers to force collaboration. This change led to a 69% reduction in story cycle time and a 79% reduction in average queue wait time. Their conclusion was simple: controlling WIP shortened how long work spent in the system and dramatically improved predictability.

The more work you start without finishing, the longer everything takes to get done. That delay introduces variability, and that variability is what destroys the trustworthiness of your plans.

Most teams don’t lose predictability because the work is hard. They lose predictability because everything is in progress, and very little is actually flowing.

## You don’t need to measure to see the damage

You don’t need metrics dashboards to identify when WIP is too high. You can see it in the way work moves ,  or doesn’t.

If you reach the middle of a sprint and everything is “in progress” but nothing has been finished, that’s a signal. If developers are working on individual items and handing them off downstream to test or review, you’re operating a batch-and-queue system, and your flow efficiency is likely sitting around 5–15%.

That means 85–95% of the total time a work item spends in the system is just waiting. And yet we still treat the active effort as the part worth optimising.

This is why “estimating better” doesn’t help. Your estimates cover the 5–15%. The problem lives in the 85–95%.

## Collaboration is the early warning system

In my experience, if a team isn’t working together, in pairs, mobs, or focused swarms, WIP is already too high. The more localised the work, the more parallelisation. The more parallelisation, the more queues. And the more queues, the longer and more variable the cycle time.

Solo work in a collaborative delivery system isn’t faster. It’s fragmented. And it usually results in a board full of items “almost done” by the time you hit the sprint review.

There’s a reason experinced teams limit WIP to fewer items than there are people. It forces collaboration. It surfaces blockers. It reduces context switching. And it creates the conditions where delivery actually becomes predictable.

## Multitasking is just unmanaged WIP

It’s easy to hide WIP inside individual calendars. A developer working on four items in parallel is managing four invisible queues. They’ll tell you they’re “almost done” with all of them, but none of them are finished.

Every switch between tasks adds cognitive load ([Mark et al., 2005, UC Irvine](https://www.ics.uci.edu/~gmark/chi08-mark.pdf)). Studies have shown that with five parallel items, you lose up to 75% of productive time to context switching alone (Weinberg, G., _Quality Software Management: Systems Thinking_, 1992; DeMarco, T. & Lister, T., _Peopleware_, 1999).

We don’t account for this in planning. We assume that “utilised” means “productive.” It doesn’t. It means slow, error-prone, and unpredictable.

So even if each individual item is small and well-estimated, the system is still under strain. And that strain manifests as delay.

## The fix isn’t effort. It’s flow.

I’ve worked with teams that improved throughput and predictability without changing how they estimated, or increasing capacity, or working longer hours. They simply reduced WIP and focused on finishing.

Another example comes from a workshop documented by Julia Wester and Daniel Vacanti, where a team reduced their average cycle time by 55% over four sprints by combining visible WIP limits with service level expectations. There was no change to the work, the people, or the tooling. The only thing that changed was the system of work: work was finished before starting more, blockers were made visible, and delivery became more even. This kind of operational clarity consistently outperforms speculative estimation.

They didn’t do more work. They just stopped pretending that all the started work was progress.

The result? Less stress. Fewer surprises. And a forecast that didn’t fall apart after day two.

## If you want predictability, stop flooding the system

You don’t get predictability from planning harder.

You get it from flow. You get it when work finishes at a consistent rate. You get it when the system is stable enough that estimates are actually meaningful.

If you’re struggling with predictability, don’t start with estimation. Start with WIP. Look at how many items are currently in progress. Look at how long they’ve been sitting. Look at how many are waiting on something else to move first.

Then ask: what would happen if we cut our WIP in half?

What would we have to do differently to actually finish things instead of constantly starting new ones?

That’s where predictability begins, not in a planning session, but in the shape and health of the system itself.

---

## References

- Wester, J. & Vacanti, D. (2019). _Actionable Agile Metrics for Predictability_. Leanpub. [https://www.actionableagile.com/book](https://www.actionableagile.com/book)
- Magennis, T. (2016). _Impact of WIP Limits on Throughput and Predictability_. Focused Objective. [https://focusedobjective.com](https://focusedobjective.com)
- Mark, G., Gonzalez, V. M., & Harris, J. (2005). _No Task Left Behind? Examining the Nature of Fragmented Work_. UC Irvine, CHI Conference. [https://www.ics.uci.edu/\~gmark/chi08-mark.pdf](https://www.ics.uci.edu/~gmark/chi08-mark.pdf)
- Weinberg, G. (1992). _Quality Software Management: Systems Thinking_. Dorset House Publishing. [https://www.dorsethouse.com/books/qsmvol1.html](https://www.dorsethouse.com/books/qsmvol1.html)
- DeMarco, T. & Lister, T. (1999). _Peopleware: Productive Projects and Teams_. Dorset House Publishing. [https://www.dorsethouse.com/books/peopleware.html](https://www.dorsethouse.com/books/peopleware.html)
- Magennis, T. (2016). _Impact of WIP Limits on Throughput and Predictability_. [https://focusedobjective.com](https://focusedobjective.com)
- DeGrandis, D. (2017). _Making Work Visible: Exposing Time Theft to Optimize Work & Flow_. IT Revolution Press. [https://itrevolution.com/products/making-work-visible](https://itrevolution.com/products/making-work-visible)
