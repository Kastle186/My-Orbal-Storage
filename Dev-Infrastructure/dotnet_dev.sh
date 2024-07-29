#!/usr/bin/env bash

echo -e '\nSourcing dotnet_dev.sh...'

###################################
# Setup the Dotnet Dev Environment
###################################

SOURCING_PATH="$(cd -- \"$(dirname \"${BASH_SOURCE[0]}\")\" > /dev/null 2>&1 ; pwd -P)"
SCRIPT_PATH="$SOURCING_PATH/$(dirname ${BASH_SOURCE[0]})"
DOTNET_DEV_ENG_APP="$SCRIPT_PATH/dotnet_dev/dotnet_dev.rb"

##############################
# Environment Variables Setup
##############################

export WORK_REPO=""
export TEST_ARTIFACTS=""
export CORE_ROOT=""

ARCH_NAME=$(uname -m | tr '[:upper:]' '[:lower:]')
OS_NAME=$(uname -s | tr '[:upper:]' '[:lower:]')

case "$ARCH_NAME" in
    aarch64)
        export DEV_ARCH="arm64"
        ;;

    amd64|x86_64)
        export DEV_ARCH="x64"
        ;;

    armv6l)
        export DEV_ARCH="armv6"
        ;;

    armv7l|armv8l)
        if (NAME=""; . /etc/os-release; test "$NAME" = "Tizen"); then
            export DEV_ARCH="armel"
        else
            export DEV_ARCH="arm"
        fi
        ;;

    i[3-6]86)
        export DEV_ARCH="x86"
        ;;

    *)
        export DEV_ARCH="$ARCH_NAME"
        ;;
esac

if [[ "$OS_NAME" = "darwin" ]]; then
    export DEV_OS="osx"
else
    export DEV_OS="$OS_NAME"
fi

if [[ -z "$1" ]]; then
    export DEV_CONFIG="Debug"
else
    export DEV_CONFIG="$1"
fi

echo "Default architecture was set to '$DEV_ARCH'."
echo "Default operating system was set to '$DEV_OS'."
echo "Default configuration was set to '$DEV_CONFIG'."

##################################
# Dev Environment Main Functions!
##################################

function setrepo {
    if [ -n "$1" ]; then
        export WORK_REPO="$1"
    else
        export WORK_REPO="$(pwd)"
    fi

    export TEST_ARTIFACTS="$WORK_REPO/artifacts/tests/coreclr/"
    export CORE_ROOT="$TEST_ARTIFACTS/Tests/Core_Root"
}

function setarch {
    echo 'Setarch under construction!'
}

function setos {
    echo 'Setos under construction!'
}

function setconfig {
    echo 'Setconfig under construction!'
}
