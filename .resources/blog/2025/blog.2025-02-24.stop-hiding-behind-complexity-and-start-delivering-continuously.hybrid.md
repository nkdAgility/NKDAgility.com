---
title: Stop Hiding Behind Complexity and Start Delivering Continuously
description: Continuous delivery is achievable for any software, regardless of complexity. Success depends on investment in automation, quality, and process improvement—not technical barriers.
date: 2025-02-24T09:00:00
weight: 155
slug: stop-hiding-behind-complexity-and-start-delivering-continuously
aliases:
- /resources/7hEAycZIn8w
ResourceId: 7hEAycZIn8w
ResourceImport: false
ResourceType: blog
ResourceContentOrigin: Hybrid
AudioNative: true
creator: Martin Hinshelwood
contributors:
- name: John McFadyen
  external: https://www.linkedin.com/in/johnmcfadyen/
- name: Rich Visotcky
  external: https://www.linkedin.com/in/richvisotcky/
layout: blog
resourceTypes: blog
aliasesArchive:
- /stop-hiding-behind-complexity-deliver-continuously
- /blog/stop-hiding-behind-complexity-deliver-continuously
- /stop-hiding-behind-complexity-and-start-delivering-continuously
- /blog/stop-hiding-behind-complexity-and-start-delivering-continuously
concepts:
- Practice
categories:
- DevOps
- Engineering Excellence
- Product Development
tags:
- Continuous Delivery
- Software Development
- Technical Mastery
- Operational Practices
- Market Adaptability
- Product Delivery
- Evidence Based Management
- Deployment Frequency
- Metrics and Learning
- Organisational Agility
- Technical Excellence
- Frequent Releases
- Azure DevOps
- Business Agility
- Release Management
preview: 2025-02-24-stop-hiding-behind-complexity-deliver-continuously.jpg
Watermarks:
  description: 2025-05-07T12:49:30Z
platform_signals:
- platform: Scrumorg
  post_url: https://www.scrum.org/resources/blog/stop-hiding-behind-complexity-and-start-delivering-continuously
  post_date: 2025-07-01T09:00:00Z
  post_type: crosspost

---
Every organisation says their software is 'too complex' for [continuous delivery]({{< ref "/tags/continuous-delivery" >}}). That's nonsense. Complexity is an excuse, not a blocker. [Azure DevOps]({{< ref "/tags/azure-devops" >}}), Starbucks, and countless others proved it wrong. The only real obstacle is the resistance to invest in fixing what’s broken. Complexity is an excuse, not a blocker. Microsoft proved it. Starbucks proved it. You can too; if you’re willing to put in the time, effort, and money.

Continuous delivery is not a pipe dream. If the organisation is willing to invest, it’s achievable for every software product, regardless of complexity or legacy constraints. And that's the challenge.

The organisation must be willing to invest significant time and effort in enabling it. Microsoft's Azure [DevOps]({{< ref "/categories/devops" >}}) team exemplifies this. They transitioned from shipping new features every two years to delivering value every three weeks, increasing their annual feature delivery from 25 to nearly 300 at their peak.

This evolution was not the result of a silver bullet but a deliberate effort to modernise architecture, eliminate [technical debt]({{< ref "/tags/technical-debt" >}}), automate relentlessly, and embed a culture of [continuous improvement]({{< ref "/tags/continuous-improvement" >}}). It is an ongoing evolution that has paid dividends for every year of effort invested. They delivered 58 features at the end of the first year of investment, rising to over 250 features after four years, later stabilising at just over 300. This is the power of continuous delivery.

### TLDR

Every software system, no matter how complex or archaic, can be updated, tested, and deployed continuously—without delays, bottlenecks, or manual interventions. This is the core of Continuous Delivery (CD): software always in a deployable state, ready for frequent, reliable releases.

## What is holding you back?

Many teams believe they cannot achieve continuous delivery and instead claim:

- Their product is too big and complex
- Their teams lack the skills
- It’s not possible in their regulated industry

Every single one of these justifications is illegitimate and reflects either the team's unwillingness to learn or the [leadership]({{< ref "/categories/leadership" >}})'s unwillingness to invest. These are excuses, not realities.

