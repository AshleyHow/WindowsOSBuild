BeforeAll {
    $Path =  (Get-Item $PsScriptRoot).parent.FullName + "\WindowsOSBuild.psm1"
    . Import-Module -Name $Path -Verbose

    # Function to check if a string contains a valid date in YYYY-MM-DD format
    Function Find-ValidDate {
        Param (
            [string]$InputString
        )
        # Trim whitespace from the input string
        $InputString = $InputString.Trim()

        # Try to parse the date
        Try {
            [datetime]::ParseExact($InputString, "yyyy-MM-dd", $null) | Out-Null
            Return $true
        }
        Catch {
            Return $false
        }
    }

    Function Find-TrueOrFalse {
        Param (
            [object]$Value
        )
        # Return true if the value is either $true or $false
        Return $Value -eq $true -or $Value -eq $false
    }
}

If ($PSVersionTable.PSVersion.Major -le 6) {
    Describe "PS - Get-LatestOSBuild" {
        Context "Win 10 (1507)" {
            It "Results" {
                $Results = Get-LatestOSBuild -OSName Win10 -OSVersion 1507 -latestreleases 1000
                Start-Sleep -Seconds 0
                $Results.Build.Count | Should -BeGreaterThan 0
                $Results.Version | Should -Contain 'Version 1507 (RTM) (OS build 10240)'
                $Results.Build | Should -Match '^10240\.'
                $Results.'Availability date' | ForEach-Object { Find-ValidDate $_ } | Where-Object { $_ -eq $true }
                $Results.Preview | ForEach-Object { Find-TrueOrFalse $_ } | Where-Object { $_ -eq $true }
                $Results.'Out-of-band' | ForEach-Object { Find-TrueOrFalse $_ } | Where-Object { $_ -eq $true }
                $Results.'Servicing option' | Should -Not -BeNullOrEmpty
                $Results.'Servicing option' | ForEach-Object { $_ -match "â€¢|\u2022" } | Where-Object { $_ -eq $true }
                $Results.'KB article' | Should -Match "^KB\d+( / KB\d+)*$|^N/A$"
                $Results.'KB URL' | Should -Match "^\s*(https://support.microsoft.com/([a-z]{2}-[a-z]{2})?/help/\d+)\s*$|^\s*N/A\s*$"
                $Results.'Catalog URL' | Should -Match "https://www.catalog.update.microsoft.com/Search.aspx\?q=KB\d+|^N/A$"
            }
        }
        Context "Win 10 (1511)" {
            It "Results" {
                $Results = Get-LatestOSBuild -OSName Win10 -OSVersion 1511 -latestreleases 1000
                Start-Sleep -Seconds 0
                $Results.Build.Count | Should -BeGreaterThan 0
                $Results.Version | Should -Contain 'Version 1511 (OS build 10586)'
                $Results.Build | Should -Match '^10586\.'
                $Results.'Availability date' | ForEach-Object { Find-ValidDate $_ } | Where-Object { $_ -eq $true }
                $Results.Preview | ForEach-Object { Find-TrueOrFalse $_ } | Where-Object { $_ -eq $true }
                $Results.'Out-of-band' | ForEach-Object { Find-TrueOrFalse $_ } | Where-Object { $_ -eq $true }
                $Results.'Servicing option' | Should -Not -BeNullOrEmpty
                $Results.'Servicing option' | ForEach-Object { $_ -match "â€¢|\u2022" } | Where-Object { $_ -eq $true }
                $Results.'KB article' | Should -Match "^KB\d+( / KB\d+)*$|^N/A$"
                $Results.'KB URL' | Should -Match "^\s*(https://support.microsoft.com/([a-z]{2}-[a-z]{2})?/help/\d+)\s*$|^\s*N/A\s*$"
                $Results.'Catalog URL' | Should -Match "https://www.catalog.update.microsoft.com/Search.aspx\?q=KB\d+|^N/A$"
            }
        }
        Context "Win 10 / Server 2016 (1607)" {
            It "Results" {
                $Results = Get-LatestOSBuild -OSName Win10 -OSVersion 1607 -latestreleases 1000
                Start-Sleep -Seconds 0
                $Results.Build.Count | Should -BeGreaterThan 0
                $Results.Version | Should -Contain 'Version 1607 (OS build 14393)'
                $Results.Build | Should -Match '^14393\.'
                $Results.'Availability date' | ForEach-Object { Find-ValidDate $_ } | Where-Object { $_ -eq $true }
                $Results.Preview | ForEach-Object { Find-TrueOrFalse $_ } | Where-Object { $_ -eq $true }
                $Results.'Out-of-band' | ForEach-Object { Find-TrueOrFalse $_ } | Where-Object { $_ -eq $true }
                $Results.'Servicing option' | Should -Not -BeNullOrEmpty
                $Results.'Servicing option' | ForEach-Object { $_ -match "â€¢|\u2022" } | Where-Object { $_ -eq $true }
                $Results.'KB article' | Should -Match "^KB\d+( / KB\d+)*$|^N/A$"
                $Results.'KB URL' | Should -Match "^\s*(https://support.microsoft.com/([a-z]{2}-[a-z]{2})?/help/\d+)\s*$|^\s*N/A\s*$"
                $Results.'Catalog URL' | Should -Match "https://www.catalog.update.microsoft.com/Search.aspx\?q=KB\d+|^N/A$"
            }
        }
        Context "Win 10 (1703)" {
            It "Results" {
                $Results = Get-LatestOSBuild -OSName Win10 -OSVersion 1703 -latestreleases 1000
                Start-Sleep -Seconds 0
                $Results.Build.Count | Should -BeGreaterThan 0
                $Results.Version | Should -Contain 'Version 1703 (OS build 15063)'
                $Results.Build | Should -Match '^15063\.'
                $Results.'Availability date' | ForEach-Object { Find-ValidDate $_ } | Where-Object { $_ -eq $true }
                $Results.Preview | ForEach-Object { Find-TrueOrFalse $_ } | Where-Object { $_ -eq $true }
                $Results.'Out-of-band' | ForEach-Object { Find-TrueOrFalse $_ } | Where-Object { $_ -eq $true }
                $Results.'Servicing option' | Should -Not -BeNullOrEmpty
                $Results.'Servicing option' | ForEach-Object { $_ -match "â€¢|\u2022" } | Where-Object { $_ -eq $true }
                $Results.'KB article' | Should -Match "^KB\d+( / KB\d+)*$|^N/A$"
                $Results.'KB URL' | Should -Match "^\s*(https://support.microsoft.com/([a-z]{2}-[a-z]{2})?/help/\d+)\s*$|^\s*N/A\s*$"
                $Results.'Catalog URL' | Should -Match "https://www.catalog.update.microsoft.com/Search.aspx\?q=KB\d+|^N/A$"
            }
        }
        Context "Win 10 (1709)" {
            It "Results" {
                $Results = Get-LatestOSBuild -OSName Win10 -OSVersion 1709 -latestreleases 1000
                Start-Sleep -Seconds 0
                $Results.Build.Count | Should -BeGreaterThan 0
                $Results.Version | Should -Contain 'Version 1709 (OS build 16299)'
                $Results.Build | Should -Match '^16299\.'
                $Results.'Availability date' | ForEach-Object { Find-ValidDate $_ } | Where-Object { $_ -eq $true }
                $Results.Preview | ForEach-Object { Find-TrueOrFalse $_ } | Where-Object { $_ -eq $true }
                $Results.'Out-of-band' | ForEach-Object { Find-TrueOrFalse $_ } | Where-Object { $_ -eq $true }
                $Results.'Servicing option' | Should -Not -BeNullOrEmpty
                $Results.'Servicing option' | ForEach-Object { $_ -match "â€¢|\u2022" } | Where-Object { $_ -eq $true }
                $Results.'KB article' | Should -Match "^KB\d+( / KB\d+)*$|^N/A$"
                $Results.'KB URL' | Should -Match "^\s*(https://support.microsoft.com/([a-z]{2}-[a-z]{2})?/help/\d+)\s*$|^\s*N/A\s*$"
                $Results.'Catalog URL' | Should -Match "https://www.catalog.update.microsoft.com/Search.aspx\?q=KB\d+|^N/A$"
            }
        }
        Context "Win 10 (1803)" {
            It "Results" {
                $Results = Get-LatestOSBuild -OSName Win10 -OSVersion 1803 -latestreleases 1000
                Start-Sleep -Seconds 0
                $Results.Build.Count | Should -BeGreaterThan 0
                $Results.Version | Should -Contain 'Version 1803 (OS build 17134)'
                $Results.Build | Should -Match '^17134\.'
                $Results.'Availability date' | ForEach-Object { Find-ValidDate $_ } | Where-Object { $_ -eq $true }
                $Results.Preview | ForEach-Object { Find-TrueOrFalse $_ } | Where-Object { $_ -eq $true }
                $Results.'Out-of-band' | ForEach-Object { Find-TrueOrFalse $_ } | Where-Object { $_ -eq $true }
                $Results.'Servicing option' | Should -Not -BeNullOrEmpty
                $Results.'Servicing option' | ForEach-Object { $_ -match "â€¢|\u2022" } | Where-Object { $_ -eq $true }
                $Results.'KB article' | Should -Match "^KB\d+( / KB\d+)*$|^N/A$"
                $Results.'KB URL' | Should -Match "^\s*(https://support.microsoft.com/([a-z]{2}-[a-z]{2})?/help/\d+)\s*$|^\s*N/A\s*$"
                $Results.'Catalog URL' | Should -Match "https://www.catalog.update.microsoft.com/Search.aspx\?q=KB\d+|^N/A$"
            }
        }
        Context "Win 10 / Server 2019 (1809)" {
            It "Results" {
                $Results = Get-LatestOSBuild -OSName Win10 -OSVersion 1809 -latestreleases 1000
                Start-Sleep -Seconds 0
                $Results.Build.Count | Should -BeGreaterThan 0
                $Results.Version | Should -Contain 'Version 1809 (OS build 17763)'
                $Results.Build | Should -Match '^17763\.'
                $Results.'Availability date' | ForEach-Object { Find-ValidDate $_ } | Where-Object { $_ -eq $true }
                $Results.Preview | ForEach-Object { Find-TrueOrFalse $_ } | Where-Object { $_ -eq $true }
                $Results.'Out-of-band' | ForEach-Object { Find-TrueOrFalse $_ } | Where-Object { $_ -eq $true }
                $Results.'Servicing option' | Should -Not -BeNullOrEmpty
                $Results.'Servicing option' | ForEach-Object { $_ -match "â€¢|\u2022" } | Where-Object { $_ -eq $true }
                $Results.'KB article' | Should -Match "^KB\d+( / KB\d+)*$|^N/A$"
                $Results.'KB URL' | Should -Match "^\s*(https://support.microsoft.com/([a-z]{2}-[a-z]{2})?/help/\d+)\s*$|^\s*N/A\s*$"
                $Results.'Catalog URL' | Should -Match "https://www.catalog.update.microsoft.com/Search.aspx\?q=KB\d+|^N/A$"
            }
        }
        Context "Win 10 (1903)" {
            It "Results" {
                $Results = Get-LatestOSBuild -OSName Win10 -OSVersion 1903 -latestreleases 1000
                Start-Sleep -Seconds 0
                $Results.Build.Count | Should -BeGreaterThan 0
                $Results.Version | Should -Contain 'Version 1903 (OS build 18362)'
                $Results.Build | Should -Match '^18362\.'
                $Results.'Availability date' | ForEach-Object { Find-ValidDate $_ } | Where-Object { $_ -eq $true }
                $Results.Preview | ForEach-Object { Find-TrueOrFalse $_ } | Where-Object { $_ -eq $true }
                $Results.'Out-of-band' | ForEach-Object { Find-TrueOrFalse $_ } | Where-Object { $_ -eq $true }
                $Results.'Servicing option' | Should -Not -BeNullOrEmpty
                $Results.'KB article' | Should -Match "^KB\d+( / KB\d+)*$|^N/A$"
                $Results.'KB URL' | Should -Match "^\s*(https://support.microsoft.com/([a-z]{2}-[a-z]{2})?/help/\d+)\s*$|^\s*N/A\s*$"
                $Results.'Catalog URL' | Should -Match "https://www.catalog.update.microsoft.com/Search.aspx\?q=KB\d+|^N/A$"
            }
        }
        Context "Win 10 (1909)" {
            It "Results" {
                $Results = Get-LatestOSBuild -OSName Win10 -OSVersion 1909 -latestreleases 1000
                Start-Sleep -Seconds 0
                $Results.Build.Count | Should -BeGreaterThan 0
                $Results.Version | Should -Contain 'Version 1909 (OS build 18363)'
                $Results.Build | Should -Match '^18363\.'
                $Results.'Availability date' | ForEach-Object { Find-ValidDate $_ } | Where-Object { $_ -eq $true }
                $Results.Preview | ForEach-Object { Find-TrueOrFalse $_ } | Where-Object { $_ -eq $true }
                $Results.'Out-of-band' | ForEach-Object { Find-TrueOrFalse $_ } | Where-Object { $_ -eq $true }
                $Results.'Servicing option' | Should -Not -BeNullOrEmpty
                $Results.'KB article' | Should -Match "^KB\d+( / KB\d+)*$|^N/A$"
                $Results.'KB URL' | Should -Match "^\s*(https://support.microsoft.com/([a-z]{2}-[a-z]{2})?/help/\d+)\s*$|^\s*N/A\s*$"
                $Results.'Catalog URL' | Should -Match "https://www.catalog.update.microsoft.com/Search.aspx\?q=KB\d+|^N/A$"
            }
        }
        Context "Win 10 (2004)" {
            It "Results" {
                $Results = Get-LatestOSBuild -OSName Win10 -OSVersion 2004 -latestreleases 1000
                Start-Sleep -Seconds 0
                $Results.Build.Count | Should -BeGreaterThan 0
                $Results.Version | Should -Contain 'Version 2004 (OS build 19041)'
                $Results.Build | Should -Match '^19041\.'
                $Results.'Availability date' | ForEach-Object { Find-ValidDate $_ } | Where-Object { $_ -eq $true }
                $Results.Preview | ForEach-Object { Find-TrueOrFalse $_ } | Where-Object { $_ -eq $true }
                $Results.'Out-of-band' | ForEach-Object { Find-TrueOrFalse $_ } | Where-Object { $_ -eq $true }
                $Results.'Servicing option' | Should -Not -BeNullOrEmpty
                $Results.'KB article' | Should -Match "^KB\d+( / KB\d+)*$|^N/A$"
                $Results.'KB URL' | Should -Match "^\s*(https://support.microsoft.com/([a-z]{2}-[a-z]{2})?/help/\d+)\s*$|^\s*N/A\s*$"
                $Results.'Catalog URL' | Should -Match "https://www.catalog.update.microsoft.com/Search.aspx\?q=KB\d+|^N/A$"
            }
        }
        Context "Win 10 (20H2)" {
            It "Results" {
                $Results = Get-LatestOSBuild -OSName Win10 -OSVersion 20H2 -latestreleases 1000
                Start-Sleep -Seconds 0
                $Results.Build.Count | Should -BeGreaterThan 0
                $Results.Version | Should -Contain 'Version 20H2 (OS build 19042)'
                $Results.Build | Should -Match '^19042\.'
                $Results.'Availability date' | ForEach-Object { Find-ValidDate $_ } | Where-Object { $_ -eq $true }
                $Results.Preview | ForEach-Object { Find-TrueOrFalse $_ } | Where-Object { $_ -eq $true }
                $Results.'Out-of-band' | ForEach-Object { Find-TrueOrFalse $_ } | Where-Object { $_ -eq $true }
                $Results.'Servicing option' | Should -Not -BeNullOrEmpty
                $Results.'KB article' | Should -Match "^KB\d+( / KB\d+)*$|^N/A$"
                $Results.'KB URL' | Should -Match "^\s*(https://support.microsoft.com/([a-z]{2}-[a-z]{2})?/help/\d+)\s*$|^\s*N/A\s*$"
                $Results.'Catalog URL' | Should -Match "https://www.catalog.update.microsoft.com/Search.aspx\?q=KB\d+|^N/A$"
            }
        }
        Context "Win 10 (21H1)" {
            It "Results" {
                $Results = Get-LatestOSBuild -OSName Win10 -OSVersion 21H1 -latestreleases 1000
                Start-Sleep -Seconds 0
                $Results.Build.Count | Should -BeGreaterThan 0
                $Results.Version | Should -Contain 'Version 21H1 (OS build 19043)'
                $Results.Build | Should -Match '^19043\.'
                $Results.'Availability date' | ForEach-Object { Find-ValidDate $_ } | Where-Object { $_ -eq $true }
                $Results.Preview | ForEach-Object { Find-TrueOrFalse $_ } | Where-Object { $_ -eq $true }
                $Results.'Out-of-band' | ForEach-Object { Find-TrueOrFalse $_ } | Where-Object { $_ -eq $true }
                $Results.'Servicing option' | Should -Not -BeNullOrEmpty
                $Results.'KB article' | Should -Match "^KB\d+( / KB\d+)*$|^N/A$"
                $Results.'KB URL' | Should -Match "^\s*(https://support.microsoft.com/([a-z]{2}-[a-z]{2})?/help/\d+)\s*$|^\s*N/A\s*$"
                $Results.'Catalog URL' | Should -Match "https://www.catalog.update.microsoft.com/Search.aspx\?q=KB\d+|^N/A$"
            }
        }
        Context "Win 10 (21H2)" {
            It "Results" {
                $Results = Get-LatestOSBuild -OSName Win10 -OSVersion 21H2 -latestreleases 1000
                Start-Sleep -Seconds 0
                $Results.Build.Count | Should -BeGreaterThan 0
                $Results.Version | Should -Contain 'Version 21H2 (OS build 19044)'
                $Results.Build | Should -Match '^19044\.'
                $Results.'Availability date' | ForEach-Object { Find-ValidDate $_ } | Where-Object { $_ -eq $true }
                $Results.Preview | ForEach-Object { Find-TrueOrFalse $_ } | Where-Object { $_ -eq $true }
                $Results.'Out-of-band' | ForEach-Object { Find-TrueOrFalse $_ } | Where-Object { $_ -eq $true }
                $Results.'Servicing option' | Should -Not -BeNullOrEmpty
                $Results.'Servicing option' | ForEach-Object { $_ -match "â€¢|\u2022" } | Where-Object { $_ -eq $true }
                $Results.'KB article' | Should -Match "^KB\d+( / KB\d+)*$|^N/A$"
                $Results.'KB URL' | Should -Match "^\s*(https://support.microsoft.com/([a-z]{2}-[a-z]{2})?/help/\d+)\s*$|^\s*N/A\s*$"
                $Results.'Catalog URL' | Should -Match "https://www.catalog.update.microsoft.com/Search.aspx\?q=KB\d+|^N/A$"
            }
        }
        Context "Win 10 (22H2)" {
            It "Results" {
                $Results = Get-LatestOSBuild -OSName Win10 -OSVersion 22H2 -latestreleases 1000
                Start-Sleep -Seconds 0
                $Results.Build.Count | Should -BeGreaterThan 0
                $Results.Version | Should -Contain 'Version 22H2 (OS build 19045)'
                $Results.Build | Should -Match '^19045\.'
                $Results.'Availability date' | ForEach-Object { Find-ValidDate $_ } | Where-Object { $_ -eq $true }
                $Results.Preview | ForEach-Object { Find-TrueOrFalse $_ } | Where-Object { $_ -eq $true }
                $Results.'Out-of-band' | ForEach-Object { Find-TrueOrFalse $_ } | Where-Object { $_ -eq $true }
                $Results.'Servicing option' | Should -Not -BeNullOrEmpty
                $Results.'KB article' | Should -Match "^KB\d+( / KB\d+)*$|^N/A$"
                $Results.'KB URL' | Should -Match "^\s*(https://support.microsoft.com/([a-z]{2}-[a-z]{2})?/help/\d+)\s*$|^\s*N/A\s*$"
                $Results.'Catalog URL' | Should -Match "https://www.catalog.update.microsoft.com/Search.aspx\?q=KB\d+|^N/A$"
            }
        }
        Context "Win 11 (21H2)" {
            It "Results" {
                $Results = Get-LatestOSBuild -OSName Win11 -OSVersion 21H2 -latestreleases 1000
                Start-Sleep -Seconds 0
                $Results.Build.Count | Should -BeGreaterThan 0
                $Results.Version | Should -Contain 'Version 21H2 (OS build 22000)'
                $Results.Build | Should -Match '^22000\.'
                $Results.'Availability date' | ForEach-Object { Find-ValidDate $_ } | Where-Object { $_ -eq $true }
                $Results.Preview | ForEach-Object { Find-TrueOrFalse $_ } | Where-Object { $_ -eq $true }
                $Results.'Out-of-band' | ForEach-Object { Find-TrueOrFalse $_ } | Where-Object { $_ -eq $true }
                $Results.'Servicing option' | Should -Not -BeNullOrEmpty
                $Results.'KB article' | Should -Match "^KB\d+( / KB\d+)*$|^N/A$"
                $Results.'KB URL' | Should -Match "^\s*(https://support.microsoft.com/([a-z]{2}-[a-z]{2})?/help/\d+)\s*$|^\s*N/A\s*$"
                $Results.'Catalog URL' | Should -Match "https://www.catalog.update.microsoft.com/Search.aspx\?q=KB\d+|^N/A$"
            }
        }
        Context "Win 11 (22H2)" {
            It "Results" {
                $Results = Get-LatestOSBuild -OSName Win11 -OSVersion 22H2 -latestreleases 1000
                Start-Sleep -Seconds 0
                $Results.Build.Count | Should -BeGreaterThan 0
                $Results.Version | Should -Contain 'Version 22H2 (OS build 22621)'
                $Results.Build | Should -Match '^22621\.'
                $Results.'Availability date' | ForEach-Object { Find-ValidDate $_ } | Where-Object { $_ -eq $true }
                $Results.Preview | ForEach-Object { Find-TrueOrFalse $_ } | Where-Object { $_ -eq $true }
                $Results.'Out-of-band' | ForEach-Object { Find-TrueOrFalse $_ } | Where-Object { $_ -eq $true }
                $Results.'Servicing option' | Should -Not -BeNullOrEmpty
                $Results.'KB article' | Should -Match "^KB\d+( / KB\d+)*$|^N/A$"
                $Results.'KB URL' | Should -Match "^\s*(https://support.microsoft.com/([a-z]{2}-[a-z]{2})?/help/\d+)\s*$|^\s*N/A\s*$"
                $Results.'Catalog URL' | Should -Match "https://www.catalog.update.microsoft.com/Search.aspx\?q=KB\d+|^N/A$"
            }
        }
        Context "Win 11 (23H2)" {
            It "Results" {
                $Results = Get-LatestOSBuild -OSName Win11 -OSVersion 23H2 -latestreleases 1000
                Start-Sleep -Seconds 0
                $Results.Build.Count | Should -BeGreaterThan 0
                $Results.Version | Should -Contain 'Version 23H2 (OS build 22631)'
                $Results.Build | Should -Match '^22631\.'
                $Results.'Availability date' | ForEach-Object { Find-ValidDate $_ } | Where-Object { $_ -eq $true }
                $Results.Preview | ForEach-Object { Find-TrueOrFalse $_ } | Where-Object { $_ -eq $true }
                $Results.'Out-of-band' | ForEach-Object { Find-TrueOrFalse $_ } | Where-Object { $_ -eq $true }
                $Results.'Servicing option' | Should -Not -BeNullOrEmpty
                $Results.'KB article' | Should -Match "^KB\d+( / KB\d+)*$|^N/A$"
                $Results.'KB URL' | Should -Match "^\s*(https://support.microsoft.com/([a-z]{2}-[a-z]{2})?/help/\d+)\s*$|^\s*N/A\s*$"
                $Results.'Catalog URL' | Should -Match "https://www.catalog.update.microsoft.com/Search.aspx\?q=KB\d+|^N/A$"
            }
        }
        Context "Win 11 (24H2)" {
            It "Results" {
                $Results = Get-LatestOSBuild -OSName Win11 -OSVersion 24H2 -latestreleases 1000
                Start-Sleep -Seconds 0
                $Results.Build.Count | Should -BeGreaterThan 0
                $Results.Version | Should -Contain 'Version 24H2 (OS build 26100)'
                $Results.Build | Should -Match '^26100\.'
                $Results.'Availability date' | ForEach-Object { Find-ValidDate $_ } | Where-Object { $_ -eq $true }
                $Results.Preview | ForEach-Object { Find-TrueOrFalse $_ } | Where-Object { $_ -eq $true }
                $Results.'Out-of-band' | ForEach-Object { Find-TrueOrFalse $_ } | Where-Object { $_ -eq $true }
                $Results.'Servicing option' | Should -Not -BeNullOrEmpty
                $Results.'KB article' | Should -Match "^KB\d+( / KB\d+)*$|^N/A$"
                $Results.'KB URL' | Should -Match "^\s*(https://support.microsoft.com/([a-z]{2}-[a-z]{2})?/help/\d+)\s*$|^\s*N/A\s*$"
                $Results.'Catalog URL' | Should -Match "https://www.catalog.update.microsoft.com/Search.aspx\?q=KB\d+|^N/A$"
            }
        }
        Context "Windows 11 Hotpatch (24H2)" {
            It "Results" {
                $Results = Get-LatestOSBuild -OSName Win11Hotpatch -OSVersion 24H2 -latestreleases 1000
                Start-Sleep -Seconds 0
                $Results.Build.Count | Should -BeGreaterThan 0
                $Results.Version | Should -Contain 'Version 24H2 (OS build 26100)'
                (($Results.Build -match '^26100\.') -or ($Results.Build -match 'Security Update')) | Should -BeTrue
                $Results.'Availability date' | ForEach-Object { Find-ValidDate $_ } | Where-Object { $_ -eq $true }
                $Results.Hotpatch | Should -Not -BeNullOrEmpty
                $Results.Preview | ForEach-Object { Find-TrueOrFalse $_ } | Where-Object { $_ -eq $true }
                $Results.'Out-of-band' | ForEach-Object { Find-TrueOrFalse $_ } | Where-Object { $_ -eq $true }
                $Results.'Servicing option' | Should -Not -BeNullOrEmpty
                $Results.'KB article' | Should -Match "^KB\d+( / KB\d+)*$|^N/A$"
                $Results.'KB URL' | Should -Match "^\s*(https://support.microsoft.com/([a-z]{2}-[a-z]{2})?/help/\d+)\s*$|^\s*N/A\s*$"
                $Results.'Catalog URL' | Should -Match "https://www.catalog.update.microsoft.com/Search.aspx\?q=KB\d+|^N/A$"
            }
        }
        Context "Server 2022 (21H2)" {
            It "Results" {
                $Results = Get-LatestOSBuild -OSName Server2022 -OSVersion 21H2 -latestreleases 1000
                Start-Sleep -Seconds 0
                $Results.Build.Count | Should -BeGreaterThan 0
                $Results.Version | Should -Contain 'Version 21H2 (OS build 20348)'
                $Results.Build | Should -Match '^20348\.'
                $Results.'Availability date' | ForEach-Object { Find-ValidDate $_ } | Where-Object { $_ -eq $true }
                $Results.Preview | ForEach-Object { Find-TrueOrFalse $_ } | Where-Object { $_ -eq $true }
                $Results.'Out-of-band' | ForEach-Object { Find-TrueOrFalse $_ } | Where-Object { $_ -eq $true }
                $Results.'Servicing option' | Should -Not -BeNullOrEmpty
                $Results.'KB article' | Should -Match "^KB\d+( / KB\d+)*$|^N/A$"
                $Results.'KB URL' | Should -Match "^\s*(https://support.microsoft.com/([a-z]{2}-[a-z]{2})?/help/\d+)\s*$|^\s*N/A\s*$"
                $Results.'Catalog URL' | Should -Match "https://www.catalog.update.microsoft.com/Search.aspx\?q=KB\d+|^N/A$"
            }
        }
        Context "Server 2022 Hotpatch (21H2)" {
            It "Results" {
                $Results = Get-LatestOSBuild -OSName Server2022Hotpatch -OSVersion 21H2 -latestreleases 1000
                Start-Sleep -Seconds 0
                $Results.Build.Count | Should -BeGreaterThan 0
                $Results.Version | Should -Contain 'Version 21H2 (OS build 20348)'
                (($Results.Build -match '^20348\.') -or ($Results.Build -match 'Security Update')) | Should -BeTrue
                $Results.'Availability date' | ForEach-Object { Find-ValidDate $_ } | Where-Object { $_ -eq $true }
                $Results.Hotpatch | Should -Not -BeNullOrEmpty
                $Results.Preview | ForEach-Object { Find-TrueOrFalse $_ } | Where-Object { $_ -eq $true }
                $Results.'Out-of-band' | ForEach-Object { Find-TrueOrFalse $_ } | Where-Object { $_ -eq $true }
                $Results.'Servicing option' | Should -Not -BeNullOrEmpty
                $Results.'KB article' | Should -Match "^KB\d+( / KB\d+)*$|^N/A$"
                $Results.'KB URL' | Should -Match "^\s*(https://support.microsoft.com/([a-z]{2}-[a-z]{2})?/help/\d+)\s*$|^\s*N/A\s*$"
                $Results.'Catalog URL' | Should -Match "https://www.catalog.update.microsoft.com/Search.aspx\?q=KB\d+|^N/A$"
            }
        }
        Context "Server 2025 (24H2)" {
            It "Results" {
                $Results = Get-LatestOSBuild -OSName Server2025 -OSVersion 24H2 -latestreleases 1000
                Start-Sleep -Seconds 0
                $Results.Build.Count | Should -BeGreaterThan 0
                $Results.Version | Should -Contain 'Version 24H2 (OS build 26100)'
                $Results.Build | Should -Match '^26100\.'
                $Results.'Availability date' | ForEach-Object { Find-ValidDate $_ } | Where-Object { $_ -eq $true }
                $Results.Preview | ForEach-Object { Find-TrueOrFalse $_ } | Where-Object { $_ -eq $true }
                $Results.'Out-of-band' | ForEach-Object { Find-TrueOrFalse $_ } | Where-Object { $_ -eq $true }
                $Results.'Servicing option' | Should -Not -BeNullOrEmpty
                $Results.'KB article' | Should -Match "^KB\d+( / KB\d+)*$|^N/A$"
                $Results.'KB URL' | Should -Match "^\s*(https://support.microsoft.com/([a-z]{2}-[a-z]{2})?/help/\d+)\s*$|^\s*N/A\s*$"
                $Results.'Catalog URL' | Should -Match "https://www.catalog.update.microsoft.com/Search.aspx\?q=KB\d+|^N/A$"
            }
        }
        Context "Server 2025 Hotpatch (24H2)" {
            It "Results" {
                $Results = Get-LatestOSBuild -OSName Server2025Hotpatch -OSVersion 24H2 -latestreleases 1000
                Start-Sleep -Seconds 0
                $Results.Build.Count | Should -BeGreaterThan 0
                $Results.Version | Should -Contain 'Version 24H2 (OS build 26100)'
                (($Results.Build -match '^26100\.') -or ($Results.Build -match 'Security Update')) | Should -BeTrue
                $Results.'Availability date' | ForEach-Object { Find-ValidDate $_ } | Where-Object { $_ -eq $true }
                $Results.Hotpatch | Should -Not -BeNullOrEmpty
                $Results.Preview | ForEach-Object { Find-TrueOrFalse $_ } | Where-Object { $_ -eq $true }
                $Results.'Out-of-band' | ForEach-Object { Find-TrueOrFalse $_ } | Where-Object { $_ -eq $true }
                $Results.'Servicing option' | Should -Not -BeNullOrEmpty
                $Results.'KB article' | Should -Match "^KB\d+( / KB\d+)*$|^N/A$"
                $Results.'KB URL' | Should -Match "^\s*(https://support.microsoft.com/([a-z]{2}-[a-z]{2})?/help/\d+)\s*$|^\s*N/A\s*$"
                $Results.'Catalog URL' | Should -Match "https://www.catalog.update.microsoft.com/Search.aspx\?q=KB\d+|^N/A$"
            }
        }
        Context "Server SAC (1709)" {
            It "Results" {
                $Results = Get-LatestOSBuild -OSName ServerSAC -OSVersion 1709 -latestreleases 1000
                Start-Sleep -Seconds 0
                $Results.Build.Count | Should -BeGreaterThan 0
                $Results.Version | Should -Contain 'Version 1709 (OS build 16299)'
                $Results.Build | Should -Match '^16299\.'
                $Results.'Availability date' | ForEach-Object { Find-ValidDate $_ } | Where-Object { $_ -eq $true }
                $Results.Preview | ForEach-Object { Find-TrueOrFalse $_ } | Where-Object { $_ -eq $true }
                $Results.'Out-of-band' | ForEach-Object { Find-TrueOrFalse $_ } | Where-Object { $_ -eq $true }
                $Results.'Servicing option' | Should -Not -BeNullOrEmpty
                $Results.'KB article' | Should -Match "^KB\d+( / KB\d+)*$|^N/A$"
                $Results.'KB URL' | Should -Match "^\s*(https://support.microsoft.com/([a-z]{2}-[a-z]{2})?/help/\d+)\s*$|^\s*N/A\s*$"
                $Results.'Catalog URL' | Should -Match "https://www.catalog.update.microsoft.com/Search.aspx\?q=KB\d+|^N/A$"
            }
        }
    }
    Describe "PS - Get-CurrentOSBuild" {
        Context "Build only" {
            It "Results" {
                $Results = Get-CurrentOSBuild
                Start-Sleep -Seconds 0
                $Results.Count | Should -Be 1
            }
        }
        Context "Detailed" {
            It "Results" {
                $Results = Get-CurrentOSBuild -Detailed
                Start-Sleep -Seconds 0
                $Results.Build.Count | Should -Be 1
                $Results.Version | Should -Not -BeNullOrEmpty
                $Results.Build | Should -Not -BeNullOrEmpty
                $Results.'Availability date' | ForEach-Object { Find-ValidDate $_ } | Where-Object { $_ -eq $true }
                $Results.Preview | ForEach-Object { Find-TrueOrFalse $_ } | Where-Object { $_ -eq $true }
                $Results.'Out-of-band' | ForEach-Object { Find-TrueOrFalse $_ } | Where-Object { $_ -eq $true }
                $Results.'Servicing option' | Should -Not -BeNullOrEmpty
                $Results.'KB article' | Should -Match "^KB\d+( / KB\d+)*$|^N/A$"
                $Results.'KB URL' | Should -Match "^\s*(https://support.microsoft.com/([a-z]{2}-[a-z]{2})?/help/\d+)\s*$|^\s*N/A\s*$"
                $Results.'Catalog URL' | Should -Match "https://www.catalog.update.microsoft.com/Search.aspx\?q=KB\d+|^N/A$"
            }
        }
        Describe "PS - Get-CurrentOSBuild" {
            Context "Build only" {
                It "Results" {
                    $Results = Get-CurrentOSBuild
                    Start-Sleep -Seconds 0
                    $Results.Count | Should -Be 1
                }
            }
        }
        Context "Detailed" {
            It "Results" {
                $Results = Get-CurrentOSBuild -Detailed
                Start-Sleep -Seconds 0
                $Results.Build.Count | Should -Be 1
                $Results.Version | Should -Not -BeNullOrEmpty
                $Results.Build | Should -Not -BeNullOrEmpty
                $Results.'Availability date' | ForEach-Object { Find-ValidDate $_ } | Where-Object { $_ -eq $true }
                $Results.Preview | ForEach-Object { Find-TrueOrFalse $_ } | Where-Object { $_ -eq $true }
                $Results.'Out-of-band' | ForEach-Object { Find-TrueOrFalse $_ } | Where-Object { $_ -eq $true }
                $Results.'Servicing option' | Should -Not -BeNullOrEmpty
                $Results.'KB article' | Should -Match "^KB\d+( / KB\d+)*$|^N/A$"
                $Results.'KB URL' | Should -Match "^\s*(https://support.microsoft.com/([a-z]{2}-[a-z]{2})?/help/\d+)\s*$|^\s*N/A\s*$"
                $Results.'Catalog URL' | Should -Match "https://www.catalog.update.microsoft.com/Search.aspx\?q=KB\d+|^N/A$"
            }
        }
        Describe "Code Signing Certificate Test - WindowsOSBuild.psm1" {
            Context "File Signature Check" {
                It "Results" {
                    $signature = Get-AuthenticodeSignature -FilePath "$((Split-Path -Path $PSScriptRoot -Parent).TrimEnd('\'))\WindowsOSBuild.psm1"
                    $signature | Should -Not -BeNullOrEmpty
                    $signature.SignatureType| Should -Be "Authenticode"
                    $signature.Status | Should -Be "Valid"
                }
            }
        }
        Describe "Code Signing Certificate Test - WindowsOSBuild.psd1" {
            Context "File Signature Check" {
                It "Results" {
                    $signature = Get-AuthenticodeSignature -FilePath "$((Split-Path -Path $PSScriptRoot -Parent).TrimEnd('\'))\WindowsOSBuild.psd1"
                    $signature | Should -Not -BeNullOrEmpty
                    $signature.SignatureType| Should -Be "Authenticode"
                    $signature.Status | Should -Be "Valid"
                }
            }
        }
        Describe "Code Signing Certificate Test - Get-CurrentOSBuild.ps1" {
            Context "File Signature Check" {
                It "Results" {
                    $signature = Get-AuthenticodeSignature -FilePath "$((Split-Path -Path $PSScriptRoot -Parent).TrimEnd('\'))\Public\Get-CurrentOSBuild.ps1"
                    $signature | Should -Not -BeNullOrEmpty
                    $signature.SignatureType| Should -Be "Authenticode"
                    $signature.Status | Should -Be "Valid"
                }
            }
        }
        Describe "Code Signing Certificate Test - Get-LatestOSBuild.ps1" {
            Context "File Signature Check" {
                It "Results" {
                    $signature = Get-AuthenticodeSignature -FilePath "$((Split-Path -Path $PSScriptRoot -Parent).TrimEnd('\'))\Public\Get-LatestOSBuild.ps1"
                    $signature | Should -Not -BeNullOrEmpty
                    $signature.SignatureType| Should -Be "Authenticode"
                    $signature.Status | Should -Be "Valid"
                }
            }
        }
        Describe "Code Signing Certificate Test - Import-HtmlAgilityPack.ps1" {
            Context "File Signature Check" {
                It "Results" {
                    $signature = Get-AuthenticodeSignature -FilePath "$((Split-Path -Path $PSScriptRoot -Parent).TrimEnd('\'))\Private\Import-HtmlAgilityPack.ps1"
                    $signature | Should -Not -BeNullOrEmpty
                    $signature.SignatureType| Should -Be "Authenticode"
                    $signature.Status | Should -Be "Valid"
                }
            }
        }
        Describe "Code Signing Certificate Test - WindowOSBuild.Tests.ps1" {
            Context "File Signature Check" {
                It "Results" {
                    $signature = Get-AuthenticodeSignature -FilePath "$((Split-Path -Path $PSScriptRoot -Parent).TrimEnd('\'))\CI\WindowOSBuild.Tests.ps1"
                    $signature | Should -Not -BeNullOrEmpty
                    $signature.SignatureType| Should -Be "Authenticode"
                    $signature.Status | Should -Be "Valid"
                }
            }
        }
    }
}
Else {
    Describe "PWSH - Get-LatestOSBuild" {
        Describe "PS - Get-LatestOSBuild" {
            Context "Win 10 (1507)" {
                It "Results" {
                    $Results = Get-LatestOSBuild -OSName Win10 -OSVersion 1507 -latestreleases 1000
                    Start-Sleep -Seconds 0
                    $Results.Build.Count | Should -BeGreaterThan 0
                    $Results.Version | Should -Contain 'Version 1507 (RTM) (OS build 10240)'
                    $Results.Build | Should -Match '^10240\.'
                    $Results.'Availability date' | ForEach-Object { Find-ValidDate $_ } | Where-Object { $_ -eq $true }
                    $Results.Preview | ForEach-Object { Find-TrueOrFalse $_ } | Where-Object { $_ -eq $true }
                    $Results.'Out-of-band' | ForEach-Object { Find-TrueOrFalse $_ } | Where-Object { $_ -eq $true }
                    $Results.'Servicing option' | Should -Not -BeNullOrEmpty
                    $Results.'Servicing option' | ForEach-Object { $_ -match "â€¢|\u2022" } | Where-Object { $_ -eq $true }
                    $Results.'KB article' | Should -Match "^KB\d+( / KB\d+)*$|^N/A$"
                    $Results.'KB URL' | Should -Match "^\s*(https://support.microsoft.com/([a-z]{2}-[a-z]{2})?/help/\d+)\s*$|^\s*N/A\s*$"
                    $Results.'Catalog URL' | Should -Match "https://www.catalog.update.microsoft.com/Search.aspx\?q=KB\d+|^N/A$"
                }
            }
            Context "Win 10 (1511)" {
                It "Results" {
                    $Results = Get-LatestOSBuild -OSName Win10 -OSVersion 1511 -latestreleases 1000
                    Start-Sleep -Seconds 0
                    $Results.Build.Count | Should -BeGreaterThan 0
                    $Results.Version | Should -Contain 'Version 1511 (OS build 10586)'
                    $Results.Build | Should -Match '^10586\.'
                    $Results.'Availability date' | ForEach-Object { Find-ValidDate $_ } | Where-Object { $_ -eq $true }
                    $Results.Preview | ForEach-Object { Find-TrueOrFalse $_ } | Where-Object { $_ -eq $true }
                    $Results.'Out-of-band' | ForEach-Object { Find-TrueOrFalse $_ } | Where-Object { $_ -eq $true }
                    $Results.'Servicing option' | Should -Not -BeNullOrEmpty
                    $Results.'Servicing option' | ForEach-Object { $_ -match "â€¢|\u2022" } | Where-Object { $_ -eq $true }
                    $Results.'KB article' | Should -Match "^KB\d+( / KB\d+)*$|^N/A$"
                    $Results.'KB URL' | Should -Match "^\s*(https://support.microsoft.com/([a-z]{2}-[a-z]{2})?/help/\d+)\s*$|^\s*N/A\s*$"
                    $Results.'Catalog URL' | Should -Match "https://www.catalog.update.microsoft.com/Search.aspx\?q=KB\d+|^N/A$"
                }
            }
            Context "Win 10 / Server 2016 (1607)" {
                It "Results" {
                    $Results = Get-LatestOSBuild -OSName Win10 -OSVersion 1607 -latestreleases 1000
                    Start-Sleep -Seconds 0
                    $Results.Build.Count | Should -BeGreaterThan 0
                    $Results.Version | Should -Contain 'Version 1607 (OS build 14393)'
                    $Results.Build | Should -Match '^14393\.'
                    $Results.'Availability date' | ForEach-Object { Find-ValidDate $_ } | Where-Object { $_ -eq $true }
                    $Results.Preview | ForEach-Object { Find-TrueOrFalse $_ } | Where-Object { $_ -eq $true }
                    $Results.'Out-of-band' | ForEach-Object { Find-TrueOrFalse $_ } | Where-Object { $_ -eq $true }
                    $Results.'Servicing option' | Should -Not -BeNullOrEmpty
                    $Results.'Servicing option' | ForEach-Object { $_ -match "â€¢|\u2022" } | Where-Object { $_ -eq $true }
                    $Results.'KB article' | Should -Match "^KB\d+( / KB\d+)*$|^N/A$"
                    $Results.'KB URL' | Should -Match "^\s*(https://support.microsoft.com/([a-z]{2}-[a-z]{2})?/help/\d+)\s*$|^\s*N/A\s*$"
                    $Results.'Catalog URL' | Should -Match "https://www.catalog.update.microsoft.com/Search.aspx\?q=KB\d+|^N/A$"
                }
            }
            Context "Win 10 (1703)" {
                It "Results" {
                    $Results = Get-LatestOSBuild -OSName Win10 -OSVersion 1703 -latestreleases 1000
                    Start-Sleep -Seconds 0
                    $Results.Build.Count | Should -BeGreaterThan 0
                    $Results.Version | Should -Contain 'Version 1703 (OS build 15063)'
                    $Results.Build | Should -Match '^15063\.'
                    $Results.'Availability date' | ForEach-Object { Find-ValidDate $_ } | Where-Object { $_ -eq $true }
                    $Results.Preview | ForEach-Object { Find-TrueOrFalse $_ } | Where-Object { $_ -eq $true }
                    $Results.'Out-of-band' | ForEach-Object { Find-TrueOrFalse $_ } | Where-Object { $_ -eq $true }
                    $Results.'Servicing option' | Should -Not -BeNullOrEmpty
                    $Results.'Servicing option' | ForEach-Object { $_ -match "â€¢|\u2022" } | Where-Object { $_ -eq $true }
                    $Results.'KB article' | Should -Match "^KB\d+( / KB\d+)*$|^N/A$"
                    $Results.'KB URL' | Should -Match "^\s*(https://support.microsoft.com/([a-z]{2}-[a-z]{2})?/help/\d+)\s*$|^\s*N/A\s*$"
                    $Results.'Catalog URL' | Should -Match "https://www.catalog.update.microsoft.com/Search.aspx\?q=KB\d+|^N/A$"
                }
            }
            Context "Win 10 (1709)" {
                It "Results" {
                    $Results = Get-LatestOSBuild -OSName Win10 -OSVersion 1709 -latestreleases 1000
                    Start-Sleep -Seconds 0
                    $Results.Build.Count | Should -BeGreaterThan 0
                    $Results.Version | Should -Contain 'Version 1709 (OS build 16299)'
                    $Results.Build | Should -Match '^16299\.'
                    $Results.'Availability date' | ForEach-Object { Find-ValidDate $_ } | Where-Object { $_ -eq $true }
                    $Results.Preview | ForEach-Object { Find-TrueOrFalse $_ } | Where-Object { $_ -eq $true }
                    $Results.'Out-of-band' | ForEach-Object { Find-TrueOrFalse $_ } | Where-Object { $_ -eq $true }
                    $Results.'Servicing option' | Should -Not -BeNullOrEmpty
                    $Results.'Servicing option' | ForEach-Object { $_ -match "â€¢|\u2022" } | Where-Object { $_ -eq $true }
                    $Results.'KB article' | Should -Match "^KB\d+( / KB\d+)*$|^N/A$"
                    $Results.'KB URL' | Should -Match "^\s*(https://support.microsoft.com/([a-z]{2}-[a-z]{2})?/help/\d+)\s*$|^\s*N/A\s*$"
                    $Results.'Catalog URL' | Should -Match "https://www.catalog.update.microsoft.com/Search.aspx\?q=KB\d+|^N/A$"
                }
            }
            Context "Win 10 (1803)" {
                It "Results" {
                    $Results = Get-LatestOSBuild -OSName Win10 -OSVersion 1803 -latestreleases 1000
                    Start-Sleep -Seconds 0
                    $Results.Build.Count | Should -BeGreaterThan 0
                    $Results.Version | Should -Contain 'Version 1803 (OS build 17134)'
                    $Results.Build | Should -Match '^17134\.'
                    $Results.'Availability date' | ForEach-Object { Find-ValidDate $_ } | Where-Object { $_ -eq $true }
                    $Results.Preview | ForEach-Object { Find-TrueOrFalse $_ } | Where-Object { $_ -eq $true }
                    $Results.'Out-of-band' | ForEach-Object { Find-TrueOrFalse $_ } | Where-Object { $_ -eq $true }
                    $Results.'Servicing option' | Should -Not -BeNullOrEmpty
                    $Results.'Servicing option' | ForEach-Object { $_ -match "â€¢|\u2022" } | Where-Object { $_ -eq $true }
                    $Results.'KB article' | Should -Match "^KB\d+( / KB\d+)*$|^N/A$"
                    $Results.'KB URL' | Should -Match "^\s*(https://support.microsoft.com/([a-z]{2}-[a-z]{2})?/help/\d+)\s*$|^\s*N/A\s*$"
                    $Results.'Catalog URL' | Should -Match "https://www.catalog.update.microsoft.com/Search.aspx\?q=KB\d+|^N/A$"
                }
            }
            Context "Win 10 / Server 2019 (1809)" {
                It "Results" {
                    $Results = Get-LatestOSBuild -OSName Win10 -OSVersion 1809 -latestreleases 1000
                    Start-Sleep -Seconds 0
                    $Results.Build.Count | Should -BeGreaterThan 0
                    $Results.Version | Should -Contain 'Version 1809 (OS build 17763)'
                    $Results.Build | Should -Match '^17763\.'
                    $Results.'Availability date' | ForEach-Object { Find-ValidDate $_ } | Where-Object { $_ -eq $true }
                    $Results.Preview | ForEach-Object { Find-TrueOrFalse $_ } | Where-Object { $_ -eq $true }
                    $Results.'Out-of-band' | ForEach-Object { Find-TrueOrFalse $_ } | Where-Object { $_ -eq $true }
                    $Results.'Servicing option' | Should -Not -BeNullOrEmpty
                    $Results.'Servicing option' | ForEach-Object { $_ -match "â€¢|\u2022" } | Where-Object { $_ -eq $true }
                    $Results.'KB article' | Should -Match "^KB\d+( / KB\d+)*$|^N/A$"
                    $Results.'KB URL' | Should -Match "^\s*(https://support.microsoft.com/([a-z]{2}-[a-z]{2})?/help/\d+)\s*$|^\s*N/A\s*$"
                    $Results.'Catalog URL' | Should -Match "https://www.catalog.update.microsoft.com/Search.aspx\?q=KB\d+|^N/A$"
                }
            }
            Context "Win 10 (1903)" {
                It "Results" {
                    $Results = Get-LatestOSBuild -OSName Win10 -OSVersion 1903 -latestreleases 1000
                    Start-Sleep -Seconds 0
                    $Results.Build.Count | Should -BeGreaterThan 0
                    $Results.Version | Should -Contain 'Version 1903 (OS build 18362)'
                    $Results.Build | Should -Match '^18362\.'
                    $Results.'Availability date' | ForEach-Object { Find-ValidDate $_ } | Where-Object { $_ -eq $true }
                    $Results.Preview | ForEach-Object { Find-TrueOrFalse $_ } | Where-Object { $_ -eq $true }
                    $Results.'Out-of-band' | ForEach-Object { Find-TrueOrFalse $_ } | Where-Object { $_ -eq $true }
                    $Results.'Servicing option' | Should -Not -BeNullOrEmpty
                    $Results.'KB article' | Should -Match "^KB\d+( / KB\d+)*$|^N/A$"
                    $Results.'KB URL' | Should -Match "^\s*(https://support.microsoft.com/([a-z]{2}-[a-z]{2})?/help/\d+)\s*$|^\s*N/A\s*$"
                    $Results.'Catalog URL' | Should -Match "https://www.catalog.update.microsoft.com/Search.aspx\?q=KB\d+|^N/A$"
                }
            }
            Context "Win 10 (1909)" {
                It "Results" {
                    $Results = Get-LatestOSBuild -OSName Win10 -OSVersion 1909 -latestreleases 1000
                    Start-Sleep -Seconds 0
                    $Results.Build.Count | Should -BeGreaterThan 0
                    $Results.Version | Should -Contain 'Version 1909 (OS build 18363)'
                    $Results.Build | Should -Match '^18363\.'
                    $Results.'Availability date' | ForEach-Object { Find-ValidDate $_ } | Where-Object { $_ -eq $true }
                    $Results.Preview | ForEach-Object { Find-TrueOrFalse $_ } | Where-Object { $_ -eq $true }
                    $Results.'Out-of-band' | ForEach-Object { Find-TrueOrFalse $_ } | Where-Object { $_ -eq $true }
                    $Results.'Servicing option' | Should -Not -BeNullOrEmpty
                    $Results.'KB article' | Should -Match "^KB\d+( / KB\d+)*$|^N/A$"
                    $Results.'KB URL' | Should -Match "^\s*(https://support.microsoft.com/([a-z]{2}-[a-z]{2})?/help/\d+)\s*$|^\s*N/A\s*$"
                    $Results.'Catalog URL' | Should -Match "https://www.catalog.update.microsoft.com/Search.aspx\?q=KB\d+|^N/A$"
                }
            }
            Context "Win 10 (2004)" {
                It "Results" {
                    $Results = Get-LatestOSBuild -OSName Win10 -OSVersion 2004 -latestreleases 1000
                    Start-Sleep -Seconds 0
                    $Results.Build.Count | Should -BeGreaterThan 0
                    $Results.Version | Should -Contain 'Version 2004 (OS build 19041)'
                    $Results.Build | Should -Match '^19041\.'
                    $Results.'Availability date' | ForEach-Object { Find-ValidDate $_ } | Where-Object { $_ -eq $true }
                    $Results.Preview | ForEach-Object { Find-TrueOrFalse $_ } | Where-Object { $_ -eq $true }
                    $Results.'Out-of-band' | ForEach-Object { Find-TrueOrFalse $_ } | Where-Object { $_ -eq $true }
                    $Results.'Servicing option' | Should -Not -BeNullOrEmpty
                    $Results.'KB article' | Should -Match "^KB\d+( / KB\d+)*$|^N/A$"
                    $Results.'KB URL' | Should -Match "^\s*(https://support.microsoft.com/([a-z]{2}-[a-z]{2})?/help/\d+)\s*$|^\s*N/A\s*$"
                    $Results.'Catalog URL' | Should -Match "https://www.catalog.update.microsoft.com/Search.aspx\?q=KB\d+|^N/A$"
                }
            }
            Context "Win 10 (20H2)" {
                It "Results" {
                    $Results = Get-LatestOSBuild -OSName Win10 -OSVersion 20H2 -latestreleases 1000
                    Start-Sleep -Seconds 0
                    $Results.Build.Count | Should -BeGreaterThan 0
                    $Results.Version | Should -Contain 'Version 20H2 (OS build 19042)'
                    $Results.Build | Should -Match '^19042\.'
                    $Results.'Availability date' | ForEach-Object { Find-ValidDate $_ } | Where-Object { $_ -eq $true }
                    $Results.Preview | ForEach-Object { Find-TrueOrFalse $_ } | Where-Object { $_ -eq $true }
                    $Results.'Out-of-band' | ForEach-Object { Find-TrueOrFalse $_ } | Where-Object { $_ -eq $true }
                    $Results.'Servicing option' | Should -Not -BeNullOrEmpty
                    $Results.'KB article' | Should -Match "^KB\d+( / KB\d+)*$|^N/A$"
                    $Results.'KB URL' | Should -Match "^\s*(https://support.microsoft.com/([a-z]{2}-[a-z]{2})?/help/\d+)\s*$|^\s*N/A\s*$"
                    $Results.'Catalog URL' | Should -Match "https://www.catalog.update.microsoft.com/Search.aspx\?q=KB\d+|^N/A$"
                }
            }
            Context "Win 10 (21H1)" {
                It "Results" {
                    $Results = Get-LatestOSBuild -OSName Win10 -OSVersion 21H1 -latestreleases 1000
                    Start-Sleep -Seconds 0
                    $Results.Build.Count | Should -BeGreaterThan 0
                    $Results.Version | Should -Contain 'Version 21H1 (OS build 19043)'
                    $Results.Build | Should -Match '^19043\.'
                    $Results.'Availability date' | ForEach-Object { Find-ValidDate $_ } | Where-Object { $_ -eq $true }
                    $Results.Preview | ForEach-Object { Find-TrueOrFalse $_ } | Where-Object { $_ -eq $true }
                    $Results.'Out-of-band' | ForEach-Object { Find-TrueOrFalse $_ } | Where-Object { $_ -eq $true }
                    $Results.'Servicing option' | Should -Not -BeNullOrEmpty
                    $Results.'KB article' | Should -Match "^KB\d+( / KB\d+)*$|^N/A$"
                    $Results.'KB URL' | Should -Match "^\s*(https://support.microsoft.com/([a-z]{2}-[a-z]{2})?/help/\d+)\s*$|^\s*N/A\s*$"
                    $Results.'Catalog URL' | Should -Match "https://www.catalog.update.microsoft.com/Search.aspx\?q=KB\d+|^N/A$"
                }
            }
            Context "Win 10 (21H2)" {
                It "Results" {
                    $Results = Get-LatestOSBuild -OSName Win10 -OSVersion 21H2 -latestreleases 1000
                    Start-Sleep -Seconds 0
                    $Results.Build.Count | Should -BeGreaterThan 0
                    $Results.Version | Should -Contain 'Version 21H2 (OS build 19044)'
                    $Results.Build | Should -Match '^19044\.'
                    $Results.'Availability date' | ForEach-Object { Find-ValidDate $_ } | Where-Object { $_ -eq $true }
                    $Results.Preview | ForEach-Object { Find-TrueOrFalse $_ } | Where-Object { $_ -eq $true }
                    $Results.'Out-of-band' | ForEach-Object { Find-TrueOrFalse $_ } | Where-Object { $_ -eq $true }
                    $Results.'Servicing option' | Should -Not -BeNullOrEmpty
                    $Results.'Servicing option' | ForEach-Object { $_ -match "â€¢|\u2022" } | Where-Object { $_ -eq $true }
                    $Results.'KB article' | Should -Match "^KB\d+( / KB\d+)*$|^N/A$"
                    $Results.'KB URL' | Should -Match "^\s*(https://support.microsoft.com/([a-z]{2}-[a-z]{2})?/help/\d+)\s*$|^\s*N/A\s*$"
                    $Results.'Catalog URL' | Should -Match "https://www.catalog.update.microsoft.com/Search.aspx\?q=KB\d+|^N/A$"
                }
            }
            Context "Win 10 (22H2)" {
                It "Results" {
                    $Results = Get-LatestOSBuild -OSName Win10 -OSVersion 22H2 -latestreleases 1000
                    Start-Sleep -Seconds 0
                    $Results.Build.Count | Should -BeGreaterThan 0
                    $Results.Version | Should -Contain 'Version 22H2 (OS build 19045)'
                    $Results.Build | Should -Match '^19045\.'
                    $Results.'Availability date' | ForEach-Object { Find-ValidDate $_ } | Where-Object { $_ -eq $true }
                    $Results.Preview | ForEach-Object { Find-TrueOrFalse $_ } | Where-Object { $_ -eq $true }
                    $Results.'Out-of-band' | ForEach-Object { Find-TrueOrFalse $_ } | Where-Object { $_ -eq $true }
                    $Results.'Servicing option' | Should -Not -BeNullOrEmpty
                    $Results.'KB article' | Should -Match "^KB\d+( / KB\d+)*$|^N/A$"
                    $Results.'KB URL' | Should -Match "^\s*(https://support.microsoft.com/([a-z]{2}-[a-z]{2})?/help/\d+)\s*$|^\s*N/A\s*$"
                    $Results.'Catalog URL' | Should -Match "https://www.catalog.update.microsoft.com/Search.aspx\?q=KB\d+|^N/A$"
                }
            }
            Context "Win 11 (21H2)" {
                It "Results" {
                    $Results = Get-LatestOSBuild -OSName Win11 -OSVersion 21H2 -latestreleases 1000
                    Start-Sleep -Seconds 0
                    $Results.Build.Count | Should -BeGreaterThan 0
                    $Results.Version | Should -Contain 'Version 21H2 (OS build 22000)'
                    $Results.Build | Should -Match '^22000\.'
                    $Results.'Availability date' | ForEach-Object { Find-ValidDate $_ } | Where-Object { $_ -eq $true }
                    $Results.Preview | ForEach-Object { Find-TrueOrFalse $_ } | Where-Object { $_ -eq $true }
                    $Results.'Out-of-band' | ForEach-Object { Find-TrueOrFalse $_ } | Where-Object { $_ -eq $true }
                    $Results.'Servicing option' | Should -Not -BeNullOrEmpty
                    $Results.'KB article' | Should -Match "^KB\d+( / KB\d+)*$|^N/A$"
                    $Results.'KB URL' | Should -Match "^\s*(https://support.microsoft.com/([a-z]{2}-[a-z]{2})?/help/\d+)\s*$|^\s*N/A\s*$"
                    $Results.'Catalog URL' | Should -Match "https://www.catalog.update.microsoft.com/Search.aspx\?q=KB\d+|^N/A$"
                }
            }
            Context "Win 11 (22H2)" {
                It "Results" {
                    $Results = Get-LatestOSBuild -OSName Win11 -OSVersion 22H2 -latestreleases 1000
                    Start-Sleep -Seconds 0
                    $Results.Build.Count | Should -BeGreaterThan 0
                    $Results.Version | Should -Contain 'Version 22H2 (OS build 22621)'
                    $Results.Build | Should -Match '^22621\.'
                    $Results.'Availability date' | ForEach-Object { Find-ValidDate $_ } | Where-Object { $_ -eq $true }
                    $Results.Preview | ForEach-Object { Find-TrueOrFalse $_ } | Where-Object { $_ -eq $true }
                    $Results.'Out-of-band' | ForEach-Object { Find-TrueOrFalse $_ } | Where-Object { $_ -eq $true }
                    $Results.'Servicing option' | Should -Not -BeNullOrEmpty
                    $Results.'KB article' | Should -Match "^KB\d+( / KB\d+)*$|^N/A$"
                    $Results.'KB URL' | Should -Match "^\s*(https://support.microsoft.com/([a-z]{2}-[a-z]{2})?/help/\d+)\s*$|^\s*N/A\s*$"
                    $Results.'Catalog URL' | Should -Match "https://www.catalog.update.microsoft.com/Search.aspx\?q=KB\d+|^N/A$"
                }
            }
            Context "Win 11 (23H2)" {
                It "Results" {
                    $Results = Get-LatestOSBuild -OSName Win11 -OSVersion 23H2 -latestreleases 1000
                    Start-Sleep -Seconds 0
                    $Results.Build.Count | Should -BeGreaterThan 0
                    $Results.Version | Should -Contain 'Version 23H2 (OS build 22631)'
                    $Results.Build | Should -Match '^22631\.'
                    $Results.'Availability date' | ForEach-Object { Find-ValidDate $_ } | Where-Object { $_ -eq $true }
                    $Results.Preview | ForEach-Object { Find-TrueOrFalse $_ } | Where-Object { $_ -eq $true }
                    $Results.'Out-of-band' | ForEach-Object { Find-TrueOrFalse $_ } | Where-Object { $_ -eq $true }
                    $Results.'Servicing option' | Should -Not -BeNullOrEmpty
                    $Results.'KB article' | Should -Match "^KB\d+( / KB\d+)*$|^N/A$"
                    $Results.'KB URL' | Should -Match "^\s*(https://support.microsoft.com/([a-z]{2}-[a-z]{2})?/help/\d+)\s*$|^\s*N/A\s*$"
                    $Results.'Catalog URL' | Should -Match "https://www.catalog.update.microsoft.com/Search.aspx\?q=KB\d+|^N/A$"
                }
            }
            Context "Win 11 (24H2)" {
                It "Results" {
                    $Results = Get-LatestOSBuild -OSName Win11 -OSVersion 24H2 -latestreleases 1000
                    Start-Sleep -Seconds 0
                    $Results.Build.Count | Should -BeGreaterThan 0
                    $Results.Version | Should -Contain 'Version 24H2 (OS build 26100)'
                    $Results.Build | Should -Match '^26100\.'
                    $Results.'Availability date' | ForEach-Object { Find-ValidDate $_ } | Where-Object { $_ -eq $true }
                    $Results.Preview | ForEach-Object { Find-TrueOrFalse $_ } | Where-Object { $_ -eq $true }
                    $Results.'Out-of-band' | ForEach-Object { Find-TrueOrFalse $_ } | Where-Object { $_ -eq $true }
                    $Results.'Servicing option' | Should -Not -BeNullOrEmpty
                    $Results.'KB article' | Should -Match "^KB\d+( / KB\d+)*$|^N/A$"
                    $Results.'KB URL' | Should -Match "^\s*(https://support.microsoft.com/([a-z]{2}-[a-z]{2})?/help/\d+)\s*$|^\s*N/A\s*$"
                    $Results.'Catalog URL' | Should -Match "https://www.catalog.update.microsoft.com/Search.aspx\?q=KB\d+|^N/A$"
                }
            }
            Context "Windows 11 Hotpatch (24H2)" {
                It "Results" {
                    $Results = Get-LatestOSBuild -OSName Win11Hotpatch -OSVersion 24H2 -latestreleases 1000
                    Start-Sleep -Seconds 0
                    $Results.Build.Count | Should -BeGreaterThan 0
                    $Results.Version | Should -Contain 'Version 24H2 (OS build 26100)'
                    (($Results.Build -match '^26100\.') -or ($Results.Build -match 'Security Update')) | Should -BeTrue
                    $Results.'Availability date' | ForEach-Object { Find-ValidDate $_ } | Where-Object { $_ -eq $true }
                    $Results.Hotpatch | Should -Not -BeNullOrEmpty
                    $Results.Preview | ForEach-Object { Find-TrueOrFalse $_ } | Where-Object { $_ -eq $true }
                    $Results.'Out-of-band' | ForEach-Object { Find-TrueOrFalse $_ } | Where-Object { $_ -eq $true }
                    $Results.'Servicing option' | Should -Not -BeNullOrEmpty
                    $Results.'KB article' | Should -Match "^KB\d+( / KB\d+)*$|^N/A$"
                    $Results.'KB URL' | Should -Match "^\s*(https://support.microsoft.com/([a-z]{2}-[a-z]{2})?/help/\d+)\s*$|^\s*N/A\s*$"
                    $Results.'Catalog URL' | Should -Match "https://www.catalog.update.microsoft.com/Search.aspx\?q=KB\d+|^N/A$"
                }
            }
            Context "Server 2022 (21H2)" {
                It "Results" {
                    $Results = Get-LatestOSBuild -OSName Server2022 -OSVersion 21H2 -latestreleases 1000
                    Start-Sleep -Seconds 0
                    $Results.Build.Count | Should -BeGreaterThan 0
                    $Results.Version | Should -Contain 'Version 21H2 (OS build 20348)'
                    $Results.Build | Should -Match '^20348\.'
                    $Results.'Availability date' | ForEach-Object { Find-ValidDate $_ } | Where-Object { $_ -eq $true }
                    $Results.Preview | ForEach-Object { Find-TrueOrFalse $_ } | Where-Object { $_ -eq $true }
                    $Results.'Out-of-band' | ForEach-Object { Find-TrueOrFalse $_ } | Where-Object { $_ -eq $true }
                    $Results.'Servicing option' | Should -Not -BeNullOrEmpty
                    $Results.'KB article' | Should -Match "^KB\d+( / KB\d+)*$|^N/A$"
                    $Results.'KB URL' | Should -Match "^\s*(https://support.microsoft.com/([a-z]{2}-[a-z]{2})?/help/\d+)\s*$|^\s*N/A\s*$"
                    $Results.'Catalog URL' | Should -Match "https://www.catalog.update.microsoft.com/Search.aspx\?q=KB\d+|^N/A$"
                }
            }
            Context "Server 2022 Hotpatch (21H2)" {
                It "Results" {
                    $Results = Get-LatestOSBuild -OSName Server2022Hotpatch -OSVersion 21H2 -latestreleases 1000
                    Start-Sleep -Seconds 0
                    $Results.Build.Count | Should -BeGreaterThan 0
                    $Results.Version | Should -Contain 'Version 21H2 (OS build 20348)'
                    (($Results.Build -match '^20348\.') -or ($Results.Build -match 'Security Update')) | Should -BeTrue
                    $Results.'Availability date' | ForEach-Object { Find-ValidDate $_ } | Where-Object { $_ -eq $true }
                    $Results.Hotpatch | Should -Not -BeNullOrEmpty
                    $Results.Preview | ForEach-Object { Find-TrueOrFalse $_ } | Where-Object { $_ -eq $true }
                    $Results.'Out-of-band' | ForEach-Object { Find-TrueOrFalse $_ } | Where-Object { $_ -eq $true }
                    $Results.'Servicing option' | Should -Not -BeNullOrEmpty
                    $Results.'KB article' | Should -Match "^KB\d+( / KB\d+)*$|^N/A$"
                    $Results.'KB URL' | Should -Match "^\s*(https://support.microsoft.com/([a-z]{2}-[a-z]{2})?/help/\d+)\s*$|^\s*N/A\s*$"
                    $Results.'Catalog URL' | Should -Match "https://www.catalog.update.microsoft.com/Search.aspx\?q=KB\d+|^N/A$"
                }
            }
            Context "Server 2025 (24H2)" {
                It "Results" {
                    $Results = Get-LatestOSBuild -OSName Server2025 -OSVersion 24H2 -latestreleases 1000
                    Start-Sleep -Seconds 0
                    $Results.Build.Count | Should -BeGreaterThan 0
                    $Results.Version | Should -Contain 'Version 24H2 (OS build 26100)'
                    $Results.Build | Should -Match '^26100\.'
                    $Results.'Availability date' | ForEach-Object { Find-ValidDate $_ } | Where-Object { $_ -eq $true }
                    $Results.Preview | ForEach-Object { Find-TrueOrFalse $_ } | Where-Object { $_ -eq $true }
                    $Results.'Out-of-band' | ForEach-Object { Find-TrueOrFalse $_ } | Where-Object { $_ -eq $true }
                    $Results.'Servicing option' | Should -Not -BeNullOrEmpty
                    $Results.'KB article' | Should -Match "^KB\d+( / KB\d+)*$|^N/A$"
                    $Results.'KB URL' | Should -Match "^\s*(https://support.microsoft.com/([a-z]{2}-[a-z]{2})?/help/\d+)\s*$|^\s*N/A\s*$"
                    $Results.'Catalog URL' | Should -Match "https://www.catalog.update.microsoft.com/Search.aspx\?q=KB\d+|^N/A$"
                }
            }
            Context "Server 2025 Hotpatch (24H2)" {
                It "Results" {
                    $Results = Get-LatestOSBuild -OSName Server2025Hotpatch -OSVersion 24H2 -latestreleases 1000
                    Start-Sleep -Seconds 0
                    $Results.Build.Count | Should -BeGreaterThan 0
                    $Results.Version | Should -Contain 'Version 24H2 (OS build 26100)'
                    (($Results.Build -match '^26100\.') -or ($Results.Build -match 'Security Update')) | Should -BeTrue
                    $Results.'Availability date' | ForEach-Object { Find-ValidDate $_ } | Where-Object { $_ -eq $true }
                    $Results.Hotpatch | Should -Not -BeNullOrEmpty
                    $Results.Preview | ForEach-Object { Find-TrueOrFalse $_ } | Where-Object { $_ -eq $true }
                    $Results.'Out-of-band' | ForEach-Object { Find-TrueOrFalse $_ } | Where-Object { $_ -eq $true }
                    $Results.'Servicing option' | Should -Not -BeNullOrEmpty
                    $Results.'KB article' | Should -Match "^KB\d+( / KB\d+)*$|^N/A$"
                    $Results.'KB URL' | Should -Match "^\s*(https://support.microsoft.com/([a-z]{2}-[a-z]{2})?/help/\d+)\s*$|^\s*N/A\s*$"
                    $Results.'Catalog URL' | Should -Match "https://www.catalog.update.microsoft.com/Search.aspx\?q=KB\d+|^N/A$"
                }
            }
            Context "Server SAC (1709)" {
                It "Results" {
                    $Results = Get-LatestOSBuild -OSName ServerSAC -OSVersion 1709 -latestreleases 1000
                    Start-Sleep -Seconds 0
                    $Results.Build.Count | Should -BeGreaterThan 0
                    $Results.Version | Should -Contain 'Version 1709 (OS build 16299)'
                    $Results.Build | Should -Match '^16299\.'
                    $Results.'Availability date' | ForEach-Object { Find-ValidDate $_ } | Where-Object { $_ -eq $true }
                    $Results.Preview | ForEach-Object { Find-TrueOrFalse $_ } | Where-Object { $_ -eq $true }
                    $Results.'Out-of-band' | ForEach-Object { Find-TrueOrFalse $_ } | Where-Object { $_ -eq $true }
                    $Results.'Servicing option' | Should -Not -BeNullOrEmpty
                    $Results.'KB article' | Should -Match "^KB\d+( / KB\d+)*$|^N/A$"
                    $Results.'KB URL' | Should -Match "^\s*(https://support.microsoft.com/([a-z]{2}-[a-z]{2})?/help/\d+)\s*$|^\s*N/A\s*$"
                    $Results.'Catalog URL' | Should -Match "https://www.catalog.update.microsoft.com/Search.aspx\?q=KB\d+|^N/A$"
                }
            }
        }
    }
    Describe "PWSH - Get-CurrentOSBuild" {
        Context "Build only" {
            It "Results" {
                $Results = Get-CurrentOSBuild
                Start-Sleep -Seconds 0
                $Results.Count | Should -Be 1
            }
        }
        Context "Detailed" {
            It "Results" {
                $Results = Get-CurrentOSBuild -Detailed
                Start-Sleep -Seconds 0
                $Results.Build.Count | Should -Be  1
                $Results.Version | Should -Not -BeNullOrEmpty
                $Results.Build | Should -Not -BeNullOrEmpty
                $Results.'Availability date' | ForEach-Object { Find-ValidDate $_ } | Where-Object { $_ -eq $true }
                $Results.Preview | ForEach-Object { Find-TrueOrFalse $_ } | Where-Object { $_ -eq $true }
                $Results.'Out-of-band' | ForEach-Object { Find-TrueOrFalse $_ } | Where-Object { $_ -eq $true }
                $Results.'Servicing option' | Should -Not -BeNullOrEmpty
                $Results.'KB article' | Should -Match "^KB\d+( / KB\d+)*$|^N/A$"
                $Results.'KB URL' | Should -Match "^\s*(https://support.microsoft.com/([a-z]{2}-[a-z]{2})?/help/\d+)\s*$|^\s*N/A\s*$"
                $Results.'Catalog URL' | Should -Match "https://www.catalog.update.microsoft.com/Search.aspx\?q=KB\d+|^N/A$"
            }
        }
        Describe "Code Signing Certificate Test - WindowsOSBuild.psm1" {
            Context "File Signature Check" {
                It "Results" {
                    $signature = Get-AuthenticodeSignature -FilePath "$((Split-Path -Path $PSScriptRoot -Parent).TrimEnd('\'))\WindowsOSBuild.psm1"
                    $signature | Should -Not -BeNullOrEmpty
                    $signature.SignatureType| Should -Be "Authenticode"
                    $signature.Status | Should -Be "Valid"
                }
            }
        }
        Describe "Code Signing Certificate Test - WindowsOSBuild.psd1" {
            Context "File Signature Check" {
                It "Results" {
                    $signature = Get-AuthenticodeSignature -FilePath "$((Split-Path -Path $PSScriptRoot -Parent).TrimEnd('\'))\WindowsOSBuild.psd1"
                    $signature | Should -Not -BeNullOrEmpty
                    $signature.SignatureType| Should -Be "Authenticode"
                    $signature.Status | Should -Be "Valid"
                }
            }
        }
        Describe "Code Signing Certificate Test - Get-CurrentOSBuild.ps1" {
            Context "File Signature Check" {
                It "Results" {
                    $signature = Get-AuthenticodeSignature -FilePath "$((Split-Path -Path $PSScriptRoot -Parent).TrimEnd('\'))\Public\Get-CurrentOSBuild.ps1"
                    $signature | Should -Not -BeNullOrEmpty
                    $signature.SignatureType| Should -Be "Authenticode"
                    $signature.Status | Should -Be "Valid"
                }
            }
        }
        Describe "Code Signing Certificate Test - Get-LatestOSBuild.ps1" {
            Context "File Signature Check" {
                It "Results" {
                    $signature = Get-AuthenticodeSignature -FilePath "$((Split-Path -Path $PSScriptRoot -Parent).TrimEnd('\'))\Public\Get-LatestOSBuild.ps1"
                    $signature | Should -Not -BeNullOrEmpty
                    $signature.SignatureType| Should -Be "Authenticode"
                    $signature.Status | Should -Be "Valid"
                }
            }
        }
        Describe "Code Signing Certificate Test - Import-HtmlAgilityPack.ps1" {
            Context "File Signature Check" {
                It "Results" {
                    $signature = Get-AuthenticodeSignature -FilePath "$((Split-Path -Path $PSScriptRoot -Parent).TrimEnd('\'))\Private\Import-HtmlAgilityPack.ps1"
                    $signature | Should -Not -BeNullOrEmpty
                    $signature.SignatureType| Should -Be "Authenticode"
                    $signature.Status | Should -Be "Valid"
                }
            }
        }
        Describe "Code Signing Certificate Test - WindowOSBuild.Tests.ps1" {
            Context "File Signature Check" {
                It "Results" {
                    $signature = Get-AuthenticodeSignature -FilePath "$((Split-Path -Path $PSScriptRoot -Parent).TrimEnd('\'))\CI\WindowOSBuild.Tests.ps1"
                    $signature | Should -Not -BeNullOrEmpty
                    $signature.SignatureType| Should -Be "Authenticode"
                    $signature.Status | Should -Be "Valid"
                }
            }
        }
    }
}
# SIG # Begin signature block
# MIImoQYJKoZIhvcNAQcCoIImkjCCJo4CAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUGa4a1JkV3hfCOO655q3hFd+N
# FveggiBWMIIFjTCCBHWgAwIBAgIQDpsYjvnQLefv21DiCEAYWjANBgkqhkiG9w0B
# AQwFADBlMQswCQYDVQQGEwJVUzEVMBMGA1UEChMMRGlnaUNlcnQgSW5jMRkwFwYD
# VQQLExB3d3cuZGlnaWNlcnQuY29tMSQwIgYDVQQDExtEaWdpQ2VydCBBc3N1cmVk
# IElEIFJvb3QgQ0EwHhcNMjIwODAxMDAwMDAwWhcNMzExMTA5MjM1OTU5WjBiMQsw
# CQYDVQQGEwJVUzEVMBMGA1UEChMMRGlnaUNlcnQgSW5jMRkwFwYDVQQLExB3d3cu
# ZGlnaWNlcnQuY29tMSEwHwYDVQQDExhEaWdpQ2VydCBUcnVzdGVkIFJvb3QgRzQw
# ggIiMA0GCSqGSIb3DQEBAQUAA4ICDwAwggIKAoICAQC/5pBzaN675F1KPDAiMGkz
# 7MKnJS7JIT3yithZwuEppz1Yq3aaza57G4QNxDAf8xukOBbrVsaXbR2rsnnyyhHS
# 5F/WBTxSD1Ifxp4VpX6+n6lXFllVcq9ok3DCsrp1mWpzMpTREEQQLt+C8weE5nQ7
# bXHiLQwb7iDVySAdYyktzuxeTsiT+CFhmzTrBcZe7FsavOvJz82sNEBfsXpm7nfI
# SKhmV1efVFiODCu3T6cw2Vbuyntd463JT17lNecxy9qTXtyOj4DatpGYQJB5w3jH
# trHEtWoYOAMQjdjUN6QuBX2I9YI+EJFwq1WCQTLX2wRzKm6RAXwhTNS8rhsDdV14
# Ztk6MUSaM0C/CNdaSaTC5qmgZ92kJ7yhTzm1EVgX9yRcRo9k98FpiHaYdj1ZXUJ2
# h4mXaXpI8OCiEhtmmnTK3kse5w5jrubU75KSOp493ADkRSWJtppEGSt+wJS00mFt
# 6zPZxd9LBADMfRyVw4/3IbKyEbe7f/LVjHAsQWCqsWMYRJUadmJ+9oCw++hkpjPR
# iQfhvbfmQ6QYuKZ3AeEPlAwhHbJUKSWJbOUOUlFHdL4mrLZBdd56rF+NP8m800ER
# ElvlEFDrMcXKchYiCd98THU/Y+whX8QgUWtvsauGi0/C1kVfnSD8oR7FwI+isX4K
# Jpn15GkvmB0t9dmpsh3lGwIDAQABo4IBOjCCATYwDwYDVR0TAQH/BAUwAwEB/zAd
# BgNVHQ4EFgQU7NfjgtJxXWRM3y5nP+e6mK4cD08wHwYDVR0jBBgwFoAUReuir/SS
# y4IxLVGLp6chnfNtyA8wDgYDVR0PAQH/BAQDAgGGMHkGCCsGAQUFBwEBBG0wazAk
# BggrBgEFBQcwAYYYaHR0cDovL29jc3AuZGlnaWNlcnQuY29tMEMGCCsGAQUFBzAC
# hjdodHRwOi8vY2FjZXJ0cy5kaWdpY2VydC5jb20vRGlnaUNlcnRBc3N1cmVkSURS
# b290Q0EuY3J0MEUGA1UdHwQ+MDwwOqA4oDaGNGh0dHA6Ly9jcmwzLmRpZ2ljZXJ0
# LmNvbS9EaWdpQ2VydEFzc3VyZWRJRFJvb3RDQS5jcmwwEQYDVR0gBAowCDAGBgRV
# HSAAMA0GCSqGSIb3DQEBDAUAA4IBAQBwoL9DXFXnOF+go3QbPbYW1/e/Vwe9mqyh
# hyzshV6pGrsi+IcaaVQi7aSId229GhT0E0p6Ly23OO/0/4C5+KH38nLeJLxSA8hO
# 0Cre+i1Wz/n096wwepqLsl7Uz9FDRJtDIeuWcqFItJnLnU+nBgMTdydE1Od/6Fmo
# 8L8vC6bp8jQ87PcDx4eo0kxAGTVGamlUsLihVo7spNU96LHc/RzY9HdaXFSMb++h
# UD38dglohJ9vytsgjTVgHAIDyyCwrFigDkBjxZgiwbJZ9VVrzyerbHbObyMt9H5x
# aiNrIv8SuFQtJ37YOtnwtoeW/VvRXKwYw02fc7cBqZ9Xql4o4rmUMIIGWzCCBEOg
# AwIBAgIQKweeTiSV9CRQUMWKtyhRWjANBgkqhkiG9w0BAQsFADBWMQswCQYDVQQG
# EwJQTDEhMB8GA1UEChMYQXNzZWNvIERhdGEgU3lzdGVtcyBTLkEuMSQwIgYDVQQD
# ExtDZXJ0dW0gQ29kZSBTaWduaW5nIDIwMjEgQ0EwHhcNMjUwNzE3MTgyMDIzWhcN
# MjYwNzE3MTgyMDIyWjCBgDELMAkGA1UEBhMCR0IxDzANBgNVBAgMBkRvcnNldDEU
# MBIGA1UEBwwLQk9VUk5FTU9VVEgxHjAcBgNVBAoMFU9wZW4gU291cmNlIERldmVs
# b3BlcjEqMCgGA1UEAwwhT3BlbiBTb3VyY2UgRGV2ZWxvcGVyLCBBU0hMRVkgSE9X
# MIIBojANBgkqhkiG9w0BAQEFAAOCAY8AMIIBigKCAYEA8ap4OjJmSOTr8zBs08vh
# alMD8EclzF4q0ld8A0+bl+uQES+5410cmZWudM9MzM0yn0y3bcOzfjUh57dFhIin
# 4xy6vO03mOAtYG7GzfOu1CO57sx1AFzLMWUwJ1aPiP3hZ2iHa1rW1rYxq39KJSeq
# PxKu3i+sReTW6ac0IV8MedqEto7jVF0El/7Loq4UIaw3+doXo+cjSacrWqW1iGXm
# HEgbM67GRwQI+siJmEMfGaZ258F89pQeFIbUg0dDqntmkW8H7p62yEHwMwZ0y/PK
# paSHwzDOeSlajtvVCE94S/QeepI+Xeqdzem4VIaitSPOLuZ15QGv7J4Iv/BABIps
# r/M9O6BHPUO2mItWR5DerBNbycGHK75S7n3yE0gjwKVrnmlfAG6OGK7qhnRZUawa
# TlsfVSCTkcd9PuOsatdUOOlUKOOjCImoZGNGrGjqxMbKM7MTVh682ydIRbWR166F
# Y/q4dI4e1gwOlSMq5H3zc/yXBmKgFr9DRfQSz53bnQXfAgMBAAGjggF4MIIBdDAM
# BgNVHRMBAf8EAjAAMD0GA1UdHwQ2MDQwMqAwoC6GLGh0dHA6Ly9jY3NjYTIwMjEu
# Y3JsLmNlcnR1bS5wbC9jY3NjYTIwMjEuY3JsMHMGCCsGAQUFBwEBBGcwZTAsBggr
# BgEFBQcwAYYgaHR0cDovL2Njc2NhMjAyMS5vY3NwLWNlcnR1bS5jb20wNQYIKwYB
# BQUHMAKGKWh0dHA6Ly9yZXBvc2l0b3J5LmNlcnR1bS5wbC9jY3NjYTIwMjEuY2Vy
# MB8GA1UdIwQYMBaAFN10XUwA23ufoHTKsW73PMAywHDNMB0GA1UdDgQWBBR8z8z9
# vBIfD+PQrYWR2rBUuO+kazBLBgNVHSAERDBCMAgGBmeBDAEEATA2BgsqhGgBhvZ3
# AgUBBDAnMCUGCCsGAQUFBwIBFhlodHRwczovL3d3dy5jZXJ0dW0ucGwvQ1BTMBMG
# A1UdJQQMMAoGCCsGAQUFBwMDMA4GA1UdDwEB/wQEAwIHgDANBgkqhkiG9w0BAQsF
# AAOCAgEATGEG4d93zWE85Oa+uGtYwV0K4bc9q5KZTsO4kEWIP/PGT4ajFguLrsQE
# cSHtVgMHYOgNl9ux4PPWHyvk7LMEqqKSM54meM2P2NZdzQeaEytVeJlU9SCgPv01
# /UIu3MOkzr215N+QTbcuj1xQjV6gu2A/jD8hqZuZwU2fSV5AC+Yt42WPGixnLcEy
# lYa6M6p01qM2wuKb7Bg3No8exWXLdp2UK7MDZ2eX/n6a8ZqYBTmlZ4TrFsaWO5GD
# 2rDfXjlQdd9fhglv2u5iUnG0rBnnIyi08KyWm61eOrh+0X1l718+ZoPrKGzOzj9F
# p/t6e+5naCvHzukQB/RrbgswPL/zMrRyOoAv0Zsq6WaIb2ZzeYR1s9kx0VS/C2J6
# 8JZf0OMBsRdaTkjwlU09kRLgLGYJMEFvr8BhpIDqfu/cbChFSoL/4r+mRO5n5AcK
# Goauj/sJGNNav0btef6L00kgqITCAxBhPzGllavkD94Lid0UZlc6SnJqqkOS0tRZ
# y1iSLHGcNQ2qYdXK6tyxQfyxsamZnGc9X4QssuiBezqEc6Hz/csaFmxStIBv9Pvv
# r6Yrg/pWUXV6rLfc0vQAyiGBuZngBYcIKStFMYcqrkWCUlrO+WS7TuVFP9PtTvpS
# lF3bM72WyzgkkoUkECq4JQPo5nLk4QY2XPyb5FbXItSy7l6Crjgwgga0MIIEnKAD
# AgECAhANx6xXBf8hmS5AQyIMOkmGMA0GCSqGSIb3DQEBCwUAMGIxCzAJBgNVBAYT
# AlVTMRUwEwYDVQQKEwxEaWdpQ2VydCBJbmMxGTAXBgNVBAsTEHd3dy5kaWdpY2Vy
# dC5jb20xITAfBgNVBAMTGERpZ2lDZXJ0IFRydXN0ZWQgUm9vdCBHNDAeFw0yNTA1
# MDcwMDAwMDBaFw0zODAxMTQyMzU5NTlaMGkxCzAJBgNVBAYTAlVTMRcwFQYDVQQK
# Ew5EaWdpQ2VydCwgSW5jLjFBMD8GA1UEAxM4RGlnaUNlcnQgVHJ1c3RlZCBHNCBU
# aW1lU3RhbXBpbmcgUlNBNDA5NiBTSEEyNTYgMjAyNSBDQTEwggIiMA0GCSqGSIb3
# DQEBAQUAA4ICDwAwggIKAoICAQC0eDHTCphBcr48RsAcrHXbo0ZodLRRF51NrY0N
# lLWZloMsVO1DahGPNRcybEKq+RuwOnPhof6pvF4uGjwjqNjfEvUi6wuim5bap+0l
# gloM2zX4kftn5B1IpYzTqpyFQ/4Bt0mAxAHeHYNnQxqXmRinvuNgxVBdJkf77S2u
# PoCj7GH8BLuxBG5AvftBdsOECS1UkxBvMgEdgkFiDNYiOTx4OtiFcMSkqTtF2hfQ
# z3zQSku2Ws3IfDReb6e3mmdglTcaarps0wjUjsZvkgFkriK9tUKJm/s80FiocSk1
# VYLZlDwFt+cVFBURJg6zMUjZa/zbCclF83bRVFLeGkuAhHiGPMvSGmhgaTzVyhYn
# 4p0+8y9oHRaQT/aofEnS5xLrfxnGpTXiUOeSLsJygoLPp66bkDX1ZlAeSpQl92QO
# MeRxykvq6gbylsXQskBBBnGy3tW/AMOMCZIVNSaz7BX8VtYGqLt9MmeOreGPRdtB
# x3yGOP+rx3rKWDEJlIqLXvJWnY0v5ydPpOjL6s36czwzsucuoKs7Yk/ehb//Wx+5
# kMqIMRvUBDx6z1ev+7psNOdgJMoiwOrUG2ZdSoQbU2rMkpLiQ6bGRinZbI4OLu9B
# MIFm1UUl9VnePs6BaaeEWvjJSjNm2qA+sdFUeEY0qVjPKOWug/G6X5uAiynM7Bu2
# ayBjUwIDAQABo4IBXTCCAVkwEgYDVR0TAQH/BAgwBgEB/wIBADAdBgNVHQ4EFgQU
# 729TSunkBnx6yuKQVvYv1Ensy04wHwYDVR0jBBgwFoAU7NfjgtJxXWRM3y5nP+e6
# mK4cD08wDgYDVR0PAQH/BAQDAgGGMBMGA1UdJQQMMAoGCCsGAQUFBwMIMHcGCCsG
# AQUFBwEBBGswaTAkBggrBgEFBQcwAYYYaHR0cDovL29jc3AuZGlnaWNlcnQuY29t
# MEEGCCsGAQUFBzAChjVodHRwOi8vY2FjZXJ0cy5kaWdpY2VydC5jb20vRGlnaUNl
# cnRUcnVzdGVkUm9vdEc0LmNydDBDBgNVHR8EPDA6MDigNqA0hjJodHRwOi8vY3Js
# My5kaWdpY2VydC5jb20vRGlnaUNlcnRUcnVzdGVkUm9vdEc0LmNybDAgBgNVHSAE
# GTAXMAgGBmeBDAEEAjALBglghkgBhv1sBwEwDQYJKoZIhvcNAQELBQADggIBABfO
# +xaAHP4HPRF2cTC9vgvItTSmf83Qh8WIGjB/T8ObXAZz8OjuhUxjaaFdleMM0lBr
# yPTQM2qEJPe36zwbSI/mS83afsl3YTj+IQhQE7jU/kXjjytJgnn0hvrV6hqWGd3r
# LAUt6vJy9lMDPjTLxLgXf9r5nWMQwr8Myb9rEVKChHyfpzee5kH0F8HABBgr0Udq
# irZ7bowe9Vj2AIMD8liyrukZ2iA/wdG2th9y1IsA0QF8dTXqvcnTmpfeQh35k5zO
# CPmSNq1UH410ANVko43+Cdmu4y81hjajV/gxdEkMx1NKU4uHQcKfZxAvBAKqMVuq
# te69M9J6A47OvgRaPs+2ykgcGV00TYr2Lr3ty9qIijanrUR3anzEwlvzZiiyfTPj
# LbnFRsjsYg39OlV8cipDoq7+qNNjqFzeGxcytL5TTLL4ZaoBdqbhOhZ3ZRDUphPv
# SRmMThi0vw9vODRzW6AxnJll38F0cuJG7uEBYTptMSbhdhGQDpOXgpIUsWTjd6xp
# R6oaQf/DJbg3s6KCLPAlZ66RzIg9sC+NJpud/v4+7RWsWCiKi9EOLLHfMR2ZyJ/+
# xhCx9yHbxtl5TPau1j/1MIDpMPx0LckTetiSuEtQvLsNz3Qbp7wGWqbIiOWCnb5W
# qxL3/BAPvIXKUjPSxyZsq8WhbaM2tszWkPZPubdcMIIGuTCCBKGgAwIBAgIRAJmj
# gAomVTtlq9xuhKaz6jkwDQYJKoZIhvcNAQEMBQAwgYAxCzAJBgNVBAYTAlBMMSIw
# IAYDVQQKExlVbml6ZXRvIFRlY2hub2xvZ2llcyBTLkEuMScwJQYDVQQLEx5DZXJ0
# dW0gQ2VydGlmaWNhdGlvbiBBdXRob3JpdHkxJDAiBgNVBAMTG0NlcnR1bSBUcnVz
# dGVkIE5ldHdvcmsgQ0EgMjAeFw0yMTA1MTkwNTMyMThaFw0zNjA1MTgwNTMyMTha
# MFYxCzAJBgNVBAYTAlBMMSEwHwYDVQQKExhBc3NlY28gRGF0YSBTeXN0ZW1zIFMu
# QS4xJDAiBgNVBAMTG0NlcnR1bSBDb2RlIFNpZ25pbmcgMjAyMSBDQTCCAiIwDQYJ
# KoZIhvcNAQEBBQADggIPADCCAgoCggIBAJ0jzwQwIzvBRiznM3M+Y116dbq+XE26
# vest+L7k5n5TeJkgH4Cyk74IL9uP61olRsxsU/WBAElTMNQI/HsE0uCJ3VPLO1Uu
# fnY0qDHG7yCnJOvoSNbIbMpT+Cci75scCx7UsKK1fcJo4TXetu4du2vEXa09Tx/b
# ndCBfp47zJNsamzUyD7J1rcNxOw5g6FJg0ImIv7nCeNn3B6gZG28WAwe0mDqLrvU
# 49chyKIc7gvCjan3GH+2eP4mYJASflBTQ3HOs6JGdriSMVoD1lzBJobtYDF4L/Gh
# lLEXWgrVQ9m0pW37KuwYqpY42grp/kSYE4BUQrbLgBMNKRvfhQPskDfZ/5GbTCyv
# lqPN+0OEDmYGKlVkOMenDO/xtMrMINRJS5SY+jWCi8PRHAVxO0xdx8m2bWL4/ZQ1
# dp0/JhUpHEpABMc3eKax8GI1F03mSJVV6o/nmmKqDE6TK34eTAgDiBuZJzeEPyR7
# rq30yOVw2DvetlmWssewAhX+cnSaaBKMEj9O2GgYkPJ16Q5Da1APYO6n/6wpCm1q
# UOW6Ln1J6tVImDyAB5Xs3+JriasaiJ7P5KpXeiVV/HIsW3ej85A6cGaOEpQA2got
# iUqZSkoQUjQ9+hPxDVb/Lqz0tMjp6RuLSKARsVQgETwoNQZ8jCeKwSQHDkpwFndf
# CceZ/OfCUqjxAgMBAAGjggFVMIIBUTAPBgNVHRMBAf8EBTADAQH/MB0GA1UdDgQW
# BBTddF1MANt7n6B0yrFu9zzAMsBwzTAfBgNVHSMEGDAWgBS2oVQ5AsOgP46KvPrU
# +Bym0ToO/TAOBgNVHQ8BAf8EBAMCAQYwEwYDVR0lBAwwCgYIKwYBBQUHAwMwMAYD
# VR0fBCkwJzAloCOgIYYfaHR0cDovL2NybC5jZXJ0dW0ucGwvY3RuY2EyLmNybDBs
# BggrBgEFBQcBAQRgMF4wKAYIKwYBBQUHMAGGHGh0dHA6Ly9zdWJjYS5vY3NwLWNl
# cnR1bS5jb20wMgYIKwYBBQUHMAKGJmh0dHA6Ly9yZXBvc2l0b3J5LmNlcnR1bS5w
# bC9jdG5jYTIuY2VyMDkGA1UdIAQyMDAwLgYEVR0gADAmMCQGCCsGAQUFBwIBFhho
# dHRwOi8vd3d3LmNlcnR1bS5wbC9DUFMwDQYJKoZIhvcNAQEMBQADggIBAHWIWA/l
# j1AomlOfEOxD/PQ7bcmahmJ9l0Q4SZC+j/v09CD2csX8Yl7pmJQETIMEcy0VErSZ
# ePdC/eAvSxhd7488x/Cat4ke+AUZZDtfCd8yHZgikGuS8mePCHyAiU2VSXgoQ1Mr
# kMuqxg8S1FALDtHqnizYS1bIMOv8znyJjZQESp9RT+6NH024/IqTRsRwSLrYkbFq
# 4VjNn/KV3Xd8dpmyQiirZdrONoPSlCRxCIi54vQcqKiFLpeBm5S0IoDtLoIe21kS
# w5tAnWPazS6sgN2oXvFpcVVpMcq0C4x/CLSNe0XckmmGsl9z4UUguAJtf+5gE8GV
# sEg/ge3jHGTYaZ/MyfujE8hOmKBAUkVa7NMxRSB1EdPFpNIpEn/pSHuSL+kWN/2x
# QBJaDFPr1AX0qLgkXmcEi6PFnaw5T17UdIInA58rTu3mefNuzUtse4AgYmxEmJDo
# df8NbVcU6VdjWtz0e58WFZT7tST6EWQmx/OoHPelE77lojq7lpsjhDCzhhp4kfsf
# szxf9g2hoCtltXhCX6NqsqwTT7xe8LgMkH4hVy8L1h2pqGLT2aNCx7h/F95/QvsT
# eGGjY7dssMzq/rSshFQKLZ8lPb8hFTmiGDJNyHga5hZ59IGynk08mHhBFM/0MLeB
# zlAQq1utNjQprztZ5vv/NJy8ua9AGbwkMWkOMIIG7TCCBNWgAwIBAgIQCoDvGEuN
# 8QWC0cR2p5V0aDANBgkqhkiG9w0BAQsFADBpMQswCQYDVQQGEwJVUzEXMBUGA1UE
# ChMORGlnaUNlcnQsIEluYy4xQTA/BgNVBAMTOERpZ2lDZXJ0IFRydXN0ZWQgRzQg
# VGltZVN0YW1waW5nIFJTQTQwOTYgU0hBMjU2IDIwMjUgQ0ExMB4XDTI1MDYwNDAw
# MDAwMFoXDTM2MDkwMzIzNTk1OVowYzELMAkGA1UEBhMCVVMxFzAVBgNVBAoTDkRp
# Z2lDZXJ0LCBJbmMuMTswOQYDVQQDEzJEaWdpQ2VydCBTSEEyNTYgUlNBNDA5NiBU
# aW1lc3RhbXAgUmVzcG9uZGVyIDIwMjUgMTCCAiIwDQYJKoZIhvcNAQEBBQADggIP
# ADCCAgoCggIBANBGrC0Sxp7Q6q5gVrMrV7pvUf+GcAoB38o3zBlCMGMyqJnfFNZx
# +wvA69HFTBdwbHwBSOeLpvPnZ8ZN+vo8dE2/pPvOx/Vj8TchTySA2R4QKpVD7dvN
# Zh6wW2R6kSu9RJt/4QhguSssp3qome7MrxVyfQO9sMx6ZAWjFDYOzDi8SOhPUWlL
# nh00Cll8pjrUcCV3K3E0zz09ldQ//nBZZREr4h/GI6Dxb2UoyrN0ijtUDVHRXdmn
# cOOMA3CoB/iUSROUINDT98oksouTMYFOnHoRh6+86Ltc5zjPKHW5KqCvpSduSwhw
# UmotuQhcg9tw2YD3w6ySSSu+3qU8DD+nigNJFmt6LAHvH3KSuNLoZLc1Hf2JNMVL
# 4Q1OpbybpMe46YceNA0LfNsnqcnpJeItK/DhKbPxTTuGoX7wJNdoRORVbPR1VVnD
# uSeHVZlc4seAO+6d2sC26/PQPdP51ho1zBp+xUIZkpSFA8vWdoUoHLWnqWU3dCCy
# FG1roSrgHjSHlq8xymLnjCbSLZ49kPmk8iyyizNDIXj//cOgrY7rlRyTlaCCfw7a
# SUROwnu7zER6EaJ+AliL7ojTdS5PWPsWeupWs7NpChUk555K096V1hE0yZIXe+gi
# AwW00aHzrDchIc2bQhpp0IoKRR7YufAkprxMiXAJQ1XCmnCfgPf8+3mnAgMBAAGj
# ggGVMIIBkTAMBgNVHRMBAf8EAjAAMB0GA1UdDgQWBBTkO/zyMe39/dfzkXFjGVBD
# z2GM6DAfBgNVHSMEGDAWgBTvb1NK6eQGfHrK4pBW9i/USezLTjAOBgNVHQ8BAf8E
# BAMCB4AwFgYDVR0lAQH/BAwwCgYIKwYBBQUHAwgwgZUGCCsGAQUFBwEBBIGIMIGF
# MCQGCCsGAQUFBzABhhhodHRwOi8vb2NzcC5kaWdpY2VydC5jb20wXQYIKwYBBQUH
# MAKGUWh0dHA6Ly9jYWNlcnRzLmRpZ2ljZXJ0LmNvbS9EaWdpQ2VydFRydXN0ZWRH
# NFRpbWVTdGFtcGluZ1JTQTQwOTZTSEEyNTYyMDI1Q0ExLmNydDBfBgNVHR8EWDBW
# MFSgUqBQhk5odHRwOi8vY3JsMy5kaWdpY2VydC5jb20vRGlnaUNlcnRUcnVzdGVk
# RzRUaW1lU3RhbXBpbmdSU0E0MDk2U0hBMjU2MjAyNUNBMS5jcmwwIAYDVR0gBBkw
# FzAIBgZngQwBBAIwCwYJYIZIAYb9bAcBMA0GCSqGSIb3DQEBCwUAA4ICAQBlKq3x
# HCcEua5gQezRCESeY0ByIfjk9iJP2zWLpQq1b4URGnwWBdEZD9gBq9fNaNmFj6Eh
# 8/YmRDfxT7C0k8FUFqNh+tshgb4O6Lgjg8K8elC4+oWCqnU/ML9lFfim8/9yJmZS
# e2F8AQ/UdKFOtj7YMTmqPO9mzskgiC3QYIUP2S3HQvHG1FDu+WUqW4daIqToXFE/
# JQ/EABgfZXLWU0ziTN6R3ygQBHMUBaB5bdrPbF6MRYs03h4obEMnxYOX8VBRKe1u
# NnzQVTeLni2nHkX/QqvXnNb+YkDFkxUGtMTaiLR9wjxUxu2hECZpqyU1d0IbX6Wq
# 8/gVutDojBIFeRlqAcuEVT0cKsb+zJNEsuEB7O7/cuvTQasnM9AWcIQfVjnzrvwi
# CZ85EE8LUkqRhoS3Y50OHgaY7T/lwd6UArb+BOVAkg2oOvol/DJgddJ35XTxfUlQ
# +8Hggt8l2Yv7roancJIFcbojBcxlRcGG0LIhp6GvReQGgMgYxQbV1S3CrWqZzBt1
# R9xJgKf47CdxVRd/ndUlQ05oxYy2zRWVFjF7mcr4C34Mj3ocCVccAvlKV9jEnstr
# niLvUxxVZE/rptb7IRE2lskKPIJgbaP5t2nGj/ULLi49xTcBZU8atufk+EMF/cWu
# iC7POGT75qaL6vdCvHlshtjdNXOCIUjsarfNZzGCBbUwggWxAgEBMGowVjELMAkG
# A1UEBhMCUEwxITAfBgNVBAoTGEFzc2VjbyBEYXRhIFN5c3RlbXMgUy5BLjEkMCIG
# A1UEAxMbQ2VydHVtIENvZGUgU2lnbmluZyAyMDIxIENBAhArB55OJJX0JFBQxYq3
# KFFaMAkGBSsOAwIaBQCgeDAYBgorBgEEAYI3AgEMMQowCKACgAChAoAAMBkGCSqG
# SIb3DQEJAzEMBgorBgEEAYI3AgEEMBwGCisGAQQBgjcCAQsxDjAMBgorBgEEAYI3
# AgEVMCMGCSqGSIb3DQEJBDEWBBQxeudyGPAXfySSiO6zuokUPylPLzANBgkqhkiG
# 9w0BAQEFAASCAYBvGGF3aZ3JDgJmuhVuFKShinPaavc0jaU9bA8KT9K0b3KRD04f
# fqnf5Gv4iWXgB5ge7Wn+FXPiqTJD+qYojYeRiLTByMkDcNvTMwcE74T6VHLE7S7j
# M9dHI1iuqdUtN0F5LltMPi1F0ZQcSv08iE5LjdNS/0dX3kDmyT3hMT84M5eHYDSe
# a5CqI2AxtuNjyiUUcprGQnCoYwJW41uA5KmED6LxjfyPKTSIPBgVi2QWn79Vs+F/
# tQRAuBklU25xeYFp2Q6BuxH5z3x54pyRgPo7JdlNt57Y/tzadgYuMRppz2FnPnrc
# KkITuYn7MM/WrxBTiEe/n6LqZV2ZBa2xMbceWfq5yusWgRPVRkgOPXCc4wbKt9EC
# goPE/zqqhw0LbrNtL9403EjyZM8VL7XjMk2rRWOAcGPOQk4gkXNtJ3oQdyO4sWuX
# dEiE9Sh2k9oZq3VvISXgnCIRfg4vRkK/gYFkjgq/6b0pH7EnkEMtNbzsl8AcMaTt
# aqDM4z4SRU9eRiahggMmMIIDIgYJKoZIhvcNAQkGMYIDEzCCAw8CAQEwfTBpMQsw
# CQYDVQQGEwJVUzEXMBUGA1UEChMORGlnaUNlcnQsIEluYy4xQTA/BgNVBAMTOERp
# Z2lDZXJ0IFRydXN0ZWQgRzQgVGltZVN0YW1waW5nIFJTQTQwOTYgU0hBMjU2IDIw
# MjUgQ0ExAhAKgO8YS43xBYLRxHanlXRoMA0GCWCGSAFlAwQCAQUAoGkwGAYJKoZI
# hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMjUwNzE3MTkwODE4
# WjAvBgkqhkiG9w0BCQQxIgQg0Pr4HqzdQnkoDY5P4e/6b1XMcVbMfhRon1ivrv+h
# BVEwDQYJKoZIhvcNAQEBBQAEggIAm5TEY9zxX3n7akaF40ze/R7gOiQu7N7IqL1M
# 6PXksL4X/qQGXlFWNxpUDcFaWEbr/7XNx0/SJzW6AKuAyH0tkxEE/ck7AY3/nzSo
# 72XaaljQLAaOt9UPRrBeKy3nA0YgF8uPwfOGtV1nYT7BDR19QtdtClg6v5w5AtOd
# Kk25AR1JgUbeS/IaIihPuey/0STusPjAxZsoIwZpbvp9XC1J4MaSMZAHHBmftwU5
# yLbpDUH/iMIqzTJmeqUcBXHhhUXzQ4ReXd+5z27FTue5JuK8pFx3IcKFImT3qdrX
# +FwjUQ8lcqzDaZ3U8HecI2RyiUJRzt2Q+valsYAnybXUGrpCwfMe7FxLOSCVPv/S
# 73MLU0D9BTUnEAMA9IsXQak0zDu8J5vA8q9PM4BM8YF00nkenDpJmUFzWxBwNY6b
# E5zwwQFDWh/6WnuVOVJIv0T5TIc7ioy33SbtXjXZ16quq636znl3ZVGTquDqlvLN
# qcyux3B30yjtjCnj5r9XyZn6xDoo01KRjiYDSDRu7VjOP5vNj9OBPVP6V9wUjsCP
# /N0+4c/7WiODSbPzg5h8Bu4zFrk0tLJD+M1jtcl0uyuTR1TT134wtKO+eT8OuPPx
# seGr4sca0op0/PkYZ7XMD6mgxAw6P033XtAsmyeHreo33uoLR+G/Y1Amz5QzbDOi
# MiHKBfI=
# SIG # End signature block
