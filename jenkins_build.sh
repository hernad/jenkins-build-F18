#!/bin/bash

WORKSPACE=F18_linux_i386_std
 
if [ -n $2 ] ; then
   F18_VER_MAJOR=$1
   F18_VARIJANTA=$2

   echo ${F18_VER_MAJOR}-${F18_VARIJANTA} > F18_BRANCH
else
   echo 23100-ld > F18_BRANCH
fi

SSH_DOWNLOAD_SERVER=docker@192.168.168.171

DOWNLOADS_DIR=/data_0/f18-downloads_0/downloads.bring.out.ba/www/files/


if [ ! -f data.vdi ] ; then

  VM=`VBoxManage list vms | grep ^\"${WORKSPACE}_default_ | tail -1 | awk '{print $2}'`
  if [ -n "$VM" ] ; then
    echo "erasing old VM $VM"
    VBoxManage unregistervm $VM --delete
  else
    echo "no old VM $WORKSPACE"
  fi

  HDD=`VBoxManage list hdds -l | grep "Location.*workspace/${WORKSPACE}/data.vdi" -B7 | grep "^UUID:" | awk '{print $2}'`
  if [ -n "$HDD" ] ; then
     echo "erasing old HDD"
     VBoxManage closemedium $HDD --delete
  else
     echo "no old HDD ${WORKSPACE}/data.vdi"
  fi

fi

RUNNINGVM=`VBoxManage list runningvms | grep $WORKSPACE | awk '{ print $2 }'`
if [ ! -z "$RUNNINGVM" ] ; then
  VBoxManage controlvm $RUNNINGVM poweroff
  VBoxManage unregistervm $RUNNINGVM --delete
fi


./prepare_build.sh

cp Vagrantfile.jenkins Vagrantfile
vagrant --version
vagrant up --provision
vagrant halt

[ -f .ssh_download_key ] || exit 1
echo "parametri download servera: $SSH_DOWNLOAD_SERVER $DOWNLOADS_DIR" 

for f in F18_VER F18_VER_E F18_VER_X ; do

   if [ ! -f $f ] ; then
     echo "no version file $f continue ..."
     continue
   fi

   VER=`cat $f`
   FILE="F18_Ubuntu_i686_${VER}.gz"

   echo "scp $VER - file: $FILE -> download server"

   if ! ls $FILE>/dev/null ; then
       echo "$FILE not created ?!"
       exit 1
   fi

   scp -i .ssh_download_key \
      -o StrictHostKeyChecking=no \
      $FILE \
      $SSH_DOWNLOAD_SERVER:$DOWNLOADS_DIR

   ssh -i .ssh_download_key  $SSH_DOWNLOAD_SERVER  ls -lh $DOWNLOADS_DIR/$FILE

done

exit 0
