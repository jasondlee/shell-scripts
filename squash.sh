#!/bin/bash

git branch-log $*

read -p "Enter the number of revisions required, then press enter to continue: " NUM


if [ "$NUM" != "" ] ; then
    git rebase -i HEAD~$NUM
else
    echo "No number entered. Aborting."
    exit -1
fi
