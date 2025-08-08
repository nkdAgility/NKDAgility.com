---
title: The Scrum Guide (February 2010)
short_title: The Scrum Guide (February 2010)
description: A clear summary of Scrum’s framework, roles, events, artefacts, and values, explaining how teams use Scrum to deliver value and adapt to complex problems.
date: 2010-02-01
lastmod: 2010-02-01
weight: 1000
sitemap:
  filename: sitemap.xml
  priority: 0.1
  changefreq: weekly
author:
  - Ken Schwaber
  - Jeff Sutherland
ResourceId: 59gcHh1fYtC
ResourceImport: false
ResourceType: guides
ResourceContentOrigin: human
slug: the-scrum-guide-february-2010
aliases:
  - /resources/59gcHh1fYtC
concepts: []
categories:
  - Uncategorized
tags: []
Watermarks:
  description: 2025-05-07T12:58:15Z
  short_title: 2025-07-07T16:40:32Z

---
## Acknowledgements

### General

Scrum is based on industry-accepted best practices, used and proven for decades. It is then set in an empirical process theory. As Jim Coplien once remarked to Jeff, “Everyone will like Scrum; it is what we already do when our back is against the wall.”

### People

Of the thousands of people that have contributed to Scrum, we should single out those that were instrumental in its first ten years. First there were Jeff Sutherland, working with Jeff McKenna, and Ken Schwaber with Mike Smith and Chris Martin. Scrum was first formally presented and published at OOPSLA 1995. During the next five years, Mike Beadle and Martine Devos made significant contributions. And then everyone else, without whose help Scrum wouldn’t have been refined into what it is today.

### History

The history of Scrum can already be considered long in the world of software development. To honor the first places where it was tried and refined, we honor Individual, Inc., Fidelity Investments, and IDX (now GE Medical).

## Purpose

Scrum has been used to develop complex products since the early 1990s. This paper describes how to use Scrum to build products. Scrum is not a process or a technique for building products; rather, it is a framework within which you can employ various processes and techniques. The role of Scrum is to surface the relative efficacy of your development practices so that you can improve upon them while providing a framework within which complex products can be developed.

## Scrum Theory

Scrum, which is grounded in empirical process control theory, employs an iterative, incremental approach to optimize predictability and control risk. Three pillars uphold every implementation of empirical process control:

### Transparency

Transparency ensures that aspects of the process that affect the outcome must be visible to those managing the outcomes. Not only must these aspects be transparent, but also what is being seen must be known. That is, when someone inspecting a process believes that something is done, it must be equivalent to their definition of done.

### Inspection

The various aspects of the process must be inspected frequently enough so that unacceptable variances in the process can be detected. The frequency of inspection has to take into consideration that all processes are changed by the act of inspection. A conundrum occurs when the required frequency of inspection exceeds the tolerance to inspection of the process. Fortunately, this doesn’t seem to be true of software development. The other factor is the skill and diligence of the people inspecting the work results.

### Adaptation

If the inspector determines from the inspection that one or more aspects of the process are outside acceptable limits, and that the resulting product will be unacceptable, the inspector must adjust the process or the material being processed. The adjustment must be made as quickly as possible to minimize further deviation.

There are three points for inspection and adaptation in Scrum:

- The **Daily Scrum** meeting
- The **Sprint Review and Planning** meetings
- The **Sprint Retrospective**

## Scrum Content

The Scrum framework consists of a set of Scrum Teams and their associated roles; Time-Boxes, Artifacts, and Rules.

Scrum Teams are designed to optimize flexibility and productivity. To this end, they are:

- Self-organizing
- Cross-functional
- Working in iterations

Each Scrum Team has three roles:

1. **ScrumMaster**: Responsible for ensuring the process is understood and followed.
2. **Product Owner**: Responsible for maximizing the value of the work the Scrum Team does.
3. **Team**: Does the work.

The Team consists of developers with all the skills to turn the Product Owner’s requirements into a potentially releasable piece of the product by the end of the Sprint.

Scrum employs **Time-Boxes** to create regularity. These include:

- Release Planning Meeting
- Sprint Planning Meeting
- Sprint
- Daily Scrum
- Sprint Review
- Sprint Retrospective

