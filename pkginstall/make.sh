#!/bin/bash

./configure --prefix=/usr \
    --without-guile \
    --host=$PDP_TRGT \
    --build=$(build-aux/config.guess)

make -j`nproc`
make DESTDIR=$PDP install
