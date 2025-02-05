Okay, so we're going to update a video. I have pre-prepared an issue on GitHub. What you do is you just click "New Issue" when you get here. Put the title in, add the copy as markdown. You can just paste from Word, and then you'll have to make it look like markdown. Here's one I prepared earlier. I've got the video ID because that's where we're going to find it. I've got the new title, I've got the old link, the current page. I just pasted that in, and then I added the copy in here as markdown. 

So let me edit that. There's the copy. You can add links and stuff in there. You can do all of those things, and they'll copy across. What's more interesting, if you're internal linking to other posts that are the same, we need to have a conversation about that because there are ways to do that to make it work nicely. 

But what I did, what I didly did, was I created a new workspace. I created a new branch. So over here, there was a button that said "New Branch." I clicked it. I just created it locally, and it said, "Do you want to open?" In fact, let's delete that branch just now. Delete. It's gone. 

Okay, so here's my content. I'm going to create a new branch. It's going to create a default name for that branch, and I'm going to say "Open in Codespace." So I'm going to create the branch, and I think I'll need to copy that because I think it'll open in this window, and I still want a copy of this so I can go back to it. 

So now it's opening. A Codespace, what it's doing is basically it's a virtual machine in the cloud. It's getting your code, the code for the site, getting it locally and building that environment. You just wait for it to open. You can see on the bottom left it says "Opening remote," and there it is. It's ready. So it's built. It's going to do some jiggy pokery behind the scenes while we're doing some other things, but it should be all working. 

So what I need to do is I need to find where this video is. If you remember, I used this code for the pages. So all of the code for the site is under "site." All of the content for the site is under "content." So there's capabilities, company outcomes, resources. Okay, so that's all the content for the site. Don't worry about these ones; these are for... yeah, don't worry about those ones. 

So I'm going to open up resources, and then I'm going to open up video, and then we have a folder called YouTube, which is where these are automatically added. You can see it's got all the YouTube IDs, so I need to find one, 1886. So if I just go down, 1806, there it is. And I can see it's got the data file, which is the stuff that got exported out of YouTube, and then it's got the built content file. 

Okay, so this is it here. What we're going to do is we are going to do a couple of things, but let me walk you through this file. So this is the original title, and you'll notice you put a dot in the title on YouTube, so it pulled it in here, and it means that we've got this extra little dash on the end there to represent that dot. So that should all work. 

I've already added this to the aliases in preparation for us setting this up. So there's a few changes we need to make here, and we need to update the copy. So let's get the copy first. I'm going to edit this. Here is our content. I'm going to copy that markdown, go over here. If you've got markdown in ChatGPT, it will output markdown, and you can just stick it in here or ask whatever tool you're using to create it as markdown. 

So we're going to replace this content here. So I'm just going to do that, select it all, boom, there we go. I've updated the file with the new content. I keep this; this is the video link. That's what renders the video at the top. You could put it there; that could look good. The default is at the top right, so I'm just going to leave it there. 

And then there's a couple of things we need to do in this content. If we leave it the way it is, we've not updated the title, we've not updated the URL, and this will get overwritten when we reprocess at midnight. Okay, so what you need to do in order to prevent that is we're going to take the title and we're going to add it to the title here. Okay, so that will be the new title. 

Then we're going to remove the slug. So this manually set the title, like the URL, the bit at the end, to what this was. If you want, you can make a new slug that's the same as this and put it in here. I think it's unnecessary, so I'm just going to delete it. And what it will do is it will take whatever's in here, so if you change it later, you need to remember to do some stuff. It will take whatever's there, and it will turn it into the URL of the page. 

So any special characters, anything like that, will get converted to dashes, and it will do that. Okay, I already added this, which is the old URL, so the redirect is already there. So you don't need to worry about that, but we do need to remove the canonical URL. That's what I search for when we're updating the content. If there's no canonical URL, it's not going to try and update this file. 

And the last thing we need to do is change the priority from four, one below half, to six, one above half, so that Google and everything knows that we have updated this content. So there's a do not; don't change the date. There's a hidden value, which is when we save this, it will automatically take that the last time we edited it as the date in there, so that's fine. 

