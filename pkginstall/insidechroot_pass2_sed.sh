#!/usr/bin/bash

./configure --prefix=/usr
make -j`nproc`
make html

make install
install -d -m755 /usr/share/doc/sed-$PKG_VERSION
install -m644 doc/sed.html /usr/share/doc/sed-$PKG_VERSION
