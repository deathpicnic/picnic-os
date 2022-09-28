#!/usr/bin/bash

./configure --prefix=/usr \
    --docdir=/usr/share/doc/flex-$PKG_VERSION \
    --disable-static

make -j`nproc`
#make check
make install

ln -sv flex /usr/bin/lex
