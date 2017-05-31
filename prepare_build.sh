#!/bin/bash

VDI_BASE=~/data_F18_core_linux.vdi 

VM=`VBoxManage list vms | grep ^\"F18-linux_default_ | tail -1 | awk '{print $2}'`
if [ ! -f data.vdi ] && [ -n "$VM" ] ; then
  echo erase old VM $VM
  VBoxManage unregistervm $VM --delete
fi


[ -f $VDI_BASE ]  || VBoxManage createmedium --size 20000 --format VDI --filename $VDI_BASE

[ -f data.vdi ] || VBoxManage clonemedium $VDI_BASE data.vdi

