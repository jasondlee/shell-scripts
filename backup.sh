#!/bin/bash

set -euo pipefail

CMD=$1
DIR=$2

KEEP=7

function wrap_restic() {
    restic -r sftp:restic@perry:restic-repo --password-file=/home/jdlee/.restic \
        $*
}
function backup() {
    restic -r sftp:restic@perry:restic-repo --password-file=/home/jdlee/.restic \
        --exclude-file=/home/jdlee/src/personal/shell-scripts/backup.exclude \
        --cleanup-cache \
        backup \
        /etc/X11/xorg.conf.d/ \
        /etc/default/grub \
        /etc/fstab \
        /etc/hosts \
        /etc/sddm.conf \
        /etc/sddm/ \
        /etc/yum.repos.d/ \
        /home/jdlee
}

function cleanup() {
    restic -r sftp:restic@perry:restic-repo --password-file=/home/jdlee/.restic \
        forget \
        --keep-last $KEEP \
        --prune
}

function checkdir() {
    if [ "$DIR" == "" -o ! -e "$DIR" ] ; then
        echo "Please specify a target directory"
        exit 1
    fi
}

if [ "$CMD" == "backup" ] ; then
    backup
    cleanup
elif [ "$CMD" == "cleanup" ] ; then
    cleanup
elif [ "$CMD" == "restore" ] ; then
    checkdir 

    #restic -r sftp:restic@perry:restic-repo --password-file=/home/jdlee/.restic \
    wrap_restic restore latest --target $DIR
elif [ "$CMD" == "mount" ] ; then
    checkdir 

    #restic -r sftp:restic@perry:restic-repo --password-file=/home/jdlee/.restic \
    wrap_restic mount $DIR
elif [ "$CMD" == "list" ] ; then
    #restic -r sftp:restic@perry:restic-repo --password-file=/home/jdlee/.restic \
    wrap_restic --no-lock snapshots
elif [ "$CMD" == "unlock" ] ; then
    #restic -r sftp:restic@perry:restic-repo --password-file=/home/jdlee/.restic \
    wrap_restic unlock
elif [ "$CMD" == "status" ] ; then
    COUNT=`psg -ef | grep restic | grep -v grep | wc -l`
    if [ "$COUNT" == "1" ]; then
        echo Backup is running
    else
        echo Backup is not running
    fi
else
    echo "Unknown command: '$CMD'"
    exit 1
fi
