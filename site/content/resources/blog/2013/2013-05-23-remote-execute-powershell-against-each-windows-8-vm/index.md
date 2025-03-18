---
title: Remote Execute PowerShell against each Windows 8 VM
description: Learn how to remotely execute PowerShell scripts on Windows 8 VMs using Hyper-V, streamlining updates and management with minimal effort.
ResourceId: T_5NKsLxoK7
ResourceType: blog
ResourceContentOrigin: Human
ResourceImport: true
ResourceImportId: 9901
ResourceImportSource: Wordpress
ResourceImportOriginalSource: Wordpress
date: 2013-05-23
weight: 1000
creator: Martin Hinshelwood
layout: blog
resourceTypes: blog
slug: remote-execute-powershell-against-each-windows-8-vm
aliases:
- /blog/remote-execute-powershell-against-each-windows-8-vm
- /remote-execute-powershell-against-each-windows-8-vm
- /resources/T_5NKsLxoK7
- /resources/blog/remote-execute-powershell-against-each-windows-8-vm
aliasesArchive:
- /blog/remote-execute-powershell-against-each-windows-8-vm
- /remote-execute-powershell-against-each-windows-8-vm
- /resources/blog/remote-execute-powershell-against-each-windows-8-vm
tags:
- Windows
- Install and Configuration
- Practical Techniques and Tooling
- Software Development
- System Configuration
categories:
- DevOps
preview: image11-1-1.png

---
Running a remote execute PowerShell against each Windows 8 VM on your Hyper-V host can help you maintain the guest VM's in a minimal amount of time.

With all of the work going on at the office around PowerShell I wanted to have a go and solve another problem I have. I kept running into an issue when using Hyper-V on my local computer. Every so often, to keep them relent, I need to boot each of the virtual machines and run windows updates. My first thought was to create a PowerShell that would update the them automatically, by then I thought… why can’t I push the script out to each of them.

- DONE Remote Execute PowerShell against each VM
- DONE Execute PowerShell against VM

This will require two distinct Scripts.

## Remote Execute against each VM

I am using Windows 8 with Hyper-V so all of the virtual machines are local. So the first step is to get a list of the VM’s and loop though them.

```
$VMs = Get-VM
foreach ($vm in $VMs)
{
    Write-Host  " $($vm.Name)" -ForegroundColor Yellow
}

```

Note Watch out as Get-VM does not error out when you are not running under elevated privileges it just returns no machines. Now that vexed me for a while.

You can combat this by doing a check for elevated privileges and starting a new elevated process if your are not currently running in elevated mode.

```
If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{
    $arguments = "& '" + $myinvocation.mycommand.definition + "'"
    Start-Process powershell -Verb runAs -ArgumentList $arguments
    Break
}

```

We will see how this works out remotely, but that's for later.

So for each VM we can now execute something. However, what I want to do is run the script on my host (My main computer) and have it execute a portion of that script on the VM. For this I choose to have a separate ps1 file that did all of the local actions. There are really two ways to do this, first with a “\[remote region\]” that executes anything within that code block on the remote VM and second with a “Invoke-Command -ComputerName \[computerName\]”. The former sounds like it will complicate my scripts, making them too long, so I went with the latter. “Invoke-Command” has an option to pass another ps1 that does the actual execution which in turn allows me test that script separately.

So what do I end up with?

```
Try{
    Invoke-Command -ComputerName $compName -ScriptBlock {Set-ExecutionPolicy Unrestricted} -Credential $Cred
    Invoke-Command -ComputerName $compName -FilePath $RemoteScript -Credential $Cred
}

catch {
    "any other undefined errors"
    $error[0]
}

```

You will note that I have set the execution policy to ‘unrestricted’ prior to executing the code. As I am not signing the PowerShell scripts I need to do that in order to get them to run. Although all of the guest VM’s are within a domain my local computer, the one running the master script, is not. This does pose a number of interesting issues that means that you need to pass a ‘-Credential’ object into the invoke method.

