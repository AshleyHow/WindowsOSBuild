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

    If ($AssembliesToLoad) {
        #If we are in a build or a pester test, load assemblies from a temporary file so they don't lock the original file
        #This helps to prevent cleaning problems due to a powershell session locking the file because unloading a module doesn't unload assemblies
        If ($BuildTask -or $TestDrive) {
            write-verbose "Detected Invoke-Build or Pester, loading assemblies from a temp location to avoid locking issues"
            If ($Global:BuildAssembliesLoadedPreviously) {
                write-warning "You are in a build or test environment. We detected that module assemblies were loaded in this same session on a previous build or test. Strongly recommend you kill the process and start a new session for a clean build/test!"
            }

            $TempAssembliesToLoad = @()
            ForEach ($AssemblyPathItem in $AssembliesToLoad) {
                $TempAssemblyPath = [System.IO.Path]::GetTempFileName() + ".dll"
                Copy-Item $AssemblyPathItem $TempAssemblyPath
                $TempAssembliesToLoad += [System.IO.FileInfo]$TempAssemblyPath
            }
            $AssembliesToLoad = $TempAssembliesToLoad
            $Global:BuildAssembliesLoadedPreviously = $true
        }
    }

    Write-Verbose "Loading Assemblies for .NET target: $dotNetTarget"
    Add-Type -Path $AssembliesToLoad.fullname -ErrorAction Stop
}

Import-HtmlAgilityPack