#!/bin/bash

CMD=$1
DIR=$2

function backup() {
    restic -r sftp:backup@perry:restic-repo --password-file=/home/jdlee/.restic \
        --exclude-file=/home/jdlee/src/steeplesoft/shell-scripts/backup.exclude \
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
    restic -r sftp:backup@perry:restic-repo --password-file=/home/jdlee/.restic \
        forget \
        --keep-last 168 \
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

    restic -r sftp:backup@perry:restic-repo --password-file=/home/jdlee/.restic \
        restore \
        latest \
        --target $DIR
elif [ "$CMD" == "restore" ] ; then
    checkdir 

    restic -r sftp:backup@perry:restic-repo --password-file=/home/jdlee/.restic \
        mount \
        $DIR
elif [ "$CMD" == "list" ] ; then
    restic -r sftp:backup@perry:restic-repo --password-file=/home/jdlee/.restic \
        snapshots
else
    echo "Unknown command: '$CMD'"
    exit 1
fi
