---
id: "447"
title: "Ahhh, the fun of deploying Team System in a large corporation"
date: "2006-12-15"
coverImage: "nakedalm-logo-128-link-1-1.png"
author: "MrHinsh"
layout: blog
resourceType: blog
slug: "ahhh-the-fun-of-deploying-team-system-in-a-large-corporation"
---

I can see that this project is going to be fun. I need to deploy team system within the investment bank that I work for. The DBA's will not let me access their servers! And the TFS installation needs to be run on them.

However their is a way round this which a nice man called [Brian Keller](http://blogs.msdn.com/briankel/ "Brian Keller") let me in on, thanks Brian.

You can create the databases on another server and use "How to: Restore Team Foundation Server Data to a Different Server" to move the database's across.

Has anyone tried this?

Check out the TFS Administration Guide at [http://www.microsoft.com/downloads/details.aspx?familyid=2AED0ECC-1552-49F1-ABE7-4905155E210A&displaylang=en](http://www.microsoft.com/downloads/details.aspx?familyid=2AED0ECC-1552-49F1-ABE7-4905155E210A&displaylang=en).  
Be sure to note the steps in the KB article for assistance opening the guide [http://support.microsoft.com/kb/902225/](http://support.microsoft.com/kb/902225/).

---

More on [**Team Foundation Server**](http://geekswithblogs.net/Providers/BlogEntryEditor/FCKeditor/editor/) from hinshelm.

More on [**TFS Deployment**](/hinshelm/category/5992.aspx) from hinshelm.

Technorati Tags: [ALM](http://technorati.com/tags/ALM)