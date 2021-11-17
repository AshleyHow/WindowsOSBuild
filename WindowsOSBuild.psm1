Function Get-LatestOSBuild {
    <#
        .SYNOPSIS
            Gets windows patch release information (Build, KB Number, Release Date etc) for Windows client and server versions. Useful for scripting and automation purposes.
            Supports Windows 10 and Windows Server 2016 onwards.
        .DESCRIPTION
            Patch information retrieved from https://docs.microsoft.com/en-gb/windows/release-health/release-information and outputted in a usable format.
            This source is updated regularly by Microsoft AFTER new patches are released. This means at times this info may not always in sync with Windows Update.
        .PARAMETER OSName
            This parameter is optional. OS name you want to check. Default value is Win10. Accepted values: 

            Windows Client OS Names                              - Win10, Win11.
            Windows Server OS Names                              - Server2016, Server2019, Server2022.
        .PARAMETER OSVersion 
            This parameter is mandatory. OS version number you want to check. Accepted values:
            
            Windows Client OS Versions:
            CB/CBB/SAC (Semi-Annual Channel)                     - 1507, 1511, 1607, 1703, 1709, 1803, 1809, 1903, 1909, 2004, 20H2, 21H2, 21H2. 
            LTSB/LTSC (Long-Term Servicing Build/Channel)        - 2015 = 1507, 2016 = 1607, 2019 = 1809, 2021 = 21H2.
            
            Window Server OS Versions:
            SAC (Semi-Annual Channel)                            - 1809, 1903, 1909, 2004, 20H2.
            LTSB/LTSC (Long-Term Servicing Build/Channel)        - Server 2016 = 1607, Server 2019 = 1809, Server 2022 = 21H2.
        .PARAMETER LatestReleases
            This parameter is optional. Returns last x releases (where x is the number of releases you want to display). Default value is 1.
        .PARAMETER BuildOnly
            This parameter is optional. Returns only the full build number/s of the OS Version.
        .EXAMPLE
            Get-LatestOSBuild -OSVersion 21H1
            Will show all information on the latest available OS Build for Version 21H1 in list format.
        .EXAMPLE
            Get-LatestOSBuild -OSVersion 21H1 -LatestReleases 2
            Will show all information on the latest 2 releases of OS Builds for Version 21H1 in list format.
        .EXAMPLE
            Get-LatestOSBuild -OSVersion 21H1 -BuildOnly
            Will show only the latest available OS Build for Version 21H1 in list format.
        .EXAMPLE
            Get-LatestOSBuild -OSVersion 21H1 | ConvertTo-Json
            Will show all information on the latest available OS Build for Version 21H1 in json format.
        .EXAMPLE
            Get-LatestOSBuild -OSVersion 21H1 | ConvertTo-Json | Out-File .\Get-LatestOSBuild.json
            Will save the json format to a file on the latest available OS Build for Version 21H1.
        .NOTES
            Large portions of this code came originally from Get-Windows10ReleaseInformation, credit to Fredrik Wall.
            https://github.com/FredrikWall/PowerShell/blob/master/Windows/Get-Windows10ReleaseInformation.ps1
    #>

        Param(
        [CmdletBinding()]
        [Parameter(Mandatory = $true)]
        [String]$OSVersion,
        
        [Parameter(Mandatory = $false)]
        [String]$LatestReleases = 1,
        
        [Parameter(Mandatory = $false)]
        [ValidateSet('Win10','Win11','Server2016','Server2019','Server2022')]
        [String]$OSName = "Win10",
        
        [Parameter(Mandatory = $false)]
        [Switch]$BuildOnly
    )
    
    If (($OSName) -eq "Win11") {
        $Url = "https://docs.microsoft.com/en-gb/windows/release-health/windows11-release-information"
        $TableNumber = 1
    }
    ElseIf (($OSName) -eq "Win10" -or  "Server2016" -or "Server2019" -or "Server2022" ) {
        $Url = "https://docs.microsoft.com/en-gb/windows/release-health/release-information"
        $TableNumber = 2
    }
    Else {
        Throw "Unsupported Operating System"
    }

    $Webpage = Invoke-RestMethod $Url
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

    $Version = @($HTML.all.tags("strong"))
    $ReleaseVersions = ($Version.outerText).Substring(0)
    $Table = Foreach ($Version in $ReleaseVersions) {
        $Tables = @($HTML.all.tags("table"))
        $Table = $Tables[$TableNumber]
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
                $Title = "Version"
                $ResultObject[$Title] = $Version
            }
            For ($Counter = 0; $Counter -lt $Cells.Count; $Counter++) {
                $Title = $Titles[$Counter]
                If (-not $Title) { 
                    Continue 
                }
                $ResultObject[$Title] = ("" + $Cells[$Counter].InnerText).Trim()
            }

            ## And finally cast that hash table to a PSCustomObject
            [PSCustomObject]$ResultObject 
        }
        $TableNumber++
    } 

    If ($BuildOnly -eq $false) {
        ($Table | Where-Object { $_ -Match "Version $OSVersion" } | Select-Object -First $LatestReleases)
    }
    If ($BuildOnly -eq $true) {
        ($Table | Where-Object { $_ -Match "Version $OSVersion" } | Select-Object -First $LatestReleases)."Build"
    }
}

Function Get-CurrentOSBuild {
    <#
        .SYNOPSIS
            Gets the currently installed OS Build release number for Windows 10 including Windows Server versions.
        .DESCRIPTION
            Installed OS Build release number is obtained from the registry. 
        .EXAMPLE
            C:\PS> Get-LatestOSBuild -OSVersion 21H1
            Will show all information on the latest available OS Build information for Version 21H1 in list format.
    #>

    $CurrentBuild = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion" -Name CurrentBuild).CurrentBuild
    $UBR = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion" -Name UBR).UBR
    $CurrentBuild + '.' + $UBR
}