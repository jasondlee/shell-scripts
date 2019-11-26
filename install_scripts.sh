#!/bin/bash

BIN="common/bin"
LOCAL="/usr/local/bin"
NLROOT=${NLROOT:-/webdev}
SRCDIR=`pwd`

function install() {
    DIR=$1
    for FILE in * ; do
        if [ "$FILE" != "`basename $0`" ] ; then
            echo Installing $FILE in $DIR
            if [ "$OS" == "Windows_NT" ] ; then
                echo -e "#/bin/bash\n$SRCDIR/$FILE \$*" > $DIR/$FILE
                chmod go+rx $DIR/$FILE
            else
                ln -sf `pwd`/$FILE $DIR/$FILE
            fi
        fi
    done
}

if [ "$1" == "" ] ; then
    if [ -w $LOCAL ] ; then
        install $LOCAL
    else
        for DIR in `ls -d $NLROOT/NetLedger*` ; do
            if [ -e $DIR/$BIN ] ; then
                install $DIR/$BIN
            fi
        done
    fi
else
    install "$1"
fi
