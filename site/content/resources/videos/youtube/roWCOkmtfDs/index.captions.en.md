When you think a feature is going to be valuable to your customers or to your business, how do you know that that work has actually provided value? I've been working with a customer recently where a lot of sales-driven features end up in the product, which is actually having the impact of fragmenting the product and making it more difficult to use. The driving force for adding those features to the product is closing a deal; it's got nothing to do with what the users of the product want. It's got nothing to do with what the business that is creating the product wants. All it has to do with is closing the deal with the customer.

So why is that bad? We obviously want to close deals with customers, but what's bad is because we don't know whether those things that we're creating actually produce value or not. There's definitely an assumed value, right? We think if we add this feature, we're going to get value from it, close that deal. But what's the long-term impact of that feature? We might close that $30,000 deal, but if over the next five years that feature is going to cost us $100,000 in support and maintenance and all those kinds of things, and we don't close any more deals because of that feature, then it wasn't worth adding that feature to close that $30,000 contract.

But your sales guys don't care because they've made their 5% bonus on the $30,000 of the deal they closed. There's no incentive for them to really focus on the right features that will support many of their customers. They're just worried about closing the deal because that's how they get the bonus. That's usually the metric for salespeople.

One of the ways to turn that around is to start changing the way you measure, changing the way you deliver bonuses. People behave how they're measured, right? A great example again is Microsoft, which has lots of these examples because they've been through some of these traumas. They switched the Azure sales folks from getting their bonus based on the number of Azure hours they sell to being instead on the number of Azure hours the customer uses. 

So then instead of selling a million dollars to the customer and then the customer being unhappy at the end of the year because they bought a million dollars' worth of Azure and they've used $40,000 and the rest is waste, the salesperson is focused on usage. How can I help you as the customer use this product, not how can I be Draconian and close the deal and get you to sign on the dotted line? Signing on the dotted line is not the value that the customer wants; using the features and capabilities to the maximum capability that they have is what the customer wants.

It's that shift in focus from revenue extraction towards value creation because quite often that short-term view on revenue extraction has a long-term cost that's not obvious to the people that are making the decision that the feature goes in. It might be obvious to the people who are actually doing the work, but they don't have any say or control over that. 

This validation is really important because you pull back around and once you've shipped a feature, you monitor that feature's usage. You collect telemetry from that feature. Now, in order to collect the right telemetry, we can always in hindsight say, "Well, this feature did this," right? But was that what was intended? Is that why you added that feature in the first place? Is that the change that you wanted to make? 

This is why I'm a big proponent, as part of product management, of hypothesis-driven engineering practices. It doesn't have to be engineering; it can be anything we're building. If we're building a product, I guess I would just call that engineering anyway. If we're building a product, every feature that we want to add to the product that is not just table stakes—there are features that we just have to have. 

For example, if you're going to have a web-based product and there's dynamic content specific to the user, they're going to have to be able to log in. I don't need to have a hypothesis to say, "Is adding login a good idea?" We kind of have to have it; it's table stakes. But what level does that go to might include some kind of hypothesis, right? 

If we make it easier to log in—right, so base username and password is how most login systems work. Most systems are moving to passwordless. If we implement a passwordless system, do we get more or less users using our product? If we put a LinkedIn auto-login or a Windows or an Apple or Google auto-login, does that increase the number of users that we get in the system? 

So the hypothesis would be, "If we add the capability for people to log in with Facebook, we're going to get a higher number of people logging into the system because it's easier for them to log in." That would be a hypothesis. Then you might ask the question, "Well, how much more is that worth?" Hopefully, it's very minimal. That sort of thing should be very minimal effort to add to your system, right? 

If you add that to your system, what data are you going to collect to know whether you've successfully achieved that hypothesis? Well, I want to know how many people click the Facebook link versus use the username and password. I also want to know the total number of new net users coming onto the system. 

