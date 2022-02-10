#!/usr/bin/env bash

set -euo pipefail

NAME="$1"
PAGES=$2
UNITE=""

for i in $(seq 1 $PAGES); do 
    if [ $PAGES == 1 ] ; then
        FILENAME="$NAME.pdf"
    else
        FILENAME="$NAME - $i.pdf"
    fi
    RC=-1
    while [ $RC -ne 0 ] ; do
        read -p "Press enter to continue..."
        hp-scan --size=letter -o "$FILENAME"
        RC=$?
        if [ $RC -ne 0 ] ; then
            echo Retrying...
        fi
    done
    #hp-scan -d hpaio:/net/Officejet_4630_series?zc=baljeet --size=letter -o "$NAME - $i.pdf";
done

if [ $PAGES -gt 1 ] ; then
    for i in $(seq 1 $PAGES); do
        N=`echo "$NAME - $i.pdf" | sed -e 's/ /\\\\ /g'`
        PARTS="$PARTS '$NAME - $i.pdf'"
    done
    CMD="pdfunite $PARTS '$NAME.pdf'"
    eval $CMD
    DEL="rm $PARTS"
    eval $DEL
    echo "Saved '$NAME.pdf'"
fi
