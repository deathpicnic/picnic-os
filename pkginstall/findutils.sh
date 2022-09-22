#!/bin/bash

./configure --prefix=/usr \
    --localstatedir=/var/lib/locate \
    --host=$PDP_TRGT \
    --build=$(build-aux/config.guess)

make -j`nproc`
make DESTDIR=$PDP install
