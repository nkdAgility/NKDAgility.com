Creating an effective Caman strategy is hard. In this world of hybrid work, we need to share our visualizations using digital tools. One such tool is Azure DevOps. Here, I'll discuss how you can use Azure DevOps to visualize your work as part of a Caman strategy.

Hi, I'm Martin Hinwood, owner and principal consultant at Naked Agility. I'm a professional Scrum trainer with Scrum.org, a professional Kanban trainer with Pro Kanban, and I've been a Microsoft MVP in GitHub and Azure DevOps for years.

Before we start, it's essential to understand why we need to use something like Azure Boards in order to manage our work. Since the pandemic, many teams have moved away from physical offices, and even when we're in a physical office, we're not all there at the same time. This means that there's no physical wall or meeting room that teams can use to present all of their work visually, where they can all see it. Digital tools for saving and presenting that work have really become more critical than ever.

Now, there is way more to a Caman strategy than just a tool. A Caman strategy works best when applied to a stable system, one where we're all following the same rules. However, most of us don't work in environments like that. Each participant in the system typically makes choices based on their own internal system, one that they don't necessarily share with the rest of the team. 

Well, why don't we share it? I think it's a result of not realizing how important it is that we do share it. We don't realise how much impact those seemingly small choices make, like which item to pull or not and why, on the entire system. We've created a lot of local optimizations for our overall system that may have a negative impact on that larger system.

So, what do we do about it? Well, I recommend that you sit down with all of the participants that are going to be working on the work that goes through your system and have them work out what rules they want to use or come to an agreement on the choices that they're going to make. It doesn't need to be perfect; you'll have ample opportunity to change and adapt those rules as you discover the impact that it has on the work. But we need a place to get started, and really, you don't have to do all of that before you start with Caman. You can get started and then work through those problems with a rougher workflow, like just guessing whatever it is you work on just now. More details can be added later to start stabilising that system and make it more effective.

But let's leave that for now. For now, we're going to look at how we can create a Caman board for a typical software team and then how we can implement that in Azure DevOps. I'm going to show you how to manage the cards on the board, how to customize the cards so that you can see what's going on, and also how to customize the columns and perhaps swim lanes if you have the need for that, and then be able to see and visualize what's going on on your board and filter that board for the things you might need.

So, let's take a look at what's going on in Azure DevOps. I have an environment here; this is just my environment. I have a lovely org over here on the left; that's my learning environment, and I have a few projects that I've preset up with things that we can look at. So, let's look at a finished environment first, or at least the first stage, like we've set up our boards to be able to see what's going on. I'm going to click on the demo environment.

So, on the left-hand side, you'll see boards, and you'll see two things that are important: you'll see under boards you'll have boards and backlog. Those are the two main things that I would expect both Caman and Scrum teams to use when they're managing their work. So, I'm going to click on boards first, and here you'll see I have a pre-set board for this team. 

In this view, you can see that I've got a number of different columns going on here, but the important thing to realise is that the states of the work items, the underlying work item states, have not been changed here when we've customized the columns. This means that multiple teams working inside of the same Azure DevOps project can have a different set of columns while maintaining the same states.

Let's take a look at some of the work item states and how it applies to Caman, depending on the process that you've selected. So, here you can see an overlay with two things going on. Horizontally, you can see the states for the particular process that you might have selected. So, if your process for your work is based on the Agile process, on the Scrum process, or the CMMI process, it'll have these different states that you see here. 

I prefer the Scrum process because I believe it's the most generic, although I do make some changes to it. So, here's the Scrum process: we go from new to approved to committed to done. In the Agile process, which is the other most common one, people go from new to active, active to resolved, resolved to closed. But the vertical columns here, where you have proposed, in progress, resolved, and completed, give you an indication of how those states are going to be treated by Azure DevOps.

Under the covers, Azure DevOps has a whole bunch of Agile planning tools that have been applied to the system that has been created, and the fundamental basis upon which they work is that you have a proposed state. So, that's things that we're not working on yet. When things get added to the system, you'll see that the lead time timer starts, but the cycle time timer doesn't. 

Inside of Azure DevOps, they specify cycle time as from when the developers start the work to when it's finished, and lead time to when it's added to the system to when it's finished. You can absolutely argue the validity of that. I would maybe prefer a more configurable option, but this is how it's configured currently inside of Azure DevOps. 

So, if something's in the proposed state, the lead time timer started, but the cycle time timer's not. In the Agile template, you only have one state, which is new, which is in proposed, and then you have active and resolved, which are in progress states, and then you have one completed state called closed. That's where both the timers stop.

Okay, so when it crosses this line, it gets marked as active or resolved. Sorry, when it crosses this line, the cycle time timer gets started. So, in this case, one of the reasons I prefer the Scrum process here is that by default, although you can absolutely add it to the Agile template, by default it has two states in proposed. You've got new; it's been added to the system. It might have been added by some random person in your organisation, so you don't necessarily want to have started the work. 

