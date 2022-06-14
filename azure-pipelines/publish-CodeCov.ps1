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

Get-ChildItem -Recurse -Path $CodeCoveragePathWildcard | % {

    if ($IsMacOS -or $IsLinux)
    {
        $relativeFilePath = $_
    }
    else
    {
        $relativeFilePath = (Get-ChildItem $_ | Select-Object -ExpandProperty Target)
    }

    & (& "$PSScriptRoot/Get-CodeCovTool.ps1") -t "$CodeCovToken" -f "$relativeFilePath" -R "$RepoRoot"
}
