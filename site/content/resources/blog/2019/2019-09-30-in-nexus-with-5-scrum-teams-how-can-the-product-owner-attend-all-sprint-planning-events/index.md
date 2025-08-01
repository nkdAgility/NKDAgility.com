---
title: In Nexus with 5 Scrum teams, how can the Product Owner attend all Sprint Planning events?
short_title: Product Owner Role in Nexus Sprint Planning
description: Explains how a Product Owner can manage Sprint Planning across multiple Scrum teams in Nexus by delegating, using area or team owners, and maintaining clear communication.
date: 2019-09-30
weight: 640
ResourceId: As4R5dKsJtU
ResourceImport: false
ResourceType: blog
ResourceContentOrigin: Hybrid
slug: in-nexus-with-5-scrum-teams-how-can-the-product-owner-attend-all-sprint-planning-events
aliases:
- /resources/As4R5dKsJtU
aliasesArchive:
- /blog/in-nexus-with-5-scrum-teams-how-can-the-product-owner-attend-all-sprint-planning-events
- /in-nexus-with-5-scrum-teams-how-can-the-product-owner-attend-all-sprint-planning-events
- /in-nexus-with-5-scrum-teams,-how-can-the-product-owner-attend-all-sprint-planning-events-
- /blog/in-nexus-with-5-scrum-teams,-how-can-the-product-owner-attend-all-sprint-planning-events-
- /in-nexus-with-5-scrum-teams--how-can-the-product-owner-attend-all-sprint-planning-events-
- /blog/in-nexus-with-5-scrum-teams--how-can-the-product-owner-attend-all-sprint-planning-events-
- /resources/blog/in-nexus-with-5-scrum-teams-how-can-the-product-owner-attend-all-sprint-planning-events
layout: blog
concepts:
- Method
categories:
- Scrum
- Product Development
tags:
- Agile Frameworks
- Agile Product Management
- Professional Scrum
- Software Development
- Scrum Team
- Product Owner
Watermarks:
  description: 2025-05-07T13:16:08Z
  short_title: 2025-07-07T17:58:25Z
ResourceImportId: 39855
creator: Martin Hinshelwood
resourceTypes: blog
preview: 146713119-1-1.jpg

---
As part of the [Scrum]({{< ref "/categories/scrum" >}}).org webinar “Ask a [Professional Scrum]({{< ref "/tags/professional-scrum" >}}) Trainer - Martin Hinshelwood - Answering Your Most Pressing Scrum Questions” I was asked a number of questions. Since not only was I on the spot and live, I thought that I should answer each question that was asked again here, as well as those questions I did not get to.

In case you missed it, here is the recording of yesterday's Ask a Professional Scrum Trainer webinar with Martin Hinshelwood! Watch here: [http://ow.ly/ijiM50vwEkD](http://ow.ly/ijiM50vwEkD)

### \[Question\] In Nexus with 5 Scrum teams, how can the [Product Owner]({{< ref "/tags/product-owner" >}}) attend all Sprint Planning events?

As you increase the number of Teams in a Nexus you can very quickly run into this common [scaling]({{< ref "/tags/scaling" >}}) issue. While Nexus talks about a single Product Owner who has overall accountability and ownership of the [Product Backlog]({{< ref "/tags/product-backlog" >}}), you may need to scale the Product Owner role as your Nexus grows. My usual starting point here is to look at how the Product Backlog is decomposed. It may be that my Product Owner only provides detailed [leadership]({{< ref "/categories/leadership" >}}) down to the Feature level and not to the Product Backlog Level. This leaves the [Scrum Team]({{< ref "/tags/scrum-team" >}}) with ownership there, and releases pressure on the Product Owner. The Product Owner would then only require to attend the Nexus Sprint Planning portion, and would delegate the rest. As long as the Product Owner effectively communicates their vision & expectations as part of the Nexus Sprint Goals, the Scrum Teams should be able to work towards fulfilling them.

> Product Backlog Items can be delivered in a singe Sprint with a preference for smaller.
>
> Features are too big for a single team Sprint and may be delivered across multiple Sprints or Teams
>
> Epics are too big for a Release and would be composed of many Features.
>
> \-Martin Hinshelwood

Each Scrum Team would then be free to choose how they manage this and make sure that they have enough ready Backlog Items for their part of Sprint Planning. Usually they will designate, or have, a virtual Product Owner that is dedicated to their team. This virtual PO role could be called a “Area Owner” if their Scrum Team is focused on only one area of the Product, or a “Team Owner” if there are many teams in the same area. This is roughly how the Azure [DevOps]({{< ref "/categories/devops" >}}) engineering teams break down:

\-Product Owner

> |----Work Item Product Owner
>
> |--- Team A Product Owner
>
> |---Team B Product Owner
>
> |----Source Control Product Owner
>
> |----etc.

In this case they have ~42 teams that roll up to ~6 Product Areas, and is just one example of how you might structure things. The danger is in disrupting the flow of information by increasing the distance between the Product Owner and the Development Team. The [Azure DevOps]({{< ref "/tags/azure-devops" >}}) engineering teams mitigate this with Autonomy. Each Area Owner is only looking at their functional area while fulfilling the vision set by the Product Owner, and the Team Owner is communicating constantly with their peers and the Area Owner.

If you do implement some kind of hierarchy I recommend focusing on keeping it as flat as posible and understanding that each of these folks, Product Owner, Area Owner, & Team Owner are fulfilling the role of the Product Owner as per the Scrum Guide as part of a Scrum Team. For the question above I would likely start with a dedicated Team Owner for each team that is the representative that attends the Nexus Sprint Planning and that works closely with the Product Owner. This will likely need close monitoring and a skilled [Scrum Master]({{< ref "/tags/scrum-master" >}}) to help coach the teams to maintain communication and not loose focus.

While there are no right answers there are some answers that are better than others. For your given situation select the most right answer, and iteration to the best version of it.
