#!/bin/bash


for IP in `host $1 | grep "has address" | awk '{print $4}'` ; do
    echo iptables -A OUTPUT -d $IP  -j DROP
done
