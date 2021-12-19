BeforeAll {
    BeforeAll {
        . $PSScriptRoot/WindowsOSBuild.psm1
    }
}

Describe "WindowsOSBuild Tests" {
    Context "Win 10 (1507)" {
        It "Return Results" {
            $Results = Get-LatestOSBuild -OSName Win10 -OSVersion 1507 -latestreleases 1000
            $Results.Build.Count | Should -BeGreaterThan 1
            $Results.Version | Should -Not -BeNullOrEmpty
            $Results.Build | Should -Not -BeNullOrEmpty
            $Results.'Availability date' | Should -Not -BeNullOrEmpty
            $Results.Preview | Should -Not -BeNullOrEmpty
            $Results.'Out-of-band' | Should -Not -BeNullOrEmpty
            $Results.'Servicing option' | Should -Not -BeNullOrEmpty
            $Results.'KB article' | Should -Not -BeNullOrEmpty
            $Results.'KB URL' | Should -Not -BeNullOrEmpty
            $Results.'Catalog URL' | Should -Not -BeNullOrEmpty
        }
    }
    Context "Win 10 (1511)" {
        It "Return Results" {
            $Results = Get-LatestOSBuild -OSName Win10 -OSVersion 1511 -latestreleases 1000
            $Results.Build.Count | Should -BeGreaterThan 1
            $Results.Version | Should -Not -BeNullOrEmpty
            $Results.Build | Should -Not -BeNullOrEmpty
            $Results.'Availability date' | Should -Not -BeNullOrEmpty
            $Results.Preview | Should -Not -BeNullOrEmpty
            $Results.'Out-of-band' | Should -Not -BeNullOrEmpty
            $Results.'Servicing option' | Should -Not -BeNullOrEmpty
            $Results.'KB article' | Should -Not -BeNullOrEmpty
            $Results.'KB URL' | Should -Not -BeNullOrEmpty
            $Results.'Catalog URL' | Should -Not -BeNullOrEmpty
        }
    }
    Context "Win 10 / Server 2016 (1607)" {
        It "Return Results" {
            $Results = Get-LatestOSBuild -OSName Win10 -OSVersion 1607 -latestreleases 1000
            $Results.Build.Count | Should -BeGreaterThan 1
            $Results.Version | Should -Not -BeNullOrEmpty
            $Results.Build | Should -Not -BeNullOrEmpty
            $Results.'Availability date' | Should -Not -BeNullOrEmpty
            $Results.Preview | Should -Not -BeNullOrEmpty
            $Results.'Out-of-band' | Should -Not -BeNullOrEmpty
            $Results.'Servicing option' | Should -Not -BeNullOrEmpty
            $Results.'KB article' | Should -Not -BeNullOrEmpty
            $Results.'KB URL' | Should -Not -BeNullOrEmpty
            $Results.'Catalog URL' | Should -Not -BeNullOrEmpty
        }
    }
    Context "Win 10 (1607)" {
        It "Return Results" {
            $Results = Get-LatestOSBuild -OSName Win10 -OSVersion 1607 -latestreleases 1000
            $Results.Build.Count | Should -BeGreaterThan 1
            $Results.Version | Should -Not -BeNullOrEmpty
            $Results.Build | Should -Not -BeNullOrEmpty
            $Results.'Availability date' | Should -Not -BeNullOrEmpty
            $Results.Preview | Should -Not -BeNullOrEmpty
            $Results.'Out-of-band' | Should -Not -BeNullOrEmpty
            $Results.'Servicing option' | Should -Not -BeNullOrEmpty
            $Results.'KB article' | Should -Not -BeNullOrEmpty
            $Results.'KB URL' | Should -Not -BeNullOrEmpty
            $Results.'Catalog URL' | Should -Not -BeNullOrEmpty
        }
    }
    Context "Win 10 (1703)" {
        It "Return Results" {
            $Results = Get-LatestOSBuild -OSName Win10 -OSVersion 1703 -latestreleases 1000
            $Results.Build.Count | Should -BeGreaterThan 1
            $Results.Version | Should -Not -BeNullOrEmpty
            $Results.Build | Should -Not -BeNullOrEmpty
            $Results.'Availability date' | Should -Not -BeNullOrEmpty
            $Results.Preview | Should -Not -BeNullOrEmpty
            $Results.'Out-of-band' | Should -Not -BeNullOrEmpty
            $Results.'Servicing option' | Should -Not -BeNullOrEmpty
            $Results.'KB article' | Should -Not -BeNullOrEmpty
            $Results.'KB URL' | Should -Not -BeNullOrEmpty
            $Results.'Catalog URL' | Should -Not -BeNullOrEmpty
        }
    }
    Context "Win 10 (1709)" {
        It "Return Results" {
            $Results = Get-LatestOSBuild -OSName Win10 -OSVersion 1709 -latestreleases 1000
            $Results.Build.Count | Should -BeGreaterThan 1
            $Results.Version | Should -Not -BeNullOrEmpty
            $Results.Build | Should -Not -BeNullOrEmpty
            $Results.'Availability date' | Should -Not -BeNullOrEmpty
            $Results.Preview | Should -Not -BeNullOrEmpty
            $Results.'Out-of-band' | Should -Not -BeNullOrEmpty
            $Results.'Servicing option' | Should -Not -BeNullOrEmpty
            $Results.'KB article' | Should -Not -BeNullOrEmpty
            $Results.'KB URL' | Should -Not -BeNullOrEmpty
            $Results.'Catalog URL' | Should -Not -BeNullOrEmpty
        }
    }
    Context "Win 10 (1803)" {
        It "Return Results" {
            $Results = Get-LatestOSBuild -OSName Win10 -OSVersion 1803 -latestreleases 1000
            $Results.Build.Count | Should -BeGreaterThan 1
            $Results.Version | Should -Not -BeNullOrEmpty
            $Results.Build | Should -Not -BeNullOrEmpty
            $Results.'Availability date' | Should -Not -BeNullOrEmpty
            $Results.Preview | Should -Not -BeNullOrEmpty
            $Results.'Out-of-band' | Should -Not -BeNullOrEmpty
            $Results.'Servicing option' | Should -Not -BeNullOrEmpty
            $Results.'KB article' | Should -Not -BeNullOrEmpty
            $Results.'KB URL' | Should -Not -BeNullOrEmpty
            $Results.'Catalog URL' | Should -Not -BeNullOrEmpty
        }
    }
    Context "Win 10 / Server 2019 (1809)" {
        It "Return Results" {
            $Results = Get-LatestOSBuild -OSName Win10 -OSVersion 1809 -latestreleases 1000
            $Results.Build.Count | Should -BeGreaterThan 1
            $Results.Version | Should -Not -BeNullOrEmpty
            $Results.Build | Should -Not -BeNullOrEmpty
            $Results.'Availability date' | Should -Not -BeNullOrEmpty
            $Results.Preview | Should -Not -BeNullOrEmpty
            $Results.'Out-of-band' | Should -Not -BeNullOrEmpty
            $Results.'Servicing option' | Should -Not -BeNullOrEmpty
            $Results.'KB article' | Should -Not -BeNullOrEmpty
            $Results.'KB URL' | Should -Not -BeNullOrEmpty
            $Results.'Catalog URL' | Should -Not -BeNullOrEmpty
        }
    }
    Context "Win 10 (1903)" {
        It "Return Results" {
            $Results = Get-LatestOSBuild -OSName Win10 -OSVersion 1903 -latestreleases 1000
            $Results.Build.Count | Should -BeGreaterThan 1
            $Results.Version | Should -Not -BeNullOrEmpty
            $Results.Build | Should -Not -BeNullOrEmpty
            $Results.'Availability date' | Should -Not -BeNullOrEmpty
            $Results.Preview | Should -Not -BeNullOrEmpty
            $Results.'Out-of-band' | Should -Not -BeNullOrEmpty
            $Results.'Servicing option' | Should -Not -BeNullOrEmpty
            $Results.'KB article' | Should -Not -BeNullOrEmpty
            $Results.'KB URL' | Should -Not -BeNullOrEmpty
            $Results.'Catalog URL' | Should -Not -BeNullOrEmpty
        }
    }
    Context "Win 10 (1909)" {
        It "Return Results" {
            $Results = Get-LatestOSBuild -OSName Win10 -OSVersion 1909 -latestreleases 1000
            $Results.Build.Count | Should -BeGreaterThan 1
            $Results.Version | Should -Not -BeNullOrEmpty
            $Results.Build | Should -Not -BeNullOrEmpty
            $Results.'Availability date' | Should -Not -BeNullOrEmpty
            $Results.Preview | Should -Not -BeNullOrEmpty
            $Results.'Out-of-band' | Should -Not -BeNullOrEmpty
            $Results.'Servicing option' | Should -Not -BeNullOrEmpty
            $Results.'KB article' | Should -Not -BeNullOrEmpty
            $Results.'KB URL' | Should -Not -BeNullOrEmpty
            $Results.'Catalog URL' | Should -Not -BeNullOrEmpty
        }
    }
    Context "Win 10 (2004)" {
        It "Return Results" {
            $Results = Get-LatestOSBuild -OSName Win10 -OSVersion 2004 -latestreleases 1000
            $Results.Build.Count | Should -BeGreaterThan 1
            $Results.Version | Should -Not -BeNullOrEmpty
            $Results.Build | Should -Not -BeNullOrEmpty
            $Results.'Availability date' | Should -Not -BeNullOrEmpty
            $Results.Preview | Should -Not -BeNullOrEmpty
            $Results.'Out-of-band' | Should -Not -BeNullOrEmpty
            $Results.'Servicing option' | Should -Not -BeNullOrEmpty
            $Results.'KB article' | Should -Not -BeNullOrEmpty
            $Results.'KB URL' | Should -Not -BeNullOrEmpty
            $Results.'Catalog URL' | Should -Not -BeNullOrEmpty
        }
    }
    Context "Win 10 (20H2)" {
        It "Return Results" {
            $Results = Get-LatestOSBuild -OSName Win10 -OSVersion 20H2 -latestreleases 1000
            $Results.Build.Count | Should -BeGreaterThan 1
            $Results.Version | Should -Not -BeNullOrEmpty
            $Results.Build | Should -Not -BeNullOrEmpty
            $Results.'Availability date' | Should -Not -BeNullOrEmpty
            $Results.Preview | Should -Not -BeNullOrEmpty
            $Results.'Out-of-band' | Should -Not -BeNullOrEmpty
            $Results.'Servicing option' | Should -Not -BeNullOrEmpty
            $Results.'KB article' | Should -Not -BeNullOrEmpty
            $Results.'KB URL' | Should -Not -BeNullOrEmpty
            $Results.'Catalog URL' | Should -Not -BeNullOrEmpty
        }
    }
    Context "Win 10 (21H1)" {
        It "Return Results" {
            $Results = Get-LatestOSBuild -OSName Win10 -OSVersion 21H1 -latestreleases 1000
            $Results.Build.Count | Should -BeGreaterThan 1
            $Results.Version | Should -Not -BeNullOrEmpty
            $Results.Build | Should -Not -BeNullOrEmpty
            $Results.'Availability date' | Should -Not -BeNullOrEmpty
            $Results.Preview | Should -Not -BeNullOrEmpty
            $Results.'Out-of-band' | Should -Not -BeNullOrEmpty
            $Results.'Servicing option' | Should -Not -BeNullOrEmpty
            $Results.'KB article' | Should -Not -BeNullOrEmpty
            $Results.'KB URL' | Should -Not -BeNullOrEmpty
            $Results.'Catalog URL' | Should -Not -BeNullOrEmpty
        }
    }
    Context "Win 10 (21H2)" {
        It "Return Results" {
            $Results = Get-LatestOSBuild -OSName Win10 -OSVersion 21H2 -latestreleases 1000
            $Results.Build.Count | Should -BeGreaterThan 1
            $Results.Version | Should -Not -BeNullOrEmpty
            $Results.Build | Should -Not -BeNullOrEmpty
            $Results.'Availability date' | Should -Not -BeNullOrEmpty
            $Results.Preview | Should -Not -BeNullOrEmpty
            $Results.'Out-of-band' | Should -Not -BeNullOrEmpty
            $Results.'Servicing option' | Should -Not -BeNullOrEmpty
            $Results.'KB article' | Should -Not -BeNullOrEmpty
            $Results.'KB URL' | Should -Not -BeNullOrEmpty
            $Results.'Catalog URL' | Should -Not -BeNullOrEmpty
        }
    }
    Context "Win 11 (21H2)" {
        It "Return Results" {
            $Results = Get-LatestOSBuild -OSName Win11 -OSVersion 21H2 -latestreleases 1000
            $Results.Build.Count | Should -BeGreaterThan 1
            $Results.Version | Should -Not -BeNullOrEmpty
            $Results.Build | Should -Not -BeNullOrEmpty
            $Results.'Availability date' | Should -Not -BeNullOrEmpty
            $Results.Preview | Should -Not -BeNullOrEmpty
            $Results.'Out-of-band' | Should -Not -BeNullOrEmpty
            $Results.'Servicing option' | Should -Not -BeNullOrEmpty
            $Results.'KB article' | Should -Not -BeNullOrEmpty
            $Results.'KB URL' | Should -Not -BeNullOrEmpty
            $Results.'Catalog URL' | Should -Not -BeNullOrEmpty
        }
    }
    Context "Server 2022 (21H2)" {
        It "Return Results" {
            $Results = Get-LatestOSBuild -OSName Server2022 -OSVersion 21H2 -latestreleases 1000
            $Results.Build.Count | Should -BeGreaterThan 1
            $Results.Version | Should -Not -BeNullOrEmpty
            $Results.Build | Should -Not -BeNullOrEmpty
            $Results.'Availability date' | Should -Not -BeNullOrEmpty
            $Results.Preview | Should -Not -BeNullOrEmpty
            $Results.'Out-of-band' | Should -Not -BeNullOrEmpty
            $Results.'Servicing option' | Should -Not -BeNullOrEmpty
            $Results.'KB article' | Should -Not -BeNullOrEmpty
            $Results.'KB URL' | Should -Not -BeNullOrEmpty
            $Results.'Catalog URL' | Should -Not -BeNullOrEmpty
        }
    }
    Context "Server SAC (1709)" {
        It "Return Results" {
            $Results = Get-LatestOSBuild -OSName ServerSAC -OSVersion 1709 -latestreleases 1000
            $Results.Build.Count | Should -BeGreaterThan 1
            $Results.Version | Should -Not -BeNullOrEmpty
            $Results.Build | Should -Not -BeNullOrEmpty
            $Results.'Availability date' | Should -Not -BeNullOrEmpty
            $Results.Preview | Should -Not -BeNullOrEmpty
            $Results.'Out-of-band' | Should -Not -BeNullOrEmpty
            $Results.'Servicing option' | Should -Not -BeNullOrEmpty
            $Results.'KB article' | Should -Not -BeNullOrEmpty
            $Results.'KB URL' | Should -Not -BeNullOrEmpty
            $Results.'Catalog URL' | Should -Not -BeNullOrEmpty
        }
    }
}