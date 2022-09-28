#!/usr/bin/bash

./configure --prefix=/usr \
    --enable-shared \
    --with-system-expat \
    --with-system-ffi \
    --enable-optimizations

make -j`nproc`
#make test
make install

python3 -m ensurepip

cat > /etc/pip.conf << EOF
[global]
root-user-action = ignore
disable-pip-version-check = true
EOF

install -v -dm755 /usr/share/doc/python-$PKG_VERSION/html

tar --strip-components=1 \
    --no-same-owner \
    --no-same-permissions \
    -C /usr/share/doc/python-$PKG_VERSION/html \
    -xvf /sources/python-$PKG_VERSION-docs-html.tar.bz2
