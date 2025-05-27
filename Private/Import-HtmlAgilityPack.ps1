Function Import-HtmlAgilityPack {
    Try {
        Add-Type -AssemblyName 'netstandard, Version=2.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51' -ErrorAction Stop
        $dotNetTarget = "netstandard2"
    }
    Catch {
        $dotNetTarget = "net40-client"
    }

    $RootPath = Split-Path $PSScriptRoot -Parent
    $AssembliesToLoad = Get-ChildItem -Path "$RootPath\lib\*-$dotNetTarget.dll"

    Write-Verbose -Message "Loading Assemblies for .NET target: $dotNetTarget"
    Add-Type -Path $AssembliesToLoad.fullname -ErrorAction Stop
}

Import-HtmlAgilityPack