The heart of Scrum is a **Sprint**, an iteration of one month or less, of consistent length throughout a development effort.

Scrum employs four principal **Artifacts**:

- **Product Backlog**: Prioritized list of everything that might be needed in the product.
- **Sprint Backlog**: List of tasks to turn Product Backlog items into an increment of potentially shippable product.
- **Burndown**: Measure of remaining backlog over time.
  - **Release Burndown**: Measures remaining Product Backlog across the time of a release plan.
  - **Sprint Burndown**: Measures remaining Sprint Backlog items across the time of a Sprint.

**Rules** bind together Scrum’s time-boxes, roles, and artifacts. These are described throughout the body of the document.

> **Tip**
> When rules are not stated, users of Scrum are expected to figure out what to do. Don’t try to find a perfect solution, because the problem usually changes quickly. Instead, try something and see how it works. The inspect-and-adapt mechanisms of Scrum’s empirical nature will guide you.

---

## Scrum Roles

The Scrum Team consists of the ScrumMaster, the Product Owner, and the Team. Scrum Team members are called “pigs.” The Product Owner is the “pig” of the Product Backlog. The Team is the “pig” of the Sprint work. The ScrumMaster is the “pig” of the Scrum process. Everyone else is a “chicken.” Chickens cannot tell pigs how to do their work.

> **Tip**
> When rules are not stated, the users of Scrum are expected to figure out what to do. Don’t try to figure out a perfect solution, because the problem usually changes quickly. Instead, try something and see how it works. The inspect-and-adapt mechanisms of Scrum’s empirical nature will guide you.

### The ScrumMaster

The ScrumMaster is responsible for ensuring that the Scrum Team adheres to Scrum values, practices, and rules. The ScrumMaster helps the Scrum Team and the organization adopt Scrum. The ScrumMaster teaches the Scrum Team by coaching and by leading it to be more productive and produce higher quality products. The ScrumMaster helps the Scrum Team understand and use self-organization and cross-functionality. The ScrumMaster also helps the Scrum Team do its best in an organizational environment that may not yet be optimized for complex product development. When the ScrumMaster helps make these changes, this is called “removing impediments.” The ScrumMaster’s role is one of a servant-leader for the Scrum Team.

> **Tip**
> The ScrumMaster works with the customers and management to identify and instantiate a Product Owner. The ScrumMaster teaches the Product Owner how to do his or her job. Product Owners are expected to know how to manage to optimize value using Scrum. If they don’t, we hold the ScrumMaster accountable.
>
> The ScrumMaster may be a member of the Team; for example, a developer performing Sprint tasks. However, this often leads to conflicts when the ScrumMaster has to choose between removing impediments and performing tasks. The ScrumMaster should never be the Product Owner.

### The Product Owner

The Product Owner is the one and only person responsible for managing the Product Backlog and ensuring the value of the work the Team performs. This person maintains the Product Backlog and ensures that it is visible to everyone. Everyone knows what items have the highest priority, so everyone knows what will be worked on. The Product Owner is one person, not a committee. Committees may exist that advise or influence this person, but people who want to change an item’s priority have to convince the Product Owner.

Companies that adopt Scrum may find it influences their methods for setting priorities and requirements over time.

For the Product Owner to succeed, everyone in the organization has to respect his or her decisions. No one is allowed to tell the Team to work from a different set of priorities, and Teams aren’t allowed to listen to anyone who says otherwise. The Product Owner’s decisions are visible in the content and prioritization of the Product Backlog. This visibility requires the Product Owner to do his or her best, and it makes the role of Product Owner both a demanding and a rewarding one.

> **Tip**
> For commercial development, the Product Owner may be the product manager. For in-house development efforts, the Product Owner could be the manager of the business function that is being automated.
>
> The Product Owner can be a Team member, also doing development work. This additional responsibility may cut into the Product Owner’s ability to work with stakeholders. However, the Product Owner can never be the ScrumMaster.

### The Team

Teams of developers turn Product Backlog into increments of potentially shippable functionality every Sprint. Teams are also cross-functional; Team members must have all of the skills necessary to create an increment of work. Team members often have specialized skills, such as programming, quality control, business analysis, architecture, user interface design, or database design. However, the skills that Team member share – that is, the skill of addressing a requirement and turning it into a usable product – tend to be more important than the ones that they do not.

