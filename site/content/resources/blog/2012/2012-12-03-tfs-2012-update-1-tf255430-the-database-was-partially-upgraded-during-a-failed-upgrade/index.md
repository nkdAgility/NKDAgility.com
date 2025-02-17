---
title: 'TFS 2012 Update 1 - TF255430: the database was partially upgraded during a failed upgrade'
description: Resolve TFS 2012 Update 1 upgrade issues with expert insights on error TF255430. Learn how to restore your database and ensure a smooth upgrade process.
ResourceId: -IOLGjKhnje
ResourceType: blog
ResourceImport: true
ResourceImportId: 9164
ResourceImportSource: Wordpress
ResourceImportOriginalSource: Wordpress
date: 2012-12-03
creator: Martin Hinshelwood
layout: blog
resourceTypes: blog
slug: tfs-2012-update-1-tf255430-the-database-was-partially-upgraded-during-a-failed-upgrade
aliases:
- /blog/tfs-2012-update-1-tf255430-the-database-was-partially-upgraded-during-a-failed-upgrade
- /tfs-2012-update-1-tf255430-the-database-was-partially-upgraded-during-a-failed-upgrade
- /tfs-2012-update-1
- /tfs-2012-update-1---tf255430--the-database-was-partially-upgraded-during-a-failed-upgrade
- /blog/tfs-2012-update-1---tf255430--the-database-was-partially-upgraded-during-a-failed-upgrade
- /resources/-IOLGjKhnje
- /resources/blog/tfs-2012-update-1-tf255430-the-database-was-partially-upgraded-during-a-failed-upgrade
aliasesFor404:
- /tfs-2012-update-1-tf255430-the-database-was-partially-upgraded-during-a-failed-upgrade
- /blog/tfs-2012-update-1-tf255430-the-database-was-partially-upgraded-during-a-failed-upgrade
- /tfs-2012-update-1---tf255430--the-database-was-partially-upgraded-during-a-failed-upgrade
- /blog/tfs-2012-update-1---tf255430--the-database-was-partially-upgraded-during-a-failed-upgrade
- /tfs-2012-update-1
- /resources/blog/tfs-2012-update-1-tf255430-the-database-was-partially-upgraded-during-a-failed-upgrade
tags:
- Windows
- System Configuration
- Operational Practices
- Technical Mastery
- Troubleshooting
- Release Management
- Software Development
- Pragmatic Thinking
categories:
- Install and Configuration
- Practical Techniques and Tooling
- Azure DevOps
- Technical Excellence
preview: metro-problem-icon-2-2.png

---
You get an error while upgrading Team Foundation Server 2012 to Update 1 with a “TF254027: You must correct all errors before you continue”, “TF255375: the configuration database that you specified cannot be used” and a “TF255430: the database was partially upgraded during a failed upgrade”.

![image](images/image-1-1.png "image")  
{ .post-img }
**Figure: TF255375 and TF255430 configuration database cannot be used due to a failed upgrade**

The result of this is that you have an inaccessible environment until it is either upgraded successfully or restored to the RTM.

### Applies to

- Team Foundation Server 2012
- Team Foundation Server 2012 Update 1

### Findings for TF255430

The only way to figure out what went wrong it to look at the log. You can see the little “Open Log” option in the results and there is also an “Open Log folder” as part of the “Logs” node in the Administration Console.

On examining the logs the first thing that I found was a SQL Server communication error.

