#!/usr/bin/bash

patch -Np1 -i /sources/sysvinit-*.patch
make -j`nproc`
make install