Everyone chips in, even if that requires learning new skills or remembering old ones. There are no titles on Teams, and there are no exceptions to this rule. Teams do not contain sub-Teams dedicated to particular domains like testing or business analysis.

Teams are also self-organizing. No one – not even the ScrumMaster – tells the Team how to turn Product Backlog into increments of shippable functionality. The Team figures this out on its own. Each Team member applies his or her expertise to all of the problems. The synergy that results improves the entire Team’s overall efficiency and effectiveness.

The optimal size for a Team is seven people, plus or minus two. When there are fewer than five Team members, there is less interaction and as a result less productivity gain. If there are more than nine members, there is simply too much coordination required. Large Teams generate too much complexity for an empirical process to manage. The Product Owner and ScrumMaster roles are not included in this count unless they are also pigs, working on tasks in the Sprint Backlog.

Team composition may change at the end of a Sprint. Every time Team membership is changed, the productivity gained from self-organization is diminished. Care should be taken when changing Team composition.

## Daily Scrum

Each Team meets daily for a 15-minute inspect and adapt meeting called the Daily Scrum. The Daily Scrum is at the same time and same place throughout the Sprints. During the meeting, each Team member explains:

1. What he or she has accomplished since the last meeting;
2. What he or she is going to do before the next meeting; and
3. What obstacles are in his or her way.

Daily Scrums improve communications, eliminate other meetings, identify and remove impediments to development, highlight and promote quick decision-making, and improve everyone's level of project knowledge.

The ScrumMaster ensures that the Team has the meeting. The Team is responsible for conducting the Daily Scrum. The ScrumMaster teaches the Team to keep the Daily Scrum short by enforcing the rules and making sure that people speak briefly. The ScrumMaster also enforces the rule that chickens are not allowed to talk or in any way interfere with the Daily Scrum.

The Daily Scrum is not a status meeting. It is not for anyone but the people transforming the Product Backlog items into an increment (the Team). The Team has committed to a Sprint Goal, and to these Product Backlog items. The Daily Scrum is an inspection of the progress toward that Sprint Goal (the three questions). Follow-on meetings usually occur to make adaptations to the upcoming work in the Sprint. The intent is to optimize the probability that the Team will meet its Goal. This is a key inspect and adapt meeting in the Scrum empirical process.

## Scrum Artifacts

Scrum Artifacts include the Product Backlog, the Release Burndown, the Sprint Backlog, and the Sprint Burndown.

### Product Backlog and Release Burndown

The requirements for the product that the Team(s) is developing are listed in the Product Backlog. The Product Owner is responsible for the Product Backlog, its contents, its availability, and its prioritization. Product Backlog is never complete. The initial cut at developing it only lays out the initially known and best-understood requirements. The Product Backlog evolves as the product and the environment in which it will be used evolves. The Backlog is dynamic in that it constantly changes to identify what the product needs to be appropriate, competitive, and useful. As long as a product exists, Product Backlog also exists.

The Product Backlog represents everything necessary to develop and launch a successful product. It is a list of all features, functions, technologies, enhancements, and bug fixes that constitute the changes that will be made to the product for future releases. Product Backlog items have the attributes of a description, priority, and estimate. Priority is driven by risk, value, and necessity.

> **Tip**
> Product Backlog items are usually stated as User Stories. Use Cases are appropriate as well, but they are better for use in developing life- or mission-critical software.

Product Backlog is sorted in order of priority. Top priority Product Backlog drives immediate development activities. The higher the priority, the more urgent it is, the more it has been thought about, and the more consensus there is regarding its value. Higher priority backlog is clearer and has more detailed information than lower priority backlog. Better estimates are made based on the greater clarity and increased detail. The lower the priority, the less the detail.

As a product is used, as its value increases, and as the marketplace provides feedback, the product’s backlog emerges into a larger and more exhaustive list. Requirements never stop changing. Product Backlog is a living document. Changes in business requirements, market conditions, technology, and staffing cause changes in the Product Backlog.

To minimize rework, only the highest priority items need to be detailed out. The Product Backlog items that will occupy the Teams for the upcoming several Sprints are fine-grained, having been decomposed so that any one item can be done within the duration of the Sprint.

