#!/usr/bin/bash

./configure --prefix=/usr \
    --sysconfdir=/etc \
    --disable-efiemu \
    --disable-werror

make -j`nproc`
make install
mv -v /etc/bash_completion.d/grub /usr/share/bash-completion/completions
