---
title: Site Reliability Engineering
abstract: Site Reliability Engineering (SRE) is a discipline that utilises software engineering principles to develop scalable and reliable systems, effectively bridging the gap between development and operations. Originating from the need to embed reliability within the software development lifecycle, SRE ensures that systems maintain functionality and resilience under diverse conditions. This methodology prioritises automation, monitoring, and incident response, which allows teams to deliver consistent value in a sustainable manner. SRE teams establish service level objectives (SLOs) and service level indicators (SLIs) to create clear performance and reliability metrics, fostering a culture of accountability and continuous improvement. This proactive approach to problem-solving and engineering solutions to operational challenges enhances overall system performance, distinguishing SRE from traditional operations roles. By promoting shared responsibility for reliability across teams, SRE encourages collaboration and knowledge sharing, which not only improves user satisfaction but also drives positive business outcomes. Ultimately, the integration of reliability into the development process supports organisational strategic goals and enhances competitive advantage, making SRE a vital component in agile, DevOps, and product development frameworks.
ClassificationType: tags
ClassificationContentOrigin: AI
trustpilot: false
ResourceId: K0i7PIZARDw
date: 2025-05-05T10:17:24Z
weight: 175
description: Applying software engineering principles to ensure scalable and reliable systems.
aliases:
- /learn/agile-delivery-kit/practices/site-reliability-engineering-sre
- /resources/practices/site-reliability-engineering-sre/
- /resources/K0i7PIZARDw
Instructions: |-
  **Use this category only for discussions on Site Reliability Engineering.**  
  The purpose of this category is to explore the application of software engineering principles to enhance the reliability, scalability, and performance of systems in production environments. It focuses on the integration of development and operations to create resilient systems that can withstand failures and maintain service quality.

  **Key topics that should be discussed under this category:**
  - Principles of Site Reliability Engineering (SRE) as defined by Google.
  - The role of SRE in bridging the gap between development and operations.
  - Best practices for monitoring, incident response, and post-mortem analysis.
  - The use of Service Level Objectives (SLOs), Service Level Indicators (SLIs), and Service Level Agreements (SLAs).
  - Automation and tooling to improve system reliability and reduce manual intervention.
  - Capacity planning and performance optimisation strategies.
  - The impact of culture and collaboration on reliability engineering.
  - Case studies and real-world applications of SRE principles.

  **Strictly exclude** any discussions that do not directly relate to the principles and practices of Site Reliability Engineering, such as general software development practices, unrelated DevOps topics, or Agile methodologies that do not specifically address reliability in production systems.
headline:
  cards: []
  title: Site Reliability Engineering
  subtitle: Ensuring robust and scalable systems through engineering practices and continuous improvement methodologies.
  content: Integrating software engineering principles with operational practices to enhance system reliability and scalability. Posts should explore incident management, performance monitoring, automation strategies, and the cultural aspects of collaboration between development and operations teams, fostering a proactive approach to system resilience and user satisfaction.
  updated: 2025-02-13T12:02:19Z
sitemap:
  filename: sitemap.xml
  priority: 0.7
BodyContentGenDate: 2025-04-09T13:12:47
concepts:
- Capability
categories:
- DevOps
- Engineering Excellence
tags:
- Software Development
- Operational Practices
- Metrics and Learning
- Technical Mastery
- Pragmatic Thinking
- Team Performance
- Product Delivery
- Engineering Practices
- Market Adaptability
- Continuous Improvement
- Service Level Expectation
- Value Delivery
- Technical Excellence
icon: fa-shield-alt

---
Site Reliability Engineering (SRE) is not a job title; it is an ethos. It is the disciplined application of software engineering principles to design, build, and operate reliable, scalable systems. And it is essential if you want to survive modern software delivery.

SRE builds resilience by design, not by accident. It makes reliability a first-class product feature: measured, automated, and continuously improved. This ethos aligns perfectly with the Azure DevOps journey — moving from on-premises to SaaS, from two-year release cycles to daily deployments, and from siloed development to integrated, accountable delivery.

With the shift-left movement pushing more operational accountability onto engineering teams, the old excuses no longer work. Feature teams can no longer shrug and say, “Ops will handle it.” They own their live site experience end-to-end — from ideation to validation, from code to customer.

Here’s what that demands:

- **Transparency**: Teams need visibility into what’s happening in production. Not vague guesses, but hard telemetry. Service Level Objectives (SLOs) and Service Level Indicators (SLIs) are non-negotiable. If you can’t see it, you can’t manage it.
- **Telemetry**: Instrument everything. Capture user-facing metrics, not just server uptime. Focus on failed or slow user minutes. That’s what customers feel. That’s what matters.
- **On-Call Discipline**: Resilience is not about heroism; it’s about system design. But when incidents happen, teams must be ready. That means practiced, well-understood on-call rotations, pre-delegated authority, and rehearsed recovery plans. Top-down control is a liability in a crisis. Empowered teams move fast.
- **Feature Team Protection**: While feature teams own their work, they cannot be buried under endless incident noise. SRE practices like progressive rollouts, feature toggles, circuit breakers, and automated rollback are critical. They let teams learn from production without drowning in it.

The Azure DevOps Services team learned this the hard way. Moving from a monolithic, on-premises delivery model to SaaS forced a fundamental rethink. They didn’t just automate pipelines. They embedded a production-first mindset, shifting quality left, closing feedback loops, and treating resilience as part of the Definition of Done.

Their key lessons:

- **Automate everything**: Deployments, rollbacks, recoveries — no heroics, just engineering.
- **Iterate over pain**: If something hurts, do it more often until it stops hurting.
- **Build for failure**: Circuit breakers, graceful degradation, progressive delivery — resilience by design, not by wish.
- **Treat resilience as an investment**: Downtime kills trust. Outages cost revenue. Slow recovery erodes morale. Resilience pays for itself.

SRE and DevOps together deliver continuous value. DevOps brings the union of people, process, and products; SRE ensures that union runs reliably under real-world stress. This is not about vanity metrics or theatre. It is about evidence-based management — metrics like Mean Time to Recovery (MTTR), deployment frequency, and customer satisfaction that tell you whether your resilience investments are delivering.

Bottom line: if your teams are not actively designing, measuring, and improving resilience, you are not running a serious engineering organisation. You are just hoping you survive the next failure.

Stop hoping. Start engineering.
