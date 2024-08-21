#!/usr/bin/env bash

# GENERAL TODO:
#   - Add safeguards where needed.
#   - Add the check for Linux/Mac vs Windows because Bash is also available on Windows
#     through MinGW and Git Bash. Windows should in theory use the Powershell version
#     of the Orbal Environment, but it's better to keep it open :)

# ***************************** #
# Set up the Orbal Environment! #
# ***************************** #

ORBAL_ENV_SRC=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
ORBAL_ENV_APP="$ORBAL_ENV_SRC/App/OrbalEnv"

# First, we need to build the Orbal Env App. All its configuration parameters are
# already set in the csproj, so calling 'dotnet build' is enough.
dotnet build "$ORBAL_ENV_SRC/OrbalEnv.csproj"

if [[ "$?" != "0" ]]; then
    echo -e "\nSomething went wrong building the Orbal Environment. Check the C# message."
    return 1
fi

# ******************************************************************* #
# Configure and define the Orbal Environment variables and functions!
# ******************************************************************* #

function ncd {
    local newpath_out
    local ncd_code

    newpath_out=$($ORBAL_ENV_APP ncd "$1")
    ncd_code=$?

    if [[ "$ncd_code" != "0" ]]; then
        echo $newpath_out
        return 1
    fi
    cd $newpath_out
}

function cdroot {
    cd $(git rev-parse --show-toplevel)
}

function itemcount {
    local items_out=$($ORBAL_ENV_APP itemcount "$@")
    echo $items_out
}
