#!/usr/bin/bash

./configure --prefix=/usr --sysconfdir=/etc
make -j`nproc`
make install
