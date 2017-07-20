#!/bin/bash

BRANCH=`cat //vboxsrv/vagrant/F18_BRANCH`
FILE="F18_Windows_*.gz"

export PATH=/c/msys32/mingw32/bin:C:\hbwin\bin:/mingw32/bin:/usr/local/bin:/usr/bin:/bin
export PATH=$PATH:/c/ProgramData/Oracle/Java/javapath
export PATH=$PATH:/c/WINDOWS/system32:/c/WINDOWS:/c/WINDOWS/System32/Wbem:/c/WINDOWS/System32/WindowsPowerShell/v1.0


#pacman --noconfirm -Sy mingw-w64-i686-icu mingw-w64-i686-curl

cd /c
echo ======= harbour dependency ===================
[ -d hbwin ] && rm -rf hbwin 
curl -LO https://download.bring.out.ba/hbwin.tar.gz
tar xf hbwin.tar.gz

if [ ! -d hbwin ] ; then
   echo "c:/hbwin not found?!"
   exit -1
fi
echo =============================================

echo == g drive for data ===
cd /g
git clone https://github.com/knowhow/F18_knowhow.git
cd F18_knowhow

git checkout $BRANCH -f
git pull
git fetch --tags --force

export HB_ARCHITECTURE=win
export HB_COMPILER=mingw

export PATH=/c/hbwin/bin:$PATH

harbour --version
hbmk2 --version

source scripts/mingw_msys2_set_envars.sh
export F18_POS=1
export F18_RNAL=1

rm $FILE




for f in VERSION VERSION_E VERSION_X
do

git checkout $BRANCH -f
F18_VER=`cat $f`

[ $f == "VERSION" ] && cp $f //vboxsrv/vagrant/F18_VER
[ $f == "VERSION_E" ] && cp $f //vboxsrv/vagrant/F18_VER_E
[ $f == "VERSION_X" ] && cp $f //vboxsrv/vagrant/F18_VER_X

FILE_GZ="F18_Windows_${F18_VER}.gz"

if [ -n "$F18_VER" ] && [ -f $f ] && [ ! -f //vboxrv/vagrant/$FILE_GZ ] ; then
   git checkout -f $F18_VER
   [ $? -ne 0 ] && echo "git checkout $F18_VER ERROR" && exit 1
   scripts/build_gz_push.sh Windows $F18_VER
   cp $FILE_GZ //vboxsrv/vagrant/
else
   echo "F18_VER ${F18_VER} already exists"
fi

done

