#!/usr/bin/bash

sed -i 's/extras//' Makefile.in
./configure --prefix=/usr
make -j`nproc`
#make check
make install

mkdir -pv /usr/share/doc/gawk-$PKG_VERSION
cp -v doc/{awkforai.txt,*.{eps,pdf,jpg}} /usr/share/doc/gawk-$PKG_VERSION
