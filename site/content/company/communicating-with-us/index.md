---
title: Communicating with Us
description: naked Agility Partnership Communications
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
headline:
  cards: []
  title: Communicating with Us
  content: Transform your organisation with engineering excellence and technical leadership through DevOps, Agile, Scrum, and Kanban. Empower teams to innovate, adapt, and deliver lasting value with clear goals and continuous feedback. Consistently. Reliably. Effectively.
---

We use Microsoft Teams for all our communications. If you are a client or partner of naked Agility we want you and your people to be able to communicate with us easily. We have a few simple steps to ensure that you can communicate with us effectively as may IT departments lock down Teams communication to only allow communication with known domains.

To facilitate seamless two-way communication between your organisation and nkdagility.com, please follow the steps outlined below.

**1. Configuring Microsoft Teams to Allow External Communication**

To enable your users to communicate with nkdagility.com via Microsoft Teams, adjust the external access settings as follows:

- **Access the Teams Admin Center**:

  - Navigate to the [Microsoft Teams admin center](https://admin.teams.microsoft.com/).
  - Ensure you have the necessary administrative privileges.

- **Modify External Access Settings**:
  - In the left-hand navigation pane, select **Users** > **External access**.
  - Under **Choose which domains your users have access to**, select **Allow only specific external domains**.
  - Click on **Add a domain** and enter `nkdagility.com`.
  - Click **Done**, then **Save** to apply the changes.

This configuration ensures that your users can communicate with users from nkdagility.com.

[Microsoft Learn: Manage external access in Microsoft Teams](https://learn.microsoft.com/en-us/microsoftteams/trusted-organizations-external-meetings-chat)

**2. Configuring Microsoft Entra ID (Azure Active Directory) for Cross-Tenant Access**

To establish a trusted relationship between your organisation and nkdagility.com, configure cross-tenant access settings in Microsoft Entra ID:

- **Access the Microsoft Entra Admin Center**:

  - Navigate to the [Microsoft Entra admin center](https://entra.microsoft.com/).
  - Ensure you have the necessary administrative privileges.

- **Add nkdagility.com as an External Organisation**:

  - In the left-hand navigation pane, select **External Identities** > **Cross-tenant access settings**.
  - Go to the **Organizational settings** tab and click on **Add organization**.
  - Enter `nkdagility.com` and select the organisation from the search results.
  - Click **Add** to include nkdagility.com in your list of external organisations.

- **Configure Inbound Access Settings**:

  - Select nkdagility.com from your list of external organisations.
  - Under **Inbound access**, select **B2B collaboration** and choose **Customize settings**.
  - In the **External users and groups** section, select **Allow access** and specify the users or groups from nkdagility.com permitted to access your resources.
    - **For most organisations**: It's perfectly safe to select "All naked Agility with Martin Hinshelwood users and groups" as the B2B collaboration does not give users in the configured tenant any permissions to access data, only to message those in your organisation via Teams.
    - **For companies with stringent security requirements**: You can specify individual users by their object ID. Martin Hinshelwood's object ID is: `ea9573be-3654-4a29-8abd-43d300baa351`
  - In the **Applications** section, select **Allow access** and specify the applications (e.g., Microsoft Teams) that these external users can access.
  - Click **Save** to apply the inbound settings.

- **Configure Outbound Access Settings**:
  - Under **Outbound access**, select **B2B collaboration** and choose **Customize settings**.
  - In the **Users and groups** section, select **Allow access** and specify the internal users or groups permitted to access nkdagility.com's resources.
  - In the **Applications** section, select **Allow access** and specify the applications that your users can access in nkdagility.com.
  - Click **Save** to apply the outbound settings.

These configurations establish a controlled and secure collaboration environment between your organisation and nkdagility.com.

[Microsoft Learn: Configure cross-tenant access settings in Azure Active Directory](https://learn.microsoft.com/en-us/entra/external-id/cross-tenant-access-settings-b2b-collaboration)

**3. Testing the Configuration**

After completing the above configurations, it's advisable to test the setup:

- Initiate a chat or call between users from your organisation and nkdagility.com to confirm that communication is functioning as intended.

By following these steps, you will enable secure and efficient two-way communication between your organisation and nkdagility.com.