```
$Username = 'nakedalmmrhinsh'
$Password = 'P2ssw0rd'
$pass = ConvertTo-SecureString -AsPlainText $Password -Force
$Cred = New-Object System.Management.Automation.PSCredential -ArgumentList $Username,$pass

```

This object will then allow the ‘Invoke-Command’ to authenticate correctly with the remote server. However the first time that you run this script you might get an error because the local computer is not trusted. If it was joined to the domain this would not be an issue but as it is in a workgroup the domain joined VM will reject you.

```
Set-Item wsman:localhostclienttrustedhosts *

```

Just run the above on the VM to prep it or you can explicitly trust the host name. As these are all demo and not production VM’s I am not particularly worried about locking them down.

Now we can loop through the VM’s and execute a remote script against them. This then sounds like we are nearly done, however what happens when the VM’s are off or saved or paused. Well… nothing as you can’t execute a script against a machine that is not running. I needed to find a way to start the machines and luckily hyper-v can be totally managed by PowerShell and thus there is a command for that. The current state of the machine is stored in “$vm.State” which has a number of vaues that we need to do different things for.

```
switch ($vm.State)
{
     default {
          Write-Host  " Don't need to do anything with $($compName) as it is $($vm.State) "
     }
     "Paused"
     {
          Write-Host  "$($vm.Name) is paused so making it go "
          Resume-VM –Name *$compName* -Confirm:$false
     }
     "Saved"
     {
          Write-Host  "$($vm.Name) is paused so making it go "
          Start-VM –Name *$compName* -Confirm:$false
      }
     "Off"
     {
          Write-Host  "$($vm.Name) is stopped so making it go "
          Start-VM –Name *$compName* -Confirm:$false
     }
}

```

Here I use a case statement to choose what to do with each VM based on its current state. Therefore if it is ‘paused’ I need to ‘resume’ it to the running state. In addition I also store the current state in a variable so that I can reset each VM to its original state after I have run the script. This would allow me to boot each VM in turn rather than all at one and thus not overload my local computer.

So there is one last thing to do. When you change the state of  VM using “Start-VM” it can take some time to load. You could guess and insert a delay but what if the VM takes a long time to do a group policy update or maybe a windows update needs to finish.

```
do {
     Start-Sleep -milliseconds 100
     Write-Progress -activity "Waiting for VM to become responsive" -SecondsRemaining -1
}
until ((Get-VMIntegrationService $vm | ?{$_.name -eq "Heartbeat"}).PrimaryStatusDescription -eq "OK")
Write-Progress -activity "Waiting for VM to become responsive" -SecondsRemaining -1 -Completed

```

So I monitor the ‘heartbeat’ of the VM to determine when it becomes available. This will return “OK” once the VM has booted far enough to start responding to Hyper-V. This should mean that the VM will now be responsive to commands. As this can take some time I also want some sort of progress bar to be visible to let anyone monitoring the script know that we are waiting. There is a built in ‘Write-Progress’ command that lets us do this and it renders in the appropriate form for the medium that the script is executing in.

