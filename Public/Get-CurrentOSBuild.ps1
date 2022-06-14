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