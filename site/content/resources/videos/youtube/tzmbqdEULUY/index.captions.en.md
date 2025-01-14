When you're doing a migration of data, downtime isn't of always great concern for organisations. If you've got 5,000 software engineers in your collection, you don't want it to be down for an extended period of time and your engineers not able to work. I'm going to put that in air quotes because it's not really true; not able to work for that period of time. 

So, there's a couple of things that you do need to kind of understand in this context. Even if TFS or Azure DevOps is down, like offline, your engineers can still work. It's just more difficult for them to collaborate together. So, if they're using Git as the source control system, which is the primary source control system in Azure DevOps and TFS, then they're able to even share code in a way that works within the context of the tool, even when they're offline. That's how Linux was created; there was no central source control system and they sent patches to each other over email. 

Right? So, Git fully supports that. Obviously, they wouldn't have access to the work items, so they would need to know what it is we're working on for the time that it's down. But I will point out that if you plan it right, downtime can be absolutely minimal. The largest migration we have done was 2.5 terabytes, a collection that we moved up from on-prem in Europe to Azure DevOps. 

We took the system offline because it needs to be offline to do the final part of the migration. We're actually moving up to the cloud. We took it offline at 5:00 p.m. on Friday, and we were back online Sunday morning. The engineers came in over the weekend to validate that things looked good. They did their cursory checks; everything's in the right place, that that's working, this is working, that kind of thing. 

And they were back up and running Monday morning. So, that's probably one of the very few people out there that have collections that big. But if you plan it right—and that took, in order to do a 2.5 terabyte system in that time, we probably took 3 to 6 months of planning and dry runs and validations and making sure everything's good in the data. 

Dry runs are really important for that. Sorry, that's practice runs, right? To get the data out of the data centre in a timely manner, get it up to the cloud in a timely manner, or get it processed, because that can be quite failure-prone. You want to have done a dry run so that you know that's going to work. 

And perhaps have Microsoft on hand to help out if there are any issues. So, that was minimal downtime. I think that was about 5,500 software engineers, and they really, really had no downtime. 5:00 p.m. on Friday, back up in the morning. But they were a global company, so there was some downtime for some engineers in some regions, right? Because that's just unavoidable. But we minimised it as much as possible.