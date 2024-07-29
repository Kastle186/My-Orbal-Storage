#!/usr/bin/env bash

function ncd {
    local path=""
    for (( i=1; i<=$1; i++ )); do
        path="../$path"
    done
    cd $path
}

function itemcount {
    local path=""
    if [ -n "$1" ]; then
        path="$1"
    else
        path="."
    fi
    ls -1 "$path" | wc -l
}
