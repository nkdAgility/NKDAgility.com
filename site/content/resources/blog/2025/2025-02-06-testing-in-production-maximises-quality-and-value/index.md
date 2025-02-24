---
title: Testing in Production Maximises Quality and Value
description: Explore how audience-based deployment, also known as ring-based deployment, challenges traditional environments, accelerates feedback, and transforms continuous delivery.
ResourceId: _ncZFfeCrnS
ResourceType: blog
ResourceImport: false
date: 2025-02-13T09:00:00
AudioNative: true
creator: Martin Hinshelwood
contributors:
- name: Benjamin Day
  external: https://www.linkedin.com/in/benjaminpday/
- name: Dave Westgarth
  external: https://www.linkedin.com/in/dave-westgarth/
- name: Vladimir Khvostov
  external: https://www.linkedin.com/in/vladimirkhvostov/
layout: blog
resourceTypes: blog
slug: testing-in-production-maximises-quality-and-value
aliases:
- /resources/_ncZFfeCrnS
aliasesFor404:
- /testing-in-production-maximises-quality-and-value
- /blog/testing-in-production-maximises-quality-and-value
tags:
- Deployment Strategies
- Software Development
- Continuous Delivery
- Azure DevOps
- Product Delivery
- Value Delivery
- Software Developers
- Technical Excellence
- Technical Mastery
- Operational Practices
categories:
- DevOps
- Engineering Excellence
preview: 2025-02-06-testing-in-production-maximises-quality-and-value.jpg
marketing: []

---
Testing in production, is about structured, observable releases that allow for fast feedback, controlled exposure, and rapid course correction, ensuring quality without sacrificing speed.

One such paradigm shift in software delivery is audience-based deployment.

Gone are the days of rigid Dev-Test-Staging-Production pipelines. These [traditional environments are costly, slow, and fundamentally flawed]({{< ref "/resources/blog/2025/2025-02-06-stop-promoting-branches" >}}). They delay feedback loops, hinder innovation, and reinforce outdated notions of software stability.

Instead, modern software engineering demands a smarter approach: deploying directly to real users in production but in a controlled, incremental manner.

For those familiar with ring-based deployment, audience-based deployment is not a new concept; it expands on it. Ring-based deployment is a proven strategy, widely used at scale by companies like Microsoft with products like Windows and Microsoft Teams. Audience-based deployment simply extends this principle by providing even finer-grained control over who gets access to a given change based on account types, user profiles, or organisational groups. This approach allows teams, like the Azure DevOps team, to release software to small, targeted user groups, enabling faster feedback, reduced blast radius, and progressive rollout strategies.

This approach enables:

- **Faster feedback** from real-world conditions, not simulated test environments.
- **Reduced blast radius** by limiting exposure of potentially risky changes.
- **Progressive rollout strategies**, improving resilience and adaptability.

### Retaining Context Without Environmental Branching

While you may need to retain some environmental context for compliance or operational reasons, **your branching structure should not model it**. Creating branches that mimic Dev-Test-Staging environments is costly and counterproductive. It increases complexity, delays feedback, and reinforces silos rather than fostering continuous delivery. Instead, focus on:

- Using **feature flags** to control exposure.
- Implementing **progressive rollouts** instead of environment-based branching.
- Relying on **observability and monitoring** rather than artificial environments.

By shifting away from rigid environment-based branching, teams can iterate faster and detect issues in real-world scenarios without unnecessary overhead.

I don't think this is easy; it's not. Teams making this shift face teething problems; adapting workflows, enhancing observability, and upskilling in DevOps and CI/CD practices. Success here isn't just technical; it's cultural. Organisations must embrace automation, foster real-time monitoring capabilities, and embed progressive delivery into their engineering ethos. It requires significant discipline and a relentless focus on the usable working product that many teams just don't have.

### How Microsoft Transformed Deployment

Microsoft’s transformation to DevOps and audience-based deployment has been an industry-defining journey, starting with the Visual Studio and Azure DevOps (was Team Foundation Server) teams in the Developer Division and later extending to Windows and Office.

**Key Lessons from Microsoft’s Evolution:**

- **Be Customer Obsessed** – Prioritise user experience and collect telemetry to refine deployments.
- **Iterate Over Pain** – If it's hard and painful, do it more often until it becomes just another activity.
- **Adopt a Production-First Mindset** – Deploy as continuously as possible, with safeguards to protect end-users.
- **Enable Team Autonomy with Enterprise Alignment** – Empower teams while ensuring strategic cohesion.
- **Shift Left on Quality** – Detect and address issues earlier in the development cycle.

These were hard-learned lessons from the transition of Team Foundation Server from one delivery every two years to one every three weeks. This was also the catalyst for them to move their product to the cloud, ultimately leading to the Azure DevOps product we have today. There was a key realisation that closing feedback loops is much harder if you are delivering a locally installed product. Not every customer takes every release, and not every customer allows the vendor to truly understand the usage patterns.

If you want to build products that meet your customer's needs, then you need to get ahead of those needs. If you respond to customer requests, then you are too late to meet their need, and are costing them time and money while you go build what they asked for. Getting ahead of that loop, crossing the chasm, requires that you are able to engage with early adopters and collect telemetry and feedback much closer to the development cycle. Feedback on something that you shipped two years ago is largely useless if your priorities have changed since then.

Audience-based deployment allows you to control which users and which accounts get access to new features. This means that you can start to engage with early adopters even within an organisation where most users are late adopters.

