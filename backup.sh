#!/bin/bash

restic -r sftp:backup@perry:restic-repo --verbose \
    --password-file=/home/jdlee/.restic \
    --exclude /home/jdlee/Dropbox \
    --exclude /home/jdlee/GoogleDrive \
    backup \
    /etc/X11/xorg.conf.d/ \
    /etc/default/grub \
    /etc/fstab \
    /etc/hosts \
    /etc/sddm.conf \
    /etc/sddm/ \
    /etc/yum.repos.d/ \
    /home/jdlee