I usually use approved or some kind of second state to indicate that the person who manages that backlog, who is or this could be the team themselves, the team has agreed that they're probably going to do it. Right? So, that's where it's approved; we're going to work on it. That's why I would kind of like lead time to start there, but you can't have everything. 

Then in progress, I actually prefer just one state. I usually change it from committed to something else, like forecasted or just in progress. Right? New, approved, in progress, done. But I prefer one state so that the developers get the choice to split into however many columns that they want. Having an active and forced resolved state can limit the way you can configure the board, but also you can work it into the way you do things for sure. 

And then everything has a default closed state, so that's the kind of flow of work from Azure DevOps internals perspective. But we can configure that however we like on the board. So, you can kind of see here I'm going to try and show you what this looks like. 

So, on this board, you'll notice that I have inventory, I have backlog, and I have discovery. When you look at the work items, they are new in all of those columns. Okay? So, they've not yet... This is the Scrum template, not the Scrum template, the Agile template. So, you'll notice that the items haven't been moved to a different state. 

And then in development, we have active, and then in validation, we have resolved, and in done, we have closed. Okay? So, this means that when work crosses this line here, that's when the timer starts on the lead time, but it has to cross this line here in this particular process to start the timer for cycle time, and all the timers stop at this line here. 

Okay? So, that allows us to implement a bunch of controls that we can use to kind of see what's going on and manage our work. So, this particular team has set up... We've got our inventory; this is stuff that's been added to the backlog that we may or may not do yet. So, that's like the back warehouse in our shop. 

And then we've got a backlog, which is the stuff that we're going to try and sell. We're going to do... has been moved to the front, and it's moved into that column. So, inventory is just a big list of stuff, and then when we decide we're going to do something, we've agreed to do it, whatever those reasons are, it ends up in the backlog. 

And things in the backlog are then options to be pulled into discovery. So, you could call this options. Right? So, I'm going to pull things... The team's going to pull things from here into discovery so they can put it anywhere they like in discovery. So, let me drag and drop that in there. Once it's in discovery, that column will change to discovery, but you'll note that the state has not changed. 

I'll show you how that works in a moment. So, once that is in this doing column, discovery doing, that's when we're going... The team's going to do all of that discovery or refinement work that they need to do to figure out what this thing is before they actually start it. Right? Before they actually start executing on creating this, and things may drop out of this space, right? Because we might do some analysis on this and figure out that it's not something we want to do. 

It's either too costly or whatever reason. Here, we've got generating invoice reports that has been blocked. Perhaps it's been blocked because we're waiting for new information. We've got a request out to somebody else, but it currently is blocked. 

But we've split this column into doing and done, so the doing column and the wait state column. We've done the work, and it's waiting for the next column to pull it in. When it crosses this line here from discovery to development, that's when this item is going to change state. So, if I bring this across, you'll notice it's currently set to new, and now it's going to be marked as active because we've crossed that line for the internals of Azure DevOps from one state to another state, even though we've got multiple columns. 

I'll show how that's configured soon. So, we've got that development column now. So, this is the team's going to work on it. We're going to work on it, and at some point, we're going to mark it as done, so it's now moved to the next column. 

So, again, we've not changed the state; it's still active. So, if you're creating reports across multiple teams inside of the same project, you can still report on those states. You don't need to worry about the columns. Right? There's ways you can do that too, but you don't need to worry about the columns. 

So now, it's development done. It's waiting for whoever does validation to pick it up. This could be last-minute checks by the developers who want to check that everything is... all the eyes are dotted and the tees are crossed before they say officially say it's done. They're going to check the work against the definition of done, against anything else they believe they need to do. 

Whatever it is they need to do in that particular stage, and then that item, when it moves across this line here, is going to move from active to resolved. You'll notice I've hit the whip limit, gone beyond it, but just for demo purposes, I'm okay with that. And then they're going to validate that it's in the resolved state. We believe, we as the team, believe the work has been done. 

We're marking it as resolved. We're going to come back around, do a sanity check on that, and then move it into closed to say it's been finished. And there you go; we had a piece of work flow from left to right through our system, hopefully as effective as possible. 

Now, this team is generally, hopefully, when they're working on their checks, when they're viewing this board, is going to walk the board from right to left, ensuring that they've populated the board, that they've got it all set up. They can do those things here, and you can see I've got the blocked visualisation there highlighted to see what's going on.

So, how might you configure this? There's a number of things that you're going to want to configure to be able to set this up. So, I'm going to show you how to set up and manage the columns and lanes if you do want lanes. So, if I click configure board settings over here on the top right, you'll see that in here, I have a configuration for fields where I have bug and user story. 

