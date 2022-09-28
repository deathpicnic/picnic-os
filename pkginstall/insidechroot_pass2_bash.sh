#!/usr/bin/bash

./configure --prefix=/usr \
    --docdir=/usr/share/doc/bash-$PKG_VERSION \
    --without-bash-malloc \
    --with-installed-readline

make -j`nproc`
make install
