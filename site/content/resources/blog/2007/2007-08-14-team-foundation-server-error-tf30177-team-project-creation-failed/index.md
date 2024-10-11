---
title: "Team Foundation Server Error TF30177 : Team Project Creation Failed"
date: 2007-08-14
creator: Martin Hinshelwood
id: "332"
layout: blog
resourceType: blog
slug: team-foundation-server-error-tf30177-team-project-creation-failed
aliases:
  - /blog/team-foundation-server-error-tf30177-team-project-creation-failed
tags:
  - ml
  - tfs
  - tools
  - visual-studio
  - vs2005
preview: metro-visual-studio-2005-128-link-1-1.png
---

When you create your first project, you may get an error during the creation process. When you look at the log file and see a "proxy error" message detail it may be to do with the way that TFS installs.

I  many large networks you can't connect to the server in the browser if you use the server name. This is because the proxy server is checking DNS for the name and unless you get every server in your company added to the proxy PAC file, you will get an error. To see if this is the issue try putting the server name into the browser:

http://myServerName.

If you get the error then you should try the FQDN:

http://myServerName.myInternalDomain.com

If this work then you need to change the URL's within TFS that it uses to define these calls. You can check what the current settings are by:

1. Open http://tfs01.uk.company.com:8080/Services/v1.0/Registration.asmx in your browser.
2. Click on GetRegistrationEntries.
3. Then click on Invoke.

Save (or just view) the resultant XML so you can have a look at it. There are two section of importance here. One is the Reports section which will look like:

> ```
> <RegistrationEntry>
>   <Type>Reports</Type>
>   <ServiceInterfaces>
>     <ServiceInterface>
>       <Name>BaseReportsUrl</Name>
>       <Url>http://[serverName]/Reports</Url>
>     </ServiceInterface>
>     <ServiceInterface>
>       <Name>DataSourceServer</Name>
>       <Url>[serverName]</Url>
>     </ServiceInterface>
>     <ServiceInterface>
>       <Name>ReportsService</Name>
>       <Url>http://[serverName]/ReportServer/ReportService.asmx</Url>
>     </ServiceInterface>
>   </ServiceInterfaces>
>   <Databases />
>   <EventTypes />
>   <ArtifactTypes />
>   <RegistrationExtendedAttributes />
> </RegistrationEntry>
> ```
>
> [](http://11011.net/software/vspaste)

The second is the is the WSS section that is in the same format.

Now, we have established that \[serverName\] will not work so we will have to update TFS with the new details. To do this you need to:

1. Create an XML file called RSRegister.xml with just the xml above.
2. Modify the server name from \[serverName\] to the FQDN of the server and save it.
3. on the TFS server you need to open a command prompt and execute the following:
   1. `iisreset /stop`
   2. `cd "%programfiles% Microsoft Visual Studio 2005 Team Foundation ServerTools"`
   3. `TFSReg.exe RSRegister.xml [yourDataTierServerName`\]
   4. i`isreset /start`
4. Then call the web service above to make sure that the settings are correct.

You can repeat this for the WSS (Windows Sharepoint Services) section.

All done and TFS should work. Although it is worth noting that in my company environment I could then no longer create projects from the TFS App server itself as \[serverName\] works but the FQDN did not. Typical...

Technorati Tags: [ALM](http://technorati.com/tags/ALM) [TFS](http://technorati.com/tags/TFS) [VS 2005](http://technorati.com/tags/VS+2005)

