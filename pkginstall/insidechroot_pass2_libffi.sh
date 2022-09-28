#!/usr/bin/bash

./configure --prefix=/usr \
    --disable-static \
    --with-gcc-arch=native \
    --disable-exec-static-tramp

make -j`nproc`
#make check
make install
