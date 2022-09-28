#!/usr/bin/bash

sed -i '/install -m.*STA/d' libcap/Makefile

make prefix=/usr lib=lib -j`nproc`
#make test
make prefix=/usr lib=lib install
