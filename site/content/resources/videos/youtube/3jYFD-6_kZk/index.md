---
title: Navigating the Complex World of Azure DevOps Data Migration
short_title: Azure DevOps Data Migration Guide
description: Learn key steps, common pitfalls, and best practices for migrating data from legacy TFS systems to Azure DevOps, including identity alignment, database cleanup, and backups.
tldr: Migrating to Azure DevOps is complex, especially with legacy systems, but careful planning and attention to detail can prevent most issues. Key steps include importing legacy data before upgrades, aligning user identities to avoid workflow disruptions, cleaning up databases to meet size limits, and strictly following Microsoft’s backup procedures. Development managers should prioritize preparation and sequencing to ensure a smooth migration and minimize risks.
date: 2024-07-31T12:00:49Z
lastmod: 2024-07-31T12:00:49Z
weight: 690
sitemap:
  filename: sitemap.xml
  priority: 0.1
  changefreq: monthly
ResourceId: 3jYFD-6_kZk
ResourceImport: true
ResourceType: videos
ResourceContentOrigin: AI
ResourceImportSource: Youtube
slug: navigating-the-complex-world-of-azure-devops-data-migration
aliases:
  - /resources/3jYFD-6_kZk
  - /resources/videos/navigating-the-complex-world-of-azure-devops-data-migration
  - /resources/videos/what-can-go-wrong-and-what-can-go-right-with-a-migration-via-azure-devops
aliasesArchive:
  - /resources/videos/navigating-the-complex-world-of-azure-devops-data-migration
  - /resources/navigating-the-complex-world-of-azure-devops-data-migration
  - /resources/videos/what-can-go-wrong-and-what-can-go-right-with-a-migration-via-azure-devops
  - /resources/what-can-go-wrong-and-what-can-go-right-with-a-migration-via-azure-devops
  - navigating-the-complex-world-of-azure-devops-data-migration
source: internal
layout: video
concepts: []
categories:
  - DevOps
tags:
  - Azure DevOps
  - Software Development
  - Troubleshooting
  - Pragmatic Thinking
  - Install and Configuration
Watermarks:
  description: 2025-05-07T13:02:21Z
  short_title: 2025-07-07T17:48:47Z
  tldr: 2025-08-07T12:50:21Z
videoId: 3jYFD-6_kZk
url: /resources/videos/:slug
preview: https://i.ytimg.com/vi/3jYFD-6_kZk/maxresdefault.jpg
duration: 1055
resourceTypes:
  - video
isShort: false

---
When it comes to migrating data in Azure [DevOps]({{< ref "/categories/devops" >}}), the process can be overwhelming, especially if you're dealing with legacy systems or older versions of Team Foundation Server (TFS). As someone who has been through this many times, I can tell you that there are countless pitfalls, but with careful planning and attention to detail, you can avoid most of them. In this post, I'll share some of the common issues, critical steps, and personal experiences that can help you successfully navigate the complexities of [Azure DevOps]({{< ref "/tags/azure-devops" >}}) data migration.

## **Common Issues with Older TFS Versions**

One of the biggest challenges you'll face when migrating to Azure DevOps is dealing with older versions of TFS. I've encountered situations where clients were still using Visual SourceSafe, a system that went end-of-life in 2005. Before you can even think about upgrading TFS, you need to import any old data from systems like Visual SourceSafe. If you skip this step and upgrade TFS first, you risk losing critical historical data since Visual SourceSafe imports were only supported up to TFS 2015.

**Key Takeaways:**

- **Visual SourceSafe Import:** Ensure you import legacy data before upgrading TFS.

- **Order Matters:** Doing things in the wrong order can lead to irreversible issues.

## **The Importance of Order in Migration**

Order of operations is crucial in any migration process. Whether it's moving from TFVC (Team Foundation Version Control) to Git or making process template changes, the sequence in which you perform these tasks can make or break your migration.

### **What Can Go Wrong?**

- **Process Template Changes:** Make these changes on-premises before pushing to Azure DevOps.

- **Source Control Migration:** Migrate your source control to Git before moving to Azure DevOps.

