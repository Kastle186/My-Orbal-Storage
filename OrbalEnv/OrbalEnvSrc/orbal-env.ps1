# GENERAL TODO:
#   - Add safeguards where needed.

# ***************************** #
# Set up the Orbal Environment! #
# ***************************** #

$ext = if ($IsWindows) { ".exe" } else { "" }
$orbalEnvSrc = $PSScriptRoot
$orbalEnvApp = Join-Path $orbalEnvSrc "App" "OrbalEnv$ext"

# First, we need to build the Orbal Env App. All its configuration parameters are
# already set in the csproj, so calling 'dotnet build' is enough.
dotnet build "$orbalEnvSrc/OrbalEnv.csproj"

if ($LASTEXITCODE -ne 0)
{
    Write-Host "`nSomething went wrong building the Orbal Environment. Check the C# message."
    exit 1
}

# ******************************************************************* #
# Configure and define the Orbal Environment variables and functions!
# ******************************************************************* #

function Ncd([string]$Level)
{
    $newPathOut = (Invoke-Expression "$orbalEnvApp ncd $Level")
    $ncdCode = $LASTEXITCODE

    if ($ncdCode -ne 0)
    {
        Write-Host $newPathOut
        return 1
    }

    Set-Location $newPathOut
}

function CdRoot()
{
    $repoRoot = (git rev-parse --show-toplevel)
    Set-Location $repoRoot
}

function ItemCount([string[]]$CmdArgs)
{
    $itemsOut = (Invoke-Expression "$orbalEnvApp itemcount $CmdArgs")
    Write-Host $itemsOut
}
