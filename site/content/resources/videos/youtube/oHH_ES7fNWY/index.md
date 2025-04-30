---
title: 'Mastering Email Notifications in Release Management: A Step-by-Step Guide to Configuring Office 365 SMTP'
description: Master the art of configuring email notifications in your release management system with Office 365. Follow our step-by-step guide for seamless setup!
date: 2014-01-02T15:58:51Z
weight: 1000
ResourceId: oHH_ES7fNWY
ResourceType: videos
ResourceContentOrigin: AI
ResourceImport: true
ResourceImportSource: Youtube
videoId: oHH_ES7fNWY
url: /resources/videos/:slug
slug: mastering-email-notifications-in-release-management-a-step-by-step-guide-to-configuring-office-365-smtp
layout: video
aliases:
- /resources/oHH_ES7fNWY
aliasesArchive:
- /resources/videos/sending-email-from-office-for-tfs-
- /resources/videos/sending-email-from-office-365-for-tfs-2013
- /resources/sending-email-from-office-365-for-tfs-2013
- /resources/videos/mastering-email-notifications-in-release-management-a-step-by-step-guide-to-configuring-office-365-smtp
- mastering-email-notifications-in-release-management-a-step-by-step-guide-to-configuring-office-365-smtp
preview: https://i.ytimg.com/vi/oHH_ES7fNWY/maxresdefault.jpg
duration: 145
isShort: false
tags:
- System Configuration
- Install and Configuration
sitemap:
  filename: sitemap.xml
  priority: 0.6
source: youtube
resourceTypes:
- video
categories: []

---
As I dive into the intricacies of configuring a release management system, I want to share my experience with setting up email notifications using Office 365. This process can seem daunting at first, but with a little guidance, you’ll find it’s quite straightforward. Let’s break it down step by step.

### Configuring SMTP for Release Management

1. **Accessing Release Management**: 
   - Start by opening your release management tool. 
   - Navigate to the **Administration** section and select **Settings** at the bottom of the menu. 

2. **SMTP Server Configuration**:
   - Here, you’ll find various configuration options. The key area we’re focusing on is the **SMTP server configuration**.
   - For Office 365, you’ll want to set your SMTP server to `outlook.office365.com` and use **Port 995**. 

3. **Entering Your Credentials**:
   - Input your username and password. It’s crucial to ensure that the sender address you’re using is authorised to send emails. For instance, I use `martin@nn.com`, which is set up correctly in my organisation.

4. **Creating a Generic Mailbox**:
   - While you can use your personal email, I recommend setting up a dedicated mailbox for this purpose. This approach not only keeps things organised but also makes it easier for your team to manage notifications.

### Finding Your Account Details

Now, you might be wondering where to find the necessary account details for this configuration. Here’s how to do it:

1. **Log into Office 365**:
   - Open your browser and head to `office.microsoft.com`. Sign in with your organisational account.

2. **Accessing Outlook Settings**:
   - Once logged in, navigate to the **Outlook app**. 
   - Click on the **Cog** icon (settings) and scroll down to **Options**.

3. **POP and IMAP Access**:
   - In the options menu, scroll to the bottom to find settings for **POP or IMAP access**. 
   - Click on this option to reveal your connection details, which you’ll use to complete your release management configuration.

### Final Thoughts

Configuring your release management system to send emails via Office 365 doesn’t have to be a complex task. By following these steps, you can ensure that your notifications are set up correctly, allowing for seamless communication within your team. 

Remember, the key to effective release management is not just about the tools you use, but also about how you configure them to meet your team’s needs. If you have any questions or need further assistance, feel free to reach out. Happy configuring!