This connection to the users, the telemetry it provides, and the closeness of the feedback to the build that allows you to maximise the value, the ROI, of the work that you do is the business reason to move in this direction.

## The Azure DevOps team revolutionised Microsoft’s approach.

The Azure DevOps team revolutionised Microsoft’s approach to deployment by pioneering a **ring-based deployment strategy** that allowed for:

1. **Incremental feature releases** with real-time telemetry analysis.
2. **Production-first mindset**, shifting quality assurance left.
3. **Automated stops to rollouts triggered by observed failures.**
4. **Continuous monitoring** to reduce release risk.

This strategy proved so effective that it became the foundation for deploying changes to **Windows**, an operating system with a vastly larger and more diverse user base. And more scary indeed is that Windows is an installed product that needs to support an almost infinite set of configurations.

#### Windows: Scaling the Model to Millions

Windows took inspiration from Azure DevOps' success and implemented the ring-based model at an unprecedented scale:

1. **Internal to Microsoft** - Im not necessarily privy to the details of this, but there have been hints and stories told by folks on the inside. (\~70,000 members)

   1. Internal Channel - Nightly changes tested internally by a small subset of engineers.
   2. Dogfooding Channel – Microsoft employees use new versions before external customers.

2. **Windows Insider Program** - Anyone can join this just by opting in. (\~17m members)

   1. **Canary Channel** – This is for highly technical users who get builds from the dev branch every few days.
   2. **Dev Channel** – For enthusiasts; gets builds every few weeks from the dev branch
   3. **Beta Channel** - This is for early adopters and gets early builds every month or so from the release branch
   4. **Release Preview** - For those looking for just an early peek but want stability. Builds every 3 months or so from the release branch about 3 months before they hit GA.

3. **General Availability** - Finally, changes are staged and rolled out to everyone else (\~900bn machines worldwide)

This approach enables them to:

- **Detect failures early**, before they affect millions of users.
- **Refine features based on telemetry and user behaviour**.
- **Confidently scale releases** while maintaining stability.

This isn’t just DevOps done well; it’s a learning engine driving continuous improvement across Microsoft’s ecosystem. Today, you will find this model and variants of it on all of Microsoft's platforms.

For example, I am in the Insider group for Microsoft Teams, with my account in R3, with both R3.5 (preview) and R4 (ga) ahead of me... and yet I can be in a call with folks from any of the rings from R0 all the way to R4. We each get different features and capabilities and a different product stability level.

### Why You Should Ditch the Old Way

Beyond the inefficiencies of traditional environments, the old way accumulates waste—relearning, duplicated effort, and maintaining outdated processes, all drain resources. Each additional environment introduces overhead in familiarization, regression testing, and upkeep, diverting attention from work that delivers actual value. The cost isn't just financial; it's an innovation tax.

Most organisations still cling to the traditional **Dev-Test-Staging-Production** model because it feels safe. But let’s be honest:

- **Testing environments are never identical to production.** Data, scale, and real-world user behaviour differences mean you’re testing a mirage.
- **Delayed feedback loops increase risk.** The longer it takes to discover issues, the harder and costlier they are to fix.
- **It stifles innovation.** Slow, gated releases hinder rapid iteration and experimentation.

The alternative? **Deploying directly to your users, but smartly.**

### Making the Shift: Key Strategies for Audience-Based Deployment

We first need to accept that rolling forward is the only viable option! If a team has just failed to roll forward, what makes us think they have the skills to execute the more complex task of rolling back? Rolling back is often more risky than pushing a fix forward, as it can introduce inconsistencies, data mismatches, and unexpected failures. The key is to **design rollouts to be fail-safe**, ensuring issues are detected early and addressed immediately without needing a complex rollback process.

> "I was a big proponent of the rolling forward strategy. 10+ years ago, I said that if a team screwed up a database upgrade, most likely they will not succeed with a database downgrade. Sometimes downgrade means data loss. When we do deployments, we upgrade binaries first by creating new VMs and switch traffic to them. We keep old VMs running for 3 hours, so that we can go back to an old binaries if we detect any user impacting issues. After 3 hours we deallocate VMs, but do not delete them. If we detect an issue 3+ hours after deployment, we can still start VMs and go back to previous binaries. When we start database upgrade, we delete old VMs. At this point there is no going back to an old binaries." -Vladimir Khvostov, Principal Software Engineer at Microsoft - Azure DevOps

The Azure DevOps team does allow for limited rollback under specific circumstances, but only for binaries, never for data.

Want to embrace audience-based deployment? Here’s how:

1. **Feature Flags & Toggles** – Control feature exposure dynamically without redeploying code.
2. **Progressive Delivery** – Gradually expand releases based on telemetry and user feedback.
3. **Real-Time Observability** – Use logging, metrics, and tracing to detect issues immediately.
4. **Automated Rollout Halts** – Deployments should automatically pause if telemetry detects anomalies or performance degradations, ensuring issues are caught before they escalate.
5. **User Opt-In Programs** – Encourage beta testers and early adopters to participate.

### The Future of Continuous Delivery

In an interconnected world, **production is the ultimate reality check.** Audience-based deployment isn’t just an evolution of DevOps,it’s the logical next step in **delivering value faster, safer, and smarter.**

The question is, **are you ready to embrace it?**

Is your team still relying on pre-production environments? What’s stopping you from adopting audience-based deployment?
