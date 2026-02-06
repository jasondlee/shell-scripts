#!/bin/bash

#source `dirname $0`/includes.sh

#set +o pipefail

function report() {
    HOST=$1
    STATUS=$2

    if [ $STATUS != 0 ] ; then
        echo '****' "$HOST is NOT HEALTHY" '****'
    else
        echo "$HOST is healthy"
    fi
}

function checkSite() {
    SITE=$1

    http --check-status --follow https://$SITE &>/dev/null

    report $SITE $?
}

function checkService() {
    HOST=$1
    PORT=$2
    PORT=${PORT:-443}

    nc -zv -w 1 $HOST $PORT &>/dev/null

    report $HOST $?
}

for HOST in andrew.theleehouse.net \
    cloud.theleehouse.net \
    img.steeplesoft.com \
    im.jasondl.ee \
    noah.theleehouse.net \
    repository.steeplesoft.com \
    board.theleehouse.net \
    mealie.theleehouse.net \
    theleehouse.net ; do

    checkSite $HOST
done

checkService minecraft.theleehouse.net 25565
ssh jdlee@$vps2 "echo"
