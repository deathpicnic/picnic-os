#!/usr/bin/bash


./configure --prefix=/usr \
    --disable-static \
    --docdir=/usr/share/doc/acl-$PKG_VERSION

make -j`nproc`
make install
