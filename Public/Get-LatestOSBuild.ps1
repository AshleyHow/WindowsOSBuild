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
            CB/CBB/SAC (Semi-Annual Channel)           - 1507, 1511, 1607, 1703, 1709, 1803, 1809, 1903, 1909, 2004, 20H2, 21H2, 22H2, 23H2, 24H2.
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
        .EXAMPLE
            Get-LatestOSBuild -OSName Win10 -OSVersion 22H2
            Show all information on the latest available OS build for Windows 10 Version 22H2 in list format.
        .EXAMPLE
            Get-LatestOSBuild -OSName Win10 -OSVersion 22H2 -LatestReleases 2
            Show all information on the latest 2 releases of OS builds for Windows 10 Version 22H2 in list format.
        .EXAMPLE
            Get-LatestOSBuild -OSName Win10 -OSVersion 22H2 -ExcludePreview -LatestReleases 2
            Show all information on the latest 2 releases excluding preview of OS builds for Windows 10 Version 22H2 in list format.
        .EXAMPLE
            Get-LatestOSBuild -OSName Win10 -OSVersion 22H2 -ExcludeOutOfBand -LatestReleases 2
            Show all information on the latest 2 releases excluding out-of-band of OS builds for Windows 10 Version 22H2 in list format.
        .EXAMPLE
            Get-LatestOSBuild -OSName Win10 -OSVersion 22H2 -PreviewOnly -LatestReleases 2
            Show all information on the latest 2 preview releases of OS builds for Windows 10 Version 22H2 in list format.
        .EXAMPLE
            Get-LatestOSBuild -OSName Win10 -OSVersion 22H2 -OutOfBandOnly -LatestReleases 2
            Show all information on the latest 2 out-of-band releases of OS builds for Windows 10 Version 22H2 in list format.
        .EXAMPLE
            Get-LatestOSBuild -OSName Win10 -OSVersion 22H2 -BuildOnly
            Show only the latest available OS build for Windows 10 Version 22H2 in list format.
        .EXAMPLE
            Get-LatestOSBuild -OSName Win10 -OSVersion 22H2 -PreviewOnly -BuildOnly
            Show only the latest available preview OS build for Windows 10 Version 22H2 in list format.
        .EXAMPLE
            Get-LatestOSBuild -OSName Win10 -OSVersion 22H2 -OutOfBandOnly -BuildOnly
            Show only the latest available out-of-band OS build for for Windows 10 Version 22H2 in list format.
        .EXAMPLE
            Get-LatestOSBuild -OSName Win10 -OSVersion 22H2 | ConvertTo-Json
            Show all information on the latest available OS build for Windows 10 Version 22H2 in json format.
        .EXAMPLE
            Get-LatestOSBuild -OSName Win10 -OSVersion 22H2 | ConvertTo-Json | Out-File .\Get-LatestOSBuild.json
            Save the json format to a file on the latest available OS build for Windows 10 Version 22H2.

        .NOTES
            Forked from 'Get-Windows10ReleaseInformation.ps1' created by Fredrik Wall.
            https://github.com/FredrikWall/PowerShell/blob/master/Windows/Get-Windows10ReleaseInformation.ps1
            Uses code adapted from 'Get-CurrentPatchInfo.ps1' created by Trevor Jones.
            https://gist.githubusercontent.com/SMSAgentSoftware/79fb091a4b7806378fc0daa826dbfb47/raw/0f6b52cddf82b2aa836a813cf6bc910a52a48c9f/Get-CurrentPatchInfo.ps1
    #>

        Param(
        [CmdletBinding()]
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
        [Switch]$OutOfBandOnly
    )

    # Disable progress bar to speed up Invoke-WebRequest calls
    $ProgressPreference = 'SilentlyContinue'

    # Enforce TLS 1.2
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

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
    ElseIf ($OSName -eq "Win11HotPatch") {
        $URL = "https://support.microsoft.com/en-us/topic/release-notes-for-hotpatch-public-preview-on-windows-11-version-24h2-enterprise-clients-c117ee02-fd35-4612-8ea9-949c5d0ba6d1"
        $AtomFeedUrl = "https://support.microsoft.com/en-us/feed/atom/4ec863cc-2ecd-e187-6cb3-b50c6545db92"
        $CategoryName = "Windows 11, version 24H2 Enterprise clients"
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
    ElseIf ($OSName -eq "Server2025" -or $OSName -eq "Server2025Hotpatch" -or $OSName -eq "Win11HotPatch") {
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
        return $categorizedLinks | Where-Object { $_.Title -notlike "*$CategoryName*" }
    }

    # Obtain data from webpage
    Try {
        If ($OSName -eq "Server2022" -or $OSName -eq "Server2025") {
            $Webpage = Invoke-WebRequest -Uri $URL -UseBasicParsing -ErrorAction Stop
        }
        # Supports Server 2022 Hotpatch
        Else {
            If ($OSName -eq "Win11Hotpatch" -or $OSName -eq "Server2022Hotpatch" -or $OSName -eq "Server2025Hotpatch") {
                $Webpage = Invoke-WebRequest -Uri $URL -UseBasicParsing -ErrorAction Stop
            }
            Else {
                # All other OS
                $Webpage = Invoke-RestMethod -Uri $URL -UseBasicParsing -ErrorAction Stop
            }

            # Fetch the Atom feed content, used to obtain preview and out-of-band data
            If ($AtomFeedUrl -ne "N/A") {
                $response = Invoke-WebRequest -Uri $AtomFeedUrl -Method Get -UseBasicParsing -ErrorAction Stop

                # Extract raw content from the response
                $feedContent = $response.Content

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
                        $ResultObject["Version"] = "Version $OSVersion (OS build 26100)"
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
                        $ResultObject["Availability date"] = "N/A"
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
                    $ResultObject["KB source article"] = [regex]::Match($SourceOSBuild, 'KB\d{7}').Value
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
        $HTML = (New-Object HtmlAgilityPack.HtmlWeb).Load($URL)

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
# MIImoQYJKoZIhvcNAQcCoIImkjCCJo4CAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUEDgBFqxt4hZmH63GL4gfyPFc
# do2ggiBWMIIFjTCCBHWgAwIBAgIQDpsYjvnQLefv21DiCEAYWjANBgkqhkiG9w0B
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
# AgEVMCMGCSqGSIb3DQEJBDEWBBQR1NNHyW93KK4UJ+Fbfi2j5OGvCzANBgkqhkiG
# 9w0BAQEFAASCAYCLQ8G4ayafU0WX3hY61ydryMiF+4wnEVZABr6X0QrXlPr2xwIl
# XyB8ld6sW5aQ8Wyk4r8oIsk2q8U1j4nvglu6OeXQfY8YaGk6FyOKDL+4mm4zCFqk
# t34dkIlTKM+cwjCYuYGbETVhfF6a37WHH6NtNEu8PAsHTwz7ILwAWpsExf56y2+F
# gHxbW8J7M1Ej8Hhm4oqSfVW3AaMdcS4Mgvxh4mVO63f4N/fOudeACaxd9mbHanpI
# uD30UENHfpZsapVQ53FHCEGs80D16EYeijBCzSzxOO3eGs3WWklZxnv7ySSLyM/y
# bzDMrxSZDRBVgpvlIgO1T/50lTPDxpo9YJtLvviqSuKeGBiwA350y2pESaZc//sy
# yGP4vuqcqVIxLl+rlYWlzgNzPBFo3Yn8qQSQwMDqoGeiFkf7Z7RMUeuv/fge3uRB
# Pd3GQmSkrscN3zFR6R+dXfzYDhZw1/ck1pAUop/mFreT8DQlUKoxdSLOUjC4OQLy
# GKJbZK/EOoiqJmKhggMmMIIDIgYJKoZIhvcNAQkGMYIDEzCCAw8CAQEwfTBpMQsw
# CQYDVQQGEwJVUzEXMBUGA1UEChMORGlnaUNlcnQsIEluYy4xQTA/BgNVBAMTOERp
# Z2lDZXJ0IFRydXN0ZWQgRzQgVGltZVN0YW1waW5nIFJTQTQwOTYgU0hBMjU2IDIw
# MjUgQ0ExAhAKgO8YS43xBYLRxHanlXRoMA0GCWCGSAFlAwQCAQUAoGkwGAYJKoZI
# hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMjUwNzE3MTkwODIy
# WjAvBgkqhkiG9w0BCQQxIgQgOu1tGRaC/6gcHJK8v4/oGSOwMyAVYpTleQb1YlkC
# ya0wDQYJKoZIhvcNAQEBBQAEggIAM1sg/qW6R+G+M/1rVXWQMemGSLxkLHrog+xG
# waYi7EjHtk1tPIUgcid98rOCSkVV/DB70vyznDbSm35W1Uy97nCsujGuaKKpXcJ1
# mZSLOEHSDBKViMr/OKBamncQVo8zerrw2T+zn0KTJn0Ewmq20x+5rOmZxXuRcUL4
# tJD0Cv+9pRvesnR9osUgnYinjtfTBQ47zd0CbumP852GE7quXbynzgk52s5fal3+
# KOCN6nDUrUvHAiTVH2fuLegKmkhHNCE5+NVk5ljLyyJCcS1u18WUmx8y1M+ZAekv
# NsWflV3POgJa2CYZVbXcXb70vZ1d6GVzv8AMMRLj7dmaYnvtQ7r2UDvS4ATNZ5Fz
# c7BblBpIIQE1DF+bZZo2Y/3fxSadJZfUiFWUgVJPp0FRzS0EO0MuAxZ8RlavRhWA
# 7R5o3CbpqXjKA8xXotebNJupeoVxiMvsaB9kD2q4NNmhrldCF4Bt+kl7FSintRz1
# kzbv3owf/wYKPOj1DyEbjnzE3+gmSf5HvfDnADr8xTYnamdn3esZHzxBUqEVCTbZ
# vDikLxxZ2eWfZtDmmB4Rn/uHQ618dI0Zs2SrKzMqNTHQkHJuV33LPn/utlqMvghi
# jgrjrVyIRspd2nJEboiPeFfpphxnRdpI3PS6XoBdgDMitgWGaIdiXoWZ54KEbNzq
# USO8Fok=
# SIG # End signature block
