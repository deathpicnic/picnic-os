#!/usr/bin/bash

./configure --prefix=/usr
make -j`nproc`
make install
