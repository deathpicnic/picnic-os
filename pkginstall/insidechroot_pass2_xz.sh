#!/usr/bin/bash

./configure --prefix=/usr \
    --disable-static \
    --docdir=/usr/share/doc/xz-$PKG_VERSION

make -j`nproc`
#make check
make install
