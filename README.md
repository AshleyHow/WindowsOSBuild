# WindowsOSBuild
[![License][license-badge]][license]
[![PowerShell Gallery][psgallery-badge]][psgallery]
[![PowerShell Gallery Version][psgallery-version-badge]][psgallery]
[![Codacy Badge](https://app.codacy.com/project/badge/Grade/ec81538145f64de7ad264606ed790407)](https://www.codacy.com/gh/AshleyHow/WindowsOSBuild/dashboard?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=AshleyHow/WindowsOSBuild&amp;utm_campaign=Badge_Grade)
[![Build status](https://ci.appveyor.com/api/projects/status/o8l8510lkoo7igy1?svg=true)](https://ci.appveyor.com/project/ah-uk/windowsosbuild)

![alt text](https://github.com/AshleyHow/WindowsOSBuild/blob/main/WindowsOSBuild.png)

Gets Windows patch release information (Version, Build, Availability date, Hotpatch, Baseline, Preview, Out-of-band, Servicing option, KB article, KB URL and Catalog URL) for Windows client and server versions. Useful for scripting and automation purposes. Supports Windows 10 and Windows Server 2016 onwards. Supports Hotpatch on Windows 11, Windows Server 2022 and Windows Server 2025.

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
| CB/CBB/SAC (Semi-Annual Channel)           | 1507, 1511, 1607, 1703, 1709, 1803, 1809, 1903, 1909, 2004, 20H2, 21H1, 21H2, 22H2, 23H2, 24H2, 25H2, 26H1.             |
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

  - NoCache

This parameter is optional. Bypasses the local web cache completely for the current command. No cache is read and no cache is written.

  - RefreshCache

This parameter is optional. Forces a fresh download of Microsoft source pages and updates the local cache.

  - CacheTTLHours / TTL

This parameter is optional. Defines cache lifetime in hours. Alias: TTL. Default: 8. Range: 0.01 to 720.

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

Show all information on the latest available OS build for Windows 11 Version 25H2 in list format.
```powershell
Get-LatestOSBuild -OSName Win11 -OSVersion 25H2
```
Show all information on the latest 2 releases of OS builds for Windows 11 Version 25H2 in list format.
```powershell
Get-LatestOSBuild -OSName Win11 -OSVersion 25H2 -LatestReleases 2
```
Show all information on the latest 2 releases excluding preview of OS builds for Windows 11 Version 25H2 in list format.
```powershell
Get-LatestOSBuild -OSName Win11 -OSVersion 25H2 -ExcludePreview -LatestReleases 2
```
Show all information on the latest 2 releases excluding out-of-band of OS builds for Windows 11 Version 25H2 in list format.
```powershell
Get-LatestOSBuild -OSName Win11 -OSVersion 25H2 -ExcludeOutOfBand -LatestReleases 2
```
Show all information on the latest 2 preview releases of OS builds for Windows 11 Version 25H2 in list format.
```powershell
Get-LatestOSBuild -OSName Win11 -OSVersion 25H2 -PreviewOnly -LatestReleases 2
```
Show all information on the latest 2 out-of-band releases of OS builds for Windows 11 Version 25H2 in list format.
```powershell
Get-LatestOSBuild -OSName Win11 -OSVersion 25H2 -OutOfBandOnly -LatestReleases 2
```
Show only the latest available OS build for Windows 11 Version 25H2 in list format.
```powershell
Get-LatestOSBuild -OSName Win11 -OSVersion 25H2 -BuildOnly
```
Show only the latest available preview OS build for Windows 11 Version 25H2 in list format.
```powershell
Get-LatestOSBuild -OSName Win11 -OSVersion 25H2 -PreviewOnly -BuildOnly
```
Show only the latest available out-of-band OS build for for Windows 11 Version 25H2 in list format.
```powershell
Get-LatestOSBuild -OSName Win11 -OSVersion 25H2 -OutOfBandOnly -BuildOnly
```
Show all information on the latest available OS build for Windows 11 Version 25H2 in json format.
```powershell
Get-LatestOSBuild -OSName Win11 -OSVersion 25H2 | ConvertTo-Json
```
Save the json format to a file on the latest available OS build for Windows 11 Version 25H2.
```powershell
Get-LatestOSBuild -OSName Win11 -OSVersion 25H2 | ConvertTo-Json | Out-File .\Get-LatestOSBuild.json
```

## Output

### Get-CurrentOSBuild

```powershell
PS C:\Users\Ashley> Get-CurrentOSBuild

19045.6937
```

```powershell
PS C:\Users\Ashley> Get-CurrentOSBuild -Detailed

Version           : Version 22H2 (OS build 19045)
Build             : 19045.6937
Availability date : 2026-02-10
Preview           : False
Out-of-band       : False
Servicing option  : General Availability Channel
KB article        : KB5075912
KB URL            : https://support.microsoft.com/en-us/help/5075912
Catalog URL       : https://www.catalog.update.microsoft.com/Search.aspx?q=KB5075912
```
### Get-LatestOSBuild

```powershell
PS C:\Users\Ashley> Get-LatestOSBuild -OSName Win11 -OSVersion 25H2 -LatestReleases 2 -BuildOnly

26200.7922
26200.7840
```

```powershell
PS C:\Users\Ashley> Get-LatestOSBuild -OSName Win11 -OSVersion 25H2 -LatestReleases 2

Version           : Version 25H2 (OS build 26200)
Build             : 26200.7922
Availability date : 2026-02-24
Preview           : True
Out-of-band       : False
Servicing option  : General Availability Channel
KB article        : KB5077241
KB URL            : https://support.microsoft.com/en-us/help/5077241
Catalog URL       : https://www.catalog.update.microsoft.com/Search.aspx?q=KB5077241

Version           : Version 25H2 (OS build 26200)
Build             : 26200.7840
Availability date : 2026-02-10
Preview           : False
Out-of-band       : False
Servicing option  : General Availability Channel
KB article        : KB5077181
KB URL            : https://support.microsoft.com/en-us/help/5077181
Catalog URL       : https://www.catalog.update.microsoft.com/Search.aspx?q=KB5077181
```

```powershell
PS C:\Users\Ashley> Get-LatestOSBuild -OSName Win11 -OSVersion 25H2 -LatestReleases 20 | Format-Table

Version                       Build      Availability date Preview Out-of-band Servicing option             KB article KB URL                                           Catalog URL
-------                       -----      ----------------- ------- ----------- ----------------             ---------- ------                                           -----------
Version 25H2 (OS build 26200) 26200.7922 2026-02-24        True    False       General Availability Channel KB5077241  https://support.microsoft.com/en-us/help/5077241 https://www.catalog.update.microsoft.com/Search.aspx?q=KB5077241
Version 25H2 (OS build 26200) 26200.7840 2026-02-10        False   False       General Availability Channel KB5077181  https://support.microsoft.com/en-us/help/5077181 https://www.catalog.update.microsoft.com/Search.aspx?q=KB5077181
Version 25H2 (OS build 26200) 26200.7705 2026-01-29        True    False       General Availability Channel KB5074105  https://support.microsoft.com/en-us/help/5074105 https://www.catalog.update.microsoft.com/Search.aspx?q=KB5074105
Version 25H2 (OS build 26200) 26200.7628 2026-01-24        False   True        General Availability Channel KB5078127  https://support.microsoft.com/en-us/help/5078127 https://www.catalog.update.microsoft.com/Search.aspx?q=KB5078127
Version 25H2 (OS build 26200) 26200.7627 2026-01-17        False   True        General Availability Channel KB5077744  https://support.microsoft.com/en-us/help/5077744 https://www.catalog.update.microsoft.com/Search.aspx?q=KB5077744
Version 25H2 (OS build 26200) 26200.7623 2026-01-13        False   False       General Availability Channel KB5074109  https://support.microsoft.com/en-us/help/5074109 https://www.catalog.update.microsoft.com/Search.aspx?q=KB5074109
Version 25H2 (OS build 26200) 26200.7462 2025-12-09        False   False       General Availability Channel KB5072033  https://support.microsoft.com/en-us/help/5072033 https://www.catalog.update.microsoft.com/Search.aspx?q=KB5072033
Version 25H2 (OS build 26200) 26200.7309 2025-12-01        True    False       General Availability Channel KB5070311  https://support.microsoft.com/en-us/help/5070311 https://www.catalog.update.microsoft.com/Search.aspx?q=KB5070311
Version 25H2 (OS build 26200) 26200.7171 2025-11-11        False   False       General Availability Channel KB5068861  https://support.microsoft.com/en-us/help/5068861 https://www.catalog.update.microsoft.com/Search.aspx?q=KB5068861
Version 25H2 (OS build 26200) 26200.7019 2025-10-28        True    False       General Availability Channel KB5067036  https://support.microsoft.com/en-us/help/5067036 https://www.catalog.update.microsoft.com/Search.aspx?q=KB5067036
Version 25H2 (OS build 26200) 26200.6901 2025-10-20        False   True        General Availability Channel KB5070773  https://support.microsoft.com/en-us/help/5070773 https://www.catalog.update.microsoft.com/Search.aspx?q=KB5070773
Version 25H2 (OS build 26200) 26200.6899 2025-10-14        False   False       General Availability Channel KB5066835  https://support.microsoft.com/en-us/help/5066835 https://www.catalog.update.microsoft.com/Search.aspx?q=KB5066835
Version 25H2 (OS build 26200) 26200.6584 2025-09-30        False   False       General Availability Channel N/A        N/A                                              N/A
```

## How to compare current vs latest OS build

To compare you can use the following code example. This will compare a device's current OS build against the latest available OS build of Windows 10 22H2 (including out-of-band and excluding preview builds) this can be changed as required and guidance can be found above. The $Status variable can used in your RMM, monitoring solution or scripts as required.

```powershell
$InstalledOSBuild = Get-CurrentOSBuild
$LatestOSBuilds = Get-LatestOSBuild -OSName Win11 -OSVersion 25H2 -LatestReleases 1 -ExcludePreview

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
