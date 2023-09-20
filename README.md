# WindowsOSServicing
[![License][license-badge]][license]
[![PowerShell Gallery][psgallery-badge]][psgallery]
[![PowerShell Gallery Version][psgallery-version-badge]][psgallery]
[![Codacy Badge](https://app.codacy.com/project/badge/Grade/ec81538145f64de7ad264606ed790407)](https://www.codacy.com/gh/AshleyHow/WindowsOSServicing/dashboard?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=AshleyHow/WindowsOSServicing&amp;utm_campaign=Badge_Grade)
[![Build status](https://ci.appveyor.com/api/projects/status/o8l8510lkoo7igy1?svg=true)](https://ci.appveyor.com/project/ah-uk/WindowsOSServicing)

![alt text](https://github.com/AshleyHow/WindowsOSServicing/blob/main/WindowsOSServicing.png)

Gets WindowsOS servicing information to check if OS is currently serviced. Useful for scripting and automation purposes. Supports Windows 10 and Windows Server 2016 onwards.

## Installing the Module

### PowerShell Support

WindowsOSServicing supports Windows PowerShell 5.0, 5.1 and 7.0+.

### Install from the PowerShell Gallery

The WindowsOSServicing module is published to the PowerShell Gallery and can be found here: [WindowsOSServicing](https://www.powershellgallery.com/packages/WindowsOSServicing/). This is the best and recommend method to install WindowsOSServicing.

The module can be installed from the gallery with:

```powershell
Install-Module -Name WindowsOSServicing
```

### Updating the Module

If you have installed a previous version of the module from the gallery, you can install the latest update with `Update-Module` and the `-Force` parameter:

```powershell
Update-Module -Name WindowsOSServicing -Force
```

## Get-WindowsServicing Function

Gets Windows OS servicing information (OS Name, Version, Service start date, Service end date, Serviced, Lifecycle Policy URL) for for Windows client and server versions.

### Parameters

  - Caption
    
This parameter is optional. Return servicing information for specified operating system caption. Supported accepted values:
    

| Windows Client OS Captions                          |                                                                                    
| :-------------------------------------------------- | 
| Microsoft Windows 10 Home                           |
| Microsoft Windows 10 Pro                            |
| Microsoft Windows 10 Pro for Workstations           |
| Microsoft Windows 10 Pro Education                  |
| Microsoft Windows 10 Enterprise                     |
| Microsoft Windows 10 Education                      | 
| Microsoft Windows 10 Enterprise multi-session       |
| Microsoft Windows 10 Enterprise 2015 LTSB           |
| Microsoft Windows 10 Enterprise 2016 LTSB           |
| Microsoft Windows 10 Enterprise LTSC 2019           |
| Microsoft Windows 10 Enterprise LTSC 2021           |
| Microsoft Windows 11 Home                           |
| Microsoft Windows 11 Pro                            |
| Microsoft Windows 11 Pro for Workstations           |
| Microsoft Windows 11 Pro Education                  | 
| Microsoft Windows 11 Enterprise                     |
| Microsoft Windows 11 Education                      |
| Microsoft Windows 11 Enterprise multi-session       | 


| Windows Server OS Captions                          |
| :-------------------------------------------------- |
| Microsoft Windows Server Standard                   | 
| Microsoft Windows Server Datacenter                 | 
| Microsoft Windows Server 2016                       | 
| Microsoft Windows Server 2019                       |
| Microsoft Windows Server 2022                       |


   -  Version

This parameter is required if the operating system has multiple versions such as Windows 10 or 11. Not required if using the CurrentVersion parameter.

   - CurrentVersion
   
This parameter is optional. Returns servicing information for the installed version.

## Usage

Show Windows OS servicing information for installed version of the operating system.
```powershell
Get-WindowsServicing -CurrentVersion
```
Show Windows OS servicing information for Microsoft Windows 10 Pro Version 22H2.
```powershell
Get-WindowsServicing -Caption "Microsoft Windows 10 Pro" -Version "22H2"
```
Show Windows OS servicing information for Microsoft Windows Server 2022.
```powershell
Get-WindowsServicing -Caption "Microsoft Windows Server 2022"
```

## Output

```powershell
PS C:\Users\Ashley> Get-WindowsServicing -CurrentVersion


Name                 : Microsoft Windows 10 Pro
Version              : 22H2
Service start date   : 2022-10-18
Service end date     : 2025-10-15
Serviced             : Yes
Lifecycle Policy URL : https://learn.microsoft.com/en-us/lifecycle/products/windows-10-home-and-pro
```

```powershell
PS C:\Users\Ashley> . Get-WindowsServicing -Caption "Microsoft Windows 11 Pro" -version 22H2


Name                 : Microsoft Windows 11 Pro
Version              : 22H2
Service start date   : 2022-09-20
Service end date     : 2024-10-09
Serviced             : Yes
Lifecycle Policy URL : https://learn.microsoft.com/en-us/lifecycle/products/windows-11-home-and-pro
```

```powershell
PS C:\Users\Ashley> . Get-WindowsServicing -Caption "Microsoft Windows Server 2022"


Name                 : Microsoft Windows Server 2022
Version              : NA
Service start date   : 2021-08-18
Service end date     : 2031-10-15
Serviced             : Yes
Lifecycle Policy URL : https://learn.microsoft.com/en-us/lifecycle/products/windows-server-2022
```

## Who

This module is maintained by the following

* Ashley How, [@AshleyHow1](https://twitter.com/AshleyHow1)

[psgallery-badge]: https://img.shields.io/powershellgallery/v/WindowsOSServicing.svg?logo=PowerShell&style=flat-square
[psgallery]: https://www.powershellgallery.com/packages/WindowsOSServicing
[psgallery-version-badge]: https://img.shields.io/powershellgallery/dt/WindowsOSServicing.svg?logo=PowerShell&style=flat-square
[license-badge]: https://img.shields.io/github/license/AshleyHow/WindowsOSServicing.svg?style=flat-square
[license]: https://github.com/AshleyHow/WindowsOSServicing/blob/main/LICENCE
