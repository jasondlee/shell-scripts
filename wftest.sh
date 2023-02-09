#!/bin/bash

export SDKMAN_DIR="/home/jdlee/.sdkman"
[[ -s "/home/jdlee/.sdkman/bin/sdkman-init.sh" ]] && source "/home/jdlee/.sdkman/bin/sdkman-init.sh"

function selectJdk11() {
    CANDIDATE=$( sdk list java | grep 11. | grep -E 'installed|local' | head -1 )
    if [ "$CANDIDATE" != "" ] ; then
        CANDIDATE=$( echo $CANDIDATE | cut -f 6 -d '|' )
        echo "Using $CANDIDATE"
        sdk use java $CANDIDATE
    else
        echo "Unable to find a JDK 11 installation"
        exit -1
    fi
}

CURRENT=$( sdk list java | grep -E '>>>' | head -1  | cut -f 6 -d '|' )
echo "Current JDK: $CURRENT"

if [ "$1" == "-11" ] ; then
    selectJdk11
fi

echo Test JDK: $( sdk list java | grep -E '>>>' | head -1  | cut -f 6 -d '|' )


echo "Run WildFly test suite:"
echo "1) Standard"
echo "2) Bootable Jar"
echo "3) Galleon"
echo "4) MicroProfile"
echo "5) Preview"

read -p "Select test suite:  " SUITE

case "$SUITE" in
    "1")
        OPTS="-DallTests -DlegacyBuild -DlegacyRelease -Dignore.ARTEMIS-2800"
        ;;
    "2")
        OPTS="-Dts.bootable"
        ;;
    "3")
        OPTS="-Dts.layers -Dts.galleon"
        ;;
    "4")
        OPTS="-Dts.standalone.microprofile"
        ;;
    "5")
        OPTS="-Dts.ee9 -Dts.preview"
        ;;
esac


mvn -fae -B -Dinsecure.repositories=WARN -Dipv6 -Djboss.test.transformers.eap -Dci-cleanup=true $OPTS clean install

sdk use java $CURRENT