```
$Username = 'nakedalmmrhinsh'
$Password = 'P2ssw0rd'
$nameRegex = "[d*][(?.*)](?.*)[(?.*)]"
$RemoteScript = D:DataUsersMrHinshDesktopcmdService-VM.ps1
#------------------------------------------------------------------------
If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{
    $arguments = "&amp; '" + $myinvocation.mycommand.definition + "'"
    Start-Process powershell -Verb runAs -ArgumentList $arguments
    Break
}
#------------------------------------------------------------------------
$pass = ConvertTo-SecureString -AsPlainText $Password -Force
$Cred = New-Object System.Management.Automation.PSCredential -ArgumentList $Username,$pass
$confirm = $false
$VMs = Get-VM
Write-Output "Found $($VMs.Count) virtual computers"
foreach ($vm in $VMs)
{
    Write-Host  "Execute for $($vm.Name)" -ForegroundColor Yellow
    $matches = [Regex]::Matches($vm.Name,$nameRegex)
    if ($matches.count -gt 0)
    {
        $compName = $matches[0].groups["name"].value.Trim()

        $startState = $vm.State
        switch ($vm.State)
        {
            default {

               Write-Host  " Don't need to do anything with $($compName) as it is $($vm.State) "
            }
            "Paused"
            {
                Write-Host  "$($vm.Name) is paused so making it go "
                Resume-VM –Name *$compName* -Confirm:$false
            }
            "Saved"
            {
                Write-Host  "$($vm.Name) is paused so making it go "
                Start-VM –Name *$compName* -Confirm:$false
            }
            "Off"
            {
                 Write-Host  "$($vm.Name) is stopped so making it go "
                 Start-VM –Name *$compName* -Confirm:$false
            }
        }

        Write-Host  " Waiting for '$($compName)' to respond "
        do {
                Start-Sleep -milliseconds 100
                Write-Progress -activity "Waiting for VM to become responsive" -SecondsRemaining -1
            }
        until ((Get-VMIntegrationService $vm | ?{$_.name -eq "Heartbeat"}).PrimaryStatusDescription -eq "OK")
        Write-Progress -activity "Waiting for VM to become responsive" -SecondsRemaining -1 -Completed


        Write-Host  " Remote execution for '$($compName)' :) "

        Try{
            Invoke-Command -ComputerName $compName -ScriptBlock {Set-ExecutionPolicy Unrestricted} -Credential $Cred
            Invoke-Command -ComputerName $compName -FilePath $RemoteScript -Credential $Cred
        }

        catch {
            "any other undefined errors"
            $error[0]
        }

         switch ($startState)
        {
            "Off"
            {
                Stop-VM  –Name *$compName* -Force -Confirm:$false
            }
            "Paused"
            {
                Suspend-VM –Name *$compName* -Confirm:$false
            }
            "Saved"
            {
                Save-VM –Name *$compName* -Confirm:$false
            }
            default {

                Write-Host  " Leaving $($compName) running $startState "
            }
        }

    }
    else
    {
        Write-Host  "Unable to determin name of $($vm.Name) as it is in a crappy format. Needs to be '$nameRegex'" -ForegroundColor Red
    }
}
```

Be warned that this is my first pass at this script and more scarily my first actual PowerShell script. As such I have no idea if this is the right way to do things, but it does seam to work. It lets you execute another PowerShell script against each of my VM’s.

## Execute against VM

The second script that I need will do all of the work to configure and update the VM after it has been started. This will be a remote execution script that installs anything that it needs as well as getting and installing all of the outstanding Microsoft Updates.

```
Param(
  [string]$computerName = $env:COMPUTERNAME
)
If (!(Test-Path C:Chocolatey))
{
    Write-Host  " Install Chocolatey "
    iex ((new-object net.webclient).DownloadString("http://bit.ly/psChocInstall"))
}
Else
{
    chocolatey update
}
cinst enablepsremoting
cinst PSWindowsUpdate -Version 1.4.6
Write-Output "--SERVICE"
Write-Output "-Allow ping for whatever"
netsh advfirewall firewall add rule name="All ICMP V4" dir=in action=allow protocol=icmpv4
Write-Output "-Enable File and Print Sharing for possible Lab Management use"
netsh advfirewall firewall set rule group=”File and Printer Sharing” new enable=Yes
Write-Output "-Check all Updates"
Import-Module PSWindowsUpdate
Get-WUInstall -MicrosoftUpdate -IgnoreUserInput -acceptall -autoreboot -verbose

```

I will likely go though a bunch more iterations on this script but for right now it:

1. Makes sure that Chocolatey is installed
2. Installed Chocolatey packages including ‘PSWindowsUpdate’
3. Validates some firewall changes that I need
4. Downloads and installs all Microsoft Updates

This may change and I want to test out some hierarchical PowerShell script option, but until then this makes it easy to update all of my VM’s.

## Conclusion

Although I have tinkered with PowerShell now and then this is the first executable script that I have written. I am still in copy/paste mode but I can sure see the value of learning and using PowerShell for everything from installing applications to configuring systems.

You can just about do anything with PowerShell that you like.
