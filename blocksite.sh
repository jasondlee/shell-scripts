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
    sudo cp "$FILE" "$TEMP_FILE"
    sudo sed -i'' -e 's/^COMMIT//g' "$TEMP_FILE"
    echo -e "$*" >> "$TEMP_FILE"
    sudo cp "$TEMP_FILE" "$FILE"
}

echo Processing IPV4
for IP in $( host "$HOST" | grep "has address" | awk '{print $4}' ) ; do
    echo "Checking $IP"
    #sudo grep -R "$IP" $IPTABLES_FILE &> /dev/null
    if ! sudo grep -R "$IP" $IPTABLES_FILE &> /dev/null ; then
        addToFile $IPTABLES_FILE "-A INPUT -p tcp -d $IP -j REJECT"
        addToFile $IPTABLES_FILE "-A OUTPUT -p tcp -d $IP -j REJECT"q
    fi
done

echo Processing IPV6
for IP in $( host "$HOST" | grep "has IPv6 address" | awk '{print $5}' ) ; do
    echo "Checking $IP"
    #set -x
    #COUNT=$( sudo cat "$IP6TABLES_FILE" | grep "$IP" | wc -l )
    #sudo grep -R "$IP" "$IP6TABLES_FILE" &>/dev/null
    if ! sudo grep -R "$IP" "$IP6TABLES_FILE" &>/dev/null ; then
        addToFile "$IP6TABLES_FILE" "-A INPUT -s $IP -j REJECT"
        addToFile "$IP6TABLES_FILE" "-A OUTPUT -d $IP -j REJECT"
    fi
done

if [ "$PERM" == "true" ] ; then
    addToFile "$IPTABLES_FILE" "COMMIT"
    addToFile "$IP6TABLES_FILE" "COMMIT"
fi

# iptables -A OUTPUT -p tcp -m string --string "tweetdeck.com" --algo kmp -j REJECT

sudo iptables-restore /etc/sysconfig/iptables
sudo ip6tables-restore /etc/sysconfig/ip6tables
