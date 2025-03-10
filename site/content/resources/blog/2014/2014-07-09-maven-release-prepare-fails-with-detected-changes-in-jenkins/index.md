---
title: Maven release prepare fails with detected changes in Jenkins
description: Discover how to resolve Maven release prepare failures in Jenkins due to detected changes. Learn to use .tfignore for smoother TFS integration.
ResourceId: gtoRjWgSmKe
ResourceType: blog
ResourceImport: true
ResourceImportId: 10579
ResourceImportSource: Wordpress
ResourceImportOriginalSource: Wordpress
date: 2014-07-09
weight: 720
creator: Martin Hinshelwood
layout: blog
resourceTypes: blog
slug: maven-release-prepare-fails-with-detected-changes-in-jenkins
aliases:
- /blog/maven-release-prepare-fails-with-detected-changes-in-jenkins
- /maven-release-prepare-fails-with-detected-changes-in-jenkins
- /resources/gtoRjWgSmKe
- /resources/blog/maven-release-prepare-fails-with-detected-changes-in-jenkins
aliasesArchive:
- /blog/maven-release-prepare-fails-with-detected-changes-in-jenkins
- /maven-release-prepare-fails-with-detected-changes-in-jenkins
- /resources/blog/maven-release-prepare-fails-with-detected-changes-in-jenkins
tags:
- Practical Techniques and Tooling
- Windows
- Modern Source Control
- Continuous Integration
- Release Management
- Pragmatic Thinking
- Software Development
- System Configuration
- Technical Mastery
- Troubleshooting
categories:
- DevOps
preview: naked-alm-jenkins-logo-9-9.png

---
If you are using Team Explorer Everywhere 2012 or 2013 your Maven release prepare fails with detected changes, however it worked when you were using SVN.

As you may have noticed I have had a few posts on Jenkins integration with TFS recently. My current customer is migrating away from SVN and Jenkins to TFS 2012 to take advantage of the cool ALM feature however we need to stage in, taking one thing at a time. They have quite a few builds in Jenkins and moving them will take time. The idea is that we can move all of the source over and it is a fairly simple process to re-point Jenkins and Maven to TFS. This allows the teams to take advantage of relating their Source and Work Item while allowing us to create parallel builds and validate the output.

[![image[2]](images/image2_thumb-3-3.png "image[2]")](http://nkdagility.com/wp-content/uploads/2014/06/image2-4-4.png)
{ .post-img }

Our initial problem was around [Configuring Jenkins to talk to TFS 2013](http://nkdagility.com/configuring-jenkins-talk-tfs-2013/) and then [Mask password in Jenkins when calling TEE](http://nkdagility.com/mask-password-in-jenkins-when-calling-tee/). As with all migration projects you get past one problem and get hit by another. The next issue was that the Release builds would always fail. Looking at the logs it is obvious why.

```
[INFO] Command line - /bin/sh -c cd /appl/data/ci-test/jenkins/jobs/TFS-TestProject/workspace && tf status -login:username,********** -recursive -format:detailed '$/main/VisualStudioALM/JavaTestProject'
[DEBUG] line -
[DEBUG] line --------------------------------------------------------------------------------
[DEBUG] line -Detected Changes:
[DEBUG] line --------------------------------------------------------------------------------
[DEBUG] line -$/main/VisualStudioALM/JavaTestProject/release.properties
[DEBUG] line -  User:       Martin Hinshelwood (MrHinsh)
[DEBUG] line -  Date:       22-May-2014 14:33:52
[DEBUG] line -  Lock:       none
[DEBUG] line -  Change:     add
[DEBUG] line -  Workspace:  Hudson-TFS-TestProject-MASTER
[DEBUG] line -  Local item: [zsts490716.eu.company.com] /appl/data/ci-test/jenkins/jobs/TFS-TestProject/workspace/release.properties
[DEBUG] line -
[DEBUG] line -0 change(s), 1 detected change(s)
[INFO] err -
[DEBUG] Iterating
[DEBUG] /appl/data/ci-test/jenkins/jobs/TFS-TestProject/workspace/release.properties:added

```

Here the release build is checking for changes after a get to validate the output and it finds a "release.properties" file sitting there. Now in the days of Server workspaces where you had to explicitly check out from the server you would not even see an issue. The file would not even be detected let alone pended to the server unless you ran a specific command. In the wonderful world of Local workspaces where changes to local workspaces are detected automatically this is an issue.

We need some way to tell TFS that we want it to ignore these release.properties files. Well, the TFS team thought of this and have added .tfignore files that operate just like the .gitignore one that you might be used to. However adding a .whatever files does not seem to be very easy in Widnows.

[![image[5]](images/image5_thumb-5-5.png "image[5]")](http://nkdagility.com/wp-content/uploads/2014/06/image5-6-6.png)
{ .post-img }

My first attempts to add the file resulted in a "you must type a file name" error and no matter what I did I could not get that .tfignore file created. I headed to the internet and eventually found that while you are blocked in Explorer you can open notepad and save a file of the required name. That’s a little poopy but needs must. I guess only power users really need to create files that begin with a dot and this protects the rest of them.

[![image[8]](images/image8_thumb-7-7.png "image[8]")](http://nkdagility.com/wp-content/uploads/2014/06/image8-8-8.png)
{ .post-img }

So we create and add a .tfignore file with a line that matches the pattern we want to ignore. Just listing the explicit file name will result in all instances, recursively, being ignored.

```
######################################
# Ignore all release files from Maven release process
release.properties
```

You can get quite complicated with this file but here I have very simple needs. To get the file into TFS the easyest way is to go to the folder where you want it in your local workspace and add it to the file system. We then need to right click in the empty space of the folder and select "Add Files to folder" which will pop the "Add to Source Control" dialog above with any files listed that it can't see already. If you have the Power Tools installed you can also just right-click the file and add it to source control right from Windows explorer.

[![image[11]](images/image11_thumb-1-1.png "image[11]")](http://nkdagility.com/wp-content/uploads/2014/06/image11-2-2.png)
{ .post-img }

There may be other files that you need to ignore and I ended up with:

```
######################################
# Ignore all release files from Maven release process
release.properties
*.releaseBackup
target/

```

All we need to do now is execute a new build and see that light turn green. This is however a "dry run" build and we still have some work to do to get the rest of the process working, however this is progress. At least I don’t have generated files ruining my day.