What I would expect to see is, you know, we've got our line for new users in the system. We add that feature, and that line has something noticeable that says we're increasing at a higher rate. Then we can look at the data and say, "Well, 10% of people clicked the Facebook button; we've got a 10% increase in the net new users. Therefore, we've opened up access to new users and new markets." 

Less people go to the page and then bounce; more people go to the page and then sign in just because it's easy—they can just click the button. So that's hypothesis-driven practices. We have to look at the data and figure out whether the thing that we added has the result that we expect. 

But this is the important part: that means whose job is it to provide the hypothesis? It could be the person who wants the feature, who's asking for the feature. This is something that I encouraged a customer recently. I encouraged them to push back to sales. 

So if sales say, "We want feature X because we think it's going to close this deal," and this deal is worth X amount of money, engineering should say, "Well, how many other customers are going to use the feature? How much do we think it's going to increase usage of the product?" 

I'd like you guys to come up with a hypothesis of why we're adding this feature and what we expect to be different other than just closing that deal because we want to look at the total cost of ownership, let's say, over five years of adding a feature—support and maintenance and testing and automated testing and all of those things. 

What's the total cost of that? The amount of time it adds to the build, right? All those kinds of things. A lot of that is guesses, but we come up with, "Here's what we think it will cost." Are we actually going to make the money back that we're putting in? Is it enough of a difference to make it worth doing? If we do it, what else is it going to support? How many other customers is it going to help? 

That's the clincher. Do you understand how many customers are using the features that you have in your product? I think there's some data from the Standish Group in Boston that used to create the Chaos Report. I think they still do create a report called the Chaos Report every year; it might have a new name now. 

In that report, they collect data—they're a data analysts group. They collect data across, I think, about 70,000 to 75,000 projects worldwide, mostly in the US and Europe but some in the rest of the world. I think it's like 60% US, 30% Europe, and then 10% of the rest of the world. I can't remember exactly, but I seem to remember those numbers; I could be making them up. 

The data that they analysed showed that only 35% of the features that we build in our products are actually used by our customers. I think it could be used a little bit but not enough to make it worth adding to the product. They've analysed that across all these products. 

So why is that number so low? Because that sounds like for every million dollars you invest in your product, you're only getting $350,000 worth of value, right? So that's a lot of waste—$650,000 waste. That's a lot of money. Where's it going? Why are we building features that our customers aren't using? 

Even worse, why are we continuing to invest in features that we could know that our customers aren't using? That's the even more interesting question. How many features do you track the usage of features in your product? And how many features in your product are you actively adding new functionality to that your customers don't use? 

Because if they're not using it, you probably want to think twice about adding new features. You may want to double down, right? You've got that old adage that we can either double down, right? So we keep investing in that feature because we think it's going to be valuable in the future and customers will use it. 

We pivot; we need to change the way that feature works in order to maximise user engagement with it, right? Which means it's valuable if they're engaging with it. Or we stop investing in it and perhaps take it out of the product. 

How often do you make those decisions? And how often do you make those decisions based on data? Do you have the data to be able to make those decisions? This is something that product management wants. The only way they can get the data is if the team adds that capability into the product. 

It needs to be integrated with the product because you want to be looking at the actual features, how they work, and create telemetry specific to those features. Understand based on what you intended the feature to do that you're able to track that data, see the needles moving, and decide whether to continue investing in it or stop. 

That's something that every product manager, every product owner should have for almost every feature they add to the product or the intent to add to the product. That can be great feedback and information you can use when you're talking to stakeholders who've asked for those features. 

Before you've built the whole feature, build a little bit of it, validate that it's the right feature, and if you see there's very few people using it, go back to the stakeholder and say, "We don't want to keep investing in this feature because nobody's using it. Do you know why nobody's using it?" 

You can go ask the customers as well, but this is your pushback on that financial investment that's maybe been imposed upon you if you don't control everything. Validation is a super important part of product development. It's often lacking. 

I feel that it's more often lacking than almost anything else in product development. So go out there, figure out what telemetry you need in your product, get your engineers to build it, and start making evidence-based decisions. Validate that the features that you create are actually adding the value that you intended for them.