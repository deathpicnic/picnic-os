#!/bin/bash

./configure --prefix=/usr \
    --host=$PDP_TRGT

make -j `nproc`
make DESTDIR=$PDP install
