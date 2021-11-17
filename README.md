
![alt text](https://github.com/AshleyHow/WindowsOSBuild/blob/main/WindowsOSBuild.png)

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

Patch information retrieved from [Microsoft](https://docs.microsoft.com/en-gb/windows/release-health/release-information) and outputted in a usable format. This source is updated regularly by Microsoft AFTER new patches are released. This means at times this info may not always in sync with Windows Update. 

Large portions of this code came originally from [Get-Windows10ReleaseInformation](https://github.com/FredrikWall/PowerShell/blob/master/Windows/Get-Windows10ReleaseInformation.ps1), credit to Fredrik Wall.
    
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

Gets windows patch release information (Build, KB Number, Release Date etc) for Windows client and server versions. Useful for scripting and automation purposes. Supports Windows 10 and Windows Server 2016 onwards.

#### Parameters

* **OSVersion**
    
    This parameter is optional. OS name you want to check. Default value is Win10. Accepted values: 
    
    | OS Name                                             | Version                                                                      |
    | :---------------------------------------------------| :--------------------------------------------------------------------------- |
    | Windows Client OS Names                             | Win10, Win11                                                                 |
    | Windows Server OS Names                             | Server2016, Server2019, Server2022                                           |

* **OSVersion**

    This parameter is mandatory. OS version number you want to check. Accepted values:

    | Windows Client OS                                   | Version                                                                      |
    | :-------------------------------------------------- | :--------------------------------------------------------------------------- |
    | CB/CBB/SAC (Semi-Annual Channel)                    | 1507, 1511, 1607, 1703, 1709, 1803, 1809, 1903, 1909, 2004, 20H2, 21H1, 21H2 |
    | LTSB/LTSC (Long-Term Servicing Build/Channel)       | 2015 = 1507, 2016 = 1607, 2019 = 1809, 2021 = 21H2                           |

    | Windows Server OS                                   | Version                                                                      |
    | :-------------------------------------------------- | :--------------------------------------------------------------------------- |
    | SAC (Semi-Annual Channel)                           | 1809, 1903, 1909, 2004, 20H2, 21H1, 21H2                                     |
    | LTSB/LTSC (Long-Term Servicing Build/Channel)       | 2016 = 1607, 2019 = 1809, 2022 = 21H2                                        |

* **LatestReleases**

    This parameter is optional. Returns last x releases (where x is the number of releases you want to display). Default value is 1.

* **BuildOnly**

    This parameter is optional. Returns only the full build number/s of the OS Version.
    
## Get-CurrentOSBuild

Gets the currently installed OS Build release number for Windows 10 including Windows Server versions.

#### Parameters    
    
There are no parameters required.

## Example Usage

Show the currently installed OS Build release number.
```
Get-CurrentOSBuild
```
Show all information on the latest available OS Build for Version 21H1 in list format.
```
Get-LatestOSBuild -OSVersion 21H1
```
Show all information on the latest 2 releases of OS Builds for Version 21H1 in list format.
```
Get-LatestOSBuild -OSVersion 21H1 -LatestReleases 2
```
Show only the latest available OS Build for Version 21H1 in list format.  
```
Get-LatestOSBuild -OSVersion 21H1 -BuildOnly
```
Show all information on the latest available OS Build for Version 21H1 in json format.
```
Get-LatestOSBuild -OSVersion 21H1 | ConvertTo-Json
```
Save the json format to a file on the latest available OS Build for Version 21H1.
```
Get-LatestOSBuild -OSVersion 21H1 | ConvertTo-Json | Out-File .\Get-LatestOSBuild.json
```

## Example Output

```
PS C:\Users\Ashley> Get-LatestOSBuild -OSVersion 21H1 -LatestReleases 2

Version           : Version 21H1 (OS build 19043)
OS build          : 19043.1266
Availability date : 2021-09-30
Servicing option  : Semi-Annual Channel
Kb article        : KB 5005611

Version           : Version 21H1 (OS build 19043)
OS build          : 19043.1237
Availability date : 2021-09-14
Servicing option  : Semi-Annual Channel
Kb article        : KB 5005565
```

```
PS C:\Users\Ashley> Get-LatestOSBuild -OSVersion 21H1 -LatestReleases 2 -BuildOnly
19043.1266
19043.1237
```
