#!/usr/bin/bash

directory="$PWD"

if [ -n "$1" ]; then
    directory="$1"
fi

extensions=()

for entry in "$directory"/*; do
    if [ -f "$entry" ]; then
        extensions+=("${entry##*.}")
    fi
done

declare -A ext_counts
declare -A ext_names=(
    [c]="C Source File"
    [cpp]="C++ Source File"
    [erl]="Erlang Source File"
    [go]="Golang Source File"
    [java]="Java Source File"
    [js]="JavaScript Source File"
    [pdf]="PDF Document"
    [py]="Python Source File"
    [rb]="Ruby Source File"
    [rs]="Rust Source File"
    [sh]="Bash/Shell Script"
    [swift]="Swift Source File"
    [tex]="LaTeX Source File"
    [other]="Other"
)

# FIXME: Have to do the extension conversion before attempting to add to the
#        associative arrays. Otherwise, file types with multiple possible extensions
#        (e.g. JavaScript with .js and .mjs) have undefined behavior sometimes.

for ext in "${extensions[@]}"; do
    if [[ ! -v ext_counts["$ext"] ]]; then
        ext_counts["$ext"]=1
        continue
    fi

    case "$ext" in
        c | h)
            ext_counts["c"]=$(( ext_counts["c"] + 1 ))
            ;;
        cpp | hpp)
            ext_counts["cpp"]=$(( ext_counts["cpp"] + 1 ))
            ;;
        erl)
            ext_counts["erl"]=$(( ext_counts["erl"] + 1 ))
            ;;
        go)
            ext_counts["go"]=$(( ext_counts["go"] + 1 ))
            ;;
        java)
            ext_counts["java"]=$(( ext_counts["java"] + 1 ))
            ;;
        js | mjs)
            ext_counts["js"]=$(( ext_counts["js"] + 1 ))
            ;;
        pdf)
            ext_counts["pdf"]=$(( ext_counts["pdf"] + 1 ))
            ;;
        py)
            ext_counts["py"]=$(( ext_counts["py"] + 1 ))
            ;;
        rb)
            ext_counts["rb"]=$(( ext_counts["rb"] + 1 ))
            ;;
        rs)
            ext_counts["rs"]=$(( ext_counts["rs"] + 1 ))
            ;;
        sh)
            ext_counts["sh"]=$(( ext_counts["sh"] + 1 ))
            ;;
        swift)
            ext_counts["swift"]=$(( ext_counts["swift"] + 1 ))
            ;;
        tex)
            ext_counts["tex"]=$(( ext_counts["tex"] + 1 ))
            ;;
        *)
            ext_counts["other"]=$(( ext_counts["other"] + 1 ))
            ;;
    esac
done

for item in "${!ext_counts[@]}"; do
    key="${ext_names[$item]}"
    value="${ext_counts[$item]}"
    echo "$key: $value"
done
