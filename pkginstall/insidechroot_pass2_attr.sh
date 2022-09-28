#!/usr/bin/bash

./configure --prefix=/usr \
    --disable-static \
    --sysconfdir=/etc \
    --docdir=/usr/share/doc/attr-$PKG_VERSION

make -j`nproc`
#make check
make install
