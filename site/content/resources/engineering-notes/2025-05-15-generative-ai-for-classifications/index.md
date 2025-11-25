---
title: How I Used Generative AI to Transform Site Tagging and Categories
short_title: Generative AI for Automated Site Tagging
description: Explains how generative AI and PowerShell scripts automate and improve blog post tagging and categorisation in Hugo, with human oversight and transparent audit trails.
tldr: Migrating a large, legacy blog to Hugo enabled the use of generative AI for automated tagging and categorisation, significantly improving content discoverability and editorial consistency while reducing manual effort. The system combines AI-driven suggestions with human oversight, using multi-factor scoring, penalty logic, and transparent reasoning to ensure quality and accountability. Development managers considering similar automation should maintain human control over final decisions and leverage AI to streamline, not replace, editorial processes.
date: 2025-05-15T09:00:00Z
lastmod: 2025-05-15T09:00:00Z
weight: 470
sitemap:
  filename: sitemap.xml
  priority: 0.4
  changefreq: weekly
ItemId: oRStCAqLAY4
ItemType: engineering-notes
ItemKind: resource
ItemContentOrigin: human
slug: how-i-used-generative-ai-to-transform-site-tagging-and-categories
aliases:
  - /resources/oRStCAqLAY4
concepts:
  - Tool
categories:
  - Uncategorized
tags:
  - Artificial Intelligence
  - Personal
  - Technical Mastery
  - Transparency
  - Pragmatic Thinking
  - Agentic Engineering
Watermarks:
  description: 2025-05-07T13:48:01Z
  short_title: 2025-07-07T16:44:11Z
  tldr: 2025-08-07T12:32:16Z
ResourceId: oRStCAqLAY4
ResourceType: engineering-notes
---

I moved my blog to Hugo in mid-2024 to regain control over my content and workflow. This proved to be a great decision as it gave me the ability to really focus on content for my site.

My site has been around since 2006 and was originally on GeeksWithBlogs, then Blogger, and then WordPress. As it moved, it grew in complexity, but updating legacy things like "old posts" and "categories" became painful in WordPress when you have 800+ posts. If you have tried to use the WordPress API, you will understand the pain.

So when I moved, I wanted my content to be portable, static, and in a data format that I could easily manipulate. I chose Hugo as the site generator, with Markdown and YAML as the data formats (with some JSON as you will see below). This made it very easy to write scripts over the top of the Markdown and update it dynamically. I built a bunch of such scripts, and it became apparent very early that AI could play a fantastic part in the story. My first implementation of AI was to use a prompt to ensure that my posts all had an SEO-friendly description. This worked great and produced some fantastic descriptions, but while it’s tempting to treat AI as a black box, that’s reckless. AI systems have **agency**, but it is limited to **tactical optimisation** , they can suggest, rank, and cluster, but they cannot **own accountability** for what gets published or accepted. That’s the human’s job.

This post outlines the architecture and technical strategy I implemented to integrate OpenAI into my Hugo site for automated classification, while maintaining human oversight and ensuring auditability.

### Why I Built This

I realised pretty quickly that many of my tags and categories were vague, uninteresting, and often just wrong. I had over 1,000 tags and 200 categories, which made discoverability a nightmare. So I decided to see if I could leverage generative AI to do the classification for me once I had pruned my categorisations.

I finally ended up with about 140 tags and 12 categories, but more recently also introduced the idea of "Concepts" to classify the classifications , what fun.

Overall I wanted to:

- **Improve discoverability** across hundreds of blog posts.
- **Align tags and categories** with consistent editorial standards.
- **Reduce manual labour** but keep ultimate control in human hands.
- **Make classification decisions traceable and explainable.**

Automation without traceability is irresponsible. This system deliberately blends machine suggestions with deterministic validation and penalty logic to ensure reliable, explainable outcomes.

While I started with just a dump of my 19 years of categories and tags, over that time I had moved from a web developer through DevOps and Scrum to a process consultant. As you can imagine, the context of the taxonomies and their intent changed a lot over time. I needed to really think about what I wanted for each, and the new classification system relies on three interconnected layers:

- **Concepts** → High-level thematic anchors that describe foundational ideas (e.g., Philosophy, Practices, Methods, Values, Strategy). These are used to "classify the classifications."
- **Categories** → Editorially curated groupings that organise posts into broad topic clusters aligned with user needs (e.g., Technical Leadership, Product Development, Scrum, Kanban). Some tags are promoted to categories for marketing purposes.
- **Tags** → Detailed, fine-grained descriptors that capture specific topics, techniques, tools, or patterns (e.g., Scrum Mastery, CI/CD, Azure Pipelines).

By combining these, I created a multi-level structure that improves searchability, recommendation accuracy, and editorial consistency. Tags have categories, and both tags and categories have concepts. I think of tags and categories as a single list, but categories are few, important, and go at the top of the content, and tags are many, tactical, and go at the bottom.

