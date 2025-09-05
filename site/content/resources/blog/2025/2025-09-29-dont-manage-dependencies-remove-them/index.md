---
title: Don’t Manage Dependencies, Remove Them
short_title: Remove Dependencies, Don’t Manage Them
description: Explains why dependencies are a sign of poor system design and outlines steps to eliminate them by aligning teams, clarifying ownership, and redesigning workflows.
tldr: Dependencies are not inevitable but are usually caused by poor system design; instead of managing them, focus on removing them by aligning work, teams, and architecture, making contracts explicit, and clarifying ownership. Only manage the rare dependencies that remain, treating them as design flaws to be fixed, not as normal work. Leadership should prioritise redesigning systems to eliminate dependencies, which leads to faster delivery, fewer defects, and higher team autonomy.
date: 2025-09-29T09:00:00Z
lastmod: 2025-09-29T09:00:00Z
weight: 1000
sitemap:
  filename: sitemap.xml
  priority: 0.1
  changefreq: weekly
ResourceId: eBNUwJszXyE
ResourceImport: false
ResourceType: blog
ResourceContentOrigin: hybrid
slug: don-t-manage-dependencies-remove-them
aliases:
  - /resources/eBNUwJszXyE
concepts: []
categories:
  - Uncategorized
tags: []
Watermarks:
  description: 2025-09-04T23:19:42Z
  tldr: 2025-09-04T23:19:46Z
  short_title: 2025-09-04T23:19:48Z
canvas: 

---
_Answering the question: How do you manage dependencies?_

Every large-scale delivery conversation eventually drifts into the same dead-end: _“How do you manage dependencies?”_ The assumption is baked in, that dependencies are inevitable, so the best you can do is build a Gantt chart, track them, and hope for the best.

That assumption is wrong. Dependencies are not a law of nature. They are, as a rule, a symptom of poor system design. The ethos you should adopt is simple: **don’t manage dependencies, remove them.** Dependencies are systemic problems, not individual failings. Blaming teams or people misses the point; the system itself is what generates dependency waste.

When you manage dependencies, you’re committing to ongoing overhead: coordination meetings, dependency boards, artificial milestones, and cross-team politics. When you remove them, you restore autonomy, accelerate flow, and reduce risk. The cost of managing dependencies grows exponentially with every new team and integration point. The benefit of removing these compounds.

This post reframes the question. Instead of asking how to manage dependencies, let’s explore how to **design systems of work that eliminate them.**

## Step 1: Align Work, Teams, and Architecture

Dependencies don’t just appear by accident; they are often created when work, team structures, and architecture are misaligned. Without clear alignment, every piece of work risks bouncing between silos, waiting on specialists, and suffering from endless handoffs. That is the problem: dependencies are the tax you pay for poor organisational design. Getting alignment between the work coming in, the teams who own it, and the architecture they work within is the single most effective lever to reduce this tax. Start by examining the flow of work into the system and then design accordingly. Misalignment creates dependencies, which in turn generate delay and rework. Alignment is not optional; it is the prerequisite for autonomy and predictable flow. Leadership must own this alignment—teams cannot fix systemic misalignment by themselves.

**What you’d observe:**

- Teams blocked waiting for another group to deliver a component.
- Integration schedules instead of continuous delivery.
- Architects handing down plans disconnected from the team topology.

**Impact:**

- Delays compound as work zig-zags across silos.
- Teams cannot deliver end-to-end value.

### Design your organisation so that work, teams, and architecture line up

When teams can deliver value without waiting for others, most “dependencies” vanish. Dependencies are often just silos masquerading as inevitabilities.

- Structure teams to own a vertical slice of customer value, not a horizontal layer of technology.
- Use **Conway’s Law** as guidance: your architecture will mirror your communication structure. Intentionally shape both.
- Collapse handoffs. Give each team persistent ownership of the product or service they deliver.

## Step 2: Make Contracts Explicit

Many teams have other teams that depend on them, yet the terms of those dependencies are often left implicit. Each capability should provide a clear published contract that others can rely on. When changes are required, subscribers must be engaged to avoid breakage. In practice, this can mean maintaining multiple versions of contracts or APIs so that legacy consumers continue to work.

**What you’d observe:**

- Teams are guessing at how another service behaves.
- Breaking changes are introduced without warning.
- Communication channels are full of “who owns this API?” questions.

**Impact:**

- Surprise defects at integration time.
- Long cycles of rework.