So, if I click on user story, you'll see that it's showing what fields are available for user story. So, I've added iteration path. I think I didn't unbug, so I can easily just add iteration path on here, and it will show up on the bug items as well. So, if I save that, you'll see that bug item change to include the iteration state as well. 

There's iteration path there coming in. So, I can add additional fields if I have custom fields or something I want to show on there. It's definitely worth considering that the more fields you add, the bigger the card's going to be, the less you're going to be able to show on the screen. So, just consider that and have only the most important information surfaced here.

You can add style rules. Style rules enable you to change the look and feel of the work items. So, you might add... If I do a test rule, whatever it's called, and then I can change either the colour of the card or the colour of the title of the card. So, if I change the background colour of the card, let's say I'm going to change it to a kind of light blue, only if the changed date... Let's do change date is greater than, let's say today minus one. 

Okay, so if I save that, if I've got my... There we go. So, these items that I've moved today are going to show up today or yesterday, today minus one, are going to show up as these things have moved. Everything else has been static and hasn't moved. So, I can prove that just by bringing this one across, and you'll notice it changes colour immediately because it's been changed recently. 

So, you can use that to highlight things that have moved recently or not. I can also... Not only can I do styles on the cards, you can have multiple styles if you want. Again, a kaleidoscope of colour removes the importance of colour, right? So, try and be careful with that. 

And here you can see I've got a tag, a blocked tag, that highlights a particular colour. So, in this case, a block tag highlighting red. You can add other tags as well, depending on what it is you want to look at too. On these cards, you can have annotations. So, if the sub-item of this is tasks or things linked to GitHub or tests, you can have them actually show up on the cards, and you can click on it, and it will drop down. 

I don't have any of those set up just now, just for that view, but then we get to customizing the columns themselves on the board. So, if I click on columns, you'll see that I have the same columns that I had set up before. The first one, inventory, has to be in the new, and the last one, done, has to be in that closed because those are the start and end states for the work items. 

Right? So, you must have at least one start state and at least one end state. Everything else in the middle you can configure. So, for example, I added backlog but kept it in new, and I set the whip limit to 15. So, you can see that's 11 out of 15 is in the backlog at the moment. 

And I can also choose to split the column between doing and done. And then there's a... I don't really like the name of this; this is the definition of workflow field. So, let's say in order for things to move from backlog into discovery, there might be some things that need to be true. 

So, I could create some markdown that says inventory to backlog, I'm going to do that inventory to backlog rule one, rule two. And then on the next one, I'm actually just going to copy that so that I can be quick and call that backlog to discovery. And what are the rules that are going to be applied? 

And if I save that now, you'll see at the top the backlog has a little... If you hover over it, it will show you that markdown information there. So, you can add some of your definition to workflow. You can add links in here as well, so I guess it might link out to your wiki page or wherever you've got additional information for these rules for your definition of workflow. You could even store the whole thing out there and just link it so you can go and click those items. 

So, that's quite useful in the columns. As you go through, you can see discovery, which is a split column here, doing and done. All I need you to do is take the box again. You've got whip limit; you've got what state it's in. This one is new. Development is where we switch to active again; it's split, and validation is set to resolved, and done is set to closed. 

So, those are really those column configurations. It's not as... There's not as many configurations as I might like in the long run, but it does give me that ability to have those visual boards and have work flow from left to right across those boards in a way that allows me to create those visualisations that I'm looking for. 

You can add swim lanes, so if you had different classes of service for work flowing across this board, then you could create different lanes for this. It's not something I normally would do, but let's call this expedite, and we're going to make it neon red because expedite is really important. 

But the default is not going to be expedite. If I create that, you'll see I'll have this expedite lane going across the top, and I could pull a piece of work in and move it along, and it just counts to the usual whip. I don't think there's a whip you can add for the expedite lane. Is there? Where can I maybe set some rules for things that have to be in the expedite lane versus in the default lane, which can't have rules? 

I don't know; I need to explore what criteria does there. It's not something that I've actually used. So, there we go. You can see I've been able to configure the board. I've been able to set up an expedite lane. I've been able to set up my columns, and I've now got a configured Caman board. 

There are some additional things that you might want to do. For example, if I switched to backlog, I've added some additional columns here to the backlog. So, as well as having state, I've also added board column and board column done. So, you can see a little bit more about what's going on on the other board. 

So, if you're the product owner or you're the team lead or whatever, people, the whole team, right, looking at the order of the backlog, you're able to manage it from there pretty effectively. 

If you're struggling to understand your systems or how work flows through these systems, Naked Agility can help or help you find somebody who can help you. We specialise in helping companies that build software get better at building software, and being able to analyse the flow of work through your existing system is critical to figuring out what to improve. 

Don't wait; get help as soon as possible to minimise that waste. Get in touch.