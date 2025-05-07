---
title: What is the Tfs Automation Platform
description: Discover the TFS Automation Platform, designed to streamline iteration management and enhance automation in TFS. Unlock efficiency in your development process!
ResourceId: AavdFKxGJg9
ResourceType: blog
ResourceContentOrigin: Human
ResourceImport: true
ResourceImportId: 3373
ResourceImportSource: Wordpress
ResourceImportOriginalSource: Wordpress
date: 2011-05-31
weight: 790
creator: Martin Hinshelwood
layout: blog
resourceTypes: blog
slug: what-is-the-tfs-automation-platform
aliases:
- /resources/AavdFKxGJg9
aliasesArchive:
- /blog/what-is-the-tfs-automation-platform
- /what-is-the-tfs-automation-platform
- /resources/blog/what-is-the-tfs-automation-platform
tags:
- Software Development
- Internal Developer Platform
preview: metro-visual-studio-2010-128-link-2-2.png
categories:
- Uncategorized

---
[![Turk-Automaton](images/Turk-Automaton_thumb2-3-3.gif "Turk-Automaton")](http://blog.hinshelwood.com/files/2011/06/Turk-Automaton2.gif)The TFS Automation Platform is a project that will be developed initially as the [TFS Iteration Automation](http://blogs.msdn.com/b/willy-peter_schaub/archive/2011/02/20/new-rangers-project-tfs-iteration-automation.aspx) project for the Rangers, but which has a grander  vision to solve a need for customers to have things just happen within TFS.
{ .post-img }

Currently, the scope of this project is to create automations that assist with iteration management, but my eventual goal for this project is to enable a wide variety of automation solutions. This platform enables the development of three major classifications of automations: automations that can be called on a schedule; automations that can respond to an event in TFS; automations that can be called on demand.

## Updates

- **2011-06-09 - Mattias Sköld** – Mattias had a bunch of questions, and I want to provide answers. You will find the questions and answers inline at the relevant sections.

**note: This product is still under development and this document is subject to change. There is also the strong possibility that these are just rambling fantasies of a mad programmer with an architect complex.**

---

## Releases

This project is an anomaly in the wave of new [Visual Studio ALM Ranger projects,](http://msdn.microsoft.com/en-us/vstudio/ee358786) whereby we are trying something new. Instead of the Rangers creating, owning and maintaining the project, we are trying a two-phased approach with this project:

1. [Release 1 - TFS Iteration Automation](http://blogs.msdn.com/b/willy-peter_schaub/archive/2011/02/20/new-rangers-project-tfs-iteration-automation.aspx "Release 1 - TFS Iteration Automation") – Ranger project, which delivers core value to the Rangers community … automating the painful administration of fixing queries when switching iterations. The other value is to deliver an extensible platform for release 2 and beyond.
2. Release 2+ - Community project, owned/driven by external Rangers to extend the Release 1.0 product.

## TFS Automation Platform Scope

Team Foundation Server is currently comprised of several major feature areas, including, version control, work item tracking, build automation, reporting, and SharePoint.

At this point in time, the TFS Automation Platform is scoped to only support a the following TFS features:

- Work Item Tracking

## TFS Automation Platform Vision

The TFS Automation Platform is a development platform for partners and customers who are interested in building automations against TFS. One goal of the project is to make it simple to write a simple automation to perform some action. We intend to build a reusable framework with the ability to provide a menu of “automations” from a server that can be configured and/or run from any client with a single install on that client. An administrator would be able to add “automation” to a “menu” that allows users with appropriate permissions to select and configure those “automations” from a Visual Studio integrated UI at the Server, Collection, Project or Branch level.

An install on either the client or the server would only be required when the platform is updated and not to add “automations”. Think of it like the Wordpress Plugin system.

## Tfs Automation Platform Architecture

The purpose of this section is to help the team understand the way that the system goes together without locking them into an tight architecture at this early stage in the process.

[![image](images/image_thumb16-1-1.png "image")](http://blog.hinshelwood.com/files/2011/06/image16.png)  
{ .post-img }
**Figure: TFS Automation main components brainstorm**

### Automaton Package

With the need to run everything on the server to alleviate installs and maintained client side I would expect to have a package created (CurrentIteration.auto) that can be upload to the server and contains a manifest to describe its contents and where those content will reside.

- UI -
- ISubscribers
- Tfs Jobs
- Check In Policies
- Request Filters
- etc…

A folder naming should be maintained that relates as closely as possible to standard TFS naming. These packages will be stored in a “Store” that is accessed through a model that allows Multiple stores to be made available and combined for presentation to the users.

Where possible all automations should reflect the same API’s used within TFS in order to maintain feature parity and allow the development team to concentrate building against the TFS API. This will also allow an exacting ease of transitioning any existing Automations to this platform.

For those Automations that do not need a UI, but instead only require an “Enabled/Disabled” option the platform should provide this by default.

_note: It should be possible to turn an existing CheckinPolicy or ISubscriber into an Automation Package with winzip and notepad._

> I’m not really sure if that’s should be a requirement, I was expecting a lot more information to be transformed with code through a decorated Interface. I guess you plan to accomplish the same through some kind of manifest/config files ?  
> I can see both advantages and disadvantages with putting metadata in code and config files…  
> **\-Mattias Sköld**

No matter what decoration you did a manifest would still be required. For example, for an Automation that sends emails you would probably have an .htm email template. Where would you put that? How would you know that it even existed? Much better to have an XML file that lists where everything should go. We can however do a bunch of extra checks like:

- Don't put a ISubscribe in the job folder

These are all things that will help, but the core will be the manifest

_note: Some automations are single instance and others can be configured for multi-instance_

### Visual Studio Extension

This will likely be that main UI for users wishing to access and configure Automations. Any features that are beyond the default should be provided by a call to the server. There are a number of ways to achieve this that are built into .NET, from deep-linking into Silverlight and WPF, to the ability to instantiate a class that is contained in a DLL on the server. These all provide a level of extensibility that would allow a zero based (or at least infrequent) client install which is one of the goals.

My current bias is for a WPF application that is provided by the server and an add-on component for the Visual Studio client that loads a list of extension points from the server. The server would provide a list of GUID, image, text and URL to link to. The URL’s would be deep links into a single instance WPF application that is deployed from the server via ClickOnce. This should make it possible to frequently update the UI from the server without having to continuously force users to install updates.

### TfsAutomation.Platform.Core (Web Service or System Service)

The core platform should provide the core services for setting up and maintaining the platform. It will likely:

- Download chosen Automation packages from source store
- Storage of all unpacked Automations
- Keep all Automation Packages updated
- Deploy files to the correct locations
- retract the correct files and configurations
- Store instance configuration for Automations

The idea is that the core service will keep all of the Automation up to date and deploy them on demand to the correct location within TFS is required.For example, while I think we can easily proxy the Event Model, it would be a lot more difficult to proxy the Job model.

### TfsAutomation.Platform.Store (Web Service and Aggregation)

The PackageStore provides all of the automation packages that are available along with any meta data that is required. The system should be able to load from one or more stores simultaneously. This will allow smaller organisations or individuals to take advantage of a hosted store, or many hosted stores. This again allows for less installation changes as users can choose to load automations from external lists that are maintained separately.

> I don’t get this Multi Store thing ? Ive envisioned a “store” for each team project collection. Will we supply multi stores – what is the benefit of multi stores and what will a store relate to ?
>
> I was thinking more of an Automation Manager for project collections (compare to Process template manager).  
> **\-Mattias Sköld**

The Store refers to a source of plugins and not the list of installed plugins. Plugins are downloaded from the store prior to being installed and activated. The Store can be hosted locally for enterprises or for the vast majority of customer we can provide a hosted store that we maintain (MSDN Free Azure). In either regard think of the store like [http://wordpress.org/extend/plugins/](http://wordpress.org/extend/plugins/)

### TfsAutomation.SincProxy (ISubscriber)

The SinkProxy is a hook into the eventing model that will redirect events into the correct Automation Package for the Tfs Event that is fired. It will be responsible only for making sure that the correct event handlers are fired with the correct configuration.

_note: Configuration is set by the UI and stored by the Platform Core._

_note: I did indeed mean “Sink” and not “Synch”._

> In order to provide a reliable extension framework I would like the SincProxy to be responsible for providing isolation in the cases there it can be provided. For example if I make an automation that is async , I would like the Framework to que the execution of my automation in a separate process . This might be a less of a problem from a technical view if actions use the tfsJob for asyncronous work... For a TFS Admin it might be an issue to enable custom code if it will run inside the TFS process. If Im not misstaken the Tfs Job Agent by default is a bit to infrequent to provide a reasonable fast response for actions started from the UI, but I suspect you have a solution for this ?  
> **\-Mattias Sköld**

All processing will be done as part of the TFS Job and not in the SincProxy. Once you are in the running Job you can do that you are referring to, but you will need to handle the main thread waiting for the async one. The SincProxy is just one way of getting a job queued.

### TfsAutomation.RequestFilterProxy (ITeamFoundationRequestFilter)

For certain types of automation, like auditing, there is the need to have an injected filter on all requests so we can implement auditing.

### TfsAutomation.CheckInPolicyProxy (PolicyBase)

This is a single Check-In Policy that will proxy to any number of Check-In Polices that have been enabled server side. These policies are enabled as part of Automations and run Locally on the client. However the assemblies can be downloaded prior to execution from the Platform.Core service.

## Scenarios

There are really two scenarios I want to concentrate on for testing the TFS Iteration Automation release.

### Scenario 1: Change current iteration

When we get to the end of an iteration we need all of the queres in the “Current iteration” folder to reference “project1R1I2” rather than “project1R1I1”

1. **User logs onto TFS Automation UI and installs the “Current Iteration Changer” automation from the Store**
   1. TfsAutomation Core downloads the selected Automation and unpacks it locally.
   2. TfsAutomation Core deploys the correct files to the correct location defined in the manifest
   3. TfsAutomation sets automation to only work at the Project Level
2. **User enables the “Area/Iteration Rename Fixer”**
   1. TfsAutomation UI adds the default configuration for the new Automation
3. **User configures the “Area/Iteration Rename Fixer” for the Team Project “TeamProject1”**
   1. TfsAutomation UI adds the configuration for the new Automation to that team project and configures the folder that contains the current iteration queries
4. **User right-clicks on their Team Project and selects “Change Iteration”**
   1. TfsAutomation shows the UI to let the user select an iteration to change to
   2. TfsAutomation UI adds TfsAutomation.Iterations.ChangeCurrentJob to the TFS Jobs queue
   3. Job runs and does a replace in all of the queries in that project for the change.
   4. **Done** – Notify original calling user that the task is complete

### Scenario 2: User renames Iteration

When the user renames an iteration then a job needs to be kicked off that will fix all queries that use that iteration.

1. **User logs onto TFS Automation UI and installs the “Area/Iteration Rename Fixer” automation from the Store**
   1. TfsAutomation Core downloads the selected Automation and unpacks it locally.
   2. TfsAutomation Core deploys the correct files to the correct location defined in the manifest
2. **User enables the “Area/Iteration Rename Fixer” at the Server level**
   1. TfsAutomation UI adds the configuration for the new Automation
3. **User renames Iteration**
   1. Tfs Iteration Changed event fires on server
   2. TfsAutomation.SincProxy captures event and runs all appropriate “inner” subscribers
   3. TfsAutomation.Iterations.RenameSubscriber subscriber is run and adds TfsAutomation.Iterations.RenameJob to the TFS Jobs queue
   4. Job runs and does a replace in all of the queries in that project for the change.
   5. **Done** – Notify original calling user that the task is complete

## Conclusion

This poses to be a very interesting project if we can get the resource together to be effective. The idea is to start small, so expect to see some smaller, more focused architectures coming down the line.
