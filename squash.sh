#!/bin/bash

MASTER=master
if git branch | grep -c " main$" &> /dev/null  ; then
    MASTER=main
fi

while getopts "b:" OPTION; do
    case $OPTION in
        b) MASTER=$OPTARG ;;
        *) echo "Unknown option: $OPTION" ; exit 1 ;;
    esac
done
shift $((OPTIND -1))

set -x

git --no-pager branch-log -b "$MASTER" "$*"

read -r -p "Enter the number of revisions required, then press enter to continue: " NUM


if [ "$NUM" != "" ] ; then
    git rebase -i HEAD~"$NUM"
else
    echo "No number entered. Aborting."
    exit 1
fi
