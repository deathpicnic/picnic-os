#!/usr/bin/bash

patch -Np1 -i ../kbd-$PKG_VERSION-backspace-1.patch

sed -i '/RESIZECONS_PROGS=/s/yes/no/' configure
sed -i 's/resizecons.8 //' docs/man/man8/Makefile.in

./configure --prefix=/usr --disable-vlock

make -j`nproc`
#make check
make install

mkdir -pv /usr/share/doc/kbd-$PKG_VERSION
cp -R -v docs/doc/* /usr/share/doc/kbd-$PKG_VERSION
