<#
.SYNOPSIS
    Uploads code coverage to codecov.io
.PARAMETER PathToCodeCoverage
    Path to root of code coverage files
#>
[CmdletBinding()]
Param (
    [Parameter()]
    [string]$PathToCodeCoverage
)

$coverageFiles =[string]::join(',', (Get-ChildItem $PathToCodeCoverage -Recurse))

Write-Host "Publishing to codecov: $coverageFiles" -ForegroundColor Yellow

(& $PSScriptRoot\Get-CodeCovTool.ps1) -f $coverageFiles
