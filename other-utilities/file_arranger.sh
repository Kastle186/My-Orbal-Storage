#!/opt/homebrew/bin/bash

# ##################### #
# File Arranger Script!
# ##################### #

# Universal Params
CMD=""
SRC_DIR=""

# Insert-only Params
FILE_TO_ADD=""
INDEX_TO_ADD=""
SERIES="" # Temp while I learn how to take the prefix programmatically from existing files.

# Rename-only Params
LABEL=""

function parse_command {
    local cmd_arg="$1"

    case "$cmd_arg" in
        --insert-to-series | -i2s)
            CMD="ins2series"
            ;;
        --rename-to-series | -r2s)
            CMD="renm2series"
            ;;
        *)
            CMD="$cmd_arg"
            ;;
    esac
}

function parse_insert_args {
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --directory | -d)
                SRC_DIR="$2"
                shift 2
                ;;
            --file | -f)
                FILE_TO_ADD="$2"
                shift 2
                ;;
            --index | -i)
                INDEX_TO_ADD="$2"
                shift 2
                ;;
            --series | -s)
                SERIES="$2"
                shift 2
                ;;
            *)
                echo "Unknown option for mode insert-to-series: '$1'"
                exit 1
                ;;
        esac
    done

    # Validate we got all the parameters.

    if [ ! -d "$SRC_DIR" ]; then
        echo "The given directory path '$SRC_DIR' could not be found :("
        exit 1
    fi

    if [[ -z "$FILE_TO_ADD" ]]; then
        echo "Missing file to insert to the series. Pass it with --file."
        exit 1
    fi

    if [[ -z "$INDEX_TO_ADD" ]]; then
        echo "Missing index where to insert the file. Pass it with --index."
        exit 1
    fi

    if [[ -z "$SERIES" ]]; then
        echo "Missing series prefix. Pass it with --series."
        exit 1
    fi
}

function parse_rename_args {
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --directory | -d)
                SRC_DIR="$2"
                shift 2
                ;;
            --label | -l)
                LABEL="$2"
                shift 2
                ;;
            *)
                echo "Unknown option for mode rename-to-series: '$1'"
                exit 1
                ;;
        esac
    done

    # Validate we got all the parameters.

    if [ ! -d "$SRC_DIR" ]; then
        echo "The given directory path '$SRC_DIR' could not be found :("
        exit 1
    fi

    if [[ -z "$LABEL" ]]; then
        echo "Missing prefix label to rename the files. Pass it with --label."
        exit 1
    fi
}

function insert_to_series {
    SERIES="$SERIES "
    cd "$SRC_DIR"

    echo -e "\nInserting $FILE_TO_ADD at position $INDEX in $SRC_DIR...\n"

    # Step 1: Find existing numbered files and store them with their extensions

    mapfile -t existing_files < <(find . -maxdepth 1 -type f -name "$SERIES*" | sed -E "s|^\./||" | grep -E "^$SERIES[0-9]+(\.[a-zA-Z0-9]+)$")

    # Step 2: Extract file numbers and sort descending

    declare -A file_map
    local max_index=0

    for file in "${existing_files[@]}"; do
        if [[ "$file" =~ ^${SERIES}([0-9]+)(\.[a-zA-Z0-9]+)$ ]]; then
            num="${BASH_REMATCH[1]}"
            ext="${BASH_REMATCH[2]}"
            file_map["$num"]="$ext"
            (( num > max_index )) && max_index=$num
        fi
    done

    # Step 3: Shift existing files backward starting from the max_index

    for (( i=max_index; i>=$INDEX_TO_ADD; i-- )); do
        current_name="$SERIES$i${file_map[$i]}"
        next_index=$((i + 1))
        new_name="$SERIES$next_index${file_map[$i]}"

        if [[ -f "$current_name" ]]; then
            echo "Renaming ${current_name} to ${new_name}..."
            mv "$current_name" "$new_name"
        fi
    done

    # Step 4: Insert the new file

    # Get extension of new file
    new_ext=".${FILE_TO_ADD##*.}"
    new_name="$SERIES$INDEX_TO_ADD$new_ext"
    echo -e "\nInserting $FILE_TO_ADD as ${new_name}..."
    cp "$FILE_TO_ADD" "$new_name"

    # Return to the original location.
    cd -
}

function rename_to_series {
    # Rename the files to a given tag/label/prefix and a number.
    local count=1

    echo -e "\nRenaming files to label '${LABEL}'...\n"

    for file in "$SRC_DIR"/*; do
        if [ ! -f "$file" ]; then
            continue
        fi

        ext="${file##*.}"
        newname="${LABEL} ${count}.${ext}"

        echo "Renaming ${file} to ${newname}..."
        mv "$file" "$SRC_DIR/$newname"
        ((count++))
    done
}

function main {
    parse_command "$1"
    shift 1

    case "$CMD" in
        "ins2series")
            parse_insert_args "$@"
            insert_to_series
            ;;
        "renm2series")
            parse_rename_args "$@"
            rename_to_series
            ;;
        *)
            echo "Unknown command: '$CMD'"
            exit 1
            ;;
    esac
}

main "$@"

# #!/bin/bash

# # Configuration
# target_folder="./images"     # Folder with images
# insert_position=3            # Position to insert the new image
# new_file_path="./new.webp"   # New file to insert
# file_prefix="Image "         # Common prefix

# cd "$target_folder" || exit 1

# # Step 1: Find existing numbered files and store them with their extensions
# mapfile -t existing_files < <(find . -maxdepth 1 -type f -name "$file_prefix*" | sed -E "s|^\./||" | grep -E "^$file_prefix[0-9]+(\.[a-zA-Z0-9]+)$")

# # Step 2: Extract file numbers and sort descending
# declare -A file_map
# max_index=0

# for file in "${existing_files[@]}"; do
#     if [[ "$file" =~ ^${file_prefix}([0-9]+)(\.[a-zA-Z0-9]+)$ ]]; then
#         num="${BASH_REMATCH[1]}"
#         ext="${BASH_REMATCH[2]}"
#         file_map["$num"]="$ext"
#         (( num > max_index )) && max_index=$num
#     fi
# done

# # Step 3: Shift existing files backward starting from the max_index
# for ((i=max_index; i>=insert_position; i--)); do
#     current_name="$file_prefix$i${file_map[$i]}"
#     next_index=$((i + 1))
#     new_name="$file_prefix$next_index${file_map[$i]}"
#     if [[ -f "$current_name" ]]; then
#         mv "$current_name" "$new_name"
#     fi
# done

# # Step 4: Insert the new file
# # Get extension of new file
# new_ext=".${new_file_path##*.}"
# new_name="$file_prefix$insert_position$new_ext"
# cp "$new_file_path" "$new_name"

# echo "Inserted '$new_file_path' as '$new_name'."
