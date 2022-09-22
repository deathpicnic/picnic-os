#!/bin/bash

make mrproper

make headers -j`nproc`
find usr/include -type f ! -name '*.h' -delete
cp -rv usr/include $PDP/usr
