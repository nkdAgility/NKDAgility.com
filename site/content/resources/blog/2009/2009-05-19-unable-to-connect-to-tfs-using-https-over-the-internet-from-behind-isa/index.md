---
title: Unable to connect to TFS using HTTPS over the Internet from behind ISA
description: Struggling to connect to TFS via HTTPS behind ISA? Discover workarounds and solutions to proxy authentication issues in Visual Studio 2010. Read more!
ResourceId: 6IrP42bGBD6
ResourceType: blog
ResourceImport: true
ResourceImportId: 113
ResourceImportSource: Wordpress
ResourceImportOriginalSource: GeeksWithBlogs
date: 2009-05-19
creator: Martin Hinshelwood
layout: blog
resourceTypes: blog
slug: unable-to-connect-to-tfs-using-https-over-the-internet-from-behind-isa
aliases:
- /blog/unable-to-connect-to-tfs-using-https-over-the-internet-from-behind-isa
- /unable-to-connect-to-tfs-using-https-over-the-internet-from-behind-isa
- /resources/6IrP42bGBD6
- /resources/blog/unable-to-connect-to-tfs-using-https-over-the-internet-from-behind-isa
aliasesFor404:
- /unable-to-connect-to-tfs-using-https-over-the-internet-from-behind-isa
- /blog/unable-to-connect-to-tfs-using-https-over-the-internet-from-behind-isa
- /resources/blog/unable-to-connect-to-tfs-using-https-over-the-internet-from-behind-isa
tags:
- Troubleshooting
preview: metro-visual-studio-2010-128-link-1-1.png
categories:
- Application Lifecycle Management
- Install and Configuration

---
I have a number of [CodePlex](http://www.codeplex.com "CodePlex") projects that I connect to from work and I have had a problem since 2008 that it does not always send my authentication to the proxy server (ISA). What this manifests as is that I get a popup telling me that “Proxy authentication is required”. The workaround was to connect in offline and then click the connect button and everything invariable works with no additional problems.

With Visual Studio 2010 the mater is slightly different. It pops up with a vague error that I had not seen before, but a little searching seamed to indicate that it may be the proxy problem rearing its ugly head in a killer way.

[![SavingToCodeplexOverHttpsThroughISA](images/image-1.png)](images/image-1.png)
{ .post-img }

So the “ServicePointManager does not support proxies with the https scheme” error has been seen before when connecting to [Windows Communication Foundation](http://wcf.netfx3.com "Windows Communication Foundation") services through a proxies. The fix is code based, so that is not something that I can achieve, so I have raised a [bug](https://connect.microsoft.com/VisualStudio/feedback/ViewFeedback.aspx?FeedbackID=453677) on Connect.

If you are experiencing this problem, then please add your support to the work item:

[BUG: Unable to connect to TFS using HTTPS over the Internet from behind ISA](https://connect.microsoft.com/VisualStudio/feedback/ViewFeedback.aspx?FeedbackID=453677)

Technorati Tags: [ALM](http://technorati.com/tags/ALM) [VS 2010](http://technorati.com/tags/VS+2010)
