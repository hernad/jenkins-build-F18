#!/bin/bash


BRANCH=23100-ld

export PATH=/c/msys32/mingw32/bin:C:\hbwin\bin:/mingw32/bin:/usr/local/bin:/usr/bin:/bin
export PATH=$PATH:/c/ProgramData/Oracle/Java/javapath
export PATH=$PATH:/c/WINDOWS/system32:/c/WINDOWS:/c/WINDOWS/System32/Wbem:/c/WINDOWS/System32/WindowsPowerShell/v1.0


echo msys2 build step 3


cd /c
if [ ! -d hbwin ] ; then
   curl -LO https://download.bring.out.ba/hbwin.tar.gz
   tar xvf hbwin.tar.gz
fi

if [ ! -d hbwin ] ; then
   echo "c:/hbwin not found?!"
   exit -1
fi

echo == g drive for data ===
cd /g
git clone https://github.com/knowhow/F18_knowhow.git
cd F18_knowhow

git checkout $BRANCH -f
git pull


export HB_ARCHITECTURE=win
export HB_COMPILER=mingw

C_ROOT=C:


HB_ROOT=$C_ROOT\\hbwin
export PATH=$HB_ROOT\\bin:$PATH

harbour --version
hbmk2 --version

source scripts/mingw_msys2_set_envars.sh

scripts/build_gz_push.sh Windows


cp F18_Windows*.gz //vboxsrv/vagrant/

