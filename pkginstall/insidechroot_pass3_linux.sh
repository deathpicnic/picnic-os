#!/usr/bin/bash

make mrproper

make defconfig
make -j`nproc`
make modules_install

cp -iv arch/x86/boot/bzImage /boot/vmlinuz-$PKG_VERSION
cp -iv System.map /boot/System.map-$PKG_VERSION
cp -iv .config /boot/config-$PKG_VERSION

install -d /usr/share/doc/linux-$PKG_VERSION
cp -r Documentation/* /usr/share/doc/linux-$PKG_VERSION


install -v -m755 -d /etc/modprobe.d
cat > /etc/modprobe.d/usb.conf << "EOF"
# Begin /etc/modprobe.d/usb.conf
install ohci_hcd /sbin/modprobe ehci_hcd ; /sbin/modprobe -i ohci_hcd ; true
install uhci_hcd /sbin/modprobe ehci_hcd ; /sbin/modprobe -i uhci_hcd ; true
# End /etc/modprobe.d/usb.conf
EOF
