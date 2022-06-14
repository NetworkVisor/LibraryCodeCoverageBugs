<#
.SYNOPSIS
    Uploads code coverage to codecov.io
.PARAMETER CodeCovToken
    Code coverage token to use
.PARAMETER PathToCodeCoverage
    Path to root of code coverage files
#>
[CmdletBinding()]
Param (
    [string]$CodeCovToken,
    [string]$PathToCodeCoverage
)

$codeCovToolPath = & "$PSScriptRoot/Get-CodeCovTool.ps1"
Write-Host "Path to codecov $codeCovToolPath" -ForegroundColor Yellow

Get-ChildItem -Recurse -Path "$PathToCodeCoverage/*.cobertura.xml" | % {

    # Replace Directory Separator on Windows
    if (-not ($IsLinux -or $IsMacOS))
    {
        $_.replace([IO.Path]::DirectorySeparatorChar, [IO.Path]::AltDirectorySeparatorChar)
    }

    Write-Host "Uploading $_" -ForegroundColor Yellow
    & (& "$PSScriptRoot/Get-CodeCovTool.ps1") -t $CodeCovToken -f $_
}



