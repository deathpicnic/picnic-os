#!/bin/bash

: '
    ----------------------------------
    PICNIC OS
    =========
    a LinuxFromScratch Project
    @deathpicnic
    ----------------------------------
'

export PDP=$PWD/build
export PDP_TRGT=`uname -m`-pdp-linux-gnu

export PDP_SRC=$PDP/sources
export PDP_PKGINSTALL=$PDP/pkginstall
export PDP_EXTRACTED=$PDP/extracted
export SCRPT_DIR=$PWD
export LOGS_DIR=$SCRPT_DIR/logs

_die()
{
    echo "[!] $*"
    exit 1
}

mkdir -pv $PDP/sources
chmod a+wt $PDP/sources
chmod +x $SCRPT_DIR/pkginstall/*.sh

mkdir -pv $PDP/pkginstall
cp -rvf $SCRPT_DIR/pkginstall/* $PDP_PKGINSTALL
mkdir -pv $PDP_EXTRACTED
mkdir -pv $LOGS_DIR

mkdir -pv $PDP/{boot,bin,lib,sbin,etc,var} $PDP/usr/{bin,lib,sbin}
export PATH="$PDP/tools/bin:$PATH"


case `uname -m` in
    x86_64) mkdir -pv $PDP/lib64 ;;
esac

mkdir -pv $PDP/tools/{bin,}

# # DOWNLOADS SRC-PKGs from URL inside ``wget-list``
cat wget-list | while read line; do

    URL=$line
    FILE="`basename $line`" || "`echo $line | rev | cut -d'/' -f1 | rev`"
    if [[ ! -f build/sources/$FILE ]]; then
        wget $URL --continue --directory-prefix=$PDP/sources
    fi

done

# # COMPARES SRC-PKGs md5sum inside ``md5sums`` file
pushd $PDP/sources
    md5sum -c $SCRPT_DIR/md5sums
popd

############ PKGINSTALL() ##########################################

for package in binutils gcc linux-api-headers glibc;
do
    source pkginstall.sh "$package"
done

pushd $PDP_EXTRACTED/gcc-*/
    source $PDP/pkginstall/libstdc++.sh
popd

for package in m4 ncurses bash coreutils diffutils file findutils gawk grep gzip make patch sed tar xz;
do
    source pkginstall.sh "$package"
done

# # PASS-2 [binutils, gcc]
# # ======================

for pass2_package in `ls $PDP/pkginstall/ | grep '_pass2.*'` ;
do
    PKG_PASS2_LOG="`echo $pass2_package | cut -d'.' -f1`.log"
    source $PDP/pkginstall/$pass2_package | tee $LOGS_DIR/$PKG_PASS2_LOG
done

# # ======================

echo "[+] DONE Building basics"
echo "========================"
echo "read logs at $LOGS_DIR/"
echo "-----------------------"
echo ""
echo "[+] Getting inside chroot Environmnet"


sudo ./prepare_chroot.sh "$PDP" || _die "Error Preparing chroot, Exitting"

cp -fv insidechroot.sh $PDP/init.sh
cp -fv insidechroot2.sh $PDP/init2.sh
cp -fv insidechroot3.sh $PDP/init3.sh
cp -fv insidechroot4.sh $PDP/init4.sh

for INIT in init init2 init3 init4;
do
    sudo chroot "$PDP" /usr/bin/env -i \
        HOME=/root \
        TERM="$TERM" \
        INIT="$INIT" \
        PDP="/" \
        hostname="$USER" \
        PS1='(pdp chroot) \u:\w\$ ' \
        PATH=/usr/bin:/usr/sbin:/bin:/sbin \
        bash --login -c './$INIT.sh | tee $INIT.log'

    rm -f $PDP/$INIT.sh
done

sudo ./unprepare_chroot.sh "$PDP" || _die "Error unpreparing chroot, make sure to unmount manually everything inside <BUILD_DIR>, Exitting..."

echo "[!] Creating Backup -> $HOME/$PDP_TRGT-chroot-`date | cut -d" " -f3`-`date | cut -d" " -f2`.tar.gz"

tar -czf $HOME/$PDP_TRGT-chroot-`date | cut -d" " -f3`-`date | cut -d" " -f2`.tar.gz --exclude=$PDP/extracted/ $PDP/

echo "[+] DONE creating backup"
echo "========================"
echo ""
echo "Picnic OS @deathpicnic"
echo ""

