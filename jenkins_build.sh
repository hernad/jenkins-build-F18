#!/bin/bash

SSH_DOWNLOAD_SERVER=docker@192.168.168.171
WORKSPACE=F18-windows

if [ -n $2 ] ; then
   F18_VER_MAJOR=$1
   F18_VARIJANTA=$2

   echo ${F18_VER_MAJOR}-${F18_VARIJANTA} > F18_BRANCH
else
   echo 23100-ld > F18_BRANCH
fi

if [ ! -f data.vmdk ] ; then

  VM=`VBoxManage list vms | grep ^\"${WORKSPACE}_default_ | tail -1 | awk '{print $2}'`
  if [ -n "$VM" ] ; then
    echo "erasing old VM $VM"
    VBoxManage unregistervm $VM --delete
  else
    echo "no old VM F18-windows"
  fi

  HDD=`VBoxManage list hdds -l | grep "Location.*workspace/${WORKSPACE}/data.vmdk" -B7 | grep "^UUID:" | awk '{print $2}'`
  if [ -n "$HDD" ] ; then
     echo "erasing old HDD"
     VBoxManage closemedium $HDD --delete
  else
     echo "no old HDD ${WORKSPACE}/data.vmdk"
  fi

fi


DOWNLOADS_DIR=/data_0/f18-downloads_0/downloads.bring.out.ba/www/files/

[ -f data.vmdk ] || VBoxManage clonehd ~/data_core_base_windows.vmdk data.vmdk

[ -f hbwin.tar.gz ] && rm harbour.tar.gz

vagrant halt
vagrant --version
vagrant up --provision
vagrant halt

#F18_VER is generated in the build process
FILE="F18_Windows_`cat F18_VER`.gz"

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

