---
title: Stop Hiding Behind Complexity and Start Delivering Continuously
description: Unlock continuous delivery for any software, regardless of complexity. Invest in fixing technical debt and automate processes for faster, reliable releases.
ResourceId: 7hEAycZIn8w
ResourceType: blog
ResourceImport: false
date: 2025-02-24T09:00:00
AudioNative: true
creator: Martin Hinshelwood
layout: blog
resourceTypes: blog
slug: stop-hiding-behind-complexity-deliver-continuously
aliases:
  - /resources/7hEAycZIn8w
aliasesFor404:
  - /stop-hiding-behind-complexity-deliver-continuously
  - /blog/stop-hiding-behind-complexity-deliver-continuously
  - /stop-hiding-behind-complexity-and-start-delivering-continuously
  - /blog/stop-hiding-behind-complexity-and-start-delivering-continuously
tags:
  - Value Delivery
  - Software Development
  - Continuous Delivery
  - Product Delivery
  - Frequent Releases
categories:
  - DevOps
preview: 2025-02-24-stop-hiding-behind-complexity-deliver-continuously.jpg
---

Every organisation says their software is 'too complex' for continuous delivery. That's nonsense. Complexity is an excuse, not a blocker. Azure DevOps, Starbucks, and countless others proved it wrong. The only real obstacle is the resistance to invest in fixing what’s broken. Complexity is an excuse, not a blocker. Microsoft proved it. Starbucks proved it. You can too—if you’re willing to pay down your technical debt.

Continuous delivery is not a pipe dream. If the organisation is willing to invest, it’s achievable for every software product, regardless of complexity or legacy constraints. And that's the challenge.

The organisation must be willing to invest significant time and effort in enabling it. Microsoft's Azure DevOps team exemplifies this. They transitioned from shipping new features every two years to delivering value every three weeks, increasing their annual feature delivery from 25 to nearly 300 at their peak.

This evolution was not the result of a silver bullet but a deliberate effort to eliminate technical debt, automate relentlessly, and embed a culture of continuous improvement. It is an ongoing evolution that has paid dividends for every year of effort invested. They delivered 58 features at the end of the first year of investment, rising to over 250 features after six years.

> TLDR; Every software system, no matter how complex or archaic, can be updated, tested, and deployed continuously—without delays, bottlenecks, or manual interventions. This is the core of Continuous Delivery (CD): software always in a deployable state, ready for frequent, reliable releases.

## What is holding you back?

Many teams believe they cannot achieve continuous delivery and instead claim:

- Their product is too big and complex
- Their teams lack the skills
- It’s not possible in their regulated industry

Every single one of these justifications is illegitimate and reflects either the team's unwillingness to learn or the leadership's unwillingness to invest. These are excuses, not realities.

**In reality, systemic and continuous underinvestment in quality, scalable, and supportable products is to blame.**

This failure is not driven by the engineers or managers doing the work, but they have enabled it. The cause lies squarely in the business, even if they did not consciously make it.

> "If you put people under pressure to deliver, they will increasingly and systemically decrease quality to meet whatever ridiculous deadlines you give them."

The result is unchecked technical debt, high bug rates in production, significant rework, and unmet expectations.

This is not a terminal condition but a challenge to manage and overcome. The key lies in intentionality. Without tackling the root causes of complexity for new capabilities, slow releases, and frequent production issues, process changes will fail to deliver meaningful results.

## The Evolution of the Developer Division at Microsoft

Like every other company that has built software at scale, Microsoft fell into the usual traps of long release cycles, single-pass coding, and poor testing quality. For the Developer Division—responsible for Visual Studio, Team Foundation Server, and other software engineering tools—this resulted in a two-year release cycle, a four-year customer feedback loop, and fixing 75,000 bugs to get Visual Studio 2010 out the door.

Market forces pushed them to evolve. They could no longer meet the demands of an increasingly dynamic market, and a four-year response time to customer needs was unsustainable. While laggards might remain, it's the early adopters who drive new business and shape emerging markets. Failing to keep them engaged signals a decline that, if left unchecked, can be fatal—but recovery is possible with decisive action.

