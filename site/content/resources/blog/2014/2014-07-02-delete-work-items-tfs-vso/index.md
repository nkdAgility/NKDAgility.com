---
title: How to delete work items from TFS or VSO
description: Learn how to efficiently delete work items from TFS or VSO with expert tips and code examples. Streamline your project management today!
ResourceId: MYXrtTYV2UD
ResourceType: blog
ResourceImport: true
ResourceImportId: 10597
ResourceImportSource: Wordpress
ResourceImportOriginalSource: Wordpress
date: 2014-07-02
creator: Martin Hinshelwood
layout: blog
resourceTypes: blog
slug: delete-work-items-tfs-vso
aliases:
- /blog/delete-work-items-tfs-vso
- /delete-work-items-tfs-vso
- /how-to-delete-work-items-from-tfs-or-vso
- /blog/how-to-delete-work-items-from-tfs-or-vso
- /resources/MYXrtTYV2UD
- /resources/blog/delete-work-items-tfs-vso
aliasesFor404:
- /delete-work-items-tfs-vso
- /blog/delete-work-items-tfs-vso
- /how-to-delete-work-items-from-tfs-or-vso
- /blog/how-to-delete-work-items-from-tfs-or-vso
- /resources/blog/delete-work-items-tfs-vso
tags:
- Software Development
- Software Developers
- Azure Boards
- Azure Repos
- Agile Digital Tools
- Technical Excellence
- Modern Source Control
- Operational Practices
- Agile Tools
- System Configuration
- Working Software
- Pragmatic Thinking
- Troubleshooting
- Application Lifecycle Management
- DevOps
categories:
- Code and Complexity
- Practical Techniques and Tooling
- Install and Configuration
preview: nakedalm-experts-visual-studio-alm-1-1.png

---
Have you ever created a bunch of work items that you decided later that you had to delete. Well I have… especially as a user of the TFS Integration Platform. And when things go wrong there they can really go wrong.

Now while you can put stuff into the "removed" state it is still hanging around cluttering up the place. The only way out of the box to remove items is to give the ID for each work item that you want to delete and execute the command line for each one.:

```
witadmin destroywi /collection:CollectionURL /id:id [/noprompt]
```

_WARNING: This code can result in total loss of all work items you have if you miss key a query! Be careful… and you are on your own. Don't blame me, and no… I can’t get them back for you…_

Well that’s just great unless you have a couple of thousand things to delete. So I knocked up a little bit of code to do it for me. Now, since I have had to knock it up a bunch of times before I thought that I had better share it. I started this blog in the first place so that I would remember things.

```
using Microsoft.TeamFoundation.Client;
using Microsoft.TeamFoundation.WorkItemTracking.Client;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
 
namespace ConsoleApplication1
{
    class Program
    {
        static void Main(string[] args)
        {
 
            TfsTeamProjectCollection tpc = new TfsTeamProjectCollection(new Uri("http://tfs.company.com:8080/tfs/DefultCollection"));
            WorkItemStore store = tpc.GetService();
            string query = @"SELECT [System.Id] FROM WorkItems WHERE [System.TeamProject] = 'projectName'  AND  [System.AreaPath] UNDER 'projectName\_TOBEDELETED' ORDER BY [System.Id]";
            WorkItemCollection wis = store.Query(query);
            IEnumerable x = from WorkItem wi in wis select wi.Id;
            Console.WriteLine(string.Format("DESTROY {0} work items (they really can't be resurrected): y/n?", wis.Count));
            ConsoleKeyInfo cki = Console.ReadKey();
            Console.WriteLine();
          if (cki.Key.ToString().ToLower() == "y")
            {
            try
                {
                    Console.WriteLine("Deleting....");
                    IEnumerable y = store.DestroyWorkItems(x.ToArray());
                    Console.WriteLine("DONE");
                    foreach (var item in y)
                    {
                        Console.WriteLine(item.ToString());
                    }
                }
                catch (Exception)
                {
 
                    Console.WriteLine("Things have gotten all pooped up please try again!");
                }
        
            }
 
          Console.WriteLine("Freedom");
        }
   
    }
}

```

The first thing that you may notice is that I search for items in a specific area path. I use \_TOBEDELETED as it is obvious what is going to happen to things that end up there. Although I did work with a user who complained that all his files had gone missing. When asked where he kept them he pointed at the recycle bin on his desktop!

Anyhoo… just in case you made a mistake it will let you know how many work items that you are deleting. It’s a simple check but I have had it say "100,000" work items… AS you can imagine I very carefully terminated the program (never trust the 'no' option).
