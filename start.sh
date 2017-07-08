#!/bin/bash


F18_FONT=xfonts-terminus-oblique

if ! dpkg -l $F18_FONT
   apt-get install -y $F18_FONT
fi
 
sudo mount -t vboxsf -o uid=$UID,gid=$(id -g) vagrant /vagrant

if ! cat /proc/mounts | grep /data ; then
  sudo mount /dev/sdb1 /data
fi

