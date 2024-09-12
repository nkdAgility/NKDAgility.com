---
id: "11944"
title: "VSTS Sync Migration Tool Update and Bugfix"
date: "2017-06-21"
categories: 
  - "devops"
tags: 
  - "migration"
  - "sync"
  - "tfs"
  - "vsts"
coverImage: "nkdagility-martin-hinshelwood-vsts-sync-migration-1-1.png"
author: "MrHinsh"
type: "post"
slug: "vsts-sync-migration-tool-update-bugfix"
---

The [VSTS Sync Migration tools](https://marketplace.visualstudio.com/items?itemName=nkdagility.vsts-sync-migration) have been updated with new features and bug fixes for common issues reported by users.

[![Chocolatey](https://camo.githubusercontent.com/30eda87c074e892c7b2126ffd0e6b1d3da7f710d/68747470733a2f2f696d672e736869656c64732e696f2f63686f636f6c617465792f762f767374732d73796e632d6d69677261746f722e737667)](https://chocolatey.org/packages/vsts-sync-migrator/)

For those that are using TFS and VSTS since the demise of the TFS Integration Tools there has been a gap that has only been filled by commercial tools. For a while I have been shipping the [VSTS Sync Migration tool](https://marketplace.visualstudio.com/items?itemName=nkdagility.vsts-sync-migration) as a stop gap measure until more features are available out of the box. If you are looking to:

- Bulk update thousands of work items with regex pattern matches, and other field mappings.
- Migrate a partial or entire Team Project from one location to another, Collection, Account, or Server
- Merge two or more Team Projects that should not have been separated

We have also had a number of awesome contributions from the community of users that have been using this tool to push work items around…and that has resulted in a number of new features in the last few months:

- **Work Item History** – Now you can migrate revisions as well as just the tip with the new **WorkItemRevisionReplayMigrationContext**  \[[Harald Koestinger](https://github.com/hkoestin)\]
- **Query Migration** - Migrate you Work Item Queries from one Team Project to another with the **WorkItemQueryMigrationContext** \[[Richard Fennell](https://github.com/rfennell)\]
- **Closed Date on Tasks** – Fixed a serious bug with the Closed Date that has been blocking a number of users \[[Darryl James Heath](https://github.com/darryljamesheath)\]
- **Update Notification** – When a new version is published through our automated DevOps pipeline you will be notified when you run the tool.

We are working on the documentation, and folks struggle with the concept of the ReflectedWorkItemId that we use for tracking what you have already processed. Hopefully we can make some changes to fix this in the future.

[![Chocolatey](https://camo.githubusercontent.com/30eda87c074e892c7b2126ffd0e6b1d3da7f710d/68747470733a2f2f696d672e736869656c64732e696f2f63686f636f6c617465792f762f767374732d73796e632d6d69677261746f722e737667)](https://chocolatey.org/packages/vsts-sync-migrator/)

Install the latest version from chocolate and have it notify you when a new version comes out.

