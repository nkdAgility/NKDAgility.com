---
title: 'Fragile by Design: The Cost of Pretending to Be Resilient'
short_title: 'Fragile by Design: The Cost of Fake Resilience'
description: Explores how poor engineering, shallow product thinking, and organisational denial lead to fragile systems, stressing that true resilience requires rigorous, real-world testing.
date: 2025-05-12T09:00:00Z
weight: 165
ResourceId: LGGuvRq4g7p
ResourceImport: false
ResourceType: blog
slug: fragile-by-design-the-cost-of-pretending-to-be-resilient
aliases:
- /resources/LGGuvRq4g7p
ResourceContentOrigin: hybrid
subtitle: You don't rise to the level of your continuity plan. You fall to the level of your last real test.
aliasesArchive:
- /fragile-by-design--the-cost-of-pretending-to-be-resilient
- /blog/fragile-by-design--the-cost-of-pretending-to-be-resilient
concepts: []
categories:
- Engineering Excellence
- Product Development
- Technical Leadership
tags:
- Technical Mastery
- Pragmatic Thinking
- Engineering Practices
- Site Reliability Engineering
Watermarks:
  description: 2025-05-07T12:49:09Z
  short_title: 2025-07-07T16:44:17Z

---
Most systems are not resilient. They are fragile by design—propped up by a fantasy of "continuity" that vanishes the moment real pressure hits.

Spain’s national blackout. Portugal’s cascading failures. Oracle’s hospital cloud outage. Heathrow’s catastrophic shutdown. These were not accidents. They were not rare, unpredictable events. They were the inevitable consequences of bad engineering, shallow product thinking, and organisational self-delusion.

Resilience is not a checkbox. It is not a compliance exercise. It is not a hope and a prayer filed away in a disaster recovery plan. Resilience is hard. It is costly. It must be engineered, tested, and verified under real-world conditions—or it does not exist.

## Bad Engineering

Real resilience assumes things will fail. Networks will fail. Authentication systems will fail. People will make mistakes. If your architecture does not _assume failure_ at every level, you are not resilient; you are brittle.

Spain’s energy grid collapsed because it was optimised for efficiency, not survivability. No dynamic rerouting. No true load isolation. No meaningful observability. Their system was designed for perfect operating conditions that do not exist outside PowerPoint decks.

Oracle’s outage was even worse. Critical healthcare systems went offline because Oracle’s cloud infrastructure had no effective multi-region failover. Their architecture did not degrade gracefully; it fell over completely. That is not resilience. That is negligence at scale.

## Bad Product and Continuity Thinking

Resilience is a **product capability**. If your product cannot survive failure, it is not a product. It is a liability.

Spain, Portugal, Oracle—all treated continuity as an afterthought. As long as the lights were on today, everything was declared fine. Until it was not.

Real product [leadership]({{< ref "/categories/leadership" >}}) demands harder questions: _When—not if—this part fails, how will our system recover? How will our customers experience it? How fast can we restore service? How much risk are we carrying—and is that risk acceptable?_

If those questions are not part of your roadmap, your architecture, and your operational strategy, you are not building resilience. You are building a house of cards.

## Organisational Blindness

The real failure sits higher up the chain. Leadership failed to create a culture that prioritised operational survivability over operational fantasy.

I have lived through this firsthand. At Merrill Lynch, I participated in two major disaster recovery exercises. Both were declared “successful.” Both were complete failures.

Not a single system restored was actually usable. Systems were technically “back online”—but functionally, nothing worked. And the root cause was obvious: Active Directory, the system everything depended on for authentication, was never successfully recovered. Without it, every other "restored" system was dead weight.

Ironically, my application was successfully restored. We assumed it would have been usable—_if_ Active Directory had been available. But we never found out. Two years running, the same critical dependency remained broken, and nobody was willing to call it what it was: systemic failure hidden behind fake success metrics.

Heathrow Airport offers another textbook case of organisational blindness disguised as resilience. When a fire broke out at one of their substations, they publicly blamed the disruption on their third-party power supplier. What they failed to mention was critical: Heathrow receives power from _three independent substations_, any one of which can fully power the airport alone.

The real problem was not the power supply it was a fluctuation in the power supply. It was Heathrow’s own disaster recovery system, designed to “protect” infrastructure by shutting everything down that detected that fluctuation and activated.  
The result? Heathrow’s entire IT backbone collapsed. It took the rest of the day to get basic systems running again—and much longer to recover from the cascading operational chaos.

Instead of owning the internal failure, leadership pointed fingers outward. It is the same story everywhere: an unwillingness to face the reality that their own fake resilience made the disaster worse.

## Real Resilience: Iterating Over the Pain

Not every story ends in failure. There are organisations that do it right—and the difference is discipline.

Take Rackspace. During catastrophic floods in London, when almost every other datacentre in the city failed, Rackspace’s facility stayed operational. Their backup generators worked exactly as expected. While others blamed suppliers and scrambled for excuses, Rackspace quietly kept their customers online.

When asked why their systems worked when everyone else’s failed, the CEO simply held up a key.

It was the key to the power room.

Every month, without fail, he would walk down, unlock the main breaker, and physically pull it—shutting off external power. Not in theory. Not in a simulation. A real, full transfer to emergency backup power under real-world conditions.

Because of that brutal discipline, they did not hope their disaster recovery systems would work. They _knew_. They had tested it, again and again, under real conditions. They iterated over the pain.

And that is the lesson:  
If something is hard, you must do it _more often_, not less.  
If failure is painful, you must _lean into it_, not avoid it.

Only by living through controlled, intentional failures—early, often, and brutally—can you build true resilience.

You cannot wait until it matters. You cannot prepare only on paper. You must _earn_ resilience by testing your systems, exposing your weaknesses, and getting punched in the face repeatedly until you are strong enough to survive the real thing.

## Resilience Is Built, Not Bought

You cannot buy resilience from a vendor. You cannot inherit it automatically because you deployed to "the cloud." You cannot declare yourself resilient by writing it into your incident response plan.

Real resilience is built. It is designed in. It is iterated over. It is relentlessly tested. It is painful, slow, and expensive. But the alternative—the fragility we saw in Spain, Portugal, Oracle, and Heathrow—is far more costly.

If you are not engineering for failure, you are engineering for collapse.

Fragility is not an accident. It is a design choice.  
Pretending otherwise only guarantees you will learn the hard way.
