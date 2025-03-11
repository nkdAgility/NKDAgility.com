---
title: TeamPlain - Revisit
description: Discover a clever workaround for long project names in TeamPlain. Enhance your project management with this practical JavaScript solution. Read more!
ResourceId: 74iowBMHVfu
ResourceType: blog
ResourceImport: true
ResourceImportId: 419
ResourceImportSource: Wordpress
ResourceImportOriginalSource: GeeksWithBlogs
date: 2007-04-02
weight: 1000
creator: Martin Hinshelwood
layout: blog
resourceTypes: blog
slug: teamplain-revisit
aliases:
- /blog/teamplain-revisit
- /teamplain-revisit
- /teamplain---revisit
- /blog/teamplain---revisit
- /resources/74iowBMHVfu
- /resources/blog/teamplain-revisit
aliasesArchive:
- /blog/teamplain-revisit
- /teamplain-revisit
- /teamplain---revisit
- /blog/teamplain---revisit
- /resources/blog/teamplain-revisit
preview: nakedalm-logo-128-link-1-1.png
categories: []
tags:
- Pragmatic Thinking
- Troubleshooting
- Miscellaneous

---
I ran into some problems that I blogged on in my [TeamPlain - Install and initial views](http://team.worldnet-dev.ml.com/workitem.aspx?id=185) post. I have got a work around for the long project name problem, but it only works when you really daft project names like ours:

"XXEMEA-UK-Area-Dept-BusinessUnit-\[Project Name\]"

What I have done is rewrite this drop down list after it has been rendered using JavaScript!

Eww, I hear you say. Well as team server does not support compartmentalization of projects out of the box the long project names must stay.

Here is the code:

> <script type="text/JavaScript">
> 
> function Remove(ProjectString,ThingToRemove)  
> {  
> if (ProjectString.indexOf(ThingToRemove) == 0)  
> {  
> ProjectString = ProjectString.replace(ThingToRemove, '');  
> }  
> return ProjectString  
> }
> 
> var mylist=document.getElementById("ph1\_cmbProjects");  
> for (i=0;i<=mylist.length-1;i++)  
> {  
> mylist.options\[i\].text = Remove(mylist.options\[i\].text,'XXEMEA-UK-Area2-Dept1-BusinessUnit1-')  
> mylist.options\[i\].text = Remove(mylist.options\[i\].text,'XXEMEA-UK-Area2-Dept1-BusinessUnit2-')  
> mylist.options\[i\].text = Remove(mylist.options\[i\].text,'XXEMEA-UK-Area2-Dept1-')  
> mylist.options\[i\].text = Remove(mylist.options\[i\].text,'XXEMEA-UK-Area1-PP-')  
> mylist.options\[i\].text = Remove(mylist.options\[i\].text,'XXEMEA-UK-Area1-TFS-')  
> }
> 
> </script>

Put it after the drop down list by the id of "cmbProjects" and change the remove function calls for whatever you need.

I know it is ugly, but it is the sort of "Tactical" work around that gets the short term problem sorted.

I permanent solution would be nested projects (Or and Organizational Unit separator for the project name) from Microsoft, but I don't think it is on the cards in the near future!

Technorati Tags: [ALM](http://technorati.com/tags/ALM)
