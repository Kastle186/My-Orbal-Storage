#!/usr/bin/env bash

# *************************** #
# Set up the Git Environment! #
# *************************** #

case "$(uname -s)" in
    CYGWIN*|MINGW*|MSYS*)
        EXT='.exe'
        ;;
    *)
        EXT=''
        ;;
esac

GIT_ENV_SRC=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
GIT_ENV_APP="$GIT_ENV_SRC/App/GitEnv$EXT"

# First, we need to build the Git Env App. All its configuration parameters are
# already set in the csproj, so calling 'dotnet build' is enough.
dotnet build "$GIT_ENV_SRC/GitEnv.csproj"

if [[ "$?" != "0" ]]; then
    echo -e "\nSomething went wrong building the Git Environment. Check the C# message."
    return 1
fi

# NOTE: Check whether Git is actually in the PATH environment variable. If it isn't,
#       then display a warning saying the commands won't work unless the GITENV_GIT_EXE
#       environment variable is set to point to the 'git' executable.

export GITENV_GIT_EXE="git"

# ***************************************************************** #
# Configure and define the Git Environment variables and functions! #
# ***************************************************************** #

alias gitstat="$GITENV_GIT_EXE status"
