#!/usr/bin/env bash

set -euo pipefail

if [ ! -e ~/GoogleDrive/Jason ] ; then
    googledrive_mount -f
fi
