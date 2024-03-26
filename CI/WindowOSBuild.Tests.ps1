BeforeAll {
    $Path =  (Get-Item $PsScriptRoot).parent.FullName + "\WindowsOSBuild.psm1"
    . Import-Module -Name $Path -Verbose
}

If ($PSVersionTable.PSVersion.Major -le 6) {
    Describe "PS - Get-LatestOSBuild" {
        Context "Win 10 (1507)" {
            It "Results" {
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
            It "Results" {
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
            It "Results" {
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
            It "Results" {
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
            It "Results" {
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
            It "Results" {
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
            It "Results" {
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
            It "Results" {
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
            It "Results" {
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
            It "Results" {
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
            It "Results" {
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
            It "Results" {
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
            It "Results" {
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
        Context "Win 10 (22H2)" {
            It "Results" {
                $Results = Get-LatestOSBuild -OSName Win10 -OSVersion 22H2 -latestreleases 1000
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
            It "Results" {
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
        Context "Win 11 (22H2)" {
            It "Results" {
                $Results = Get-LatestOSBuild -OSName Win11 -OSVersion 22H2 -latestreleases 1000
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
        Context "Win 11 (23H2)" {
            It "Results" {
                $Results = Get-LatestOSBuild -OSName Win11 -OSVersion 23H2 -latestreleases 1000
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
            It "Results" {
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
        Context "Server 2022 Hotpatch (21H2)" {
            It "Results" {
                $Results = Get-LatestOSBuild -OSName Server2022Hotpatch -OSVersion 21H2 -latestreleases 1000
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
            It "Results" {
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
    Describe "PS - Get-CurrentOSBuild" {
        Context "Build only" {
            It "Results" {
                $Results = Get-CurrentOSBuild
                $Results.Count | Should -Be 1
            }
        }
        Context "Detailed" {
            It "Results" {
                $Results = Get-CurrentOSBuild -Detailed
                $Results.Build.Count | Should -Be 1
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
}
Else {
    Describe "PWSH - Get-LatestOSBuild" {
        Context "Win 10 (1507)" {
            It "Results" {
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
            It "Results" {
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
            It "Results" {
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
            It "Results" {
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
            It "Results" {
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
            It "Results" {
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
            It "Results" {
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
            It "Results" {
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
            It "Results" {
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
            It "Results" {
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
            It "Results" {
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
            It "Results" {
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
            It "Results" {
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
        Context "Win 10 (22H2)" {
            It "Results" {
                $Results = Get-LatestOSBuild -OSName Win10 -OSVersion 22H2 -latestreleases 1000
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
            It "Results" {
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
        Context "Win 11 (22H2)" {
            It "Results" {
                $Results = Get-LatestOSBuild -OSName Win11 -OSVersion 22H2 -latestreleases 1000
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
        Context "Win 11 (23H2)" {
            It "Results" {
                $Results = Get-LatestOSBuild -OSName Win11 -OSVersion 23H2 -latestreleases 1000
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
            It "Results" {
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
        Context "Server 2022 Hotpatch (21H2)" {
            It "Results" {
                $Results = Get-LatestOSBuild -OSName Server2022Hotpatch -OSVersion 21H2 -latestreleases 1000
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
            It "Results" {
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

    Describe "PWSH - Get-CurrentOSBuild" {
        Context "Build only" {
            It "Results" {
                $Results = Get-CurrentOSBuild
                $Results.Count | Should -Be 1
            }
        }
        Context "Detailed" {
            It "Results" {
                $Results = Get-CurrentOSBuild -Detailed
                $Results.Build.Count | Should -Be  1
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
}