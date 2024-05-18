#!/bin/bash

set -eu

status() {
    echo ">>> $*" >&2
}

error() {
    echo "ERROR: $*"
    exit 1
}

warning() {
    echo "WARNING: $*"
}

cleanup() {
    echo
}

debug() {
    if [ "$DEBUG" == "true" ] ; then
        echo "$*"
    fi
}

pause() {
    if [ "$PAUSE_ENABLED" == "true" -o "$DEBUG" == "true" ] ; then
        read -p "Press enter..."
    fi
}

exiting() {
    echo
    error "CTRL-C pressed"
}

trap exiting SIGINT
trap cleanup EXIT
