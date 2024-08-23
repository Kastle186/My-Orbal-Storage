#!/usr/bin/env bash

MAIN_SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
PLUGINS_CMD=(find $MAIN_SCRIPT_DIR -mindepth 2 -maxdepth 2 -name '*.sh' -type f -print)

while IFS= read -r script
do
    echo -e "\nSourcing $script...\n"
    source $script
done < <("${PLUGINS_CMD[@]}")
