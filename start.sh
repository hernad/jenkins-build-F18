#!/bin/bash

sudo mount -t vboxsf -o uid=$UID,gid=$(id -g) vagrant /vagrant

sudo mount /dev/sdb1 /data
