#!/bin/bash


echo ======== mkpart ==============

if [ ! -e /dev/sdb1 ] ; then
   sudo parted /dev/sdb mklabel gpt mkpart P1 ext4 1MiB 100%
   sudo mkfs.ext4 /dev/sdb1

fi

echo ======== mount /data =====================

[ -d /data ]  || mkdir -p /data

if ( ! mount | grep -q \/data ) ; then
   sudo mount /dev/sdb1 /data
else
   echo /data mounted
fi

echo ========= install dev deps ==========================

if ! dpkg -l libx11-dev  ||  ! dpkg -l git
then
  sudo apt-get -y update
  sudo apt-get -y install git libx11-dev build-essential flex bison libpq-dev
fi


echo ======== /data/build =====================

[ -d /data/build ] || sudo mkdir -p /data/build
sudo chown vagrant /data/build 

cd /data/build

if [ ! -d /data/build/hb-linux-i386 ] ||  ( ! /data/build/hb-linux-i386/bin/hbmk2 --version ) ; then
  cd /data/build
  curl -s -LO http://download.bring.out.ba/hb-linux-i386.tar.gz
  tar xvfz hb-linux-i386.tar.gz
fi
 
[ -d F18_knowhow ] || git clone https://github.com/knowhow/F18_knowhow.git
cd F18_knowhow
git checkout 23100-ld -f
git pull

export PATH=/data/build/hb-linux-i386/bin:$PATH

echo ======== /data/build/F18_knowhow  =====================

source scripts/ubuntu_set_envars.sh
export F18_POS=1
export F18_RNAL=1
scripts/build_gz_push.sh Ubuntu_i686


git describe --tags > F18_VER
cp F18_VER /vagrant/
cp F18_Ubuntu_i686_`cat F18_VER`.gz /vagrant/
