I work with many enterprise organisations that use Azure DevOps, and many of them do things that either reduce the effectiveness of the features or break them entirely. I asked Dan Helm, the principal product manager for Azure DevOps, what the top four issues were, and this is the result.

Hi, I'm Martin Hinwood, owner and principal consultant at Naked Agility. I'm a professional Scrum trainer with Scrum.org, a professional Kanban trainer with Pro Kanban, and I've been a Microsoft MVP in GitHub and Azure DevOps for 15 years. 

Azure DevOps, in its current incarnation, was built for agile teams by agile teams. The Azure DevOps product team transitioned to Agile around 2013, and they moved almost overnight from a two-year delivery schedule to one of three weeks. As of the time I recorded this video, they have completed 235 sprints and delivered 235 times to production in this new model. 

This was not always the case, and many of the tools, features, and capabilities which persist from the Visual Studio Team System days of the product are much more relevant for companies that are not using agile practices. When Microsoft created Team Foundation Server back in 2006, the intent was to create a connected experience for all of the tools and capabilities that an engineering team would use. The idea was to create a holistic connected experience from ideation all the way through to delivery, with full traceability of how and why things were added. 

However, back in 2006, Microsoft found this to be at odds with the organisation's general outlook, and they ended up with a very Microsoft technology-only focused system. Fast forward to 2011 and the move to the cloud, and suddenly those limitations were much more prominent and needed to be fixed. There's a fantastic paper from Buck Hodges, director of engineering for Azure DevOps, on this, and I'll put a link in the comments below. 

As Microsoft transformed TFS to become a cloud product, it also addressed many of the Microsoft-centric issues that held back its adoption. The tool started to reflect the original dream, and the idea of 1ES, or one engineering system, was born. The intent of 1ES, as with the original team system, was to reduce the complexity of product delivery by ensuring that everybody working on a product knew where their stuff was: work items, builds, release environments, and more. 

Today, Azure DevOps supports any technology from any stack and has enabled that 1ES dream. However, as with all products, users use them in many ways that were not envisaged by their creators. But with something as complicated as Azure DevOps, there are a number of things that users do that go against the very intent and paradigms of the tool itself. 

I'll show you the top four issues that give the Azure DevOps team palpitations. 

So the first item that has the Azure DevOps product team pulling their hair out is same-level hierarchy. Creating a hierarchy of work items that happen to be exactly the same level. So let's take a look at what that looks like. I'm going to show a simple example, and then we'll go make a customisation and show a more complicated example. 

So here I have my product backlog. I've got my product backlog items. I have under here a task, which is a sub-item. So I can quite easily go in here and add a new item. I'm going to call it a child, and I'm going to add a task. Click okay. You can see I suck at that, and now I have two tasks underneath this item. But what I've done over here is I have added product backlog items as children of product backlog items. 

So it is represented on this board, and I should be able to... can I still move this around? Oh, I can still move this around here. But when I go to try and grab one of these items, I can order it inside of the context. Oh, and there I've managed to break it. This is why this is a problem. 

Work item 4052C can't be ordered because it's appearing in the same category. So if I hit refresh, it'll have gone back to where it was. There we go. So I was just trying to order within this category, and it jumped out, and that was the problem. If I go and try and order it over here, I will immediately get that error. That's the one I was going to show you. 

And now I can't do anything with that until I refresh, and it will go back underneath because it has a parent-child relationship. You can't order that hierarchy.