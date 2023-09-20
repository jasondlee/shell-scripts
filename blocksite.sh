#!/bin/bash

PERM=true
IPTABLES_FILE=/etc/sysconfig/iptables
IP6TABLES_FILE=/etc/sysconfig/ip6tables

while [ "$1" != "" ] ; do
    OPT="$1"
    if [ "$OPT" == "-t" ] ; then
        PERM=false
    else
        HOST=$OPT
    fi
    shift
done

function addToFile() {
    FILE=$1
    shift
    TEMP_FILE=$( mktemp ) || exit
    sudo cp $FILE $TEMP_FILE
    sudo sed -i'' -e 's/^COMMIT//g' $TEMP_FILE
    echo -e "$*" >> $TEMP_FILE
    sudo cp $TEMP_FILE $FILE
}

for IP in `host $HOST | grep "has address" | awk '{print $4}'` ; do
    echo "Blocking $IP"
    COUNT=`sudo cat $IPTABLES_FILE | grep $IP | wc -l`
    if [ "$COUNT" == "0" ] ; then
        BLOCK="-A OUTPUT -p tcp -d $IP -j REJECT" #-j DROP"
        sudo iptables $BLOCK
        if [ "$PERM" == "true" ] ; then
            addToFile $IPTABLES_FILE "$BLOCK"
        fi
    fi
done

for IP in `host $HOST | grep "has IPv6 address" | awk '{print $5}'` ; do
    echo "Blocking $IP"
    OUTPUT="-A OUTPUT -d $IP -j REJECT"
    INPUT="-A INPUT -s $IP -j REJECT"
    COUNT=`sudo cat $IP6TABLES_FILE | grep $IP | wc -l`
    if [ "$COUNT" == "0" ] ; then
        sudo ip6tables $INPUT
        sudo ip6tables $OUTPUT

        if [ "$PERM" == "true" ] ; then
            addToFile $IP6TABLES_FILE "$INPUT"
            addToFile $IP6TABLES_FILE "$OUTPUT"
        fi
    fi
done

if [ "$PERM" == "true" ] ; then
    DATE=`date +%Y-%m-%d`
    addToFile $IPTABLES_FILE "COMMIT"
    addToFile $IP6TABLES_FILE "COMMIT"
fi

# iptables -A OUTPUT -p tcp -m string --string "tweetdeck.com" --algo kmp -j REJECT
