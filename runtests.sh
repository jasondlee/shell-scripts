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

while getopts "t:sc" opt ; do
    case "$opt" in
        t) findtests "$OPTARG" ;;
        s) SUSPEND=y ;;
        c) CLEAN=clean ;;
    esac
done

shift $((OPTIND -1))

if [ "$TESTS" == "" ] ; then
    findtests "$1"
fi

if [ "$TESTS" != "" ] ; then
    mvn $CLEAN test -Dtest="$TESTS" -Dtestsuite.integration.container.logging=true -Dsuspend=$SUSPEND
else
   echo "No tests found for '$KEY'"
fi
