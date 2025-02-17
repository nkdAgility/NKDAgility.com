---
title: Create log entries in Release Management
description: Learn how to create effective log entries in Release Management using PowerShell. Enhance your deployment process and ensure success with detailed logs!
ResourceId: 1jC1jE7shiY
ResourceType: blog
ResourceImport: true
ResourceImportId: 10975
ResourceImportSource: Wordpress
ResourceImportOriginalSource: Wordpress
date: 2014-12-12
creator: Martin Hinshelwood
layout: blog
resourceTypes: blog
slug: create-log-entries-release-management
aliases:
- /blog/create-log-entries-release-management
- /create-log-entries-release-management
- /create-log-entries-in-release-management
- /blog/create-log-entries-in-release-management
- /resources/1jC1jE7shiY
- /resources/blog/create-log-entries-release-management
aliasesFor404:
- /create-log-entries-release-management
- /blog/create-log-entries-release-management
- /create-log-entries-in-release-management
- /blog/create-log-entries-in-release-management
- /resources/blog/create-log-entries-release-management
tags:
- Windows
- Release Management
- Application Lifecycle Management
- System Configuration
- Practical Techniques and Tooling
- Azure Pipelines
- Technical Mastery
- Azure DevOps
- Troubleshooting
- Software Development
- Pragmatic Thinking
categories:
- Technical Excellence
preview: nakedalm-experts-visual-studio-alm-5-5.png

---
I have been working through my demos for NDC London next week. And I found it almost impossible to create log entries in Release Management where I wanted.

While in London for NDC 2014 I was in the same building as the filming of Mission Impossible 5. I worked on a TV show for my work experience at school and ended up with an [IMDB profile](http://www.imdb.com/name/nm4402255/) and what always struck me was how much time was spent getting one a few minutes or even seconds of footage. If you ever get a chance to even be in the audience for a 30 minute comedy show, be warned… you will be there for at least 6 hours to get only 25 minutes of air time.

Sometimes the same thing happens for demos. My demo for NDC was an end to end presentation of Visual Studio ALM with VSO. For that I needed to have a full release pipeline for my application and as I just downloaded Fabirkam Fibre I had to [create that release pipeline](http://nkdagility.com/create-release-management-pipeline-professional-developers/) from scratch. While I was building this out I ran into a few issues and one that was kind of annoying was an inability to get a log to output so I could review what happened during the deployment.

If you have a deployment script it is really easy to fail it out. All you need to do is have an error occur, or deliberately call a "Write-Error" command. Simples. But what about having a log of the good things that happened?

![clip_image001](images/clip_image0011-1-1.png "clip_image001")
{ .post-img }

If everything goes swimmingly then you get an empty space where the log should be. So how do I get an output. Well if I was creating a build script I could just have "Write-Host" and the build system would capture and log all the output.

```
#### Update Web.config
$config = Get-Content $destinationPathweb.config
$config = $config -replace "__connectionString__", $connectionString
Set-Content $destinationPathweb.config $config
Write-Host "Updated web.config"
```

Well lets try "Write-Host"…

![clip_image002](images/clip_image0021-2-2.png "clip_image002")
{ .post-img }

Well, that’s not good. Looks like the Release Management team forgot to pipe the output that is intended for the "host" to the file. While "host" in the normal context is normally the "command prompt", a script should not just fail because you are running it differently. You should always make sure that you pipe the output to the correct location for your context.

A command that prompts the user failed because the host program or the command type does not support user interaction. Try a host program that supports user interaction, such as the Windows PowerShell Console or Windows PowerShell ISE, and remove prompt-related commands from command types that do not support user interaction, such as Windows PowerShell workflows.

```
+At C:WindowsDtlDownloadsFabrikamFiber.WebDeploySimpleDeploy.ps1:31 char:1
+ Write-Host "destinationPath: $destinationPath"
+ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
CategoryInfo :NotImplemented: (:) [Write-Host], HostException
FullyQualifiedErrorId :HostFunctionNotImplemented,Microsoft.PowerShell.Commands.WriteHostCommand
Moo.. That’s just a nasty error that should never happen. SO lets try a simple "Write-Output" shall we.
Write-Output "applicationAnalyticsKey: $applicationAnalyticsKey"
```

![clip_image003](images/clip_image0031-3-3.png "clip_image003")
{ .post-img }

Dam… "Write-Output" just disappears into the ether. It really should end up in the output but… well… it does not.. And "Write-Verbose" also end up nowhere, but that is a little more expected. At this point I am at a loss and ping the product team. Really, if I write something to the output and I would see it if running from the command line I want to see it in the log file. However for RM you need to explicitly declare output by using the "-verbose" command to tell PowerShell to actually write the verbose statements.

```
Write-Verbose "applicationAnalyticsKey: $applicationAnalyticsKey" -verbose
```

![clip_image004](images/clip_image0041-4-4.png "clip_image004")
{ .post-img }

Well… now I get some output and a lovely log to view for later. While I may not ever look, when I do need something it will be there. Success logs are just as important as failure ones…
