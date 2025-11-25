---
title: "Unlocking TFS: Mastering Permissions for Seamless Team Collaboration"
description: Learn how to configure Team Foundation Server (TFS) permissions and access levels to enable full feature access and improve team collaboration and project management.
date: 2014-01-15T14:55:37Z
lastmod: 2014-01-15T14:55:37Z
weight: 1000
sitemap:
  filename: sitemap.xml
  priority: 0.1
  changefreq: monthly
ItemId: KRC89A7RtrM
ItemType: videos
ItemKind: resource
ItemContentOrigin: AI
slug: unlocking-tfs-mastering-permissions-for-seamless-team-collaboration
aliases:
  - /resources/KRC89A7RtrM
aliasesArchive:
  - /resources/videos/some-of-the-features-of-team-web-access-are-not-available-to-you-in-tfs-
  - /resources/videos/some-of-the-features-of-team-web-access-are-not-available-to-you-in-tfs-2013
  - /resources/some-of-the-features-of-team-web-access-are-not-available-to-you-in-tfs-2013
  - /resources/videos/unlocking-tfs-mastering-permissions-for-seamless-team-collaboration
  - unlocking-tfs-mastering-permissions-for-seamless-team-collaboration
source: youtube
layout: video
concepts: []
categories:
  - Uncategorized
tags: []
Watermarks:
  description: 2025-05-12T14:22:31Z
ResourceId: KRC89A7RtrM
ResourceType: videos
ResourceImportSource: Youtube
videoId: KRC89A7RtrM
url: /resources/videos/:slug
preview: https://i.ytimg.com/vi/KRC89A7RtrM/maxresdefault.jpg
duration: 164
resourceTypes:
  - video
isShort: false
---

When I first opened Team Foundation Server (TFS), I encountered a common hurdle that many users face: a message indicating that some features of Team Web Access were not visible to me. Initially, I was directed to an MSDN article that promised a solution, but I quickly realised that the fix was much simpler than it seemed. The key? Having the right administrative access on the TFS server, not just on the collection, but on the entire server itself.

### Navigating TFS Permissions

To resolve this issue, I found that the first step was to access the administration settings. Here’s how you can do it:

1. **Access the Admin Settings**: Click on the little cog icon in the top right corner of your TFS interface. This will take you to the administration section.
2. **Control Panel Navigation**: From there, navigate all the way up to the Control Panel view. Here, you’ll find an **Access Levels** tab.

3. **Configure User Permissions**: In the Access Levels section, you can configure which users have permission to access various features based on their licensing level.

### Understanding Access Levels

TFS offers several access levels, each with its own set of permissions:

- **Limited Access**: This level allows users to view their work items without needing a Client Access License (CAL). It’s a basic level of access that’s great for users who only need to see their tasks.

- **Standard Access**: This is the default access level, which requires a CAL. Users in this group can view all standard features, including:
  - Work item views
  - Agile boards
  - Backlog and sprint planning tools
  - Chart viewing capabilities

- **Full Access**: For those who need comprehensive features, the Full Access level is essential. This includes:
  - Agile portfolio tools
  - Team rooms
  - Test case management

However, to access these features, you must have one of the higher-level CALs, such as Test Professional with MSDN, Premium with MSDN, or Ultimate with MSDN.

### Setting Default Access Levels

In my case, since everyone accessing my local server had the Ultimate level, I was able to set this as the default access level. After making this change, I simply refreshed my TFS server, and voilà! The extra features appeared, including:

- Request feedback options
- Enhanced backlog views with agile portfolio management features
- A dedicated test tab for additional functionalities

### Conclusion

Configuring permissions in TFS can seem daunting at first, but with the right administrative access and understanding of the access levels, it becomes a straightforward process. By ensuring that your team has the appropriate access, you can unlock the full potential of TFS and streamline your project management efforts.

If you find yourself struggling with TFS permissions, remember that the solution often lies in the details of your access levels. Don’t hesitate to reach out to your TFS administrator for assistance, and soon enough, you’ll be navigating the platform with ease.
