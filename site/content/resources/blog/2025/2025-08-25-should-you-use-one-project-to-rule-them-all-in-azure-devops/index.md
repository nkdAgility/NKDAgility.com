---
title: Should You Use One Project to Rule Them All in Azure DevOps?
short_title: One Project vs Multiple in Azure DevOps
description: Explores when to use a single Azure DevOps project versus multiple projects, detailing impacts on flow, visibility, governance, and team collaboration at scale.
tldr: Using a single Azure DevOps project for all teams and products reduces fragmentation, improves visibility, and streamlines governance compared to managing multiple projects or organisations. Key benefits include unified reporting, easier collaboration, and lower administrative overhead, while Area Paths and Teams provide the necessary structure and security within one project. Development managers should consolidate into one project where possible, using Area Paths and Teams to model structure and scale, to optimise flow and delivery.
date: 2025-08-25T09:00:00Z
lastmod: 2025-08-25T09:00:00Z
weight: 115
sitemap:
  filename: sitemap.xml
  priority: 0.8
  changefreq: weekly
ItemId: k-kqjqSgdGx
ItemType: blog
ItemKind: resource
ItemContentOrigin: hybrid
slug: should-you-use-one-project-to-rule-them-all-in-azure-devops
aliases:
  - /resources/k-kqjqSgdGx
concepts:
  - Tool
categories:
  - DevOps
  - Product Development
  - Engineering Excellence
tags:
  - Azure DevOps
  - Project Management
  - Software Development
  - Operational Practices
  - Value Delivery
  - Product Delivery
  - Agile Planning Tools
  - Application Lifecycle Management
  - Scaling
  - Pragmatic Thinking
  - Large Scale Agility
  - Agile Planning
  - Agile Strategy
  - Organisational Agility
  - Team Performance
Watermarks:
  description: 2025-06-06T12:34:49Z
  short_title: 2025-07-07T16:43:07Z
  tldr: 2025-07-30T23:12:39Z
ResourceId: k-kqjqSgdGx
ResourceType: blog

---
**Most organisations still believe that managing multiple projects means a better organisation. It doesn’t. It could just be hiding your problems or even creating them.**

If you’re still using multiple team projects in Azure DevOps to represent every application, every team, or every product, you may be paying the price in fragmentation, lost observability, and poor flow. That might have made sense in TFS 2005, but it's a liability in 2025.

The real path to high-performing teams? **One Project to rule them all**. One Azure DevOps Project, multiple teams, focused goals, observable flow. Scaled, not scattered.

I have been advocating for [One Team Project to rule them all]({{< resource-ref "8AfjJ-2eCEV" >}}) almost from the beginning with [Project of Projects with team Foundation Server 2010]({{< resource-ref "qiY3IH2aMYV" >}})  and my stance has not changed, although the Azure DevOps product has a over the years.

## TL;DR;&#x20;

The "many teams and projects" model in Azure DevOps is Microsoft’s own recommended setup—and one they use internally. It can make life easier for portfolio management and cross-team collaboration. But it comes with a price: increased complexity in setup, configuration, and ongoing maintenance. You’re trading operational simplicity for structural flexibility.

> "One project to rule them all \[Teams] and in \[Azure DevOps] bind them"
> \- Martin Hinshelwood, 2010

## When should you have multiple Projects in Azure DevOps?

