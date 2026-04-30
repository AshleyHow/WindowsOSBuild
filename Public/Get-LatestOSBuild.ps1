Function Get-LatestOSBuild {
    <#
        .SYNOPSIS
            Gets Windows patch release information (Version, Build, Availability date, Hotpatch, Preview, Out-of-band, Servicing option, KB article, KB URL and Catalog URL) for Windows client and server versions.
            Useful for scripting and automation purposes. Supports Windows 10 and Windows Server 2016 onwards. Supports Hotpatch on Windows 11, Windows Server 2022 and Windows Server 2025.
        .DESCRIPTION
            Patch information retrieved from Microsoft Release Health / Update History pages and outputted in a usable format.
            These sources are updated regularly by Microsoft AFTER new patches are released. This means at times this info may not always be in sync with Windows Update.
        .PARAMETER OSName
            This parameter is optional. OS name you want to check. Default value is Win10. Accepted values:

            Windows Client OS Names                    - Win10, Win11, Win11Hotpatch.
            Windows Server OS Names                    - Server2016, Server2019, Server2022, Server2022Hotpatch, Server2025, Server2025Hotpatch, Server Semi-annual = ServerSAC.
        .PARAMETER OSVersion
            This parameter is mandatory. OS version number you want to check. Accepted values:

            Windows Client OS Versions:
            CB/CBB/SAC (Semi-Annual Channel)           - 1507, 1511, 1607, 1703, 1709, 1803, 1809, 1903, 1909, 2004, 20H2, 21H2, 22H2, 23H2, 24H2, 25H2.
            Win 10 LTSB/LTSC                           - 2015 = 1507, 2016 = 1607, 2019 = 1809, 2021 = 21H2.
            Win 11 LTSC                                - 2024 = 24H2.

            Window Server OS Versions:
            SAC (Semi-Annual Channel)                  - 1709, 1803, 1809, 1903, 1909, 2004, 20H2.
            LTSB/LTSC                                  - 2016 = 1607, 2019 = 1809, 2022 = 21H2, 2025 = 24H2.
        .PARAMETER LatestReleases
            This parameter is optional. Returns last x releases (where x is the number of releases you want to display). Default value is 1.
        .PARAMETER BuildOnly
            This parameter is optional. Returns full build number/s only.
        .PARAMETER ExcludePreview
            This parameter is optional. Excludes preview release/s.
        .PARAMETER ExcludeOutOfBand
            This parameter is optional. Excludes out-of-band release/s.
        .PARAMETER PreviewOnly
            This parameter is optional. Returns preview release/s only.
        .PARAMETER OutOfBandOnly
            This parameter is optional. Returns out-of-band/s only.
        .PARAMETER NoCache
            This parameter is optional. Bypasses cache completely for this run. No cache is read and no cache is written.
        .PARAMETER RefreshCache
            This parameter is optional. Forces fresh download from Microsoft sources and updates the cache.
        .PARAMETER CacheTTLHours
            This parameter is optional. Defines cache lifetime in hours. Alias: TTL. Default: 8. Range: 0.01 to 720.

        .EXAMPLE
            Get-LatestOSBuild -OSName Win11 -OSVersion 25H2
            Show all information on the latest available OS build for Windows 11 Version 25H2 in list format.
        .EXAMPLE
            Get-LatestOSBuild -OSName Win11 -OSVersion 25H2 -LatestReleases 2
            Show all information on the latest 2 releases of OS builds for Windows 11 Version 25H2 in list format.
        .EXAMPLE
            Get-LatestOSBuild -OSName Win11 -OSVersion 25H2 -ExcludePreview -LatestReleases 2
            Show all information on the latest 2 releases excluding preview of OS builds for Windows 11 Version 25H2 in list format.
        .EXAMPLE
            Get-LatestOSBuild -OSName Win11 -OSVersion 25H2 -ExcludeOutOfBand -LatestReleases 2
            Show all information on the latest 2 releases excluding out-of-band of OS builds for Windows 11 Version 25H2 in list format.
        .EXAMPLE
            Get-LatestOSBuild -OSName Win11 -OSVersion 25H2 -PreviewOnly -LatestReleases 2
            Show all information on the latest 2 preview releases of OS builds for Windows 11 Version 25H2 in list format.
        .EXAMPLE
            Get-LatestOSBuild -OSName Win11 -OSVersion 25H2 -OutOfBandOnly -LatestReleases 2
            Show all information on the latest 2 out-of-band releases of OS builds for Windows 11 Version 25H2 in list format.
        .EXAMPLE
            Get-LatestOSBuild -OSName Win11 -OSVersion 25H2 -BuildOnly
            Show only the latest available OS build for Windows 11 Version 25H2 in list format.
        .EXAMPLE
            Get-LatestOSBuild -OSName Win11 -OSVersion 25H2 -PreviewOnly -BuildOnly
            Show only the latest available preview OS build for Windows 11 Version 25H2 in list format.
        .EXAMPLE
            Get-LatestOSBuild -OSName Win11 -OSVersion 25H2 -OutOfBandOnly -BuildOnly
            Show only the latest available out-of-band OS build for for Windows 11 Version 25H2 in list format.
        .EXAMPLE
            Get-LatestOSBuild -OSName Win11 -OSVersion 25H2 | ConvertTo-Json
            Show all information on the latest available OS build for Windows 11 Version 25H2 in json format.
        .EXAMPLE
            Get-LatestOSBuild -OSName Win11 -OSVersion 25H2 | ConvertTo-Json | Out-File .\Get-LatestOSBuild.json
            Save the json format to a file on the latest available OS build for Windows 11 Version 25H2.

        .NOTES
            Forked from 'Get-Windows10ReleaseInformation.ps1' created by Fredrik Wall.
            https://github.com/FredrikWall/PowerShell/blob/master/Windows/Get-Windows10ReleaseInformation.ps1
            Uses code adapted from 'Get-CurrentPatchInfo.ps1' created by Trevor Jones.
            https://gist.githubusercontent.com/SMSAgentSoftware/79fb091a4b7806378fc0daa826dbfb47/raw/0f6b52cddf82b2aa836a813cf6bc910a52a48c9f/Get-CurrentPatchInfo.ps1
    #>

    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true)]
        [String]$OSVersion,

        [Parameter(Mandatory = $false)]
        [String]$LatestReleases = 1,

        [Parameter(Mandatory = $false)]
        [ValidateSet('Win10','Win11','Win11Hotpatch','Server2016','Server2019','Server2022','Server2022Hotpatch','Server2025','Server2025Hotpatch','ServerSAC')]
        [String]$OSName = "Win10",

        [Parameter(Mandatory = $false)]
        [Switch]$BuildOnly,

        [Parameter(Mandatory = $false)]
        [Switch]$ExcludePreview,

        [Parameter(Mandatory = $false)]
        [Switch]$ExcludeOutOfBand,

        [Parameter(Mandatory = $false)]
        [Switch]$PreviewOnly,

        [Parameter(Mandatory = $false)]
        [Switch]$OutOfBandOnly,

        [Parameter(Mandatory = $false)]
        [Switch]$NoCache,

        [Parameter(Mandatory = $false)]
        [Switch]$RefreshCache,

        [Alias('TTL')]
        [Parameter(Mandatory = $false)]
        [ValidateRange(0.01,720)]
        [double]$CacheTTLHours = 8
    )

    # Disable progress bar to speed up Invoke-WebRequest calls
    $ProgressPreference = 'SilentlyContinue'

    # Allow TLS 1.2 without overriding OS or external TLS configuration
    [Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12

    # Modern browser-like headers to avoid CDN blocking in Windows PowerShell
    $Headers = @{
        "User-Agent"      = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36"
        "Accept"          = "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8"
        "Accept-Language" = "en-GB,en;q=0.9"
    }

    # Local raw web cache to reduce repeated requests and avoid Microsoft CDN denial-of-service protection.
    # Cache is stored in the original raw format (HTML/XML/text), not JSON or CLIXML.
    $CachePath = Join-Path $env:LOCALAPPDATA 'WindowsOSBuild\Cache'
    $CacheTTL = New-TimeSpan -Hours $CacheTTLHours

    Function Get-OSBuildCacheFile {
        Param(
            [Parameter(Mandatory = $true)]
            [String]$Key
        )

        If (-not (Test-Path $CachePath)) {
            New-Item -Path $CachePath -ItemType Directory -Force | Out-Null
        }

        $SHA256 = [System.Security.Cryptography.SHA256]::Create()
        $HashBytes = $SHA256.ComputeHash([System.Text.Encoding]::UTF8.GetBytes($Key))
        $Hash = [BitConverter]::ToString($HashBytes).Replace('-', '').ToLowerInvariant()

        Return (Join-Path $CachePath "$Hash.cache")
    }

    Function Get-CachedContent {
        Param(
            [Parameter(Mandatory = $true)]
            [String]$Key,

            [Parameter(Mandatory = $true)]
            [ScriptBlock]$ScriptBlock,

            [Switch]$NoCache,

            [Switch]$RefreshCache
        )

        $CacheFile   = Get-OSBuildCacheFile -Key $Key
        $CacheFolder = Split-Path -Path $CacheFile -Parent
        $TempFile    = "$CacheFile.tmp"

        If (-not (Test-Path $CacheFolder)) {
            New-Item -Path $CacheFolder -ItemType Directory -Force | Out-Null
        }

        If ($NoCache) {
            Write-Verbose "Bypassing cache: $Key"
        }
        ElseIf ($RefreshCache) {
            Write-Verbose "Refreshing cache: $Key"
        }
        ElseIf ((Test-Path $CacheFile) -and (((Get-Date) - (Get-Item $CacheFile).LastWriteTime) -lt $CacheTTL)) {
            Write-Verbose "Using cached content: $CacheFile"
            Return [System.IO.File]::ReadAllText($CacheFile, [System.Text.Encoding]::UTF8)
        }

        Try {
            $Content = [String](& $ScriptBlock)

            If ([String]::IsNullOrWhiteSpace($Content)) {
                Throw "Downloaded content was empty. Cache not updated."
            }

            If (-not $NoCache) {
                Write-Verbose "Writing cache: $CacheFile"
                [System.IO.File]::WriteAllText($TempFile, $Content, [System.Text.Encoding]::UTF8)
                Move-Item -Path $TempFile -Destination $CacheFile -Force
            }

            Return $Content
        }
        Catch {
            If (Test-Path $TempFile) {
                Remove-Item -Path $TempFile -Force -ErrorAction SilentlyContinue
            }

            If (-not $NoCache -and (Test-Path $CacheFile)) {
                Write-Verbose "Using stale cache after failure: $CacheFile"
                Return [System.IO.File]::ReadAllText($CacheFile, [System.Text.Encoding]::UTF8)
            }

            Throw
        }
    }

    Function Invoke-CachedWebRequestContent {
        Param(
            [Parameter(Mandatory = $true)]
            [String]$Uri,

            [String]$Method = 'Get',

            [Switch]$NoCache,

            [Switch]$RefreshCache
        )

        Return Get-CachedContent -Key "Invoke-WebRequest|$Method|$Uri" -NoCache:$NoCache -RefreshCache:$RefreshCache -ScriptBlock {
            (Invoke-WebRequest -Uri $Uri -Method $Method -Headers $Headers -UseBasicParsing -ErrorAction Stop).Content
        }
    }

    Function Invoke-CachedRestMethodContent {
        Param(
            [Parameter(Mandatory = $true)]
            [String]$Uri,

            [Switch]$NoCache,

            [Switch]$RefreshCache
        )

        Return Get-CachedContent -Key "Invoke-RestMethod|$Uri" -NoCache:$NoCache -RefreshCache:$RefreshCache -ScriptBlock {
            $Result = Invoke-RestMethod -Uri $Uri -Headers $Headers -UseBasicParsing -ErrorAction Stop

            If ($null -ne $Result.Content) {
                $Result.Content
            }
            Else {
                [String]$Result
            }
        }
    }

    Function Invoke-CachedHtmlWebLoad {
        Param(
            [Parameter(Mandatory = $true)]
            [String]$Uri,

            [Switch]$NoCache,

            [Switch]$RefreshCache
        )

        $RawHtml = Get-CachedContent -Key "HtmlWeb.Load|$Uri" -NoCache:$NoCache -RefreshCache:$RefreshCache -ScriptBlock {
            ((New-Object HtmlAgilityPack.HtmlWeb).Load($Uri)).DocumentNode.OuterHtml
        }

        $HtmlDocument = New-Object HtmlAgilityPack.HtmlDocument
        $HtmlDocument.LoadHtml($RawHtml)
        Return $HtmlDocument
    }

    # Define variables for OSName
    If (($OSName) -eq "Win11") {
        $OSBase = "Windows 11"
        $URL = "https://docs.microsoft.com/en-us/windows/release-health/windows11-release-information"
        $TableNumber = 1
        $AtomFeedUrl = "https://support.microsoft.com/en-us/feed/atom/4ec863cc-2ecd-e187-6cb3-b50c6545db92"
    }
    ElseIf (($OSName) -eq "Win10" -or ($OSName) -eq "Server2016" -or ($OSName) -eq "Server2019" -or ($OSName) -eq "ServerSAC") {
        $OSBase = "Windows 10"
        $URL = "https://docs.microsoft.com/en-us/windows/release-health/release-information"
        $TableNumber = 2
        $AtomFeedUrl = "https://support.microsoft.com/en-us/feed/atom/6ae59d69-36fc-8e4d-23dd-631d98bf74a9"
    }
    ElseIf ($OSName -eq "Win11HotPatch" -and $OSVersion -eq "24H2") {
        $URL = "https://support.microsoft.com/en-us/topic/release-notes-for-hotpatch-on-windows-11-enterprise-version-24h2-c0906ee6-5e62-498f-bd5a-8f4966349f3c"
        $AtomFeedUrl = "https://support.microsoft.com/en-us/feed/atom/4ec863cc-2ecd-e187-6cb3-b50c6545db92"
        $CategoryName = "Windows 11 Enterprise version 24H2"
        $HotpatchOSBuild = "26100"
    }
    ElseIf ($OSName -eq "Win11HotPatch" -and $OSVersion -eq "25H2") {
        $URL = "https://support.microsoft.com/en-us/topic/release-notes-for-hotpatch-on-windows-11-enterprise-version-25h2-0bbaa1c7-5070-41ca-a7c9-4ead79602dbf"
        $AtomFeedUrl = "https://support.microsoft.com/en-us/feed/atom/4ec863cc-2ecd-e187-6cb3-b50c6545db92"
        $CategoryName = "Windows 11 Enterprise version 25H2"
        $HotpatchOSBuild = "26200"
    }
    ElseIf ($OSName -eq "Server2022" -or $OSName -eq "Server2022Hotpatch") {
        # Disabled automatic detection of hotfix as it is not a reliable method of guaranteeing devices are applying hotpatch updates, non-hotpatch updates can still be applied.
        # $HotpatchOS = Get-HotFix -Id KB5003508 -ErrorAction SilentlyContinue
        if ($OSName -eq "Server2022Hotpatch") {
            $URL = "https://support.microsoft.com/en-us/topic/release-notes-for-hotpatch-in-azure-automanage-for-windows-server-2022-4e234525-5bd5-4171-9886-b475dabe0ce8"
            $AtomFeedUrl = "https://support.microsoft.com/en-us/feed/atom/2d67e9fb-2bd2-6742-08ee-628da707657f"
            $CategoryName = "Release notes for Hotpatch in Azure Automanage for Windows Server 2022"
        }
        Else {
            $URL = "https://support.microsoft.com/en-us/topic/windows-server-2022-update-history-e1caa597-00c5-4ab9-9f3e-8212fe80b2ee"
            $CategoryName = "Windows Server 2022"
        }
    }
    ElseIf ($OSName -eq "Server2025" -or $OSName -eq "Server2025Hotpatch") {
        # Disabled automatic detection of hotfix as it is not a reliable method of guaranteeing devices are applying hotpatch updates, non-hotpatch updates can still be applied.
        # $HotpatchOS = Get-HotFix -Id KB5003508 -ErrorAction SilentlyContinue
        if ($OSName -eq "Server2025Hotpatch") {
            $URL = "https://support.microsoft.com/en-us/topic/release-notes-for-hotpatch-on-windows-server-2025-datacenter-azure-edition-c548437e-8c7a-4e27-99f4-e8746f97f8fa"
            $AtomFeedUrl = "https://support.microsoft.com/en-us/feed/atom/c7b7e227-e17e-8633-fd90-9d28fb739cc5"
            $CategoryName = "Release notes for Hotpatch on Windows Server 2025 Datacenter Azure Edition"
        }
        Else {
            $URL = "https://support.microsoft.com/en-us/topic/windows-server-2025-update-history-10f58da7-e57b-4a9d-9c16-9f1dcd72d7d7"
            $CategoryName = "Windows Server 2025"
        }
    }
    Else {
        Throw "Get-LatestOSBuild: Unsupported Operating System"
    }

    # Enforce OSVersion for LTSC Server OSName to prevent incorrect OSVersion input
    If ($OSName -eq "Server2016") {
        $OSVersion = "1607"
    }
    ElseIf ($OSName -eq "Server2019") {
        $OSVersion = "1809"
    }
    ElseIf ($OSName -eq "Server2022" -or $OSName -eq "Server2022Hotpatch") {
        $OSVersion = "21H2"
    }
    ElseIf ($OSName -eq "Server2025" -or $OSName -eq "Server2025Hotpatch") {
        $OSVersion = "24H2"
    }

    # Function used for to convert raw array from support URL to a parsed array (currently used only for Server 2022)
    Function Convert-ParsedArray {
        Param($Array)

        $ArrayList = New-Object System.Collections.ArrayList
        ForEach ($item in $Array) {
            $Match = [regex]::Match($item.Title, "Build (\d+\.\d+)")
            If ($Match.Success) {
                $OSBuild = [System.Version]::new($Match.Groups[1].Value)
            }
            Else {
                $OSBuild = $null
            }

            [Void]$ArrayList.Add([PSCustomObject]@{
                Update = $item.Title.Replace('&#x2014;', ' — ').Trim()
                KB       = "KB" + $item.link.Split('/')[-1]
                InfoURL  = "https://support.microsoft.com" + $item.Link
                OSBuild  = $OSBuild  # Add OSBuild here in the hashtable
            })
        }
        Return $ArrayList
    }

    # Function used to get update release notes of specified OS as an array
    Function Get-ReleaseNotes {
        param (
            [string]$webpage,
            [string]$CategoryName
        )

        # Create an HtmlDocument object
        $htmlDocument = New-Object HtmlAgilityPack.HtmlDocument
        $htmlDocument.LoadHtml($webpage)

        # Check if HTML loaded correctly
        if ($htmlDocument.DocumentNode.InnerHtml -eq "") {
            return
        }

        # Find all categories with 'supLeftNavCategoryTitle' class
        $categoryTitles = $htmlDocument.DocumentNode.SelectNodes('//div[contains(@class, "supLeftNavCategoryTitle")]')

        if (!$categoryTitles) {
            return
        }

        # Initialize a list to store categorized links
        $categorizedLinks = @()

        # Loop through each category and extract article links
        foreach ($category in $categoryTitles) {
            $osName = $category.SelectSingleNode('.//a').InnerText

            # If CategoryName parameter is provided, only process matching categories
            if ($CategoryName -and $osName -notlike "*$CategoryName*") {
                continue
            }

            $articlesList = $category.ParentNode.SelectNodes('.//ul[contains(@class, "supLeftNavArticles")]')

            if ($articlesList) {
                foreach ($articleList in $articlesList) {
                    foreach ($article in $articleList.SelectNodes('.//li')) {
                        $articleLinkNode = $article.SelectSingleNode('.//a')
                        if ($articleLinkNode) {
                            $categorizedLinks += [PSCustomObject]@{
                                Category = $osName
                                Link     = $articleLinkNode.GetAttributeValue('href', '')
                                Title    = $articleLinkNode.InnerText.Trim()
                            }
                        }
                    }
                }
            }
        }

        # Return the categorized links as output
        ## Match KB numbers like KB5066360 or match dates like "January 11, 2022"
        return $categorizedLinks | Where-Object { $_.Title -match 'KB\d{6,7}' -or $_.Title -match '(January|February|March|April|May|June|July|August|September|October|November|December) \d{1,2}, \d{4}' }
    }

    # Obtain data from webpage
    Try {
        If ($OSName -eq "Server2022" -or $OSName -eq "Server2025") {
            $Webpage = Invoke-CachedWebRequestContent -Uri $URL -NoCache:$NoCache -RefreshCache:$RefreshCache
        }
        # Supports Server 2022 Hotpatch
        Else {
            If ($OSName -eq "Win11Hotpatch" -or $OSName -eq "Server2022Hotpatch" -or $OSName -eq "Server2025Hotpatch") {
                $Webpage = Invoke-CachedWebRequestContent -Uri $URL -NoCache:$NoCache -RefreshCache:$RefreshCache
            }
            Else {
                # All other OS
                $Webpage = Invoke-CachedRestMethodContent -Uri $URL -NoCache:$NoCache -RefreshCache:$RefreshCache
            }

            # Fetch the Atom feed content, used to obtain preview and out-of-band data
            If ($AtomFeedUrl -ne "N/A") {
                $feedContent = Invoke-CachedWebRequestContent -Uri $AtomFeedUrl -Method Get -NoCache:$NoCache -RefreshCache:$RefreshCache

                # Use regular expressions to extract entries
                $pattern = '<entry>\s*<id>(.*?)<\/id>\s*<title\s+type="text">(.*?)<\/title>\s*<published>(.*?)<\/published>\s*<updated>(.*?)<\/updated>\s*<link\s+rel="alternate"\s+href="(.*?)"\s*\/>\s*<content\s+type="text">(.*?)<\/content>\s*<\/entry>'
                $AtomMatches = [regex]::Matches($feedContent, $pattern)

                If ($AtomMatches.Count -eq 0) {
                    Throw "Get-LatestOSBuild: No <entry> elements found in the atom feed."
                }
                Else {
                    # Initialize a list to store filtered feed entries
                    $feedEntries = New-Object System.Collections.Generic.List[PSObject]

                    # Iterate over matched entries
                    ForEach ($AtomMatch in $AtomMatches) {
                        $title     = $AtomMatch.Groups[2].Value
                        $published = $AtomMatch.Groups[3].Value
                        $link      = $AtomMatch.Groups[5].Value

                        # Filter out entries that do not contain "OS" in the title
                        If (($title -like '*(OS*') -or ($title -like '*Security Update for*')) {
                            # Create a hashtable for the entry
                            $feedEntry = @{
                                Title     = $title
                                Published = $published
                                Link      = $link
                            }

                            # Add the entry to the list
                            $feedEntries.Add([PSCustomObject]$feedEntry)
                        }
                    }
                }
            }
        }
    }
    Catch {
        If ($_.Exception.Message -like '*403*') {
            Throw "Get-LatestOSBuild: Unable to obtain patch release information. Akamai CDN denial-of-service protection active. Error: $($_.Exception.Message)"
        }
        Else {
            Throw "Get-LatestOSBuild: Unable to obtain patch release information. Please check your internet connectivity. Error: $($_.Exception.Message)"
        }
    }

    # Server 2022 and 2025, Server 2022 Hotpatch, Server 2025 Hotpatch, Windows 11 Hotpatch.
    If ($OSName -eq "Win11Hotpatch" -or $OSName -eq "Server2022" -or $OSName -eq "Server2025" -or $OSName -eq "Server2022Hotpatch" -or $OSName -eq "Server2025Hotpatch") {
        $Table = @()
        $Table =  @(
            $VersionDataRaw = $null
            $VersionDataRaw = Get-ReleaseNotes -Webpage $webpage -CategoryName $CategoryName | Sort-Object -Property Title -Unique
            # Excludes security updates from the list which are not updates that change the build e.g KB5061096—Security Update for Windows PowerShell
            $UniqueList =  (Convert-ParsedArray -Array $VersionDataRaw) | Sort-Object OSBuild -Descending
            ForEach ($Update in $UniqueList) {
                $ResultObject = [Ordered] @{}
                # Support for Hotpatch
                If ($null -eq $Update.OSBuild.Major) {
                    If ($OSName -eq "Win11Hotpatch") {
                        $ResultObject["Version"] = "Version $OSVersion (OS build $HotpatchOSBuild)"
                    }
                    If ($OSName -eq "Server2022Hotpatch") {
                        $ResultObject["Version"] = "Version $OSVersion (OS build 20348)"
                    }
                    If ($OSName -eq "Server2025Hotpatch") {
                        $ResultObject["Version"] = "Version $OSVersion (OS build 26100)"
                    }
                }
                Else {
                    $ResultObject["Version"] = "Version $OSVersion (OS build $($Update.OSBuild.Major))"
                }
                # Support for Hotpatch - As we are performing matching based on date, this accounts for erroronus spaces in the date.
                If ($null -eq $Update.OSBuild) {
                    $updateDate = ($Update.Update -replace '^([A-Za-z]+\s\d{1,2},\s\d{4}).*', '$1').Trim()
                    $SourceOSBuild = $feedEntries.Title -like "*$updateDate*"
                    $ResultObject["Build"] = [String]$SourceOSBuild -replace '.*OS Build (\d+\.\d+).*', '$1'
                }
                Else {
                    $ResultObject["Build"] = [String]$Update.OSBuild
                }
                # Exclude date calculation for updates that don't have dates published in the title
                If ($Update -notlike "*Security Update*") {
                    $GetDate = [regex]::Match($Update.Update,"(Jan(uary)?|Feb(ruary)?|Mar(ch)?|Apr(il)?|May|Jun(e)?|Jul(y)?|Aug(ust)?|Sep(tember)?|Oct(ober)?|Nov(ember)?|Dec(ember)?)\s+\d{1,2},\s+\d{4}").Value
                    Try {
                        $ConvertToDate = [Datetime]::ParseExact($GetDate, 'MMMM dd, yyyy', [Globalization.CultureInfo]::CreateSpecificCulture('en-US'))
                    }
                    Catch {
                        $ConvertToDate = [Datetime]::ParseExact($GetDate, 'MMMM d, yyyy', [Globalization.CultureInfo]::CreateSpecificCulture('en-US'))
                    }
                    $FormatDate =  Get-Date($ConvertToDate) -Format 'yyyy-MM-dd'
                    $ResultObject["Availability date"] = $FormatDate
                }
                Else {
                    # Extract KB ID from title - Security Updates
                    $KBID = [regex]::Match($Update.Update, 'KB\d{7}').Value
                    $MatchedEntry = $feedEntries | Where-Object { $_.Title -match $KBID }

                    If ($MatchedEntry) {
                        $PublishedDate = Get-Date($MatchedEntry.Published) -Format 'yyyy-MM-dd'
                        $ResultObject["Availability date"] = $PublishedDate
                    }
                    Else {
                        #Write-Warning "No matching feed entry for: $KBID"
                        $ResultObject["Availability date"] = "0000-00-00"
                    }
                    $ResultObject["Build"] = "Security Update"
                }

                If ($OSName -eq "Win11Hotpatch" -or $OSName -eq "Server2022Hotpatch" -or $OSName -eq "Server2025Hotpatch") {
                    If ($Update.Update -match 'Baseline' -or $Update.Update -match 'Security Update') {
                        $ResultObject["Hotpatch"] = "False"
                    }
                    Else {
                        $ResultObject["Hotpatch"] = "True"
                    }
                }
                If ($Update.Update -match 'Preview') {
                    $ResultObject["Preview"] = "True"
                }
                Else {
                    $ResultObject["Preview"] = "False"
                }
                If ($Update.Update -match 'Out-of-band') {
                    $ResultObject["Out-of-band"] = "True"
                }
                Else {
                    $ResultObject["Out-of-band"] = "False"
                }
                $ResultObject["Servicing option"] = "LTSC"
                If (($OSName -eq "Win11Hotpatch" -or $OSName -eq "Server2022Hotpatch" -or $OSName -eq "Server2025Hotpatch") -and ($ResultObject.Hotpatch -eq "False") -and ($ResultObject.Build -ne "Security Update")) {
                    $ResultObject["KB source article"] = ([regex]::Match($SourceOSBuild, 'KB\s?\d{7}').Value) -replace '\s', ''
                    $ResultObject["KB article"] = $Update.KB + " / " + $ResultObject.'KB source article'
                }
                Else {
                    $ResultObject["KB article"] = $Update.KB
                }
                If (($OSName -eq "Win11Hotpatch" -or $OSName -eq "Server2022Hotpatch" -or $OSName -eq "Server2025Hotpatch") -and ($ResultObject.Hotpatch -eq "False")) {
                    $ResultObject["KB URL"] = $Update.InfoURL
                    $ResultObject["KB source URL"] = "https://support.microsoft.com/en-us/help" + $ResultObject.'KB source article'
                }
                Else {
                    $ResultObject["KB URL"] = $Update.InfoURL
                }
                If (($OSName -eq "Win11Hotpatch" -or $OSName -eq "Server2022Hotpatch" -or $OSName -eq "Server2025Hotpatch") -and ($ResultObject.Hotpatch -eq "True")) {
                    $ResultObject["Catalog URL"] =  "N/A"
                }
                Else {
                    $ResultObject["Catalog URL"] =  "https://www.catalog.update.microsoft.com/Search.aspx?q=" + $Update.KB
                }
                # Cast hash table to a PSCustomObject
                If ($OSName -eq "Win11Hotpatch" -or $OSName -eq "Server2022Hotpatch" -or $OSName -eq "Server2025Hotpatch") {
                    [PSCustomObject]$ResultObject | Select-Object -Property 'Version', 'Build', 'Availability date', 'Hotpatch', 'Preview', 'Out-of-band', 'Servicing option', 'KB article', 'KB URL', 'Catalog URL'
                }
                Else {
                    [PSCustomObject]$ResultObject | Select-Object -Property 'Version', 'Build', 'Availability date', 'Preview', 'Out-of-band', 'Servicing option', 'KB article', 'KB URL', 'Catalog URL'
                }
            }
        )

        # Include build information for Server 2022 RTM not included in Windows Update History
        $Server2022RTM = [PsCustomObject]@{
                        'Version' = "Version 21H2 (OS build 20348)"
                        'Build' = "20348.169"
                        'Availability date' = "2021-08-18"
                        'Preview' = "False"
                        'Out-of-band' = "False"
                        'Servicing option' = "LTSC"
                        'KB article' = "N/A"
                        'KB URL' = "N/A"
                        'Catalog URL' = "N/A"
        }

        # Include build information for Server 2025 RTM not included in Windows Update History
        $Server2025RTM = [PsCustomObject]@{
                        'Version' = "Version 24H2 (OS build 26100)"
                        'Build' = "26100.1742"
                        'Availability date' = "2024-09-10"
                        'Preview' = "False"
                        'Out-of-band' = "False"
                        'Servicing option' = "LTSC"
                        'KB article' = "N/A"
                        'KB URL' = "N/A"
                        'Catalog URL' = "N/A"
        }

        # Add / Sort Arrays
        If ($OSName -eq "Win11Hotpatch" -or $OSName -eq "Server2022Hotpatch" -or $OSName -eq "Server2025Hotpatch") {
            $Table = $Table | Sort-Object -Property 'Availability date' -Descending
        }
        ElseIf ($OSName -eq "Server2022") {
            $Table = $Table + $Server2022RTM | Sort-Object -Property 'Availability date' -Descending
        }
        ElseIf ($OSName -eq "Server2025") {
            $Table = $Table + $Server2025RTM | Sort-Object -Property 'Availability date' -Descending
        }

    }
    # All other OS
    Else {
        # Create HTML object using HTML Agility Pack
        $HTML = Invoke-CachedHtmlWebLoad -Uri $URL -NoCache:$NoCache -RefreshCache:$RefreshCache

        # Table Mapping - required to obtain preview and out-of-band information of versions
            ## Select <strong> nodes that have an associated history table
        $GetVersions = @($HTML.DocumentNode.SelectNodes("//strong") | Where-Object {
            ## Check if there is a <table> following the <strong> with ID like historyTable_N. Hotpatch tables are excluded. Hotpatch is dealt with using a different method.
            $null -ne $_.SelectSingleNode(".//following::table[starts-with(@id, 'historyTable_')]")
        })
        $ReleaseVersions = ($GetVersions.innertext).Substring(0)
        $TableMapping = @()
        $TableMapping = ForEach ($Version in $ReleaseVersions) {
            # Windows 11 Base OS
            If ($OSBase -eq "Windows 11") {
                [PSCustomObject]@{
                    'Base' = $OSBase
                    'Version' = $Version
                    'TableNumber'=  $ReleaseVersions.IndexOf($Version) + 2
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
        $SearchVersion = ($TableMapping | Where-Object { $_.Version -like "Version $OSVersion*(OS build*)" } | Select-Object -Unique).Version
        $SearchTable = ($TableMapping | Where-Object { $_.Version -like "Version $OSVersion*(OS build*)" } ).TableNumber

        # Perform search and build table
        $Table = @()
        $Table =  @(
            $Tables = @($HTML.DocumentNode.SelectNodes("//table"))
            Try {
                $Table = $Tables[$SearchTable]
            }
            Catch {
                Throw "Get-LatestOSBuild: Operating system name and version combination not supported. OS Name: $OSname, OS Version: $OSVersion, Error: $($_.Exception.Message)"
            }
            $Titles = @()
            $Rows = @($Table.Descendants("tr"))
            Foreach ($Row in $Rows) {
                # Remove not required row
                If ($Row.InnerText -like "*Servicing option*") {
                    Continue
                }
                $Cells = @($Row.Descendants("td"))

                ## If we've found a table header, remember its titles
                If ($null -ne $Cells[0]) {
                    $Titles = $Cells[0].ParentNode.ParentNode.SelectNodes(".//th").Innertext
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
                    If (![string]::IsNullOrEmpty($ResultObject.'Servicing option')) {
                        # Resolve bullet encoding issue - Windows Terminal
                        If ((Test-Path env:WT_SESSION) -eq "True") {
                            # Directly replace the incorrect sequence with the correct bullet point
                            $ResultObject['Servicing option'] = $ResultObject['Servicing option'].Replace([char]0xE2 + [char]0x80 + [char]0xA2, '•')
                        }
                        # Resolve bullet encoding issue - PowerShell
                        Else {
                            # Directly replace the incorrect sequence with the correct bullet point
                            $ResultObject['Servicing option'] = $ResultObject.'Servicing option' -replace '\s*â¢\s*', ' • '
                        }
                    }
                    $ResultObject[$Title] = ("" + $Cells[$Counter].InnerText).Trim()
                    If ((![string]::IsNullOrEmpty($ResultObject.'KB article')) -and ($ResultObject.'KB article' -ne "N/A")) {
                        $KBURL = "https://support.microsoft.com/en-us/help/" + ($ResultObject."KB article").Trim("KB")
                        $ResultObject["KB URL"] = $KBURL
                        $ResultObject["Catalog URL"] =  "https://www.catalog.update.microsoft.com/Search.aspx?q=" + $ResultObject.'KB article'
                        If ($KBURL -ne " https://support.microsoft.com//en-us/help") {
                            If ([string]::IsNullOrEmpty($feedEntries)) {
                                $ResultObject["Preview"] = "Unknown"
                                $ResultObject["Out-of-band"] = "Unknown"
                            }

                            $Item = $feedEntries | Where-Object -Property Title -match $ResultObject."KB article"
                            If (($Item.Title -match ($ResultObject."KB article")) -and ($Item.Title -match 'Preview')) {
                                $ResultObject["Preview"] = "True"
                            }
                            Else {
                                $ResultObject["Preview"] = "False"
                            }
                            If (($Item.Title -match ($ResultObject."KB article")) -and ($Item.Title -match 'Out-of-band')) {
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
                [PSCustomObject]$ResultObject | Select-Object -Property 'Version', 'Build', 'Availability date','Preview', 'Out-of-band', 'Servicing option', 'KB article', 'KB URL', 'Catalog URL'
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
    ElseIf ($PreviewOnly -eq $true -and $BuildOnly -eq $false) {
        # Preview Only
        ($Table | Where-Object { $_.Preview -eq "True" } | Select-Object -First $LatestReleases)
    }
    ElseIf ($PreviewOnly -eq $true -and $BuildOnly -eq $true) {
        # Preview Only - Build
        ($Table | Where-Object { $_.Preview -eq "True" } | Select-Object -First $LatestReleases)."Build"
    }
    ElseIf ($OutOfBandOnly -eq $true -and $BuildOnly -eq $false) {
        # Out-of-band Only
        ($Table | Where-Object { $_.'Out-of-band' -eq "True" } | Select-Object -First $LatestReleases)
    }
    ElseIf ($OutOfBandOnly -eq $true -and $BuildOnly -eq $true) {
        # Out-of-band Only - Build
        ($Table | Where-Object { $_.'Out-of-band' -eq "True" } | Select-Object -First $LatestReleases)."Build"
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
# SIG # Begin signature block
# MIImxgYJKoZIhvcNAQcCoIImtzCCJrMCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCBUJVEj7/tMd3Iz
# 9xayoUuxclvYChM4VAelu+AG3nME96CCIFYwggWNMIIEdaADAgECAhAOmxiO+dAt
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
# BgorBgEEAYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAvBgkqhkiG9w0BCQQxIgQgnfZN
# KqZAKsFvN/yA5VfJIYRGWebtdP18FP/9869ZAcwwDQYJKoZIhvcNAQEBBQAEggGA
# lze0ubOXCzf4K+woLW+WMzJQZfFI0By9WXwduwC0LnTIdmDEGQYCDfeCwgbD2q69
# ypJJzlI9yx6dxXc13gZcx/1VO1xRcSzoJ6KVt2KcYDRiIpD8Yc39I5ehJGopbaj0
# RBmdFGsXHQGtOHqk3sc8WF3yzjCLgJ8HrGG/hmFIdOOWb/XbsfsREfbdmClkLUZs
# W8XqdHMIYLEMdSKhcbd+xR+ZxKAEP332dv5EdcZMfUysHsjLt7wQD8RMaRjLB+9S
# fGzMmIUv43L0l15EBKkP1W7zeYqcwocigHc/KQtLVRd6jxf45YhimyJhNyutH5LJ
# pT/Lxa3Z3zZAB6lVBh493DBBUsAE43Qz2X5w8WV49DWjqNi39JoeMa8y0z1czG30
# oZBCZMhkZhvY5wj/AV52aagbsL6D50197B0IfTavnpRsgvuDu2ntkUff/5hI85XM
# SaIn/P31whLv3MbmmjjqPpt2YjKo94Xt7brLTP2vKn+kFByDhNPDTVtSHNfwlhgA
# oYIDJjCCAyIGCSqGSIb3DQEJBjGCAxMwggMPAgEBMH0waTELMAkGA1UEBhMCVVMx
# FzAVBgNVBAoTDkRpZ2lDZXJ0LCBJbmMuMUEwPwYDVQQDEzhEaWdpQ2VydCBUcnVz
# dGVkIEc0IFRpbWVTdGFtcGluZyBSU0E0MDk2IFNIQTI1NiAyMDI1IENBMQIQCoDv
# GEuN8QWC0cR2p5V0aDANBglghkgBZQMEAgEFAKBpMBgGCSqGSIb3DQEJAzELBgkq
# hkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTI2MDQzMDE5MDc1NlowLwYJKoZIhvcN
# AQkEMSIEIJVtPFjTvzT9GcycWhTh7aB8cRfFtbCHK6Y4ER2USrMxMA0GCSqGSIb3
# DQEBAQUABIICAH3QtyVpSBeKuntebgDeRW741c0EaGHkD5tKj5EwMrNfl6W43ynF
# +i9Lx3uqVjaIZuPsBt8gk+ceC1NMszn5RGTbCLfTEvqIQ6OAw9OXELykUBsdjwDu
# zxNYcJp7RJztdFOORF5LcUV8vGIdSIhSThJk6/PTrfj3XEVO2G5XnW0AfwGIBEmz
# 1htCb0k8R8ZupYWROxfq8yyC0iFeIJlYWEdCFD9BeqqYLwiK8YCP4oOHVG5reZ/s
# gpa9tepf0+1WNOR9StXcxyfzqSlelwcAW0dGETecj7faSPA5Cfit85mAkqONU+TU
# 0End+3y4Ukpy3Fa25lVOuw0r2VSKAhIj27MDhv4WmGW9Y7FH4CyKgL1Dukh+6Sid
# DNEqwP1xjlKJZb3EU6VbgYHBUhAMlEg58Ng1LP0ExCvR22quUyZGZk46YE6sJiwF
# BJO3lkBDIzTpLKVuohbloxun5WVV2VJjHtF6GfUpwYoTHeoypdGM+3YNwoMjw/QN
# 2OBLRXnm1dGfrvlDKmp97EYOyoP1WzQnG4eM+Vzh4bsNqvJSyU/ffa2flC/lOnJS
# lOFP5CW5dvm4wVq4/83rBRqa8Bgn8zXywrOeIZDm1qEy/cu0/hoDUhwm/50NWZGk
# rNGuFgStzxb6lwza0WXtb57l90J4qxeE26ga0OM7TPmzlFzXX2llQzJ/
# SIG # End signature block
