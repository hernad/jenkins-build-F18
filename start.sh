#!/bin/bash

sudo mount -t vboxsf -o uid=$UID,gid=$(id -g) vagrant /vagrant

if ! cat /proc/mounts | grep /data ; then
  sudo mount -o uid=$UID,gid=$(id -g)  /dev/sdb1 /data
fi

