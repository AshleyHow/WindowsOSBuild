# Get public and private function definition files
    $Public  = @(Get-ChildItem -Path $PSScriptRoot\Public\*.ps1 -ErrorAction SilentlyContinue)
    $Private = @(Get-ChildItem -Path $PSScriptRoot\Private\*.ps1 -ErrorAction SilentlyContinue)

# Dot source the files
    Foreach($Import in @($Public + $Private)) {
        Try {
            . $Import.Fullname
        }
        Catch {
            Write-Error -Message "Failed to import function $(Import.Fullname): $_"
        }
    }

# Export the public functions. This requires them to match the standard Noun-Verb powershell cmdlet format as a safety mechanism
Export-ModuleMember -Function ($Public.Basename | Where-Object {$PSitem -match '^\w+-\w+$'})