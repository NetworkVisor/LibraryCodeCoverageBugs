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

# CodeCov cannot handle full windows paths so make them relative
if ($IsWindows)
{
    $codeCoveragePathWildcard = Resolve-Path -relative $PathToCodeCoverage
}
else
{
    $codeCoveragePathWildcard = $PathToCodeCoverage
}

$RepoRoot = (Resolve-Path "$PSScriptRoot/..").Path

Write-Host "RepoRoot: $RepoRoot" -ForegroundColor Yellow
Write-Host "CodeCoveragePathWildcard: $codeCoveragePathWildcard" -ForegroundColor Yellow

& (& "$PSScriptRoot/Get-CodeCovTool.ps1") -t "$CodeCovToken" -s "$codeCoveragePathWildcard" -R "$RepoRoot"
