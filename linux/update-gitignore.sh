#!/usr/bin/env bash

GITIGNORE=.gitignore
GITIGNORE_DIR=${GITIGNORE}.d

RM='rm -rf'
MKDIR='mkdir -p'
CURL='curl -o'
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

${RM} ${GITIGNORE_DIR}
${MKDIR} ${GITIGNORE_DIR}

${RM} ${GITIGNORE}

index=0

for gi_file in "${gi_files[@]}"; do
    file_path="${GITIGNORE_DIR}/${gi_file}${GITIGNORE}"

    # download
    ${CURL} ${file_path} ${gi_urls[${index}]}

    # create header
    length=${#gi_file}
    border_length=$((length + 4))
    border=$(${ECHO} "%${border_length}s" | ${TR} ' ' "${S}")
    ${ECHO} "${border}${LF}${S} ${gi_file} ${S}${LF}${border}${LF}${LF}" >> ${GITIGNORE}

    # insert file into the result file
    ${CAT} ${file_path} >> ${GITIGNORE}

    # add new lines
    ${ECHO} "${LF}${LF}" >> ${GITIGNORE}

    # increment index
    let index=${index}+1
done

${RM} ${GITIGNORE_DIR}
