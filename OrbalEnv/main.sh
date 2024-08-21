#!/usr/bin/env bash

# GENERAL TODO: Add safeguards where needed.

MAIN_SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
PLUGIN_ENTRIES=$(find $MAIN_SCRIPT_DIR -mindepth 2 -maxdepth 2 -name '*.sh' -type f -print)

for script in "${PLUGIN_ENTRIES[@]}"
do
    echo -e "\nSourcing $script...\n"
    source $script
done
