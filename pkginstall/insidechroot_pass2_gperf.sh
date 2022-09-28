#!/usr/bin/bash

./configure --prefix=/usr --docdir=/usr/share/doc/gperf-3.1
make -j`nproc`
#make -j1 check
make install
