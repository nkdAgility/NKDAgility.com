Technical debt is something that adds a massive cost to your product and the way you do things. But I want to be really clear that I'm including multiple things in technical debt because that's how people see it. So from a technical standpoint, technical debt is like it's the implied cost of future rework because we prioritised speed over long-term design. Right, so that's where we come to a decision point. We have to, we're building a feature and we can either do it the fast way or the right way, and we choose the fast way. Right, that's technical debt. It's usually deliberately incurred, right, with choices that we make. It's either deliberate by the engineer, deliberate by product leadership, or deliberate by the organisation.

There's also an unintentional technical debt that isn't generally, I mean, in general, people characterise it as technical debt for sure, but technically it's not technical debt. Trying to get my brain around that, but it's poor quality. Poor quality is not technical debt; poor quality is just poor quality. So when people talk about technical debt and they talk about, "We've got a lot of bugs in the system," they're probably not talking about technical debt; they're probably talking about poor quality. But they don't want to call it poor quality because that makes them look bad. "Why did you deliver poor quality?" says the CTO. I understand why you made decisions to expedite a feature in order to ship more quickly to our customers, but why did you ship poor quality?

Right, you will generally find that C-suite is not interested in poor quality. They want high quality; they want their product to work, and they want users to be happy. But they would be happy to make design decisions that expedite, right, that get things done faster. So the problem is that, maybe I'm being a bit jaded here, but I would say most engineering groups—I'm using the word group very specifically there, like department, group, perhaps team, depends on your context—they characterise poor quality as technical debt, like it's a choice. I mean, it is a choice. They deliberately didn't do the stuff they needed to do in order to maintain the quality of the product, and that builds up over time.

So technical debt builds up over time, and poor quality builds up over time. Poor quality is by far your biggest killer. Both create rework, both create higher costs of maintenance, both create slower development. It's harder to add features to your product because you made what we now realise are subpar design decisions. Right, we might have made the right decision at the time, but now it's the wrong decision because the world's changed, or the market's changed, or we shipped a bunch of crap to production, which is what I see quite often. I don't understand it, but I see it quite often with teams and with products that we don't deliver high-quality usable product to production. We deliver barely functioning product to production, and when you build new features on top of new barely functioning features on top of old barely functioning features, you're going to have barely functioning squared, and it starts to become excessive cost.

I use an example in one of my other videos of a company I worked with that had manual testers to 300 coders. That was because of poor quality. Definitely, some of it was to do with technical debt, but most of it was to do with poor quality. It was horrendous. So this has a massive cost. It has so much cost, and it's especially easy for it to happen when you take longer to ship your product to production. Right, so if you have a really long product cycle, let's say two years between releases, then the last six months is what they say is bug fixing. Right, but it's not really; you're out with the sticky tape and the super glue patching it up to a state where it can be shipped. If it's patched up, that means it's not right.

Okay, that some of that might be technical debt, and some of that might be low quality. It's the reason that Windows, for example, is so much more stable now than it ever was in the past. In the past, they used to have a six-year ship cycle, right, and that incurred massive amounts of debt and cost. And then when they came back around at the end to clean things up, some things were now fundamental to the product, and they couldn't clean them up; they had to paper over them. Right, you've got the paper mache over the top making it like a lovely glossy product. But then hackers and nefarious people come along and start peeling back at the edges to get underneath and exploit things in it.

With the new model that the Windows team work in, where they're delivering continuously to production, every member of every team is in charge of quality or part of that story of quality, of security. They go back and fix things on a continuous basis. They don't build up that technical debt anymore; they keep on top of it. And the way you keep on top of technical debt is to continuously deal with it. You're continuously refactoring; you're continuously re-architecting your product when things happen that you find you need to deal with.

A great example is when the Azure DevOps team ran into an issue that they'd moved to the cloud. They got a bunch of smaller services. One of those services was the profile service, right, where you give it an email address and it comes back with your profile data, like your picture and your friendly name and all of those kind of things. And something went wrong with the profile service, and because the profile service wasn't responding, the entire system didn't work. You couldn't change work items; you couldn't commit code; you couldn't do any of the things that, anytime it called the profile service, you couldn't even view code because it was calling the profile service to get the friendly names for the people that were committing the code, right, in the history and stuff, or the work items. Right, you couldn't see anything in the work items.

So, but why? Right, if there's something wrong with the profile service, just show the email address. You don't need to go get the friendly name. I, as a user, might go, "Why is it just showing me the email address?" But I can still use the system; I can still work. Right? And that was there because they made architectural decisions that were perhaps done for expediency, perhaps done deliberately, but also could be done accidentally. Right? They didn't realise this was going to be a problem in the future. But as soon as they figured that out, they realised this technical debt. We had a production incident because of our design choices, right? This service was too tightly coupled, and we need to figure out what was the cause of the problem. Well, it's this tightly coupling. What do we need to do about it? Well, we need to go re-architect, and anywhere that calls this service, we need to introduce—in this case, it was introduced the circuit breaker pattern. So that when it's not working, it just turns it off and doesn't keep trying to call it. It just stops calling it, and then maybe every ten seconds it goes, "Is it working? No. Is it working? No. Okay, wait a minute. Is it working? Oh yeah, it's working now," so we can reconnect it. Right? That's a circuit breaker pattern.

So they did that so that they would never have that problem again. It would never happen that the profile service going out would result in another service not working. Right? So that's paying back some of that technical debt that you either deliberately incurred or you found later. Right? You realised you'd got into debt over your head, and you need to fix it. But you need to fix it; you need to go back and refactor it, and there's a cost to that. Right? It's engineering work; it's time; it's possible mistakes; it's reworking tests; it's all of those things to make that work.

And then I think a year later, they had a similar problem with another service, so they took the decision at that point to go and introduce the circuit breaker pattern in all the communication across their entire service, and then they never had that problem again. So you're always going to incur technical debt, whether you choose to do it deliberately or you discover it later. You should never have poor quality. You should have an absolute minimum quality bar that's set by the organisation to protect the business, the brand, your employees, and your customers. Right? That's your organisation's—we I would call it a definition of done. Right? What's the minimum quality level required by your business? But from a technical debt perspective, we still need to go back and pay it back, and it pays back dividends when we go fix these things because it pays it back in making it easier for us to add new features to the product. It pays it back because our customers have less issues, so they're happier. They think better of our product, and if they think better of our product, then we tend to make more money. It's a lagging indicator, but we tend to make more money. So managing technical debt minimises your costs and maximises your profit.