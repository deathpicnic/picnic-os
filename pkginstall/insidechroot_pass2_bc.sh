#!/usr/bin/bash

CC=gcc ./configure --prefix=/usr -G -O3 -r
make -j`nproc`
#make check
make install
