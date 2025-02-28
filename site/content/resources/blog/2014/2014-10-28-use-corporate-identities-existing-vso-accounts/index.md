---
title: Use corporate identities with existing VSO accounts
description: Learn how to configure ADFS for seamless SSO with existing VSO accounts, ensuring continuity and easy access to Azure and Office 365. Get started now!
ResourceId: yIJgOpFCdJE
ResourceType: blog
ResourceImport: true
ResourceImportId: 10797
ResourceImportSource: Wordpress
ResourceImportOriginalSource: Wordpress
date: 2014-10-28
weight: 1000
creator: Martin Hinshelwood
layout: blog
resourceTypes: blog
slug: use-corporate-identities-existing-vso-accounts
aliases:
- /blog/use-corporate-identities-existing-vso-accounts
- /use-corporate-identities-existing-vso-accounts
- /use-corporate-identities-with-existing-vso-accounts
- /blog/use-corporate-identities-with-existing-vso-accounts
- /resources/yIJgOpFCdJE
- /resources/blog/use-corporate-identities-existing-vso-accounts
aliasesArchive:
- /blog/use-corporate-identities-existing-vso-accounts
- /use-corporate-identities-existing-vso-accounts
- /use-corporate-identities-with-existing-vso-accounts
- /blog/use-corporate-identities-with-existing-vso-accounts
- /resources/blog/use-corporate-identities-existing-vso-accounts
tags:
- Windows
- Install and Configuration
- Practical Techniques and Tooling
- Azure DevOps
- System Configuration
- Troubleshooting
categories:
- DevOps
preview: nakedalm-experts-visual-studio-alm-11-11.png

---
If you configure Active Directory Federated Services (ADFS) you can use corporate identities with existing VSO accounts. Link to your internal domain and you can get a completely seamless Single-Sign-on from your local network to the cloud for Office 365, SharePoint Online, and now Visual Studio Online (VSO).

I have Office 365 and now that I am starting to use Azure (I have training this week), I am running into the usual authentication issue as I do not have a "single-sign-on" but instead have two. I have a Microsoft ID (martin@nakedalm.com) and an OrgId (martin@nakedalm.com) and I am getting clashes. I get a little more as they both have the same name, but for VSO this is becoming a pain and I need to switch my VSO over to OrgID. This is actually a trivial task, but you want to make sure you have continuity.

#### Warning

Your Microsoft ID (was Live ID) mush match your corporate ID to be able to maintain history. Without this VSO will treat you as a new user.

#### Label

