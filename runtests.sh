#!/bin/bash

source `dirname $0`/includes.sh

SUSPEND=n
CLEAN=
TESTS=
OPTS=
DEBUG=false

function findtests() {
    debug "Looking for tests matching '$1'"
    SEP=
    for DIR in $( fd -t d $1 | sort -u ) ; do
        pause
        for FILE in $( fd -t f --base-directory "$DIR" -i test ) ; do
            FILE=`basename $FILE`
            FILE=$( echo $FILE | cut -f 1 -d . )
            TESTS="$TESTS$SEP$FILE"
            SEP=,
        done
    done
}

while getopts "cdD:Lp:P:sSt:w" opt ; do
    case "$opt" in
        c) CLEAN=clean ;;
        d) DEBUG=true ;;
        p) findtests "$OPTARG" ;;
        s) SUSPEND=y ;;
        t) TESTS="${TESTS}${OPTARG}" ;;
        w) WAIT=true ;;
        D) OPTS="$OPTS -D$OPTARG" ;;
        L) OPTS="$OPTS -Dlegacy-ee-full-server-tests -Dlegacy-ee-tests" ;;
        P) PROFILE=" -P$OPTARG" ;;
        S) SECMGR="-Dsecurity.manager=true" ;;
    esac
done

shift $((OPTIND -1))

if [ "$TESTS" == "" ] ; then
    findtests "$1"
fi

if [ "$TESTS" != "" ] ; then
    echo -e "Testing:\n    ${TESTS//,/$'\n    '}"
    echo -e "Testing:\n    ${TESTS}"
    if [ "$WAIT" == "true" ] ; then
        read -p "Press enter to begin..."
    fi
    COMMAND="mvn --fail-fast -Dsurefire.skipAfterFailureCount=1 -Dtestsuite.integration.container.logging=true -Dsuspend=$SUSPEND $PROFILE $SECMGR -Dtest="$TESTS" $OPTS $CLEAN test"
    debug "Executing '$COMMAND'"
    ${COMMAND}
else
   echo "No tests found for '$KEY'"
fi
