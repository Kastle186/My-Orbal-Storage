#!/opt/homebrew/bin/bash

# ##################### #
# File Arranger Script!
# ##################### #

cmd=""
indx=""
label=""
srcdir=""

function validate_args {
    # Do the necessary checks to ensure paths and stuff are okay.
    if [ ! -d "$dir" ]; then
        echo "The given directory '$dir' was not found :("
        exit 1
    fi
}

function add_old_prefix {
    for file in "$dir"/*; do
        if [ ! -f "$file" ]; then
            continue
        fi

        filename=$(basename "$file")
        newname="_old_${filename}"
        mv "$file" "$dir/$newname"
    done
}

function insert_to_series {
}

function rename_to_series {
    # Rename the files to a given tag/label/prefix and a number.
    local count=1

    echo -e "\nRenaming files to label '${label}'...\n"

    for file in "$dir"/*; do
        if [ ! -f "$file" ]; then
            continue
        fi

        ext="${file##*.}"
        newname="${label} ${count}.${ext}"

        echo "Renaming ${file} to ${newname}..."
        mv "$file" "$dir/$newname"
        ((count++))
    done
}

# Parse the command-line arguments.

while [[ $# -gt 0 ]]; do
    case "$1" in
        --directory)
            srcdir="$2"
            shift 2
            ;;
        --insert-to-series)
            cmd="ins2series"
            indx="$2"
            shift 2
            ;;
        --rename-to-series)
            cmd="ren2series"
            label="$2"
            shift 2
            ;;
        *)
            echo "Unknown option: '$1'"
            exit 1
            ;;
    esac
done

# Call the function(s) to run here.

echo "Finished!"
