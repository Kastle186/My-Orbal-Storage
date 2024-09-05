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

export DOTNET_DEV_WHATIF_PREVIEW=0
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

    if [[ "$DOTNET_DEV_WHATIF_PREVIEW" != "0" ]]; then
        echo "export DOTNET_DEV_OS=$newos_out"
    else
        export DOTNET_DEV_OS=$newos_out
    fi

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

    if [[ "$DOTNET_DEV_WHATIF_PREVIEW" != "0" ]]; then
        echo "export DOTNET_DEV_ARCH=$newarch_out"
    else
        export DOTNET_DEV_ARCH=$newarch_out
    fi

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

    if [[ "$DOTNET_DEV_WHATIF_PREVIEW" != "0" ]]; then
        echo "export DOTNET_DEV_CONFIG=$newconfig_out"
    else
        export DOTNET_DEV_CONFIG=$newconfig_out
    fi

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

    if [[ "$DOTNET_DEV_WHATIF_PREVIEW" != "0" ]]; then
        echo "export DOTNET_DEV_REPO=\"$repopath_out\""
        echo "export DOTNET_DEV_CLRSRC=\"$repopath_out/src/coreclr\""
        echo "export DOTNET_DEV_TESTSRC=\"$repopath_out/src/tests\""
        echo "export DOTNET_DEV_LIBSSRC=\"$repopath_out/src/libraries\""

        echo "export DOTNET_DEV_COREROOT=\"$repopath_out/artifacts/tests/coreclr/\
$DOTNET_DEV_PLATFORM/Tests/Core_Root\""

    else
        export DOTNET_DEV_REPO="$repopath_out"
        export DOTNET_DEV_CLRSRC="$DOTNET_DEV_REPO/src/coreclr"
        export DOTNET_DEV_TESTSRC="$DOTNET_DEV_REPO/src/tests"
        export DOTNET_DEV_LIBSSRC="$DOTNET_DEV_REPO/src/libraries"

        export DOTNET_DEV_COREROOT="$DOTNET_DEV_REPO/artifacts/tests/coreclr/
$DOTNET_DEV_PLATFORM/Tests/Core_Root"
    fi
}

function updatepaths {
    export DOTNET_DEV_PLATFORM="$DOTNET_DEV_OS.$DOTNET_DEV_ARCH.$DOTNET_DEV_CONFIG"
    export DOTNET_DEV_COREROOT="$DOTNET_DEV_REPO/artifacts/tests/coreclr/\
$DOTNET_DEV_PLATFORM/Tests/Core_Root"
}

# **************************************************************** #
# The Functions in Charge of all the Dotnet Dev Environment Magic! #
# **************************************************************** #

# FEATURE IDEA: Enable the 'whatif-preview' scenario with a command-line flag as well.

function whatifpreview {
    if [[ "$DOTNET_DEV_WHATIF_PREVIEW" == "0" ]]; then
        export DOTNET_DEV_WHATIF_PREVIEW=1
        echo 'What-If Preview Mode Enabled.'
    else
        export DOTNET_DEV_WHATIF_PREVIEW=0
        echo 'What-If Preview Mode Disabled.'
    fi
}

function buildrepo {
    local buildrepo_out
    local buildrepo_code

    buildrepo_out=$($DOTNET_DEV_APP buildrepo "$@")
    buildrepo_code=$?

    if [[ "$buildrepo_code" != "0" || "$DOTNET_DEV_WHATIF_PREVIEW" != "0" ]]; then
        echo $buildrepo_out
        return 1
    fi

    $buildrepo_out
}

alias buildclr="buildrepo -subset clr"
alias buildclrdbg="buildrepo -subset clr -configuration Debug"
alias buildclrchk="buildrepo -subset clr -configuration Checked"
alias buildclrrel="buildrepo -subset clr -configuration Release"

alias buildlibs="buildrepo -subset libs"
alias buildlibsdbg="buildrepo -subset libs -configuration Debug"
alias buildlibschk="buildrepo -subset libs -configuration Checked"
alias buildlibsrel="buildrepo -subset libs -configuration Release"

alias buildclrlibs="buildrepo -subset clr+libs"
alias buildclrlibsdbg="buildrepo -subset clr+libs -configuration Debug"
alias buildclrlibsrel="buildrepo -subset clr+libs -configuration Release"

alias buildclrlibsdbgrel="buildrepo -s clr+libs -rc Debug -lc Release"
alias buildclrlibschkrel="buildrepo -s clr+libs -rc Checked -lc Release"
alias buildclrlibschkdbg="buildrepo -s clr+libs -rc Checked -lc Debug"
alias buildclrlibsreldbg="buildrepo -s clr+libs -rc Release -lc Debug"

# Using single quotes here because we want to cd into the literal environment variable,
# to whatever value it has when issuing the alias. Otherwise, it will expand the
# environment variable at the time of sourcing the script, and assign that value to
# the 'cd' path, which in this case would be the empty string.

alias cdclr='cd $DOTNET_DEV_CLRSRC'
alias cdtests='cd $DOTNET_DEV_TESTSRC'
alias cdlibs='cd $DOTNET_DEV_LIBSSRC'
