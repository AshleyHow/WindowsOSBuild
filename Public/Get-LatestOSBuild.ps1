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
                        $link      = $AtomMatch.Groups[5].Value

                        # Filter out entries that do not contain "OS" in the title
                        If ($title -like '*OS*') {
                            # Create a hashtable for the entry
                            $feedEntry = @{
                                Title     = $title
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
                $GetDate = [regex]::Match($Update.Update,"(Jan(uary)?|Feb(ruary)?|Mar(ch)?|Apr(il)?|May|Jun(e)?|Jul(y)?|Aug(ust)?|Sep(tember)?|Oct(ober)?|Nov(ember)?|Dec(ember)?)\s+\d{1,2},\s+\d{4}").Value
                Try {
                    $ConvertToDate = [Datetime]::ParseExact($GetDate, 'MMMM dd, yyyy', [Globalization.CultureInfo]::CreateSpecificCulture('en-US'))
                }
                Catch {
                    $ConvertToDate = [Datetime]::ParseExact($GetDate, 'MMMM d, yyyy', [Globalization.CultureInfo]::CreateSpecificCulture('en-US'))
                }
                $FormatDate =  Get-Date($ConvertToDate) -Format 'yyyy-MM-dd'
                $ResultObject["Availability date"] = $FormatDate
                If ($OSName -eq "Win11Hotpatch" -or $OSName -eq "Server2022Hotpatch" -or $OSName -eq "Server2025Hotpatch") {
                    If ($Update.Update -match 'Baseline') {
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
                If (($OSName -eq "Win11Hotpatch" -or $OSName -eq "Server2022Hotpatch" -or $OSName -eq "Server2025Hotpatch") -and ($ResultObject.Hotpatch -eq "False")) {
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
        $GetVersions = @($HTML.DocumentNode.SelectNodes("//strong"))
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
        $SearchTable = ($TableMapping | Where-Object { $_.Version -like "Version $OSVersion*(OS build*)" }).TableNumber

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