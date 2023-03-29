#!/bin/bash

git branch-log

read -p "Enter the number of revisions required, then press enter to continue: " NUM

git rebase -i HEAD~$NUM
