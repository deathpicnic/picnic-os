#!/usr/bin/bash

./configure --prefix=/usr \
    --disable-static \
    --docdir=/usr/share/doc/mpc-$PKG_VERSION

make -j`nproc`
make html
#make check
make install
make install-html
