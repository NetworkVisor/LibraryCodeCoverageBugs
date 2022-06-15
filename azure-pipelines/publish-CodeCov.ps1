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

$RepoRoot = (Resolve-Path "$PSScriptRoot/..").Path
$CodeCoveragePathWildcard = (Join-Path $PathToCodeCoverage "*.cobertura.xml")

Write-Host "RepoRoot: $RepoRoot" -ForegroundColor Yellow
Write-Host "CodeCoveragePathWildcard: $CodeCoveragePathWildcard" -ForegroundColor Yellow

$reports = ""

Get-ChildItem -Recurse -Path $CodeCoveragePathWildcard | % {

    if ($IsMacOS -or $IsLinux)
    {
        $relativeFilePath = Resolve-Path -relative $_
    }
    else
    {
        $relativeFilePath = Resolve-Path -relative (Get-ChildItem $_ | Select-Object -ExpandProperty Target)
    }

    Write-Host "Uploading: $relativeFilePath" -ForegroundColor Yellow
    reports += ($relativeFilePath + ",")
}

& (& "$PSScriptRoot/Get-CodeCovTool.ps1") -t "$CodeCovToken" -f "$reports" -R "$RepoRoot"
