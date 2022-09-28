#!/usr/bin/bash

./configure --prefix=/usr --docdir=/usr/share/doc/automake-$PKG_VERSION
make -j`nproc`
#make -j4 check
make install