- **Account Alignment:** The most critical issue is ensuring that identities align correctly during the migration. If not handled properly, users may end up with duplicate identities, leading to confusion and lost work.

**Personal Experience:**

I once worked on a migration where a customer moved from a workgroup environment to a domain-joined environment without proper account alignment. This resulted in users having multiple identities in TFS, leading to a situation where they couldn't find their assigned work because it was linked to their old identity. This issue is not just a technical glitch; it's a workflow nightmare that can severely impact productivity.

## **Critical Identity Alignment**

Identity management is one of the trickiest parts of migrating to Azure DevOps. TFS handles identities in a way that can cause significant issues if not managed correctly.

### **How Does It Work?**

- **TFS Identity Wrapping:** TFS wraps your actual identity (whether a workgroup account or Active Directory account) in its system.

- **Migration Risks:** If your accounts don't match when moving environments, TFS might create a new identity instead of mapping to the existing one. This results in users not being able to see their work assigned to their old identity.

**Case Study: Complex Migration**

In a particularly challenging migration, we had to move a TFS environment from inside Microsoft to another company after a business sale. The process involved seven separate migrations, each with different scripts, validations, and legal requirements. The biggest headache was maintaining identity alignment throughout the entire process. If even one identity didn't map correctly, it could have caused significant issues down the line.

## **Database Size and Cleanup**

Another critical aspect of migration is managing your database size and cleaning up old data. Azure DevOps has limitations on database size, so it's essential to clean up unnecessary data before migrating.

### **What to Watch Out For:**

- **Legacy Systems:** Older TFS versions might have accumulated a lot of "baggage" over the years, including half-committed changes, outdated scripts, and beta versions that were never fully supported.

- **Database Cleanup:** Make sure to clean up your database before attempting the migration. This includes removing obsolete data, fixing old errors, and ensuring everything is in order.

## **Backup Procedures and Disaster Recovery**

Backup procedures are often overlooked, but they are crucial to ensuring a smooth migration. Most operations teams will use standardized backup tools that might not be compatible with TFS or Azure DevOps. This can lead to incomplete backups and, in the worst-case scenario, a failed migration.

### **Best Practices:**

- **Use TFS-Documented Backup Procedures:** Always follow Microsoft's documented procedures for backing up TFS or Azure DevOps. Using non-standard tools can result in incomplete or corrupt backups.

- **Mark Transaction Logs:** Ensure you mark transaction logs across all databases before backing up. This ensures consistency across multiple databases during the backup process.

**Real-World Example:**

In one case, an operations team used their standard SQL Server backup tools for TFS. Unfortunately, this approach didn't account for the complexity of TFS's multiple databases. During a disaster recovery scenario, they were unable to restore the databases properly, leading to significant downtime and the need for Microsoft engineers to intervene.

## **Ensuring Successful Migrations**

Despite the challenges, migrating to Azure DevOps doesn't have to be a nightmare. With the right approach, you can avoid many common pitfalls.

### **Key Steps:**

1. **Plan the Order of Operations:** Ensure you follow the correct sequence for all migration tasks.

3. **Align Identities:** Double-check that all user identities are correctly mapped during the migration.

5. **Clean Up Your Database:** Remove any obsolete or unnecessary data before migrating.

7. **Follow Backup Best Practices:** Use TFS-documented procedures and mark transaction logs.

**Final Thoughts:**

90% of the time, migrations go smoothly if you follow these guidelines. However, when something does go wrong, it often requires deep expertise to fix. The Azure DevOps team has done a great job of making the migration process easier, but there's always a chance that something might slip through the cracks.

## **Conclusion**

Migrating to Azure DevOps can be a daunting task, especially if you're dealing with legacy systems or outdated processes. However, with careful planning, attention to detail, and a thorough understanding of the potential pitfalls, you can ensure a successful migration. Remember, the key is in the preparation: plan your order of operations, align your identities, clean up your database, and always follow best practices for backups. With these steps, you can avoid the common pitfalls and ensure a smooth transition to Azure DevOps. 🚀
