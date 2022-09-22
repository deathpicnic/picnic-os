#!/bin/bash

./configure --prefix=/usr \
    --host=$PDP_TRGT \
    --build=$(build-aux/config.guess) \
    --disable-static \
    --docdir=/usr/share/doc/xz-5.2.6

make -j`nproc`
make DESTDIR=$PDP install
rm -v $PDP/usr/lib/liblzma.la || echo ""
