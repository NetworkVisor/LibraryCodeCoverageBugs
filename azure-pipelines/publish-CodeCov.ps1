<#
.SYNOPSIS
    Uploads code coverage to codecov.io
.PARAMETER CodeCovToken
    Code coverage token to use
.PARAMETER PathToCodeCoverage
    Path to root of code coverage files
.PARAMETER Name
    Optional name to upload with codecoverge
.PARAMETER CalcNSFlags
    Optional switch to calculate Flags from namespace of test.
.PARAMETER Flags
    Optional flags to upload with codecoverge
#>
[CmdletBinding()]
Param (
    [string]$CodeCovToken,
    [string]$PathToCodeCoverage,
    [string]$Name="",
    [switch]$CalcNSFlags,
    [string]$Flags=""
)

$RepoRoot = (Resolve-Path "$PSScriptRoot/..").Path
$CodeCoveragePathWildcard = (Join-Path $PathToCodeCoverage "*.cobertura.xml")

Write-Host "RepoRoot: $RepoRoot" -ForegroundColor Yellow
Write-Host "CodeCoveragePathWildcard: $CodeCoveragePathWildcard" -ForegroundColor Yellow

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

    $CalcNSFlags = true

    if ($CalcNSFlags)
    {
        $TestTypeFlag = "UnknownTest"

        if ($relativeFilePath -ilike ".Unit")
        {
            $TestTypeFlag = "Unit"
        }
        elseif ($relativeFilePath -ilike ".Integration")
        {
            $TestTypeFlag = "Integration"
        }
        elseif ($relativeFilePath -ilike ".Local")
        {
             $TestTypeFlag = "Local"
        }
        elseif ($relativeFilePath -ilike ".Device")
        {
            $TestTypeFlag = "Device"
        }

        $OSTypeFlag = "UnknownOS"

        if ($relativeFilePath -ilike ".Windows")
        {
            $OSTypeFlag = "Windows"
        }
        elseif ($relativeFilePath -ilike ".WinUI")
        {
            $OSTypeFlag = "WinUI"
        }
        elseif ($relativeFilePath -ilike ".WPF")
        {
            $OSTypeFlag = "WPF"
        }
        elseif ($relativeFilePath -ilike ".MacOS")
        {
            $OSTypeFlag = "MacOS"
        }
        elseif ($relativeFilePath -ilike ".MacCatalyst")
        {
            $OSTypeFlag = "MacCatalyst"
        }
        elseif ($relativeFilePath -ilike ".OSX")
        {
            $OSTypeFlag = "MacOS"
        }
        elseif ($relativeFilePath -ilike ".Android")
        {
            $OSTypeFlag = "Android"
        }
        elseif ($relativeFilePath -ilike ".IOS")
        {
            $OSTypeFlag = "IOS"
        }
        elseif ($relativeFilePath -ilike ".Linux")
        {
            $OSTypeFlag = "Linux"
        }
        elseif ($relativeFilePath -ilike ".NetCore")
        {
            $OSTypeFlag = "NetCore"
        }
        elseif ($relativeFilePath -ilike ".Core")
        {
            $OSTypeFlag = "Core"
        }

        $Flags = ($Flags, $TestTypeFlag, $OSTypeFlag -join ',')
    }

    Write-Host "Flags: $Flags" -ForegroundColor Yellow

    & (& "$PSScriptRoot/Get-CodeCovTool.ps1") -t "$CodeCovToken" -f "$relativeFilePath" -R "$RepoRoot" -F "$Flags" -n "$Name"
}
