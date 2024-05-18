#!/bin/bash

source `dirname $0`/includes.sh

INPUT="$*"
MXL=$( echo $INPUT | sed -e 's/\.pdf/\.mxl/' )
MS=$( echo $INPUT | sed -e 's/\.pdf/\.mscz/' )

set -x
echo "Convering $INPUT into MusicXML"
audiveris -export -batch -output . "$*" &>/dev/null
echo "Converting $MXL into MuseScore"
mscore "$MXL" -o "$MS" &>/dev/null
rm "$MXL" *omr *log
