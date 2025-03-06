---
title: Definition of Done
trustpilot: false
date: 2025-02-11T10:17:24Z
description: Ensure transparency and quality with the Definition of Done (DoD). Align teams on what it means for work to be truly complete.
Instructions: |-
  **Use this category only for discussions on Definition of Done.**  
  The Definition of Done (DoD) is a critical Agile and Scrum concept that ensures transparency and quality in the delivery of work. It serves as a shared understanding among team members regarding the criteria that must be met for a product increment to be considered complete. The DoD helps to align teams on expectations and promotes accountability, ultimately leading to higher quality outcomes.

  **Key Topics:**
  - The purpose and importance of the Definition of Done in Agile and Scrum frameworks.
  - Criteria that typically comprise a Definition of Done, such as code review, testing, documentation, and acceptance criteria.
  - The role of the Definition of Done in enhancing team collaboration and communication.
  - How the Definition of Done contributes to maintaining product quality and reducing technical debt.
  - Best practices for creating, maintaining, and evolving the Definition of Done within teams.
  - The relationship between the Definition of Done and other Agile artefacts, such as the Product Backlog and Sprint Backlog.
  - Examples of effective Definitions of Done from various Agile teams and projects.

  **Strictly exclude** any discussions that deviate from the core principles of the Definition of Done, such as unrelated project management practices, non-Agile methodologies, or personal opinions on team dynamics that do not directly relate to the DoD.
headline:
  cards: []
  title: Definition of Done (DoD)
  subtitle: Ensuring Quality, Transparency, and Releasability
  content: The **Definition of Done (DoD)** establishes a shared understanding of what makes a product increment **complete and releasable**, ensuring all work meets a **minimum quality standard**. It enhances transparency, consistency, and empirical decision-making by providing clear criteria for done work. This includes an Organisational Definition of Done that applies across teams, with team-specific extensions as needed. A well-defined DoD is essential for adaptation, accountability, and delivering valuable, verifiable, and production-ready increments.
  updated: 2025-02-13T12:05:05Z
---

The **Definition of Done (DoD)** establishes a shared understanding of what constitutes a **completed and releasable** product increment. It ensures that all work meets a **minimum quality standard**, providing transparency, consistency, and the ability to make **empirical decisions** based on real-world feedback.

This document outlines the **Organisational Definition of Done**, which applies across all teams, as well as **team-specific extensions** that may be necessary based on product requirements. It also highlights why the DoD is essential for **transparency, adaptation, and ensuring that every increment is valuable, verifiable, and production-ready**.

## Organisational Definition of Done

For work to be considered **Done**, it must meet the following **minimum standard**:

- **Live and in production**: The increment must be deployed and available for end users.
- **Collecting telemetry**: The increment must be instrumented with appropriate logging, monitoring, and analytics to gather data on its impact.
- **Supporting or diminishing the starting hypothesis**: The increment must validate or disprove the assumptions that justified its development.

## Team-Specific Definition of Done

Each team must define what is required for a product increment to be considered **releasable** while ensuring full compliance with the **Organisational Definition of Done**. The organisational DoD sets the **minimum quality standard** that all teams must meet. If additional criteria are needed based on product-specific requirements, teams may extend their Definition of Done beyond the organisational standard but never below it. This ensures a consistent, high-quality standard across all teams and prevents discrepancies in what is considered Done.

Each team may have additional criteria, but they must adhere to the **organisational DoD** as a minimum. Typical extensions include:

- Code is peer-reviewed and merged to main.
- Automated tests (unit, integration, performance, security) are written and pass.
- Feature flags or rollback mechanisms are in place.
- Documentation is updated.
- No critical bugs or unresolved incidents are present.
- User feedback mechanisms are implemented.

If there are multiple teams working on a single product, those teams must agree on a shared **Definition of Done** and ensure it is consistently honoured.

## Validation and Continuous Improvement

- Each deployed increment should be evaluated based on **real-world telemetry**.
- Adjustments should be made based on the evidence collected, ensuring iterative learning and refinement.
- The DoD should be reviewed periodically to incorporate evolving engineering and business needs.
- The **purpose of the Definition of Done is to provide transparency** into what has been achieved and ensure that increments are **usable and releasable**.

By **strictly adhering to and continuously refining our DoD**, we ensure that every increment is **valuable, verifiable, and ready for real-world use**.

## Why the Definition of Done Matters

The Definition of Done is more than a checklist—it is the bedrock of transparency and adaptation. Without a clear and universally understood DoD, teams risk misalignment, rework, and poor decision-making.

### Transparency

- **Shared Understanding**: The DoD ensures that every stakeholder, from developers to leadership, understands what "done" truly means.
- **Clear Expectations**: Teams, Product Managers, and business leaders operate with full visibility into what work is **ready for use versus work-in-progress**.
- **Trust in Delivery**: A well-defined DoD reduces ambiguity, improving confidence in the quality and completeness of increments.

### Enabling Adaptation

- **Empirical Decision-Making**: The DoD ensures increments are deployed with real-world telemetry, allowing teams to inspect and adapt based on actual data rather than assumptions.
- **Minimising Risk**: By enforcing rigorous completion criteria, the DoD prevents half-baked work from reaching users, reducing technical debt and ensuring fast, safe iteration.
- **Faster Feedback Loops**: A strong DoD accelerates learning, allowing teams to course-correct sooner and focus on what truly delivers value.

## Done Means Releasable

When a **Product Backlog item** or an **Increment** is described as **Done**, everyone must understand what that means. This ensures **transparency**, the foundation of any empirical system. Without a consistent Definition of Done, teams cannot know what it takes to get something finished.

A shared Definition of Done allows us to:

1. Maintain **Transparency** of what we have **Done**.
2. Understand how much work is required to deliver an item.
3. Create an agreement of what to **show at the Sprint Review**.
4. **Protect our Brand!**

A releasable product increment adheres to all aspects of quality, with **no corners cut** during development. This ensures that Product Management has the choice to release at any time, rather than requiring additional work before shipping.

The Definition of Done is the **commitment to quality for the Increment**. Creating and adhering to a usable increment that meets the DoD ensures **predictable, high-quality delivery**.