**In reality, systemic and continuous underinvestment in quality, scalable, and supportable products is to blame.**

This failure is not driven by the engineers or managers doing the work, but they have enabled it. The cause lies squarely in the business, even if they did not consciously make it.

> "If you put people under pressure to deliver, they will increasingly and systemically decrease quality to meet whatever ridiculous deadlines you give them."

The result is unchecked technical debt, high bug rates in production, significant rework, and unmet expectations.

This is not a terminal condition but a challenge to manage and overcome. The key lies in intentionality. Without tackling the root causes of complexity for new capabilities, slow releases, and frequent production issues, process changes will fail to deliver meaningful results.

### The Evolution of the Developer Division at Microsoft

Like every other company that has built software at scale, Microsoft fell into the usual traps of long release cycles, single-pass coding, and poor testing quality. For the Developer Division—responsible for Visual Studio, Team Foundation Server, and other software engineering tools—this resulted in a two-year release cycle, a four-year customer feedback loop, and fixing 75,000 bugs to get Visual Studio 2010 out the door.

Market forces pushed them to evolve. They could no longer meet the demands of an increasingly dynamic market, and a four-year response time to customer needs was unsustainable. While laggards might remain, it's the early adopters who drive new business and shape emerging markets. Failing to keep them engaged signals a decline that, if left unchecked, can be fatal—but recovery is possible with decisive action.

Azure DevOps emerged as the result of decisive action by Microsoft's Developer Division, triggered by an urgent need to break free from their two-year release cycle and four-year customer feedback loop. They didn't inherit perfection—they faced legacy code, fragmented processes, and a monolithic release cycle. Their transformation began with small, incremental changes, but success required deeper, systemic shifts:

- **Automate Everything**: This cannot be emphasised enough. Automate every possible task. If something cannot be automated today, create a plan to rework the architecture until it can be. From testing and deployments to upgrades, certificates, passwords, and environments—automation should be the default, not the exception.

- **Trunk-Based Development**: The cognitive load and resulting complexity from supporting multiple versions of your product significantly increases complexity and risk. Long-running branches, especially when promoting by branch, slow the delivery of [working software]({{< ref "/tags/working-software" >}}) to real users. Adopting [Trunk-Based Development practices]({{< ref "/resources/blog/2025/2025-02-06-stop-promoting-branches" >}}) eliminates this risk by ensuring that all code integrates continuously into a single shared branch.

- **Feature Flags**: To maximise both quality and value, it's essential to [test new capabilities in production]({{< ref "/resources/blog/2025/2025-02-06-testing-in-production-maximises-quality-and-value" >}}) while gradually exposing them to users, reducing risk. This approach shortens feedback loops and enables swift adaptation to emerging market opportunities. Since we can't predict which features will deliver the most value, we validate hypotheses by running small experiments with real data. Effective use of feature flags is crucial for these experiments, ensuring safe, controlled releases that drive continuous improvement.

- **Shift-Left**: Shift from testing quality at the end (QA, Staging, UAT) to embedding it throughout the development process. Use hypothesis-driven practices and unit tests at every stage to ensure high quality from the start. Discovering a security vulnerability in staging often means the flaw is deeply embedded, leaving no time or budget for proper fixes—only quick patches that hackers easily exploit. Instead, conduct security tests, code reviews, and performance checks continuously, as close to code creation as possible.

- **Iterate Over Pain**: If a task is hard or error-prone, you should do it more often. Any activity, like releasing, that feels difficult or frequently leads to errors deserves focused attention. Repeated practice exposes weak points, allowing you to refine the process and reduce risk. Avoiding the pain only ensures it remains a persistent threat.

## What can we learn?

If you want to be able to adapt to market opportunities or surprises, then you need to be able to shift quickly. This means that any software system, regardless of its complexity, architecture, or purpose, should be updated, tested, and deployed in a continuous flow without delays, bottlenecks, or manual interventions. This is the ethos of Continuous Delivery (CD), where software is always in a deployable state, enabling frequent and reliable releases.

In the world of modern software engineering its no longer an optional thing. It's a business demand.  Too many business opportunities have been missed because we are too slow to deliver and too slow to turn feedback into usable working products on a short enough timeline.

