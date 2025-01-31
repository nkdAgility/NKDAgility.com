---
title: Why I think VB.NET is a better choice than C#
description: Discover why VB.NET may be a superior choice over C# for readability, accessibility, and efficiency, especially for developers with dyslexia.
ResourceId: 1Vt6-eiRtjI
ResourceImport: true
ResourceImportId: 340
ResourceImportSource: Wordpress
ResourceImportOriginalSource: GeeksWithBlogs
date: 2007-08-06
creator: Martin Hinshelwood
id: "340"
layout: blog
resourceTypes: blog
slug: why-i-think-vb-net-is-a-better-choice-than-c
aliases:
- /blog/why-i-think-vb-net-is-a-better-choice-than-c
- /why-i-think-vb-net-is-a-better-choice-than-c
- /why-i-think-vb-net-is-a-better-choice-than-c-
- /blog/why-i-think-vb-net-is-a-better-choice-than-c-
- /resources/1Vt6-eiRtjI
- /resources/blog/why-i-think-vb-net-is-a-better-choice-than-c
aliasesFor404:
- /why-i-think-vb-net-is-a-better-choice-than-c
- /blog/why-i-think-vb-net-is-a-better-choice-than-c
- /why-i-think-vb-net-is-a-better-choice-than-c-
- /blog/why-i-think-vb-net-is-a-better-choice-than-c-
tags:
- dyslexia
- tools
- visual-basic
- visual-basic-9
categories:
- me
preview: nakedalm-logo-128-link-1-1.png

---
The reasons I think that VB.NET is better than C# are many, but I will try to put some of them down in a coherent manor unlike the usual C# developer that can only come up with "[vb is a language for mediocre programmers...anyway looks ugly and smells ugly..](http://blog.hinshelwood.com/archive/2007/08/05/114415.aspx#140605)" (Hmm, he must have thought long and hard to come up with that).

**Reason 1 - Business sense**

liviu is right that many mediocre programmers are VB programmers. This is because VB is easier to read and easier to code, thus there are actually many more VB.NET programmer than C# in the world, so ov course there are more mediocre ones, statistics demand that. But this is its advantage, you can have a superb developer produce your application, then have on of the mediocre programmers maintain it. This keeps costs down for the business, and frees up the superb programmers time to work on the next complex project.

**Reason 2 - Visual sense**

The readability of VB.NTE is what makes it more popular. Take these pieces of code for example:

![](images/image_thumb.png)
{ .post-img }

or (thanks [Mihir Solanki](http://www.mihirsolanki.com/) for the timely translation)

> NorthwindDataContext ctx = new NorthwindDataContext();
>
> var query = from c in ctx.Customers  
>                   where c.Country == "UK"  
>                   select new { Name = c.ContactTitle + " " + c.ContactName };
>
> foreach (var c in query.Skip(2).Take(3))  
> {  
> Console.WriteLine(c.Name);  
> }

Forget for a moment that the VB is nicely formatted, this looks pretty similar. There are the same number of lines. The same amount of text. But I find the VB version easier to read as it is more logical, it flows better and you can read it much more effectively.

But this is just personal preference.

**Reason 3 - Disability friendly**

VB.NET unlike C# is not case sensitive. I have always wondered why in this day and age that C# is still case sensitive. It seams to me that this is a historical thing, but it just avoids confusion and makes you code more readable if "variable" and "Variable" and "vaRiable" are the same thing and not different.

If you are [dyslexic like me](http://blog.hinshelwood.com/archive/2007/07/23/What-is-dyslexiaAgain.aspx) then this is very confusing as although "r" and "R" are difficult to confuse, "v" and "V" is the same letter, only slightly bigger. This means that you code is more accessible and disability friendly if you do not have case sensitivity.

**Reason 4 - Intellisense**

Oh how I love intellisense, the joy to have all of your code write itself. In effect this makes the argument of C# being more concise mute, as your code almost writes itself.

**Reason 5 - Dynamic checking**

Using VB.NET I do not need to wait till compile time to see if I have any typos or errors in my code and the "write-time" compiler for VB.NET checks my code as I type. As a dyslexic who can write the same work six times in the same object differently and not be able to see the difference you can imagine how helpfully this is.

Would you like Word to only check your spelling when you try to save, and refuse to save until you had fixed it? I think not...

**Reason 6  - Personal**

I don't know if it is a symptom of my dyslexia, but curly brackets ({ and }) give me the heebie jeebies and I find I am unable to see where one method, or loop ends and the others begin. If it is part of my dyslexia then that is an even better proponent of VB.NET over C# and should be added to reason 3.

**Conclusion**

Although the use of VB.NET over C# is a personal preference it also has many advantages. The more noted of which is Readability, disability friendly and 'write-time' code checking. With all this it is actually faster to write in VB than C#.

Lets all try to make our code more accessible and use VB.NET.

P.S. I don't know what I am doing wrong, I can't seems to 'smell' any of my code, neither VB.NET or C#. Hmm...

Technorati Tags: [.NET](http://technorati.com/tags/.NET) [Dyslexia](http://technorati.com/tags/Dyslexia)
