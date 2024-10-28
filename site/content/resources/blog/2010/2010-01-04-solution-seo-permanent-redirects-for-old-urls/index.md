---
title: Solution - SEO permanent redirects for old URL’s?
description: "Learn how to maintain your SEO rankings with permanent redirects for old URLs. Discover effective strategies to map old links to new ones seamlessly."
date: 2010-01-04
creator: Martin Hinshelwood
id: "73"
layout: blog
resourceType: blog
slug: solution-seo-permanent-redirects-for-old-urls
aliases:
  - /blog/solution-seo-permanent-redirects-for-old-urls
tags:
  - code
  - codeproject
  - sharepoint
  - spf2010
  - ssw
  - tools
categories:
  - code-and-complexity
preview: metro-sharepoint-128-link-1-1.png
---

From time to time, your website structure may change. When this happens, you do not want to have to start from scratch with your Google rankings, so you need to map all of your Old URLs to new ones.

This may seem like a trivial thing, but it is essential to keep your current rankings, that you worked hard for, intact.

In our scenario the old site used a query string with the product ID in it, and the new site uses nice friendly names.

Old: [http://northwind.com/Product/ProductInfo.aspx?id=3456](http://northwind.com/Product/ProductInfo.aspx?id=3456)

New: [http://northwind.com/CoolLightsaberWithRealAction.aspx](http://northwind.com/CoolLightsaberWithRealAction.aspx)

Updated #1 January 5th, 2010: \- As suggested by [Adam Cogan](http://sharepoint.ssw.com.au/AboutUs/Employees/Pages/Adam.aspx), I changed:

- Change Figures to SSW standard with “Good example, ….”, “OK example, ….” And “Bad example, ….“
- Prefix main headings with “Option #x” to make them stand out
- Prefix process steps with “Step #x” to differentiate them.
- Remove tiny URL’s so the reader knows where they are going
- Spell check (i.e. run through Word)
- Link to rules for better regex
- Change “outtakes” to “TODO:”’s
- End on an impact line (“In conclusion I …..”)
- Change Title to  “Solution - SEO permanent redirects for old URL’s?”

Updated #2 January 6th, 2010: –As suggested by [John Liu](http://sharepoint.ssw.com.au/AboutUs/Employees/Pages/John.aspx), I changed the SQL call to be completely wrapped in a “try catch” statement and to close the connection in the “Finally” area. Dam, I thought no one at SSW could read VB.

Updated #3 January 7th, 2010: \- As suggested by [Peter Gfader](http://sharepoint.ssw.com.au/AboutUs/Employees/Pages/Peter.aspx), I changed the source to use a parameterised SQL statement instead of a Stored Procedure. He pointed out that “[Stored procedures are bad, m'kay?](http://weblogs.asp.net/fbouma/archive/2003/11/18/38178.aspx "Stored procedures are bad, m'kay?")”

Updated #4 January 8th, 2010: – Updated to reflect latest code changes to increase flexibility of the rule.

---

## Option #1 - You can do it in product.aspx

```
// …
// Lookup database here and find the friendly name for the product with the ID 3456
// …
Response.Status = "301 Moved Permanently"
Response.StatusCode = 301;
Response.AddHeader("Location","/CoolLightsaberWithRealAction.aspx");
Response.End();
```

Figure: Bad example, Write it right into the old page.

Why is this not a good approach?

- The old page may not exist, you may be building a whole new version of the site
- It is slow. You have to wait for the page to load, which probably means your master page, and all the code which goes with that.
- It leaves old pages dotted about your site that you do not really want.

## Option #2 - You can do it in the global.asax

```
protected void Application_BeginRequest(object sender, EventArgs e)
{

    if (Request.FilePath.Contains("/product.aspx?id=")
    {
        // ...
        // Lookup the ID in the database to get the new friendly name
        // ...
        Response.Status="301 Moved Permanently"
        Response.StatusCode=301;
        Response.Redirect ("/CoolLightsaberWithRealAction.aspx", true);
    }
}
```

Figure: Bad example, ASP.NET 2.0 solution in the global.asax file for redirects

```
protected void Application_BeginRequest(object sender, EventArgs e)
{

    if (Request.FilePath.Contains("/product.aspx?id=")
    {
        // ...
        // Lookup the ID in the database to get the new friendly name
        // ...
        Response.RedirectPermanent("/CoolLightsaberWithRealAction.aspx", true);
    }
}
```

Figure: Bad example, ASP.NET 4.0 solution in the global.asax file for redirects, less code.

Using the global.asax has its draw backs.

- To change it you must make a code change to your site and re-deploy
- If you have multiple redirects it is going to get ugly fast.

## Option #3 - You can do it with the IIS7 URL Rewrite Module

Using the IIS7 URL Rewrite Module which can be installed using the [Microsoft Web Platform Installer](http://www.microsoft.com/web/downloads/platform.aspx) is the best option, but unfortunately it does [not currently support](http://blog.hinshelwood.com/archive/2009/12/28/do-you-know-how-to-permanently-redirect-old-incoming-urlrsquos.aspx) looking up a database.

If you have identifiable patterns in the rewrites that you want to perform then this is fantastic. So if you have all of the information that you need in the URL to do the rewrite, then you can stop reading and go an install it.

With the IIS7 URL Rewrite Module you can

- Rewrite and redirect URLs
- Handles requests before ASP.NET is aware of (good performance)
- Solves both problems: redirecting broken pages and creating nice URLs
- **Various rule actions**. Instead of rewriting a URL, a rule may perform other actions, such as issue an HTTP redirect, abort the request, or send a custom status code to HTTP client.
- Nice graphical rule editor
- Regex pattern matching for requests and rewrites
- URL rewrite module v2 adds support for outbound response rewriting
- Fix up the content of any HTTP response by using regular expression pattern matching (e.g. modify links in outgoing response)

As it turns out, we found out yesterday that the next version of the IIS7 URL Rewriting Module IS going to support loading from a database! Wither that is just loading the rules, or you can load some of the data you need has yet to be seen. But as we can’t get even a beta for a couple of weeks, and our release date is in that region we could not wait.

## Option #4 - You can do it with UrlRewritingNet.UrlRewriter

Using the [UrlRewritingNet.UrlRewriter](http://www.urlrewriting.net) component you can do pretty much everything that the IIS7 Rewrite Module does, but it does not have a nice UI to interact with. The best part of UrlRewritingNet.UrlRewriter is that its rules engine is extensible, so we can add a new rule type to load from a database.

The first thing you do with any new toolkit is read the documentation, or at least have it open and pretend to read it while you tinker.

### Step #1 - Add UrlRewritingNet.UrlRewriter to our site

To add UrlRewritingNet.UrlRewriter to our site you need to add UrlRewritingNet.UrlRewriter.dll (you can download this from their site) to the Bin folder and make a couple of modifications to the web.config. I have opted to add the UrlRewritingNet.UrlRewriter section of the config to a separate file as this makes it more maintainable.

```
<?xml version="1.0"?>
<urlrewritingnet xmlns="http://www.urlrewriting.net/schemas/config/2006/07">
  <providers>
    <!-- providers go here -->
  </providers>
  <rewrites>
      <!-- rules go here -->
  </rewrites>
</urlrewritingnet>
```

Figure: Boilerplate URLRewriting config.

Create a new blank file called "urlrewriting.config" and insert the code above. As you can see you can add numerous providers and rules. Lookup the documentation for the built in rules model that uses the same method we will be using to capture URL's, but has a regular expression based replace implementation that lets you reform any URL into any other URL, provided all the values you need are either static, or included in the incoming URL.

```
<configSections>
  ...
  <section name="urlrewritingnet"
      restartOnExternalChanges="true"
      requirePermission="false"
      type="UrlRewritingNet.Configuration.UrlRewriteSection, UrlRewritingNet.UrlRewriter"       />
</configSections>
```

Figure: ASP.NET Section definition for URLRewriting.

In your "web.config" add this section.

```
<urlrewritingnet configSource="UrlRewrite.config" />
```

Figure: You can use an external file or inline.

After the sections definition, but NOT inside any other section, add the section implementation, but use the "configSource" tag to map it to the "urlrewriting.config" file you created previously. You could also just add the contents of "urlrewriting.config" under "urlrewritingnet" element and remove the need for the additional file, but I think this is neater.

```
<system.web>
  <httpModules>
    <add name="UrlRewriteModule"
      type="UrlRewritingNet.Web.UrlRewriteModule, UrlRewritingNet.UrlRewriter" />
  </httpModules>
</system.web>
```

Figure: HttpModules make it all work in IIS6.

We need IIS to know that it needs to do some processing, but there are some key differences between IIS6 and IIS7, to make sure that both load your rewrite correctly, especially if you still have developers on Windows XP, you will need to add both of them. Add this one to the "HttpModules" element, before any other rewriting modules, it tells IIS6 that it needs to load the module.

```
<system.webServer>
  <modules>
    <add name="UrlRewriteModule"
      type="UrlRewritingNet.Web.UrlRewriteModule, UrlRewritingNet.UrlRewriter" />
  </modules>
</system.webServer>
```

Figure: Modules make it all work in IIS7.

II7 does things a little differently, so add the above to the "modules" element of "system.webServer". This does exactly the same thing, but slots it into the IIS7 pipeline.

You should now be able to add rules as specified in the documentation and have them run successfully, provided you have your regular expression  is correct :), but for this process we need to write our custom rule.

### Step #2 - Creating a blank custom rule

For some reason I have not yet fathomed, you need to create a “Provider” as well. It just has boilerplate code, but I would assume that there are circumstances when it would be useful to have some code in there.

```
Imports UrlRewritingNet.Configuration.Provider

Public Class SqlUrlRewritingProvider
    Inherits UrlRewritingProvider

    Public Overrides Function CreateRewriteRule() As UrlRewritingNet.Web.RewriteRule
        Return New SqlRewriteRule
    End Function

End Class
```

Figure: Simple code for the provider.

All you need to do in the Provider is override the “CreateRewriteRule” and pass back an instance of your custom rule.

```
Imports UrlRewritingNet.Web
Imports UrlRewritingNet.Configuration
Imports System.Configuration

Public Class SqlRewriteRule
    Inherits RewriteRule

    Public Overrides Sub Initialize(ByVal rewriteSettings As RewriteSettings)
        MyBase.Initialize(rewriteSettings)
    End Sub

    Public Overrides Function IsRewrite(ByVal requestUrl As String) As Boolean
        Return false
    End Function

    Public Overrides Function RewriteUrl(ByVal url As String) As String
        Return url
    End Function

End Class
```

Figure: Boilerplate Rule.

This is a skeleton of a new rule. It does nothing now, and in fact will not run as long as the “IsRewrite” function returns false.

The “Initialize” method passes any setting that are set on the rule entry in the config file. As we want to create a dynamic and reusable rule, we will be using a lot of settings. The settings are written as Attributes in the XML, but are in effect name value pairs.

The “IsRewrite” will determine wither we want to run the logic behind the rule. I would not advice any performance intensive calls here (like calling the database), so you should find a quick and easy way of determining if we want to proceed to rewrite the URL. The best way of doing this will be via a regular expression.

“RewiteUrl” provides the actual logic to do the rewrite. We will be calling the database here so this is more intensive work.

### Step #3 - Capture the URL you want to rewrite

Let’s first consider the capturing of the URL so we can do the IsRewrite. To provide our regular expression we will need to options, the first being our pattern, the second being the Regular expression options. We add the options so we can have both Case sensitive and insensitive settings. The standard field name for regular expressions that match is “VirtualUrl” we will just call the other “RegexOptions”.

```
Imports UrlRewritingNet.Web
Imports UrlRewritingNet.Configuration
Imports System.Data.SqlClient
Imports System.Text.RegularExpressions
Imports System.Configuration

Public Class SqlRewriteRule
    Inherits RewriteRule

    Private m_regexOptions As Text.RegularExpressions.RegexOptions
    Private m_virtualUrl As String = String.Empty

    Public Overrides Sub Initialize(ByVal rewriteSettings As RewriteSettings)
        Me.m_regexOptions = rewriteSettings.GetEnumAttribute(Of RegexOptions)("regexOptions", RegexOptions.None)
        Me.m_virtualUrl = rewriteSettings.GetAttribute("virtualUrl", "")
        MyBase.Initialize(rewriteSettings)
    End Sub

    Public Overrides Function IsRewrite(ByVal requestUrl As String) As Boolean
        Return true
    End Function

    Public Overrides Function RewriteUrl(ByVal url As String) As String
        Return url
    End Function


End Class
```

Figure: Retrieving values from the config is easy.

In order to capture these values we just add two fields to our class, and parse out the data from “rewriteSettings” for these two fields in the Initialize method.

```
Imports UrlRewritingNet.Web
Imports UrlRewritingNet.Configuration
Imports System.Text.RegularExpressions
Imports System.Configuration

Public Class ProductKeyRewriteRule
    Inherits RewriteRule

    Private m_regex As Text.RegularExpressions.Regex
    Private m_regexOptions As Text.RegularExpressions.RegexOptions
    Private m_virtualUrl As String = String.Empty

    ' Methods
    Private Sub CreateRegEx()
        Dim helper As New UrlHelper
        If MyBase.IgnoreCase Then
            Me.m_regex = New Regex(helper.HandleRootOperator(Me.m_virtualUrl), ((RegexOptions.Compiled Or RegexOptions.IgnoreCase) Or Me.m_regexOptions))
        Else
            Me.m_regex = New Regex(helper.HandleRootOperator(Me.m_virtualUrl), (RegexOptions.Compiled Or Me.m_regexOptions))
        End If
    End Sub

    Public Overrides Sub Initialize(ByVal rewriteSettings As RewriteSettings)
        Me.m_regexOptions = rewriteSettings.GetEnumAttribute(Of RegexOptions)("regexOptions", RegexOptions.None)
        Me.m_virtualUrl = rewriteSettings.GetAttribute("virtualUrl", "")
        CreateRegEx
        MyBase.Initialize(rewriteSettings)
    End Sub

    Public Overrides Function IsRewrite(ByVal requestUrl As String) As Boolean
        Return Me.m_regex.IsMatch(requestUrl)
    End Function

    Public Overrides Function RewriteUrl(ByVal url As String) As String
        Return url
    End Function


End Class
```

Figure: Creating an instance of a regular expression and using that is always faster than creating one each time.

We now have all of the information we need to create a regular expression and call "IsMatch" in the "IsRewrite" method. Therefore, we add another field for the regular expression and add a “CreateRegEx” method to create our regular expression using the built in “Ignorecase” option as well as our “RegexOptions” value. This creates a single compiled copy of our regular expression so it will operate as quickly as possible. Remember that this code will now be called for EVERY incoming URL request.

### Step #4 - Rewrite the URL with data from the database

Now that we have captured the URL, we need to rewrite it. in order to do this we will need some extra fields, and this is were things get a little complicated because we want to be generic. We will need:

- a connection string so we know where to load the data from
- a SQL Statement
- some input parameters for our SQL
- some output data
- a destination URL to inject our output into
- a place to redirect users to if all else fails

The connection string is easy, or is it.

```
' Test for connectionString and throw exception if not available
m_ConnectionString = rewriteSettings.GetAttribute("connectionString", String.Empty)
If m_ConnectionString = String.Empty Then
    Throw New NotSupportedException(String.Format("You must specify a connectionString attribute for the DataRewriteRule {0}", rewriteSettings.Name))
End If
' Check to see if this is a named connection string
Dim NamedConnectionString As ConnectionStringSettings = ConfigurationManager.ConnectionStrings(m_ConnectionString)
If Not NamedConnectionString Is Nothing Then
    m_ConnectionString = NamedConnectionString.ConnectionString
End If
```

Figure: Make sure that you check wither values are correct.

There are two ways for a connection string to be stored in ASP.NET, inline and shared. We don’t want to be fixed to a specific type, so we need to assume shared and if we can’t find a shared string, assume that the string provided in the connection string and not a key for the shared string.

The stored procedure is just a string, but the input parameters, now that is a quandary. Where can we get them from and now can we configure them. Although it would probably be best if we could have sub elements to the rule definition in the “web.config” we can’t, so all we have is a set of name value pairs.

```
^.*/Product/ProductInfo.aspx?id=(?'ProductId'd+)
```

Figure: Follow the rule: [Do you test your regular expressions?](http://www.ssw.com.au/ssw/standards/Rules/RulesToBetterRegularExpressions.aspx#testregex)

The solution I went for was to use Named groups in the regular expression. The only input parameter with this expression would be “@ProductId” and should be populated by the data in the capture group for the regular expression.

```
' Get all the named groups from the regular expression and use them as the stored procedure parameters.
Dim groupNames = From groupName In m_regex.GetGroupNames Where Not groupName = String.Empty And Not IsNumeric(groupName)
' Iterate through the named groups
For Each groupName As String In groupNames
   ' Add the name and value to the saved replacements
   UrlReplacements.Add(groupName, match.Groups(groupName).ToString)
   ' Add the name and value as input prameters to the stored procedure
   cmd.Parameters.AddWithValue("@" & groupName, match.Groups(groupName).ToString)
Next
```

Figure: Retrieving the named groups is easier than you think, but remember that it also contains the unnamed groups as a number.

So for each of the group names found in the regular expression I will be adding a SqlParameter to the SqlCommand object with the value that is returned. Again, a better solution would be to have meta data along with this that would identify the input parameters as well as data types and where to get them from, but alas it is not possible in this context.

All this allows you to call a parameterised SQL statement and get some data back that you can use in the “RewriteUrl” method. I created a “GetUrlReplacements” method to encapsulate this logic.

```
Private Function GetUrlReplacements(ByVal match As Match) As Dictionary(Of String, String)
    Dim UrlReplacements As New Dictionary(Of String, String)
    Dim paramString As String = String.Empty
    ' Call database
    Using conn As New SqlConnection(m_ConnectionString)
        Try
            conn.Open()
            Dim cmd As New SqlCommand(m_parameterisedSql, conn)
            cmd.CommandType = CommandType.Text
            ' Get all the named groups from the regular expression and use them as the stored procedure parameters.
            Dim groupNames = From groupName In m_regex.GetGroupNames Where Not groupName = String.Empty And Not IsNumeric(groupName)
            ' Iterate through the named groups
            For Each groupName As String In groupNames
                ' Add the name and value as input prameters to the stored procedure
                cmd.Parameters.AddWithValue("@" & groupName, match.Groups(groupName).ToString)
                paramString = paramString & "[@" & groupName & "=" & match.Groups(groupName).ToString & "]"
                If UrlReplacements.ContainsKey(groupName) Then
                    UrlReplacements.Add(groupName, match.Groups(groupName).ToString)
                Else
                    UrlReplacements(groupName) = match.Groups(groupName).ToString
                End If
            Next
            ' Defigne the data capture method
            Dim sqlReader As SqlClient.SqlDataReader
            ' Execute the SQL
            sqlReader = cmd.ExecuteReader()
            If sqlReader.HasRows Then
                Dim isDone As Boolean = False
                Do While sqlReader.Read()
                    If isDone Then
                        ' If more than one record is returned, exit and record
                        My.Application.Log.WriteEntry(String.Format("Too many results from execution of '{0}' using parameters '{1}' on the connection '{2}'. Make sure your query only returns a single record.", m_parameterisedSql, paramString, m_ConnectionString), TraceEventType.Error, 19786)
                        Exit Do
                    End If
                    ' Add a sql output parameter for each outputParam (note: Must be NVarChar(255))
                    For i As Integer = 0 To sqlReader.FieldCount - 1
                        If UrlReplacements.ContainsKey(sqlReader.GetName(i)) Then
                            UrlReplacements.Add(sqlReader.GetName(i), sqlReader.GetValue(i).ToString)
                        Else
                            UrlReplacements(sqlReader.GetName(i)) = sqlReader.GetValue(i).ToString
                        End If
                    Next
                    isDone = True
                Loop
                sqlReader.Close()
            Else
                My.Application.Log.WriteEntry(String.Format("No results from execution of '{0}' using parameters '{1}' on the connection '{2}'", m_parameterisedSql, paramString, m_ConnectionString), TraceEventType.Error, 19784)
                UrlReplacements.Clear()
                UrlReplacements.Add("results", "None")
            End If
        Catch ex As System.Data.SqlClient.SqlException
            My.Application.Log.WriteException(ex, TraceEventType.Error, String.Format("Unable to execute '{0}' using parameters '{1}' on the connection '{2}'", m_parameterisedSql, paramString, m_ConnectionString), 19783)
            UrlReplacements.Clear()
            UrlReplacements.Add("ex", "SqlException")
        Catch ex As Exception
            My.Application.Log.WriteException(ex, TraceEventType.Error, String.Format("Unable to connect using the connection '{0}'", m_ConnectionString), 19782)
            UrlReplacements.Clear()
            UrlReplacements.Add("ex", ex.GetType.ToString)
        End Try
    End Using
    Return UrlReplacements
End Function
```

Figure: Always encapsulate your more complicated logic, especially database calls.

The SQL is called and the first, and only the first, returned record is parsed into a name value collection allowing for multiple values to be returned.

Now that we have the relevant data, we can rewrite the URL.

```
Public Overrides Function RewriteUrl(ByVal url As String) As String
    ' Get the url replacement values
    Dim UrlReplacements As Dictionary(Of String, String) = GetUrlReplacements(Me.m_regex.Match(url))
    ' Take a copy of the target url
    Dim newUrl As String = m_destinationUrl
    ' Replace any valid values with the new value
    For Each key As String In UrlReplacements.Keys
        newUrl = newUrl.Replace("{" & key & "}", UrlReplacements(key))
    Next
    ' Test to see is any failed by looking for any left over '{'
    If newUrl.Contains("{") Then
        ' If there are left over bits, then only do a Tempory redirect to the failed URL
        Me.RedirectMode = RedirectModeOption.Temporary
        My.Application.Log.WriteEntry(String.Format("Unable to locate a product url replacement for {0}", url), TraceEventType.Error, 19781)
        Return (String.Format(m_RedirectToOnFail, Me.Name, "NotFound", UrlReplacementsToQueryString(UrlReplacements)))
    End If
    ' Sucess, so do a perminant redirect to the new url.
    My.Application.Log.WriteEntry(String.Format("Redirecting {0} to {1}", url, newUrl), TraceEventType.Information, 19780)
    Me.RedirectMode = RedirectModeOption.Permanent
    Return newUrl.Replace("^", "")
End Function
```

Figure: Make sure that there is a backup plan for your rewrites.

As you can see all we do once we have the replacement values is replace the keys from the “DestinationUrl” value with the new values. One additional test is done to check that we have not miss-configured and left some values out, so check to see if there are any “{“ left and redirect to the  “redirectOnFailed” location if we did. This will be caught if either we did not get any data back, or we just messed up the configuration.

Lets setup the rule in the config.

```
<?xml version="1.0"?>
<urlrewritingnet xmlns="http://www.urlrewriting.net/schemas/config/2006/07">
  <providers>
    <add name="SqlUrlRewritingProvider" type="SSW.UrlRewriting.SqlUrlRewritingProvider, SSW.UrlRewriting"/>
  </providers>
  <rewrites>
    <add name="Rule2"
        provider="SqlUrlRewritingProvider"
        connectionString="MyConnectionString"
        virtualUrl="^.*/Product/ProductInfo.aspx?id=(?'ProductId'd+)"
        parameterisedSql="SELECT dbo.CatalogEntry.Code as ProductId, dbo.CatalogItemSeo.Uri as ProductKey FROM  dbo.CatalogEntry INNER JOIN dbo.CatalogItemSeo ON dbo.CatalogEntry.CatalogEntryId = dbo.CatalogItemSeo.CatalogEntryId WHERE Code = @ProductId"
        DestinationUrl="^~/{ProductKey}"
        rewriteUrlParameter="IncludeQueryStringForRewrite"
        redirectToOnFail="~/default.aspx?rewrite=productNotFound"
        redirectMode="Permanent"
        redirect="Application"
        rewrite="Application"
        ignoreCase="true" />
  </rewrites>
</urlrewritingnet>
```

Figure: You can configure as many rules as you like.

The final config entry for the rule looks complicated, but it should all make sense to you now that all the logic has been explained. There are some additional propertied here that are part of the Rewriting engine, but you will find them all in the documentation.

In conclusion, hopefully the IIS7 module will support a more elegant solution in its next iteration, and you can always just hard code an HttpModule. This however is the beginnings of a more dynamic solution that can be used over and over again, even in the one site.

For those of you that can’t be bothered to piece this all together, here is the full rule source, but Don’t forget to skip to the bottom for the TODO.

```
Imports UrlRewritingNet.Web
Imports UrlRewritingNet.Configuration
Imports System.Data.SqlClient
Imports System.Text.RegularExpressions
Imports System.Configuration

Public Class SqlRewriteRule
    Inherits RewriteRule

    Private m_ConnectionString As String
    Private m_parameterisedSql As String
    Private m_destinationUrl As String = String.Empty
    Private m_regex As Text.RegularExpressions.Regex
    Private m_regexOptions As Text.RegularExpressions.RegexOptions
    Private m_virtualUrl As String = String.Empty
    Private m_RedirectToOnFail As String

    ' Methods
    Private Sub CreateRegEx()
        Dim helper As New UrlHelper
        If MyBase.IgnoreCase Then
            Me.m_regex = New Regex(helper.HandleRootOperator(Me.m_virtualUrl), ((RegexOptions.Compiled Or RegexOptions.IgnoreCase) Or Me.m_regexOptions))
        Else
            Me.m_regex = New Regex(helper.HandleRootOperator(Me.m_virtualUrl), (RegexOptions.Compiled Or Me.m_regexOptions))
        End If
    End Sub

    Public Overrides Sub Initialize(ByVal rewriteSettings As RewriteSettings)
        Me.m_regexOptions = rewriteSettings.GetEnumAttribute(Of RegexOptions)("regexOptions", RegexOptions.None)
        Me.m_virtualUrl = rewriteSettings.GetAttribute("virtualUrl", "")
        Me.m_destinationUrl = rewriteSettings.GetAttribute("destinationUrl", "")
        Me.CreateRegEx()
        ' Test for connectionString and throw exception if not available
        m_ConnectionString = rewriteSettings.GetAttribute("connectionString", String.Empty)
        If m_ConnectionString = String.Empty Then
            Throw New NotSupportedException(String.Format("You must specify a connectionString attribute for the DataRewriteRule {0}", rewriteSettings.Name))
        End If
        ' Check to see if this is a named connection string
        Dim NamedConnectionString As ConnectionStringSettings = ConfigurationManager.ConnectionStrings(m_ConnectionString)
        If Not NamedConnectionString Is Nothing Then
            m_ConnectionString = NamedConnectionString.ConnectionString
        End If
        ' Test for storedProcedure and throw exception if not available
        m_parameterisedSql = rewriteSettings.GetAttribute("parameterisedSql", String.Empty)
        If m_parameterisedSql = String.Empty Then
            Throw New NotSupportedException(String.Format("You must specify a parameterisedSql attribute for the DataRewriteRule {0}", rewriteSettings.Name))
        End If

        ' Test for redirectToOnFail and throw exception if not available
        m_RedirectToOnFail = rewriteSettings.GetAttribute("redirectToOnFail", String.Empty)
        If m_RedirectToOnFail = String.Empty Then
            Throw New NotSupportedException(String.Format("You must specify a redirectToOnFail attribute for the DataRewriteRule {0}", rewriteSettings.Name))
        End If
        MyBase.Initialize(rewriteSettings)
    End Sub

    Public Overrides Function IsRewrite(ByVal requestUrl As String) As Boolean
        Return Me.m_regex.IsMatch(requestUrl)
    End Function

    Public Overrides Function RewriteUrl(ByVal url As String) As String
        ' Get the url replacement values
        Dim UrlReplacements As Dictionary(Of String, String) = GetUrlReplacements(Me.m_regex.Match(url))
        ' Take a copy of the target url
        Dim newUrl As String = m_destinationUrl
        ' Replace any valid values with the new value
        For Each key As String In UrlReplacements.Keys
            newUrl = newUrl.Replace("{" & key & "}", UrlReplacements(key))
        Next
        ' Test to see is any failed by looking for any left over '{'
        If newUrl.Contains("{") Then
            ' If there are left over bits, then only do a Tempory redirect to the failed URL
            Me.RedirectMode = RedirectModeOption.Temporary
            My.Application.Log.WriteEntry(String.Format("Unable to locate a product url replacement for {0}", url), TraceEventType.Error, 19781)
            Return (String.Format(m_RedirectToOnFail, Me.Name, "NotFound", UrlReplacementsToQueryString(UrlReplacements)))
        End If
        ' Sucess, so do a perminant redirect to the new url.
        My.Application.Log.WriteEntry(String.Format("Redirecting {0} to {1}", url, newUrl), TraceEventType.Information, 19780)
        Me.RedirectMode = RedirectModeOption.Permanent
        Return newUrl.Replace("^", "")
    End Function

    Private Function GetUrlReplacements(ByVal match As Match) As Dictionary(Of String, String)
        Dim UrlReplacements As New Dictionary(Of String, String)
        Dim paramString As String = String.Empty
        ' Call database
        Using conn As New SqlConnection(m_ConnectionString)
            Try
                conn.Open()
                Dim cmd As New SqlCommand(m_parameterisedSql, conn)
                cmd.CommandType = CommandType.Text
                ' Get all the named groups from the regular expression and use them as the stored procedure parameters.
                Dim groupNames = From groupName In m_regex.GetGroupNames Where Not groupName = String.Empty And Not IsNumeric(groupName)
                ' Iterate through the named groups
                For Each groupName As String In groupNames
                    ' Add the name and value as input prameters to the stored procedure
                    cmd.Parameters.AddWithValue("@" & groupName, match.Groups(groupName).ToString)
                    paramString = paramString & "[@" & groupName & "=" & match.Groups(groupName).ToString & "]"
                    If UrlReplacements.ContainsKey(groupName) Then
                        UrlReplacements.Add(groupName, match.Groups(groupName).ToString)
                    Else
                        UrlReplacements(groupName) = match.Groups(groupName).ToString
                    End If
                Next
                ' Defigne the data capture method
                Dim sqlReader As SqlClient.SqlDataReader
                ' Execute the SQL
                sqlReader = cmd.ExecuteReader()
                If sqlReader.HasRows Then
                    Dim isDone As Boolean = False
                    Do While sqlReader.Read()
                        If isDone Then
                            ' If more than one record is returned, exit and record
                            My.Application.Log.WriteEntry(String.Format("Too many results from execution of '{0}' using parameters '{1}' on the connection '{2}'. Make sure your query only returns a single record.", m_parameterisedSql, paramString, m_ConnectionString), TraceEventType.Error, 19786)
                            Exit Do
                        End If
                        ' Add a sql output parameter for each outputParam (note: Must be NVarChar(255))
                        For i As Integer = 0 To sqlReader.FieldCount - 1
                            If UrlReplacements.ContainsKey(sqlReader.GetName(i)) Then
                                UrlReplacements.Add(sqlReader.GetName(i), sqlReader.GetValue(i).ToString)
                            Else
                                UrlReplacements(sqlReader.GetName(i)) = sqlReader.GetValue(i).ToString
                            End If
                        Next
                        isDone = True
                    Loop
                    sqlReader.Close()
                Else
                    My.Application.Log.WriteEntry(String.Format("No results from execution of '{0}' using parameters '{1}' on the connection '{2}'", m_parameterisedSql, paramString, m_ConnectionString), TraceEventType.Error, 19784)
                    UrlReplacements.Clear()
                    UrlReplacements.Add("results", "None")
                End If
            Catch ex As System.Data.SqlClient.SqlException
                My.Application.Log.WriteException(ex, TraceEventType.Error, String.Format("Unable to execute '{0}' using parameters '{1}' on the connection '{2}'", m_parameterisedSql, paramString, m_ConnectionString), 19783)
                UrlReplacements.Clear()
                UrlReplacements.Add("ex", "SqlException")
            Catch ex As Exception
                My.Application.Log.WriteException(ex, TraceEventType.Error, String.Format("Unable to connect using the connection '{0}'", m_ConnectionString), 19782)
                UrlReplacements.Clear()
                UrlReplacements.Add("ex", ex.GetType.ToString)
            End Try
        End Using
        Return UrlReplacements
    End Function

    Private Function UrlReplacementsToQueryString(ByVal dic As Dictionary(Of String, String)) As String
        Dim quer As String = String.Empty
        For Each dicEntry In dic
            quer = String.Format("{0}&{1}={2}", quer, dicEntry.Key, dicEntry.Value)
        Next
        Return quer
    End Function

End Class
```

Figure: Full source listing for the rule.

\----------

## TODO

What would I change and why…or things that I just did not have time to do.

### TODO: Add more configurable parameters

The lack of meta data will lead to limitations in the future and ultimately the duplication of code. The ideal solution would be something like the ASP.NET SqlDataSource configuration, with a nice UI.

```
<asp:SqlDataSource ID="SqlDataSource1" runat="server"
    CacheExpirationPolicy="Sliding"
    ConnectionString="MyConnectionString"
    EnableCaching="True"
    SelectCommand="ssw_proc_SeoProductIdToProductKey"
    SelectCommandType="StoredProcedure">
    <SelectParameters>
        <asp:RegexParameter DbType="StringFixedLength" DefaultValue="0"
            Name="ProductId" RegexGroupName="ProductId" Size="100" Type="String" />
        <asp:Parameter DbType="StringFixedLength" Direction="Output" Name="ProductKey"
            Size="255" Type="String" />
    </SelectParameters>
</asp:SqlDataSource>
```

Figure: Good Example, code from the ASP.NET 2.0 SqlDataSource.

You should be able to configure any set of input and output parameters.

### TODO: Retrieve a record and replace based on the columns

It may make more sense to return a single record and perform the replaces based on the columns that are returned. This may help to reduce complexity while increasing functionality.

### TODO: Add caching to improve performance

Caching is a difficult thing as it depends on the amount of data returned, but it can improve the speed.

Technorati Tags: [SSW](http://technorati.com/tags/SSW) [.NET](http://technorati.com/tags/.NET) [Software Development](http://technorati.com/tags/Software+Development) [CodeProject](http://technorati.com/tags/CodeProject) [SP 2010](http://technorati.com/tags/SP+2010) [SharePoint](http://technorati.com/tags/SharePoint)

