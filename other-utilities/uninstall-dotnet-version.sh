#!/usr/bin/env bash

declare -a DOTNET_PATHS=(
    "$DOTNET_ROOT/host/fxr"
    "$DOTNET_ROOT/packs/Microsoft.AspNetCore.App.Ref"
    "$DOTNET_ROOT/packs/Microsoft.NETCore.App.Host.linux-x64"
    "$DOTNET_ROOT/packs/Microsoft.NETCore.App.Ref"
    "$DOTNET_ROOT/sdk"
    "$DOTNET_ROOT/sdk-manifests"
    "$DOTNET_ROOT/shared/Microsoft.AspNetCore.App"
    "$DOTNET_ROOT/shared/Microsoft.NETCore.App"
    "$DOTNET_ROOT/templates"
)

version_to_uninstall="$1"

if [[ "$version_to_uninstall" == "" ]]; then
    echo "A version string or substring is required."
    exit 1
fi

declare -a to_delete=()

for base_path in "${DOTNET_PATHS[@]}"
do
    readarray -d '' contents < <(find $base_path -maxdepth 1 -type d -print0)

    for directory in "${contents[@]}"
    do
        if [[ "$directory" == *"/$version_to_uninstall"* ]]; then
            to_delete+=("$directory")
        fi
    done
done

if [[ "${#to_delete[@]}" == "0" ]]; then
    echo "No versions matching '$version_to_uninstall' were found."
    exit 0
fi

echo -e "The following directories will be removed:\n"
printf "%s\n" "${to_delete[@]}"
echo -e ""

while :
do
    read -n 1 -p "Do you wish to proceed? (y/n)? " answer

    case $answer in
        y|Y) break ;;
        n|N) echo -e "" && exit 0 ;;
        *) echo -e "\nPlease answer 'y' or 'n'." ;;
    esac
done

echo -e "\n"

for directory in "${to_delete[@]}"
do
    echo "Deleting $directory..."
    rm -rf "$directory"
done

echo -e "\nFinished!"
