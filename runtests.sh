#!/bin/bash

source `dirname $0`/includes.sh

SUSPEND=n
CLEAN=
TESTS=

function findtests() {
    SEP=
    for DIR in $( fd -t d $1 | sort -u ) ; do
        pause
        for FILE in $( fd -t f --base-directory "$DIR" -i test ) ; do
            FILE=`basename $FILE`
            FILE=$( echo $FILE | cut -f 1 -d . )
            TESTS="$TESTS$SEP$FILE"
            SEP=,
            pause
        done
    done
}

while getopts "p:t:scP:" opt ; do
    case "$opt" in
        p) findtests "$OPTARG" ;;
        t) TESTS="$OPTARG" ;;
        s) SUSPEND=y ;;
        c) CLEAN=clean ;;
        P) PROFILE=" -D$OPTARG"
    esac
done

shift $((OPTIND -1))

if [ "$TESTS" == "" ] ; then
    findtests "$1"
fi

if [ "$TESTS" != "" ] ; then
    mvn $CLEAN test -Dtest="$TESTS" -Dtestsuite.integration.container.logging=true -Dsuspend=$SUSPEND $PROFILE
else
   echo "No tests found for '$KEY'"
fi
