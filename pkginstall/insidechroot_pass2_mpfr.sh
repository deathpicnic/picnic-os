#!/usr/bin/bash

./configure --prefix=/usr \
    --disable-static \
    --enable-thread-safe \
    --docdir=/usr/share/doc/mpfr-$PKG_VERSION

make -j`nproc`
make html
#make check
make install
make install-html
