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
                $Results.Build | Should -Match '^26100\.'
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
                $Results.Build | Should -Match '^20348\.'
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
                $Results.Build | Should -Match '^26100\.'
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
                    $Results.Build | Should -Match '^26100\.'
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
                    $Results.Build | Should -Match '^20348\.'
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
                    $Results.Build | Should -Match '^26100\.'
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
    }
}