Microsoft [clearly advises that projects are there to support multiple business units](https://learn.microsoft.com/en-us/azure/devops/organizations/projects/about-projects?view=azure-devops) and gives the following reasons for creating multiple projects:

- Support custom work tracking processes for specific business units within your organisation
- Support entirely separate business units that have their own administrative policies and administrators

I removed three reasons they give from this list, as they are generally irrelevant for most organisations. The first was the permission boundary, which I will handle below; another was for testing customisations, and the last was for a separate public OSS project.

Nowhere does Microsoft, as the creator of Azure DevOps, advocate for a Project per project, initiative, or effort within your organisation.

## Why Multiple Organisations and Projects Break Down at Scale

In most organisations, we aim to create cross-functional teams capable of delivering across a portfolio, at least within a defined funding stream or budgetary unit. As organisations grow, they typically segment into multiple funding streams, but decision-making around where and how to apply funding remains centralised within each unit.

Azure DevOps’ organisational and project boundaries can hinder this flexibility.

#### Multi-Organisation Boundaries

- **P\&L Boundary**: Separate organisations represent separate billing scopes; licensing, builds, storage.
- **Query Boundary**: You cannot query across organisations inside the same tenant. To get a full view, you're forced into third-party tooling like Power BI.
- **Linking Boundary**: While you can link work items across organisations (e.g., "Consumes From", "Produces For", "Remote Related"), these links are largely superficial. They aren't usable in Delivery Plans, Backlogs, or Boards.

#### Multi-Project Boundaries

- **Query Boundary**: While you can technically query across projects, you can't create a unified backlog. Planning becomes fragmented and requires external tools like Portfolio++ to stitch things together.
- **Boards**: You cannot create a board that visualises work across multiple projects. That’s a hard platform limitation.
- **Team Focus**: When individuals belong to multiple projects, their focus splinters. Backlogs fragment. Priorities conflict. The result? Increased wait time, context switching, and delivery delays.
- **Security**: Permissions, policies, and groups must be duplicated and managed separately across projects. That’s more overhead and more risk.
- **Shared Assets**: Test cases, source, pipelines, environments—these are far harder to reuse or coordinate across projects.

Every additional Organisation and Project adds friction that Azure DevOps is not designed to resolve. These aren’t flexible abstractions; they are hard boundaries and are by design.

&#x20;None of these constraints provides anything that a single project and a sane Area Path strategy couldn’t already achieve, with less overhead and more coherence.

## Should you have many projects?

Here is a summary of the three options:

- **One project, many teams** - If your teams are aligned, your backlog is coherent, and you're operating within a single organisation, then one project is the sweet spot. You get unified governance, consistent processes, and minimal admin overhead. Each team can tailor their boards and iterations while still feeding into a shared backlog and reporting structure. Visibility is baked in—if someone wants to see what's happening, they can. Coordination is simpler, reuse is natural, and roll-up metrics just work. Most importantly, it reduces cognitive and operational overhead, letting teams focus on delivery, not bureaucracy.
- **One organisation, many projects, and teams** - This model is useful when you're juggling different processes, delivery cadences, or security needs. You trade a bit of simplicity for flexibility. Each project has its own process templates, permissions, and settings, which makes sense if the work is fundamentally different, but it adds friction. Cross-team visibility suffers, reuse gets clumsy, and roll-up reporting becomes harder. You're coordinating across silos, not within a system. If you're using this model, you’ve likely optimised for isolation over collaboration. That might be intentional, but it comes at a cost.
- **Many organisations** - Only use this if you need ironclad isolation—think separate business units, external contracts, or compliance constraints. This is the most expensive model in terms of overhead, administration, and collaboration. There’s no natural visibility across orgs, no shared queries or boards, and zero cross-org reporting. Everything has to be duplicated or integrated manually. That might be acceptable if you’re supporting legacy TFS structures or strict multitenancy, but it kills flow. If you’re working across orgs and still need to coordinate, you’re solving a problem your tooling should have prevented.

I have always advocated for larger projects and use the following rule of thumb:

> If you have money, people, work, or products that interact in any meaningful way, then they should really be in a single Project.

Let’s not pretend this is theoretical. Microsoft’s own Developer Division (DevDiv) utilises a single Azure DevOps project to manage source code, builds, releases, test cases, and work items for over 2,000 engineers. For the Windows team at Microsoft, it's more like 15,000 people in one Project.

If that’s not proof this scales, what is?

## The Strategy: One Project. Many Teams. Clear Constraints.

A modern Azure DevOps project is designed to scale horizontally using **Teams**, and **Area Paths** and not by creating new team projects. This means that you need to deliberately design your strategy to avoid it becoming a total midden.

Inside Azure DevOps, while teams are a flat list, they are linked to Area paths, a hierarchy, to determine which work items are included in the teams view, and thus their backlogs and boards.

Here’s how it works.

> [!WARNING]
> This is going to get confusing since "Team" can mean "team of people" or the Azure DevOps construct of "Team". Im going to try and explicetly say "Azure DevOps Team" to refer to the construct and "team" to refer to a group of people. These people could be a "portfolio team", "feature team", or "delivery team".

### 1. **Use Area Paths to Represent Departments and Products**

Your Area Path hierarchy is the backbone of visibility, governance, and scale. Treat it as a map of how your products are delivered—not how your org chart looks. It should reflect the product structure and value streams, not departmental politics.

Create a distinct leaf node for every delivery team. This gives you fine-grained control for permissions, test plan isolation, dashboard targeting, and scoped visibility. Intermediate levels should reflect coherent product or platform groupings, enabling roll-up views without breaking team autonomy.

```
MyProject
 ├── Product A
 │    ├── Team 1
 │    └── Team 2
 ├── Product B
 │    ├── Team X
 │    └── Team Y
 └── Platform
      └── Shared Services Team
```

If your hierarchy matches your architecture and delivery teams, you unlock real traceability. If it mirrors your reporting lines, you’ll spend your time fighting visibility gaps and access problems.

> [!TIP]
> Use Area Paths deliberately. They are your primary tool for scoping permissions, isolating test plans, assigning build policies, and targeting dashboards. Keep them stable. Don’t reorganise on a whim.

### 2. Define Azure DevOps Teams with Clear Area Path Ownership

Each Azure DevOps Team is a lens into a defined slice of the Area Path hierarchy. That lens determines what work shows up on its backlog, board, and delivery plans. Clear, non-overlapping ownership is essential if you want visibility without duplication, focus without conflict.

The key? Design the Area Path hierarchy with intent, then map each team to a specific leaf node. Use the “include sub-areas” option carefully. Avoid overlap. One work item, one team board.

- Want a unified **Platform view**? Create an Azure DevOps Team at the higher-level node and include all sub-areas.
- Need a **delivery team focus**? Map them to their own leaf node and exclude others.
- Building a **Portfolio Kanban**? Use higher-level Areas with Epics and Features only—leave Backlog Items to delivery teams.

> [!TIP]
> A work item should never appear on two boards. If it does, your setup will confuse stakeholders and erode trust.

Here’s a common, pragmatic split:

- **Feature team Boards**: Configure to show Backlog Items only.
- **Portfolio Boards**: Configure to show Epics and Features only, with “include sub-areas” on.

This setup enables delivery teams to focus on tactical work, while leadership tracks strategic progress—all in the same project, without duplication.

### 3. **Use Iteration Paths for Cadence, Not Structure**

Keep Iteration Paths consistent across teams where possible. This enables consolidated reporting and facilitates shared understanding of delivery cycles.

> [!WARNING]
> When teams have different cadences within the same funding structure, it can cause friction and delays.&#x20;

When Team A says that the work will be done by Sprint 23, what does that mean? If Team B is on a different candidate, then this could be their Sprint 45, or the Shared Platform Teams Sprint 3.  A balance of autonomy and alignment is important when lots of folks are working together in the same value stream.

> [!TIP]
> Choose a cadence for review and delivery that aligns with the business needs, stakeholder engagement cadence, and the effective planning horizon. Regardless of the delivery team's chosen process, everyone inspects and adapts at least on that cadence.

If you must deviate (e.g. teams with different Sprint lengths), isolate only the differing branches.

### 4. **Secure by Area, Not by Project**

One of the most common justifications for multiple team projects is “security.” But Azure DevOps already supports:

- **Granular permissions on Area Paths**
- **Repos permissions**
- **Pipeline-level permissioning**
- **Environment and Library security for deployments**

You can grant fine-grained access control to individual teams, stakeholders, or systems without fragmenting your project into unmanageable silos.

> [!TIP]
> Use Azure DevOps Groups that contain Enta ID groups to maintain flexability and clarity

## What About Reporting?

If you're using one Azure DevOps project with clearly defined Area Paths and Teams, reporting becomes dramatically simpler, more powerful, and more honest.

Everything you need is in one place: Work Items, Repos, Pipelines, Releases, Test Plans. That means dashboards, boards, analytics views, and Delivery Plans just work—with no duct tape, no spreadsheet exports, no cross-project hacks.

- Use **Dashboards** for high-level visibility tailored to stakeholders.
- Use **Delivery Plans** for planning across multiple teams and value streams.
- Use **Portfolio Backlogs** to track progress across Features, Epics, and Initiatives without duplicating work.
- Use **Analytics Views** and **Power BI** to correlate flow, throughput, and cycle times across teams, products, and time.

And when you need more:

- **Portfolio++** provides rich roadmap and status visualisations that work across queries, teams, and even projects.
- **ActionableAgile** brings deep flow metrics—cycle time scatterplots, throughput charts, WIP ageing—directly into your Azure DevOps instance.

> [!TIP]
> Reporting doesn’t just inform—it aligns. A unified project gives you shared truth. Every extra project boundary erodes that.

## Final Word: Optimise for Flow, Not Structure

Azure DevOps isn’t just tooling; it reflects how your organisation thinks about delivery. If you design for control, you’ll get silos. If you design for flow, you’ll get visibility, alignment, and adaptability. Its an intrinsic part of your systems of work.

Every new project boundary introduces delay, friction, and duplication. Every extra organisational boundary kills collaboration and wrecks observability. You don’t need more buckets. You need better boundaries inside one.

Design your system of work to reflect how you deliver value, not how your teams report. Use one project. Use Area Paths and Teams to model structure and scale. Secure it properly. Report from it meaningfully. And let your delivery system evolve with clarity, not chaos.

**Don’t build around exceptions. Build for flow.**

One Project. Many teams. Clear constraints. Value, continuously delivered.

### Definitions

It's clear that everyone refers to things within Azure DevOps differently, and naming is not Microsoft's strong suit. Here is what I mean when I use terminology in this post:

- **Tennant -** Not really within Azure DevOps, but intrinsically linked is the Microsoft Entra ID tenant that provides the security with Users and Groups.
- **Organisation** - The big bucket of stuff and the almost absolute boundary for Azure DevOps. For argument's sake, it's a "database" with unique IDs and clear boundaries. Also known as "Collection" in Team Foundation Server (TFS).
- **Process** - The definition of the types and workflows of those types as well as the available backlog levels. Previously known as "Process Template".
- **Project** - The first level bucket after Organisation that provides a security and feature boundary. Used to be called "Team Project".
- **Value Board** - visualisation of the flow of value at a particular backlog level. This is just called "Board" in Azure DevOps, but I wanted to make my distinction clearer.
- **Task Board** - visualisation of tasks within value represented as value pinned to the left, and sub-tasks flow across the board.

## References

- [About projects and scaling your organization - Azure DevOps | Microsoft Learn](https://learn.microsoft.com/en-us/azure/devops/organizations/projects/about-projects?view=azure-devops)
- [Scaling Agile to large teams - Azure DevOps | Microsoft Learn](https://learn.microsoft.com/en-us/devops/plan/scaling-agile)
- [Plan your organizational structure - Azure DevOps | Microsoft Learn](https://learn.microsoft.com/en-us/azure/devops/user-guide/plan-your-azure-devops-org-structure?view=azure-devops#how-many-projects-do-you-need)
