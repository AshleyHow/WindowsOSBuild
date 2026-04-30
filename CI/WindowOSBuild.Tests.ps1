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
                Start-Sleep -Seconds 5
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
                Start-Sleep -Seconds 5
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
                Start-Sleep -Seconds 5
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
                Start-Sleep -Seconds 5
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
                Start-Sleep -Seconds 5
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
                Start-Sleep -Seconds 5
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
                Start-Sleep -Seconds 5
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
                Start-Sleep -Seconds 5
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
                Start-Sleep -Seconds 5
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
                Start-Sleep -Seconds 5
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
                Start-Sleep -Seconds 5
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
                Start-Sleep -Seconds 5
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
                Start-Sleep -Seconds 5
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
                Start-Sleep -Seconds 5
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
                Start-Sleep -Seconds 5
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
                Start-Sleep -Seconds 5
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
                Start-Sleep -Seconds 5
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
                Start-Sleep -Seconds 5
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
        Context "Win 11 (25H2)" {
            It "Results" {
                $Results = Get-LatestOSBuild -OSName Win11 -OSVersion 25H2 -latestreleases 1000
                Start-Sleep -Seconds 5
                $Results.Build.Count | Should -BeGreaterThan 0
                $Results.Version | Should -Contain 'Version 25H2 (OS build 26200)'
                $Results.Build | Should -Match '^26200\.'
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
                Start-Sleep -Seconds 5
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
        Context "Windows 11 Hotpatch (25H2)" {
            It "Results" {
                $Results = Get-LatestOSBuild -OSName Win11Hotpatch -OSVersion 25H2 -latestreleases 1000
                Start-Sleep -Seconds 5
                $Results.Build.Count | Should -BeGreaterThan 0
                $Results.Version | Should -Contain 'Version 25H2 (OS build 26200)'
                (($Results.Build -match '^26200\.') -or ($Results.Build -match 'Security Update')) | Should -BeTrue
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
                Start-Sleep -Seconds 5
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
                Start-Sleep -Seconds 5
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
                Start-Sleep -Seconds 5
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
                Start-Sleep -Seconds 5
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
                Start-Sleep -Seconds 5
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
                Start-Sleep -Seconds 5
                $Results.Count | Should -Be 1
            }
        }
        Context "Detailed" {
            It "Results" {
                $Results = Get-CurrentOSBuild -Detailed
                Start-Sleep -Seconds 5
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
                    Start-Sleep -Seconds 5
                    $Results.Count | Should -Be 1
                }
            }
        }
        Context "Detailed" {
            It "Results" {
                $Results = Get-CurrentOSBuild -Detailed
                Start-Sleep -Seconds 5
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
                    Start-Sleep -Seconds 5
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
                    Start-Sleep -Seconds 5
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
                    Start-Sleep -Seconds 5
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
                    Start-Sleep -Seconds 5
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
                    Start-Sleep -Seconds 5
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
                    Start-Sleep -Seconds 5
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
                    Start-Sleep -Seconds 5
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
                    Start-Sleep -Seconds 5
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
                    Start-Sleep -Seconds 5
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
                    Start-Sleep -Seconds 5
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
                    Start-Sleep -Seconds 5
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
                    Start-Sleep -Seconds 5
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
                    Start-Sleep -Seconds 5
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
                    Start-Sleep -Seconds 5
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
                    Start-Sleep -Seconds 5
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
                    Start-Sleep -Seconds 5
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
                    Start-Sleep -Seconds 5
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
                    Start-Sleep -Seconds 5
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
            Context "Win 11 (25H2)" {
                It "Results" {
                    $Results = Get-LatestOSBuild -OSName Win11 -OSVersion 25H2 -latestreleases 1000
                    Start-Sleep -Seconds 5
                    $Results.Build.Count | Should -BeGreaterThan 0
                    $Results.Version | Should -Contain 'Version 25H2 (OS build 26200)'
                    $Results.Build | Should -Match '^26200\.'
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
                    Start-Sleep -Seconds 5
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
            Context "Windows 11 Hotpatch (25H2)" {
                It "Results" {
                    $Results = Get-LatestOSBuild -OSName Win11Hotpatch -OSVersion 25H2 -latestreleases 1000
                    Start-Sleep -Seconds 5
                    $Results.Build.Count | Should -BeGreaterThan 0
                    $Results.Version | Should -Contain 'Version 25H2 (OS build 26200)'
                    (($Results.Build -match '^26200\.') -or ($Results.Build -match 'Security Update')) | Should -BeTrue
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
                    Start-Sleep -Seconds 5
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
                    Start-Sleep -Seconds 5
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
                    Start-Sleep -Seconds 5
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
                    Start-Sleep -Seconds 5
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
                    Start-Sleep -Seconds 5
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
                Start-Sleep -Seconds 5
                $Results.Count | Should -Be 1
            }
        }
        Context "Detailed" {
            It "Results" {
                $Results = Get-CurrentOSBuild -Detailed
                Start-Sleep -Seconds 5
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
# MIImxgYJKoZIhvcNAQcCoIImtzCCJrMCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCA32ZalW/1dBfGs
# liQusS4EsTDijhtpthi7Pxm311A52KCCIFYwggWNMIIEdaADAgECAhAOmxiO+dAt
# 5+/bUOIIQBhaMA0GCSqGSIb3DQEBDAUAMGUxCzAJBgNVBAYTAlVTMRUwEwYDVQQK
# EwxEaWdpQ2VydCBJbmMxGTAXBgNVBAsTEHd3dy5kaWdpY2VydC5jb20xJDAiBgNV
# BAMTG0RpZ2lDZXJ0IEFzc3VyZWQgSUQgUm9vdCBDQTAeFw0yMjA4MDEwMDAwMDBa
# Fw0zMTExMDkyMzU5NTlaMGIxCzAJBgNVBAYTAlVTMRUwEwYDVQQKEwxEaWdpQ2Vy
# dCBJbmMxGTAXBgNVBAsTEHd3dy5kaWdpY2VydC5jb20xITAfBgNVBAMTGERpZ2lD
# ZXJ0IFRydXN0ZWQgUm9vdCBHNDCCAiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoC
# ggIBAL/mkHNo3rvkXUo8MCIwaTPswqclLskhPfKK2FnC4SmnPVirdprNrnsbhA3E
# MB/zG6Q4FutWxpdtHauyefLKEdLkX9YFPFIPUh/GnhWlfr6fqVcWWVVyr2iTcMKy
# unWZanMylNEQRBAu34LzB4TmdDttceItDBvuINXJIB1jKS3O7F5OyJP4IWGbNOsF
# xl7sWxq868nPzaw0QF+xembud8hIqGZXV59UWI4MK7dPpzDZVu7Ke13jrclPXuU1
# 5zHL2pNe3I6PgNq2kZhAkHnDeMe2scS1ahg4AxCN2NQ3pC4FfYj1gj4QkXCrVYJB
# MtfbBHMqbpEBfCFM1LyuGwN1XXhm2ToxRJozQL8I11pJpMLmqaBn3aQnvKFPObUR
# WBf3JFxGj2T3wWmIdph2PVldQnaHiZdpekjw4KISG2aadMreSx7nDmOu5tTvkpI6
# nj3cAORFJYm2mkQZK37AlLTSYW3rM9nF30sEAMx9HJXDj/chsrIRt7t/8tWMcCxB
# YKqxYxhElRp2Yn72gLD76GSmM9GJB+G9t+ZDpBi4pncB4Q+UDCEdslQpJYls5Q5S
# UUd0viastkF13nqsX40/ybzTQRESW+UQUOsxxcpyFiIJ33xMdT9j7CFfxCBRa2+x
# q4aLT8LWRV+dIPyhHsXAj6KxfgommfXkaS+YHS312amyHeUbAgMBAAGjggE6MIIB
# NjAPBgNVHRMBAf8EBTADAQH/MB0GA1UdDgQWBBTs1+OC0nFdZEzfLmc/57qYrhwP
# TzAfBgNVHSMEGDAWgBRF66Kv9JLLgjEtUYunpyGd823IDzAOBgNVHQ8BAf8EBAMC
# AYYweQYIKwYBBQUHAQEEbTBrMCQGCCsGAQUFBzABhhhodHRwOi8vb2NzcC5kaWdp
# Y2VydC5jb20wQwYIKwYBBQUHMAKGN2h0dHA6Ly9jYWNlcnRzLmRpZ2ljZXJ0LmNv
# bS9EaWdpQ2VydEFzc3VyZWRJRFJvb3RDQS5jcnQwRQYDVR0fBD4wPDA6oDigNoY0
# aHR0cDovL2NybDMuZGlnaWNlcnQuY29tL0RpZ2lDZXJ0QXNzdXJlZElEUm9vdENB
# LmNybDARBgNVHSAECjAIMAYGBFUdIAAwDQYJKoZIhvcNAQEMBQADggEBAHCgv0Nc
# Vec4X6CjdBs9thbX979XB72arKGHLOyFXqkauyL4hxppVCLtpIh3bb0aFPQTSnov
# Lbc47/T/gLn4offyct4kvFIDyE7QKt76LVbP+fT3rDB6mouyXtTP0UNEm0Mh65Zy
# oUi0mcudT6cGAxN3J0TU53/oWajwvy8LpunyNDzs9wPHh6jSTEAZNUZqaVSwuKFW
# juyk1T3osdz9HNj0d1pcVIxv76FQPfx2CWiEn2/K2yCNNWAcAgPLILCsWKAOQGPF
# mCLBsln1VWvPJ6tsds5vIy30fnFqI2si/xK4VC0nftg62fC2h5b9W9FcrBjDTZ9z
# twGpn1eqXijiuZQwggZbMIIEQ6ADAgECAhArB55OJJX0JFBQxYq3KFFaMA0GCSqG
# SIb3DQEBCwUAMFYxCzAJBgNVBAYTAlBMMSEwHwYDVQQKExhBc3NlY28gRGF0YSBT
# eXN0ZW1zIFMuQS4xJDAiBgNVBAMTG0NlcnR1bSBDb2RlIFNpZ25pbmcgMjAyMSBD
# QTAeFw0yNTA3MTcxODIwMjNaFw0yNjA3MTcxODIwMjJaMIGAMQswCQYDVQQGEwJH
# QjEPMA0GA1UECAwGRG9yc2V0MRQwEgYDVQQHDAtCT1VSTkVNT1VUSDEeMBwGA1UE
# CgwVT3BlbiBTb3VyY2UgRGV2ZWxvcGVyMSowKAYDVQQDDCFPcGVuIFNvdXJjZSBE
# ZXZlbG9wZXIsIEFTSExFWSBIT1cwggGiMA0GCSqGSIb3DQEBAQUAA4IBjwAwggGK
# AoIBgQDxqng6MmZI5OvzMGzTy+FqUwPwRyXMXirSV3wDT5uX65ARL7njXRyZla50
# z0zMzTKfTLdtw7N+NSHnt0WEiKfjHLq87TeY4C1gbsbN867UI7nuzHUAXMsxZTAn
# Vo+I/eFnaIdrWtbWtjGrf0olJ6o/Eq7eL6xF5NbppzQhXwx52oS2juNUXQSX/sui
# rhQhrDf52hej5yNJpytapbWIZeYcSBszrsZHBAj6yImYQx8ZpnbnwXz2lB4UhtSD
# R0Oqe2aRbwfunrbIQfAzBnTL88qlpIfDMM55KVqO29UIT3hL9B56kj5d6p3N6bhU
# hqK1I84u5nXlAa/sngi/8EAEimyv8z07oEc9Q7aYi1ZHkN6sE1vJwYcrvlLuffIT
# SCPApWueaV8Abo4YruqGdFlRrBpOWx9VIJORx30+46xq11Q46VQo46MIiahkY0as
# aOrExsozsxNWHrzbJ0hFtZHXroVj+rh0jh7WDA6VIyrkffNz/JcGYqAWv0NF9BLP
# ndudBd8CAwEAAaOCAXgwggF0MAwGA1UdEwEB/wQCMAAwPQYDVR0fBDYwNDAyoDCg
# LoYsaHR0cDovL2Njc2NhMjAyMS5jcmwuY2VydHVtLnBsL2Njc2NhMjAyMS5jcmww
# cwYIKwYBBQUHAQEEZzBlMCwGCCsGAQUFBzABhiBodHRwOi8vY2NzY2EyMDIxLm9j
# c3AtY2VydHVtLmNvbTA1BggrBgEFBQcwAoYpaHR0cDovL3JlcG9zaXRvcnkuY2Vy
# dHVtLnBsL2Njc2NhMjAyMS5jZXIwHwYDVR0jBBgwFoAU3XRdTADbe5+gdMqxbvc8
# wDLAcM0wHQYDVR0OBBYEFHzPzP28Eh8P49CthZHasFS476RrMEsGA1UdIAREMEIw
# CAYGZ4EMAQQBMDYGCyqEaAGG9ncCBQEEMCcwJQYIKwYBBQUHAgEWGWh0dHBzOi8v
# d3d3LmNlcnR1bS5wbC9DUFMwEwYDVR0lBAwwCgYIKwYBBQUHAwMwDgYDVR0PAQH/
# BAQDAgeAMA0GCSqGSIb3DQEBCwUAA4ICAQBMYQbh33fNYTzk5r64a1jBXQrhtz2r
# kplOw7iQRYg/88ZPhqMWC4uuxARxIe1WAwdg6A2X27Hg89YfK+TsswSqopIzniZ4
# zY/Y1l3NB5oTK1V4mVT1IKA+/TX9Qi7cw6TOvbXk35BNty6PXFCNXqC7YD+MPyGp
# m5nBTZ9JXkAL5i3jZY8aLGctwTKVhrozqnTWozbC4pvsGDc2jx7FZct2nZQrswNn
# Z5f+fprxmpgFOaVnhOsWxpY7kYPasN9eOVB131+GCW/a7mJScbSsGecjKLTwrJab
# rV46uH7RfWXvXz5mg+sobM7OP0Wn+3p77mdoK8fO6RAH9GtuCzA8v/MytHI6gC/R
# myrpZohvZnN5hHWz2THRVL8LYnrwll/Q4wGxF1pOSPCVTT2REuAsZgkwQW+vwGGk
# gOp+79xsKEVKgv/iv6ZE7mfkBwoahq6P+wkY01q/Ru15/ovTSSCohMIDEGE/MaWV
# q+QP3guJ3RRmVzpKcmqqQ5LS1FnLWJIscZw1Daph1crq3LFB/LGxqZmcZz1fhCyy
# 6IF7OoRzofP9yxoWbFK0gG/0+++vpiuD+lZRdXqst9zS9ADKIYG5meAFhwgpK0Ux
# hyquRYJSWs75ZLtO5UU/0+1O+lKUXdszvZbLOCSShSQQKrglA+jmcuThBjZc/Jvk
# Vtci1LLuXoKuODCCBrQwggScoAMCAQICEA3HrFcF/yGZLkBDIgw6SYYwDQYJKoZI
# hvcNAQELBQAwYjELMAkGA1UEBhMCVVMxFTATBgNVBAoTDERpZ2lDZXJ0IEluYzEZ
# MBcGA1UECxMQd3d3LmRpZ2ljZXJ0LmNvbTEhMB8GA1UEAxMYRGlnaUNlcnQgVHJ1
# c3RlZCBSb290IEc0MB4XDTI1MDUwNzAwMDAwMFoXDTM4MDExNDIzNTk1OVowaTEL
# MAkGA1UEBhMCVVMxFzAVBgNVBAoTDkRpZ2lDZXJ0LCBJbmMuMUEwPwYDVQQDEzhE
# aWdpQ2VydCBUcnVzdGVkIEc0IFRpbWVTdGFtcGluZyBSU0E0MDk2IFNIQTI1NiAy
# MDI1IENBMTCCAiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBALR4MdMKmEFy
# vjxGwBysddujRmh0tFEXnU2tjQ2UtZmWgyxU7UNqEY81FzJsQqr5G7A6c+Gh/qm8
# Xi4aPCOo2N8S9SLrC6Kbltqn7SWCWgzbNfiR+2fkHUiljNOqnIVD/gG3SYDEAd4d
# g2dDGpeZGKe+42DFUF0mR/vtLa4+gKPsYfwEu7EEbkC9+0F2w4QJLVSTEG8yAR2C
# QWIM1iI5PHg62IVwxKSpO0XaF9DPfNBKS7Zazch8NF5vp7eaZ2CVNxpqumzTCNSO
# xm+SAWSuIr21Qomb+zzQWKhxKTVVgtmUPAW35xUUFREmDrMxSNlr/NsJyUXzdtFU
# Ut4aS4CEeIY8y9IaaGBpPNXKFifinT7zL2gdFpBP9qh8SdLnEut/GcalNeJQ55Iu
# wnKCgs+nrpuQNfVmUB5KlCX3ZA4x5HHKS+rqBvKWxdCyQEEGcbLe1b8Aw4wJkhU1
# JrPsFfxW1gaou30yZ46t4Y9F20HHfIY4/6vHespYMQmUiote8ladjS/nJ0+k6Mvq
# zfpzPDOy5y6gqztiT96Fv/9bH7mQyogxG9QEPHrPV6/7umw052AkyiLA6tQbZl1K
# hBtTasySkuJDpsZGKdlsjg4u70EwgWbVRSX1Wd4+zoFpp4Ra+MlKM2baoD6x0VR4
# RjSpWM8o5a6D8bpfm4CLKczsG7ZrIGNTAgMBAAGjggFdMIIBWTASBgNVHRMBAf8E
# CDAGAQH/AgEAMB0GA1UdDgQWBBTvb1NK6eQGfHrK4pBW9i/USezLTjAfBgNVHSME
# GDAWgBTs1+OC0nFdZEzfLmc/57qYrhwPTzAOBgNVHQ8BAf8EBAMCAYYwEwYDVR0l
# BAwwCgYIKwYBBQUHAwgwdwYIKwYBBQUHAQEEazBpMCQGCCsGAQUFBzABhhhodHRw
# Oi8vb2NzcC5kaWdpY2VydC5jb20wQQYIKwYBBQUHMAKGNWh0dHA6Ly9jYWNlcnRz
# LmRpZ2ljZXJ0LmNvbS9EaWdpQ2VydFRydXN0ZWRSb290RzQuY3J0MEMGA1UdHwQ8
# MDowOKA2oDSGMmh0dHA6Ly9jcmwzLmRpZ2ljZXJ0LmNvbS9EaWdpQ2VydFRydXN0
# ZWRSb290RzQuY3JsMCAGA1UdIAQZMBcwCAYGZ4EMAQQCMAsGCWCGSAGG/WwHATAN
# BgkqhkiG9w0BAQsFAAOCAgEAF877FoAc/gc9EXZxML2+C8i1NKZ/zdCHxYgaMH9P
# w5tcBnPw6O6FTGNpoV2V4wzSUGvI9NAzaoQk97frPBtIj+ZLzdp+yXdhOP4hCFAT
# uNT+ReOPK0mCefSG+tXqGpYZ3essBS3q8nL2UwM+NMvEuBd/2vmdYxDCvwzJv2sR
# UoKEfJ+nN57mQfQXwcAEGCvRR2qKtntujB71WPYAgwPyWLKu6RnaID/B0ba2H3LU
# iwDRAXx1Neq9ydOal95CHfmTnM4I+ZI2rVQfjXQA1WSjjf4J2a7jLzWGNqNX+DF0
# SQzHU0pTi4dBwp9nEC8EAqoxW6q17r0z0noDjs6+BFo+z7bKSBwZXTRNivYuve3L
# 2oiKNqetRHdqfMTCW/NmKLJ9M+MtucVGyOxiDf06VXxyKkOirv6o02OoXN4bFzK0
# vlNMsvhlqgF2puE6FndlENSmE+9JGYxOGLS/D284NHNboDGcmWXfwXRy4kbu4QFh
# Om0xJuF2EZAOk5eCkhSxZON3rGlHqhpB/8MluDezooIs8CVnrpHMiD2wL40mm53+
# /j7tFaxYKIqL0Q4ssd8xHZnIn/7GELH3IdvG2XlM9q7WP/UwgOkw/HQtyRN62JK4
# S1C8uw3PdBunvAZapsiI5YKdvlarEvf8EA+8hcpSM9LHJmyrxaFtoza2zNaQ9k+5
# t1wwgga5MIIEoaADAgECAhEAmaOACiZVO2Wr3G6EprPqOTANBgkqhkiG9w0BAQwF
# ADCBgDELMAkGA1UEBhMCUEwxIjAgBgNVBAoTGVVuaXpldG8gVGVjaG5vbG9naWVz
# IFMuQS4xJzAlBgNVBAsTHkNlcnR1bSBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eTEk
# MCIGA1UEAxMbQ2VydHVtIFRydXN0ZWQgTmV0d29yayBDQSAyMB4XDTIxMDUxOTA1
# MzIxOFoXDTM2MDUxODA1MzIxOFowVjELMAkGA1UEBhMCUEwxITAfBgNVBAoTGEFz
# c2VjbyBEYXRhIFN5c3RlbXMgUy5BLjEkMCIGA1UEAxMbQ2VydHVtIENvZGUgU2ln
# bmluZyAyMDIxIENBMIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAnSPP
# BDAjO8FGLOczcz5jXXp1ur5cTbq96y34vuTmflN4mSAfgLKTvggv24/rWiVGzGxT
# 9YEASVMw1Aj8ewTS4IndU8s7VS5+djSoMcbvIKck6+hI1shsylP4JyLvmxwLHtSw
# orV9wmjhNd627h27a8RdrT1PH9ud0IF+njvMk2xqbNTIPsnWtw3E7DmDoUmDQiYi
# /ucJ42fcHqBkbbxYDB7SYOouu9Tj1yHIohzuC8KNqfcYf7Z4/iZgkBJ+UFNDcc6z
# okZ2uJIxWgPWXMEmhu1gMXgv8aGUsRdaCtVD2bSlbfsq7BiqljjaCun+RJgTgFRC
# tsuAEw0pG9+FA+yQN9n/kZtMLK+Wo837Q4QOZgYqVWQ4x6cM7/G0yswg1ElLlJj6
# NYKLw9EcBXE7TF3HybZtYvj9lDV2nT8mFSkcSkAExzd4prHwYjUXTeZIlVXqj+ea
# YqoMTpMrfh5MCAOIG5knN4Q/JHuurfTI5XDYO962WZayx7ACFf5ydJpoEowSP07Y
# aBiQ8nXpDkNrUA9g7qf/rCkKbWpQ5boufUnq1UiYPIAHlezf4muJqxqIns/kqld6
# JVX8cixbd6PzkDpwZo4SlADaCi2JSplKShBSND36E/ENVv8urPS0yOnpG4tIoBGx
# VCARPCg1BnyMJ4rBJAcOSnAWd18Jx5n858JSqPECAwEAAaOCAVUwggFRMA8GA1Ud
# EwEB/wQFMAMBAf8wHQYDVR0OBBYEFN10XUwA23ufoHTKsW73PMAywHDNMB8GA1Ud
# IwQYMBaAFLahVDkCw6A/joq8+tT4HKbROg79MA4GA1UdDwEB/wQEAwIBBjATBgNV
# HSUEDDAKBggrBgEFBQcDAzAwBgNVHR8EKTAnMCWgI6Ahhh9odHRwOi8vY3JsLmNl
# cnR1bS5wbC9jdG5jYTIuY3JsMGwGCCsGAQUFBwEBBGAwXjAoBggrBgEFBQcwAYYc
# aHR0cDovL3N1YmNhLm9jc3AtY2VydHVtLmNvbTAyBggrBgEFBQcwAoYmaHR0cDov
# L3JlcG9zaXRvcnkuY2VydHVtLnBsL2N0bmNhMi5jZXIwOQYDVR0gBDIwMDAuBgRV
# HSAAMCYwJAYIKwYBBQUHAgEWGGh0dHA6Ly93d3cuY2VydHVtLnBsL0NQUzANBgkq
# hkiG9w0BAQwFAAOCAgEAdYhYD+WPUCiaU58Q7EP89DttyZqGYn2XRDhJkL6P+/T0
# IPZyxfxiXumYlARMgwRzLRUStJl490L94C9LGF3vjzzH8Jq3iR74BRlkO18J3zId
# mCKQa5LyZ48IfICJTZVJeChDUyuQy6rGDxLUUAsO0eqeLNhLVsgw6/zOfImNlARK
# n1FP7o0fTbj8ipNGxHBIutiRsWrhWM2f8pXdd3x2mbJCKKtl2s42g9KUJHEIiLni
# 9ByoqIUul4GblLQigO0ugh7bWRLDm0CdY9rNLqyA3ahe8WlxVWkxyrQLjH8ItI17
# RdySaYayX3PhRSC4Am1/7mATwZWwSD+B7eMcZNhpn8zJ+6MTyE6YoEBSRVrs0zFF
# IHUR08Wk0ikSf+lIe5Iv6RY3/bFAEloMU+vUBfSouCReZwSLo8WdrDlPXtR0gicD
# nytO7eZ5827NS2x7gCBibESYkOh1/w1tVxTpV2Na3PR7nxYVlPu1JPoRZCbH86gc
# 96UTvuWiOruWmyOEMLOGGniR+x+zPF/2DaGgK2W1eEJfo2qyrBNPvF7wuAyQfiFX
# LwvWHamoYtPZo0LHuH8X3n9C+xN4YaNjt2ywzOr+tKyEVAotnyU9vyEVOaIYMk3I
# eBrmFnn0gbKeTTyYeEEUz/Qwt4HOUBCrW602NCmvO1nm+/80nLy5r0AZvCQxaQ4w
# ggbtMIIE1aADAgECAhAKgO8YS43xBYLRxHanlXRoMA0GCSqGSIb3DQEBCwUAMGkx
# CzAJBgNVBAYTAlVTMRcwFQYDVQQKEw5EaWdpQ2VydCwgSW5jLjFBMD8GA1UEAxM4
# RGlnaUNlcnQgVHJ1c3RlZCBHNCBUaW1lU3RhbXBpbmcgUlNBNDA5NiBTSEEyNTYg
# MjAyNSBDQTEwHhcNMjUwNjA0MDAwMDAwWhcNMzYwOTAzMjM1OTU5WjBjMQswCQYD
# VQQGEwJVUzEXMBUGA1UEChMORGlnaUNlcnQsIEluYy4xOzA5BgNVBAMTMkRpZ2lD
# ZXJ0IFNIQTI1NiBSU0E0MDk2IFRpbWVzdGFtcCBSZXNwb25kZXIgMjAyNSAxMIIC
# IjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEA0EasLRLGntDqrmBWsytXum9R
# /4ZwCgHfyjfMGUIwYzKomd8U1nH7C8Dr0cVMF3BsfAFI54um8+dnxk36+jx0Tb+k
# +87H9WPxNyFPJIDZHhAqlUPt281mHrBbZHqRK71Em3/hCGC5KyyneqiZ7syvFXJ9
# A72wzHpkBaMUNg7MOLxI6E9RaUueHTQKWXymOtRwJXcrcTTPPT2V1D/+cFllESvi
# H8YjoPFvZSjKs3SKO1QNUdFd2adw44wDcKgH+JRJE5Qg0NP3yiSyi5MxgU6cehGH
# r7zou1znOM8odbkqoK+lJ25LCHBSai25CFyD23DZgPfDrJJJK77epTwMP6eKA0kW
# a3osAe8fcpK40uhktzUd/Yk0xUvhDU6lvJukx7jphx40DQt82yepyekl4i0r8OEp
# s/FNO4ahfvAk12hE5FVs9HVVWcO5J4dVmVzix4A77p3awLbr89A90/nWGjXMGn7F
# QhmSlIUDy9Z2hSgctaepZTd0ILIUbWuhKuAeNIeWrzHKYueMJtItnj2Q+aTyLLKL
# M0MheP/9w6CtjuuVHJOVoIJ/DtpJRE7Ce7vMRHoRon4CWIvuiNN1Lk9Y+xZ66laz
# s2kKFSTnnkrT3pXWETTJkhd76CIDBbTRofOsNyEhzZtCGmnQigpFHti58CSmvEyJ
# cAlDVcKacJ+A9/z7eacCAwEAAaOCAZUwggGRMAwGA1UdEwEB/wQCMAAwHQYDVR0O
# BBYEFOQ7/PIx7f391/ORcWMZUEPPYYzoMB8GA1UdIwQYMBaAFO9vU0rp5AZ8esri
# kFb2L9RJ7MtOMA4GA1UdDwEB/wQEAwIHgDAWBgNVHSUBAf8EDDAKBggrBgEFBQcD
# CDCBlQYIKwYBBQUHAQEEgYgwgYUwJAYIKwYBBQUHMAGGGGh0dHA6Ly9vY3NwLmRp
# Z2ljZXJ0LmNvbTBdBggrBgEFBQcwAoZRaHR0cDovL2NhY2VydHMuZGlnaWNlcnQu
# Y29tL0RpZ2lDZXJ0VHJ1c3RlZEc0VGltZVN0YW1waW5nUlNBNDA5NlNIQTI1NjIw
# MjVDQTEuY3J0MF8GA1UdHwRYMFYwVKBSoFCGTmh0dHA6Ly9jcmwzLmRpZ2ljZXJ0
# LmNvbS9EaWdpQ2VydFRydXN0ZWRHNFRpbWVTdGFtcGluZ1JTQTQwOTZTSEEyNTYy
# MDI1Q0ExLmNybDAgBgNVHSAEGTAXMAgGBmeBDAEEAjALBglghkgBhv1sBwEwDQYJ
# KoZIhvcNAQELBQADggIBAGUqrfEcJwS5rmBB7NEIRJ5jQHIh+OT2Ik/bNYulCrVv
# hREafBYF0RkP2AGr181o2YWPoSHz9iZEN/FPsLSTwVQWo2H62yGBvg7ouCODwrx6
# ULj6hYKqdT8wv2UV+Kbz/3ImZlJ7YXwBD9R0oU62PtgxOao872bOySCILdBghQ/Z
# LcdC8cbUUO75ZSpbh1oipOhcUT8lD8QAGB9lctZTTOJM3pHfKBAEcxQFoHlt2s9s
# XoxFizTeHihsQyfFg5fxUFEp7W42fNBVN4ueLaceRf9Cq9ec1v5iQMWTFQa0xNqI
# tH3CPFTG7aEQJmmrJTV3Qhtfparz+BW60OiMEgV5GWoBy4RVPRwqxv7Mk0Sy4QHs
# 7v9y69NBqycz0BZwhB9WOfOu/CIJnzkQTwtSSpGGhLdjnQ4eBpjtP+XB3pQCtv4E
# 5UCSDag6+iX8MmB10nfldPF9SVD7weCC3yXZi/uuhqdwkgVxuiMFzGVFwYbQsiGn
# oa9F5AaAyBjFBtXVLcKtapnMG3VH3EmAp/jsJ3FVF3+d1SVDTmjFjLbNFZUWMXuZ
# yvgLfgyPehwJVxwC+UpX2MSey2ueIu9THFVkT+um1vshETaWyQo8gmBto/m3acaP
# 9QsuLj3FNwFlTxq25+T4QwX9xa6ILs84ZPvmpovq90K8eWyG2N01c4IhSOxqt81n
# MYIFxjCCBcICAQEwajBWMQswCQYDVQQGEwJQTDEhMB8GA1UEChMYQXNzZWNvIERh
# dGEgU3lzdGVtcyBTLkEuMSQwIgYDVQQDExtDZXJ0dW0gQ29kZSBTaWduaW5nIDIw
# MjEgQ0ECECsHnk4klfQkUFDFircoUVowDQYJYIZIAWUDBAIBBQCggYQwGAYKKwYB
# BAGCNwIBDDEKMAigAoAAoQKAADAZBgkqhkiG9w0BCQMxDAYKKwYBBAGCNwIBBDAc
# BgorBgEEAYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAvBgkqhkiG9w0BCQQxIgQgCTEn
# 3HS2Yc/Blbi+TX1ueiTuYhzVpjqa66m29VLeElYwDQYJKoZIhvcNAQEBBQAEggGA
# UA/C+hCN17ucFsR4vpL4x3oZPxzAxTqUx/pZ67Yo/fY1Nyr/oJEYJg76WvSTW0Ll
# eYdYfMG8PgeEHFy3wwp0iYwrRx2NRzduhcsAjnuFuhbNn/guEJv2QmKOdh5JsGud
# lytY1Mq20gZBsI2rgUM/ekh6GdKq63f3y/wY2i4KID7nUHXX1l2U1+tYbgMddYtA
# QZo/jf9j401A6K1QogRbkfN1JIziPCRkkkwSFwjvpNv+76t/zLM9xijXOmOadSep
# o6sPhdKnlq6qIG+GpOK7jFzy286tydoNpjQVMFAaJ4O4hf2TcXzy4ubPQBjEb7Gl
# So9jDKr1kgRyFcEgYJ1ZYaSpZNUx4omOJADGvPIEs/yQX6Ssq4B84DQor/ooSfuN
# rtH2DCasNN06T6U9tFrWwOzsqzZI+dnTHNighq72NhbkC+mdwBlHqKjQTSW0d+SI
# eLrVDW82G8MNXUKxpzj1V/UiCZ6lQLxhfjjkUnieQlbTjJ0WZ9DSWBIzs5M7LB39
# oYIDJjCCAyIGCSqGSIb3DQEJBjGCAxMwggMPAgEBMH0waTELMAkGA1UEBhMCVVMx
# FzAVBgNVBAoTDkRpZ2lDZXJ0LCBJbmMuMUEwPwYDVQQDEzhEaWdpQ2VydCBUcnVz
# dGVkIEc0IFRpbWVTdGFtcGluZyBSU0E0MDk2IFNIQTI1NiAyMDI1IENBMQIQCoDv
# GEuN8QWC0cR2p5V0aDANBglghkgBZQMEAgEFAKBpMBgGCSqGSIb3DQEJAzELBgkq
# hkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTI2MDQzMDE5MDc1NVowLwYJKoZIhvcN
# AQkEMSIEIBJCkIJ6g6zUCmSYIxN9/R/3HqrPCv4n/amUr9lpfXw7MA0GCSqGSIb3
# DQEBAQUABIICAMQ+fOkALGcoNpPCM1WdNUFvfk2PAPQ30gYohzMSaV5vRc5f23w8
# W9r61Hs7FvyX8MvuwPxMCDpMWyJupC810Gjr5dDCnxBBFKO9hiKUVo8eY5+q9Kfy
# BTeOFGdV5EKYFVp9jehX05cCMpoc0n5w+8PO2QYUQFmWfGI+6X91xbDxLA3iNEhc
# 2Z1rfC4o60xGLayGG4RKEDRR+jRxzM6BoAA+3dP/W80vVT99mRG6r0rq/Qyx9Zpj
# l0LS24XZ8CHeh0G8Vw3XeZrVZhDnrQo0gzU/keJUc3lEmt7NL3pQIM53eTJJZbDk
# rMyXCtvDQMpi9tcOS0vo3X1ajIyb7oiR9lnOOBHUs0goozBssM3l9dq55vFBGVxU
# LkFQRvlV3IOKAHjFrirvCHPcm8GPVSXU3tGNed+QU3Pv19KL9Fi8CIKh/MAG3Ps8
# SxU2G8AmIYTFxrjq4ykg6Nn2U/XiHnXuRiL8EwWBB4wiJsQRGIKN3jUNWbzkiuaU
# RmvnZFYaAwXBPejvaFhEB/MesV/WHwqDggxbX0YhVzFME7MtwbTZJgBsSW7qP4WV
# mANX5+88+4RBzem2FyRcFmUPyD+42YrkguRC9HdYVFLbMyPsKTH9z1ir9pQRuQb2
# GRsLXvPHm/pB0IHklv4vGM+0Lw21eMhuXZFxrENmaVVswgxFvpbTC7KV
# SIG # End signature block
