---
title: 'Stop Guessing: How to Make Work Visible and Drive Real Improvement with Azure DevOps Flow Metrics'
short_title: Visibility, Metrics, and Flow in DevOps
description: Stop guessing—start making data-driven decisions in Azure DevOps. Discover tools, tips, and insights to make your work visible and your delivery predictable.
date: 2025-08-25T06:00:00Z
weight: 120
ResourceId: fvSZSSSjnyI
ResourceImport: true
ResourceType: videos
ResourceContentOrigin: ai
ResourceImportSource: Youtube
slug: stop-guessing-how-to-make-work-visible-and-drive-real-improvement-with-azure-devops-flow-metrics
aliases:
- /resources/fvSZSSSjnyI
- /resources/videos/7-visibility-metrics-and-flow
aliasesArchive:
- /resources/videos/7-visibility-metrics-and-flow
- 7-visibility-metrics-and-flow
source: youtube
layout: video
concepts:
- Tool
categories:
- DevOps
- Engineering Excellence
- Technical Leadership
tags:
- Azure DevOps
- Flow Efficiency
- Time to Market
- Metrics and Learning
- Operational Practices
- Team Performance
- Product Delivery
- Value Delivery
- Software Development
- Transparency
- Pragmatic Thinking
- Lead Time
- Cycle Time
- Technical Mastery
- Continuous Improvement
Watermarks:
  description: 2025-07-24T14:49:14Z
  short_title: 2025-07-24T14:49:15Z
videoId: fvSZSSSjnyI
url: /resources/videos/:slug
preview: https://i9.ytimg.com/vi/fvSZSSSjnyI/maxresdefault.jpg?sqp=CIyL2sMG&rs=AOn4CLBv1On-uLT1olHCP2GKp4FGmFtQxw
duration: 481
resourceTypes:
- video
isShort: false
sitemap:
  filename: sitemap.xml
  priority: 0.6

---
If you’re building products at any scale—whether you’re a small startup or a sprawling enterprise—one thing has become abundantly clear to me over the years: you simply cannot make good decisions without evidence. I’ve seen too many teams, and too many organisations, fall into the trap of “gut feel” decision-making. It’s seductive, but it’s also a fast track to mediocrity. Evidence-based management isn’t just a buzzword; it’s the foundation for real, sustainable improvement.

Now, evidence can take many forms. At the business level, it might be hypothesis-driven experiments. At the delivery level, it’s all about flow metrics—lead time, cycle time, work in progress, and so on. The challenge is always the same: how do we get the right data, and how do we make it visible in a way that actually helps us improve?

### The Visibility Imperative

One of the most fundamental lessons I’ve learned—sometimes the hard way—is that without visibility, you’re flying blind. If you can’t see what’s happening, you can’t change it. And if you can’t see the impact of your changes, you’re just guessing. This is why telemetry is so critical—not just telemetry from your product, but telemetry from your process.

Azure DevOps, for all its quirks, is actually a fantastic system for gathering this kind of telemetry. Every value of every variable in your work items is collected and stored. Add a custom field? No problem—the full history is there. This means you can pull and analyse any data you like, in any way you like. That’s powerful.

### Out-of-the-Box: The Good, the Bad, and the Rudimentary

Let’s be honest: the visualisations built into Azure DevOps are a bit basic. Microsoft’s approach is to provide the data layer, the API layer, and a few “table stakes” visualisations. The expectation is that partners and customers will build the value-adds that are specific to their needs.

- **Lead Time & Cycle Time**: Out of the box, you get these metrics, plus a bit of work in process. On your boards (let’s call them Kanban boards, though that’s a stretch), you can set WIP limits for each column. They’re not enforced—if you go over, the column just turns red. There’s no system-wide limit, which is a bit of a miss.
- **Averages**: The dashboards show average cycle and lead times. Personally, I’m not a fan of averages. I want to see the 85th percentile, the spread, the outliers. But Azure DevOps picks one metric and sticks with it.
- **Cumulative Flow**: You get a basic cumulative flow diagram. It’s straightforward, and it’s free.

All of this is built on a rich data foundation. Microsoft is opinionated about when work starts and finishes, but all the underlying data is there. You can access it via APIs, or load it into PowerBI and build whatever graphs you want. If you’re a large organisation with an internal engineering team, you can build custom boards, controls, and dashboards, and share them across the company. If you’re small, you probably don’t want to do that—you want a vendor solution that just works.

### My Recommendations: Tools That Make a Difference

If you want to go beyond the basics (and you should), there are two tools I recommend:

1. **Flow Viz**  
   - Pre-built PowerBI reports that connect to Azure DevOps.
   - Pulls your data and displays all the key flow metrics.
   - Free to use—download, install, and you’re off.
   - Great for teams who want more insight without building everything from scratch.

2. **Actionable Agile Metrics for Predictability**  
   - A plugin for Azure DevOps—interactive, JavaScript-based, and your data stays in your system.
   - Costs about $20 per user per month, but worth every penny in my experience.
   - Provides rich visualisations: lead time, cycle time, percentiles, WIP overlays, and more.
   - My favourite feature: the work-in-progress view with percentile overlays, so you can instantly spot items at risk.

Both tools give you far more than the out-of-the-box experience. You get deeper insights, more actionable data, and a much clearer picture of your flow.

### For the Coders: Azure DevOps Admin Tools

If you’re a developer and prefer the command line, Ben’s Azure DevOps Admin Tools are worth a look. It’s a CLI toolkit that pulls most of the data you need—cycle time, lead time, graphs, and more. It’s not as user-friendly for non-developers, but it gets the job done if you like to script your way to insight.

### Making the Invisible Visible

With all these options, it can feel a bit overwhelming. But the goal is always the same: make your work visible. Move from gut feel to data-driven delivery. When you can see your flow, your bottlenecks, your risks—you can actually do something about them. You can experiment, measure, and improve with confidence.

If you’re ready to stop guessing and start making decisions based on real evidence, let’s talk. I’ve helped teams of all sizes make their work visible and their delivery more predictable. It’s not magic—it’s just good practice, backed by the right data.

Let’s make your work visible, and your outcomes better.
