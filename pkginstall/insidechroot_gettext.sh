#!/usr/bin/bash

./configure --disable-shared
make -j`nproc`
cp -fv gettext-tools/src/{msgfmt,msgmerge,xgettext} /usr/bin
