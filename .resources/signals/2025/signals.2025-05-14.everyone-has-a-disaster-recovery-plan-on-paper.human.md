---
title: Everyone has a disaster recovery plan—on paper."
description: Most disaster recovery plans fail in practice due to overlooked dependencies and lack of real-world testing, leaving organisations vulnerable when outages occur.
date: 2025-05-14T15:30:37+01:00
weight: 1000
slug: everyone-has-a-disaster-recovery-plan-on-paper
aliases:
- /resources/jgAmhaBbUlm
ResourceId: jgAmhaBbUlm
ResourceImport: false
ResourceType: signals
ResourceContentOrigin: human
draft: true
source: LinkedIn
platform_signals:
- platform: LinkedIn
  post_url: https://www.linkedin.com/feed/update/urn:li:share:7328441618900918273
  post_id: "7328441618900918273"
  post_date: 2025-05-14T14:30:37Z
  performance:
    impressions: 0
    members_reached: 0
    reactions: 0
    comments: 0
    reposts: 0
Watermarks:
  description: 2025-05-16T15:54:46Z
concepts: []
categories:
- Uncategorized
tags: []

---
Everyone has a disaster recovery plan—on paper.

But when the lights go out, very few organisations have systems that actually work. Spain, Portugal, Oracle, Heathrow... these weren’t random outages. They were textbook examples of systems that failed exactly as they were designed.

At Merrill Lynch, I saw it firsthand. Twice. We ran full disaster recovery drills. Everything looked like a success—until we tried to use the restored systems. Nothing worked. Why? Because the one system that everything else relied on—Active Directory—was never restored.

So yes, my app was "restored" successfully. But without authentication, it was useless.

This is the cost of pretending you're resilient: you run the drills, tick the boxes, declare victory... and miss the critical dependencies that actually matter.

If you’ve never validated that your system works end to end, under real pressure, then you’re not resilient. You’re wishful.

Real resilience doesn’t live in plans. It lives in pain.