And that's us. If I save that file and close it, we've now changed the file, but we need to publish it. So I need to go over here. You'll see it says one file pending changes. This is our source control. So if we go into source control, we've got our index, and I'm just going to grab this title, in fact, including the little hashy bit, the whole thing, and I'm going to say "Updated new copy for this." 

Okay, so this will link everything up and make sure it's all connected properly. You don't have to put it, but you have to put some text in here. And then I'm going to commit it. Would you like to stage all your changes? Yes, you could say always. I'm just going to say yes. This effectively, you've got changes, stage changes, and then you commit the staged changes. That way, you can have changes that you don't commit. Like, you could make packages if you're doing lots of changes, but don't worry about it now. 

We've saved it locally; we've published it locally, but we need to push it to the server. So I click this "Sync Changes." Okay, so now it's pushed that to the server. So if we go over here, go to pull requests, you'll see here's our copy. It's now published into source control in a branch. We need to get it onto... we need to start the process to get it published for reals. 

So we create a pull request, and it will basically take exactly... I'm actually just going to fix that there. It always does that because it's just long. I'm going to do that draft. There we go. So now that's going to publish a canary version of our product. 

Okay, so this is where we can see what are the changes that we've done, what do they look like, how are they used. So if I go along here, you can see it's got the action. So if we have to have a chat about it, we can do that in here. We've got the commits, so what are the number of changes we've made? Only made one, and we've got the files that we've changed, which is only one. 

So if I click on "Preview Changes," it will actually show... it's kind of a weird view because it's in line. It will show all the changes that we've made. So minuses are rows that are deleted, pluses are rows that are added. So we kind of deleted the title and added a new title. We deleted the four and added the six, and then you'll see it's kind of doing it line by line. But we replaced with the new copy that's much longer. 

Okay, so that all looks pretty good. What you would do... and we can probably set it up as an automatic... but you can ask... I can't ask myself for a review, but you'll have me in there, so you'll be able to just click on me and ask for a review. What we're waiting for is for it to all publish. 

Right, so you can see there that it's done some stages already. It's done "Run Data." Yeah, it's building the site right now and building the APIs, and then it will publish the site once it's finished publishing the site. We'll get a little message in here to tell us it's been published. 

Okay, so it's finished publishing the site. You can see all the checks have passed, so everything looks good. Now we can go check out the new page. So I'm using Control again to open this, and this is a special copy of the whole site, 146, just for you. So we're going to go in here. You can see it will say "Canary" at the top, and there's our pull request number. 

And we're going to go into videos, and then we could probably just find it, but what I'm going to do is I'm going to nick the URL. We're in videos. I'm going to put that on the end. There we go. So now this page is "The Hidden Cost of Pro Quality Code and How to Turn It into a Super Power" is the new title. 

So there you go. There's the new site published. So we can come back here. Somebody will approve it, and then we need to... it's ready for review, and then you submit for review. It's all good. We've checked it. Like, you can check this and then make a change. 

Okay, so let's say we weren't happy with what it looked like, and we wanted to make a change. I would go back to my Codespace over here, and I would go edit this file again. So let's say, I don't know, let's say I did want this to be here. So I would make that change. I would go over here, put a copy, commit it locally, push it to the server. This would start again. A new post will get made because this will be refreshed with the new version, and everything will be good. 

But we're not going to do that. I'm going to merge that pull request because we are, in fact, happy with it. So I'm going to merge it. It'll ask me how do you want to merge it? I just want to do this. Confirm. There we go. So that is all merged in. That branch that we were working on has been deleted. Therefore, the Codespace is still there, but I'm pretty sure that will vaporise in a little bit. 

And we go back here, and we're done. That is heading to preview site. So if you want to know when it is done, you'll see this one here on Main is heading there and doing all the stuff. So this will publish it to preview, and then we need to manually publish it to live. But this is a good way to see that. So that'll end up on preview. There you go.