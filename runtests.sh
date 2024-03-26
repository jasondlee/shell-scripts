#!/bin/bash

KEY=$1
shift

function pause() {
    echo
    #read -p "Press enter..."
}

for DIR in $( fd -t d $KEY | sort -u ) ; do
    echo DIR=$DIR
    pause
    for FILE in $( fd -t f --base-directory "$DIR" -i test ) ; do
        FILE=`basename $FILE`
        FILE=$( echo $FILE | cut -f 1 -d . )
        TESTS="$TESTS,$FILE"
    done
    pause
done

if [ "$TESTS" != "" ] ; then
    mvn clean test -Dtest="$TESTS" -Dtestsuite.integration.container.logging=true $*
else
   echo "No tests found for '$KEY'"
fi
