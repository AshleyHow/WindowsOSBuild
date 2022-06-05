Function Get-LatestOSBuild {
    <#
        .SYNOPSIS
            Gets windows patch release information (Version, Build, Availability date, Preview, Out-of-band, Servicing option, KB article, KB URL and Catalog URL) for Windows client and server versions.
            Useful for scripting and automation purposes. Supports Windows 10 and Windows Server 2016 onwards.
        .DESCRIPTION
            Patch information retrieved from the release health portal (https://docs.microsoft.com/en-gb/windows/release-health/release-information) and outputted in a usable format.
            This source is updated regularly by Microsoft AFTER new patches are released. This means at times this info may not always be in sync with Windows Update.
        .PARAMETER OSName
            This parameter is optional. OS name you want to check. Default value is Win10. Accepted values:

            Windows Client OS Names                              - Win10, Win11.
            Windows Server OS Names                              - Server2016, Server2019, Server2022, Server Semi-annual = ServerSAC.
        .PARAMETER OSVersion
            This parameter is mandatory. OS version number you want to check. Accepted values:

            Windows Client OS Versions:
            CB/CBB/SAC (Semi-Annual Channel)                     - 1507, 1511, 1607, 1703, 1709, 1803, 1809, 1903, 1909, 2004, 20H2, 21H2, 21H2.
            LTSB/LTSC (Long-Term Servicing Build/Channel)        - 2015 = 1507, 2016 = 1607, 2019 = 1809, 2021 = 21H2.

            Window Server OS Versions:
            SAC (Semi-Annual Channel)                            - 1709, 1803, 1809, 1903, 1909, 2004, 20H2.
            LTSB/LTSC (Long-Term Servicing Build/Channel)        - Server 2016 = 1607, Server 2019 = 1809, Server 2022 = 21H2.
        .PARAMETER LatestReleases
            This parameter is optional. Returns last x releases (where x is the number of releases you want to display). Default value is 1.
        .PARAMETER BuildOnly
            This parameter is optional. Returns only the full build number/s of the OS Version.
        .PARAMETER ExcludePreview
            This parameter is optional. Excludes preview releases.
        .PARAMETER ExcludeOutOfBand
            This parameter is optional. Excludes out-of-band releases.
        .EXAMPLE
            Get-CurrentOSBuild
            Show the currently installed OS Build release number.
        .EXAMPLE
            Get-LatestOSBuild -OSName Win10 -OSVersion 21H1
            Show all information on the latest available OS Build for Windows 10 Version 21H1 in list format.
        .EXAMPLE
            Get-LatestOSBuild -OSName Win10 -OSVersion 21H1 -LatestReleases 2
            Show all information on the latest 2 releases of OS Builds for Windows 10 Version 21H1 in list format.
        .EXAMPLE
            Get-LatestOSBuild -OSName Win10 -OSVersion 21H1 -ExcludePreview -LatestReleases 2
            Show all information on the latest 2 releases (excluding preview) of OS Builds for Windows 10 Version 21H1 in list format.
         .EXAMPLE
            Get-LatestOSBuild -OSName Win10 -OSVersion 21H1 -ExcludeOutOfBand -LatestReleases 2
            Show all information on the latest 2 releases (excluding out-of-band) of OS Builds for Windows 10 Version 21H1 in list format.
        .EXAMPLE
            Get-LatestOSBuild -OSName Win10 -OSVersion 21H1 -BuildOnly
            Show only the latest available OS Build for Windows 10 Version 21H1 in list format.
        .EXAMPLE
            Get-LatestOSBuild -OSName Win10 -OSVersion 21H1 | ConvertTo-Json
            Show all information on the latest available OS Build for Windows 10 Version 21H1 in json format.
        .EXAMPLE
            Get-LatestOSBuild -OSName Win10 -OSVersion 21H1 | ConvertTo-Json | Out-File .\Get-LatestOSBuild.json
            Save the json format to a file on the latest available OS Build for Windows 10 Version 21H1.
        .NOTES
            Forked from 'Get-Windows10ReleaseInformation.ps1' created by Fredrik Wall.
            https://github.com/FredrikWall/PowerShell/blob/master/Windows/Get-Windows10ReleaseInformation.ps1
            Uses code adapted from 'Get-CurrentPatchInfo.ps1' created by Trevor Jones.
            https://gist.githubusercontent.com/SMSAgentSoftware/79fb091a4b7806378fc0daa826dbfb47/raw/0f6b52cddf82b2aa836a813cf6bc910a52a48c9f/Get-CurrentPatchInfo.ps1
    #>

        Param(
        [CmdletBinding()]
        [Parameter(Mandatory = $true)]
        [String]$OSVersion,

        [Parameter(Mandatory = $false)]
        [String]$LatestReleases = 1,

        [Parameter(Mandatory = $false)]
        [ValidateSet('Win10','Win11','Server2016','Server2019','Server2022','ServerSAC')]
        [String]$OSName = "Win10",

        [Parameter(Mandatory = $false)]
        [Switch]$BuildOnly,

        [Parameter(Mandatory = $false)]
        [Switch]$ExcludePreview,

        [Parameter(Mandatory = $false)]
        [Switch]$ExcludeOutOfBand
    )

    # Disable progress bar to speed up Invoke-WebRequest calls
    $ProgressPreference = 'SilentlyContinue'

    # Define variables for OSName
    If (($OSName) -eq "Win11") {
        $OSBase = "Windows 11"
        $URL = "https://docs.microsoft.com/en-us/windows/release-health/windows11-release-information"
        $TableNumber = 1
    }
    ElseIf (($OSName) -eq "Win10" -or ($OSName) -eq "Server2016" -or ($OSName) -eq "Server2019" -or ($OSName) -eq "ServerSAC") {
        $OSBase = "Windows 10"
        $URL = "https://docs.microsoft.com/en-us/windows/release-health/release-information"
        $TableNumber = 2
    }
    ElseIf (($OSName) -eq "Server2022") {
        $URL = "https://support.microsoft.com/en-us/help/5005454"
    }
    Else {
        Throw "Unsupported Operating System. Supported operating systems can be found here: https://github.com/AshleyHow/WindowsOSBuild/blob/main/README.md"
    }

    # Enforce OSVersion for LTSC Server OSName to prevent incorrect OSVersion input
    If ($OSName -eq "Server2016") {
        $OSVersion = "1607"
    }
    ElseIf ($OSName -eq "Server2019") {
        $OSVersion = "1809"
    }
    ElseIf ($OSName -eq "Server2022") {
        $OSVersion = "21H2"
    }

    # Function used for to convert raw array from support URL to a parsed array (currently used only for Server 2022)
    Function Convert-ParsedArray {
        Param($Array)

        $ArrayList = New-Object System.Collections.ArrayList
        ForEach ($item in $Array) {
            [Void]$ArrayList.Add([PSCustomObject]@{
                Update = $item.outerHTML.Split('>')[1].Replace('</a','').Replace('&#x2014;',' - ')
                KB = "KB" + $item.href.Split('/')[-1]
                InfoURL = "https://support.microsoft.com" + $item.href
                OSBuild = [regex]::Match($item.outerHTML,"Build (.*)\)").Groups[1].Value
            })
        }
        Return $ArrayList
    }

    # Obtain data from webpage
    Try {
        If ($OSName -eq "Server2022") {
            $Webpage = Invoke-WebRequest -Uri $URL -UseBasicParsing -ErrorAction Stop
        }
        Else {
            $Webpage = Invoke-RestMethod -Uri $URL -UseBasicParsing -ErrorAction Stop
        }
    }
    Catch {
        Throw "Unable to obtain patch release information. Please check your internet connectivity. If you believe this is incorrect please submit an issue at https://github.com/AshleyHow/WindowsOSBuild/issues and include the following info :- `nURL: $URL, Error: $($_.Exception.Message)"
    }

    # Server 2022
    If ($OSName -eq "Server2022") {
        $Table = @()
        $Table =  @(
            $VersionDataRaw = $Webpage.Links | Where-Object {$_.outerHTML -match "supLeftNavLink" -and $_.outerHTML -match "KB"} | Sort-Object -Property href -Unique
            $UniqueList =  (Convert-ParsedArray -Array $VersionDataRaw) | Sort-Object OSBuild -Descending
            ForEach ($Update in $UniqueList) {
                $ResultObject = [Ordered] @{}
                $ResultObject["Version"] = "Version $OSVersion (OS build $($Update.OSBuild.Split('.')[0]))"
                $ResultObject["Build"] = $Update.OSBuild
                $GetDate = [regex]::Match($Update.Update,"(Jan(uary)?|Feb(ruary)?|Mar(ch)?|Apr(il)?|May|Jun(e)?|Jul(y)?|Aug(ust)?|Sep(tember)?|Oct(ober)?|Nov(ember)?|Dec(ember)?)\s+\d{1,2},\s+\d{4}").Value
                Try {
                    $ConvertToDate = [Datetime]::ParseExact($GetDate, 'MMMM dd, yyyy', [Globalization.CultureInfo]::CreateSpecificCulture('en-US'))
                }
                Catch {
                    $ConvertToDate = [Datetime]::ParseExact($GetDate, 'MMMM d, yyyy', [Globalization.CultureInfo]::CreateSpecificCulture('en-US'))
                }
                $FormatDate =  Get-Date($ConvertToDate) -Format 'yyyy-MM-dd'
                $ResultObject["Availability date"] = $FormatDate
                If ($Update.Update-match 'Preview') {
                    $ResultObject["Preview"] = "True"
                }
                Else {
                    $ResultObject["Preview"] = "False"
                }
                If ($Update.Update-match 'Out-of-band') {
                    $ResultObject["Out-of-band"] = "True"
                }
                Else {
                    $ResultObject["Out-of-band"] = "False"
                }
                $ResultObject["Servicing option"] = "LTSC"
                $ResultObject["KB article"] = $Update.KB
                $ResultObject["KB URL"] = $Update.InfoURL
                $ResultObject["Catalog URL"] =  "https://www.catalog.update.microsoft.com/Search.aspx?q=" + $Update.KB
                # Cast hash table to a PSCustomObject
                [PSCustomObject]$ResultObject | Select-Object -Property 'Version', 'Build', 'Availability date', 'Preview', 'Out-of-band', 'Servicing option', 'KB article', 'KB URL', 'Catalog URL'
            }
        )
    }
    # All other OS
    Else {
        # Create HTML object
        $HTML = New-Object -Com "HTMLFile"

        # Write HTML content according to DOM Level2
        Try {
            # This works in PowerShell with Office installed
            $html.IHTMLDocument2_write($Webpage)
        }
        Catch {
            # This works when Office is not installed
            $Src = [System.Text.Encoding]::Unicode.GetBytes($Webpage)
            $HTML.write($Src)
        }

        # Table Mapping - required to obtain preview and out-of-band information of versions
        $GetVersions = @($HTML.all.tags("strong"))
        $ReleaseVersions = ($GetVersions.outerText).Substring(0)
        $TableMapping = @()
        $TableMapping = ForEach ($Version in $ReleaseVersions) {
            # Windows 11 Base OS
            If ($OSBase -eq "Windows 11") {
                [PSCustomObject]@{
                    'Base' = $OSBase
                    'Version' = $Version
                    'TableNumber'=  $ReleaseVersions.IndexOf($Version) + 1
                }
            }
            # Windows 10 Base OS
            Else {
                [PSCustomObject]@{
                    'Base' = $OSName
                    'Version' = $Version
                    'TableNumber'=  $ReleaseVersions.IndexOf($Version) + 2
                }
            }
        }

        # Get version and table number to search of $OSVersion variable
        $SearchVersion = ($TableMapping | Where-Object { $_.Version -like "Version $OSVersion*(OS build*)" }).Version
        $SearchTable = ($TableMapping | Where-Object { $_.Version -like "Version $OSVersion*(OS build*)" }).TableNumber

        # Perform search and build table
        $Table = @()
        $Table =  @(
            $Tables = @($HTML.all.tags("table"))
            Try {
                $Table = $Tables[$SearchTable]
            }
            Catch {
                Throw "Operating system name and version combination not supported. If you believe this is incorrect please submit an issue at https://github.com/AshleyHow/WindowsOSBuild/issues and include the following info :- `nOS Name: $OSname, OS Version: $OSVersion, Error: $($_.Exception.Message)"
            }
            $Titles = @()
            $Rows = @($Table.Rows)
            Foreach ($Row in $Rows) {
                $Cells = @($Row.Cells)

                ## If we've found a table header, remember its titles
                If ($Cells[0].tagName -eq "TH") {
                    $Titles = @($Cells | ForEach-Object { ("" + $_.InnerText).Trim() })
                    Continue
                }

                ## If we haven't found any table headers, make up names "P1", "P2", etc.
                If (-not $Titles) {
                    $Titles = @(1..($Cells.Count + 2) | ForEach-Object { "P$_" })
                }

                ## Now go through the cells in the the row. For each, try to find the title that represents that column and create a hash table mapping those titles to content
                $ResultObject = [Ordered] @{}
                For ($Counter = 0; $Counter -lt $Cells.Count; $Counter++) {
                    $ResultObject["Version"] = $SearchVersion
                }
                For ($Counter = 0; $Counter -lt $Cells.Count; $Counter++) {
                    $Title = $Titles[$Counter]
                    If (-not $Title) {
                        Continue
                    }
                    $ResultObject[$Title] = ("" + $Cells[$Counter].InnerText).Trim()
                    If ((![string]::IsNullOrEmpty($ResultObject.'KB article')) -and ($ResultObject.'KB article' -ne "N/A")) {
                        $KBURL = "https://support.microsoft.com/help/" + ($ResultObject."KB article").Trim("KB")
                        $ResultObject["KB URL"] = $KBURL
                        $ResultObject["Catalog URL"] =  "https://www.catalog.update.microsoft.com/Search.aspx?q=" + $ResultObject.'KB article'
                        If ($KBURL -ne "https://support.microsoft.com/help/") {
                            If ($PSVersionTable.PSVersion.Major -ge 6) {
                                Try {
                                    $RedirectedKBURL = "https://support.microsoft.com" + (Invoke-WebRequest  -Uri $KBURL -UseBasicParsing -MaximumRedirection 0 -ErrorAction Stop).Headers.Location
                                }
                                Catch {
                                    $RedirectedKBURL = $_.Exception.Response.Headers.Location
                                }
                            }
                            Else {
                                $RedirectedKBURL = "https://support.microsoft.com" + (Invoke-WebRequest  -Uri $KBURL -UseBasicParsing -MaximumRedirection 0 -ErrorAction SilentlyContinue).Headers.Location
                            }
                            If ([string]::IsNullOrEmpty($RedirectedKBURL)) {
                                $ResultObject["Preview"] = "Unknown"
                            }
                            ElseIf ($RedirectedKBURL-match 'Preview') {
                                $ResultObject["Preview"] = "True"
                            }
                            Else {
                                $ResultObject["Preview"] = "False"
                            }

                            If ([string]::IsNullOrEmpty($RedirectedKBURL)) {
                                $ResultObject["Out-of-band"] = "Unknown"
                            }
                            ElseIf ($RedirectedKBURL-match 'Out-of-band') {
                                $ResultObject["Out-of-band"] = "True"
                            }
                            Else {
                                $ResultObject["Out-of-band"] = "False"
                            }
                        }
                    }
                    Else {
                        $ResultObject["Preview"] = "False"
                        $ResultObject["Out-of-band"] = "False"
                        $ResultObject["KB article"] = "N/A"
                        $ResultObject["KB URL"] = "N/A"
                        $ResultObject["Catalog URL"] = "N/A"
                    }
                }
                # Cast hash table to a PSCustomObject
                [PSCustomObject]$ResultObject | Select-Object -Property 'Version', 'Build', 'Availability date', 'Preview', 'Out-of-band', 'Servicing option', 'KB article', 'KB URL', 'Catalog URL'
            }
        )
    }

    # Return filtered results based upon parameters
    If ($ExcludePreview -eq $true -and $ExcludeOutOfBand -eq $true -and $BuildOnly -eq $true) {
        # Excluding Preview and Out-of-band - Build
        ($Table | Where-Object { (($_.Preview -eq "False" -or $_.Preview -eq "Unknown") -and  ($_.'Out-of-band' -eq "False" -or $_.'Out-of-band' -eq "Unknown")) } | Select-Object -First $LatestReleases)."Build"
    }
    ElseIf ($ExcludePreview -eq $true -and $ExcludeOutOfBand -eq $false -and $BuildOnly -eq $true) {
        # Excluding Preview - Build
        ($Table | Where-Object { $_.Preview -eq "False" -or $_.Preview -eq "Unknown" } | Select-Object -First $LatestReleases)."Build"
    }
    ElseIf ($ExcludePreview -eq $false -and $ExcludeOutOfBand -eq $true -and $BuildOnly -eq $true) {
        # Excluding Out-of-band - Build
        ($Table | Where-Object { $_.'Out-of-band' -eq "False" -or $_.'Out-of-band' -eq "Unknown" } | Select-Object -First $LatestReleases)."Build"
    }
    ElseIf ($ExcludePreview -eq $true -and $ExcludeOutOfBand -eq $true -and $BuildOnly -eq $false) {
        # Excluding Preview and Out-of-band
        ($Table | Where-Object { (($_.Preview -eq "False" -or $_.Preview -eq "Unknown") -and  ($_.'Out-of-band' -eq "False" -or $_.'Out-of-band' -eq "Unknown")) } | Select-Object -First $LatestReleases)
    }
    ElseIf ($ExcludePreview -eq $true -and $ExcludeOutOfBand -eq $false -and $BuildOnly -eq $false) {
        # Excluding Preview
        ($Table | Where-Object { $_.Preview -eq "False" -or $_.Preview -eq "Unknown" } | Select-Object -First $LatestReleases)
    }
    ElseIf ($ExcludePreview -eq $false -and $ExcludeOutOfBand -eq $true -and $BuildOnly -eq $false) {
        # Excluding Out-of-band
        ($Table | Where-Object { $_.'Out-of-band' -eq "False" -or $_.'Out-of-band' -eq "Unknown" } | Select-Object -First $LatestReleases)
    }
    ElseIf ($BuildOnly -eq $true) {
        # Build
        ($Table | Select-Object -First $LatestReleases)."Build"
    }
    Else {
        # No parameters
        ($Table | Select-Object -First $LatestReleases)
    }
}

Function Get-CurrentOSBuild {
    <#
        .SYNOPSIS
            Gets the currently installed OS Build release information. Supports Windows 10 and Windows Server 2016 onwards.
        .DESCRIPTION
            Installed OS Build number or detailed information (Version, Build, Availability date, Preview, Out-of-band, Servicing option, KB article, KB URL and Catalog URL).
        .PARAMETER Detailed
            This parameter is optional. Returns detailed information about the installed OS Build.
        .EXAMPLE
            Get-CurrentOSBuild
            Show only the build number for the installed OS Build.
        .EXAMPLE
            Get-CurrentOSBuild -Detailed
            Show detailed information for the installed OS Build.
    #>

    Param(
        [CmdletBinding()]
        [Parameter(Mandatory = $false)]
        [Switch]$Detailed
    )

    Function Get-Build {
        # Check for Windows 10 1507 as ReleaseId does not exist until 1511
        If ((Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion" -Name CurrentBuild).CurrentBuild -eq "10240") {
            Return "1507"
        }
        Else {
            $ReleaseID = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion" -Name ReleaseId).ReleaseId
            If ($ReleaseID -eq '2009') {
                $DisplayVersion = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion" -Name DisplayVersion).DisplayVersion
                Return $DisplayVersion
            }
            Else {
                Return $ReleaseID
            }
        }
    }

    $CurrentBuild = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion" -Name CurrentBuild).CurrentBuild
    $UBR = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion" -Name UBR).UBR
    $CurrentOSBuild = $CurrentBuild + '.' + $UBR

    If ($Detailed -eq $true) {
        Try {
            $GetOSCaption = (Get-CIMInstance Win32_OperatingSystem).Caption
        }
        Catch {
            Throw "Unable to get operating system caption. If you believe this is incorrect please submit an issue at https://github.com/AshleyHow/WindowsOSBuild/issues and include the following info :- `nOS Caption: $GetOSCaption, Error: $($_.Exception.Message)"
        }

        If ($GetOSCaption -match "Windows 10") {
            $DetectedOS = "Win10"
        }
        ElseIf ($GetOSCaption -match "Windows 11") {
            $DetectedOS = "Win10"
        }
        ElseIf ($GetOSCaption -match "Server 2016") {
            $DetectedOS = "Server2016"
        }
        ElseIf ($GetOSCaption -match "Server 2019") {
            $DetectedOS = "Server2019"
        }
        ElseIf ($GetOSCaption -match "Server 2022") {
            $DetectedOS = "Server2022"
        }
        ElseIf ($GetOSCaption -match "Windows Server Standard" -or $GetOSCaption -match "Windows Server Datacenter") {
            $DetectedOS = "ServerSAC"
        }
        Else {
            Throw "Unable to detect operating system. If you believe this is incorrect please submit an issue at https://github.com/AshleyHow/WindowsOSBuild/issues and include the following info :- `nOS Caption: $GetOSCaption, Detected OS: $GetOSCaption"
        }

        Get-LatestOSBuild -OSName $DetectedOS -OSversion $(Get-Build) -LatestReleases 1000 | Where-Object -Property Build -eq $CurrentOSBuild
    }
    Else {
        Return $CurrentOSBuild
    }
}