Not only can you [use multiple email alias with your existing Microsoft ID](http://nkdagility.com/using-multiple-email-alias-existing-microsoft-id/) but you can consolidate accounts. This allows you to associate your work account with your existing identity, and to migrate an existing work account over. It does take 30 days to do the migration though.

![clip_image001](images/clip-image0014-1-1.png "clip_image001")
{ .post-img }

If you log into your Azure with your OrgId you should see your Active Directory configuration listed. This was created by the Office 365 folks if you are on a more small scale service like me, or it may be integrated with your local Active Directory.

![clip_image002](images/clip-image0024-2-2.png "clip_image002")
{ .post-img }

If you select "Active Directory | \[Your Directory\] | Users" you should see a list of all of the users that have been configured for access. You will need to add future users of VSO here and then specifically licence them on VSO. You can however add both your own domain accounts and you can add foreign principals.

#### Note

Foreign principals is a feature within the control of your AD administrators

The foreign principals feature allows you to add accounts from other directories as well as Microsoft ID's to give them access. I have a feeling that this will go a long way to enabling my long requested feature of being able to have single-sign-on across organisations for consultants and contractors. Can you imagine being able to go onsite at a customer and just use your existing Windows Login to access their network. Awesome….

![clip_image003](images/clip-image0034-3-3.png "clip_image003")
{ .post-img }

In this case you should head over to the users tab in Visual Studio Online and make sure that each of the users there has an account created in your AD. There is no simple way to do this, but if you select a user with your mouse and Ctrl+C you get a two row table, with headers, that you can paste into notepad and extract the bits that you want. Namely, name and email address. This really needs an export option.

<table class="table table-condensed"><tbody><tr><td>FROM</td><td>TO</td><td>EXAMPLE FROM :</td><td><p>EXAMPLE TO:</p></td><td><p>HISTORY PRESERVED</p></td></tr><tr><td><p>Microsoft Account A</p></td><td><p>Microsoft Account Foreign Principal A</p></td><td><p>Windows Live\john@live.com</p></td><td><p>contoso\john@live.com</p></td><td>Yes</td></tr><tr><td><p>Microsoft Account B</p></td><td><p>OrgID B</p></td><td><p>Windows Live\john@contoso.com</p></td><td><p>contoso\john@contoso.com</p></td><td>Yes</td></tr><tr><td>Microsoft Account A</td><td><p>OrgID B</p></td><td><p>Windows Live\john@live.com</p></td><td>contoso\john@contoso.com</td><td>No</td></tr></tbody></table>

Now, here you may want to pause and give users the [30 days needed to consolidate Microsoft ID's](http://nkdagility.com/using-multiple-email-alias-existing-microsoft-id/) before moving ahead so that they can maintain continuity. For big corporations this could be a pain and you may choose to forgo, but for smaller shops it is a must. Get your users to add their corporate email as an alias to their existing Microsoft ID (yes, the one they use to log into Xbox and Outlook.com). They should then switch the primary email to their corporate one (they can change it back later) so that VSO will update all of the data to their OrgId when you move over.

#### Note

This is a one time shot. Here are no do-overs and if folks mess it us they are done. You should see a list of corporate ID's above when done.

#### Warning

if Users already have two live ID's and use their personal one to log in it can take 30 days to migrate the corporate email over. There is a 30 days cooling off period after deleting an account before the email can be used again.

That done you can now go ahead and link your VSO account to your Azure account. You can [reuse your MSDN benefits with your Org ID](http://nkdagility.com/reuse-msdn-benefits-org-id/) even if you have already configured it but you need to cancel the subscription first.

## Linking your VSO account to your Azure Account

Now that you have configured your Active Directory you need to Link your existing VSO account to your Azure account before we can configure anything.

![clip_image004](images/clip-image0043-4-4.png "clip_image004")
{ .post-img }

If you head to the "Visual Studio Online" node in Azure you should see a "Create or Link to a Visual Studio Online Account". If you don’t have one then this is the time to create one. However I already have a VSO account that I created way back when this was TFS Preview. If you select your VSO account from the populated list and make sure you associate it with your MSDN benefits Subscription.

![clip_image005](images/clip-image0053-5-5.png "clip_image005")
{ .post-img }

You should now see your new or existing VSO account listed above. It is now possible to enable unlimited build and to integrate with the Azure Active Directory service. If you don’t see the one you want you can click “Add” at the bottom of the screen and you will be asked to Add or associate.

![clip_image006](images/clip-image0063-6-6.png "clip_image006")
{ .post-img }

Select the account that you want to integrate and go to the "Configure" tab. Here you can connect to the appropriate AAD. At this point you should make sure that you have added all of the accounts that you want to continue to have access. Anyone that is not a foreign principal or an actual AD account will not have access after this. Easy to fix later, but you need to know why they don’t have access.

![clip_image007](images/clip-image0072-7-7.png "clip_image007")
{ .post-img }

I am linking directly into my AAD created for Office 365 and creating a seamless integration across the board. Once you click the tick Microsoft will go off and convert your VSO to an AAD integrated one.

![clip_image008](images/clip-image0082-8-8.png "clip_image008")
{ .post-img }

If you now hit your account you will get automatically signed out of your Microsoft ID (MSA) and presented with the Login Screen.

![clip_image009](images/clip-image0092-9-9.png "clip_image009")
{ .post-img }

Here you should pick your Organisational ID to now login with. You may get a screen saying that it failed on the logout. If this ins the case try just hitting your account again. Sometimes it did work, just MSA getting a little confused. If not go to [http://accounts.live.com](http://accounts.live.com) and actually logout. That should do it…

![clip_image010](images/clip-image0102-10-10.png "clip_image010")
{ .post-img }

VSO now identifies me as my Organisational ID and not my Microsoft ID (MSA).  Now my account has been migrated. Just as it would be if you [run the change identities command](http://nkdagility.com/batched-domain-migration-with-tfs-while-maintaining-identity/) from TFS.

## Conclusion

If you configure Active Directory Federated Services (ADFS) to link to your internal domain you can get a completely seamless Single-Sign-on from your local network to the cloud. While there is a little extra configuration to get true SSO internally this is a big step towards truly unique and trusted identities across all of your platforms.

Now if only, for Threshold (Windows 10) Microsoft would allow me to join my computers directly to my Azure Active Directory (AAD) domain I will be a happy man.
