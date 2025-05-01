---
title: Stop Writing Business Logic in Stored Procedures
description: Stop writing business logic in SQL stored procedures! Embrace refactoring for testable, maintainable code and elevate your engineering practices.
ResourceId: utAzlIGxj7O
ResourceImport: false
ResourceType: blog
ResourceContentOrigin: hybrid
date: 2025-06-23T09:00:00Z
weight: 380
aliases:
- /resources/utAzlIGxj7O
aliasesArchive:
- /stop-writing-business-logic-in-stored-procedures
- /blog/stop-writing-business-logic-in-stored-procedures
categories:
- Engineering Excellence
tags:
- Technical Mastery
- Engineering Practices
- Software Development
- Technical Excellence
- Operational Practices
- Pragmatic Thinking
- Technical Debt
- Continuous Improvement

---
Over the years, I've encountered many companies that have maintained their business logic in stored procedures, but the practice of doing so has died out, for good reasons ill hilight below. However, many codebases have been around for 10+ years, and may still have large amounts of business logic in them.

If you’re still writing business logic in SQL Stored Procedures, it’s time to stop. If you still have code that stores business login in  SQL Stored Procedures its time to refactor!

I’m not saying rewrite everything at once. That would be ridiculous. It’s a massive cost with no direct stakeholder value. What I _am_ saying is this:

> From this point forward, stop creating new business logic in stored procedures.
>
> And when you _must_ change one, refactor that logic out into testable, mockable, maintainable code.

This is not about doing everything at once!

Take inspiration from the Azure [DevOps]({{< ref "/categories/devops" >}}) team. When they decided to eliminate their suite of brittle, long-running system tests, they didn’t try to replace them in a single sprint. It took them four years of consistent work, in three-week sprints, to fully remove and replace those tests with something better. One step at a time. That’s what change looks like.

Break the cycle of adding more mess to the mess. Every stored procedure you don't write is a future bug you won't have to debug in production. Every time you choose code over SQL for business logic, you're reclaiming control of your system.

## Stored Procedures are the wrong place for Business Logic

Let’s be clear: this isn’t an abstract architectural debate. The reasons stored procedures are a bad place for business logic are grounded in hard-learned lessons from real teams, real outages, and real maintenance headaches. If you're serious about [engineering excellence]({{< ref "/categories/engineering-excellence" >}}), you need to treat stored procedures as a legacy constraint, not a strategic tool.

1. **They can’t be tested properly** - You need a full database instance with seed data. You need to run a slow test harness. There’s no mocking, no fast feedback, no isolation. If it can’t be unit tested, it can’t be trusted. Long-running system tests do not tell you if the code works, only that the long-running system tests that you created work.
2. **They don’t participate in CI/CD** - Stored procedures are almost always deployed manually or via fragile SQL scripts. While it can be automated by things like Redgate, it's often still brittle, breaks reproducibility, and blocks automated pipelines.
3. **They aren’t version-controlled like real code** - While you can have them under source control, they are "copied" into source control..**.** either by Readgate or manually by a developer. Manual tasks are risky! Remember the Knight Capital Group!
4. **They tightly couple your logic to the database** - That kills portability and locks you into a specific database engine. It also makes testing, debugging, and observability painful. There have been attempts in the past to create "Unit Tests" for stored procedures, but they have largely been abandoned in favour of just getting our logic out of that scenario.
5. **They don’t scale** - Stored procedures run on the most expensive, least scalable part of your infrastructure: the database server. Business logic belongs in services that can scale out.
6. **They violate the separation of concerns** - Your database should store and retrieve data. Your application should handle logic. Stored procedures blur that line and create a big ball of mud.
7. **They’re hard to reason about** - No dependency injection. No composition. No mocking. No telemetry. No proper logging. Just deeply procedural code with limited tooling support. If you have to rely on a debugger to see if your code works, you are doing it wrong.

Before you write the next line of business logic in a stored procedure, ask yourself: is this something I want to debug at 2am with no tests, no telemetry, and no rollback plan?

That’s the reality of stored procedures. They make every part of your engineering practice harder. Get the logic out. Put it where it belongs—alongside the rest of your tested, observable, maintainable code.

## The strategy: don’t rip, refactor

You don’t need permission to start this. You don’t need a project. You just need a commitment to modern engineering discipline:

- When you build new features, do it in application code, not SQL.
- When you touch an existing stored procedure, _refactor it_. Move the logic into testable code.
- Leave a thin wrapper if necessary, but relocate the behaviour.

This is a _pay-as-you-go_ modernisation strategy. It lets you progressively reduce [technical debt]({{< ref "/tags/technical-debt" >}}) without halting delivery.

## The benefits are compounding.

Every time you refactor, you:

- Increase the ability to create unit tests
- Improve maintainability
- Enable faster feedback loops
- Reduce runtime costs
- Shrink the surface area for bugs
- Move toward [continuous delivery]({{< ref "/tags/continuous-delivery" >}})

No single change flips the system. But every change you make is a step away from the fragile procedural past and toward a sustainable engineering future.

## The outcome?

This isn’t about dogma. It’s about discipline. Modern [software development]({{< ref "/tags/software-development" >}}) demands testability, traceability, observability, and scalability. Stored procedures give you none of that.

If you're maintaining logic in stored procedures, you're fighting your tooling, your pipeline, and your team. Stop doing that.

Start small. Move incrementally. Raise the bar.

Modern software is built in code, not SQL.
