id: KHEPBWiFDKJ
title: Why Measuring Individual Cycle Time is Killing Your Flow (And What to Do Instead)
tldr: Measuring individual cycle time in Kanban misleads teams by focusing on personal speed instead of system flow, which ignores real bottlenecks and encourages counterproductive behaviors. To improve delivery, track system-wide metrics like lead time, work in progress, process cycle efficiency, and blockers, then address constraints at the process level. Development managers should shift measurement and improvement efforts from individuals to the overall workflow to achieve better outcomes.
classifications:
- label: Engineering Excellence
  score: 88
- label: Technical Leadership
  score: 73
content: |
  Looking at [cycle time]({{< ref "/tags/cycle-time" >}}) for an individual is a fundamental misunderstanding of how flow works in a system, unless the individual is the system. And here is why!

  ## Process Cycle Efficiency (PCE) Drives Flow, Not Individual Productivity

  [Kanban]({{< ref "/categories/kanban" >}}) isn’t about individual productivity; it’s about optimising the flow of work through a system. When you measure an individual’s cycle time, you ignore the real bottlenecks, queues, dependencies, and wait times that slow everything down. A person might complete tasks quickly, but if those tasks get stuck waiting for reviews, approvals, or other handoffs, the overall system remains inefficient. If you want faster delivery, fix the system, not the people.

  As Nigel Thurlow puts it: _"You never measure a person, ever. You only ever measure a process. You improve the system, never the people within it. If you're measuring an individual person to try and blame them, then you're ignoring what's wrong with the process that's causing it."_

  ## Encourages Local Optimisation Over System Improvement

  Measuring individual cycle time leads to bad incentives. If someone is judged on how fast they complete their own tasks, they’ll prioritise speed over impact. This can lead to:

  - Focusing on tasks that make them look efficient rather than what benefits the team.
  - Taking on work too early, creating unnecessary work in progress (WIP).
  - Cherry-picking simple tasks to appear fast rather than tackling what actually moves the system forward.

  Kanban is about improving the whole workflow. Look at Process Cycle Efficiency (PCE) and [Throughput]({{< ref "/tags/throughput" >}}) together, one improves the other.

  ## Ignores Work in Progress (WIP) and Blockers

  A fast-moving individual doesn’t mean fast-moving work. If the system is overloaded with WIP, nothing gets delivered faster. Work often gets stuck in queues, waiting for handoffs, or blocked by dependencies. Measuring individual cycle time won’t tell you where the real problems are.

  Instead, track:

  - **Total WIP**, to ensure the system isn’t overloaded.
  - **Time in queue vs. time in progress**, to identify bottlenecks.
  - **Blocked work items**, to find systemic delays.

  ## Misrepresents Collaboration and Dependencies

  Knowledge work isn’t assembly-line work. It requires handoffs, reviews, and collaboration. Measuring an individual’s cycle time isolates their part of the work but ignores the time it spends waiting on others. Worse, it discourages teamwork, if people are penalised for long cycle times, they’ll avoid collaborating because it slows them down.

  Optimise for flow across the system, not just individual speed.

  ## Creates Unintended Behaviour

  If people are measured by their [personal]({{< ref "/tags/personal" >}}) cycle time, they may:

  - **Rush work**, sacrificing quality to look fast.
  - **Avoid complex or high-value tasks**, because they take longer.
  - **Hoard work**, keeping tasks they know they can finish quickly rather than distributing work across the team.

  None of this improves system flow. It just distorts behaviour.

  ## What Should You Measure Instead?

  > At the end of the day, the Kanban Method (as opposed to kanban) is designed to improve flow (basically Process Cycle Efficiency) by improving throughput (units per unit time) by removing constraints (which includes bottlenecks) in the system. Make the system more effective by making it more efficient. - Nigel Thurlow

  If you want to improve flow, focus on:

  - **customer [lead time]({{< ref "/tags/lead-time" >}}) ([time to market]({{< ref "/tags/time-to-market" >}}))** - the total time from when work is requested to when it is delivered to the customer.
  - **Work in progress (WIP) limits** - to reduce bottlenecks and improve flow.
  - **Process Cycle Efficiency (PCE)** - the ratio of active work time to non value added time.
  - **Bottlenecks and blockers** - to identify systemic constraints.
  - **Throughput** - the rate at which something is produced or delivered..

  ## Bottom Line

  Kanban is about improving the system, not monitoring individuals. Measuring individual cycle time distracts from real systemic inefficiencies and leads to bad behaviours. Instead, optimise for end-to-end flow and make sure work moves smoothly across the whole system.

  As Thurlow emphasises: _"If there are training or skill gaps, that’s a system problem, not a person problem. Someone failed the person by not providing the right training, support, or experience."_ This reinforces why the focus should always be on fixing the system, not blaming individuals.

  ### Want to improve your Kanban flow?

  If you need help setting up meaningful Kanban metrics, let’s talk. We can identify the right measurements to improve your system without falling into the trap of individual cycle time metrics.
