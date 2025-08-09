---
title: Working With Us – Communication & Security Setup
short_title: Communication & Security Setup
description: To collaborate effectively with NKD Agility, please follow these steps to configure Microsoft Entra ID and Microsoft Teams for secure communication and device compliance.
menus:
  footer:
    - params:
        class: center
      parent: Consulting Services
      pre: <i class="fa-solid fa-code"></i>
      weight: 20
layout: informational
aliases:
  - /communicate/
  - /company/communicating-with-us/
headline:
  cards: []
  title: Communication & Security Setup
  content: To collaborate effectively with NKD Agility, please follow these steps to configure Microsoft Entra ID and Microsoft Teams for secure communication and device compliance.
---

Our consultants work with multiple clients and operate from NKD Agility–managed systems wherever possible. This approach allows us to maintain high security and compliance standards while delivering value efficiently across all customers. We use Microsoft 365 with a central calendar booking system as our single source of truth for scheduling, along with delegated email accounts accessible to administrative staff when required.

Using customer-provided email accounts or calendars introduces scheduling conflicts and unnecessary friction. Our priority is for consultants to focus on delivering value, not managing multiple calendars and email systems. Therefore, we do not use customer-provided email accounts or calendars.

We prefer to use Microsoft Entra ID Guest accounts for collaboration. However, in some situations, access to your on-premises Active Directory (AD) may be required. In these cases, we recommend creating AD accounts for our consultants without a mailbox and granting only the minimum necessary permissions. Where possible, Guest accounts in Entra ID should be used for all access needs, with AD accounts reserved solely for limited, unavoidable scenarios.

To collaborate effectively and securely, please follow the steps below.

## 1. Configure Cross-Tenant Access in Microsoft Entra ID

Setting up Cross-Tenant Access ensures trusted, secure collaboration between your organisation and NKD Agility, covering both Microsoft Teams communication and device/MFA compliance.

1. Sign in to the [Microsoft Entra admin center](https://entra.microsoft.com/) with administrative privileges.

2. Go to **External Identities > Cross-tenant access settings > Organizational settings**.

3. Click **Add organization**, enter `nkdagility.com`, and select the matching result.

4. Once added, configure the following:

   **Inbound Access** (NKD Agility → Your Organisation)
   - Under **B2B collaboration**, select **Customize settings**.
   - In **External users and groups**, select **Allow access**.
     - Recommended: “All naked Agility with Martin Hinshelwood users and groups” (safe default).
     - Higher security: specify individual object IDs. Martin Hinshelwood’s ID is `ea9573be-3654-4a29-8abd-43d300baa351`.

   - In **Applications**, select **Allow access** and include **Microsoft Teams** (and any other required apps).
   - Optionally, **trust MFA** and **device compliance** claims to reduce sign-in friction.

   **Outbound Access** (Your Organisation → NKD Agility)
   - Under **B2B collaboration**, select **Customize settings**.
   - Allow the relevant users/groups.
   - Allow required applications (e.g., Microsoft Teams).

5. Click **Save** to apply all settings.

[Microsoft Learn: Cross-tenant access configuration](https://learn.microsoft.com/en-us/entra/external-id/cross-tenant-access-settings-b2b-collaboration)

---

## 1.2 Collaborating Seamlessly via Microsoft Teams

Some IT departments restrict Teams communication to specific domains. If you do, please allow `nkdagility.com` so your users can chat and meet with our team.

1. Sign in to the [Microsoft Teams admin center](https://admin.teams.microsoft.com/) with admin rights.
2. Go to **Users > External access**.
3. Under **Choose which domains your users have access to**, select **Allow only specific external domains**.
4. Add `nkdagility.com`.
5. Click **Done**, then **Save**.

[Microsoft Learn: Manage external access in Microsoft Teams](https://learn.microsoft.com/en-us/microsoftteams/trusted-organizations-external-meetings-chat)

---

## 1.3 Security & Device Compliance

All NKD Agility systems are **Microsoft Entra domain-joined** with:

- Enforced encryption
- Automatic updates
- Security policy enforcement
- Antivirus protection

If you require device compliance or MFA for guest access to your cloud applications, the Cross-Tenant Access configuration in **Step 1** should:

- Include our domain in your trusted organisations.
- Trust NKD Agility’s **Conditional Access policies** for guest users across all relevant cloud apps.

This ensures secure access while allowing our consultants to work efficiently.

---

## 2. Testing the Setup

After completing the steps:

- Initiate a Microsoft Teams chat or call between a user in your organisation and a user in `nkdagility.com`.
- Confirm that messages and calls work in both directions.
- Verify that any required MFA or compliance checks function as expected.
