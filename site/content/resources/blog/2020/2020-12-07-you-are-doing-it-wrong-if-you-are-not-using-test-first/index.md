---
title: You are doing it wrong if you are not using test first
description: Unlock the power of Test First principles in software development. Learn how TDD and ATDD can enhance quality, reduce bugs, and meet customer needs effectively.
ResourceId: yqHaiUlMNTP
ResourceType: blog
ResourceImport: true
ResourceImportId: 9469
ResourceImportSource: Wordpress
ResourceImportOriginalSource: Wordpress
date: 2020-12-07
AudioNative: true
creator: Martin Hinshelwood
layout: blog
resourceTypes: blog
slug: you-are-doing-it-wrong-if-you-are-not-using-test-first
aliases:
- /blog/you-are-doing-it-wrong-if-you-are-not-using-test-first
- /you-are-doing-it-wrong-if-you-are-not-using-test-first
- /resources/yqHaiUlMNTP
- /resources/blog/you-are-doing-it-wrong-if-you-are-not-using-test-first
aliasesFor404:
- /you-are-doing-it-wrong-if-you-are-not-using-test-first
- /blog/you-are-doing-it-wrong-if-you-are-not-using-test-first
- /resources/blog/you-are-doing-it-wrong-if-you-are-not-using-test-first
tags:
- Agile Problem Solving
categories:
- DevOps
- Scrum
- Technical Excellence
preview: nkdAgility-PSD-Krakow-0-1-1.jpg

---
Many teams are struggling with delivering modern software because they are not building with Test First Principals. Test First gives us the assurance that we have built the correct thing, that what we built is what the customer asked for and that when we change things we don’t break anything inadvertently.

