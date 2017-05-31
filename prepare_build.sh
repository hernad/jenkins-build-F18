#!/bin/bash

PATH=/opt/VirtualBox:$PATH

VDI_BASE=~/data_F18_core_linux.vdi 
WORKSPACE=F18-linux-i386

if [ ! -f data.vdi ] ; then

  VM=`VBoxManage list vms | grep ^\"${WORKSPACE}_default_ | tail -1 | awk '{print $2}'`
  if [ -n "$VM" ] ; then
    echo "erasing old VM $VM"
    VBoxManage unregistervm $VM --delete
  else
    echo "no old VM F18-linux-i386"
  fi

  HDD=`VBoxManage list hdds -l | grep "Location.*workspace/${WORKSPACE}/data.vdi" -B7 | grep "^UUID:" | awk '{print $2}'`
  if [ -n "$HDD" ] ; then
     echo "erasing old HDD"
     VBoxManage closemedium $HDD --delete
  else
     echo "no old HDD ${WORKSPACE}/data.vdi"
  fi

fi

[ -f $VDI_BASE ]  || VBoxManage createmedium --size 20000 --format VDI --filename $VDI_BASE

[ -f data.vdi ] || VBoxManage clonemedium $VDI_BASE data.vdi