### Document contracts between capabilities

Explicit contracts turn invisible risks into manageable, testable agreements. Teams understand who relies on them and what will break if they make changes. This makes coordination predictable and largely automated.

**How:**

- Define **service contracts** for every API, integration, or shared capability.
- Use patterns like **consumer-driven contracts** and the **tolerant reader** to protect against breakage.
- Maintain a catalogue of who depends on what—visible and owned.

## Step 3: Clarify Ownership

It should be clear which team owns each feature, component, or integration point, and exactly how to reach them. Ownership is more than a name on a slide; it means team-level accountability for decision‑making, maintenance, and evolution. Teams across the organisation should know which team to approach for changes, who approves modifications, and how issues will be triaged. Without this clarity, features drift, defects bounce between groups, and hidden dependencies multiply. Stable ownership over time is crucial; frequent changes in ownership create systemic churn.

**What you’d observe:**

- Multiple teams touching the same codebase.
- Bugs bouncing between groups.
- Nobody is sure who can approve a change.

**Impact:**

- Confusion, delay, and political friction.
- Hidden dependencies on individuals or “shadow owners.”

### Resolve by establishing clear ownership lines

Ambiguity is the breeding ground for dependencies. Clarity lets others adapt or negotiate when overlap is unavoidable.

**How:**

- Map every application, service, and integration to a single accountable team.
- Make ownership visible in tooling (Wiki, Whiteboard, Azure DevOps, GitHub, etc.).
- Establish communication paths to clarify who to engage with when non-contract dependencies arise.

## Step 4: Actively Manage the Rare Remainders

After all of that, there are still going to be some dependencies that are inescapable. These need to be actively managed by the feature team that is the subscriber and raised to leadership as signals of systemic weakness that require intervention and redesign.

**What you’d observe:**

- A handful of dependencies remain despite alignment, contracts, and ownership.
- Work items in one team are directly blocked by delivery from another.

**Impact:**

- Delivery risk where elimination wasn’t possible.
- Leadership attention consumed by coordination rather than improvement.

### Manage _only these_

Dependencies you can’t remove should be visible, owned, and tracked. But the point is to treat them as defects in your organisational design, not facts of life. They are alarms that something still needs to change. They represent system design debt, not normal work.

**How:**

- Track explicit dependencies between backlog items.
- Use shared reviews or joint planning where strictly necessary.
- Escalate them so leadership sees them as design flaws to resolve, not work items to shuffle.
- Treat them as exceptions to be removed long-term, not normal operating procedure.

## Systemic View

Dependencies exist because of how you design systems of work. A flawed system will always overpower the best intentions of the people inside it. The behaviours you see are simply the consequences of the structures you created.

- Siloed teams generate handoffs and queues that slow everything down.
- Ambiguous ownership breeds uncertainty and political friction.
- Implicit contracts guarantee surprises and rework.

These are not accidents; they are deliberate design choices, even if unacknowledged. Left unchecked, they act as amplifiers of waste—magnifying delay, variability, and risk across the organisation. Dependencies are one of the clearest forms of systemic waste and delay, and every appearance of them is a call to redesign.

The answer is not to manage harder but to redesign. You remove the cause rather than chase the symptom. That is the work of stewardship: shaping structures, policies, and boundaries so that flow becomes natural and dependencies are engineered out of existence.

Organisations that aggressively eliminate dependencies consistently show:

- Faster cycle times.
- Fewer integration defects.
- Higher team morale due to autonomy.

Frameworks like **Nexus** put dependency management front and centre, but the real lesson is that dependencies are signals of poor alignment. The **Kanban Guide** emphasises WIP limits and flow efficiency; dependencies are often the hidden WIP that destroys predictability. **Evidence-Based Management** encourages us to inspect value delivery capability; dependencies are one of the clearest capability killers.

## Closing the Loop

When someone asks, _“How do you manage dependencies?”_, the radical answer is: **you don’t.** You redesign your teams, architecture, and workflow to eliminate dependencies from the outset. You only manage what’s left when all else fails, and you treat every remaining dependency as a design flaw to be removed. That’s how you maximise autonomy, accelerate flow, and reduce risk.

Stop normalising dependency management as a project management activity. Managing dependencies is treating the symptom. Leadership must instead redesign the system to eliminate the cause. Every dependency you remove is a gift to your teams and your customers. So next time someone asks you how you manage dependencies, give them the only honest answer: **we don’t; we remove them.**
