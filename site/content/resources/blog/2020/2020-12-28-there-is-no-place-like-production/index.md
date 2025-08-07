---
title: There is no place like production
short_title: There Is No Place Like Production
description: Validating product value requires releasing features to real users in production, gathering feedback, and measuring usage, satisfaction, and business impact for improvement.
tldr: To deliver real value and reduce risk, teams must release features to production quickly so real users can provide feedback, since assumptions and testing environments cannot replace actual usage. Key measures like customer satisfaction, product usage, and employee satisfaction help validate value, and releasing early also offers financial benefits through capital expenditure write-downs. Prioritize getting small increments into production to maximize learning, value, and organizational savings.
date: 2020-12-28
lastmod: 2020-12-28
weight: 440
sitemap:
  filename: sitemap.xml
  priority: 0.5
  changefreq: weekly
ResourceId: KUJ7jHOGqP7
ResourceImport: false
ResourceType: blog
ResourceContentOrigin: Hybrid
slug: there-is-no-place-like-production
aliases:
  - /blog/there-is-no-place-like-production
  - /there-is-no-place-like-production
  - /resources/KUJ7jHOGqP7
  - /resources/blog/there-is-no-place-like-production
aliasesArchive:
  - /blog/there-is-no-place-like-production
  - /there-is-no-place-like-production
  - /resources/blog/there-is-no-place-like-production
layout: blog
concepts:
  - Principle
categories:
  - Product Development
  - Product Management
tags:
  - Customer Focus
  - Product Validation
  - Pragmatic Thinking
  - Value Delivery
  - Working Software
  - Current Value
  - Agile Product Management
  - Evidence Based Management
  - Product Discovery
  - Agile Philosophy
  - Product Delivery
Watermarks:
  description: 2025-05-07T13:15:08Z
  short_title: 2025-07-07T17:57:40Z
  tldr: 2025-08-07T13:10:40Z
ResourceImportId: 45324
AudioNative: true
creator: Martin Hinshelwood
resourceTypes: blog
preview: wizard-of-oz-ruby-slippers-2018-billboard-1548-2-2.jpg

---
Value is such a subjective thing that we will often be wrong, and there is no way around that wrongness. In order to minimise the wrongness and maximise the amount of value that we deliver we need to have a clear understanding of what our users need, how they are using the product, and validate our new value as soon as we can. Without validation we only have assumptions and assumptions can be dangerous.

As a start we can collect some qualitative data to validate some of our assumptions:

- **[Customer Satisfaction]({{< ref "/tags/customer-satisfaction" >}})** - is a key measure as it is an indication of the happiness of your users with the features that you currently have in your product.
- **Product Usage** - Its key to see just how much of our product is being used by our users. There is no point in trying to add features to areas that are not being used. Features are only valuable if they fulfil some need for users and the business and usage is a key indicator of value.
- **Employee Satisfaction** - is another key indicator. If our employees feel that they understand how their work contributes to the overall product vision then they will leverage that focus and understanding towards building a better product.

For additional ways to measuring value to enable improvement and agility check out [The Evidence-Based Management Guide](https://nkdagility.com/the-evidence-based-management-guide-measuring-value-to-enable-improvement-and-agility/#h-current-value-cv-1)

## Real-Users create real-feedback

The only way to validate our assumptions is to get our perceived value in front of some subset of real users and gather feedback. I want to also be 100% clear that the term "real-users" does not mean Staging or UAT; it means production. When you ask someone to test something they do not use it in the same way that they would if they were using it for real. Following a test-script is not a real user.

## Releasing is the only way to deliver value

Without getting our [increment]({{< ref "/tags/increment" >}}) in front of those real-users we also don't have any value. Its effectively sitting on our shelf in the warehouse and is depreciating. What is the cost of delay for your feature? If you could get this value, this new business feature, into the hands of real users and make their lives easier how much money would you save? You cant save that money until users can actually use that feature.

## A financial reason to release early

And speaking of depreciation all of the software that you are creating, these new features, are capital expenditure. Your finance department is able to offset capital expenditure, and indeed often experimental features, against your tax! However, you are only generally allowed to do that once your features are in production. if you can get a smaller capital expendature into production and start writing it down on a monthly basis early you can compound that write-down by the end of the year. This could be a masive saving for your organisation.

## There is no place like production

My favourite quote is from Brian Harry, the product unit manager at Microsoft and technical fellow:

> "There is no place like production"
>
> \-Brian Harry

No mater how much testing, UX discovery, and UAT, that you do there will always be more things that you discover once you get into production. It is just not possible to simulate a production environment. We are much more likely to be successful and create value by getting the smallest piece of value into production and validating that it is indeed as valuable as we thought.