> **Tip**
> Scrum Teams often spend 10% of each Sprint grooming the product backlog. When groomed to this level of granularity, the top priority Product Backlog items are decomposed so they fit within one Sprint. They have been analyzed and thought through during the grooming process. When the Sprint Planning meeting occurs, these items are well understood and easily selected.
>
> Acceptance tests are often used as another Product Backlog item attribute. They can often supplant more detailed text descriptions with a testable description of what the Product Backlog item must do when completed.

Multiple Scrum Teams often work together on the same product. One Product Backlog is used to describe the upcoming work on the Product. A Product Backlog attribute that groups items is then employed. Grouping can occur by feature set, technology, or architecture, and is often used to organize work by Scrum Team.

The Release Burndown graph records the sum of remaining Product Backlog estimated effort across time. The units of time are usually Sprints.

> **Tip**
> In some organizations, more work is added to the backlog than is completed. This may create a trend line that is flat or even slopes upwards. To compensate for this and retain transparency, a new floor may be created when work is added or subtracted. The floor should add or remove only significant changes and should be well documented.
>
> The trend line may be unreliable for the first two to three Sprints of a release unless the Teams have worked together before, know the product well, and understand the underlying technology.

### Sprint Backlog and Sprint Burndown

The Sprint Backlog consists of the tasks the Team performs to turn Product Backlog items into a “done” increment. It is all of the work that the Team identifies as necessary to meet the Sprint goal. Sprint Backlog items must be decomposed. The decomposition is enough so changes in progress can be understood in the Daily Scrum. One day or less is a usual size for a Sprint Backlog item that is being worked on.

The Team modifies Sprint Backlog throughout the Sprint. It may find that more or fewer tasks are needed or that a given task will take more or less time than expected. As new work is required, the Team adds it. As tasks are worked on or completed, the estimated remaining work is updated. When tasks are deemed unnecessary, they are removed. Only the Team can change its Sprint Backlog during a Sprint.

Sprint Backlog is a highly visible, real-time picture of the work that the Team plans to accomplish during the Sprint.

Sprint Backlog Burndown is a graph of the amount of Sprint Backlog work remaining in a Sprint across time. Track this by summing the backlog estimates every day of the Sprint. The work remaining for all Sprint Backlog tasks gives the data points.

> **Tip**
> Whenever possible, hand draw the burndown chart on a big sheet of paper displayed in the Team's work area. Teams are more likely to see a big, visible chart than they are to look at Sprint burndown chart in Excel or a tool.

### Done

Scrum requires Teams to build an increment of product functionality every Sprint. This increment must be potentially shippable. To do so, the increment must be a complete slice of the product. It must be “done.” Each increment should be additive to all prior increments and thoroughly tested.

In product development, asserting that functionality is done might mean different things to different people. To avoid confusion, the Team must have a common definition of “done.” This defines what the Team means when it commits to “doing” a Product Backlog item in a Sprint.

A completely “done” increment includes all of the analysis, design, refactoring, programming, documentation, and testing (unit, system, user, regression, performance, stability, security, integration, and internationalization).

Some Teams aren’t yet able to include everything required for implementation in their definition of done. This must be clear to the Product Owner.

> **Tip**
> “Undone” work is often accumulated in a Product Backlog item called “Undone Work” or “Implementation Work.” As this work accumulates, the Product Backlog burndown remains more accurate.

### Final Thoughts

Some organizations are incapable of building a complete increment within one Sprint. They may not yet have the automated testing infrastructure to complete all of the testing. In this case, two categories are created: “done” and “undone” work. “Undone” work is added to a Product Backlog item named “undone work.”

For instance, if a Team is not able to do performance, regression, stability, security, and integration testing for each Product Backlog item, the proportion of this work to the work that can be done is calculated. If six units are “done,” and four are “undone,” four is added to the “undone work” Product Backlog item.

Sprint by Sprint, the “undone” work of each increment is accumulated and must be addressed prior to releasing the product. This work is accumulated linearly although it may actually accumulate exponentially.

Release Sprints are added to the end of any release to complete this “undone” work. The number of Sprints is unpredictable to the degree that the accumulation of “undone” work is not linear.
