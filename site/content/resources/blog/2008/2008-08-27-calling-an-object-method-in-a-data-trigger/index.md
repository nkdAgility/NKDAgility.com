---
title: Calling an object method in a data trigger
description: "Learn how to call object methods in WPF data triggers effectively. This guide simplifies the process, helping you enhance your coding skills with practical examples."
date: 2008-08-27
creator: Martin Hinshelwood
id: "205"
layout: blog
resourceType: blog
slug: calling-an-object-method-in-a-data-trigger
aliases:
  - /blog/calling-an-object-method-in-a-data-trigger
tags:
  - code
  - tools
  - wpf
categories:
  - code-and-complexity
preview: metro-binary-vb-128-link-1-1.png
---

Calling a method on an instance of an object in WPF is not as easy to figure out, but with the help of this Internet thing I managed it.

Say you have a DataTemplate that renders a WorkItemType as a button that is selectable:

```
   1: <DataTemplate DataType="{x:Type tfswitc:WorkItemType}">
```

```
   2:     <DockPanel>
```

```
   3:         <Image DockPanel.Dock="Left"
```

```
   4:                x:Name="wiImage"
```

```
   5:                Width="16"
```

```
   6:                Height="16"
```

```
   7:                Source="pack://application:,,/Resources/Images/WorkItems/unknown.gif">
```

```
   8:         </Image>
```

```
   9:         <Button x:Name="wiButton"
```

```
  10:                 Content="{Binding Name}"
```

```
  11:                 Style="{DynamicResource WelcomeButtonStyle}"
```

```
  12:                 CommandParameter="{Binding}"
```

```
  13:                 Command="Controlers:TeamSystemCommands.ChangeWorkItemTypeCommand">
```

```
  14:         </Button>
```

```
  15:     </DockPanel>
```

```
  16: </DataTemplate>
```

Now, if I wanted to call a method on an instance of that WorkItemType and perform some action, then I would need a DataTrigger:

```
   1: <DataTemplate DataType="{x:Type tfswitc:WorkItemType}">
```

```
   2:     <DockPanel>
```

```
   3:         <Image DockPanel.Dock="Left"
```

```
   4:                x:Name="wiImage"
```

```
   5:                Width="16"
```

```
   6:                Height="16"
```

```
   7:                Source="pack://application:,,/Resources/Images/WorkItems/unknown.gif">
```

```
   8:         </Image>
```

```
   9:         <Button x:Name="wiButton"
```

```
  10:                 Content="{Binding Name}"
```

```
  11:                 Style="{DynamicResource WelcomeButtonStyle}"
```

```
  12:                 CommandParameter="{Binding}"
```

```
  13:                 Command="Controlers:TeamSystemCommands.ChangeWorkItemTypeCommand">
```

```
  14:         </Button>
```

```
  15:     </DockPanel>
```

```
  16:     <DataTemplate.Triggers>
```

```
  17:         <DataTrigger Value="False">
```

```
  18:             <DataTrigger.Binding>
```

```
  19:                 <Binding>
```

```
  20:                     <Binding.Source>
```

```
  21:                         <ObjectDataProvider ObjectType="{x:Type tfswitc:WorkItemType}"
```

```
  22:                                             MethodName="SupportedByHeat" />
```

```
  23:                     </Binding.Source>
```

```
  24:                 </Binding>
```

```
  25:             </DataTrigger.Binding>
```

```
  26:             <Setter TargetName="wiButton"
```

```
  27:                     Property="IsEnabled"
```

```
  28:                     Value="False" />
```

```
  29:             <Setter TargetName="wiButton"
```

```
  30:                     Property="ToolTip"
```

```
  31:                     Value="You will need to add the 'HeatITSM.Ref' field to use this work item." />
```

```
  32:         </DataTrigger>
```

```
  33:     </DataTemplate.Triggers>
```

```
  34: </DataTemplate>
```

This will Call the method and if it returns false, it will disable the button and set a tooltip.

Now, this should work, but my SupportedByHeat method is an Extension method defined as:

```
   1: Imports Microsoft.TeamFoundation.WorkItemTracking.Client
```

```
   2: 
```

```
   3: Namespace TeamFoundationExtensions
```

```
   4: 
```

```
   5: 
```

```
   6:     Module WorkItemTypeExtensions
```

```
   7: 
```

```
   8:         <System.Runtime.CompilerServices.Extension()> _
```

```
   9:       Public Function SupportedByHeat(ByVal wit As WorkItemType) As Boolean
```

```
  10:             Dim c As Controlers.TeamSystemControler(Of MainWindow)
```

```
  11:             c = Application.ControlerFactory.GetControler(Of Controlers.TeamSystemControler(Of MainWindow))()
```

```
  12:             Return c.CheckWorkItemField(wit)
```

```
  13:         End Function
```

```
  14: 
```

```
  15:     End Module
```

```
  16: 
```

```
  17: End Namespace
```

And this does not seam to work even if I import the namespace in the XAML:

```
   1: <UserControl x:Class="SelectWorkItemType"
```

```
   2:   xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
```

```
   3:   xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
```

```
   4:   xmlns:d="http://schemas.microsoft.com/expression/blend/2006"
```

```
   5:   xmlns:tfs="clr-namespace:Microsoft.TeamFoundation.Client;assembly=Microsoft.TeamFoundation.Client"
```

```
   6:   xmlns:tfswitc="clr-namespace:Microsoft.TeamFoundation.WorkItemTracking.Client;assembly=Microsoft.TeamFoundation.WorkItemTracking.Client"
```

```
   7:   xmlns:tfse="clr-namespace:Hinshelwood.TFSHeatITSM.TeamFoundationExtensions"
```

```
   8:   xmlns:local="clr-namespace:Hinshelwood.TFSHeatITSM"
```

```
   9:   xmlns:Controlers="clr-namespace:Hinshelwood.TFSHeatITSM.Controlers"
```

```
  10:   xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
```

```
  11:   mc:Ignorable="d">
```

The error message that is received is:

> _System.Windows.Data Error: 34 : ObjectDataProvider: Failure trying to invoke method on type; Method='SupportedByHeat'; Type='WorkItemType'; Error='No method was found with matching parameter signature.' MissingMethodException:'System.MissingMethodException: Method 'Microsoft.TeamFoundation.WorkItemTracking.Client.WorkItemType.SupportedByHeat' not found.  
>    at System.RuntimeType.InvokeMember(String name, BindingFlags bindingFlags, Binder binder, Object target, Object\[\] providedArgs, ParameterModifier\[\] modifiers, CultureInfo culture, String\[\] namedParams)_
>
> \_at System.Type.InvokeMember(String name, BindingFlags invokeAttr, Binder binder, Object target, Object\[\] args, CultureInfo culture)
>
> at System.Windows.Data.ObjectDataProvider.InvokeMethodOnInstance(Exception& e)'\_

As you can see, during the binding the extension method is not evaluated.

During my investigation I came across [WPFix Part 3 (Extension Methods)](http://www.fikrimvar.net/lestirelim/?p=23) that intoned that there is indeed some solution, but it is complicated requiring the use of Lambda expressions.

I am looking for an easy solution :)

Technorati Tags: [.NET](http://technorati.com/tags/.NET) [WPF](http://technorati.com/tags/WPF) [WIT](http://technorati.com/tags/WIT) [TFS](http://technorati.com/tags/TFS)

