---
title: TFS Event Handler prototype Configuration Demystified
date: 2007-06-18
creator: Martin Hinshelwood
id: "379"
layout: blog
resourceType: blog
slug: tfs-event-handler-prototype-configuration-demystified
aliases:
  - /blog/tfs-event-handler-prototype-configuration-demystified
tags:
  - code
  - tfs-event-handler
  - tools
  - wit
categories:
  - code-and-complexity
preview: metro-binary-vb-128-link-1-1.png
---

There are a number of config options for the [TFS Event Handler Prototype](http://www.codeplex.com/TFSEventHandler/Release/ProjectReleases.aspx?ReleaseId=5057). I will describe all of them in depth here. The first step is to set the [Windows Communication Foundation](http://wcf.netfx3.com "Windows Communication Foundation") service options, which really only requires you to change one value.

```
<system.serviceModel>         <services>             <service name="RDdotNet.TeamFoundation.NotificationService">                 <endpoint address="http://[LocalMacheneName]:8677" binding="basicHttpBinding"
                    bindingConfiguration="" contract="RDdotNet.TeamFoundation.INotificationService" />             </service>         </services>     </system.serviceModel>
```

The important one is the \[LocalMacheneName\] variable, which should be set to the local machine name, or the domain name that points to your computer if you have a crazy proxy.

The next step is to set the real options for this software. This starts with the <[RDdotNet](http://www.rddotnet.com "RDdotNet - Reality Dysfunction .NET").TeamFoundation\> options and requires you to set a number of things.

```
<BaseAddress url="http://[LocalMacheneName]:3624/" />
```

Again you need to set the machine name, but make sure that the port is different.

```
<TeamServers>             <TeamServer name="[TFS Server Name]"
                        url="http://[TFS Server Name]:8080/"
                        subscriber="[Subscriber AD Account]"
                        mailAddressFrom="[From Email Address]"
                        mailFromName="[Form name]"
                        mailServer="[email relay server]"
                        logEvents="True"
                        testMode="True"
                        testEmail="[email to send testes to]"
                        eventLogPath="C:tempTFSEventHandler">             </TeamServer>         </TeamServers>
```

In the Team Servers section you need to list all of the team servers that you are going to be handling events for. The system will automatically add the event subscriptions for all team servers added here, but I have only tested with two and I now always run the service on the [TFS](http://msdn2.microsoft.com/en-us/teamsystem/aa718934.aspx "Team Foundation Server") server.

TeamServer Options

<table border="1" cellspacing="0" cellpadding="2" width="577"><tbody><tr><td width="138" valign="top"><strong>Name</strong></td><td width="144" valign="top"><strong>Type</strong></td><td width="293" valign="top"><strong>Description</strong></td></tr><tr><td width="141" valign="top">name</td><td width="145" valign="top">System.String</td><td width="291" valign="top">This should be a friendly name for the team foundation server</td></tr><tr><td width="142" valign="top">url</td><td width="145" valign="top">System.Uri</td><td width="290" valign="top">The URI for the TFS server you wish to connect to including protocol and port.</td></tr><tr><td width="144" valign="top">mailFromAddress</td><td width="145" valign="top">System.String</td><td width="289" valign="top">The address from which you want all emails sent by the system to say that they are sent.</td></tr><tr><td width="145" valign="top">mailFromName</td><td width="145" valign="top">System.String</td><td width="288" valign="top">The display name of the from&nbsp;email address</td></tr><tr><td width="146" valign="top">mailServer</td><td width="145" valign="top">System.String</td><td width="287" valign="top">The mail server that you have permission for to send emails</td></tr><tr><td width="147" valign="top">logEvents</td><td width="145" valign="top">System.Boolean</td><td width="287" valign="top">A true or false value that enables logging of all events within that system. Excellent for debugging...</td></tr><tr><td width="147" valign="top">testMode</td><td width="145" valign="top">System.Boolean</td><td width="287" valign="top">When in test mode all emails sent by the system will only be sent to email address defined by testEmail. Set to false for production.</td></tr><tr><td width="147" valign="top">testEmail</td><td width="145" valign="top">System.String</td><td width="287" valign="top">The email address that, when testMode is enabled will receive all emails sent from the system.</td></tr><tr><td width="147" valign="top">eventLogPath</td><td width="145" valign="top">System.String</td><td width="287" valign="top">the location that the event logs will be written to. All events received get assigned a System.Guid and all logs pertaining to that event get saved in the corresponding folder.</td></tr><tr><td width="147" valign="top">subscriber</td><td width="145" valign="top">System.String</td><td width="287" valign="top">The AD account name of the account that is writing the events. Set to the name of your TFSSetup or TFSService accounts.</td></tr></tbody></table>

Now you are ready to set the event handlers. These are defined within the "Events" section:

> <Events\>
>
> <!--
>
> Use one of the following events:
>
> AclChangedEven
>
> Branchmovedevent
>
> BuildCompletionEvent
>
> BuildStatusChangeEvent
>
> CommonStructureChangedEvent
>
> DataChangedEvent
>
> IdentityChangedEvent
>
> IdentityCreatedEvent
>
> IdentityDeletedEvent
>
> MembershipChangedEvent
>
> WorkItemChangedEvent)
>
> Then you need to add handlers for the events.
>
> Example:
>
> <Event eventType="WorkItemChangedEvent">
>
> <Handlers>
>
> <Handler type="RDdotNet.TeamFoundation.WorkItemTracking.AssignedToHandler"
>
> assemblyFileName="RDdotNet.TeamFoundation.WorkItemTracking.AssignedTo.dll"
>
> assemblyFileLocation="~EventHandlersWorkItemTracking">
>
> </Handler>
>
> </Handlers>
>
> </Event>
>
> \-->
>
> <Event eventType\="WorkItemChangedEvent"\>
>
> <Handlers\>
>
> <Handler type\="[RDdotNet](http://www.rddotnet.com "RDdotNet - Reality Dysfunction .NET").TeamFoundation.WorkItemTracking.AssignedToHandler"
>
> assemblyFileName\="[RDdotNet](http://www.rddotnet.com "RDdotNet - Reality Dysfunction .NET").TeamFoundation.WorkItemTracking.AssignedTo.dll"
>
> assemblyFileLocation\="~EventHandlersWorkItemTracking"\>
>
> </Handler\>
>
> </Handlers\>
>
> </Event\>
>
> </Events\>

As you can see you are theoretically allows to us any events. Please keep in mind that only the WorkItemChangedEvent and the CheckInEvent have been tested. When you add the "Event" tag with the corresponding eventType (which is an enumerator) this tells the system which specific events to subscribe to.

You can then add handlers to an event. These handlers are fired whenever these events are received.

<table border="1" cellspacing="0" cellpadding="2" width="571"><tbody><tr><td width="90" valign="top"><strong>Name</strong></td><td width="277" valign="top"><strong>Type</strong></td><td width="202" valign="top"><strong>Description</strong></td></tr><tr><td width="93" valign="top">eventType</td><td width="279" valign="top"><a title="RDdotNet - Reality Dysfunction .NET" href="http://www.rddotnet.com" target="_blank">RDdotNet</a>.TeamFoundation.EventTypes</td><td width="199" valign="top">Enumerator that&nbsp; defines the list of possible events.</td></tr><tr><td width="95" valign="top">type</td><td width="281" valign="top">System.Type</td><td width="197" valign="top">This must be a valid type in the assembly listed in assemblyFileName</td></tr><tr><td width="96" valign="top">assemblyFileName</td><td width="282" valign="top">System.String</td><td width="196" valign="top">This must be a valid assembly found in the assemblyFileLocation</td></tr><tr><td width="96" valign="top">assemblyFileLocation</td><td width="282" valign="top">System.String</td><td width="196" valign="top">A location within the servers file system that holds this assembly. ~ denotes the applications root.</td></tr></tbody></table>

If you are using friendly server names or TeamPlain the you can change the  TFS server links to be TeamPlain ones using the UrlReplacements config element:

> ```
> <UrlReplacements>             <!-- The Url Replaces change the url listed in the event to valid public items             Examples:                 This item changes the TFS url to a TeamPlain v1 url                 <Replace eventType="WorkItemChangedEvent" old=":8080/WorkItemTracking/WorkItem.aspx?artifactMoniker=" new="/workitem.aspx?id=" />                                              These items change the server location to a public host header:                 <Replace eventType="WorkItemChangedEvent" old="[ServerProductionEnviromentName]" new="[PublicProductionEnviromentUri]" />                 <Replace eventType="WorkItemChangedEvent" old="[ServerDevelopmentEnviromentName]" new="[PublicDevelopmentEnviromentUri]" />             -->
> ```
>
> ```
> </UrlReplacements>
> ```

This works by replacing values within the URL in the events. You specify the event type, what to look for and what to replace it by. This allows grater control and the integration of TeamPlain into your world. If a task is assigned to someone outside of your departmental sphere who you have given permission to TFS but who know nothing about it, they will still get an email that will link them through to TeamPlain.

And that is you all set. if you have installed the service and set the account that is used to run the service you should get no errors when starting. No guarantees though :)
