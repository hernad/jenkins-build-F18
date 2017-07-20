#!/bin/bash

BRANCH=`cat /vagrant/F18_BRANCH`

if [ -z "$BRANCH" ] ; then
  exit 1
fi

echo "branch=$BRANCH"

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
git checkout $BRANCH -f
git pull
git fetch --tags --force

export PATH=/data/build/hb-linux-i386/bin:$PATH

echo ======== /data/build/F18_knowhow  =====================

source scripts/ubuntu_set_envars.sh
export F18_POS=1
export F18_RNAL=1

F18_VER=`cat VERSION`
if [ -n "$F18_VER" ] && [ -f VERSION ] && [ ! -f /vagrant/F18_Ubuntu_i686_${F18_VER}.gz ] ; then
   git checkout -f $F18_VER
   scripts/build_gz_push.sh Ubuntu_i686 ${F18_VER}
   cp VERSION /vagrant/F18_VER
   cp F18_Ubuntu_i686_${F18_VER}.gz /vagrant/
else
   echo "F18_VER ${F18_VER} already exists"
fi

F18_VER_E=`cat VERSION_E`
if [ -n "$F18_VER_E" ] && [ -f VERSION_E ] &&  [ ! -f /vagrant/F18_Ubuntu_i686_${F18_VER_E}.gz ] ; then
   git checkout -f $F18_VER_E
   scripts/build_gz_push.sh Ubuntu_i686 ${F18_VER_E}
   cp VERSION_E /vagrant/F18_VER_E
   cp F18_Ubuntu_i686_${F18_VER_E}.gz /vagrant/
else
   echo "F18_VER_E ${F18_VER_E} already exists"
fi

F18_VER_X=`cat VERSION_X`
if [ -n "$F18_VER_X" ] &&  [ -f VERSION_X ] &&  [ ! -f /vagrant/F18_Ubuntu_i686_${F18_VER_X}.gz ] ; then
   git checkout -f $F18_VER_X
   scripts/build_gz_push.sh Ubuntu_i686 ${F18_VER_X}
   cp VERSION_X /vagrant/F18_VER_X
   cp F18_Ubuntu_i686_${F18_VER_X}.gz /vagrant/
else
   echo "F18_VER_X ${F18_VER_X} already exists"
fi

