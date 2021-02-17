function Get-LatestOSBuild {
    <#
        .SYNOPSIS
            Gets the latest available OS Build release information for Windows 10 including Windows Server versions.
        .DESCRIPTION
            Gets latest release information from https://winreleaseinfoprod.blob.core.windows.net/winreleaseinfoprod/en-US.html and presents this in a usable format.
            This source is updated regularly by Microsoft AFTER new patches are released. This means at times this info may not always in sync with Windows Update.        
        .PARAMETER OSVersion 
            Mandatory. OS Version number. 
            
            Windows 10 OS Versions:
            CB/CBB/SAC (Semi-Annual Channel)                     - e.g 1507, 1511, 1607, 1703, 1709, 1803, 1809, 1903, 1909, 2004, 20H2. 
            LTSB/LTSC (Long-Term Servicing Build/Channel)        - e.g 1507, 1607, 1809.

            Window Server OS Versions:
            SAC (Semi-Annual Channel)                            - e.g 1809, 1903, 1909, 2004, 20H2.
            LTSB/LTSC (Long-Term Servicing Build/Channel)        - e.g Server 2016 = 1607, Server 2019 = 1809.
        .PARAMETER LatestReleases
            Optional. Returns last x releases (where x is the number of releases you want to display). Default value is 1.
        .PARAMETER BuildOnly
            Returns only the full build number/s of the OS Version. This is an optional parameter.
        .EXAMPLE
            Get-LatestOSBuild -OSVersion 1607
            Will show all information on the latest available OS Build for Version 1607 in list format.
        .EXAMPLE
            Get-LatestOSBuild -OSVersion 1607 -LatestReleases 2
            Will show all information on the latest 2 releases of OS Builds for Version 1607 in list format.
        .EXAMPLE
            Get-LatestOSBuild -OSVersion 1607 -BuildOnly
            Will show only the latest available OS Build for Version 1607 in list format.        
        .EXAMPLE
            Get-LatestOSBuild -OSVersion 1607 | ConvertTo-Json
            Will show all information on the latest available OS Build for Version 1607 in json format.
        .EXAMPLE
            Get-LatestOSBuild -OSVersion 1607 | ConvertTo-Json | Out-File .\Get-LatestOSBuild.json
            Will save the json format to a file on the latest available OS Build for Version 1607.
        .NOTES
            The majority of this code came from Get-Windows10ReleaseInformation, credit to Fredrik Wall.
            https://github.com/FredrikWall/PowerShell/blob/master/Windows/Get-Windows10ReleaseInformation.ps1
    #>

        param(
        [CmdletBinding()]
        [Parameter(Mandatory = $true)]
        [String]$OSVersion,
        [Parameter(Mandatory = $false)]
        [String]$LatestReleases = 1,
        [Parameter(Mandatory = $false)]
        [Switch]$BuildOnly
    )

    $DLL = (Get-InstalledModule WindowsOSBuild).InstalledLocation + "\Microsoft.mshtml.dll"
    Add-Type -Path $DLL
    Add-Type -AssemblyName "Microsoft.mshtml"
    
    $Url = "https://winreleaseinfoprod.blob.core.windows.net/winreleaseinfoprod/en-US.html"
    $Webpage = Invoke-RestMethod $Url
    $HTML = New-Object -Com "HTMLFile"

    # Write HTML content according to DOM Level2 
    $HTML.IHTMLDocument2_write($Webpage)

    $Version = @($HTML.all.tags("h4"))
    $ReleaseVersions = ($Version.outerText).Substring(2)
    
    $TableNumber = 2
    $HTML.IHTMLDocument2_write($Webpage)

    $table = foreach ($Version in $ReleaseVersions) {
   
        $Tables = @($HTML.all.tags("table"))
   
        $Table = $Tables[$TableNumber]

        $Titles = @()

        $Rows = @($Table.Rows)
    
        foreach ($Row in $Rows) {

            $Cells = @($Row.Cells)

            ## If we've found a table header, remember its titles

            if ($Cells[0].tagName -eq "TH") {

                $Titles = @($Cells | ForEach-Object { ("" + $_.InnerText).Trim() })

                continue

            }

            ## If we haven't found any table headers, make up names "P1", "P2", etc.

            if (-not $Titles) {

                $Titles = @(1..($Cells.Count + 2) | ForEach-Object { "P$_" })

            }

            ## Now go through the cells in the the row. For each, try to find the

            ## title that represents that column and create a hash table mapping those

            ## titles to content

            $ResultObject = [Ordered] @{}

            for ($Counter = 0; $Counter -lt $Cells.Count; $Counter++) {
            
                $Title = "Version"
                $ResultObject[$Title] = $Version

            }

            for ($Counter = 0; $Counter -lt $Cells.Count; $Counter++) {
            
                $Title = $Titles[$Counter]

                if (-not $Title) { continue }

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
        ($Table | Where-Object { $_ -Match "Version $OSVersion" } | Select-Object -First $LatestReleases)."OS Build"
    }
}

Function Get-CurrentOSBuild {
    <#
        .SYNOPSIS
            Gets the currently installed OS Build release number for Windows 10 including Windows Server versions.
        .DESCRIPTION
            Installed OS Build release number is obtained from the registry. 
        .EXAMPLE
            C:\PS> Get-LatestOSBuild -OSVersion 1607
            Will show all information on the latest available OS Build information for Version 1607 in list format.
    #>

    $CurrentBuild = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion" -Name CurrentBuild).CurrentBuild
    $UBR = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion" -Name UBR).UBR
    $CurrentBuild + '.' + $UBR
}