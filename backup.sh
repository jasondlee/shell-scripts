#!/bin/bash

CMD=$1

        #--exclude /home/jdlee/Dropbox \
        #--exclude /home/jdlee/GoogleDrive \

if [ "$CMD" == "backup" ] ; then
    restic -r sftp:backup@perry:restic-repo  \
        --password-file=/home/jdlee/.restic \
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
elif [ "$CMD" == "cleanup" ] ; then
    restic -r sftp:backup@perry:restic-repo  \
        --password-file=/home/jdlee/.restic \
        forget \
        --keep-last 30 \
        --prune
elif [ "$CMD" == "restore" ] ; then
    DIR=$2
    
    if [ "$DIR" == "" -o ! -e "$DIR" ] ; then
        echo "Please specify a target directory"
        exit 1
    fi

    restic -r sftp:backup@perry:restic-repo \
        --password-file=/home/jdlee/.restic \
        restore \
        latest \
        --target $2
else
    echo "Unknown command: '$CMD'"
    exit 1
fi
