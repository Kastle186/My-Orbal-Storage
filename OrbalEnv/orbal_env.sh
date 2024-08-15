#!/usr/bin/env bash

# GENERAL TODO: Add safeguards where needed.

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
ORBAL_ENV_SRC="$SCRIPT_DIR/OrbalEnvSrc"
ORBAL_ENV_APP="$ORBAL_ENV_SRC/App/OrbalEnv"

export DIR_STACK="$PWD"

function cd {
    builtin cd "$@"
    cdcode=$?
    [[ "$cdcode" == "0" ]] && export DIR_STACK="$($ORBAL_ENV_APP dir2stack "$PWD")"
}

function ncd {
    local newpath_out=$($ORBAL_ENV_APP ncd "$1")
    [[ "$?" == "0" ]] && cd "$newpath_out"
}

function cdprev {
    echo 'Command cdprev under construction!'
}