```
[Error  @16:22:24.739]
Exception Message: TF246017: Team Foundation Server could not connect to the database. Verify that the server that is hosting the database is operational, and that network problems are not blocking communication with the server. (type DatabaseConnectionException)
Exception Stack Trace:    at Microsoft.TeamFoundation.Framework.Server.TeamFoundationSqlResourceComponent.TranslateException(Int32 errorNumber, SqlException sqlException, SqlError sqlError)
   at Microsoft.TeamFoundation.Framework.Server.TeamFoundationSqlResourceComponent.TranslateException(SqlException sqlException)
   at Microsoft.TeamFoundation.Framework.Server.TeamFoundationSqlResourceComponent.MapException(SqlException ex, QueryExecutionState queryState)
   at Microsoft.TeamFoundation.Framework.Server.TeamFoundationSqlResourceComponent.HandleException(Exception exception)
   at Microsoft.TeamFoundation.Framework.Server.TeamFoundationSqlResourceComponent.Execute(ExecuteType executeType, CommandBehavior behavior)
   at Microsoft.TeamFoundation.Admin.SqlHandler.ExecuteReader(String connectionString, SqlQuery sqlQuery, Action`1 action)
   at Microsoft.TeamFoundation.Admin.SqlHandler.ExecuteReader[T](String connectionString, SqlQuery sqlQuery, Func`2 binder)
   at Microsoft.TeamFoundation.Admin.SqlInstanceHandler.GetUserDatabases(String connectionString)
   at Microsoft.TeamFoundation.Admin.TfsDatabaseFactory.GetDatabases(String connectionString, Func`2 databaseNameFilter)
   at Microsoft.TeamFoundation.Admin.TfsDatabaseFactory.GetUpgradeCandidates(String connectionString)
   at Microsoft.TeamFoundation.Admin.Console.Models.DbPickerControlViewModel.GetDatabases()

Inner Exception Details:

Exception Message: A network-related or instance-specific error occurred while establishing a connection to SQL Server. The server was not found or was not accessible. Verify that the instance name is correct and that SQL Server is configured to allow remote connections. (provider: Named Pipes Provider, error: 40 - Could not open a connection to SQL Server) (type SqlException)
SQL Exception Class: 20
SQL Exception Number: 2
SQL Exception Procedure:
SQL Exception Line Number: 0
SQL Exception Server:
SQL Exception State: 0
SQL Error(s):

Exception Data Dictionary:
HelpLink.ProdName = Microsoft SQL Server
HelpLink.EvtSrc = MSSQLServer
HelpLink.EvtID = 2
HelpLink.LinkId = 20476


