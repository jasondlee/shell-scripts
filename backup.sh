#!/bin/bash

CMD=$1

if [ "$CMD" == "backup" ] ; then
    restic -r sftp:backup@perry:restic-repo  \
        --password-file=/home/jdlee/.restic \
        --exclude /home/jdlee/Dropbox \
        --exclude /home/jdlee/GoogleDrive \
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
elif [ "$CMD" == "cleanup" ] ; then
    restic -r sftp:backup@perry:restic-repo  \
        --password-file=/home/jdlee/.restic \
        forget \
        --keep-last 30 \
        --prune
else
    echo "Unknown command: '$CMD'"
    exit 1
fi