#!/usr/bin/bash

./configure --prefix=/usr \
    --docdir=/usr/share/doc/man-db-$PKG_VERSION \
    --sysconfdir=/etc \
    --disable-setuid \
    --enable-cache-owner=bin \
    --with-browser=/usr/bin/lynx \
    --with-vgrind=/usr/bin/vgrind \
    --with-grap=/usr/bin/grap \
    --with-systemdtmpfilesdir= \
    --with-systemdsystemunitdir=

make -j`nproc`
#make check
make install
