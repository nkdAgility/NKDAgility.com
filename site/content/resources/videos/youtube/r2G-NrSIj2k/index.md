---
title: Code Reviews for Quality Assurance
short_title: Code Reviews for Quality Assurance
description: Explores modern code review practices, emphasising automation, pre-reviewed code, and shift-left strategies to improve software quality, speed, and team collaboration.
date: 2024-11-27T06:00:25Z
weight: 255
ResourceId: r2G-NrSIj2k
ResourceImport: true
ResourceType: videos
ResourceContentOrigin: AI
ResourceImportSource: Youtube
slug: code-reviews-for-quality-assurance
aliases:
- /resources/r2G-NrSIj2k
- /resources/videos/code-reviews-for-quality-assurance
aliasesArchive:
- /resources/videos/code-reviews-for-quality-assurance
- /resources/code-reviews-for-quality-assurance
- code-reviews-for-quality-assurance
source: internal
layout: video
concepts:
- Tool
categories:
- Engineering Excellence
- DevOps
tags:
- Software Development
- Shift Left Strategy
Watermarks:
  description: 2025-05-07T12:57:02Z
  short_title: 2025-07-07T17:47:23Z
sitemap:
  filename: sitemap.xml
  priority: 0.6
videoId: r2G-NrSIj2k
url: /resources/videos/:slug
preview: https://i.ytimg.com/vi/r2G-NrSIj2k/maxresdefault.jpg
duration: 116
resourceTypes:
- video
isShort: false

---
# Rethinking Code Reviews: From Manual Checks to Pre-Reviewed Excellence

Hi, I’m Martin Hinshelwood, and today I want to discuss a topic that often sparks debate: **code reviews**. Traditionally, code reviews are seen as a way to improve quality and reduce defects by having multiple people review the code before it’s merged. While this has value, as we embrace shift-left practices, there’s a new perspective to consider: **pre-reviewed code**.

What if your code were effectively "reviewed" before it even reached a pull request? Let’s explore this evolving approach and how it can streamline your development process without sacrificing quality.

## The Traditional View of Code Reviews

For years, the primary argument for code reviews has been:

- **Improved quality**: Multiple eyes on the code can catch errors or highlight better ways to implement a solution.
- **Knowledge sharing**: Reviews help team members learn from one another, spreading knowledge about codebases and best practices.

These benefits are real, but traditional code reviews can also introduce bottlenecks, especially if they rely too heavily on manual intervention.

## Shifting Left: Pre-Reviewed Code

As we move toward modern [engineering practices]({{< ref "/tags/engineering-practices" >}}), there’s a growing emphasis on **pre-reviewing code**. Here’s what that means:

- **Automated validation**: By the time a developer submits a pull request, the code should already pass a suite of automated checks.
- **Streamlined pull requests**: With automated checks in place, pull requests become less about catching defects and more about strategic discussions, like architectural decisions or ensuring alignment with business goals.

## Why Pre-Reviewed Code Matters

Shifting toward pre-reviewed code delivers several benefits:

### 1. Faster Delivery

- Automated checks reduce the back-and-forth of manual reviews.
- Pull requests move through the pipeline more quickly, enabling faster delivery of value.

### 2. Early Defect Detection

- Automated tests and tools catch issues during development, not during the review phase.
- Problems are addressed immediately, saving time and effort.

### 3. Consistency and Quality

- Automated processes ensure consistent validation across all pull requests.
- Best practices are enforced without relying solely on individual reviewers.

## Best Practices for Code Reviews in a Shift-Left World

### 1. Automate Everything You Can

- Use tools to catch defects, enforce coding standards, and validate functionality before the pull request is even submitted.
- Examples of useful tools:
  - **SonarQube/SonarCloud**: For code quality and vulnerability analysis.
  - **[GitHub]({{< ref "/tags/github" >}}) Actions or Azure [DevOps]({{< ref "/categories/devops" >}}) Pipelines**: For automated build and test processes.

### 2. Make Pull Requests Mandatory

- No code should be merged into the mainline branch without going through a pull request process.
- Ensure that all pull requests pass automated checks before being eligible for review.

### 3. Focus Manual Reviews on Strategy

- Use code reviews to discuss architecture, business alignment, and other high-level considerations.
- Minimize the focus on defects or style issues, as these should already be handled by automation.

### 4. Use Validated Checks

- Require that all pull requests pass:
  - **Unit tests**
  - **Integration tests**
  - **Static code analysis**
  - **Security checks**
- These checks should run automatically and provide immediate feedback to developers.

## How Naked Agility Can Help

At **Naked Agility**, we’ve helped teams implement automated validation and streamlined code review processes. Here’s how we can support you:

- **Designing automated pipelines**: Build automated checks into your CI/CD pipeline to catch defects early.
- **Establishing best practices**: Create guidelines for pre-reviewed code and shift-left strategies tailored to your organization.
- **Tool selection and integration**: Help you choose and implement the right tools for your development environment.

Our goal is to help you deliver high-quality code faster while reducing manual effort and bottlenecks.

## The Future of Code Reviews

As engineering practices evolve, code reviews are becoming less about catching defects and more about fostering collaboration and alignment. By automating validation and shifting left, you can:

- Accelerate delivery without compromising quality.
- Empower developers with the tools and processes they need to write great code.
- Focus manual reviews on what really matters—building better products.

[Watch on Youtube](https://www.youtube.com/watch?v=r2G-NrSIj2k)
