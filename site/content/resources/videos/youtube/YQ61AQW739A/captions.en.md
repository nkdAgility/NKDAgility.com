Building a road map to get you from your legacy engineering practices or legacy products to modern, well-built products, modern engineering practices is, I guess, it's a little bit of a very high-level road map.

It's difficult to put structure around the idea of building a culture of engineering excellence. Changing culture, changing systems is more of an art than a science. You bring science to the story, right? Because you're going to have data and telemetry. You're going to bring things like OKRs, right, which have "here's what we're trying to achieve," the objective, but also "here's the key results." Here are the things that you're going to meet, right? Measure and meet to be able to say whether you've been successful in that thing.

And we want to be bringing that hypothesis-driven story to all of the things that we do within the context of our road map. So, ultimately, a transition from legacy to modern is a road map of hypotheses. I think that's the plural of hypothesis, hypotheses.

We've done it before with organizations. I'm working with an organization just now to start moving them, their own Team Foundation Version Control (TFVC), moving them to Git, modernizing their tooling, building out the DevOps pipelines. And it's not something that you can just plan up front and say it's going to work because you don't know what you're going to run into along the way. There's too many unknowns, and it's unknown unknowns, it's very, very big.

So we want to take one thing at a time. And what I tend to recommend, it seems like a little bit of an oxymoron, but take your biggest, riskiest, nastiest, most difficult product, and that's your pilot, right? You want to move them from TFVC into Git. You're going to have to fix a bunch of stuff to do that. You want to build out your automating pipelines. You're probably going to have to move things around, let's call it move things around, in order to get your automation pipelines working.

And then you're probably going to want to look at bringing in, like, what other stuff are outside of our scope of automation, our current view of our automated pipelines that we need to get to production, right? That's the story.

One of the key things that I always run with a customer is I get everybody together who is involved in approving that your product gets deployed to production, right? Who are all the people that need to be involved in that story, from product developers all the way up to somebody in management who ticks an approval box or approves something or whatever, right? All of those people, and ask them to write down everything that needs to be true in order for them to be happy to ship that thing to production, right? Everything that needs to be true.

So that could be a particular measure. It could be some piece of data. It could be something they look for. It could be something that has to be done. We just need to, yes, this is done, true, tick, right. We get all of those things together. Those are all the things that need to be in your development process. And ultimately, as many of those things as humanly and inhumanly possible need to be automated.

You want to automate everything. You shouldn't have, you should not, you should not have any manual tasks between developer committing a line of code to your repository and it getting into production. And that's manual tasks, i.e., people following scripts or doing all those things. It should be topic automated build, validated test, approvable request as automatedly as possible, as short as possible, provable request, trunk-based development, then kick off your automation to deploy to some subset of real users.

I'm usually pretty clear on when we're deploying to production a new version of our products. Production, we're probably not talking about deploying those new things to everybody at once. You don't want to do what Crowdstrike did and take out half the world's internet, right? That's not a good place to be.

You want to do like Windows or Teams or Azure DevOps or Google do, and you do a phased audience-based rollout. I usually call it ring-based development, but audience-based rollout. So you have that part of your transition road map from legacy to modern, figuring out what does our new, in our new model, what does our branching structure look like? What does our automated deployments look like? Where do they go? Who sees them? Who interacts with them? How do we get as quickly as possible to some subset of real users? Not everyone, some subset of real users.

A good example, although it's still a really big sample set, is when Microsoft ship Windows. They ship Windows daily to everybody inside of Microsoft that takes the internal build, which is not everybody. That's going to be thousands of people, right? And then weekly they ship to a bunch of people in the insiders group, which is up to 17 million people, before they roll out to 900 million people, right? Everybody using Windows, 900 million machines. They roll out to 17 million machines, not 900 million machines.

And that phased rollout allows you to understand, get telemetry, shorten that feedback loop when you know you have a long tail for your customers taking parts of your product. This is your short tail. That's your long tail.

And understanding how to do that, planning around figuring that out, is, that's your transition road map, right? That's how we get the information to be able to understand what it is we need to do within the context of your product, or at least what's the first step we're going to do within the context of your product.

And if you're on TFVC, it's getting onto Git. If you're already on Git and you don't have automated builds, it's automated builds, right? If you have automated builds and you're in Git, it's automated deployment if you don't have that. If you don't include testing in that matrix, that's the next step, bringing in the automated testing.

So there's a clear road map of what's the first thing to tackle, what's the second thing to tackle, and keep going down that line. And as you're going down that line, you're building a story of both engineering excellence and technical leadership within your organization. And you need to do that in a way that scales across your organization.

So that means when you build engineering excellence within your organization, it's an ethos. It's a philosophy of how we do things within the context of our organization. And it's all about adapting to change, adapting to surprise, adapting to the things that happen as we go in a way that's professional and provides the outcomes that the business, your end customer, is looking for.

So if you want a step-by-step path out of legacy pain, you don't have a paddle there. There's no real way to do that. But what we can provide you is the compass to help you orienteer your way through your legacy pain, right? What's every step of the, what's the next step of the journey? We do the next step of the journey. We look at the compass and the map, and we figure out what's the next direction we're going to take. What's the next thing we're going to do?

And that continuous, iterative path is what's going to support you long term and map your migration journey.
