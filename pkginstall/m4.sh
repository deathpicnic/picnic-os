#!/bin/bash

./configure --prefix=/usr \
--host=$PDP_TRGT \
--build=$(build-aux/config.guess)

make -j`nproc`
make DESTDIR=$PDP install
