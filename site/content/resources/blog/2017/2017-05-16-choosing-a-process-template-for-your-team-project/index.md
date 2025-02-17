---
title: Choosing a Process Template for your Team Project
description: Discover the best process template for your agile team project. Learn why the Scrum template minimizes friction and enhances your development workflow.
ResourceId: dGSGEOYRJAo
ResourceType: blog
ResourceImport: true
ResourceImportId: 10356
ResourceImportSource: Wordpress
ResourceImportOriginalSource: Wordpress
date: 2017-05-16
creator: Martin Hinshelwood
layout: blog
resourceTypes: blog
slug: choosing-a-process-template-for-your-team-project
aliases:
- /blog/choosing-a-process-template-for-your-team-project
- /choosing-a-process-template-for-your-team-project
- /resources/dGSGEOYRJAo
- /resources/blog/choosing-a-process-template-for-your-team-project
aliasesFor404:
- /choosing-a-process-template-for-your-team-project
- /blog/choosing-a-process-template-for-your-team-project
- /resources/blog/choosing-a-process-template-for-your-team-project
tags:
- Software Development
categories:
- Social Technologies
preview: IC749984-1-1.png

---
Over the years I have had many discussions about Agile vs Scrum process templates with both TFS and VSTS and migrated many Team Projects from Agile or CMMI templates to the Scrum Template.

**_TL;DR - Select the Scrum template if you have an agile team and want to reduce friction. Don't create unnecessary friction for your move to agility by selecting either the CMMI or Agile templates that suffer from the legacy of the Microsoft Solution Framework (MSF)._**

When you create a new Team Project in VSTS or TFS you are asked which Process Template that you want to use. This is a decision that you need to make at the time you create your Team Project and you cant change it later. You want to choose the template that is closest to what you are actually doing, or more accurately what you want to be doing.

![](images/image1-2-2.png)Many teams and organisations make very good and seemingly rational arguments for choosing either the Agile or CMMI templates, however I feel that if you are trying to achieve any type of agile implementation for your team then this is the wrong choice. There are two key frictions that I think affect your choice:
{ .post-img }

- **Current Friction -** If you have a discrepancy between what you are doing now, and the process template you choose then you will have a harder time getting folks to work within the bounded environment that you are trying to create. However you may want some friction if folks are currently doing the wrong thing.
- **Future Friction** - As your process implementation moves to match your strategic direction, and the template lags behind , then you will have a significant friction for folks who really want to do the old thing.

Having the right rules to follow is valuable for figuring out the right path:

- Create a Template for the Process that you want, not the process that you have.
- Make it easy to do the right thing, and hard to do the wrong thing.

Making the wrong choice can cripple your teams ability to inspect and adapt by making their biggest problem trying to avoid the friction that your choice in template has created. While I also believe that anyÂ  team following any process could, with significant discipline, use any template,Â  if your team is an agile one then both the Agile and CMMI templates will create significant friction. Let me explain; there are three templates available out of the box:

- **CMMI** - This was called "MSF for CMMI Process Improvement" and was primarily focused on those teams that need to monitor change and are following CMMI.
- **Agile** - Formally known as "MSF for Agile Software Development" and is designed to support Agile development for teams that don't want to be restricted by Scrum
- **Scrum** - Also know as "Microsoft Visual Studio Scrum" was designed to allow Scrum teams a more familiar with Scrum.

However every single one of these templates supports both "agile" and "CMMI", however only one embodies agility and minimises prescription and constraints, and its not the "Agile" template.

## Why you should not select the Agile template

I have had a number of... arguments discussions with the folks that own "MSDN: Work with team project artefacts, choose a process template" about its inaccuracies and false choices and some changes have been made. However I have issue with one particular statement in there:

> The Agile template is designed to support Agile development for teams that don't want to be restricted by Scrum.

Lets forget for a moment about Scrum and look singly at the contents and expected use of the templates. I completely disagree that the "Agile" template is suitable for agile teams and I vehemently disagree that the Scrum template is restrictive. I believe that the opposite is true.

I believe that the "Agile" template (as well as the "CMMI" template) is in fact not agile and enshrines many common anti-patterns for agile teams. Its not really a surprise as the "Agile" template was not designed by agilest for agile teams. The "Agile" template is properly called the "MSF for Agile Software Development" template and the MSF part is important.

