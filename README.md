# WindowsOSBuild

[![License][license-badge]][license]
[![PowerShell Gallery][psgallery-badge]][psgallery]
[![PowerShell Gallery Version][psgallery-version-badge]][psgallery]

Module for Windows OS Build management. Functions to obtain currently installed OS Build number and the latest available OS Build number/s from Windows Update. Supports Windows 10 and associated Windows Server versions only.

https://www.powershellgallery.com/packages/WindowsOSBuild

[psgallery-badge]: https://img.shields.io/powershellgallery/v/WindowsOSBuild.svg?logo=PowerShell&style=flat-square
[psgallery]: https://www.powershellgallery.com/packages/WindowsOSBuild
[psgallery-version-badge]: https://img.shields.io/powershellgallery/dt/WindowsOSBuild.svg?logo=PowerShell&style=flat-square
[psgallery-version]: https://www.powershellgallery.com/packages/WindowsOSBuild
[license-badge]: https://img.shields.io/github/license/AshleyHow/WindowsOSBuild.svg?style=flat-square
[license]: https://github.com/AshleyHow/WindowsOSBuild/blob/main/LICENCE

## About

Gets windows patch release information (Build, KB Number, Release Date etc) for Windows client and server versions. Useful for scripting and automation purposes. Supports Windows 10 and Windows Server 2016 onwards.

Gets windows patch release information from [Microsoft](https://docs.microsoft.com/en-gb/windows/release-health/release-information) and presents this in a usable format which can be used for scripting purposes. This source is updated regularly by Microsoft after new patches are released. This means at times this info may not always in sync with Windows Update.   

The majority of this code came from [Get-Windows10ReleaseInformation](https://github.com/FredrikWall/PowerShell/blob/master/Windows/Get-Windows10ReleaseInformation.ps1), credit to Fredrik Wall.
    
## Supported Powershell Versions

This has been tested with Powershell 5.0 and 5.1, and the module manifests lists the minimum supported version as 5.0.

## Installation
Powershell Gallery

Simply install directly from the Powershell Gallery by running the following command:

```
Install-Module -Name WindowsOSBuild
```

To update:

```
Update-Module -Name WindowsOSBuild
```

## Get-LatestOSBuild

Gets the latest available OS Build release information for Windows 10 including Windows Server versions.

#### Parameters

* **OSVersion**

    This parameter is mandatory and is the OS version number you want to check. Examples of some valid of OS versions are shown below.

    | Windows 10                                          | Version                                                                |
    | :-------------------------------------------------- | :--------------------------------------------------------------------- |
    | CB/CBB/SAC (Semi-Annual Channel)                    | 1507, 1511, 1607, 1703, 1709, 1803, 1809, 1903, 1909, 2004, 20H2, 21H1 |
    | LTSB/LTSC (Long-Term Servicing Build/Channel)       | 2015 = 1507, 2016 = 1607, 2019 = 1809                                                       |

    | Windows Server                                      | Version                                                                |
    | :-------------------------------------------------- | :--------------------------------------------------------------------- |
    | SAC (Semi-Annual Channel)                           | 1809, 1903, 1909, 2004, 20H2                                           |
    | LTSB/LTSC (Long-Term Servicing Build/Channel)       | 2016 = 1607, 2019 = 1809, 2022 = 21H2             |

* **LatestReleases**

    This parameter is optional. Returns last x releases (where x is the number of releases you want to display). Default value is 1.

* **BuildOnly**

    This is an optional parameter. Returns only the full build number/s of the OS Version. 
    
## Get-CurrentOSBuild

Gets the currently installed OS Build release number for Windows 10 including Windows Server versions.

#### Parameters    
    
There are no parameters required.

## Example Usage

Show the currently installed OS Build release number.
```
Get-CurrentOSBuild
```
Show all information on the latest available OS Build for Version 1607 in list format.
```
Get-LatestOSBuild -OSVersion 1607
```
Show all information on the latest 2 releases of OS Builds for Version 1607 in list format.
```
Get-LatestOSBuild -OSVersion 1607 -LatestReleases 2
```
Show only the latest available OS Build for Version 1607 in list format.  
```
Get-LatestOSBuild -OSVersion 1607 -BuildOnly
```
Show all information on the latest available OS Build for Version 1607 in json format.
```
Get-LatestOSBuild -OSVersion 1607 | ConvertTo-Json
```
Save the json format to a file on the latest available OS Build for Version 1607.
```
Get-LatestOSBuild -OSVersion 1607 | ConvertTo-Json | Out-File .\Get-LatestOSBuild.json
```

## Example Output

```
PS C:\Users\Ashley>  Get-LatestOSBuild -OSVersion 20H2 -LatestReleases 2

Version           : Version 20H2 (OS build 19042)
OS build          : 19042.985
Availability date : 2021-05-11
Servicing option  : Semi-Annual Channel
Kb article        : KB 5003173

Version           : Version 20H2 (OS build 19042)
OS build          : 19042.964
Availability date : 2021-04-28
Servicing option  : Semi-Annual Channel
Kb article        : KB 5001391
```

```
PS C:\Users\Ashley> Get-LatestOSBuild -OSVersion 1607 -LatestReleases 2 -BuildOnly
14393.4402
14393.4350
```
