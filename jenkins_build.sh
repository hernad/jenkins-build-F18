#!/bin/bash

SSH_DOWNLOAD_SERVER=docker@192.168.168.171
#FILE="F18_Windows_*.gz"
FILE="F18_Windows_`cat F18_VER`.gz"

DOWNLOADS_DIR=/data_0/f18-downloads_0/downloads.bring.out.ba/www/files/

[ -f data.vmdk ] || VBoxManage clonehd ~/data_core_base_windows.vmdk data.vmdk

[ -f hbwin.tar.gz ] && rm harbour.tar.gz

vagrant halt
vagrant --version
vagrant up --provision
vagrant halt

if ! ls $FILE>/dev/null ; then
   echo "$FILE not created ?!"
   exit 1
fi

[ -f .ssh_download_key ] || exit 1

echo "scp $SSH_DOWNLOAD_SERVER $DOWNLOADS_DIR" 

scp -i .ssh_download_key \
  -o StrictHostKeyChecking=no \
 $FILE \
 $SSH_DOWNLOAD_SERVER:$DOWNLOADS_DIR

ssh -i .ssh_download_key  $SSH_DOWNLOAD_SERVER  ls -lh $DOWNLOADS_DIR/$FILE

