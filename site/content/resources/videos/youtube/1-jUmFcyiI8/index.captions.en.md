Deployment frequency can serve as a leading indicator of your company's ability to reduce the time to market. I think there's a lot of metrics in that space that you probably want to look at because it's pretty difficult. You could deploy really frequently to a test environment, and that has no bearing on your ability to deploy to production. You're deploying stuff to a test environment that is breaking all the time, so that metric on its own is not going to tell you that you're going to be awesome. That's absolutely not true. 

There are a number of things that you can look at, but your ability to deploy to an environment and the speed with which you can deploy to an environment—let's assume that that environment is stable—so measure that as well. The stability of that environment would be a reasonable indication. If we had a stable environment we're continuously delivering to, we should be able to get stuff into production and deliver it to the market much more quickly. 

But then you need to look at what gets in the way. I have a little formula that I think works really well. I've seen it work in organisations. I know it's not my formula; I think it's a fairly logical thing. Look at your entire pipeline, from ideation—coming up with ideas to go into your product—all the way through to getting it in front of your customers and closing the feedback loop. You're collecting data and telemetry on how that feature is being used, how performant it is, those kinds of things, and then having it feedback. That whole loop is your time to learn, and that is your largest feedback loop. 

If you look at your time to learn and figure out how long it takes, you can find the thing in that time to learn that is taking the longest amount of time and go tackle that. Go make it shorter, go fix it, and then once you've fixed that thing, you've collapsed it into something much faster, much sleeker. Look for what the next blocker is in getting your time to learn down to a manageable size. 

But the question then begs: what is a manageable size of time to learn? As any quantity question, as much as you need and no more. Making those things faster than you need might have an additional cost. So maybe focus on how quickly you need to be able to get things into production. How quickly do you need that to maintain the existing customers? How fast do you need to be able to do that to get new customers? 

Your sales team is going to be promising things to customers, and then you have to come back around and build them. Because they've been promised, there's an expectation. Don't train your sales team not to promise stuff, but there might be an expectation. If there's an expectation of a feature, then you need to ship something within that context as quickly as possible to start building on that expectation, building trust. Otherwise, you start eroding trust because there's an expectation that's not fulfilled. 

This is one of the quandaries of the delivery manager: how fast we need to go. There's definitely a school of thought that faster is better, even if your business doesn't need or isn't demanding to be able to change faster. If we, in engineering, in building the product, are able to shorten those feedback loops as much as possible, we can iterate on it. We can use that data, we can get little changes in front of real customers as quickly as possible, and then we can monitor the telemetry. We can see how we've impacted performance, we can see live error messages coming through, or live telemetry, live performance, live error messages, and then be able to do something about it and make little tweaks to get things right. 

I think that's the important thing when the outcomes that we're trying to achieve are so complex. Not only how we achieve the outcome, there's a lot of unknowns about what the outcome's going to be. There's a lot of unknowns in what we're going to discover along the way. If we get that loop as tight as possible, we can deal with surprises. When something goes wrong, we can deal with it. We can make a change, we can ship it, we can make a change, we can ship it. That didn't work; we can make another change and ship it. We can iterate on that. 

When the business comes along with an opportunity—which they invariably will—they're going to come along and say, "This massive opportunity has come along." They're not going to say it like that; they're going to say, "Oh my God, I need this feature. I need it right now. I need to ship it tomorrow." If you are shipping once every sprint, shipping once every two or three weeks, that's not an impossible task to add something and ship it within a few days. But it's going to be fraught with risk and danger because if you're doing something that you've not done before and you have to get it out quicker than you're used to doing it, there are lots of points of failure in that story. 

If you, as an engineering team, if you're a delivery manager and you have a team or a bunch of teams, a product or a bunch of products, if they're able to continuously ship to production—so they're doing continuous delivery to real users—then this opportunity comes along. We add some capability, it ships. We add some capability, it ships. We build on that capability, it ships. We get that much tighter iterative cycle. 

If that feature is this big, how much of this feature is required in order for sales or the business to start advertising that feature? Maybe you only need a very small amount. Maybe you can do a couple of days of work and ship it, and then that feature is there, and they can start marketing it, getting value from it, and then you're building on that as users start using it. You can focus on what it is you need as you go. 

This confluence, I think, of product development and delivery of that product is absolutely critical in order for us to maximise the value that the business gets, that the business creates. In order to do that, there has to be extreme trust, not only between us and the business but between us and the customer. It's not the business and the customer; it's us and the customer because the customer knows that the business doesn't ship the product. They know that we ship the product. Engineering ships the product. 

So when it's not the right thing, they're blaming the business. When it's poor quality, they're complaining to the business that we suck. If we can get rid of that problem, then the only problem is what are we going to go build? If we're in a position—engineering is in a position to help provide all of the data for the business to be able to make a determination on what it is they build and what they don't, that's our job. We need to help the business make those decisions and give them as much information as they need in order to make those decisions effectively. 

That means collecting telemetry, that means being able to continuously ship to production, that means enabling the ability that when an opportunity for the business arises, we are able to deliver on that opportunity faster than our competitors.