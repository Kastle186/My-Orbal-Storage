#!/usr/bin/env bash

# ********************************** #
# Set up the Dotnet Dev Environment! #
# ********************************** #

case "$(uname -s)" in
    CYGWIN*|MINGW*|MSYS*)
        EXT='.exe'
        ;;
    *)
        EXT=''
        ;;
esac

DOTNET_DEV_SRC=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
DOTNET_DEV_APP="$DOTNET_DEV_SRC/App/DotnetDev$EXT"

# First, we need to build the Dotnet Dev App. All its configuration parameters are
# already set in the csproj, so calling 'dotnet build' is enough.
dotnet build "$DOTNET_DEV_SRC/DotnetDev.csproj"

if [[ "$?" != "0" ]]; then
    echo -e "\nSomething went wrong building the Dotnet Dev Environment. Check the C# message."
    return 1
fi

# ************************************ #
# Configure the Dotnet Dev Environment #
# ************************************ #

export DOTNET_DEV_REPO=""

export DOTNET_DEV_OS="$($DOTNET_DEV_APP getos)"
export DOTNET_DEV_ARCH="$($DOTNET_DEV_APP getarch)"
export DOTNET_DEV_CONFIG="Debug"

export DOTNET_DEV_PLATFORM="$DOTNET_DEV_OS.$DOTNET_DEV_ARCH.$DOTNET_DEV_CONFIG"
export DOTNET_DEV_COREROOT=""

export DOTNET_DEV_CLRSRC=""
export DOTNET_DEV_TESTSRC=""
export DOTNET_DEV_LIBSSRC=""

function setos {
    local newos_out
    local setos_code

    newos_out=$($DOTNET_DEV_APP setos "$1")
    setos_code=$?

    if [[ "$setos_code" != "0" ]]; then
        echo $newos_out
        return 1
    fi

    export DOTNET_DEV_OS=$newos_out
    updatepaths
}

function setarch {
    local newarch_out
    local setarch_code

    newarch_out=$($DOTNET_DEV_APP setarch "$1")
    setarch_code=$?

    if [[ "$setarch_code" != "0" ]]; then
        echo $newarch_out
        return 1
    fi

    export DOTNET_DEV_ARCH=$newarch_out
    updatepaths
}

function setconfig {
    local newconfig_out
    local setconfig_code

    newconfig_out=$($DOTNET_DEV_APP setconfig "$1")
    setconfig_code=$?

    if [[ "$setconfig_code" != "0" ]]; then
        echo $newconfig_out
        return 1
    fi

    export DOTNET_DEV_CONFIG=$newconfig_out
    updatepaths
}

function setrepo {
    local repopath_out
    local setrepo_code

    repopath_out=$($DOTNET_DEV_APP setrepo "$1")
    setrepo_code=$?

    if [[ "$setrepo_code" != "0" ]]; then
        echo $repopath_out
        return 1
    fi

    export DOTNET_DEV_REPO="$repopath_out"
    export DOTNET_DEV_CLRSRC="$DOTNET_DEV_REPO/src/coreclr"
    export DOTNET_DEV_TESTSRC="$DOTNET_DEV_REPO/src/tests"
    export DOTNET_DEV_LIBSSRC="$DOTNET_DEV_REPO/src/libraries"

    export DOTNET_DEV_COREROOT="$DOTNET_DEV_REPO/artifacts/tests/coreclr/\
$DOTNET_DEV_PLATFORM/Tests/Core_Root"
}

function updatepaths {
    export DOTNET_DEV_PLATFORM="$DOTNET_DEV_OS.$DOTNET_DEV_ARCH.$DOTNET_DEV_CONFIG"
    export DOTNET_DEV_COREROOT="$DOTNET_DEV_REPO/artifacts/tests/coreclr/\
$DOTNET_DEV_PLATFORM/Tests/Core_Root"
}
