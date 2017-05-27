#!/bin/bash

cd ~/signature-method/results/
# Find out which files git are taking care of.
GIT_LOCAL=( $(git ls-files) )
GIT_REMOTE=( $(ssh ozzy "cd signature-method/results; git ls-files") )

# Merge what git remotes locally and on remote, and remove duplicates.
TRACKED=("${GIT_LOCAL[@]}" "${GIT_REMOTE[@]}")

declare -A UNIQUE
# Store the values of TRACKED in UNIQUE as keys.
for k in "${TRACKED[@]}"; do UNIQUE["$k"]=1; done
# Extract the keys.
TRACKED=("${!UNIQUE[@]}")

printf 'Ignoring files tracked by git:\n'
printf '%s\n' ${TRACKED[*]} ''

# Explicityly construct string with many flags for excluding the traved files.
EXCLUDE=("${TRACKED[@]/#/--exclude }")
SOURCE="$OZZY:/home/exjobb_vikblom/signature-method/results/"
rsync -avz --exclude "*.p" ${EXCLUDE[*]} $SOURCE .

cd $OLDPWD
