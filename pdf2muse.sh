#!/bin/bash

source `dirname $0`/includes.sh
DIR=.

while getopts "i:d:" OPTION; do
    case $OPTION in
        d) DIR=$( basename $OPTARG ) ;;
        i) INPUT="$OPTARG" ;;
        *)
            echo "Incorrect options provided"
            exit 1
            ;;
    esac
done

if [ -z "$INPUT" ] ; then
    echo Input file not specified
    exit -1
fi

MXL=$( echo $INPUT | sed -e 's/\.pdf/\.mxl/' )
MS=$( echo $INPUT | sed -e 's/\.pdf/\.mscz/' )

MXL="$DIR/MusicXML/$MXL"
MS="$DIR/$MS"

if [ ! -e "$MXL" ] ; then
    echo "Converting $INPUT into MusicXML"
    audiveris -export -batch -output "$DIR/MusicXML" "$INPUT" &>/dev/null
    echo "Converting $MXL into MuseScore"
    mscore --force -o "$MS" "$MXL" #&>/dev/null
    rm $DIR/*omr $DIR/*log
fi