The AI assigns tags, categories, and concepts to all the content items using "instructions" embedded in the classification pages.

I'm a Windows user and have been for years, so I wrote all of the scripting in PowerShell. For me, this is the most flexible as it’s native, and anything I can’t do in PowerShell I can use C#. I do have some calls out to Python, but that’s another post. Iterating over a bunch of Markdown files with YAML front matter is a trivial experience, but I have built up a bunch of helper modules over the last 6 months that do a lot of the heavy lifting , so much so that it can take minutes to build new scripts for specific one-time tasks. For example, if I want to get a list of all my content resources pre-parsed into an ordered front matter hashtable and the content, then all I need to do is call `$hugoMarkdownObjects = Get-RecentHugoMarkdownResources -Path ".\site\content\resources\" -YearsBack 1` and I have a ready-to-iterate collection.

I also have a batch version, and all of my code is in GitHub where it can be versioned, branched, and reviewed with a PR.

## How it Works

I created a JSON cache format to reliably store the results from OpenAI. This design gives me a structured, reusable data layer that feeds the rest of the system with clean, consistent inputs. Initially, I tried creating a prompt with a list of all 160 tags and categories and asking the AI to select them, but that created a bunch of junk.

Ultimately, I settled on a single call for each classification that tested that classification against the content, based on clear instructions from the classification front matter. The result is that for each piece of content and every classification, I have an entry in the cache file that looks like:

### Example Output

```json
{
  "Technical Leadership": {
    "resourceId": "TwYNSm1pZOS",
    "category": "Technical Leadership",
    "calculated_at": "2025-05-05T13:24:31",
    "ai_confidence": 82.5,
    "ai_mentions": 7.5,
    "ai_alignment": 8.5,
    "ai_depth": 8.0,
    "ai_intent": null,
    "ai_audience": 7.0,
    "ai_signal": 8.0,
    "ai_penalties_applied": false,
    "ai_penalty_points": 0,
    "ai_penalty_details": "none",
    "final_score": 82.0,
    "reasoning": "The content discusses the Definition of Done (DoD) within the context of Scrum, which is a key aspect of agile methodologies. It directly addresses the importance of quality and transparency in software development, aligning well with the principles of technical leadership. The explicit mention of the DoD and its role in ensuring quality reflects a strong understanding of servant leadership and accountability within teams. The content thoroughly explores the implications of having a DoD, including its impact on team dynamics, accountability, and continuous improvement, which are all relevant to technical leadership. The intent is clearly to inform and guide teams on best practices, making it suitable for the target audience of technical leaders and practitioners. The signal-to-noise ratio is high, with minimal off-topic content, focusing instead on actionable insights and strategies for implementing a robust DoD. Overall, the content fits well within the category of Technical Leadership, meriting a high confidence score.",
    "level": "Primary"
  }
}
```

This creates a bunch of scores from 0–10 in Mentions, Alignment, Depth, Intent, Audience, and Signal. It assesses penalties and creates a final score, out of 100, that represents how confident the AI is that it matches.

### AI + Human Oversight

AI here has **no editorial authority**. It supplies **probabilistic suggestions**. I maintain control using a mixture of content manipulation and reviewing the output, while the human-authored penalty and validation layers provide **deterministic enforcement**. This distinction is non-negotiable. AI is a tactical agent, not a strategic decision-maker.

This reflects the ethos outlined in [Human and AI Agency in Adaptive Systems](https://preview.nkdagility.com/resources/ffJaR9AaTl7): **humans set direction and own accountability; AI optimises within defined boundaries**.

## Technical Strengths

I've been very impressed with the capability, and I’ve also learned valuable lessons about where AI shines and where human judgment is indispensable. Every classification has a clear reason for being attached to the content that’s reviewable and transparent. I even use the reasoning on the site.

- Quantitative, multi-factor assessment.
- Penalty and validation rules strengthen match quality.
- Human-readable reasoning baked into outputs.
- Cached results reduce API calls and speed up builds.
- Seamless integration into Hugo’s version-controlled structure.

### Future Enhancements

- Track classification shifts over time.
- Introduce ensemble AI models for cross-validation.
- Add a human review loop to feed corrections back into system tuning.
- Build a site-wide dashboard showing confidence trends, penalty patterns, and overall classification health.

## Closing Thoughts

Bringing AI into this system has been transformative, and if you’re considering similar work, my advice is simple: don’t delegate accountability , use AI to amplify your judgment. By combining automation with careful oversight, I’ve turned a massive manual maintenance burden into a scalable, transparent process. This work has not only improved the quality and consistency of my site, but it has also deepened my own understanding of how to use AI responsibly: as a partner in execution, not as a substitute for accountability. I’m excited about where this will go next and how it can push the boundaries of what’s possible in content management.
