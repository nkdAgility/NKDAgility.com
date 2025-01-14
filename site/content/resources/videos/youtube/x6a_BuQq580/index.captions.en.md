There's a little bit of a fear of incomplete migrations, that things won't be available when you move to the cloud. I've done hundreds of migrations using Microsoft's database import tool, and I have never had any data loss in any context whatsoever that wasn't known about beforehand. There are certain things that don't work in the cloud that you can do on-prem. You can increase the database attachment size on-prem, and that will unfortunately not be possible in the cloud, right? Because there are other people on the system; it's not just your company, so you're not the only ones taking the hit for performance issues for having attachments that are too big or build lists that are bigger than normal.

So there are some things, but upfront when you're planning the migration, we need to call those things out. We need to cut them down; we need to figure out how to resolve those things. Microsoft provides tooling to help understand what those things are, what the impact is, and what we need to do in order to make our environment viable for moving up to Azure DevOps. 

So there's not really any such thing as an incomplete migration within that context; it will just work. I've had migrations get stuck, and then we have to back off, restore, and turn back on. That's how you restore; you turn it back on, turn back on TFS locally, and then replan something because something's gone wrong or something needs to be done on Microsoft's end. But usually, especially if it's a bigger migration, you talk to Microsoft first, and they have a support team available who know you're doing a migration. You can email them, and they'll go kick the environment or figure out what the problem is at the time so that you can continue.

So, incomplete migrations from that perspective are not a big deal. If you're doing an ad hoc PC email migration, like you're moving the bits and pieces that you want to move, like would you just want to move this team or this subset of this team or this project or just this data, then we will know upfront exactly what you can and cannot do within the context of that migration. But it's not something we can define at this point because it's wholly dependent upon your data, the format of your data, what you want to move, what you're okay with losing, and having conversations around that. So you'll know upfront. 

So when it gets to migration time, there shouldn't be any surprises at all.