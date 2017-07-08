#!/bin/bash

SSH_DOWNLOAD_SERVER=docker@192.168.168.171

DOWNLOADS_DIR=/data_0/f18-downloads_0/downloads.bring.out.ba/www/files/

./prepare_build.sh


RUNNINGVM=`VBoxManage list runningvms | grep F18-linux-i386 | awk '{ print $2 }'`
if [ ! -z "$RUNNINGVM" ] ; then
  VBoxManage controlvm $RUNNINGVM poweroff
  VBoxManage unregistervm $RUNNINGVM --delete
fi

cp Vagrantfile.jenkins Vagrantfile
vagrant --version
vagrant up --provision
vagrant halt

#F18_VER is generated in the build process
FILE="F18_Ubuntu_i686_`cat F18_VER`.gz"

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

