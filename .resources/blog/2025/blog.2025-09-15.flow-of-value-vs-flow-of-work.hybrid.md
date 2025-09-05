---
title: Flow of Value vs Flow of Work – Misnomer or Useful Shorthand?
short_title: Flow of Value vs Flow of Work
description: Compares “flow of value” and “flow of work” in Kanban, explaining why only validated outcomes count as value and stressing the need for evidence, feedback, and learning.
tldr: The phrase “flow of value” is often misused in software development, as value is only confirmed when customers validate it, not just when work is completed. Teams should focus on validating outcomes quickly, breaking work into small, testable increments, and using data to cut features that do not deliver real value. To truly optimise value, ensure every item has a clear hypothesis, measure time to feedback, and prioritise learning over simply moving work through the system.
date: 2025-09-15T09:00:00Z
lastmod: 2025-09-15T09:00:00Z
weight: 60
sitemap:
  filename: sitemap.xml
  priority: 0.8
  changefreq: weekly
ResourceId: p2XfFa_1tko
ResourceImport: false
ResourceType: blog
ResourceContentOrigin: hybrid
slug: flow-of-value-vs-flow-of-work
aliases:
  - /resources/blog/flow-of-value-vs-flow-of-work-misnomer-or-useful-shorthand
  - /resources/p2XfFa_1tko
aliasesArchive:
  - /resources/blog/flow-of-value-vs-flow-of-work-misnomer-or-useful-shorthand
concepts:
  - Principle
categories:
  - Product Development
  - Engineering Excellence
  - Technical Leadership
tags:
  - Lean Principles
  - Customer Focus
  - Empirical Process Control
  - Software Development
  - Metrics and Learning
  - Lean Product Development
  - Continuous Improvement
  - Value Delivery
  - Product Validation
  - Continuous Learning
  - Agile Frameworks
  - Pragmatic Thinking
  - Flow Efficiency
  - Agile Philosophy
  - Agile Product Management
Watermarks:
  description: 2025-07-30T22:58:59Z
  tldr: 2025-08-07T12:38:44Z

---
# Flow of value vs. flow of work: misnomer or useful shorthand?

The Kanban Guide frames Kanban as a strategy to optimise the flow of value through a system. That phrase, “flow of value,” has helped teams shift from managing task queues to pursuing outcomes. But it can also obscure the truth.

_Does value actually flow? Or is it just work that moves?_

## Value is not a mystical force.

Value is validated by the customer. Never before. Until the customer confirms it solved a problem, improved their life, or moved a meaningful metric, it’s just work. Calling it “flow of value” without qualification is misleading.

In knowledge work, such as software development, services, and product discovery, most of what flows through the system is hypotheses, not guarantees. Assuming WIP equals value encourages:

- Closing tickets before a release
- Shipping features with no telemetry
- Pushing large batches through based on stakeholder opinion

It hides waste and sidesteps accountability.

The Kanban Guide helps by pointing to _potential_ value. Work items are bets, nothing more. Managing flow well means reducing the time it takes to validate whether those bets pay off.

Scrum reinforces this by focusing on maximising the potential for value, not assuming it. That is why empirical control exists: transparency, inspection, and adaptation. There is no inspection without delivery to the customer.

## Why the manufacturing metaphor fails

In manufacturing, value accumulates visibly. Raw material becomes a part. A part becomes a product. Waste is obvious. In knowledge work, it’s invisible. We’re not assembling. We’re exploring.

You don’t know if something is valuable until it’s in the hands of users. That is why “flow of value” only makes sense in hindsight. Day-to-day, you’re managing the flow of _potential_ value.

Finishing a feature doesn’t deliver value. It creates the _possibility_ of value. If no one uses it, or it solves the wrong problem, it’s a waste. Intent is not impact. That is why systems of work must optimise for learning, not motion.

Unfinished work delivers no value. It clogs the flow and delays feedback. Measuring WIP, lead time, and cycle time isn’t micro-management. It is how we ensure we’re learning fast enough.

## Useful shorthand with context

“Flow of value” is not a declaration of certainty. It is deliberate shorthand for the pursuit of work believed to be valuable. That belief isn’t enough. You need to make intent visible, validate early, and cut what doesn’t deliver. This means building systems where each item has a purpose. Why does it matter? How will we know? If those questions can’t be answered, it’s just noise.

Value isn’t defined at deployment. It begins with a hypothesis and ends with validation. Efficient delivery pipelines mean nothing if they’re optimising junk. Observability is how you fix that. Define start and end points. Limit WIP. Measure time to feedback.

Attach outcomes to cards. Acceptance criteria. OKRs. Usage metrics. Use SLEs to forecast the time to learning. In DevOps terms, version everything, automate validation, monitor behaviour, use feature flags, and ship small. Then measure. Learn. Adapt.

_If your system isn’t designed to validate outcomes, it isn’t flowing value. It is flowing assumptions._

## Radical candour: stop lying to yourselves

If you're calling every backlog item “value” and measuring success by throughput alone, you're lying to yourself. You're accountable for maximising product value, not just moving work.

Kill unvalidated work. Break big bets into small, testable increments. Use data to kill features that fail. Stop equating motion with impact.

Every item should have a testable hypothesis. Every workflow should surface whether it was delivered. Use flow metrics to measure time to feedback. Run forecasts, but act on what you learn. And stop promoting through environment-linked branches. It’s a waste. Move to trunk-based flow. Ship fast. Learn fast.

## Summary

“Flow of value” is not free. It’s not automatic. And it’s not a slogan.

It’s a claim. Claims require evidence.

Used lazily, it breeds complacency. Used rigorously, it drives alignment, urgency, and focus. That is the difference between being busy and being valuable.
