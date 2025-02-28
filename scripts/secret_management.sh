#!/bin/bash

SECRETNAME="secrets.nix"
GITPATH=$( git rev-parse --show-toplevel )
mapfile SECRETPATH < <( find "$GITPATH" -name "${SECRETNAME}"  2> /dev/null )
if [[ "${#SECRETPATH[@]}" -ne 1 ]]; then
    echo "Error. More than one filepath with name '${SECRETNAME}' found."
    for p in "${SECRETPATH[@]}"; do echo ">" "$p"; done 
    exit 1
fi

SECPATH="${SECRETPATH%%[[:space:]]}"

if [[ $1 == "set" ]]; then
	echo "Setting up ${SECPATH} in git index"
    git add --intent-to-add "${SECPATH}"
    git update-index --assume-unchanged "${SECPATH}"

elif [[ $1 == "unset" ]]; then
	echo "Removing ${SECPATH} from git index"
    git update-index --force-remove "${SECPATH}"
elif [[  "-h --help" =~ $1  ]]; then
	echo ""
	echo "Usage:"
	echo "    As a flake installable: nix run [installable] [set|unset]"
	echo "    As a standalone script: ./secret_management.sh [set|unset]"
	echo ""
	echo "Makes a selected file visible during evaluation while ensuring"
	echo "that sensitive contents don't get added to your git tree."
	echo ""
	echo "set: Run commands needed to make a file seem always up to date"
	echo "without adding its contents to the repo."
	echo ""
	echo "unset: Reverse this, and remove all reference to the file from"
	echo "git's tracking (without modifying the file itself)"
	echo ""
	echo "-h/--help: Print this text"

else
    echo "Doing Nothing. Invalid option." 
fi
