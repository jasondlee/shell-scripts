#!/usr/bin/env bash

set -euo pipefail

LOCAL="/home/jdlee/local/bin"
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
    fi
else
    install "$1"
fi
