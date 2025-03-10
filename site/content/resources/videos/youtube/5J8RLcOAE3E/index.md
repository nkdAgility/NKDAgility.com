---
title: "Rethinking Continuous Delivery: Why Best Practices Don't Exist in Complex Environments"
description: Discover how to enhance continuous delivery in complex environments with audience-based strategies, testing in production, and a commitment to improvement.
date: 2025-01-23T06:30:03Z
weight: 400
ResourceId: 5J8RLcOAE3E
ResourceType: videos
ResourceImport: true
ResourceImportSource: Youtube
videoId: 5J8RLcOAE3E
source: youtube
url: /resources/videos/:slug
slug: rethinking-continuous-delivery-why-best-practices-dont-exist-in-complex-environments
layout: video
aliases:
- /resources/5J8RLcOAE3E
- /resources/videos/rethinking-continuous-delivery-why-best-practices-dont-exist-in-complex-environments
- /resources/videos/continuous-delivery-without-compromise-why-best-practices-dont-exist-in-complex-systems
aliasesArchive:
- /resources/videos/rethinking-continuous-delivery-why-best-practices-dont-exist-in-complex-environments
- /resources/videos/continuous-delivery-without-compromise-why-best-practices-don’t-exist-in-complex-systems
- /resources/continuous-delivery-without-compromise-why-best-practices-don’t-exist-in-complex-systems
- /resources/videos/continuous-delivery-without-compromise-why-best-practices-dont-exist-in-complex-systems
- rethinking-continuous-delivery-why-best-practices-dont-exist-in-complex-environments
preview: https://i.ytimg.com/vi/5J8RLcOAE3E/maxresdefault.jpg
duration: 891
isShort: false
tags:
- Pragmatic Thinking
- Code and Complexity
- People and Process
- Product Delivery
- Continuous Delivery
- Engineering Practices
- Software Developers
- Technical Excellence
- Working Software
- Complexity Thinking
resourceTypes:
- video
sitemap:
  filename: sitemap.xml
  priority: 0.6
categories:
- DevOps

---
I often find myself in discussions about the best practices for enabling continuous delivery within teams. It’s a question that comes up frequently, and I want to address it head-on: there are no best practices in complex environments. Best practices are a concept that applies to simple tasks in straightforward situations where a procedure can be followed consistently to achieve the same results. However, the world we operate in is anything but simple.

Instead, I prefer to say that there are only adequate practices tailored to the specific situation at hand, and these practices can—and often do—change. This is a fundamental truth we must embrace. While we may not have a one-size-fits-all solution, there are several practices that many organisations have successfully leveraged to enhance their continuous delivery efforts. Let’s explore some of these practices and how they can support cross-functional collaboration without compromising quality.

### Audience-Based Delivery

One of the most powerful practices I advocate for is the implementation of an audience-based delivery strategy. Traditionally, the delivery pipeline followed a linear path: development, testing, staging, and finally production. This model, while familiar, is fraught with inefficiencies and costs. It often leads to a scenario where quality is tested in rather than built in, which is the most expensive way to ensure quality.

By shifting to an audience-based delivery model, we can deploy small changes quickly to a limited set of users. This allows us to validate our product in real-world scenarios, which is invaluable. The Windows team at Microsoft exemplifies this approach. They deploy updates to internal users nightly, allowing developers to test their code in production almost immediately. This rapid feedback loop is crucial for continuous improvement.

### Testing in Production

The concept of testing in production is another critical aspect of this audience-based model. There is no perfect simulation of a production environment; the only way to truly validate our work is to deploy it. By allowing a small group of users to access new features, we can monitor how the product performs and make adjustments as necessary. This practice not only enhances our understanding of user interactions but also helps us identify and rectify issues before a wider rollout.

### The Philosophy of Find It and Fix It

When we talk about continuous delivery, we must also adopt a philosophy of “find it and fix it.” If something slips through our automated checks and makes it into production, we need to investigate how that happened and adjust our processes accordingly. This isn’t just about fixing bugs; it’s about evolving our architecture and practices to prevent similar issues in the future.

For instance, the Azure DevOps team faced challenges when a non-essential service caused significant disruptions. They learned that it’s better to allow the system to continue functioning, even if it means displaying a less-than-ideal user experience, rather than taking everything offline. This approach not only maintains user productivity but also provides valuable insights into system resilience.

### Embracing Change

Ultimately, the key takeaway here is that we must continuously seek to improve our products and our processes. This relentless pursuit of betterment is not merely a best practice; it’s a philosophy that should underpin everything we do. By embracing change and being willing to adapt, we can create a more robust and responsive delivery pipeline that meets the needs of our users.

In conclusion, while the term “best practices” may be misleading in the context of complex environments, there are certainly effective practices and philosophies we can adopt. By focusing on audience-based delivery, testing in production, and a commitment to continuous improvement, we can enhance our ability to deliver quality software efficiently. Let’s keep the conversation going and share our experiences as we navigate this ever-evolving landscape together.
