#!/usr/bin/env bash

# GENERAL TODO: Add safeguards where needed.

# ***************************** #
# Set up the Orbal Environment! #
# ***************************** #

ORBAL_ENV_SRC=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
ORBAL_ENV_APP="$ORBAL_ENV_SRC/App/OrbalEnv"

# First, we need to build the Orbal Env App. All its configuration parameters are
# already set in the csproj, so calling 'dotnet build' is enough.
dotnet build "$ORBAL_ENV_SRC/OrbalEnv.csproj"

if [[ "$?" != "0" ]]; then
    echo -e "\nSomething went wrong building the Orbal Environment. Check the C# error message."
    return 1
fi

# ******************************************************************* #
# Configure and define the Orbal Environment variables and functions!
# ******************************************************************* #

export DIR_DEQUE="$PWD"

function cd {
    builtin cd "$@"
    local cdcode=$?
    [[ "$cdcode" == "0" ]] && export DIR_DEQUE="$($ORBAL_ENV_APP dir2deque "$PWD")"
}

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

function cdprev {
    local prevpath_out
    local cdprev_code

    prevpath_out=$($ORBAL_ENV_APP cdprev)
    cdprev_code=$?

    if [[ "$cdprev_code" == "2" ]]; then
        return 0
    fi

    if [[ "$cdprev_code" != "0" ]]; then
        echo $prevpath_out
        return 1
    fi

    cd $prevpath_out
    export DIR_DEQUE="$($ORBAL_ENV_APP dirdequeue)"
}

function cdroot {
    cd $(git rev-parse --show-toplevel)
}
