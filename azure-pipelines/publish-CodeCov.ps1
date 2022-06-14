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
    [Parameter()]
    [string]$CodeCovToken,
    [Parameter()]
    [string]$PathToCodeCoverage
)

$codeCoverageFiles = @(Get-ChildItem "$PathToCodeCoverage/*.cobertura.xml" -Recurse)
$codeCovToolPath = @(& $PSScriptRoot\Get-CodeCovTool.ps1)

 Write-Host "Path to codecov $codeCovToolPath" -ForegroundColor Yellow

$codeCoverageFiles |%
{
    Write-Host "Uploading $_" -ForegroundColor Yellow
    & $codeCovToolPath -t "$CodeCovToken" -f "$_"
}



