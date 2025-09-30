#!/bin/bash

#source `dirname $0`/includes.sh

#set +o pipefail

function check() {
    HOST=$1
    PORT=$2
    PORT=${PORT:-443}

    nc -zv -w 1 $HOST $PORT &>/dev/null

    if [ $? != 0 ] ; then
        echo '****' "$HOST is NOT HEALTHY" '****'
    else
        echo "$HOST is healthy"
    fi
}

for HOST in andrew.theleehouse.net \
    cloud.theleehouse.net \
    img.steeplesoft.com \
    im.jasondl.ee \
    noah.theleehouse.net \
    repository.steeplesoft.com \
    mealie.theleehouse.net \
    theleehouse.net ; do

    check $HOST 443
done

check minecraft.theleehouse.net 25565
ssh jdlee@$vps2 "echo"