How short your timeline needs to be is a question for your business... what is your effective planning horizon. For Starbucks PoS its 48h; for [Windows]({{< ref "/tags/windows" >}}), its \~120h, for Facebook its just a few minutes.

## Measuring your velocity

Velocity isn't just about how much work gets done—it's about how fast you move from idea to outcome. It’s about closing feedback loops quickly, enabling continuous improvement, and delivering valuable increments faster.

In 2018, Buck Hodges from Microsoft's Azure DevOps/Team Foundation Server team introduced four key metrics to evaluate and enhance the [software development]({{< ref "/tags/software-development" >}}) and deployment process:

- **Time to Build:** This metric measures the duration from code commit to the completion of a successful local build on a developer's workstation. It reflects the amount of time a developer needs to wait to know if their code compiles.

- **Time to Self-Test:** This refers to the time taken to execute automated tests after a build locally. A shorter Time to Self-Test reflects fast tests and enables quicker feedback on code quality. Efficient self-testing cycles catch defects early, reduce rework, and maintain code integrity.

- **Time to Deploy:** This metric tracks the time required to deploy a build to a production environment. Shorter deployment times increase velocity by enabling rapid feedback and [value delivery]({{< ref "/tags/value-delivery" >}}). Minimising the Time to Deploy is crucial for rapidly delivering features and fixes to end users. [Continuous integration]({{< ref "/tags/continuous-integration" >}}) and delivery (CI/CD) pipelines are essential for optimising this metric.

- **Time to Learn:** This encompasses the period from deployment to collecting and analysing user feedback or telemetry data. Reducing Time to Learn ensures teams quickly understand user interactions and make informed decisions for future development. Faster learning cycles mean teams adapt quickly, prioritise effectively, and avoid wasting time on low-value features.

These metrics represent stages in the flow of work from ideation to outcome. They are not the only metrics or stages, but they represent and expose significant bottlenecks in this case—and they are 100% within the control of engineering. Engineering did not require any outside approval to measure and optimise these stages. Accountability for improvement lies squarely within the team.

By monitoring and optimising these metrics, development teams can achieve a more streamlined and responsive DevOps workflow, leading to faster delivery of high-quality software. However, these metrics are focused on the work of engineers building the product, and there may be other things in the application lifecycle that may have a bigger impact on you and your teams.

It's crucial to take a holistic view of metrics, and the [Evidence-Based Management (EBM) guide]({{< ref "/resources/guides/evidence-based-management-guide-2020" >}}) is a great starting point. It offers example metrics that can either be adopted directly or adapted to fit your context. When choosing metrics, focus on the four Key Value Areas (KVAs) defined by EBM:

1. **[Current Value]({{< ref "/tags/current-value" >}}) (CV):** Measures the value delivered to customers or stakeholders today, reflecting satisfaction and success based on the current product.
2. **Unrealized Value (UV):** Identifies potential future value by highlighting gaps between what customers have and what they need or desire.
3. **[Ability to Innovate]({{< ref "/tags/ability-to-innovate" >}}) (A2I):** Assesses how effectively the organisation can deliver new capabilities, features, or products without being constrained by technical debt, process bottlenecks, or organisational drag.
4. **[Time to Market]({{< ref "/tags/time-to-market" >}}) (T2M):** Evaluates the speed at which ideas, features, or fixes move from concept to production, directly impacting responsiveness to market demands and customer needs.

These four areas provide a balanced view, ensuring you don’t just measure output but focus on the outcomes that drive business success and [customer satisfaction]({{< ref "/tags/customer-satisfaction" >}}).

## The Path Forward

Ultimately, when deployments are automated, code is well-tested, and processes are streamlined, teams can respond faster to customer needs, market changes, and business opportunities. Azure DevOps’ and Windows evolutions proved that the barrier to continuous delivery is not technical complexity but organisational will.

No matter where you start, the path to continuous delivery is through addressing the complexity that is slowing you down head-on. Prioritise automation, enforce code quality and relentlessly improve your processes. The result is not just faster releases but better software, happier teams, and more satisfied customers.

If Azure DevOps can do it with their scale and complexity, so can you.

The only question is whether you're willing to do what Azure DevOps, Starbucks, and countless others have done: stop hiding behind complexity, and start delivering continuously.
