---
title: Convert Legacy Projects and ASP.NET MVC Apps to SDK-Style with Confidence
short_title: Convert Legacy .NET and ASP.NET MVC to SDK-Style
description: Learn how to upgrade legacy .NET and ASP.NET MVC projects to SDK-style for easier builds, modern tooling, and future readiness, including tips for class libraries and web apps.
tldr: Upgrading legacy .NET projects to SDK-style makes your codebase easier to maintain, improves build and CI/CD integration, and prepares you for future .NET upgrades. Converting class libraries is straightforward and highly recommended, while web apps require more care and are best handled with the MSBuild.SDK.SystemWeb package if you want SDK-style; otherwise, you can leave them in the old format. Start by converting class libraries now to simplify your engineering system and reduce technical debt.
date: 2025-05-29T09:00:00Z
lastmod: 2025-05-29T09:00:00Z
weight: 350
sitemap:
  filename: sitemap.xml
  priority: 0.6
  changefreq: weekly
ItemId: 2mdv7QE2nIt
ItemType: engineering-notes
ItemKind: resource
ItemContentOrigin: human
slug: convert-legacy-projects-and-asp-net-mvc-apps-to-sdk-style-with-confidence
aliases:
  - /resources/2mdv7QE2nIt
concepts:
  - Tool
categories:
  - Engineering Excellence
tags:
  - Software Development
  - Install and Configuration
  - Pragmatic Thinking
  - Technical Mastery
  - System Configuration
  - Engineering Practices
  - Operational Practices
  - Troubleshooting
  - Application Lifecycle Management
Watermarks:
  description: 2025-05-07T15:00:14Z
  short_title: 2025-07-07T16:43:54Z
  tldr: 2025-08-07T12:29:17Z
ResourceId: 2mdv7QE2nIt
ResourceType: engineering-notes

---
I’ve been working with a customer who, like many, is stuck in the past. They were on Team Foundation Version Control (TFVC), and the backbone of their application is .NET 4.5. This creates real problems for modern engineering practices because many new tools just won’t work, so I am moving to Git, and as part of that looking to ensure that their setup is future ready. I also need to do something with all those peskie legacy DLLs that are scattered around the solution. One of the key upgrades I was looking at is moving to SDK-style projects. This is a big deal because it’s the future of .NET development, and it’s a lot easier to work with than the old project format.

The good news: you can move to SDK-style projects even if you’re targeting older .NET versions.

For the Azure DevOps Migration Tools, a contributor did the upgrade, and the capabilities are outstanding:

- Simpler project file format – no more messy MSBuild clutter
- Supports `Directory.Build.props` to consolidate configuration across the solution
- Supports `Directory.Packages.props` to consolidate NuGet versions and avoid DLL hell
- Builds with `dotnet build` (your mileage may vary)

Additional reasons to move to SDK-style projects:

- Easier multi-targeting support
- Better integration with modern CI/CD pipelines
- Cleaner diffs in source control
- Consistent experience across .NET Core, .NET 5+, and .NET Framework
- Improved support for analyzers and code quality tools
- Faster restore and build times in many cases

The Azure DevOps Migration Tools combine class libraries and executables, with a mix of .NET 4.8.1, netstandard2.0, and net8.0 – they all have to interoperate smoothly.

SDK-style `.csproj` files simplify your build system, cut the clutter, and prepare you for future upgrades. Here’s the pragmatic reality: Microsoft does not officially support converting classic ASP.NET MVC/WebForms projects to SDK-style. Class libraries? Straightforward. Web apps? That takes discipline, skill, and a willingness to dive into the details. With the right approach, you can absolutely get this working and keep IIS Express debugging alive.

Let’s break it down with radical clarity.

## Class Library Conversion – No-Brainer

Class libraries are the easy win. They have minimal impact on code but make it massively easier to organise and maintain.

- Use .NET Upgrade Assistant or `try-convert`
  Automate the rewrite:

  ```shell
  try-convert -p YourProject.csproj --keep-current-tfms --no-backup
  ```

  This keeps you on `net481` but upgrades the project format.

