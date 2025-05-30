---
title: Creating WCF Service Host Programmatically
description: Explains how to programmatically create and configure a WCF Service Host in .NET, including base addresses, endpoints, bindings, and service behaviours for secure hosting.
ResourceId: z78UlmtJAzV
ResourceType: blog
ResourceContentOrigin: Human
ResourceImport: true
ResourceImportId: 393
ResourceImportSource: Wordpress
ResourceImportOriginalSource: GeeksWithBlogs
date: 2007-05-30
weight: 840
creator: Martin Hinshelwood
layout: blog
resourceTypes: blog
slug: creating-wcf-service-host-programmatically
aliases:
- /resources/z78UlmtJAzV
aliasesArchive:
- /blog/creating-wcf-service-host-programmatically
- /creating-wcf-service-host-programmatically
- /resources/blog/creating-wcf-service-host-programmatically
tags:
- Software Development
- Windows
- Technical Mastery
- Install and Configuration
categories:
- Uncategorized
preview: metro-binary-vb-128-link-1-1.png
Watermarks:
  description: 2025-05-13T16:28:13Z
concepts: []

---
If you want to create a [Windows Communication Foundation](http://wcf.netfx3.com "Windows Communication Foundation") Service Host on the fly then you will need to first create a base address. I would recommend using the DNS host entry instead of the My.Computer.Name as I had many problems on the corporate network with \[computername\] not working with our proxy settings.

```
Dim baseAddresses() As Uri = {New Uri(String.Format("http://{0}:{1}/TFSEventHandler/Queuer", System.Net.Dns.GetHostEntry(System.Net.Dns.GetHostName).HostName, Port))}
```

Then you need to create the service host itself.

```
Dim sh As New System.ServiceModel.ServiceHost(GetType(Services.QueuerService), baseAddresses)
```

Then set the service meta and debug behaviors so that you can both enable the MEX and remote exception handling.

```
' Set service meta behavior
Dim smb As ServiceMetadataBehavior = sh.Description.Behaviors.Find(Of ServiceMetadataBehavior)()
If smb Is Nothing Then
  smb = New ServiceMetadataBehavior()
  smb.HttpGetEnabled = True
  sh.Description.Behaviors.Add(smb)
Else
  smb.HttpGetEnabled = True
End If
' Set Service Debug Behavior
Dim sdb As ServiceDebugBehavior = sh.Description.Behaviors.Find(Of ServiceDebugBehavior)()
If sdb Is Nothing Then
  sdb = New ServiceDebugBehavior()
  sdb.IncludeExceptionDetailInFaults = True
  sh.Description.Behaviors.Add(sdb)
Else
  sdb.IncludeExceptionDetailInFaults = True
End If
```

Then comes the easy bit, adding the Endpoints. I have chosen to use a Secure wsHttpBinding as I am using Active Directory authentication and I want another level of security. Here I am creating a number of static end points, but also an endpoint for each of the Team Foundation Server SOAP Events, which uses the same code to handle each one, but you can determine the incoming URL for the event type.

```
sh.Description.Endpoints.Clear()
For Each EventType As Events.EventTypes In [Enum].GetValues(GetType(Events.EventTypes))
    sh.AddServiceEndpoint(GetType(Services.Contracts.INotification), GetSecureWSHttpBinding, "Notification/" & EventType.ToString)
Next
sh.AddServiceEndpoint(GetType(Services.Contracts.ISubscriptions), GetSecureWSDualHttpBinding, "Subscriptions")
sh.AddServiceEndpoint(GetType(Services.Contracts.ITeamServers), GetSecureWSDualHttpBinding, "TeamServers")
sh.AddServiceEndpoint(GetType(Description.IMetadataExchange), GetSecureWSHttpBinding, "mex")
```

You will need to create the binding programmatically as well (see the GetSecureDualWSHttpBinding method referenced above) and you may need to set some specialist options. I needed to increase the size of some of the payloads to implement my service. I have chosen to use the same method to create the service on both the client and the server so I have included the ClientBaseAddress property to get around the problem on Windows of a "http://+:80 error if you have IIS installed.

```
Dim Binding As New WSDualHttpBinding(WSDualHttpSecurityMode.Message)
Binding.MaxReceivedMessageSize = 655360
Binding.ReaderQuotas.MaxStringContentLength = 655360
Binding.ReaderQuotas.MaxArrayLength = 655360
Binding.Security.Message.ClientCredentialType = MessageCredentialType.Windows
Binding.Security.Message.NegotiateServiceCredential = True
Binding.ClientBaseAddress = New System.Uri("http://" & System.Net.Dns.GetHostEntry(System.Net.Dns.GetHostName).HostName & ":660")
Binding.BypassProxyOnLocal = True
```

Using this in conjunction with the custom proxy creation will allow you to build versatile integrated services on the .NET platform.

You can find all of the code listed above @ [http://www.codeplex.com/TFSEventHandler](http://www.codeplex.com/TFSEventHandler)
