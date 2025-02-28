#!/bin/bash

GITPATH=$( git rev-parse --show-toplevel )
mapfile SECRETPATH < <( find "$GITPATH" -name secrets.nix )
if [[ "${#SECRETPATH[@]}" -ne 1 ]] then
    echo "Error. More than one filepath with name 'secrets.nix' found."
    for p in ${SECRETPATH[@]}; do echo ">" $p; done 
    exit 1
fi

SECPATH="\$\{SECRETPATH%%[[:space:]]}"

if [[ $1 == "set" ]] then
	echo "Setting up ${SECPATH} in git index"
    git add --intent-to-add "${SECPATH}"
    git update-index --assume-unchanged "${SECPATH}"

elif [[ $1 == "unset" ]] then
	echo "Removing ${SECPATH} from git index"
    git update-index --force-remove "${SECPATH}"
else
    echo "Doing Nothing. Invalid option." 
fi
