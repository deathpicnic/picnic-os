#!/usr/bin/bash

./configure --prefix=/usr
make -j`nproc`
#make check
make install
rm -fv /usr/lib/libz.a
