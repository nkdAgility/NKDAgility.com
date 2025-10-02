---
title: Working With Us – Communication & Security Setup
short_title: Communication & Security Setup
description: To collaborate effectively with NKD Agility, please follow these steps to configure Microsoft Entra ID and Microsoft Teams for secure communication and device compliance.
ItemType: company
ItemKind: marketing
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

Our consultants work with multiple clients and operate from NKD Agility-managed systems wherever possible. This approach maintains high security and compliance standards while enabling efficient value delivery across customers. We use Microsoft 365 with a central calendar booking system as the single source of truth for scheduling, with delegated email access for administrative staff where required.

Using customer-provided email accounts or calendars creates scheduling conflicts and unnecessary friction. Our priority is for consultants to focus on delivering value, not managing multiple accounts. Therefore, we do not use customer-provided email accounts or calendars.

We prefer Microsoft Entra ID Guest accounts for collaboration. Where on-premises Active Directory (AD) access is unavoidable, we recommend creating AD accounts for our consultants without mailboxes and granting only the minimum permissions. Guest accounts in Entra ID should be the default, with AD accounts used only in limited cases.

## 1. Configure Cross-Tenant Access in Microsoft Entra ID

Cross-Tenant Access enables secure collaboration between your organisation and NKD Agility for Teams communication, Shared Channels, and device/MFA compliance.

1. Sign in to the [Microsoft Entra admin center](https://entra.microsoft.com/) with admin rights.
2. Navigate to **External Identities > Cross-tenant access settings > Organizational settings**.
3. Add `nkdagility.com` as an organisation.
4. Configure:
   - **Inbound Access** (NKD Agility → Your Organisation):
     - Allow access for all NKD Agility users/groups or specify object IDs.
     - Allow required applications such as Microsoft Teams.
     - Optionally trust MFA and device compliance.
     - Enable B2B direct connect for shared channels if needed.

   - **Outbound Access** (Your Organisation → NKD Agility):
     - Allow access for relevant users/groups.
     - Allow required applications.
     - Enable B2B direct connect for shared channels.

5. Save settings.

[Microsoft Learn: Cross-tenant access configuration](https://learn.microsoft.com/en-us/entra/external-id/cross-tenant-access-settings-b2b-collaboration)

## 1.2 Microsoft Teams Domain Access

If your Teams access is restricted by domain, allow `nkdagility.com`:

1. Sign in to the [Microsoft Teams admin center](https://admin.teams.microsoft.com/).
2. Go to **Users > External access**.
3. Choose **Allow only specific external domains**.
4. Add `nkdagility.com`.
5. Save changes.

[Microsoft Learn: Manage external access in Microsoft Teams](https://learn.microsoft.com/en-us/microsoftteams/trusted-organizations-external-meetings-chat)

## 1.3 Security & Device Compliance

All NKD Agility systems are Microsoft Entra domain-joined and have:

- Enforced encryption
- Automatic updates
- Security policy enforcement
- Antivirus protection

If you require device compliance or MFA for guest access, ensure Cross-Tenant Access settings:

- Include `nkdagility.com` in trusted organisations.
- Trust NKD Agility Conditional Access policies.

## 1.4 Using Microsoft Teams Shared Channels (Teams Connect)

Shared Channels let you collaborate in a single channel without adding full Guest accounts or making users switch tenants.

**When to choose:**

- Shared Channel: Limited collaboration space (files/chat/meetings) with specific NKD Agility consultants.
- Guest Access: Broader access across multiple channels in a Team.

**Prerequisites:**

- Cross-tenant access configured for `nkdagility.com` with B2B direct connect allowed.
- No block on `nkdagility.com` in Teams external access or shared channel policies.
- Teams policies allowing channel owners to create shared channels and invite external people.

**If you host the Shared Channel:**

1. Verify Teams policy allows shared channel creation and external invitations.
2. Ensure `nkdagility.com` is allowed in external access.
3. (Optional) Restrict policy to specific owners.
4. In Teams:
   - Go to (or create) the Team.
   - Add channel > Shared.
   - Share channel with people/teams/organisations.
   - Enter consultant email and assign role.

5. NKD Agility user will see the channel under “Shared with me” without tenant switching.

**If NKD Agility hosts:**

- Only B2B direct connect settings are required. Channel will appear automatically when shared.

**Troubleshooting:**

- Invite failure: Check B2B direct connect settings.
- Channel not visible: Sign out/in or use Teams web client.
- Policy blocked: Verify Teams policy permissions.
- Conditional Access loop: Enable trust of NKD Agility MFA/device claims.

## 2. Testing the Setup

After configuration:

- Test Teams chat/call between your users and `nkdagility.com`.
- Confirm shared channel access or guest access as configured.
- Verify MFA or compliance checks as required.
