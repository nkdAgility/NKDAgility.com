---
title: Log Elmah errors in Team Foundation Server
description: Learn how to log Elmah errors in Team Foundation Server effectively. Discover methods to streamline error tracking and enhance your development process.
ResourceId: FGTZV3eWHR9
ResourceType: blog
ResourceImport: true
ResourceImportId: 97
ResourceImportSource: Wordpress
ResourceImportOriginalSource: GeeksWithBlogs
date: 2009-07-26
weight: 640
creator: Martin Hinshelwood
layout: blog
resourceTypes: blog
slug: log-elmah-errors-in-team-foundation-server
aliases:
- /blog/log-elmah-errors-in-team-foundation-server
- /log-elmah-errors-in-team-foundation-server
- /resources/FGTZV3eWHR9
- /resources/blog/log-elmah-errors-in-team-foundation-server
aliasesArchive:
- /blog/log-elmah-errors-in-team-foundation-server
- /log-elmah-errors-in-team-foundation-server
- /resources/blog/log-elmah-errors-in-team-foundation-server
tags:
- Software Development
preview: metro-binary-vb-128-link-1-1.png
categories:
- Engineering Excellence
- DevOps

---
I am not sure if this is a good idea, but I was bored one day and decided to add a TFS Error Log provider for [Elmah](http://code.google.com/p/elmah/). There are 2 ways you can do this. You can create a new WorkItem type and log an error report for each of the errors or you can create one work item for each error type/title. To do this you can create a title that is the combination of error message and application name and then search TFS for an existing work item. If it exists then add the error to it, if it does not then create a work item for that instance. You can use any work item type, and the errors are added as [Elmah](http://code.google.com/p/elmah/) xml log files.

There are a number of things you need to override when you inherit from [Elmah](http://code.google.com/p/elmah/).ErrorLog. The first is the Log method.

```
''' <summary>
''' Logs the error as an attachment to an existing work item, or adds a new work item if this error has not occurred.
''' </summary>
''' <param name="error">The error to be logged</param>
''' <returns>The ID of the error</returns>
''' <remarks></remarks>
Public Overrides Function Log(ByVal [error] As [Error]) As String
    Dim errorId = Guid.NewGuid().ToString()
    Dim timeStamp = DateTime.UtcNow.ToString("yyyy-MM-ddHHmmssZ", CultureInfo.InvariantCulture)
    Dim Filename = String.Format("error-{0}-{1}.elmah", timeStamp, errorId)
    Dim temp = System.IO.Path.Combine(".", Filename)
    ' Temp Log to disk
    Using writer = New XmlTextWriter(temp, Encoding.UTF8)
        writer.Formatting = Formatting.Indented
        writer.WriteStartElement("error")
        writer.WriteAttributeString("errorId", errorId)
        ErrorXml.Encode([error], writer)
        writer.WriteEndElement()
        writer.Flush()
    End Using

    Dim Title As String = String.Format("{0}-{1}", [error].ApplicationName, [error].Message)

    Dim wi As WorkItem = GetWorkItemForException(Title, [error])

    Dim a As New Attachment(temp, "Elmah error log")

    wi.Attachments.Add(a)
    If wi.IsValid Then
        wi.Save()
        Return String.Format("{0}|{1}", wi.Id, errorId.ToString)
    Else
        Dim message As New System.Text.StringBuilder
        Dim results = wi.Validate()
        Dim isFirst As Boolean = True
        For Each r In results
            message.AppendLine(String.Format(IIf(isFirst, "{0}", ", {0}"), r))
            isFirst = False
        Next
        Throw New ApplicationException(String.Format("Unable to save the work item because the following fields produced a validation error '{0}'.", message.ToString))
    End If
End Function
```

The idea is that you attach the [Elmah](http://code.google.com/p/elmah/) log file to the work item with a .[elmah](http://code.google.com/p/elmah/) extension. This will allow us to find all the error logs in the future. So we create the temporary log file, and then create our key/title for our work item. You can customize this by customizing your exception messages on the server side. We then get our work item, and add the file as an attachment.

Because I am doing this the quick and dirty way, i.e. just for fun, I have utilised the API’s provided in the Templates add-on for the Power Tools to customize the work items. So when we are creating the Work item:

```
Protected Function GetWorkItemForException(ByVal Title As String, ByVal [error] As [Error]) As WorkItem
    Dim wi As WorkItem = GetExistingWorkItem(Title)
    If wi Is Nothing Then
        wi = CreateNewWorkItem(Title)
    End If
    m_TemplateDefault.Fields.ApplyFieldValues(wi, False)
    ApplyErrorFieldValues(wi, [error])
    Return wi
End Function
```

So, we either get an existing work item, or we create a new one, but then we need to apply some values to the work item. In the constructor of the class [Elmah](http://code.google.com/p/elmah/) passes an IDictionary object that we use to pass the template names.

```
Public Sub New(ByVal config As IDictionary)
    If config Is Nothing Then
        Throw New ArgumentNullException("config")
    End If
    sm_Config = config

    Dim store As ITemplateStore = GetStore()
    m_TemplateDefault = GetTemplate("Defaults", store)
    m_TemplateErrorMap = GetTemplate("ErrorMap", store)

    If m_TemplateDefault Is Nothing Or m_TemplateErrorMap Is Nothing Then
        Throw New ApplicationException("Unable to load the templates from the store.")
    End If

End Sub
```

I created a Store (Microsoft.TeamFoundation.PowerTools.Client.WorkItemTracking.Templates.ITemplateStore) for the templates and attempt to load both a “defaults” template and a dynamic “mapping” template. The latter will need some special mapping, but as you can see from the GetWorkItemForException there is already a method on the Template object to Apply all of the values to a work item. Here is an example default template:

```
<?xml version="1.0"?>
<Template xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
  <FieldValues>
    <FieldValue>
      <ReferenceName>System.AreaPath</ReferenceName>
      <Value>TestProject1TestArea1</Value>
    </FieldValue>
    <FieldValue>
      <ReferenceName>System.IterationPath</ReferenceName>
      <Value>TestProject1TestIteration1</Value>
    </FieldValue>
    <FieldValue>
      <ReferenceName>System.AssignedTo</ReferenceName>
      <Value>Martin Hinshelwood</Value>
    </FieldValue>
    <FieldValue>
      <ReferenceName>Microsoft.VSTS.CMMI.FoundInEnvironment</ReferenceName>
      <Value>DEV</Value>
    </FieldValue>
    <FieldValue>
      <ReferenceName>Microsoft.VSTS.Build.FoundIn</ReferenceName>
      <Value>Build_v1.13_20090312.1</Value>
    </FieldValue>
  </FieldValues>
  <WorkItemTypeName>Bug</WorkItemTypeName>
  <TeamServerUri>http://tfs01.company.biz:8080/</TeamServerUri>
  <TeamProjectName>TestProject1</TeamProjectName>
  <Description />
</Template>
```

These values are now mapped onto the work item. But what about any dynamic values that we want to use from the Error. I added a second template called “ErrorMap” that will use the same format, but use something like:

```
<?xml version="1.0"?>
<Template xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
  <FieldValues>
    <FieldValue>
      <ReferenceName>System.AreaPath</ReferenceName>
      <Value>TestProject1{ApplicationName}</Value>
    </FieldValue>
    <FieldValue>
      <ReferenceName>System.Description</ReferenceName>
      <Value>{WebHostHtmlMessage}</Value>
    </FieldValue>
    <FieldValue>
      <ReferenceName>Company.Custom.MethodName</ReferenceName>
      <Value>{Exception.TargetSite.Name}</Value>
    </FieldValue>
  </FieldValues>
  <WorkItemTypeName>Bug</WorkItemTypeName>
  <TeamServerUri>http://tfs01.company.biz:8080/</TeamServerUri>
  <TeamProjectName>TestProject1</TeamProjectName>
  <Description />
</Template>
```

We can then apply those values with a little reflection by parsing out the value and applying the retrieved object values to the work item.

```
Private Sub ApplyErrorFieldValues(ByVal wi As WorkItem, ByVal [error] As [Error])
    For Each i In m_TemplateErrorMap.Fields
        Dim value As String = GetPropertyValue(i.Value, [error])
        If wi.Fields(i.ReferenceName).AllowedValues.Contains(value) Then
            wi.Fields(i.ReferenceName).Value = value
        Else
            Throw New ApplicationException(String.Format("Unable to set the work item field '{0}' to '{1}' as '{1}' is not in the Allowed Values list.", i.ReferenceName, value))
        End If
    Next
End Sub

Private Function GetPropertyValue(ByVal path As String, ByVal target As Object) As String
    Dim bits() As String = path.Split(".")
    Dim ll As New LinkedList(Of String)
    Array.ForEach(bits, Function(b) ll.AddLast(b))
    Return GetPropertyRecurse(ll.First, target)
End Function

Private Function GetPropertyRecurse(ByVal node As LinkedListNode(Of String), ByVal target As Object) As String
    ' ToDo: add ability to support propertyName(0) [arrays]
    Dim r As System.Reflection.PropertyInfo = target.GetType.GetProperty(node.Value, BindingFlags.Static Or BindingFlags.Public Or BindingFlags.GetField Or BindingFlags.GetProperty)
    If r.PropertyType.IsClass And Not node.Next Is Nothing Then
        Return GetPropertyRecurse(node.Next, r.GetValue(target, Nothing))
    Else
        Return r.GetValue(target, Nothing).ToString
    End If
End Function
```

Like I said this is work in progress and it does not support arrays as sub values, but it does add a certain level of versatility to the logging. My last project used a logging system, not [Elmah](http://code.google.com/p/elmah/), to log errors to TFS in this way and I also added functionality to update the work item in different ways if it was Closed or Resolved to reactivate it depending on the Build number values.

We have now created a new work item, but what about loading an existing one?

```
Private Function GetExistingWorkItem(ByVal Title As String) As WorkItem
    ' Query for work items
    Dim query As String = "SELECT [System.Id], [System.Title] " _
                         & "FROM WorkItems " _
                         & "WHERE [System.TeamProject] = @Project  " _
                         & "AND  [System.WorkItemType] = @WorkItemType  " _
                         & "AND  [System.Title] = @Title  " _
                         & "ORDER BY [System.Id]"
    Dim paramiters As New Hashtable
    paramiters.Add("Project", m_TemplateDefault.TeamProjectName)
    paramiters.Add("WorkItemType", m_TemplateDefault.WorkItemTypeName)
    paramiters.Add("Title", m_TemplateDefault.WorkItemTypeName)
    Dim y As WorkItemCollection = TfsWorkItemStore.Query(query, paramiters)
    Return y(0)
End Function
```

This is a simple search for the title that we created and pass back the first match, just in case we have duplicates.

And that's all there is to saving your logs into VSTS, but how do we get them out! This is pretty easy as all of our log entries have now been saved to a TFS work item and if you remember from before we used the “String.Format("{0}|{1}", wi.Id, errorId.ToString)“ for the ID so we can find the work item again.

The two thing we have left is loading a single error, and loading all of the errors. Getting a single error is a little tricky, which is why we passed back the ID in a format that included the Work Item ID.

```
Public Overrides Function GetError(ByVal id As String) As ErrorLogEntry
    Dim idBits() As String = id.Split("|")
    Dim wiId As Integer
    Dim errGuid As String
    If Not idBits.Length = 2 Then
        Throw New ArgumentException("Invalid ID, it must be made in the format {workItemId}|{guid}", "id")
    End If
    If Not IsNumeric(idBits(0)) Then
        Throw New ArgumentException("The workItemId part of the ID must be an integer. Format: {workItemId}|{guid}", "id")
    End If
    wiId = CInt(idBits(0))
    Try
        errGuid = New Guid(idBits(1)).ToString
    Catch ex As Exception
        Throw New ArgumentException("The guid part of the ID must be an integer. Format: {workItemId}|{guid}", "id")
    End Try
    Dim wi As WorkItem = TfsWorkItemStore.GetWorkItem(wiId)
    If wi Is Nothing Then
        Throw New ApplicationException("A work item with that id does not exits")
    End If
    Dim a = (From attachemnt As Attachment In wi.Attachments Where attachemnt.Name.Contains(errGuid) Select attachemnt).SingleOrDefault
    If a Is Nothing Then
        Throw New ApplicationException("The attachment does not exits or has been removed")
    End If
    Return GetErrorLogEntryFromTfsAttachement(wi, a)
End Function
```

In this method we do a little validation while parsing out the Work Item ID and the [Elmah](http://code.google.com/p/elmah/) ID, we then load the specified work item, and find the attachment, and return it. I have a little helper method to make a log item from an attachment, but it fairly simple:

```
Private Function GetErrorLogEntryFromTfsAttachement(ByVal wi As WorkItem, ByVal a As Attachment) As ErrorLogEntry
    Using reader = XmlReader.Create(a.Uri.ToString)
        If Not reader.IsStartElement("error") Then
            Return Nothing
        End If
        Dim errid = String.Format("{0}|{1}", wi.Id, reader.GetAttribute("errorId"))
        Dim [error] = ErrorXml.Decode(reader)
        Return New ErrorLogEntry(Me, errid, [error])
    End Using
    Return Nothing
End Function
```

And voila! You havve a single Error Log Entry. As you have probably guesses, getting all the errors is easy now. We just need to find all attachements that have a .[elmah](http://code.google.com/p/elmah/) extension in our project. A little linq can help with this.

```
Public Overrides Function GetErrors(ByVal pageIndex As Integer, ByVal pageSize As Integer, ByVal errorEntryList As System.Collections.IList) As Integer
    If pageIndex < 0 Then Throw New ArgumentOutOfRangeException("pageIndex", pageIndex, Nothing)
    If pageSize < 0 Then Throw New ArgumentOutOfRangeException("pageSize", pageSize, Nothing)

    ' Query for work items
    Dim query As String = "SELECT [System.Id], [System.Title] " _
                         & "FROM WorkItems " _
                         & "WHERE [System.TeamProject] = @Project  " _
                         & "AND  [System.WorkItemType] = @WorkItemType  " _
                         & "ORDER BY [System.Id]"
    Dim paramiters As New Hashtable
    paramiters.Add("Project", m_TemplateDefault.TeamProjectName)
    paramiters.Add("WorkItemType", m_TemplateDefault.WorkItemTypeName)
    Dim y As WorkItemCollection = TfsWorkItemStore.Query(query, paramiters)
    ' Query work items for attachments
    Dim wiats = From wi As WorkItem In y, a As Attachment In wi.Attachments Where a.Name.Contains(".elmah") Order By a.Name Select a, wi
    If Not wiats Is Nothing Then
        ' Select specific attachemnts
        Dim results = From wiat In wiats Skip pageIndex * pageSize Take pageSize Select wiat
        ' Add to output
        For Each el In results
            errorEntryList.Add(GetErrorLogEntryFromTfsAttachement(el.wi, el.a))
        Next
    End If
    ' return count
    Return errorEntryList.Count
End Function
```

And there we go, errors from [Elmah](http://code.google.com/p/elmah/) saved into Team Foundation Server and then loaded back out. I don’t know how useful this would be in the real world, but it was good for a little boredom relief.

**Full Source**

```
Imports Elmah
Imports Microsoft.TeamFoundation.Client
Imports Microsoft.TeamFoundation.WorkItemTracking.Client
Imports Microsoft.TeamFoundation.PowerTools.Client.WorkItemTracking.Templates
Imports System.Globalization
Imports System.Xml
Imports System.Text
Imports System.Web
Imports System.Reflection

Public Class TfsErrorLog
    Inherits ErrorLog

    Private Shared m_TemplateDefault As Template
    Private Shared m_TemplateErrorMap As Template
    Private Shared sm_Tfs As TeamFoundationServer
    Private Shared sm_TfsStore As WorkItemStore
    Private Shared sm_TfsProject As Project
    Private Shared sm_Config As IDictionary

    Public ReadOnly Property TfsServer() As TeamFoundationServer
        Get
            If sm_Tfs Is Nothing Then
                sm_Tfs = GetTeamFoundationServer()
            End If
            Return sm_Tfs
        End Get
    End Property

    Public ReadOnly Property TfsWorkItemStore() As WorkItemStore
        Get
            If sm_TfsStore Is Nothing Then
                sm_TfsStore = GetTeamFoundationServerWorkItemStore()
            End If
            Return sm_TfsStore
        End Get
    End Property

    Public ReadOnly Property TfsProject() As Project
        Get
            If sm_TfsProject Is Nothing Then
                sm_TfsProject = GetTeamFoundationServerProject()
            End If
            Return sm_TfsProject
        End Get
    End Property

    Public Sub New(ByVal config As IDictionary)
        If config Is Nothing Then
            Throw New ArgumentNullException("config")
        End If
        sm_Config = config

        Dim store As ITemplateStore = GetStore()
        m_TemplateDefault = GetTemplate("Defaults", store)
        m_TemplateErrorMap = GetTemplate("ErrorMap", store)

        If m_TemplateDefault Is Nothing Or m_TemplateErrorMap Is Nothing Then
            Throw New ApplicationException("Unable to load the templates from the store.")
        End If

    End Sub

    Private Function GetStore()
        Dim TfsWorkItemTemplateStore As String = GetStorePath()
        Try
            Dim storeProvider As New FileSystemTemplateStoreProvider
            Return New TemplateStore(storeProvider, TfsWorkItemTemplateStore, ":)Store")
        Catch ex As Exception
            Throw New ApplicationException(String.Format("Unable to load the store from '{0}'.", TfsWorkItemTemplateStore), ex)
        End Try
    End Function

    Private Function GetStorePath() As String
        Dim storePath As String = sm_Config("TfsWorkItemTemplateStore")
        If String.IsNullOrEmpty(storePath) Then
            Throw New ApplicationException("Tfs Server Name is missing for the TFS based error log.")
        End If
        Try
            If storePath.StartsWith("~/") Then
                storePath = HttpContext.Current.Server.MapPath(storePath)
            End If
            Return storePath
        Catch ex As Exception
            Throw New ApplicationException(String.Format("Unable to produce the store path from '{0}'.", storePath), ex)
        End Try
    End Function

    Private Function GetTemplate(ByVal TemplateName As String, ByVal store As ITemplateStore) As ITemplate
        Try
            Dim t As ITemplate
            If Not store.TemplateExists("/", TemplateName) Then
                t = store.CreateTemplate()
                t.Name = TemplateName
                t.ParentFolder = "/"
                t.TeamServerUri = "https://tfs01.codeplex.biz:443"
                t.TeamProjectName = "RDdotNet"
                t.WorkItemTypeName = "WorkItem"
                store.AddTemplate(t)
            End If
            Return store.GetTemplate("/", TemplateName)
        Catch ex As Exception
            Throw New ApplicationException(String.Format("Unable to load the template '{0}' from the store.", TemplateName), ex)
        End Try
    End Function

    Private Function GetTeamFoundationServer() As TeamFoundationServer
        Dim tfs As TeamFoundationServer = Nothing
        Try
            tfs = New TeamFoundationServer(m_TemplateDefault.TeamServerUri)
            tfs.Authenticate()
            If Not tfs.HasAuthenticated Then
                Throw New ApplicationException("Unable to authenticate against TFS server")
            End If
        Catch ex As Exception
            Throw New ApplicationException("Failed to authenticate against TFS server", ex)
        End Try
        Return tfs
    End Function

    Private Function GetTeamFoundationServerWorkItemStore() As WorkItemStore
        Dim store As WorkItemStore = Nothing
        If TfsServer.HasAuthenticated Then
            store = DirectCast(TfsServer.GetService(GetType(WorkItemStore)), WorkItemStore)
        End If
        Return store
    End Function

    Private Function GetTeamFoundationServerProject() As Project
        Dim Project As Project = Nothing
        Try
            If TfsServer.HasAuthenticated Then
                Project = TfsWorkItemStore.Projects(m_TemplateDefault.TeamProjectName)
            End If
        Catch ex As Exception
            Throw New ApplicationException("Unable to retrieve Tfs Project", ex)
        End Try
        If Project Is Nothing Then
            Throw New ApplicationException(String.Format("Unable to locate project with the name '{0}'", m_TemplateDefault.TeamProjectName))
        End If
        Return Project
    End Function

    Public Overrides Function GetError(ByVal id As String) As ErrorLogEntry
        Dim idBits() As String = id.Split("|")
        Dim wiId As Integer
        Dim errGuid As String
        If Not idBits.Length = 2 Then
            Throw New ArgumentException("Invalid ID, it must be made in the format {workItemId}|{guid}", "id")
        End If
        If Not IsNumeric(idBits(0)) Then
            Throw New ArgumentException("The workItemId part of the ID must be an integer. Format: {workItemId}|{guid}", "id")
        End If
        wiId = CInt(idBits(0))
        Try
            errGuid = New Guid(idBits(1)).ToString
        Catch ex As Exception
            Throw New ArgumentException("The guid part of the ID must be an integer. Format: {workItemId}|{guid}", "id")
        End Try
        Dim wi As WorkItem = TfsWorkItemStore.GetWorkItem(wiId)
        If wi Is Nothing Then
            Throw New ApplicationException("A work item with that id does not exits")
        End If
        Dim a = (From attachemnt As Attachment In wi.Attachments Where attachemnt.Name.Contains(errGuid) Select attachemnt).SingleOrDefault
        If a Is Nothing Then
            Throw New ApplicationException("The attachment does not exits or has been removed")
        End If
        Return GetErrorLogEntryFromTfsAttachement(wi, a)
    End Function

    Public Overrides Function GetErrors(ByVal pageIndex As Integer, ByVal pageSize As Integer, ByVal errorEntryList As System.Collections.IList) As Integer
        If pageIndex < 0 Then Throw New ArgumentOutOfRangeException("pageIndex", pageIndex, Nothing)
        If pageSize < 0 Then Throw New ArgumentOutOfRangeException("pageSize", pageSize, Nothing)

        ' Query for work items
        Dim query As String = "SELECT [System.Id], [System.Title] " _
                             & "FROM WorkItems " _
                             & "WHERE [System.TeamProject] = @Project  " _
                             & "AND  [System.WorkItemType] = @WorkItemType  " _
                             & "ORDER BY [System.Id]"
        Dim paramiters As New Hashtable
        paramiters.Add("Project", m_TemplateDefault.TeamProjectName)
        paramiters.Add("WorkItemType", m_TemplateDefault.WorkItemTypeName)
        Dim y As WorkItemCollection = TfsWorkItemStore.Query(query, paramiters)
        ' Query work items for attachments
        Dim wiats = From wi As WorkItem In y, a As Attachment In wi.Attachments Where a.Name.Contains(".elmah") Order By a.Name Select a, wi
        If Not wiats Is Nothing Then
            ' Select specific attachemnts
            Dim results = From wiat In wiats Skip pageIndex * pageSize Take pageSize Select wiat
            ' Add to output
            For Each el In results
                errorEntryList.Add(GetErrorLogEntryFromTfsAttachement(el.wi, el.a))
            Next
        End If
        ' return count
        Return errorEntryList.Count
    End Function

    ''' <summary>
    ''' Logs the error as an attachement to an existing work item, or adds a new work item if this error has not occured.
    ''' </summary>
    ''' <param name="error">The error to be logged</param>
    ''' <returns>The ID of the error</returns>
    ''' <remarks></remarks>
    Public Overrides Function Log(ByVal [error] As [Error]) As String
        'TODO: Log
        Dim errorId = Guid.NewGuid().ToString()
        Dim timeStamp = DateTime.UtcNow.ToString("yyyy-MM-ddHHmmssZ", CultureInfo.InvariantCulture)
        Dim Filename = String.Format("error-{0}-{1}.elmah", timeStamp, errorId)
        Dim temp = System.IO.Path.Combine(".", Filename)
        ' Temp Log to disk
        Using writer = New XmlTextWriter(temp, Encoding.UTF8)
            writer.Formatting = Formatting.Indented
            writer.WriteStartElement("error")
            writer.WriteAttributeString("errorId", errorId)
            ErrorXml.Encode([error], writer)
            writer.WriteEndElement()
            writer.Flush()
        End Using

        Dim Title As String = String.Format("{0}-{1}", [error].ApplicationName, [error].Message)

        Dim wi As WorkItem = GetWorkItemForException(Title, [error])

        Dim a As New Attachment(temp, "Elmah error log")

        wi.Attachments.Add(a)
        If wi.IsValid Then
            wi.Save()
            Return String.Format("{0}|{1}", wi.Id, errorId.ToString)
        Else
            Dim message As New System.Text.StringBuilder
            Dim results = wi.Validate()
            Dim isFirst As Boolean = True
            For Each r In results
                message.AppendLine(String.Format(IIf(isFirst, "{0}", ", {0}"), r))
                isFirst = False
            Next
            Throw New ApplicationException(String.Format("Unable to save the work item becuse the following fields produced a validation error '{0}'.", message.ToString))
        End If
    End Function

    Protected Function GetWorkItemForException(ByVal Title As String, ByVal [error] As [Error]) As WorkItem
        Dim wi As WorkItem = GetExistingWorkItem(Title)
        If wi Is Nothing Then
            wi = CreateNewWorkItem(Title)
        End If
        m_TemplateDefault.Fields.ApplyFieldValues(wi, False)
        ApplyErrorFieldValues(wi, [error])
        Return wi
    End Function

    Private Function GetExistingWorkItem(ByVal Title As String) As WorkItem
        ' Query for work items
        Dim query As String = "SELECT [System.Id], [System.Title] " _
                             & "FROM WorkItems " _
                             & "WHERE [System.TeamProject] = @Project  " _
                             & "AND  [System.WorkItemType] = @WorkItemType  " _
                             & "AND  [System.Title] = @Title  " _
                             & "ORDER BY [System.Id]"
        Dim paramiters As New Hashtable
        paramiters.Add("Project", m_TemplateDefault.TeamProjectName)
        paramiters.Add("WorkItemType", m_TemplateDefault.WorkItemTypeName)
        paramiters.Add("Title", m_TemplateDefault.WorkItemTypeName)
        Dim y As WorkItemCollection = TfsWorkItemStore.Query(query, paramiters)
        Return y(0)
    End Function

    Private Function CreateNewWorkItem(ByVal Title As String) As WorkItem
        Dim wit As WorkItemType = (From t As WorkItemType In TfsProject.WorkItemTypes Where t.Name = m_TemplateDefault.WorkItemTypeName).SingleOrDefault
        If wit Is Nothing Then
            Throw New ApplicationException(String.Format("Unable to find the work item type '{0}' in the project '{1}'", m_TemplateDefault.WorkItemTypeName, TfsProject.Name))
        End If
        Dim wi As New WorkItem(wit)
        wi.Title = Title
        Return wi
    End Function

    Private Sub ApplyErrorFieldValues(ByVal wi As WorkItem, ByVal [error] As [Error])
        For Each i In m_TemplateErrorMap.Fields
            Dim value As String = GetPropertyValue(i.Value, [error])
            If wi.Fields(i.ReferenceName).AllowedValues.Contains(value) Then
                wi.Fields(i.ReferenceName).Value = value
            Else
                Throw New ApplicationException(String.Format("Unable to set the work item field '{0}' to '{1}' as '{1}' is not in the Allowed Values list.", i.ReferenceName, value))
            End If
        Next
    End Sub

    Private Function GetPropertyValue(ByVal path As String, ByVal target As Object) As String
        Dim bits() As String = path.Split(".")
        Dim ll As New LinkedList(Of String)
        Array.ForEach(bits, Function(b) ll.AddLast(b))
        Return GetPropertyRecurse(ll.First, target)
    End Function

    Private Function GetPropertyRecurse(ByVal node As LinkedListNode(Of String), ByVal target As Object) As String
        ' ToDo: addd ability to support propertyName(0) [arrays]
        Dim r As System.Reflection.PropertyInfo = target.GetType.GetProperty(node.Value, BindingFlags.Static Or BindingFlags.Public Or BindingFlags.GetField Or BindingFlags.GetProperty)
        If r.PropertyType.IsClass And Not node.Next Is Nothing Then
            Return GetPropertyRecurse(node.Next, r.GetValue(target, Nothing))
        Else
            Return r.GetValue(target, Nothing).ToString
        End If
    End Function

    Private Function GetErrorLogEntryFromTfsAttachement(ByVal wi As WorkItem, ByVal a As Attachment) As ErrorLogEntry
        Using reader = XmlReader.Create(a.Uri.ToString)
            If Not reader.IsStartElement("error") Then
                Return Nothing
            End If
            Dim errid = String.Format("{0}|{1}", wi.Id, reader.GetAttribute("errorId"))
            Dim [error] = ErrorXml.Decode(reader)
            Return New ErrorLogEntry(Me, errid, [error])
        End Using
        Return Nothing
    End Function

End Class
```

Technorati Tags: [WIT](http://technorati.com/tags/WIT) [ALM](http://technorati.com/tags/ALM) [.NET](http://technorati.com/tags/.NET) [CodeProject](http://technorati.com/tags/CodeProject) [TFS](http://technorati.com/tags/TFS)
