---
title: 'Stop Testing Quality In: How Shifting Left Builds Better Software, Faster'
short_title: Building Quality In with TDD and Automation
description: Stop testing quality in—start building it in. Learn how shifting left, automation, and fast feedback loops drive engineering excellence in modern teams.
tldr: Relying on testers to catch issues late in the process increases costs, slows feedback, and undermines product trust; instead, quality should be built in from the start by moving tests and feedback as close to the engineer as possible. Key practices include automating builds and tests, adopting continuous integration and delivery, using test-driven development, and incrementally improving code quality. Development managers should focus on empowering engineers to own quality, relentlessly shortening feedback loops, and making incremental improvements to achieve faster, more reliable releases.
date: 2025-08-18T06:00:00Z
lastmod: 2025-08-18T06:00:00Z
weight: 155
sitemap:
  filename: sitemap.xml
  priority: 0.6
  changefreq: monthly
ResourceId: Ny4mMLZX4UE
ResourceImport: true
ResourceType: videos
ResourceContentOrigin: ai
ResourceImportSource: Youtube
slug: stop-testing-quality-in-how-shifting-left-builds-better-software-faster
aliases:
  - /resources/Ny4mMLZX4UE
  - /resources/videos/6-building-quality-innot-inspecting-it-later
aliasesArchive:
  - /resources/videos/6-building-quality-innot-inspecting-it-later
  - 6-building-quality-innot-inspecting-it-later
source: youtube
layout: video
concepts:
  - Practice
categories:
  - Engineering Excellence
  - DevOps
  - Product Development
tags:
  - Engineering Practices
  - Software Development
  - Technical Mastery
  - Shift Left Strategy
  - Technical Excellence
  - Automated Testing
  - Operational Practices
  - Test First Development
  - Continuous Delivery
  - Test Automation
  - Value Delivery
  - Product Delivery
  - Team Performance
  - Pragmatic Thinking
  - Continuous Integration
Watermarks:
  description: 2025-07-24T15:09:42Z
  short_title: 2025-07-24T15:09:43Z
  tldr: 2025-07-30T23:14:39Z
videoId: Ny4mMLZX4UE
url: /resources/videos/:slug
preview: https://i9.ytimg.com/vi/Ny4mMLZX4UE/maxresdefault.jpg?sqp=CIyL2sMG&rs=AOn4CLCWsJzPr_lUtXaQb9o83cYJ2ydRkw
duration: 605
resourceTypes:
  - video
isShort: false

---
In my experience working with organisations of all shapes and sizes, I see a recurring pattern that undermines engineering excellence: teams are still testing quality in, rather than building it in from the start. This isn’t just a technical quirk—it’s a fundamental flaw that ripples through your entire delivery process, inflating costs, slowing feedback, and eroding trust in your product.

Let’s be clear: when you rely on testers to catch issues after the fact, you’re effectively giving engineers permission to say, “It’s fine, QA will catch it.” But the further a defect travels from the engineer’s keyboard, the more expensive and disruptive it becomes to fix. Finding a bug in production is the worst-case scenario, but even waiting until QA validation—after code has already polluted your main branch—means you’re introducing unnecessary friction and risk.

I’m currently working with a customer who exemplifies this. Their workflow pushes code into a preview environment for testers to validate, but by that point, the code is already in main. If a problem is found, it’s another branch, another pull request, another round of changes. Yes, testers are essential, but the ideal is that they find nothing. We want to catch issues as early as possible—ideally, before the code ever leaves the engineer’s hands.

**How do we achieve this?** It comes down to a few core practices:

- **Automation**: Automate everything you can—builds, tests, deployments.
- **Integration**: Continuous integration (CI) and continuous delivery (CD) are non-negotiable.
- **Test-Driven Development (TDD)**: TDD isn’t a testing strategy; it’s an architectural and design discipline. It ensures your code is testable, focused, and does what you expect.
- **Static Code Analysis**: Don’t try to boil the ocean by turning on every rule in a legacy codebase. Instead, enable specific checks, fix them incrementally, and make those warnings part of your developers’ daily feedback loop.
- **Code Review Policies**: I favour trunk-based development, where long code reviews are the enemy. The goal is to get changes into main (or trunk) as quickly as possible, automating approvals unless there’s a real infraction. I even use AI checks to enforce team policies—sometimes overzealous, but often invaluable.

But even with all this, catching issues at the pull request stage is still too late. We need to **shift left**—move quality checks as close to the engineer as possible, and as early as possible.

### The Azure DevOps Example: A Real-World Shift Left

One of my favourite stories comes from the Azure DevOps team. When they moved from a two-year release cycle to a three-week cadence, they hit a wall: their full regression suite (think selenium-style system tests) took 24 to 48 hours to run. Imagine waiting two days to find out if your change broke something! Developers’ changes were batched into rolling builds, so if you were unlucky, it could be nearly four days before you got feedback.

This is the epitome of testing quality in, not building it in. Those long-running tests are lagging indicators—by the time you get feedback, the context is lost, and the cost to fix is high.

The Azure DevOps team had around 36,000 of these system tests. Over four years, they methodically refactored, moving tests down the pyramid: from slow, brittle system tests to fast, reliable unit tests using stubs, mocks, and solid engineering principles. The result? They went from 48 hours for 36,000 tests to three and a half minutes for 80,000 unit tests—delivering the same level of confidence, but orders of magnitude faster.

This is what building quality in looks like. It’s not a one-off fix; it’s a sustained investment in shortening feedback loops and empowering engineers to own quality.

### What Does This Mean for Your Team?

- **Move tests as far left as possible**: The closer to the engineer, the better.
- **Shorten feedback loops**: Identify bottlenecks—what’s taking too long? How can you make it faster?
- **Automate relentlessly**: Manual steps are opportunities for delay and error.
- **Incremental improvement**: Don’t try to fix everything at once. Tackle one static analysis rule, one flaky test, one slow build at a time.
- **Empower engineers**: Quality is everyone’s responsibility, not just QA’s.

This isn’t just theory. Azure DevOps itself is a tool built by a team that lived this journey, for teams who are on the same path. Whether you’re a four-person startup or a 15,000-strong enterprise with a 350GB git repo, these principles scale.

On one of my current projects, I’ve got the time from cutting code to automated build with a pull request down to about a minute and a half. Another minute and a half to preview, and another to production. That’s a feedback loop of under five minutes from code to live. The result? We catch mistakes early, fix them fast, and build trust with every release.

### The Bottom Line

If you want to build quality into your process—rather than testing it in after the fact—start by designing an engineering workflow that puts feedback in the hands of your engineers, as early and as often as possible. That’s the heart of agile, Scrum, and DevOps. It’s not just about tools or ceremonies; it’s about creating a culture where quality is built in, not bolted on.

**Meta Description:**  
Discover why building quality in—not testing it in—is essential for engineering excellence. Learn practical strategies for shifting left, shortening feedback loops, and empowering your team to deliver high-quality software, faster.
