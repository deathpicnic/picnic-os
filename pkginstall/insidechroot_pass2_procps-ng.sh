#!/usr/bin/bash

./configure --prefix=/usr \
    --docdir=/usr/share/doc/procps-ng-$PKG_VERSION \
    --disable-static \
    --disable-kill

make -j`nproc`
#make check
make install