Azure DevOps emerged as the result of decisive action by Microsoft's Developer Division, triggered by an urgent need to break free from their two-year release cycle and four-year customer feedback loop. They didn't inherit perfection—they faced legacy code, fragmented processes, and a monolithic release cycle. Their transformation began with small, incremental changes, but success required deeper, systemic shifts:

- **Automate Everything**: This cannot be emphasised enough. Automate every possible task. If something cannot be automated today, create a plan to rework the architecture until it can be. From testing and deployments to upgrades, certificates, passwords, and environments—automation should be the default, not the exception.

- **Trunk-Based Development**: The cognitive load and resulting technical debt from supporting multiple versions of your product significantly increases complexity and risk. Long-running branches, especially when promoting by branch, slow the delivery of working software to real users. Adopting [Trunk-Based Development practices](https://nkdagility.com/resources/blog/stop-promoting-branches/) eliminates this risk by ensuring that all code integrates continuously into a single shared branch.&#x20;

- **Feature Flags**: To maximise both quality and value, it's essential to [test new capabilities in production](https://nkdagility.com/resources/blog/testing-in-production-maximises-quality-and-value/) while gradually exposing them to users, reducing risk. This approach shortens feedback loops and enables swift adaptation to emerging market opportunities. Since we can't predict which features will deliver the most value, we validate hypotheses by running small experiments with real data. Effective use of feature flags is crucial for these experiments, ensuring safe, controlled releases that drive continuous improvement.

- **Shift-Left**: Shift from testing quality at the end (QA, Staging, UAT) to embedding it throughout the development process. Use hypothesis-driven practices and unit tests at every stage to ensure high quality from the start. Discovering a security vulnerability in staging often means the flaw is deeply embedded, leaving no time or budget for proper fixes—only quick patches that hackers easily exploit. Instead, conduct security tests, code reviews, and performance checks continuously, as close to code creation as possible.

- **Iterate Over Pain**: If a task is hard or error-prone, you should do it more often. Any activity, like releasing, that feels difficult or frequently leads to errors deserves focused attention. Repeated practice exposes weak points, allowing you to refine the process and reduce risk. Avoiding the pain only ensures it remains a persistent threat.

## What can we learn?

If you want to be able to adapt to market opportunities or surprises, then you need to be able to shift quickly. This means that any software system, regardless of its complexity, architecture, or purpose, should be updated, tested, and deployed in a continuous flow without delays, bottlenecks, or manual interventions. This is the ethos of Continuous Delivery (CD), where software is always in a deployable state, enabling frequent and reliable releases.

In the world of modern software engineering its no longer an optional thing. It's a business demand.  Too many business opportunities have been missed because we are too slow to deliver and too slow to turn feedback into usable working products on a short enough timeline.

How short your timeline needs to be is a question for your business... what is your effective planning horizon. For Starbucks PoS its 48h; for Windows, its \~120h, for Facebook its just a few minutes.

To measure velocity, Azure DevOps focused on four critical metrics:

- Time to Build
- Time to Self-Test
- Time to Deploy
- Time to Learn

Evidence-based management would ask you to consider how these metrics directly influence your delivery velocity and ability to adapt quickly:

- Release Frequency
- Customer Cycle Time
- Deployment Frequency
- Time-to-Learn
- Time to Pivot

## The Path Forward

Ultimately, when deployments are automated, code is well-tested, and processes are streamlined, teams can respond faster to customer needs, market changes, and business opportunities. Azure DevOps’ and Windows evolutions proved that the barrier to continuous delivery is not technical complexity but organisational will.

No matter where you start, the path to continuous delivery is through addressing technical debt head-on. Prioritise automation, enforce code quality and relentlessly improve your processes. The result is not just faster releases but better software, happier teams, and more satisfied customers.

If Azure DevOps can do it with their scale and complexity, so can you.

The only question is whether you're willing to do what Azure DevOps, Starbucks, and countless others have done: stop hiding behind complexity, pay down your technical debt, and start delivering continuously.
