# GENERAL TODO:
#   - Add safeguards where needed.
#   - Add the check for Linux/Mac vs Windows because Powershell is available on
#     all platforms. Linux and Mac should in theory use the Bash version of the
#     Orbal Environment, but it's better to keep it open :)

# ***************************** #
# Set up the Orbal Environment! #
# ***************************** #

$orbalEnvSrc = $PSScriptRoot
$orbalEnvApp = Join-Path $orbalEnvSrc "App" "OrbalEnv"

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
