---
title: Definition of Ready
abstract: Definition of Ready (DoR) is a concept within the Scrum framework that outlines the criteria necessary for a Backlog Item to be considered ready for implementation by the development team. It emerges from the collaborative understanding among Developers, the Product Owner, and Stakeholders regarding what is required to proceed with a Backlog Item. The importance of DoR lies in its potential to enhance clarity and alignment within agile teams, yet it also presents challenges, such as creating a false sense of readiness, neglecting the need for ongoing refinement, and leading to misconceptions about its equivalence with the Definition of Done (DoD). Unlike the DoD, which is an absolute measure of completion, the subjective nature of DoR can result in partial implementation, risking the integrity of the development process. To mitigate these issues, it is suggested that teams adopt a more nuanced approach to defining readiness, ensuring that each Backlog Item meets specific criteria, such as having a clear outcome, hypothesis, and telemetry for evaluation. The INVEST criteria further guide the formulation of Product Backlog Items, emphasising their independence, negotiability, value, estimability, size, and testability. Ultimately, a well-defined DoR fosters effective communication and understanding within agile teams, contributing to successful product development and organisational design.
ClassificationType: tags
ClassificationContentOrigin: human
trustpilot: false
date: 2025-02-11T10:17:24Z
description: Ensuring backlog items meet a clear, actionable standard before sprint planning.
Instructions: |-
  **Use this category only for discussions on Definition of Ready.**  
  The Definition of Ready (DoR) is a crucial Agile practice that ensures backlog items are well-defined and actionable before they enter the sprint planning phase. It serves as a checklist to confirm that user stories or tasks are sufficiently detailed, understood, and feasible for the development team to work on, thereby enhancing the efficiency and effectiveness of the sprint process.

  **Key Topics:**
  - Criteria for establishing a Definition of Ready.
  - Importance of clarity and detail in backlog items.
  - Role of the Product Owner in defining readiness.
  - Techniques for refining user stories to meet DoR.
  - Impact of a well-defined DoR on sprint planning and execution.
  - Common pitfalls in defining backlog items and how to avoid them.
  - Collaboration between team members to achieve a shared understanding of readiness.

  **Strictly exclude:**
  - Discussions on Definition of Done, as it pertains to the completion of work rather than its readiness.
  - General Agile principles that do not specifically address the criteria for backlog item readiness.
  - Misinterpretations of the DoR that deviate from its purpose of ensuring actionable standards for sprint planning.
headline:
  cards: []
  title: Definition of Ready
  subtitle: Establishing clear criteria for backlog items to ensure readiness for effective planning and execution in iterative workflows.
  content: Establishing actionable criteria for backlog items ensures they are well-defined and ready for prioritisation and execution. Posts should explore techniques for clarifying requirements, enhancing collaboration, and improving workflow efficiency, drawing insights from frameworks and methodologies that support iterative development and continuous improvement.
  updated: 2025-02-13T12:05:02Z
aliases:
- /practices/Definition-of-Ready-DoR.html
- /learn/agile-delivery-kit/practices/definition-of-ready-dor
- /resources/afLYe__TZKq
aliasesArchive:
- /practices/Definition-of-Ready-DoR.html
- /learn/agile-delivery-kit/practices/definition-of-ready-dor
concepts:
- Artifact
sitemap:
  filename: sitemap.xml
  priority: 0.7

---
Definition of Ready (DoR) is an artifact.

From the perspective of Scrum, the idea of Ready, as applied to a Backlog Item, represents everyone's (Developers, Product Owner, & Stakeholders) understanding of what is needed to implement that Backlog Item. Since this is subjective and not objective, having a definition of what constitutes ready is not possible.

The danger of having a defined definition of Ready (DoR) is:

- **False sense of Ready** - First that it creates a false sense of Ready that encompasses the objective points that we can focus on, but misses the subjective. This can lead to false gating, where participants hold each other accountable for failing to achieve something that was not defined in the first place.
- **Neglecting Refinement** - If things are "ready" then why would we have to understand it better!
- **False Equivalence with DoD** - Using the DoR terminology generally leads participants to feel that the DoD and the DoR have an equivalence. This is dangerous as the DoD is an absolute boolean proposition, while the subjective nature of the DoR may lead it to be only partially implemented. If it's OK to only partially achieve the DoR, the logical fallacy is that the DoD can also be partially implemented.

A solution that may enable the effective use of this practice may be to a different formula of naming to create disambiguation between the DoR and the DoD.

## Backlog Candidacy Test

Every candidate Backlog Item should have:

- has a clear outcome or objective.
- contains a clear hypothesis.
- defignes clear telemetry to be collected.

Once candidacy is achieved then the Team & Stakehodlers can determin Ready with conversation.

## Rule of Thumb

_As a general rule Developers should not take Backlog Item into a Sprint that they do not fully understand and agree, as a team, that there is a reasonable likelihood of being successful._

## INVEST

- I (Independent). The PBI should be self-contained and it should be possible to bring it into progress without a dependency upon another PBI or an external resource.
- N (Negotiable). A good PBI should leave room for discussion regarding its optimal implementation.
- V (Valuable). The value a PBI delivers to stakeholders should be clear.
- E (Estimable). A PBI must have a size relative to other PBIs.
- S (Small). PBIs should be small enough to estimate with reasonable accuracy and to plan into a time-box such as a Sprint.
- T (Testable). Each PBI should have clear acceptance criteria which allow its satisfaction to be tested.
