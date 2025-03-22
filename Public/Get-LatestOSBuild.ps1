Function Get-LatestOSBuild {
    <#
        .SYNOPSIS
            Gets Windows patch release information (Version, Build, Availability date, Hotpatch, Preview, Out-of-band, Servicing option, KB article, KB URL and Catalog URL) for Windows client and server versions.
            Useful for scripting and automation purposes. Supports Windows 10 and Windows Server 2016 onwards. Supports Hotpatch on Windows Server 2022 Azure Edition.
        .DESCRIPTION
            Patch information retrieved from Microsoft Release Health / Update History (Server 2022 and above) pages and outputted in a usable format.
            These sources are updated regularly by Microsoft AFTER new patches are released. This means at times this info may not always be in sync with Windows Update.
        .PARAMETER OSName
            This parameter is optional. OS name you want to check. Default value is Win10. Accepted values:

            Windows Client OS Names                              - Win10, Win11.
            Windows Server OS Names                              - Server2016, Server2019, Server2022, Server2022Hotpatch, Server Semi-annual = ServerSAC.
        .PARAMETER OSVersion
            This parameter is mandatory. OS version number you want to check. Accepted values:

            Windows Client OS Versions:
            CB/CBB/SAC (Semi-Annual Channel)                     - 1507, 1511, 1607, 1703, 1709, 1803, 1809, 1903, 1909, 2004, 20H2, 21H2, 22H2, 23H2, 24H2.
            Win 10 LTSB/LTSC (Long-Term Servicing Build/Channel) - 2015 = 1507, 2016 = 1607, 2019 = 1809, 2021 = 21H2.
            Win 11 LTSC (Long-Term Servicing Channel)            - 2024 = 24H2.

            Window Server OS Versions:
            SAC (Semi-Annual Channel)                            - 1709, 1803, 1809, 1903, 1909, 2004, 20H2.
            LTSB/LTSC (Long-Term Servicing Build/Channel)        - Server 2016 = 1607, Server 2019 = 1809, Server 2022 = 21H2.
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
        [ValidateSet('Win10','Win11','Server2016','Server2019','Server2022','Server2022Hotpatch','Server2025','Server2025Hotpatch','ServerSAC')]
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
    ElseIf ($OSName -eq "Server2022" -or $OSName -eq "Server2022Hotpatch") {
        # Disabled automatic detection of hotfix as it is not a reliable method of guaranteeing devices are applying hotpatch updates, non-hotpatch updates can still be applied.
        # $HotpatchOS = Get-HotFix -Id KB5003508 -ErrorAction SilentlyContinue
        if ($OSName -eq "Server2022Hotpatch") {
            $URL = "https://support.microsoft.com/en-us/topic/release-notes-for-hotpatch-in-azure-automanage-for-windows-server-2022-4e234525-5bd5-4171-9886-b475dabe0ce8"
            $AtomFeedUrl = "https://support.microsoft.com/en-us/feed/atom/2d67e9fb-2bd2-6742-08ee-628da707657f"
            $CategoryName = "Release notes for Hotpatch in Azure Automanage for Windows Server 2022"
        }
        Else {
            $URL = "https://support.microsoft.com/en-us/help/5005454"
            $CategoryName = "Windows Server 2022"
        }
    }
    ElseIf ($OSName -eq "Server2025" -or $OSName -eq "Server2025Hotpatch") {
        # Disabled automatic detection of hotfix as it is not a reliable method of guaranteeing devices are applying hotpatch updates, non-hotpatch updates can still be applied.
        # $HotpatchOS = Get-HotFix -Id KB5003508 -ErrorAction SilentlyContinue
        if ($OSName -eq "Server2025Hotpatch") {
            $URL = "https://support.microsoft.com/en-us/topic/release-notes-for-hotpatch-on-windows-server-2025-datacenter-azure-edition-c548437e-8c7a-4e27-99f4-e8746f97f8fa"
            $AtomFeedUrl = "$null"
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
                InfoURL  = " https://support.microsoft.com/en-us/" + $item.Link
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
            if ($CategoryName -and $osName -ne $CategoryName) {
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
        return $categorizedLinks | Where-Object { $_.Title -ne $CategoryName }
    }

    # Obtain data from webpage
    Try {
        If ($OSName -eq "Server2022" -or $OSName -eq "Server2025") {
            $Webpage = Invoke-WebRequest -Uri $URL -UseBasicParsing -ErrorAction Stop
        }
        # Supports Server 2022 Hotpatch
        Else {
            If ($OSName -eq "Server2022Hotpatch" -or $OSName -eq "Server2025Hotpatch") {
                $Webpage = Invoke-WebRequest -Uri $URL -UseBasicParsing -ErrorAction Stop
            }
            Else {
                # All other OS
                $Webpage = Invoke-RestMethod -Uri $URL -UseBasicParsing -ErrorAction Stop
            }

            # Fetch the Atom feed content, used to obtain preview and out-of-band data
            If ($AtomFeedUrl) {
            $response = Invoke-WebRequest -Uri $AtomFeedUrl -Method Get -UseBasicParsing -ErrorAction Stop
            }

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

                    # Filter out entries that do not contain "(OS Build" in the title
                    If ($title -like '*(OS Build*') {
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
    Catch {
        If ($_.Exception.Message -like '*403*') {
            Throw "Get-LatestOSBuild: Unable to obtain patch release information. Akamai CDN denial-of-service protection active. Error: $($_.Exception.Message)"
        }
        Else {
            Throw "Get-LatestOSBuild: Unable to obtain patch release information. Please check your internet connectivity. Error: $($_.Exception.Message)"
        }
    }

    # Server 2022 and 2025
    If ($OSName -eq "Server2022" -or $OSName -eq "Server2025" -or $OSName -eq "Server2022Hotpatch" -or $OSName -eq "Server2025Hotpatch") {
        $Table = @()
        $Table =  @(
            $VersionDataRaw = $null
            $VersionDataRaw = Get-ReleaseNotes -Webpage $webpage -CategoryName $CategoryName | Sort-Object -Property Title -Unique
            $UniqueList =  (Convert-ParsedArray -Array $VersionDataRaw) | Sort-Object OSBuild -Descending
            ForEach ($Update in $UniqueList) {
                $ResultObject = [Ordered] @{}
                # Support for Hotpatch
                If ($null -eq $Update.OSBuild.Major) {
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
                If ($OSName -eq "Server2022Hotpatch" -or $OSName -eq "Server2025Hotpatch") {
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
                If (($OSName -eq "Server2022Hotpatch" -or $OSName -eq "Server2025Hotpatch") -and ($ResultObject.Hotpatch -eq "False")) {
                    $ResultObject["KB source article"] = [regex]::Match($SourceOSBuild, 'KB\d{7}').Value
                    $ResultObject["KB article"] = $Update.KB + " / " + $ResultObject.'KB source article'
                }
                Else {
                    $ResultObject["KB article"] = $Update.KB
                }
                If (($OSName -eq "Server2022Hotpatch" -or $OSName -eq "Server2025Hotpatch") -and ($ResultObject.Hotpatch -eq "False")) {
                    $ResultObject["KB URL"] = $Update.InfoURL
                    $ResultObject["KB source URL"] = "https://support.microsoft.com/help/en-us/" + $ResultObject.'KB source article'
                }
                Else {
                    $ResultObject["KB URL"] = "$Update.InfoURL"
                }
                If (($OSName -eq "Server2022Hotpatch" -or $OSName -eq "Server2025Hotpatch") -and ($ResultObject.Hotpatch -eq "True")) {
                    $ResultObject["Catalog URL"] =  "N/A"
                }
                Else {
                    $ResultObject["Catalog URL"] =  "https://www.catalog.update.microsoft.com/Search.aspx?q=" + $ResultObject.'KB article'
                }
                # Cast hash table to a PSCustomObject
                If ($OSName -eq "Server2022Hotpatch" -or $OSName -eq "Server2025Hotpatch") {
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

        # Include build information for Server 2022 RTM not included in Windows Update History
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
        If ($OSName -eq "Server2022Hotpatch" -or $OSName -eq "Server2025Hotpatch") {
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
        $SearchVersion = ($TableMapping | Where-Object { $_.Version -like "Version $OSVersion*(OS build*)" }).Version
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
                        $KBURL = "https://support.microsoft.com/help/en-us" + ($ResultObject."KB article").Trim("KB")
                        $ResultObject["KB URL"] = $KBURL
                        $ResultObject["Catalog URL"] =  "https://www.catalog.update.microsoft.com/Search.aspx?q=" + $ResultObject.'KB article'
                        If ($KBURL -ne " https://support.microsoft.com/en-us/help/") {
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
# MIImbAYJKoZIhvcNAQcCoIImXTCCJlkCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUmmZNvLLyMI2PV/Xth9TIYvli
# 4tuggiAnMIIFjTCCBHWgAwIBAgIQDpsYjvnQLefv21DiCEAYWjANBgkqhkiG9w0B
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
# aiNrIv8SuFQtJ37YOtnwtoeW/VvRXKwYw02fc7cBqZ9Xql4o4rmUMIIGYzCCBEug
# AwIBAgIQeAuTgzemd0ILREkKU+Yq2jANBgkqhkiG9w0BAQsFADBWMQswCQYDVQQG
# EwJQTDEhMB8GA1UEChMYQXNzZWNvIERhdGEgU3lzdGVtcyBTLkEuMSQwIgYDVQQD
# ExtDZXJ0dW0gQ29kZSBTaWduaW5nIDIwMjEgQ0EwHhcNMjQwNDExMDYwMzIxWhcN
# MjUwNDExMDYwMzIwWjCBiDELMAkGA1UEBhMCR0IxDzANBgNVBAgMBkRvcnNldDEU
# MBIGA1UEBwwLQk9VUk5FTU9VVEgxHjAcBgNVBAoMFU9wZW4gU291cmNlIERldmVs
# b3BlcjEyMDAGA1UEAwwpT3BlbiBTb3VyY2UgRGV2ZWxvcGVyLCBBU0hMRVkgTUlD
# SEFFTCBIT1cwggGiMA0GCSqGSIb3DQEBAQUAA4IBjwAwggGKAoIBgQDpmsgFPzl4
# 7W61kLLEp5ljxHC0ZZDti0+DL2JSAac1+bQW24vSjg4ABHhRB5CDKBuwVe2h0l+G
# mEZHhKc9cz/RB+hUIJycd5Qx6VzsI1KJ0heEECm+oo3rywyqrd9RovkhkU2X29cR
# UAa9SWZJJ2+/ImyzfyxzR+u0DD17BucHXWylQB2HGFCcX3kYUmgyZ/ANrgTvetW+
# n91OLxquC5+Nslh4MhbQAnItX79qrFLODd05S3SpQvdti16WGcRwXka4t5zdAMf6
# v3c8ThHKPm/1TsyWsYAUMYJ9C0sNt+QYKNYHRX7DuA1OJBngAyGggtaXmqEpPBX2
# SkDJ0uOeVDoJEOsxNydGZYPgvkIzsyF8YmEzkPK5x5elglYI0wfGwaMKshVbszj5
# KXIPogeF/0vrEi8iIEd+Ro3ZY8ul+TliYf6P55tl3VCuKHDbzcYCtOXURmAPGwxC
# 9wVvTr946eJr+emejOxg4/BZw5Q5GD6Qr8wwyodqholbzp8bfjTFmC8CAwEAAaOC
# AXgwggF0MAwGA1UdEwEB/wQCMAAwPQYDVR0fBDYwNDAyoDCgLoYsaHR0cDovL2Nj
# c2NhMjAyMS5jcmwuY2VydHVtLnBsL2Njc2NhMjAyMS5jcmwwcwYIKwYBBQUHAQEE
# ZzBlMCwGCCsGAQUFBzABhiBodHRwOi8vY2NzY2EyMDIxLm9jc3AtY2VydHVtLmNv
# bTA1BggrBgEFBQcwAoYpaHR0cDovL3JlcG9zaXRvcnkuY2VydHVtLnBsL2Njc2Nh
# MjAyMS5jZXIwHwYDVR0jBBgwFoAU3XRdTADbe5+gdMqxbvc8wDLAcM0wHQYDVR0O
# BBYEFB7BnDzi+HIrft6IpueXUsx5LcgwMEsGA1UdIAREMEIwCAYGZ4EMAQQBMDYG
# CyqEaAGG9ncCBQEEMCcwJQYIKwYBBQUHAgEWGWh0dHBzOi8vd3d3LmNlcnR1bS5w
# bC9DUFMwEwYDVR0lBAwwCgYIKwYBBQUHAwMwDgYDVR0PAQH/BAQDAgeAMA0GCSqG
# SIb3DQEBCwUAA4ICAQBO5qPmZq+cztnjKtz9DyVBkZGaHj/TmfIZHrYfeQ0zdEVL
# EszgokLuqNDdk0odEUHiockPB2dQn60oE3rNs+Wb1ZLLT18VoQTV0saMD3GiNzil
# ejD4nIrhQ+vt0auxCvzBS8cQd24ePmjTqcIkL/u07xGhtT3LpUHUuHknUcEFjgs0
# bUpGR5bofW8B9ZSC31g2i5PKZH8PUgOrTvg8oaMQYWyduKFnW8JRRGqypjUIFDE0
# N224ox/U6GqqIl2cuC87H7WrHPEO6VjqSOx0PgybhSggGDKRNk9UQN1R45K/NCcw
# 5+sIA1pjTZHnMhIJdxamhXiNq2S0U3LRVLSs1/BuXGENFWUraE4c51kDCiBPpGus
# olI7/LLF3PIyYopyAWOGw0R7snlT+HJbfI7P6ObfYzzmIMdrKSaBkNtautcRYcIT
# HAmbUAVplnpexQXXapSqxUfrPXWZk7xRLSXXqn915NbAoofVrTuLNXbv437KmoaN
# p2J23oE7KzqdkoZ9SO4+8K+XKoEqBrPyxNB/i5UIId1Rsu5GE453usJf7zgsz4Ib
# T8MQXjPq0WageEH3cL3qoPGBVbD++hLCJhqHPFJfM3zqxz4xZIRm7dY7GmcVc3Qq
# H0biPnYkTfe8fwrT/IpEmVPdDnUSM92MhV25HV4CYU5LAISU1B070DMFAGc1uTCC
# Bq4wggSWoAMCAQICEAc2N7ckVHzYR6z9KGYqXlswDQYJKoZIhvcNAQELBQAwYjEL
# MAkGA1UEBhMCVVMxFTATBgNVBAoTDERpZ2lDZXJ0IEluYzEZMBcGA1UECxMQd3d3
# LmRpZ2ljZXJ0LmNvbTEhMB8GA1UEAxMYRGlnaUNlcnQgVHJ1c3RlZCBSb290IEc0
# MB4XDTIyMDMyMzAwMDAwMFoXDTM3MDMyMjIzNTk1OVowYzELMAkGA1UEBhMCVVMx
# FzAVBgNVBAoTDkRpZ2lDZXJ0LCBJbmMuMTswOQYDVQQDEzJEaWdpQ2VydCBUcnVz
# dGVkIEc0IFJTQTQwOTYgU0hBMjU2IFRpbWVTdGFtcGluZyBDQTCCAiIwDQYJKoZI
# hvcNAQEBBQADggIPADCCAgoCggIBAMaGNQZJs8E9cklRVcclA8TykTepl1Gh1tKD
# 0Z5Mom2gsMyD+Vr2EaFEFUJfpIjzaPp985yJC3+dH54PMx9QEwsmc5Zt+FeoAn39
# Q7SE2hHxc7Gz7iuAhIoiGN/r2j3EF3+rGSs+QtxnjupRPfDWVtTnKC3r07G1decf
# BmWNlCnT2exp39mQh0YAe9tEQYncfGpXevA3eZ9drMvohGS0UvJ2R/dhgxndX7RU
# CyFobjchu0CsX7LeSn3O9TkSZ+8OpWNs5KbFHc02DVzV5huowWR0QKfAcsW6Th+x
# tVhNef7Xj3OTrCw54qVI1vCwMROpVymWJy71h6aPTnYVVSZwmCZ/oBpHIEPjQ2OA
# e3VuJyWQmDo4EbP29p7mO1vsgd4iFNmCKseSv6De4z6ic/rnH1pslPJSlRErWHRA
# KKtzQ87fSqEcazjFKfPKqpZzQmiftkaznTqj1QPgv/CiPMpC3BhIfxQ0z9JMq++b
# Pf4OuGQq+nUoJEHtQr8FnGZJUlD0UfM2SU2LINIsVzV5K6jzRWC8I41Y99xh3pP+
# OcD5sjClTNfpmEpYPtMDiP6zj9NeS3YSUZPJjAw7W4oiqMEmCPkUEBIDfV8ju2Tj
# Y+Cm4T72wnSyPx4JduyrXUZ14mCjWAkBKAAOhFTuzuldyF4wEr1GnrXTdrnSDmuZ
# DNIztM2xAgMBAAGjggFdMIIBWTASBgNVHRMBAf8ECDAGAQH/AgEAMB0GA1UdDgQW
# BBS6FtltTYUvcyl2mi91jGogj57IbzAfBgNVHSMEGDAWgBTs1+OC0nFdZEzfLmc/
# 57qYrhwPTzAOBgNVHQ8BAf8EBAMCAYYwEwYDVR0lBAwwCgYIKwYBBQUHAwgwdwYI
# KwYBBQUHAQEEazBpMCQGCCsGAQUFBzABhhhodHRwOi8vb2NzcC5kaWdpY2VydC5j
# b20wQQYIKwYBBQUHMAKGNWh0dHA6Ly9jYWNlcnRzLmRpZ2ljZXJ0LmNvbS9EaWdp
# Q2VydFRydXN0ZWRSb290RzQuY3J0MEMGA1UdHwQ8MDowOKA2oDSGMmh0dHA6Ly9j
# cmwzLmRpZ2ljZXJ0LmNvbS9EaWdpQ2VydFRydXN0ZWRSb290RzQuY3JsMCAGA1Ud
# IAQZMBcwCAYGZ4EMAQQCMAsGCWCGSAGG/WwHATANBgkqhkiG9w0BAQsFAAOCAgEA
# fVmOwJO2b5ipRCIBfmbW2CFC4bAYLhBNE88wU86/GPvHUF3iSyn7cIoNqilp/GnB
# zx0H6T5gyNgL5Vxb122H+oQgJTQxZ822EpZvxFBMYh0MCIKoFr2pVs8Vc40BIiXO
# lWk/R3f7cnQU1/+rT4osequFzUNf7WC2qk+RZp4snuCKrOX9jLxkJodskr2dfNBw
# CnzvqLx1T7pa96kQsl3p/yhUifDVinF2ZdrM8HKjI/rAJ4JErpknG6skHibBt94q
# 6/aesXmZgaNWhqsKRcnfxI2g55j7+6adcq/Ex8HBanHZxhOACcS2n82HhyS7T6NJ
# uXdmkfFynOlLAlKnN36TU6w7HQhJD5TNOXrd/yVjmScsPT9rp/Fmw0HNT7ZAmyEh
# QNC3EyTN3B14OuSereU0cZLXJmvkOHOrpgFPvT87eK1MrfvElXvtCl8zOYdBeHo4
# 6Zzh3SP9HSjTx/no8Zhf+yvYfvJGnXUsHicsJttvFXseGYs2uJPU5vIXmVnKcPA3
# v5gA3yAWTyf7YGcWoWa63VXAOimGsJigK+2VQbc61RWYMbRiCQ8KvYHZE/6/pNHz
# V9m8BPqC3jLfBInwAM1dwvnQI38AC+R2AibZ8GV2QqYphwlHK+Z/GqSFD/yYlvZV
# VCsfgPrA8g4r5db7qS9EFUrnEw4d2zc4GqEr9u3WfPwwgga5MIIEoaADAgECAhEA
# maOACiZVO2Wr3G6EprPqOTANBgkqhkiG9w0BAQwFADCBgDELMAkGA1UEBhMCUEwx
# IjAgBgNVBAoTGVVuaXpldG8gVGVjaG5vbG9naWVzIFMuQS4xJzAlBgNVBAsTHkNl
# cnR1bSBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eTEkMCIGA1UEAxMbQ2VydHVtIFRy
# dXN0ZWQgTmV0d29yayBDQSAyMB4XDTIxMDUxOTA1MzIxOFoXDTM2MDUxODA1MzIx
# OFowVjELMAkGA1UEBhMCUEwxITAfBgNVBAoTGEFzc2VjbyBEYXRhIFN5c3RlbXMg
# Uy5BLjEkMCIGA1UEAxMbQ2VydHVtIENvZGUgU2lnbmluZyAyMDIxIENBMIICIjAN
# BgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAnSPPBDAjO8FGLOczcz5jXXp1ur5c
# Tbq96y34vuTmflN4mSAfgLKTvggv24/rWiVGzGxT9YEASVMw1Aj8ewTS4IndU8s7
# VS5+djSoMcbvIKck6+hI1shsylP4JyLvmxwLHtSworV9wmjhNd627h27a8RdrT1P
# H9ud0IF+njvMk2xqbNTIPsnWtw3E7DmDoUmDQiYi/ucJ42fcHqBkbbxYDB7SYOou
# u9Tj1yHIohzuC8KNqfcYf7Z4/iZgkBJ+UFNDcc6zokZ2uJIxWgPWXMEmhu1gMXgv
# 8aGUsRdaCtVD2bSlbfsq7BiqljjaCun+RJgTgFRCtsuAEw0pG9+FA+yQN9n/kZtM
# LK+Wo837Q4QOZgYqVWQ4x6cM7/G0yswg1ElLlJj6NYKLw9EcBXE7TF3HybZtYvj9
# lDV2nT8mFSkcSkAExzd4prHwYjUXTeZIlVXqj+eaYqoMTpMrfh5MCAOIG5knN4Q/
# JHuurfTI5XDYO962WZayx7ACFf5ydJpoEowSP07YaBiQ8nXpDkNrUA9g7qf/rCkK
# bWpQ5boufUnq1UiYPIAHlezf4muJqxqIns/kqld6JVX8cixbd6PzkDpwZo4SlADa
# Ci2JSplKShBSND36E/ENVv8urPS0yOnpG4tIoBGxVCARPCg1BnyMJ4rBJAcOSnAW
# d18Jx5n858JSqPECAwEAAaOCAVUwggFRMA8GA1UdEwEB/wQFMAMBAf8wHQYDVR0O
# BBYEFN10XUwA23ufoHTKsW73PMAywHDNMB8GA1UdIwQYMBaAFLahVDkCw6A/joq8
# +tT4HKbROg79MA4GA1UdDwEB/wQEAwIBBjATBgNVHSUEDDAKBggrBgEFBQcDAzAw
# BgNVHR8EKTAnMCWgI6Ahhh9odHRwOi8vY3JsLmNlcnR1bS5wbC9jdG5jYTIuY3Js
# MGwGCCsGAQUFBwEBBGAwXjAoBggrBgEFBQcwAYYcaHR0cDovL3N1YmNhLm9jc3At
# Y2VydHVtLmNvbTAyBggrBgEFBQcwAoYmaHR0cDovL3JlcG9zaXRvcnkuY2VydHVt
# LnBsL2N0bmNhMi5jZXIwOQYDVR0gBDIwMDAuBgRVHSAAMCYwJAYIKwYBBQUHAgEW
# GGh0dHA6Ly93d3cuY2VydHVtLnBsL0NQUzANBgkqhkiG9w0BAQwFAAOCAgEAdYhY
# D+WPUCiaU58Q7EP89DttyZqGYn2XRDhJkL6P+/T0IPZyxfxiXumYlARMgwRzLRUS
# tJl490L94C9LGF3vjzzH8Jq3iR74BRlkO18J3zIdmCKQa5LyZ48IfICJTZVJeChD
# UyuQy6rGDxLUUAsO0eqeLNhLVsgw6/zOfImNlARKn1FP7o0fTbj8ipNGxHBIutiR
# sWrhWM2f8pXdd3x2mbJCKKtl2s42g9KUJHEIiLni9ByoqIUul4GblLQigO0ugh7b
# WRLDm0CdY9rNLqyA3ahe8WlxVWkxyrQLjH8ItI17RdySaYayX3PhRSC4Am1/7mAT
# wZWwSD+B7eMcZNhpn8zJ+6MTyE6YoEBSRVrs0zFFIHUR08Wk0ikSf+lIe5Iv6RY3
# /bFAEloMU+vUBfSouCReZwSLo8WdrDlPXtR0gicDnytO7eZ5827NS2x7gCBibESY
# kOh1/w1tVxTpV2Na3PR7nxYVlPu1JPoRZCbH86gc96UTvuWiOruWmyOEMLOGGniR
# +x+zPF/2DaGgK2W1eEJfo2qyrBNPvF7wuAyQfiFXLwvWHamoYtPZo0LHuH8X3n9C
# +xN4YaNjt2ywzOr+tKyEVAotnyU9vyEVOaIYMk3IeBrmFnn0gbKeTTyYeEEUz/Qw
# t4HOUBCrW602NCmvO1nm+/80nLy5r0AZvCQxaQ4wgga8MIIEpKADAgECAhALrma8
# Wrp/lYfG+ekE4zMEMA0GCSqGSIb3DQEBCwUAMGMxCzAJBgNVBAYTAlVTMRcwFQYD
# VQQKEw5EaWdpQ2VydCwgSW5jLjE7MDkGA1UEAxMyRGlnaUNlcnQgVHJ1c3RlZCBH
# NCBSU0E0MDk2IFNIQTI1NiBUaW1lU3RhbXBpbmcgQ0EwHhcNMjQwOTI2MDAwMDAw
# WhcNMzUxMTI1MjM1OTU5WjBCMQswCQYDVQQGEwJVUzERMA8GA1UEChMIRGlnaUNl
# cnQxIDAeBgNVBAMTF0RpZ2lDZXJ0IFRpbWVzdGFtcCAyMDI0MIICIjANBgkqhkiG
# 9w0BAQEFAAOCAg8AMIICCgKCAgEAvmpzn/aVIauWMLpbbeZZo7Xo/ZEfGMSIO2qZ
# 46XB/QowIEMSvgjEdEZ3v4vrrTHleW1JWGErrjOL0J4L0HqVR1czSzvUQ5xF7z4I
# Qmn7dHY7yijvoQ7ujm0u6yXF2v1CrzZopykD07/9fpAT4BxpT9vJoJqAsP8YuhRv
# flJ9YeHjes4fduksTHulntq9WelRWY++TFPxzZrbILRYynyEy7rS1lHQKFpXvo2G
# ePfsMRhNf1F41nyEg5h7iOXv+vjX0K8RhUisfqw3TTLHj1uhS66YX2LZPxS4oaf3
# 3rp9HlfqSBePejlYeEdU740GKQM7SaVSH3TbBL8R6HwX9QVpGnXPlKdE4fBIn5BB
# FnV+KwPxRNUNK6lYk2y1WSKour4hJN0SMkoaNV8hyyADiX1xuTxKaXN12HgR+8Wu
# lU2d6zhzXomJ2PleI9V2yfmfXSPGYanGgxzqI+ShoOGLomMd3mJt92nm7Mheng/T
# BeSA2z4I78JpwGpTRHiT7yHqBiV2ngUIyCtd0pZ8zg3S7bk4QC4RrcnKJ3FbjyPA
# GogmoiZ33c1HG93Vp6lJ415ERcC7bFQMRbxqrMVANiav1k425zYyFMyLNyE1QulQ
# SgDpW9rtvVcIH7WvG9sqYup9j8z9J1XqbBZPJ5XLln8mS8wWmdDLnBHXgYly/p1D
# hoQo5fkCAwEAAaOCAYswggGHMA4GA1UdDwEB/wQEAwIHgDAMBgNVHRMBAf8EAjAA
# MBYGA1UdJQEB/wQMMAoGCCsGAQUFBwMIMCAGA1UdIAQZMBcwCAYGZ4EMAQQCMAsG
# CWCGSAGG/WwHATAfBgNVHSMEGDAWgBS6FtltTYUvcyl2mi91jGogj57IbzAdBgNV
# HQ4EFgQUn1csA3cOKBWQZqVjXu5Pkh92oFswWgYDVR0fBFMwUTBPoE2gS4ZJaHR0
# cDovL2NybDMuZGlnaWNlcnQuY29tL0RpZ2lDZXJ0VHJ1c3RlZEc0UlNBNDA5NlNI
# QTI1NlRpbWVTdGFtcGluZ0NBLmNybDCBkAYIKwYBBQUHAQEEgYMwgYAwJAYIKwYB
# BQUHMAGGGGh0dHA6Ly9vY3NwLmRpZ2ljZXJ0LmNvbTBYBggrBgEFBQcwAoZMaHR0
# cDovL2NhY2VydHMuZGlnaWNlcnQuY29tL0RpZ2lDZXJ0VHJ1c3RlZEc0UlNBNDA5
# NlNIQTI1NlRpbWVTdGFtcGluZ0NBLmNydDANBgkqhkiG9w0BAQsFAAOCAgEAPa0e
# H3aZW+M4hBJH2UOR9hHbm04IHdEoT8/T3HuBSyZeq3jSi5GXeWP7xCKhVireKCnC
# s+8GZl2uVYFvQe+pPTScVJeCZSsMo1JCoZN2mMew/L4tpqVNbSpWO9QGFwfMEy60
# HofN6V51sMLMXNTLfhVqs+e8haupWiArSozyAmGH/6oMQAh078qRh6wvJNU6gnh5
# OruCP1QUAvVSu4kqVOcJVozZR5RRb/zPd++PGE3qF1P3xWvYViUJLsxtvge/mzA7
# 5oBfFZSbdakHJe2BVDGIGVNVjOp8sNt70+kEoMF+T6tptMUNlehSR7vM+C13v9+9
# ZOUKzfRUAYSyyEmYtsnpltD/GWX8eM70ls1V6QG/ZOB6b6Yum1HvIiulqJ1Elesj
# 5TMHq8CWT/xrW7twipXTJ5/i5pkU5E16RSBAdOp12aw8IQhhA/vEbFkEiF2abhuF
# ixUDobZaA0VhqAsMHOmaT3XThZDNi5U2zHKhUs5uHHdG6BoQau75KiNbh0c+hatS
# F+02kULkftARjsyEpHKsF7u5zKRbt5oK5YGwFvgc4pEVUNytmB3BpIiowOIIuDgP
# 5M9WArHYSAR16gc0dP2XdkMEP5eBsX7bf/MGN4K3HP50v/01ZHo/Z5lGLvNwQ7XH
# Bx1yomzLP8lx4Q1zZKDyHcp4VQJLu2kWTsKsOqQxggWvMIIFqwIBATBqMFYxCzAJ
# BgNVBAYTAlBMMSEwHwYDVQQKExhBc3NlY28gRGF0YSBTeXN0ZW1zIFMuQS4xJDAi
# BgNVBAMTG0NlcnR1bSBDb2RlIFNpZ25pbmcgMjAyMSBDQQIQeAuTgzemd0ILREkK
# U+Yq2jAJBgUrDgMCGgUAoHgwGAYKKwYBBAGCNwIBDDEKMAigAoAAoQKAADAZBgkq
# hkiG9w0BCQMxDAYKKwYBBAGCNwIBBDAcBgorBgEEAYI3AgELMQ4wDAYKKwYBBAGC
# NwIBFTAjBgkqhkiG9w0BCQQxFgQU9E7qzcvLCkB6Qhcy+stjAtPYy24wDQYJKoZI
# hvcNAQEBBQAEggGAmCWTxVQpIEIFsRQBldrAYkI7GNenMzB49RG31n8yi3eaVYIr
# 1HVX+1fYDsV8FuBCOTGPF8b5mpGTD/y4QRWnp71yQ/sabZ9R6ZtPEewpVWORTXVE
# RwJmRYvJS7JqtRfkd5x9gw8v6zgM4tVMzZgRuMxDPO6SrhSGaatr8G7BYh6js/nn
# WAA/wQtb7M8X2RxjUvhyZK44EZ5ugsoaLL5Y+4GyK3469Y6JBW1YHoKofRaxYdMt
# /FZKUApdRP0ulVctdBuCx6A+tIasSOFgf7q6LDyh1voWu1StRvu6jAx9FH2I9URu
# FRslqBJMyK5Mb74GZ546ESAApjuIzILAwwoDnQ7324iZvA8xbF8rPnWPMdTLk/Eo
# JgnaSKckgJ+L0tzCrPloZQ14wJs5mNH00//fzv0RE3X3UxH9Cz53lyeQNm0cR3/t
# j4rMVPdwWdcToja/UZgJknEaFHgF2QB16CAKSbGpRuMOrs+hXsMQLNCGr4LKF/bv
# EQxrFa8CbMv2C/W6oYIDIDCCAxwGCSqGSIb3DQEJBjGCAw0wggMJAgEBMHcwYzEL
# MAkGA1UEBhMCVVMxFzAVBgNVBAoTDkRpZ2lDZXJ0LCBJbmMuMTswOQYDVQQDEzJE
# aWdpQ2VydCBUcnVzdGVkIEc0IFJTQTQwOTYgU0hBMjU2IFRpbWVTdGFtcGluZyBD
# QQIQC65mvFq6f5WHxvnpBOMzBDANBglghkgBZQMEAgEFAKBpMBgGCSqGSIb3DQEJ
# AzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTI1MDMyMjEwNTA0M1owLwYJ
# KoZIhvcNAQkEMSIEIOVJyzNd9rT9U+ZH7+ojoAxohf0ZTdDV+0xzfzUQsXCnMA0G
# CSqGSIb3DQEBAQUABIICAFE508kJKYJKn+Xny0BozgJ0Iw4RbplnDf7AC/B53A/j
# NPyz8gS4o+liBNE/rrqUIPNgoVPMhK84iI73JO3qLq9Mf2cc8tIFwWkXu6zkIIYV
# cPHgAmGWrwzX265xAJYtFxzsM2Cth8wK6BlYkoqAF/+S1cmRaL+zAHUgcRrQLUHW
# wwYzWXjh2ULXfDJOG+tF3YxzbiW03gWLPkVQc+nzx5kUokB2rL8v0RbbwgW5XbX2
# GEQs9JygwyYqjG4L0R1SkOb7GsT2rxqFs4nyhd2xFXoV9PyiBJJJBN0757Qgz6PX
# 0Et6/qPS/kFYqNy0C57Vdtj6tnYMPzIJB24lDOC1YgcM64I771l8Bmx+HsX83bDU
# jqWelN8QY0HyqLCS6fhHQIwnGoay3CHvxalE3OkJo1LSbah8lSnxT2MV6b5S4tEA
# iMPgS6LPXGmKOFayZSd6z7KShNHgfLfyyAVJjwaPhM3yH1wkXRLFNf4ppW18u5Iy
# CbuocBOKuRMg4PpQZJ+hfMaSU9YDjOznK9SpIAcyKD9/gWX2800sD8xHmsUyit+D
# +NShqJRb0waqBr63CKPvosJkvXjNPhx8QfsO5zZDQ4EWXP25qsv4UhC3uGTIFwnr
# i+Ou/oUWRO4PiVDOfSzy1bRbel7ha6jX+4CCYpiIFP3/wIf2VtuvtrKTJL9ZWu+L
# SIG # End signature block
