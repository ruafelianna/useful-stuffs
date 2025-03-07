#!/usr/bin/env bash

# dependencies check

if ! command -v curl &> /dev/null; then
    echo "Error: curl is required!" >&2
    exit 1
fi

# config

GITIGNORE='.gitignore'

REPO='https://raw.githubusercontent.com/github/gitignore/refs/heads/main'

declare -A GI_FILES=(
    ['Python']="${REPO}/Python.gitignore"
    ['VisualStudio']="${REPO}/VisualStudio.gitignore"
    ['VisualStudioCode']="${REPO}/Global/VisualStudioCode.gitignore"
)

# script

rm -rf "${GITIGNORE}"

for gi_file in "${!GI_FILES[@]}"; do
    # create header
    let border_length=${#gi_file}+4
    border=$(printf "%${border_length}s" | tr ' ' '#')
    printf "${border}\n# ${gi_file} #\n${border}\n\n" >> "${GITIGNORE}"

    # download file and insert it into the result file
    url="${GI_FILES[$gi_file]}"
    echo "Downloading ${gi_file}..."
    if curl -fsSL "${url}" >> "${GITIGNORE}"; then
        echo "Success."
        printf "\n\n" >> "${GITIGNORE}"
    else
        echo "Failed to download ${gi_file}." >&2
    fi
done
