#!/bin/bash

set -eo pipefail  #u

PAUSE_ENABLED=false
DEBUG=false

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

register_exit() {
    echo
    trap $1 SIGINT
}

register_cleanup() {
    trap $1 EXIT
}

register_exit exiting
register_cleanup cleanup
