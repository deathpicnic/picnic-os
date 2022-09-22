#!/bin/bash

PDP=""
PDP_EXTRACTED="$PDP/extracted"
PDP_SRC="$PDP/sources/"
PDP_PKGINSTALL="$PDP/pkginstall"
LOGS_DIR="$PDP/logs"
mkdir -p $LOGS_DIR

PKGInstall() {

    PACKAGE="$1"
    echo $PACKAGE
    TAR_PACKAGE="`echo $PACKAGE | cut -d'_' -f2`"
    TAR_FILENAME="`ls $PDP_SRC | grep -v "\.patch"| grep "^$TAR_PACKAGE.*"`"
    echo $TAR_FILENAME

    if [[ -f $PDP_SRC/$TAR_FILENAME ]]; then

        DIRNAME="$PDP_EXTRACTED/`awk -F '.tar'  '{print $1}' <<< $TAR_FILENAME`"
        export PKG_VERSION="`awk -F '.tar'  '{print $1}' <<< $TAR_FILENAME | cut -d"-" -f2`"

        if [[ ! -d $DIRNAME ]]; then
            mkdir -p $DIRNAME
            tar -xvf $PDP_SRC/$TAR_FILENAME --directory=$DIRNAME
        fi

            pushd $DIRNAME
                if [[ "`ls -A | wc -l`" == "1" ]]; then
                    mv `ls -A`/{,.}* .
                fi
                if [[ -f $PDP_PKGINSTALL/insidechroot_$PACKAGE.sh ]] ; then
                    if ! source $PDP_PKGINSTALL/insidechroot_$PACKAGE.sh ; then
                        echo "$PACKAGE -> Compiling Failed" && exit 1
                    fi
                fi
            popd

    else
        if [[ -f $PDP_PKGINSTALL/insidechroot_$PACKAGE.sh ]] ; then
            if ! source $PDP_PKGINSTALL/insidechroot_$PACKAGE.sh ; then
                echo "$PACKAGE -> Compiling Failed" && exit 1
            fi
        else echo "$PACKAGE -> not found related script or archive..." && exit 1
        fi
    fi

}

for package in $@
do
    PKGInstall $package | tee $LOGS_DIR/$package.log
done
