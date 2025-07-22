# WindowsOSBuild
[![License][license-badge]][license]
[![PowerShell Gallery][psgallery-badge]][psgallery]
[![PowerShell Gallery Version][psgallery-version-badge]][psgallery]
[![Codacy Badge](https://app.codacy.com/project/badge/Grade/ec81538145f64de7ad264606ed790407)](https://www.codacy.com/gh/AshleyHow/WindowsOSBuild/dashboard?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=AshleyHow/WindowsOSBuild&amp;utm_campaign=Badge_Grade)
[![Build status](https://ci.appveyor.com/api/projects/status/o8l8510lkoo7igy1?svg=true)](https://ci.appveyor.com/project/ah-uk/windowsosbuild)

![alt text](https://github.com/AshleyHow/WindowsOSBuild/blob/main/WindowsOSBuild.png)

Gets Windows patch release information (Version, Build, Availability date, Hotpatch, Preview, Out-of-band, Servicing option, KB article, KB URL and Catalog URL) for Windows client and server versions. Useful for scripting and automation purposes. Supports Windows 10 and Windows Server 2016 onwards. Supports Hotpatch on Windows 11, Windows Server 2022 and Windows Server 2025.

Patch information retrieved from Microsoft Release Health / Update History and relevant Atom feed pages (Preview, Out-of-Band and Hotpatch info) outputted in a usable format. These sources are updated regularly by Microsoft AFTER new patches are released. This means at times this info may not always be in sync with Windows Update.

If you have found this project useful please [:heart:Sponsor](https://github.com/sponsors/AshleyHow) to help fund the renewal of the code signing certificate for the next year.

## Installing the Module

### PowerShell Support

WindowsOSBuild supports Windows PowerShell 5.0, 5.1 and 7.0+.

### Install from the PowerShell Gallery

The WindowsOSBuild module is published to the PowerShell Gallery and can be found here: [WindowsOSBuild](https://www.powershellgallery.com/packages/WindowsOSBuild/). This is the best and recommend method to install WindowsOSBuild.

The module can be installed from the gallery with:

```powershell
Install-Module -Name WindowsOSBuild
```

### Updating the Module

If you have installed a previous version of the module from the gallery, you can install the latest update with `Update-Module` and the `-Force` parameter:

```powershell
Update-Module -Name WindowsOSBuild -Force
```

## Get-LatestOSBuild Function

Gets windows patch release information (Build, KB Number, Release Date etc) for Windows client and server versions. Useful for scripting and automation purposes. Supports Windows 10 and Windows Server 2016 onwards. Supports Hotpatch on Windows 11, Windows Server 2022 and Windows Server 2025.

### Parameters

  - OSName

This parameter is optional. OS name you want to check. Default value is Win10. Supported accepted values:

| OS Name                                   | Version                                                                                                                 |
| :-----------------------------------------| :-----------------------------------------------------------------------------------------------------------------------|
| Windows Client OS Names                   | Win10, Win11, Win11Hotpatch.                                                                                            |
| Windows Server OS Names                   | Server2016, Server2019, Server2022, Server2022Hotpatch, Server2025, Server2025Hotpatch, Server Semi-annual = ServerSAC. |

  - OSVersion

This parameter is mandatory. OS version number you want to check. Supported accepted values:

| Windows Client OS                          | Version                                                                                                                 |
| :----------------------------------------- | :-----------------------------------------------------------------------------------------------------------------------|
| CB/CBB/SAC (Semi-Annual Channel)           | 1507, 1511, 1607, 1703, 1709, 1803, 1809, 1903, 1909, 2004, 20H2, 21H1, 21H2, 22H2, 23H2, 24H2.                         |
| Win 10 LTSB/LTSC                           | 2015 = 1507, 2016 = 1607, 2019 = 1809, 2021 = 21H2.                                                                     |
| Win 11 LTSC                                | 2024 = 24H2.                                                                                                            |

| Windows Server OS                          | Version                                                                                                                 |
| :----------------------------------------- | :-----------------------------------------------------------------------------------------------------------------------|
| SAC (Semi-Annual Channel)                  | 1709, 1803, 1809, 1903, 1909, 2004, 20H2.                                                                               |
| LTSB/LTSC                                  | 2016 = 1607, 2019 = 1809, 2022 = 21H2, 2025 = 24H2.                                                                     |

  - LatestReleases

This parameter is optional. Returns last x releases (where x is the number of releases you want to display). Default value is 1.

  - BuildOnly

This parameter is optional. Returns only the full build number/s of the OS Version.

  - ExcludePreview

This parameter is optional. Excludes preview releases.

  - ExcludeOutOfBand

This parameter is optional. Excludes out-of-band releases.

  - PreviewOnly

This parameter is optional. Returns preview release/s only.

  - OutOfBandOnly

This parameter is optional. Returns out-of-band/s only.

## Get-CurrentOSBuild Function

Gets the currently installed OS Build release information. Supports Windows 10 and Windows Server 2016 onwards. Supports Hotpatch on Windows Server 2022 Azure Edition.

Installed OS Build number or detailed information (Version, Build, Availability date, Hotpatch, Preview, Out-of-band, Servicing option, KB article, KB URL and Catalog URL).

### Parameters

   - Detailed

This parameter is optional. Returns detailed information about the installed OS Build.

## Usage

### Get-CurrentOSBuild

Show only the build number for the installed OS Build.
```powershell
Get-CurrentOSBuild
```
Show detailed information for the installed OS Build.
```powershell
Get-CurrentOSBuild -Detailed
```
### Get-LatestOSBuild

Show all information on the latest available OS build for Windows 10 Version 22H2 in list format.
```powershell
Get-LatestOSBuild -OSName Win10 -OSVersion 22H2
```
Show all information on the latest 2 releases of OS builds for Windows 10 Version 22H2 in list format.
```powershell
Get-LatestOSBuild -OSName Win10 -OSVersion 22H2 -LatestReleases 2
```
Show all information on the latest 2 releases excluding preview of OS builds for Windows 10 Version 22H2 in list format.
```powershell
Get-LatestOSBuild -OSName Win10 -OSVersion 22H2 -ExcludePreview -LatestReleases 2
```
Show all information on the latest 2 releases excluding out-of-band of OS builds for Windows 10 Version 22H2 in list format.
```powershell
Get-LatestOSBuild -OSName Win10 -OSVersion 22H2 -ExcludeOutOfBand -LatestReleases 2
```
Show all information on the latest 2 preview releases of OS builds for Windows 10 Version 22H2 in list format.
```powershell
Get-LatestOSBuild -OSName Win10 -OSVersion 22H2 -PreviewOnly -LatestReleases 2
```
Show all information on the latest 2 out-of-band releases of OS builds for Windows 10 Version 22H2 in list format.
```powershell
Get-LatestOSBuild -OSName Win10 -OSVersion 22H2 -OutOfBandOnly -LatestReleases 2
```
Show only the latest available OS build for Windows 10 Version 22H2 in list format.
```powershell
Get-LatestOSBuild -OSName Win10 -OSVersion 22H2 -BuildOnly
```
Show only the latest available preview OS build for Windows 10 Version 22H2 in list format.
```powershell
Get-LatestOSBuild -OSName Win10 -OSVersion 22H2 -PreviewOnly -BuildOnly
```
Show only the latest available out-of-band OS build for for Windows 10 Version 22H2 in list format.
```powershell
Get-LatestOSBuild -OSName Win10 -OSVersion 22H2 -OutOfBandOnly -BuildOnly
```
Show all information on the latest available OS build for Windows 10 Version 22H2 in json format.
```powershell
Get-LatestOSBuild -OSName Win10 -OSVersion 22H2 | ConvertTo-Json
```
Save the json format to a file on the latest available OS build for Windows 10 Version 22H2.
```powershell
Get-LatestOSBuild -OSName Win10 -OSVersion 22H2 | ConvertTo-Json | Out-File .\Get-LatestOSBuild.json
```

## Output

### Get-CurrentOSBuild

```powershell
PS C:\Users\Ashley> Get-CurrentOSBuild

19045.3324
```

```powershell
PS C:\Users\Ashley> Get-CurrentOSBuild -Detailed

Version           : Version 22H2 (OS build 19045)
Build             : 19045.3324
Availability date : 2023-08-08
Preview           : False
Out-of-band       : False
Servicing option  : General Availability Channel
KB article        : KB5029244
KB URL            : https://support.microsoft.com/help/5029244
Catalog URL       : https://www.catalog.update.microsoft.com/Search.aspx?q=KB5029244
```
### Get-LatestOSBuild

```powershell
PS C:\Users\Ashley> Get-LatestOSBuild -OSName Win10 -OSVersion 22H2 -LatestReleases 2 -BuildOnly

19045.3393
19045.3324
```

```powershell
PS C:\Users\Ashley> Get-LatestOSBuild -OSName Win10 -OSVersion 22H2 -LatestReleases 2

Version           : Version 22H2 (OS build 19045)
Build             : 19045.3393
Availability date : 2023-08-22
Preview           : True
Out-of-band       : False
Servicing option  : General Availability Channel
KB article        : KB5029331
KB URL            : https://support.microsoft.com/help/5029331
Catalog URL       : https://www.catalog.update.microsoft.com/Search.aspx?q=KB5029331

Version           : Version 22H2 (OS build 19045)
Build             : 19045.3324
Availability date : 2023-08-08
Preview           : False
Out-of-band       : False
Servicing option  : General Availability Channel
KB article        : KB5029244
KB URL            : https://support.microsoft.com/help/5029244
Catalog URL       : https://www.catalog.update.microsoft.com/Search.aspx?q=KB5029244
```

```powershell
PS C:\Users\Ashley> Get-LatestOSBuild -OSName Win10 -OSVersion 22H2 -LatestReleases 20 | Format-Table

Version                       Build      Availability date Preview Out-of-band Servicing option                    KB article KB URL                                     Catalog URL
-------                       -----      ----------------- ------- ----------- ----------------                    ---------- ------                                     -----------
Version 21H2 (OS build 19044) 19044.3324 2023-08-08        False   False       LTSC • General Availability Channel KB5029244  https://support.microsoft.com/help/5029244 https://www.catalog.update.microsoft.com/Search.aspx?q=KB5029244
Version 21H2 (OS build 19044) 19044.3208 2023-07-11        False   False       LTSC • General Availability Channel KB5028166  https://support.microsoft.com/help/5028166 https://www.catalog.update.microsoft.com/Search.aspx?q=KB5028166
Version 21H2 (OS build 19044) 19044.3086 2023-06-13        False   False       LTSC • General Availability Channel KB5027215  https://support.microsoft.com/help/5027215 https://www.catalog.update.microsoft.com/Search.aspx?q=KB5027215
Version 21H2 (OS build 19044) 19044.2965 2023-05-09        False   False       LTSC • General Availability Channel KB5026361  https://support.microsoft.com/help/5026361 https://www.catalog.update.microsoft.com/Search.aspx?q=KB5026361
Version 21H2 (OS build 19044) 19044.2846 2023-04-11        False   False       LTSC • General Availability Channel KB5025221  https://support.microsoft.com/help/5025221 https://www.catalog.update.microsoft.com/Search.aspx?q=KB5025221
Version 21H2 (OS build 19044) 19044.2788 2023-03-21        True    False       LTSC • General Availability Channel KB5023773  https://support.microsoft.com/help/5023773 https://www.catalog.update.microsoft.com/Search.aspx?q=KB5023773
Version 21H2 (OS build 19044) 19044.2728 2023-03-14        False   False       LTSC • General Availability Channel KB5023696  https://support.microsoft.com/help/5023696 https://www.catalog.update.microsoft.com/Search.aspx?q=KB5023696
Version 21H2 (OS build 19044) 19044.2673 2023-02-21        True    False       LTSC • General Availability Channel KB5022906  https://support.microsoft.com/help/5022906 https://www.catalog.update.microsoft.com/Search.aspx?q=KB5022906
Version 21H2 (OS build 19044) 19044.2604 2023-02-14        False   False       LTSC • General Availability Channel KB5022834  https://support.microsoft.com/help/5022834 https://www.catalog.update.microsoft.com/Search.aspx?q=KB5022834
Version 21H2 (OS build 19044) 19044.2546 2023-01-19        True    False       LTSC • General Availability Channel KB5019275  https://support.microsoft.com/help/5019275 https://www.catalog.update.microsoft.com/Search.aspx?q=KB5019275
Version 21H2 (OS build 19044) 19044.2486 2023-01-10        False   False       LTSC • General Availability Channel KB5022282  https://support.microsoft.com/help/5022282 https://www.catalog.update.microsoft.com/Search.aspx?q=KB5022282
Version 21H2 (OS build 19044) 19044.2364 2022-12-13        False   False       LTSC • General Availability Channel KB5021233  https://support.microsoft.com/help/5021233 https://www.catalog.update.microsoft.com/Search.aspx?q=KB5021233
Version 21H2 (OS build 19044) 19044.2311 2022-11-15        True    False       LTSC • General Availability Channel KB5020030  https://support.microsoft.com/help/5020030 https://www.catalog.update.microsoft.com/Search.aspx?q=KB5020030
Version 21H2 (OS build 19044) 19044.2251 2022-11-08        False   False       LTSC • General Availability Channel KB5019959  https://support.microsoft.com/help/5019959 https://www.catalog.update.microsoft.com/Search.aspx?q=KB5019959
Version 21H2 (OS build 19044) 19044.2194 2022-10-28        False   True        LTSC • General Availability Channel KB5020953  https://support.microsoft.com/help/5020953 https://www.catalog.update.microsoft.com/Search.aspx?q=KB5020953
Version 21H2 (OS build 19044) 19044.2193 2022-10-25        True    False       LTSC • General Availability Channel KB5018482  https://support.microsoft.com/help/5018482 https://www.catalog.update.microsoft.com/Search.aspx?q=KB5018482
Version 21H2 (OS build 19044) 19044.2132 2022-10-17        False   True        LTSC • General Availability Channel KB5020435  https://support.microsoft.com/help/5020435 https://www.catalog.update.microsoft.com/Search.aspx?q=KB5020435
Version 21H2 (OS build 19044) 19044.2130 2022-10-11        False   False       LTSC • General Availability Channel KB5018410  https://support.microsoft.com/help/5018410 https://www.catalog.update.microsoft.com/Search.aspx?q=KB5018410
Version 21H2 (OS build 19044) 19044.2075 2022-09-20        True    False       LTSC • General Availability Channel KB5017380  https://support.microsoft.com/help/5017380 https://www.catalog.update.microsoft.com/Search.aspx?q=KB5017380
Version 21H2 (OS build 19044) 19044.2006 2022-09-13        False   False       LTSC • General Availability Channel KB5017308  https://support.microsoft.com/help/5017308 https://www.catalog.update.microsoft.com/Search.aspx?q=KB5017308
```

## How to compare current vs latest OS build

To compare you can use the following code example. This will compare a device's current OS build against the latest available OS build of Windows 10 22H2 (including out-of-band and excluding preview builds) this can be changed as required and guidance can be found above. The $Status variable can used in your RMM, monitoring solution or scripts as required.

```powershell
$InstalledOSBuild = Get-CurrentOSBuild
$LatestOSBuilds = Get-LatestOSBuild -OSName Win10 -OSVersion 22H2 -LatestReleases 1 -ExcludePreview

If ($LatestOSBuilds -match $InstalledOSBuild) {
    Write-Output "OK - OS Build is up to date"
    $Status = "OK"
}
Else {
    Write-Output "Warning - OS Build is out of date"
    $Status = "Warning"
}
````

## Who

This module is maintained by the following

* Ashley How, [@AshleyHow1](https://twitter.com/AshleyHow1)

## Credits

Forked from [Get-Windows10ReleaseInformation.ps1](https://github.com/FredrikWall/PowerShell/blob/master/Windows/Get-Windows10ReleaseInformation.ps1) created by [Fredrik Wall](https://github.com/FredrikWall)


Uses code adapted from [Get-CurrentPatchInfo.ps1](https://gist.githubusercontent.com/SMSAgentSoftware/79fb091a4b7806378fc0daa826dbfb47/raw/0f6b52cddf82b2aa836a813cf6bc910a52a48c9f/Get-CurrentPatchInfo.ps1) created by [Trevor Jones](https://github.com/SMSAgentSoftware)

[psgallery-badge]: https://img.shields.io/powershellgallery/v/WindowsOSBuild.svg?logo=PowerShell&style=flat-square
[psgallery]: https://www.powershellgallery.com/packages/WindowsOSBuild
[psgallery-version-badge]: https://img.shields.io/powershellgallery/dt/WindowsOSBuild.svg?logo=PowerShell&style=flat-square
[license-badge]: https://img.shields.io/github/license/AshleyHow/WindowsOSBuild.svg?style=flat-square
[license]: https://github.com/AshleyHow/WindowsOSBuild/blob/main/LICENCE
