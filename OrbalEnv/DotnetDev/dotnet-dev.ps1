#Requires -Version 7

# ********************************** #
# Set up the Dotnet Dev Environment! #
# ********************************** #

$ext = if ($PSVersionTable.OS -ilike "Windows") { ".exe" } else { "" }
$dotnetDevSrc = $PSScriptRoot
$dotnetDevApp = Join-Path $dotnetDevSrc "App" "DotnetDev$ext"

# First, we need to build the Dotnet Dev App. All its configuration parameters are
# already set in the csproj, so calling 'dotnet build' is enough.
dotnet build "$dotnetDevSrc/DotnetDev.csproj"

if ($LASTEXITCODE -ne 0)
{
    Write-Host "`nSomething went wrong building the Dotnet Dev Environment. Check the C# message."
    return 1
}

# ************************************ #
# Configure the Dotnet Dev Environment #
# ************************************ #

$Env:DOTNET_DEV_WHATIF_PREVIEW = 0
$Env:DOTNET_DEV_REPO = ""

$Env:DOTNET_DEV_OS = & "$dotnetDevApp" "getos"
$Env:DOTNET_DEV_ARCH = & "$dotnetDevApp" "getarch"
$Env:DOTNET_DEV_CONFIG = "Debug"

$Env:DOTNET_DEV_PLATFORM = "$Env:DOTNET_DEV_OS.$Env:DOTNET_DEV_ARCH.$Env:DOTNET_DEV_CONFIG"
$Env:DOTNET_DEV_COREROOT = ""

$Env:DOTNET_DEV_CLRSRC = ""
$Env:DOTNET_DEV_TESTSRC = ""
$Env:DOTNET_DEV_LIBSSRC = ""

function Set-OS([string]$NewOS) {
    $newOsOut = & "$dotnetDevApp" "setos" "$NewOS"
    $setOsCode = $LASTEXITCODE

    if ($setOsCode -ne 0) {
        Write-Host $newOsOut
        return 1
    }

    if ($Env:DOTNET_DEV_WHATIF_PREVIEW -ne 0) {
        Write-Host "`$Env:DOTNET_DEV_OS = $newOsOut"
    }
    else {
        $Env:DOTNET_DEV_OS = $newOsOut
    }

    Update-Paths
}

function Set-Arch([string]$NewArch) {
    $newArchOut = & "$dotnetDevApp" "setarch" "$NewArch"
    $setArchCode = $LASTEXITCODE

    if ($setArchCode -ne 0) {
        Write-Host $newArchOut
        return 1
    }

    if ($Env:DOTNET_DEV_WHATIF_PREVIEW -ne 0) {
        Write-Host "`$Env:DOTNET_DEV_ARCH = $newArchOut"
    }
    else {
        $Env:DOTNET_DEV_ARCH = $newArchOut
    }

    Update-Paths
}

function Set-Config([string]$NewConfig) {
    $newConfigOut = & "$dotnetDevApp" "setconfig" "$NewConfig"
    $setConfigCode = $LASTEXITCODE

    if ($setConfigCode -ne 0) {
        Write-Host $newConfigOut
        return 1
    }

    if ($Env:DOTNET_DEV_WHATIF_PREVIEW -ne 0) {
        Write-Host "`$Env:DOTNET_DEV_CONFIG = $newConfigOut"
    }
    else {
        $Env:DOTNET_DEV_CONFIG = $newConfigOut
    }

    Update-Paths
}

function Set-Repo([string]$RepoPath) {
    $repoPathOut = & "$dotnetDevApp" "setconfig" "$RepoPath"
    $setRepoCode = $LASTEXITCODE

    if ($setRepoCode -ne 0) {
        Write-Host $repoPathOut
        return 1
    }

    $Env:DOTNET_DEV_REPO = "$repoPathOut"
    $Env:DOTNET_DEV_CLRSRC = Join-Path "$repoPathOut" "src" "coreclr"
    $Env:DOTNET_DEV_TESTSRC = Join-Path "$repoPathOut" "src" "tests"
    $Env:DOTNET_DEV_LIBSSRC = Join-Path "$repoPathOut" "src" "libraries"

    $Env:DOTNET_DEV_COREROOT = Join-Path "$repoPathOut"           `
                                         "artifacts"              `
                                         "tests"                  `
                                         "coreclr"                `
                                         $Env:DOTNET_DEV_PLATFORM `
                                         "Tests"                  `
                                         "Core_Root"
}

function Update-Paths() {
    $Env:DOTNET_DEV_PLATFORM = "$Env:DOTNET_DEV_OS.$Env:DOTNET_DEV_ARCH.$Env:DOTNET_DEV_CONFIG"

    if ($Env:DOTNET_DEV_COREROOT) {
        $Env:DOTNET_DEV_COREROOT = Join-Path $Env:DOTNET_DEV_REPO     `
                                             "artifacts"              `
                                             "tests"                  `
                                             "coreclr"                `
                                             $Env:DOTNET_DEV_PLATFORM `
                                             "Tests"                  `
                                             "Core_Root"
    }
}

# **************************************************************** #
# The Functions in Charge of all the Dotnet Dev Environment Magic! #
# **************************************************************** #

# FEATURE IDEA: Enable the 'whatif-preview' scenario with a command-line flag as well.

function WhatIf-Preview() {
    if ($Env:DOTNET_DEV_WHATIF_PREVIEW -eq 0) {
        $Env:DOTNET_DEV_WHATIF_PREVIEW = 1
        Write-Host "What-If Preview Mode Enabled."
    }
    else {
        $Env:DOTNET_DEV_WHATIF_PREVIEW = 0
        Write-Host "What-If Preview Mode Disabled."
    }
}

function Build-Repo([string]$BuildType, [string[]]$BuildArgs = []) {
    $buildRepoOut = & "$dotnetDevApp" "buildrepo" "$BuildType" "$BuildArgs"
    $buildRepoCode = $LASTEXITCODE

    if (($buildRepoCode -ne 0) -or ($Env:DOTNET_DEV_WHATIF_PREVIEW -ne 0)) {
        Write-Host $buildRepoOut
        return 1
    }

    Write-Host "Under construction!"
}