- Manual option if you want full control:

  ```xml
  <Project Sdk="Microsoft.NET.Sdk">
    <PropertyGroup>
      <TargetFramework>net481</TargetFramework>
    </PropertyGroup>
  </Project>
  ```

- Switch from `packages.config` to `<PackageReference>`
  Drop the legacy baggage.

- Test thoroughly. Rebuild, run tests, and make sure everything resolves. This is not the time to skip CI.

In my experience, the "right-click on project" → Upgrade option in Visual Studio also works well.

## ASP.NET MVC/WebForms Conversion – Tread Carefully

This is where it gets tricky. There’s no official support for MVC/WebForms in SDK projects, and it’s like wrestling a bear to get it all working.

There are two practical approaches:

### 1. Use the Community MSBuild SDK (Recommended)

- Convert with:

  ```shell
  try-convert -p YourWebApp.csproj --keep-current-tfms --no-backup --force-web-conversion
  ```

- Change the SDK line:

  ```xml
  <Project Sdk="MSBuild.SDK.SystemWeb/4.0.97">
  ```

Why this works:

- Adds the missing web build magic (`System.Web`, Razor, content files)
- Supports F5 debugging, publishing, transforms
- Keeps you close to classic Visual Studio behaviour

Keep an eye on [MSBuild.SDK.SystemWeb on GitHub](https://github.com/CZEMacLeod/MSBuild.SDK.SystemWeb) for updates.

### 2. Manual Tweaks Without External SDK

- Set the output correctly:

  ```xml
  <OutputType>Library</OutputType>
  <OutputPath>bin\</OutputPath>
  <AppendTargetFrameworkToOutputPath>false</AppendTargetFrameworkToOutputPath>
  ```

- Define the run command:

  ```xml
  <RunCommand>$(MSBuildExtensionsPath64)\..\IIS Express\iisexpress.exe</RunCommand>
  <RunArguments>/path:"$(MSBuildProjectDirectory)" /port:YOUR_PORT</RunArguments>
  ```

- Check or add launchSettings.json, but note that Visual Studio often ignores it without the `RunCommand` fix.

Recommendation: Don’t waste time fighting Visual Studio. Use SystemWeb SDK if you want a sustainable setup.

## Debugging Survival Guide

Debugging can be a pain, and in complex apps, it’s still hit-or-miss. But here’s what typically works:

If you get the "RunCommand not set" error, add `<RunCommand>` and `<RunArguments>` in your .csproj. This tells Visual Studio how to launch IIS Express.

If you see the “Debugging Release build” warning, go to Project > Build and uncheck “Optimize code” in Debug. Also, confirm `<Optimize>false</Optimize>` is set in the .csproj and do a full clean and rebuild.

If you’re attaching to a running process, enable “Suppress JIT optimization on module load” in the Visual Studio debugging options. This will let you step through code without the headache of optimized binaries.

Finally, check that your PDB files are loaded. Open the Modules window during debugging and make sure the symbols are picked up from your output directory. Without them, breakpoints won’t bind, and you’re debugging blind.

## Known Limitations

Some things just won’t come back. The "Web" tab in the project properties is gone, but you can configure everything you need using the .csproj and launchSettings.

Out-of-the-box publish won’t work because it expects a .NET 5+ project. You’ll need to script your own publish steps to get the bits into the right place.

If needed, you can leave web apps in the old format and just convert the class libraries. That’s a pragmatic call if you’re not planning to touch System.Web long-term.

## Final Recommendations

Here’s where it all comes together. These are the pragmatic, no-nonsense calls you should make after working through the conversion process.

- Convert class libraries: Yes, immediately.
- Convert web apps:

  - Use MSBuild.SDK.SystemWeb if you want SDK-style.
  - Skip if you’re staying on .NET Framework and want zero friction.

The point of this work isn’t to show off modern `.csproj` files. It’s to make your engineering system simpler, more maintainable, and ready for what’s next.