Microsoft Solution Framework (MSF) was designed by Microsoft Consulting Services (MCS) to help them deliver software to customers when consulting. The MSF for Agile template was originally an attempt to implement that non-agile methodology (don't let the word Framework fool you) in a more agile manor and it failed (oh it gave managers a false sense of agile; vanity agile. Lets call things agile and do the same old thing we have always done.)

There are main issues with the Agile template:

- **Bugs are not on the backlog** - As any good consulting team (sarcasm) knows you must hide your bugs from the customer and this template promotes that bugs are triaged separately to Stories. Yes you can change this to add bugs to the backlog, however the expected happy path is that you triage your bugs separately. From TFS 2015+ we can choose how bugs are handled on the UI.
- **Resolved (Code Complete and Unit Tests passes)** \- Yes I know that many teams still like to create a wall between Code and Test but to enshrine it in the template forces all teams to follow that line. Making this the path of least friction encourages users to do the wrong thing. You really cant be agile and throw bugs or features over the wall to Test.

In addition to the main issues there are a great number of paper cuts as well. While individually small they add up to significant friction:

- **Story Points** - Why are people encouraged to only use Story Point? Are they the right practice for everyone, on every software? No, Story Points are just a complimentary practice that can be applied to any process. While I am a supporter of Story Points and I encourage teams that I work with to use them they are by no means the only method of estimating in agile. This should have a more generic name, like maybe Effort that allows the team, or organisation, to collectively decide how they are going to do estimation.
- **User Story** - Is the only way to write backlog items to do so as User Stories? What about Use Cases? Should you struggle to write even constraints or non-functional requirements as User Stories? No, again User Stories are merely another complimentary practice. While user stories are an effective tool to help you decompose your work they are by no means the be all and end all. Having the Requirement type called User Story makes folks feel that every one should have a "As a | I want | so that" which is just not the case in any of the agile processes. Would it not be better to have a more generic term, a base class if you will, from which you can form any sort of definition of our work?

Forcing people into using these complimentary practices is silly and creates that friction. These practices are not required to be successful at agile however being able to break walls between departments and triage bugs with the rest of our backlog I would argue is. Don't get me wrong, I like practices like Story Points and User Stories and they are right for some teams, although not all.

If you really want to be able to "let the team decide" on the practices that suit their circumstance, experience, technology and choice then you need to stay away from MSF templates entirely.

So what is the answer? What if I am not doing Scrum, but there are only two other choices, both of them MSF based. Well I would recommend that you use the Scrum Template anyway, and create your own agile process with this as the foundation. For folks that really want to have the Agile template, because they hate the word Scrum and anything associated with it. I kind of lie. I download the Scrum Process Template from TFS and change the same to "Agile for Company X" then reload it.

## Why you should use the Scrum Template

Rather like the Scrum Framework itself the Scrum template was designed to be as light as possible while still embodying the common lexicon of Agile. Wither you like Scrum or not, it is an implementation of Agile and uses the same terminology. The thing that differentiates Scrum from other agile implementations is the Sprint and the Sprint is not really part of the Scrum template. You can easily change the Iterations to be any flavour you like.

Bugs are on the backlog, one state for the team working on something, no push to a particular practice.Â  Almost universally the terminology and workflow of the Scrum framework is understood by teams doing any flavour of agile. And if you have a team that needs a little legacy love you can easily add a column to the Kanban boards without enshrining dysfunctions in the template.

I always recommend that folks start with the Visual Studio Scrum template as a base and customise from there. There are a few customising that I like to see teams make if they need them, especially to help adoption:

- **Completed & Original Estimate** - The Scrum template only has Remaining Work on a Task as this is the only metric that Scrum requires. However there are many teams that gain value through other metrics and the Scrum Guide does not say anything about not using them. I often add these two fields to the Scrum template for teams, and I never feel bad about it.
- **Requirement Type Field** - Often organisations like to differentiate between Functional , Technical, or Regulatory PBI's and this is another field to add. Making sure of course that it becomes a dimension in the Cube. Luckily the out-of-the-box template from TFS 2015+ has this field already, just put the values that you need.
- **Team Field Mode** - Often the case for long term users of TFS is that they already have made good use of the Area Path field. Now they need to use it for team? Well, no. Create a Team drop down and with a little out-of-box wiring you remove the relationship between Team and Area Path. This feature is currently unavailable in VSTS and the product team are looking to make it unnecessary.

These customisations are non-intrusive and have a limited impact on reporting and upgradability. I spend a lot of time at customers migrating them from the Agile and CMMI templates to the Scrum template and while it is not that hard to do it does take time and money.

## Conclusion

Choose the Microsoft Visual Studio Scrum process template if you don't want to be limited by MSF. What other customisations do you make to your Scrum template to support your lean-agile process?
