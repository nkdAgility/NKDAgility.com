If you're still deploying manually, you don't have modern engineering practices. I would suggest you have massive amounts of business risk. There's no good outcomes to deploying manually. If you want stories about that, look up the Night Capital Group, which is a company that went out of business in a day from a failed deployment, from a failed manual deployment. This happens in the industry.

While the bigger organizations can absorb smaller failures within that context, if you're a one product business, it's almost impossible to absorb that failure depending on the outcome, the impact of that. For the Night Capital Group, they ended up deploying, there's a whole story around it, but they had eight servers, eight production servers, and they ended up deploying with a feature flag enabled on one of, they forgot to deploy to one of the production servers because there's a manual person following a script. And they repurposed a feature flag that used to be used for a training scenario that they were exploring, like an exploratory training scenario.

They were a stock trading company, so they're trading stocks. And the feature flag enabled on this one old server that wasn't updated to the new code, it updated it to buy high and sell low because in the past they had some kind of exercise, training, AB test, whatever they did around that in the test environment. Buy high, sell low, bad idea. And they couldn't, it took them long enough to figure out what the problem is that they went bust. They used up all their money. They had $450 million in the bank at the beginning of trading that day, and by, I don't know, certainly by the close of business, I think by lunchtime, they'd run out of money. They'd lost all of the money because their software was acting erroneously.

And that's massive risk. How a business that has that much at stake when they're doing a deployment is completely incompetent if they're using manual deployment processes. This is just mental. I worked with a bank many years ago and they had not just manual deployment processes but they had five production servers. This is for a real-time banking system.

Real-time banking system. They had five servers. They had five people in the team and each person in the team would log into the server and write their own code and deploy it directly to production on the server. Right? And this is within the last 15 years.

These sorts of things risk, they're unprofessional. They risk your business. They're not the risk of the engineers to take. They're probably not even the risk of the managers to take. If you're a scrum master, that's a big squirrel burger right there. It's a whole bunch of squirrel burgers.

So, if you want to have any movement towards modern engineering practices, let alone engineering excellence, just modern engineering practices, you need to be using automated processes. You need to be using automated builds, automated deployments.

That's non-negotiable. That's table stakes in this story. It's not an aspirational thing. It is table stakes because it makes you vulnerable. People make mistakes, right? You would think,

My favorite reason, the moment in time when I lost any belief that a human can follow a set of steps repeatedly and successfully was when I taught a training class for testers. Testers using the Azure DevOps test tools. And this was many years ago, so it wasn't the Azure DevOps test tools, it was TFS test tools. But yeah, Visual Studio Team System. We had labs in our training and in a lab you work through the set of steps and when you get to the end you've completed the lab and you've done all the things and you've seen how it worked, right? All of the labs worked.

But every five minutes in that training class, I had testers, this was for testers, and the people doing it were testers, testers saying, "The labs don't work."

I followed the lab and it doesn't work. And I would sit down with them and say, show me where it doesn't work. And they've missed a step. They haven't done something. They've missed one of the things in the list.

If there was one group of people in the world that should be able to successfully manually follow a set of steps and confirm whether that set of steps works or not, it would be testers. How many false positives are we getting in manual testing, right? That they just missed a step perhaps in their own test, right?

This is why you can't rely on humans to do these types of repetitive, complex, repetitive tasks. You need automation. This must be automated. Everything must be automated and automated in as fast a way as possible. So you want to have automated builds.

I recommend both Azure DevOps pipelines, Azure pipelines, right, that feature of Azure DevOps, and I recommend GitHub actions, right? But Azure pipelines is great. It's fantastic.

You need those pipelines. You need those, I'm going to call them gates. Just because they're gates doesn't mean they're not automated, right? A gate doesn't have to be a manual thing that blocks your ability to do something. It can be automated. But pipelines, gates, test automation, that's how you automate deployments.

You want to automate everything. If it can be automated, automate it. If it can't be automated, refactor it until it can be automated. End of story. You should not have any manual processes from your developers committing a line of code to it ending up in production.

You might have an approval button or "I'm going to read through it and then approve it." Right? That's fine, but all of the steps are automated.

That's human in the loop, but not human doing the loop.

And what you'll find is if you get there to that minimum bar, the only way to peel away the pain is you're going to do lots of automation. You're going to go through that process lots of times to build it out. And what you realize in doing that is you can do it lots of times. So if you want to go from monthly or yearly releases to continuous delivery, to continuous daily, weekly, hourly releases into an environment where at least some subset of your users are, you need to automate. You need to use build automation. You need to use test automation. You need to integrate it all together. Deployment automation. Get your stuff deployed in an automated fashion. Otherwise, your business is at risk.
