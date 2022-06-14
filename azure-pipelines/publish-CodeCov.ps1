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

    if ($IsWindows)
    {
        $relativeFilePath = (Get-ChildItem $_).Target
    }
    else
    {
        $relativeFilePath = $_
    }

    if (-not (Test-Path $$relativeFilePath)) {
        Write-Host "Coverage file not found: $relativeFilePath" -ForegroundColor Yellow
    }
    else {
        Write-Host "Uploading: $relativeFilePath" -ForegroundColor Yellow
    }

    & (& "$PSScriptRoot/Get-CodeCovTool.ps1") -t "$CodeCovToken" -f "$relativeFilePath" -R "$RepoRoot"
}
