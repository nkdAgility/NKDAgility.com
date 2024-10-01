---
id: "11308"
title: "Upgrading to TFS 2015 in production - DONE"
date: "2015-04-29"
categories: 
  - "install-and-configuration"
tags: 
  - "tfs"
  - "tfs-2013-4"
  - "tfs-2015"
  - "upgrade"
coverImage: "nakedalm-experts-visual-studio-alm-22-22.png"
author: "MrHinsh"
type: "post"
slug: "upgrading-to-tfs-2015-in-production-done"
---

I am onsite today with a customer in London to do an upgrade of their production system to TFS 2015. We have a backup of the databases and a snapshot of the VM and are good to go.

It looks like this may have been the [first upgrade to TFS 2015 in production](http://blogs.msdn.com/b/bharry/archive/2015/04/27/first-tfs-2015-rc-production-upgrade-i-know-of.aspx), at least beyond internal consulting company's.

\[pl\_button type="info" link="http://visualstudio.com" target="blank"\]Download 2015 today\[/pl\_button\]

With the availability of a fully supported version of TFS 2015 I will be upgrading my customers production TFS server to TFS 2015 so that they can get all of the goodies.

This customer does not have huge TFS databases with only circa 9GB of data in their only configuration database so this should not take long. But remember, there are significant schema changes in TFS 2015 and you will need at least the same amount of free space as data that you have in TFS.

If you are on TFS 2010 (or any prior version) then remember that support ends at the end of July and that you should upgrade. If you are upgrading anyway then you should upgrade to TFS 2015.

For prepping for this upgrade I ran a bunch of installs and test upgrades over the weekend and we too backups. For backup we have a two party system. We have a SQL Server full backup that was taken when the TFS server was off, that is to prevent the need for marked transaction logging for a possible restore if anything goes wrong. We also took a snapshot of the TFS application tier to enable a much quicker re-configuration of TFS 2013. While this does not include the SQL databases that are on the SQL Server cluster, it does include things like .NET version and IIS configuration.

<table class="table"><tbody><tr><td valign="top" width="80">TFS Instance</td><td valign="top" width="80">Database</td><td valign="top" width="80">Size</td><td valign="top" width="80">Duration</td><td valign="top" width="80">&nbsp;</td></tr><tr><td valign="top" width="80">CustomerA</td><td valign="top" width="80">Tfs_Configuration</td><td valign="top" width="80">590mb</td><td valign="top" width="80">2 minutes</td><td valign="top" width="80">&nbsp;</td></tr><tr><td valign="top" width="80">&nbsp;</td><td valign="top" width="80">Tfs_DefaultCollection</td><td valign="top" width="80">9gb</td><td valign="top" width="80">9 minutes</td><td valign="top" width="80">&nbsp;</td></tr></tbody></table>

The duration for this server upgrade will be recorded above. This time is totally dependent on hardware and network communication.

![clip_image001](images/clip_image001-1-1.png "clip_image001")
{ .post-img }

As usual I will be installing the losable bits on the C drive with the operating system. This is consistent with modern best practices.

![clip_image002](images/clip_image002-2-2.png "clip_image002")
{ .post-img }

The install is pretty quick and only took a few minutes, \[same as a fresh install of TFS 2015\]. As I am just running the install and relying on the TFS bits to get rid of the old bits this seems pretty fast.

![clip_image003](images/clip_image003-3-3.png "clip_image003")
{ .post-img }

As I mentioned when I was installing a clean TFS 2015 the installer will pop the configuration wizard and the wizard will detect of it is an upgrade and automatically launch the upgrade wizard. You will need all of the Server names and accounts with passwords that TFS runs under to complete the upgrade.

Note: If your IS department has messed with the permissions of your TFS or SQL servers you may need to make sure that you have Server Admin and SysAdmin on the required boxes before you proceed.

TFS 2015 will make sure that you have all of the required pre-requisites before you start the install, and you may need to fix a few things before you proceed.

![clip_image004](images/clip_image004-4-4.png "clip_image004")
{ .post-img }

First you need to verify the database settings. This will default to the same settings as your previous server as was previously set and will show the databases available. If you are moving servers then you should change to the new DB server now so that you don’t accidentally upgrade the current production databases. However in this case I am doing an in place upgrade to TFS 2015.

As this is a big upgrade you will need to select two confirmation checks. First is new and gets you to verify that you have enough disk space to proceed with a FULL recovery model. Typically you need at least twice the space that your databases currently take up and I like to make sure that there is a little more. I have 22GB free and 9GB of data to upgrade.

The second is the usual "yes, I am not a dumb ass and I have taken a backup" checkbox. At this point… go validate that you have a backup! Then check the box…

![clip_image005](images/clip_image005-5-5.png "clip_image005")
{ .post-img }

As a security precaution the TFS server will always ask you to enter your credentials again for the TFS Service account. Have them handy.

![clip_image006](images/clip_image006-6-6.png "clip_image006")
{ .post-img }

The TFS Cache folder defaults to the C drive and you may want to stick it somewhere else. This is not a speed issue, but one of space.

![clip_image007](images/clip_image007-7-7.png "clip_image007")
{ .post-img }

By default the build agent bits are put onto the server but it will not configure it. If you want it to be configured you need to tick the box and give it credentials. You also get to set the folder that is used for the temporary build bits.

![clip_image008](images/clip_image008-8-8.png "clip_image008")
{ .post-img }

If you have reporting services configured now this will be ticked by default, if not it will be unticked. If you want to change this, then now is the time to choose.

![clip_image009](images/clip_image009-9-9.png "clip_image009")
{ .post-img }

If you have reporting services pre-configured then you will need to make sure that you account has permission to read the URL's from the WMI interface. Easiest way to achieve this is to have Admin on the Reporting Services instance. This can be controversial as you may have more than one instance in that server, however this is a read only action and permissions can be removed after.

If you need to configure reporting later you can go back a page and NOT configure reporting…

![clip_image010](images/clip_image010-10-10.png "clip_image010")
{ .post-img }

In this case the nice folks in IS gave me temp permission to proceed and all was well in the world again.

![clip_image011](images/clip_image011-11-11.png "clip_image011")
{ .post-img }

AS it might be on a different location you also need to select the location of your warehouse. If necessary the upgrade wizard will upgrader the warehouse rather than rebuild it to save time.

![clip_image012](images/clip_image012-12-12.png "clip_image012")
{ .post-img }

Make sure that you can also access analysis services and have the correct permission to configure things. Should be OK, but always hit the "test" button so that you are sure.

![clip_image013](images/clip_image013-13-13.png "clip_image013")
{ .post-img }

It is very recommended to use a separate account for the report reader account, however in this case I do not have one. TFS lets you use the same service account that it runs under.

![clip_image014](images/clip_image014-14-14.png "clip_image014")
{ .post-img }

If your organisation still has an on-premises SharePoint instance I would highly recommend that you move to Office 365, to be hones I also recommend moving to VSO, and not to integrate with TFS. The value is not worth the pain. I am happy with my current customer, although they are using an on-premises TFS they don’t have on-premises SharePoint.

![clip_image015](images/clip_image015-15-15.png "clip_image015")
{ .post-img }

You can review your configuration before you move forward with the verification. Once you are happy click verify…

![clip_image016](images/clip_image016-16-16.png "clip_image016")
{ .post-img }

My customer has a custom configuration in TFS that is not really recommended ort supported. They have created a custom website in IIS that allows them to have TFS on port 80. TFS is by default installed on port 8080 and in a virtual directory as SharePoint normally exists on the box and coexisting with it is hard. As we don’t have SharePoint this configuration is fine, but non-standard. If you have this configuration you will have to manually undo it for every upgrade and redo it after…

![clip_image017](images/clip_image017-17-17.png "clip_image017")
{ .post-img }

Once you have corrected the IIS configuration the errors disappear and you will almost always have some sort of warning. Here the cache folder is not considered big enough, ok… and as we know the Reporting account is the same as the TFS Service one…ok… and Analysis Services is not set to start automatically… I will talk to IS later for that one… so no show stoppers…

![clip_image018](images/clip_image018-18-18.png "clip_image018")
{ .post-img }

Time to configure.. If you hit the configuration button it will start the real upgrade. At this point there is no way back apart from a database restore, which is why you have to have a backup.

![clip_image019](images/clip_image019-19-19.png "clip_image019")
{ .post-img }

Once it gets to the collection the UI will show a huge number of steps (608) and each of the areas in the DB as they are upgraded. You can either sit and watch it or click close and wait.

![clip_image020](images/clip_image020-20-20.png "clip_image020")
{ .post-img }

Once done you will get a lovely green tick and then be able to view the upgraded TFS. In my case this erred out due to the non-standard configuration of the original TFS server and I had to manually create the TFS site in IIS.

![clip_image021](images/clip_image021-21-21.png "clip_image021")
{ .post-img }

Creating it was easy, it just a cse of copying the OOB IIS and making sure that you add the new Queue application under the root.

## Conclusion

Although TFS 2015 is currently only in RC it does have a Go-Live licence. Go-Live licences are somewhat of a tradition of the Developer Division that allows them to release a fully supported version of the product early so that more folks try it. The reality for CTP's is that no one will really put it through its paces until its supported and can be installed in production. Go-Live enables this..

Go on, be a kid again and install Team Foundation Server 2015 RC in production. Its fully supported and has some awesome new features…


