#!/bin/bash

if [ ! -e ~/.chevup ] ; then
    echo Config file not found at ~/.chevup
    exit -1
fi


source ~/.chevup

SOURCE=$1
OPTIONS="-s -o /dev/null -w %{redirect_url} -X POST"
OPTIONS="-q -X POST"
BASEURL="$chevsite/myapi/1/upload/?key=$chevapikey&format=json"

if [[ $SOURCE != http* ]] ; then
    #SOURCE=`base64 $SOURCE` # | tr -d '\n'`
    OUTPUT=`curl $OPTIONS "$BASEURL" -F "source=@$SOURCE"`
else
    OUTPUT=`curl $OPTIONS "$BASEURL&source=$SOURCE"`
fi

if [ $? == 0 ] ; then
	OUTPUT=`echo $OUTPUT | jq .image.display_url | tr -d '"'`
	echo $OUTPUT
fi
