#!/bin/bash

for CMD in "$@" ; do
    eval $CMD
    RC=$?
    if [ $RC != 0 ] ; then
        echo "Failed executing '$CMD'"
        exit $RC
    fi
done