Exception Stack Trace:    at System.Data.SqlClient.SqlInternalConnection.OnError(SqlException exception, Boolean breakConnection, Action`1 wrapCloseInAction)
   at System.Data.SqlClient.TdsParser.ThrowExceptionAndWarning(TdsParserStateObject stateObj, Boolean callerHasConnectionLock, Boolean asyncClose)
   at System.Data.SqlClient.TdsParser.Connect(ServerInfo serverInfo, SqlInternalConnectionTds connHandler, Boolean ignoreSniOpenTimeout, Int64 timerExpire, Boolean encrypt, Boolean trustServerCert, Boolean integratedSecurity, Boolean withFailover)
   at System.Data.SqlClient.SqlInternalConnectionTds.AttemptOneLogin(ServerInfo serverInfo, String newPassword, SecureString newSecurePassword, Boolean ignoreSniOpenTimeout, TimeoutTimer timeout, Boolean withFailover)
   at System.Data.SqlClient.SqlInternalConnectionTds.LoginNoFailover(ServerInfo serverInfo, String newPassword, SecureString newSecurePassword, Boolean redirectedUserInstance, SqlConnectionString connectionOptions, SqlCredential credential, TimeoutTimer timeout)
   at System.Data.SqlClient.SqlInternalConnectionTds.OpenLoginEnlist(TimeoutTimer timeout, SqlConnectionString connectionOptions, SqlCredential credential, String newPassword, SecureString newSecurePassword, Boolean redirectedUserInstance)
   at System.Data.SqlClient.SqlInternalConnectionTds..ctor(DbConnectionPoolIdentity identity, SqlConnectionString connectionOptions, SqlCredential credential, Object providerInfo, String newPassword, SecureString newSecurePassword, Boolean redirectedUserInstance, SqlConnectionString userConnectionOptions)
   at System.Data.SqlClient.SqlConnectionFactory.CreateConnection(DbConnectionOptions options, DbConnectionPoolKey poolKey, Object poolGroupProviderInfo, DbConnectionPool pool, DbConnection owningConnection, DbConnectionOptions userOptions)
   at System.Data.ProviderBase.DbConnectionFactory.CreatePooledConnection(DbConnectionPool pool, DbConnectionOptions options, DbConnectionPoolKey poolKey, DbConnectionOptions userOptions)
   at System.Data.ProviderBase.DbConnectionPool.CreateObject(DbConnectionOptions userOptions)
   at System.Data.ProviderBase.DbConnectionPool.UserCreateRequest(DbConnectionOptions userOptions)
   at System.Data.ProviderBase.DbConnectionPool.TryGetConnection(DbConnection owningObject, UInt32 waitForMultipleObjectsTimeout, Boolean allowCreate, Boolean onlyOneCheckConnection, DbConnectionOptions userOptions, DbConnectionInternal&amp; connection)
   at System.Data.ProviderBase.DbConnectionPool.TryGetConnection(DbConnection owningObject, TaskCompletionSource`1 retry, DbConnectionOptions userOptions, DbConnectionInternal&amp; connection)
   at System.Data.ProviderBase.DbConnectionFactory.TryGetConnection(DbConnection owningConnection, TaskCompletionSource`1 retry, DbConnectionOptions userOptions, DbConnectionInternal&amp; connection)
   at System.Data.ProviderBase.DbConnectionClosed.TryOpenConnection(DbConnection outerConnection, DbConnectionFactory connectionFactory, TaskCompletionSource`1 retry, DbConnectionOptions userOptions)
   at System.Data.SqlClient.SqlConnection.TryOpen(TaskCompletionSource`1 retry)
   at System.Data.SqlClient.SqlConnection.Open()
   at Microsoft.TeamFoundation.Framework.Server.TeamFoundationSqlResourceComponent.Execute(ExecuteType executeType, CommandBehavior behavior)

Exception Message: The system cannot find the file specified (type Win32Exception)
```

**Figure: TF246017: Team Foundation Server could not connect to the database.**

This would defiantly cause the upgrade to fail and if it happened half way through the Upgrade of the Configuration database would defiantly result in the messages above. Now, prior to running the upgrade the TFS Upgrade Wizard did check that not only could it connect to SQL Server correctly, but that the accounts in use had the appropriate permissions to perform the update.

The second thing that I found was

```
[Error  @16:18:24.966] TF400670: Error encountered when creating connection to Analysis Services. Contact your Team Foundation Server administrator.
[Info   @16:18:25.060] Microsoft.TeamFoundation.Framework.Server.AnalysisServiceConnectionException: TF400670: Error encountered when creating connection to Analysis Services. Contact your Team Foundation Server administrator. ---> Microsoft.AnalysisServices.ConnectionException: A connection cannot be made. Ensure that the server is running. ---> System.Net.Sockets.SocketException: No connection could be made because the target machine actively refused it 127.0.0.1:2383
   at System.Net.Sockets.TcpClient..ctor(String hostname, Int32 port)
   at Microsoft.AnalysisServices.XmlaClient.GetTcpClient(ConnectionInfo connectionInfo)
   --- End of inner exception stack trace ---
   at Microsoft.AnalysisServices.XmlaClient.GetTcpClient(ConnectionInfo connectionInfo)
   at Microsoft.AnalysisServices.XmlaClient.OpenTcpConnection(ConnectionInfo connectionInfo)
   at Microsoft.AnalysisServices.XmlaClient.Connect(ConnectionInfo connectionInfo, Boolean beginSession)
   at Microsoft.AnalysisServices.Server.Connect(String connectionString, String sessionId)
   at Microsoft.TeamFoundation.Warehouse.AnalysisServicesUtil.Connect(Server server, String serverName)
   --- End of inner exception stack trace ---
   at Microsoft.TeamFoundation.Warehouse.AnalysisServicesUtil.Connect(Server server, String serverName)
   at Microsoft.TeamFoundation.Warehouse.OlapCreator.DatabaseExists(String serverInstanceName, String databaseName)
   at Microsoft.TeamFoundation.Admin.Deploy.Warehouse.WarehouseStepPerformer.UpgradeReportingConfiguration(TeamFoundationRequestContext requestContext, ServicingContext servicingContext)
   at Microsoft.TeamFoundation.Framework.Server.TeamFoundationStepPerformerBase.Microsoft.TeamFoundation.Framework.Server.IStepPerformer.PerformStep(String servicingOperation, String stepType, String stepData, ServicingContext servicingContext)
   at Microsoft.TeamFoundation.Framework.Server.ServicingStepDriver.PerformServicingStep(ServicingStep step, ServicingContext servicingContext, ServicingStepGroup group, ServicingOperation servicingOperation, Int32 stepNumber, Int32 totalSteps)
[Info   @16:18:25.060] [2012-12-03 16:18:25Z] Servicing step Upgrade Warehouse failed. (ServicingOperation: ToDev11M38FinalConfiguration; Step group: WarehouseToDev11M38FinalConfiguration)
[Info   @16:18:25.184] Clearing dictionary, removing all items.
[Info   @16:18:25.184] Node returned: Error
[Error  @16:18:25.184] TF255356: The following error occurred when configuring the Team Foundation databases: TF400711: Error occurred while executing servicing step Upgrade Warehouse for component WarehouseToDev11M38FinalConfiguration during ToDev11M38FinalConfiguration: TF400670: Error encountered when creating connection to Analysis Services. Contact your Team Foundation Server administrator.. For more information, see the configuration log.
[Info   @16:18:25.184] Completed UpgradeConfigDB: Error

```

**Figure: TF400670: Error encountered when creating connection to Analysis Services**

It looks like this might be the culprit as it is followed by an “UpgradeConfigDB: Error” statement. Again it looks like a network glitch trying to open a connection to the SQL Server that was hosting Analysis Services. With these two errors I would surmise that there might be an intermittent network problem that while a running server would be resilient to it an upgrade is a much longer transactional process and thus hit the issue.

Following the instructions and  restoring the backup and rerunning should solve the issue as it is not an issue with the upgrade itself.

### Solution for TF255430 – Restore your data from a backup

As this really all boils down to the TF255430 then we should follow the instructions above as “You must restore your data from a backup to its original state to continue”.

In this case we restored the collection, re-ran the update and all was well.

If you are installing any updates to Team Foundation Server follow these simple steps:

1. **Analyse  
   **Run the Best Practices Analyser to make sure that your TFS Server is healthy and highlight any problems that you can fix first
2. **Quiesce  
   **Make your TFS and SharePoint environments inaccessible so that the backups are all at the same version
3. **Backup**  
   Backup all data using the Team Foundation Server backup tool from the power tools
4. **Snapshot**  
   Make sure that you take a Snapshot of both your application tier and data tier at the same time index.
5. **Update**  
   You should make sure that all of the components of your Team Foundation Server environment are up to data. That means installing ALL Microsoft Updates for both Windows and other products.
6. **Upgrade**  
   Then run the upgrade with the knowledge that you have done everything possible to make sure things go smoothly.

These simple steps should mitigate any future issues and should find any communication issues as well…

_\-Do you want help with this? Contact Northwest Cadence to get a Quarterly Healthcheck and Upgrade on [info@nwcadence.com](mailto:info@nwcadence.com?subject=Recommended through MrHinsh (TFS 2012 Update 1 - TF255430: the database was partially upgraded during a failed upgrade)) and to schedule all of your TFS Upgrades for the coming year._
