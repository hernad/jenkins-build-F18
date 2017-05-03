#!/bin/bash


echo ======== mkpart ==============

if [ -e /dev/sdb1 ] ; then
   sudo parted /dev/sdb mklabel gpt mkpart P1 ext4 1MiB 100%
fi

echo ======== mount /data =====================

[ -d /data ]  || mkdir -p /data

if ( ! mount | grep -q \/data ) ; then
   sudo mount /dev/sdb1 /data
else
   echo /data mounted
fi

echo ========= install dev deps ==========================
sudo apt-get -y update
sudo apt-get -y install build-essential flex bison libpq-dev


echo ======== /data/build =====================

if [ ! -d /data/hb-linux-i386 ] ; then
  curl -LO http://download.bring.out.ba/hb-linux-i386.tar.gz
  tar xvfz hb-linux-i386.tar.gz
fi
 
[ -d /data/build ] || sudo mkdir -p /data/build
sudo chown vagrant /data/build 

cd /data/build

git clone https://github.com/knowhow/F18_knowhow.git
cd F18_knowhow
git checkout 23100-ld -f
git pull

export PATH=/data/hb-linux-i386/bin:$PATH

echo ======== /data/build/F18_knowhow  =====================

source scripts/ubuntu_env.sh
./build.sh