[Updated to reflect the 2020 Scrum Guide!](https://nkdagility.com/the-2020-scrum-guide/)

## TL;DR;

While it takes time, effort, dedication and discipline to achieve Test First the return on investment is enormous. A common form of Test First is Test Driven Development (TDD) and we can use it to meet more of our customer's expectations, minimise our maintenance costs, and get fewer regressions and bugs in production. Ultimately without working in a test-first culture, you will be [unable to do continuous delivery](/blog/continuous-deliver-sprint/) with any confidence.

The only question for professional [Developers](/the-2020-scrum-guide/#developers) is how to get started.

## You are doing it wrong if you are not using test first

If you look up Test First on Wikipedia you will be redirected to the Test Driven Development (TDD) page and I believe this to be incorrect. While TDD is one, arguably the most effective, form of Test First it is by no means the whole thing. Can I achieve Test First with no automation at all: Yes. Can I do TDD with no automation at all: No. Do you see my conflict…

> **_If you are building applications without writing your tests first then you are doing it wrong. Your process will result in significant rework, be less maintainable and be less likely to meet the customers needs._\*\***Scottish Software Proverb\*\* (just made it up, and I am Scottish)

Unfortunately, while the proverb above is absolutely true there are many fanatics that will not accept that you can do test-first without automation. Just like the **Process Wars**, the **Practice Wars** are being waged around us, and while we want to endeavour to be agnostic it is not possible to be an atheist.

You will hear a lot of different terms banded about in relations to test first:

- **Test-Driven Development (TDD)** – Automated tests created before the code is written to validate that we need that code.
- **Acceptance Test Driven Development (ATDD)** – Tests, either automated or manual, that validate business functionality
- **Behaviour Driven Development (BDD)** – An automated test that validates a particular behaviour that you want your application to have.
- etc…

> All of these topics, and more, are covered in the [Professional Scrum Developer (PSD) training](/training/courses/professional-scrum-developer-training/) that was build in combination with Scrum.org and Microsoft as the only official team training for Scrum & DevOps.

These terms all fulfil a specific niche and the evolution of modern software development will sprout many more. Find that which solves your specific problem and adapt until you have something that works for you, your team and your organisation.

## The essence of test first

Test First has two main goals, both of which are as important as each other.

The first is about professionally validating that which you have built. Software Development is complicated and one can easily create unintended results when that code is executed. This is not a quotient of poor programming but of the complexity of the task. In the eighteen hundreds, plumbers pumped smoke through the pipes to make sure that there were no leaks on the grounds that if it is good enough for the smoke it is good enough for water. This mentality has resulted in what we now call the ‘smoke test’ in software development and the result of its implementation is bugs in production. When compared to software development plumbing is simple; modern software is many times more complex than Software was even 10 years ago. We have accepted poor quality deliverables and expensive maintenance for far too long.

The second goal is to shorten your feedback loops. The closer our engineers are to when the problem was created the quicker they can find it and the cheaper it is to fix. Unfortunately, it is impossible to tell in most software what ‘right’ looks like and developers just take a guess. The attitude that a problem, if it exists, will be caught by Quality Assurance (QA) or User Acceptance Testing (UAT) is unprofessional at best and incompetence at worst. We want to **know** that what we have just written not only meets our customer's expectations but also does exactly what we intended for it to do under as many circumstances as we can think of.

> **_Test First allows us to mature from simply testing quality in towards building that quality in from the start_\*\***Jeff Levinson\*\*, Architect at Boeing

Fundamentally it is far cheaper to fix an issue closest to its source. The longer we leave the finding of that defect the more expensive it becomes. A bug found in production is [10 times more costly](http://www.scrum.org/About/All-Articles/articleType/ArticleView/articleId/644/Agile-Economics-The-Dollars-and-Sense-of-Scrum) to fix than the same bug found in development.

The three virtues of Test First:

1. Validation of building what was asked for
2. Validation that what we have built works as we intended
3. Validation that changes have not broken original intent

Ideally, we want our tests to be as close to the code as possible, but also as easily understood by the customer as possible. Ideally, all of our code is automated and we have an executable specification. It's a balancing act…

### Business Validation – We have built what was asked for

Getting validation that we are building the right thing is key to actually being able to build the right thing. This sounds like a no-brainer but what do we usually do?

Well, we usually take our requirements, in whatever form we generally make them, and give them to our coders to turn into working software. Quite separately we give the same requirements to our testers and they create a bunch of tests to validate what we have built.

Did you notice the problem with this workflow?

> **_The worst that can happen is that we built exactly what the customer asked for!_**

How can we ever build to meet the measure if we don’t build to what is to be measured? We need to flip that on its head and instead have the tests created first (the measure) and then Code to make the tests pass. Now that we have removed the inevitable time-consuming rework we can take that time and use it to create even more value for our customers.

In addition, we are far more likely to be able to meet our customers expectations now we have an additional level of focus provided by those tests.

### Developer Validation – What we have built works as we intended

It's now 2020 and gone are the cowboy days of the late nineties and [early naughties](http://en.wikipedia.org/wiki/Naughties). Along with [using modern source control](https://nkdagility.com/getting-started-with-modern-source-control-system-and-devops/), software engineers can no longer hide behind their management as "not giving the approval to do Unit Testing", or changing what "unit testing" means to allow them to bypass the requirement. This is [about professionalism](/blog/scrum-tapas-importance-professionalism/) and all developers, no matter what they are working on, should be validating the work that they do.

> **_You are not a professional if you do not do the due diligence necessary to validate what you have created works as intended and continuous to do so.  
> \-[Professional Scrum teams build software that works](https://nkdagility.com/professional-scrum-teams-build-software-works/)_**

There are two main value-adds here. The first is that when a coder creates functionality it does exactly what he intended and we have a record, and executable specification, of what that intent was. The second comes later. When we go to add functionality later we know when we have broken existing functionality and that is one of the most valuable parts of this endeavour.

**Can you imagine how amazing it would be if you could use this executable specification to validate all future changes don’t break your application?**
