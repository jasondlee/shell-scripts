#!/usr/bin/env bash

set -euo pipefail

# original credit to http://stackoverflow.com/questions/372506/how-can-i-search-git-branches-for-a-file-or-directory/372654#372654
# https://gist.github.com/anonymous/62d981890eccb48a99dc#file-gitfind-sh
# usage: "gitfind.sh <regex>"

LOC=refs/heads  # to search local branches only                                                                                                    

while getopts "r" OPTION; do
    case $OPTION in
        r) LOC=refs/remotes/origin ;;
    esac
done
shift $((OPTIND -1))

for branch in `git for-each-ref --format="%(refname)" $LOC`; do
  found=$(git ls-tree -r --name-only $branch | grep "$1")
  if [ $? -eq 0 ]; then
    echo ${branch#$LOC/}:; echo "  $found"
  fi
done
