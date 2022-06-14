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
    if ($IsWindows)
    {
        $filePath = $_.FullName
        $filePath.replace([IO.Path]::AltDirectorySeparatorChar, [IO.Path]::DirectorySeparatorChar)
    }
    else
    {
        $filePath = $_.FullName
    }

    Write-Host "Uploading $_" -ForegroundColor Yellow
    & (& "$PSScriptRoot/Get-CodeCovTool.ps1") -t $CodeCovToken -f $filePath
}



