#!/bin/bash

# 1259  gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.6 -dPDFSETTINGS=/screen -dNOPAUSE -dQUIET -dBATCH -sOutputFile=Shout\ to\ the\ Lord.pdf Shout\ to\ the\ Lord_1.6.pdf
# gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.6 -dPDFSETTINGS=/screen -dNOPAUSE -dQUIET -dBATCH -sOutputFile=Shout\ to\ the\ Lord_1.6.pdf Shout\ to\ the\ Lord.pdf
# ll
# gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.5 -dPDFSETTINGS=/screen -dNOPAUSE -dQUIET -dBATCH -sOutputFile=Shout\ to\ the\ Lord_1.5.pdf Shout\ to\ the\ Lord.pdf
# gs -q -sDEVICE=pdfwrite -dCompatibilityLevel=1.6 -o Shout\ to\ the\ Lord_1.6.pdf Shout\ to\ the\ Lord.pdf
# gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.6 -o Shout\ to\ the\ Lord_1.6.pdf Shout\ to\ the\ Lord.pdf

TARGET=1.6


for F in *pdf ; do 
    VERS=`pdfinfo "$F" | grep -i 'pdf version' | cut -f 2 -d : | awk '{$1=$1};1'`
    if [ "$VERS" != "1.6" ] ; then
        echo "Converting $F from $VERS to $TARGET"
        cp "$F" "$F.$VERS"
        gs -q -sDEVICE=pdfwrite -dCompatibilityLevel=$TARGET -o "$F" "$F.$VERS"
        if [ $? == 0 ] ; then
            rm "$F.$VERS"
        fi
    fi
done
