#!/bin/bash

#if [[ $# -lt 2 ]]; then
#    echo 'Usage: "gitsync host:from_path to_path"'
#    exit 1
#fi

parse_target() {
    if [[ $1 == *':'* ]] # If taget is on a different host
    then
        IFS=':' read -a arr <<< "$1"
        HOST=${arr[0]}
        DIR=${arr[1]}
        ssh $HOST "git -C $DIR ls-files" 2> /dev/null
    else # Assume it is on this computer
        DIR=$1
        git -C $DIR ls-files 2> /dev/null
    fi
}


GIT_FROM=(`parse_target $1`)
#echo "From:" "${GIT_FROM[@]}"
GIT_TO=(`parse_target $2`)
#echo "To:" "${GIT_TO[@]}"

TRACKED=( "${GIT_FROM[@]}" "${GIT_TO[@]}" )
#echo "Tracked:" "${TRACKED[@]}"

declare -A UNIQUE # Use an associative array to remove duplicates
for k in "${TRACKED[@]}"; do UNIQUE["$k"]=1; done
TRACKED=("${!UNIQUE[@]}")
echo "Unique:" ${TRACKED[@]}


# Explicityly construct string with many flags for excluding the traved files.
EXCLUDE=("${TRACKED[@]/#/--exclude }")
echo "Excluding:" ${EXCLUDE[@]}
rsync --dry-run -avz --cvs-exclude ${EXCLUDE[@]} $1 $2
