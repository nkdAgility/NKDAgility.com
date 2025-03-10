---
title: A Step-by-Step Guide to Installing TFS 2013 on Windows Server 2012 R2
description: Eager to install TFS 2013? Discover a step-by-step guide for a smooth setup on Windows Server 2012 R2, ensuring your environment is ready to go!
date: 2014-01-14T17:18:19Z
weight: 1000
ResourceId: U7wIQk1pus0
ResourceType: videos
ResourceImport: true
ResourceImportSource: Youtube
videoId: U7wIQk1pus0
url: /resources/videos/:slug
slug: a-step-by-step-guide-to-installing-tfs-2013-on-windows-server-2012-r2
layout: video
aliases:
- /resources/U7wIQk1pus0
- /resources/videos/a-step-by-step-guide-to-installing-tfs-2013-on-windows-server-2012-r2
- /resources/videos/install-tfs-2013-basic
aliasesArchive:
- /resources/videos/install-tfs-basic
- /resources/videos/install-tfs-2013-basic
- /resources/install-tfs-2013-basic
- /resources/videos/a-step-by-step-guide-to-installing-tfs-2013-on-windows-server-2012-r2
- a-step-by-step-guide-to-installing-tfs-2013-on-windows-server-2012-r2
preview: https://i.ytimg.com/vi/U7wIQk1pus0/maxresdefault.jpg
duration: 722
isShort: false
tags:
- Windows
sitemap:
  filename: sitemap.xml
  priority: 0.6
source: youtube
resourceTypes:
- video
categories: []

---
I recently received a request for a straightforward blog post on installing TFS 2013. It struck me that I hadn’t documented a basic out-of-the-box installation since around 2010, as I’ve mostly been focused on upgrades. So, I decided to create a new virtual machine on my Surface, and I thought I’d share the process with you. 

### Setting Up the Virtual Machine

1. **Memory Configuration**: 
   - I set the virtual machine's memory to a minimum of 2048 MB. TFS performs a check during installation, and if the memory is below this threshold, the installation will fail. I opted for dynamic memory to ensure that the VM only uses what it needs once it’s running.

2. **Operating System**: 
   - I chose Windows Server 2012 R2 for this installation. After starting the machine, I connected to it and began the basic installation of Windows. 

3. **Windows Installation**: 
   - I used the standard version of Windows Server 2012 R2 and entered my product key. It’s important to note that TFS is not supported on the core installation, so I selected the GUI version instead. 

4. **Initial Setup**: 
   - After the installation files were copied and the system rebooted, I logged in for the first time. The enhanced session mode in Windows 8.1 and Server 2012 R2 allowed me to adjust the resolution and copy-paste easily, which was a nice touch.

### Configuring the Virtual Machine

5. **Changing the Computer Name**: 
   - The system generates a random computer name, which I changed to ‘btar’. A quick reboot was necessary for this change to take effect.

6. **Processor and Network Settings**: 
   - I allocated two processors to the VM and added a private network adapter to improve performance and connectivity. 

7. **Domain Configuration**: 
   - I joined the machine to my domain (in this case, ‘nm.com’), which is a more realistic scenario for TFS installations, as most users will not be installing TFS in a workgroup environment.

### Installing TFS

8. **TFS Installation**: 
   - With the server now configured, I inserted my TFS installation disc. This was the RTM version of Team Foundation Server, and I was working with a completely blank server that had just joined the domain.

9. **SQL Server Considerations**: 
   - TFS includes a license for SQL Server Standard, but I opted to proceed with SQL Server Express, which TFS installs as part of the configuration process. 

10. **Installation Process**: 
    - The initial phase of the TFS installation involves copying files and registering DLLs. It’s worth noting that this step does not configure any third-party tools yet.

11. **Activation and Configuration**: 
    - After a brief wait, I activated the installation and was greeted by the standard installation wizard. I chose the basic installation option, which would set up Express and configure work item tracking, build services, and source control.

12. **Prerequisite Checks**: 
    - The wizard checks for system prerequisites, ensuring everything is in order before proceeding. This includes installing IIS, which is essential for TFS.

### Final Steps

13. **Completion**: 
    - After a few minutes, the installation completed successfully. I logged into TFS, where I found one collection with no team projects set up yet. I’ll tackle that part later.

### Conclusion

Installing TFS 2013 on a basic server configuration is quite straightforward, as I’ve outlined. This process is a great starting point for anyone looking to get TFS up and running in their environment. If you have any questions or need further assistance, feel free to reach out. Happy installing!
