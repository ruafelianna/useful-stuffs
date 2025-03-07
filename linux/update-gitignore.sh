#!/usr/bin/env bash

GITIGNORE=.gitignore

RM='rm -rf'
CURL='curl'
ECHO='printf'
CAT='cat'
TR=tr

gi_files=("Python" "VisualStudioCode" "VisualStudio")

gi_urls=( \
    "https://raw.githubusercontent.com/github/gitignore/refs/heads/main/Python.gitignore" \
    "https://raw.githubusercontent.com/github/gitignore/refs/heads/main/Global/VisualStudioCode.gitignore" \
    "https://raw.githubusercontent.com/github/gitignore/refs/heads/main/VisualStudio.gitignore" \
)

S='#'
LF='\n'

${RM} ${GITIGNORE}

index=0

for gi_file in "${gi_files[@]}"; do
    # create header
    length=${#gi_file}
    border_length=$((length + 4))
    border=$(${ECHO} "%${border_length}s" | ${TR} ' ' "${S}")
    ${ECHO} "${border}${LF}${S} ${gi_file} ${S}${LF}${border}${LF}${LF}" >> ${GITIGNORE}

    # download file and insert it into the result file
    ${CURL} ${gi_urls[${index}]} >> ${GITIGNORE}

    # add new lines
    ${ECHO} "${LF}${LF}" >> ${GITIGNORE}

    # increment index
    let index=${index}+1
done
