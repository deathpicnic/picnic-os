#!/bin/bash

./configure --prefix=/usr \
    --build=$(support/config.guess) \
    --host=$PDP_TRGT \
    --without-bash-malloc

make -j`nproc`
make DESTDIR=$PDP install
ln -sv bash $PDP/bin/sh || echo "maybe file already exists..."
