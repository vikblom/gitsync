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

GIT_FROM=$( parse_target $1 )
echo ${GIT_FROM[*]}

GIT_TO=$( parse_target $2 )
echo ${GIT_TO[*]}

# Merge what git remotes locally and on remote, and remove duplicates.
TRACKED=("${GIT_FROM[@]}" "${GIT_TO[@]}")
echo ${TRACKED[*]}

#declare -A UNIQUE
# Store the values of TRACKED in UNIQUE as keys.
#for k in "${TRACKED[@]}"; do UNIQUE["$k"]=1; done
# Extract the keys.
#TRACKED=("${!UNIQUE[@]}")
#echo ${TRACKED[*]}

#printf 'Ignoring files tracked by git:\n'
#printf '%s\n' ${TRACKED[*]} ''

# Explicityly construct string with many flags for excluding the traved files.
#EXCLUDE=("${TRACKED[@]/#/--exclude }")
#SOURCE="$OZZY:/home/exjobb_vikblom/signature-method/results/"
#rsync -avz --exclude "*.p" ${EXCLUDE[*]} $SOURCE .
