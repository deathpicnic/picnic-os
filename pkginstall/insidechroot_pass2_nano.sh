#!/usr/bin/bash

./configure --prefix=/usr \
    --enable-nanorc \
    --enable-color

make -j`nproc`
make install
