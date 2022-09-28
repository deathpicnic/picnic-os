#!/usr/bin/bash

case $(uname -m) in
i?86) TIME_T_32_BIT_OK=yes ./configure --prefix=/usr --localstatedir=/var/lib/locate ;;
x86_64) ./configure --prefix=/usr --localstatedir=/var/lib/locate ;;
esac

make -j`nproc`
# chown -Rv tester .
# su tester -c "PATH=$PATH make check"
make install
