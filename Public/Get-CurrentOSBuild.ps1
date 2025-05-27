Function Get-CurrentOSBuild {
    <#
        .SYNOPSIS
            Gets the currently installed OS Build release information. Supports Windows 10 and Windows Server 2016 onwards. Supports Hotpatch on Windows 11 and Windows Server 2022.
        .DESCRIPTION
            Installed OS Build number or detailed information (Version, Build, Availability date, Hotpatch, Preview, Out-of-band, Servicing option, KB article, KB URL and Catalog URL).
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
            Throw "Get-CurrentOSBuild: Unable to get operating system caption. Error: $($_.Exception.Message)"
        }

        If ($GetOSCaption -match "Windows 10") {
            $DetectedOS = "Win10"
        }
        ElseIf ($GetOSCaption -match "Windows 11") {
            If ((Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\PolicyManager\current\device\Update" -Name "AllowRebootlessUpdates" -ErrorAction SilentlyContinue).AllowRebootlessUpdates -eq 1) {
                $DetectedOS = "Win11Hotpatch"
            }
            Else {
                $DetectedOS = "Win11"
            }
        }
        ElseIf ($GetOSCaption -match "Server 2016") {
            $DetectedOS = "Server2016"
        }
        ElseIf ($GetOSCaption -match "Server 2019") {
            $DetectedOS = "Server2019"
        }
        ElseIf ($GetOSCaption -match "Server 2022") {
            If (Get-HotFix -Id KB5003508 -ErrorAction SilentlyContinue) {
                $DetectedOS = "Server2022Hotpatch"
                $FallBackOS = "Server2022"
            }
            Else {
                $DetectedOS = "Server2022"
            }
        }
        ElseIf ($GetOSCaption -match "Server 2025") {
            If (($null -ne ((New-Object -ComObject Microsoft.Update.Session).CreateUpdateSearcher().Search("IsInstalled=1").Updates | Where-Object { $_.Title -like "*Hotpatch*" } | Select-Object -First 1))) {
                $DetectedOS = "Server2025Hotpatch"
                $FallBackOS = "Server2025"
            }
            Else {
                $DetectedOS = "Server2025"
            }
        }
        ElseIf ($GetOSCaption -match "Windows Server Standard" -or $GetOSCaption -match "Windows Server Datacenter") {
            $DetectedOS = "ServerSAC"
        }
        Else {
            Throw "Get-CurrentOSBuild: Unable to detect operating system. OS Caption: $GetOSCaption, Detected OS: $DetectedOS"
        }

        # Hotpatch OS
        If ($FallBackOS) {
            $Results = Get-LatestOSBuild -OSName $DetectedOS -OSversion $(Get-Build) -LatestReleases 1000 | Where-Object -Property Build -eq $CurrentOSBuild
            # Handle Hotpatch capable OS thats is not using hotpatch updates
            If (!$Results) {
                $Results = Get-LatestOSBuild -OSName $FallBackOS -OSversion $(Get-Build) -LatestReleases 1000 | Where-Object -Property Build -eq $CurrentOSBuild
            }
            $Results
        }
        # All other OS
        Else {
            Get-LatestOSBuild -OSName $DetectedOS -OSversion $(Get-Build) -LatestReleases 1000 | Where-Object -Property Build -eq $CurrentOSBuild
        }
    }
    Else {
        Return $CurrentOSBuild
    }
}