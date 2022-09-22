#!/usr/bin/bash

./configure --prefix=/usr \
    --docdir=/usr/share/doc/bison-$PKG_VERSION
make -j`nproc`
make install
