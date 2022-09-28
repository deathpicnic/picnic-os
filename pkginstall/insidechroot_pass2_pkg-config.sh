#!/usr/bin/bash

./configure --prefix=/usr \
    --with-internal-glib \
    --disable-host-tool \
    --docdir=/usr/share/doc/pkg-config-$PKG_VESION

make -j`nproc`
#make check
make install
