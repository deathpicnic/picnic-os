#!/usr/bin/bash

cp -v configfsf.guess config.guess
cp -v configfsf.sub config.sub

./configure --prefix=/usr \
    --enable-cxx \
    --disable-static \
    --docdir=/usr/share/doc/gmp-$PKG_VERSION

make -j`nproc`
make html
make check 2>&1 | tee gmp-check-log

awk '/# PASS:/{total+=$3} ; END{print total}' gmp-check-log
