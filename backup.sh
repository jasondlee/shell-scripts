#!/bin/bash


export RESTIC_PASSWORD_FILE=~/.restic

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

	#/home/jdlee/.bash.aliases \
	#/home/jdlee/.bash_profile \
	#/home/jdlee/.bashrc \
	#/home/jdlee/.chevup \
	#/home/jdlee/.config/Slack/ \
	#/home/jdlee/.config/autostart/ \
	#/home/jdlee/.config/dolphinrc \
	#/home/jdlee/.config/konsolerc \
	#/home/jdlee/.config/mimeapps.list \
	#/home/jdlee/.config/quassel-irc.org/ \
	#/home/jdlee/.config/quasselrc \
	#/home/jdlee/.dropbox/ \
	#/home/jdlee/.envvars \
	#/home/jdlee/.functions \
	#/home/jdlee/.gdfuse/ \
	#/home/jdlee/.git-credentials \
	#/home/jdlee/.gitconfig \
	#/home/jdlee/.gitconfig-personal \
	#/home/jdlee/.gitconfig-work \
	#/home/jdlee/.gitignore \
	#/home/jdlee/.gnupg/ \
	#/home/jdlee/.local/share/applications/ \
	#/home/jdlee/.purple/ \
	#/home/jdlee/.ssh/ \
	#/home/jdlee/.thunderbird/ \
	#/home/jdlee/.viminfo \
	#/home/jdlee/.vimrc \
	#/home/jdlee/.vscode/ \
	#/home/jdlee/Documents/ \
	#/home/jdlee/Downloads/ \
	#/home/jdlee/Music/ \
	#/home/jdlee/Pictures/ \
	#/home/jdlee/Videos/ \
	#/home/jdlee/src/ 
