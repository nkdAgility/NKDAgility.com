---
title: Stop Promoting Branches
description: Explore how audience-based deployment, also known as ring-based deployment, challenges traditional environments, accelerates feedback, and transforms continuous delivery.
ResourceId: x7ra7pQCDX5
ResourceType: blog
ResourceContentOrigin: Hybrid
ResourceImport: false
date: 2025-02-06T09:00:00
weight: 305
AudioNative: true
creator: Martin Hinshelwood
contributors:
- name: Benjamin Day
  external: https://www.linkedin.com/in/benjaminpday/
layout: blog
resourceTypes: blog
slug: stop-promoting-branches
aliases:
- /resources/x7ra7pQCDX5
aliasesArchive:
- /stop-promoting-branches
- /blog/stop-promoting-branches
tags:
- Software Development
- Modern Source Control
- Continuous Integration
- Value Delivery
- Release Management
- Software Developers
- Continuous Delivery
- Engineering Practices
- Deployment Strategies
- Practical Techniques and Tooling
categories:
- DevOps
preview: 2025-02-06-stop-promoting-branches.jpg
marketing: []

---
The traditional Dev → Test → Staging → Production model is flawed, leading to unnecessary complexity and reinforcing outdated software delivery patterns. This breakdown explains why branch promotion is a failure mode, why GitHub Flow and Release Flow are reasonable alternatives, and why Git Flow belongs in the bin.

## TL;DR

If teams still promote code through a Dev → Test → Staging → Production model, they are doing it wrong. This model inevitably leads to a **branch promotion strategy**, adding friction, increasing risk, and delaying value delivery.

- **GitHub Flow is a simple option for continuous delivery.**
- **Release Flow is a good choice when production needs to exist for some time.**
- **Git Flow? That bloated mess belongs in the past.**

Branching should be a tool to support flow, not an administrative overhead that slows everything down. If a model requires multiple merges to get code into production, **it is already behind.** Reverse integration, which involves pulling changes from downstream branches back into upstream branches, is fraught with danger and should be avoided.

## The Failure of the branch Promotion Model

This model was meant to provide structure and control, but in practice, it leads to teams **confusing environments with branches**.

The typical pattern looks like this:

1. Code is committed to a **Dev branch**.
2. It moves to a **Test branch** for QA.
3. It advances to a **Staging branch** for approval.
4. It is finally merged into **Production**.

What started as an environment management strategy **becomes a branch promotion model**, where:

- Features wait in queues instead of shipping immediately.
- Merge conflicts create unnecessary rework.
- Hotfixes bypass the process, breaking consistency.
- Rollbacks require painful cherry-picking instead of simple toggles.
- Reverse integration causes unpredictable failures and last-minute surprises.

This is a linear, gated approach that **kills agility**. Instead of focusing on **delivering value**, teams get stuck in a cycle of merging, resolving conflicts, and firefighting. Reverse integration only amplifies the chaos, introducing instability at the worst possible moments.

## Branch Promotion is a Symptom of Organisational Dysfunction

If teams are **passing code between branches like a baton in a relay race**, they are reinforcing a broken process. This is just waterfall with more Git commands.

Instead of treating branches as milestones, teams should focus on **continuous integration and delivery**. That means:

1. Every change merges into `main` as soon as it is ready.
2. Deployment is decoupled from release using feature flags.
3. Testing happens in production-like environments without blocking releases.
4. Rollbacks are instant; simply toggle a flag instead of reverting code.

Reverse integration breaks this model by introducing last-minute, untested changes into upstream branches, increasing risk and eroding confidence in deployments. Instead of integrating forward with stability, teams are forced into reactive fixes that create further instability.

This eliminates the bottlenecks of branch promotion. Instead of waiting weeks for a merge to move through environments, **code is always deployable**.

### Supporting Multiple Versions in Production

Branch promotion models often significantly increase cognitive load as engineers may be forced to support multiple versions in production. This excessive complexity increases the chances of reverse integration, where engineers must back-port features and fixes to different production versions, introducing further instability.

In these scenarios, Developers face constant challenges in tracking which code changes apply to which versions, leading to a higher risk of errors and regressions. Maintaining multiple live versions not only complicates testing, debugging, and feature rollouts but also makes it nearly impossible to ensure consistency across environments.

An extreme version of this is branch-by-customer, where separate branches are maintained for different clients. This is one of the most unmanageable and expensive practices, requiring extensive manual effort to maintain, patch, and update. Merging changes across multiple customer-specific branches is error-prone and time-consuming, leading to unpredictable behaviour and instability. Avoid at all costs.

### Git Flow

Git Flow was an attempt to support many of the old branching models, but it is a bloated relic that needs to die! If teams are still using Git Flow, it is time to stop.

It introduces:

- A develop branch that adds unnecessary friction as it needs to be integrated into main.
- `release/\*` branches that delay deployment.
- `hotfix/\*` branches that signal a broken process.

Teams that adopt Git Flow reinvent branch promotion, creating an overcomplicated merge-heavy workflow that belongs in the past.

## Mainline Branching Practices

The alternative is to use trunk or mainline development where all code is integrated continuously into the main, and there are only ever short-lived topic branches for a few developers to work together on something small.

The two main options relevant here are GitHub Flow and Release Flow.

### GitHub Flow

One of the easiest to understand, implement, and do well is GitHub Flow. For most teams its the only branching model they will need as it provides that speed and simplicity that enable fast turnarounds and low cognitive load. It looks like:

1. Developers work in **short-lived feature branches**.
2. They open a **pull request** against `main`.
3. Code is reviewed, merged, and **deployed immediately**.

One would expect the pull request to be as automated as possible within the context of modern software engineering practices:

- **Automated tests** to validate every change.
- **Continuous deployment** to eliminate hand-offs.
- **Observability and monitoring** to detect issues early.

Reverse integration is **completely unnecessary** in GitHub Flow because all changes integrate forward, reducing complexity and risk.

### Release Flow

For teams that need to support multiple versions in production, **Microsoft’s Release Flow** extends GitHub Flow without unnecessary complexity for the specific purpose of having a release version that you need to help until the next release is ready. Microsoft developed this because it took longer than their 3 weeks for Sprint to deploy new versions of Azure DevOps to the thousands of databases that they used.

- All work merges into `main`.
- When a release is ready, a **version branch** (e.g., `release/1.2`) is created.
- Fixes are always made into the main and cherry-picked into the release branches or, if necessary, implemented again.

This keeps development fast **while maintaining stability where needed**. It avoids regression by always fixing into \`main\`. Critically, Release Flow continues to **avoid the pitfalls of reverse integration**, ensuring that all changes move forward in a controlled, predictable manner.

## Keep It Simple, Keep It Fast

Branching should enable fast delivery, not slow it down.

- **Want to ship continuously? Use GitHub Flow.**
- **Need to maintain live versions? Use Release Flow.**

If teams still promote branches through environments, **it is time to rethink the strategy**. Reverse integration is a dangerous practice that adds unnecessary risk and complexity. The best branching model is the one that gets in the way the least. **Stop promoting branches. Start delivering value.**
