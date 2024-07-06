#!/bin/sh

export MACHINE=my-rbp3
#export MACHINE=raspberrypi3-64
export IMAGE=core-image-rbp3
#export IMAGE=core-image-base
export DISTRO=poky

export YOCTO_DIR=`pwd`

alias  cdh='cd $YOCTO_DIR'
alias  cdb='cd $YOCTO_DIR/build'
alias  cdi='cd $YOCTO_DIR/build/tmp/deploy/images/$MACHINE'
alias  cdm='cd $YOCTO_DIR/meta-rbp3/recipes-rbp3/streaming-service/files/src'
alias  cleank='cd $YOCTO_DIR/build; bitbake -c cleansstate linux-raspberrypi'
alias  buildi='cd $YOCTO_DIR/build; bitbake $IMAGE'

function make_local_conf() {
cat << EOF > conf/local.conf
MACHINE = '$MACHINE'
DISTRO = '$DISTRO'
PACKAGE_CLASSES ?= 'package_rpm'
EXTRA_IMAGE_FEATURES ?= "debug-tweaks"
PATCHRESOLVE = "noop"
BB_DISKMON_DIRS ??= "\\
    STOPTASKS,\${TMPDIR},1G,100K \\
    STOPTASKS,\${DL_DIR},1G,100K \\
    STOPTASKS,\${SSTATE_DIR},1G,100K \\
    STOPTASKS,/tmp,100M,100K \\
    HALT,\${TMPDIR},100M,1K \\
    HALT,\${DL_DIR},100M,1K \\
    HALT,\${SSTATE_DIR},100M,1K \\
    HALT,/tmp,10M,1K"
PACKAGECONFIG:append:pn-qemu-system-native = " sdl"
CONF_VERSION = "2"

BB_NUMBER_THREADS="10"
PARALLEL_MAKE = "-j 10"

ENABLE_UART = "1"
ENABLE_KGBD = "1"

IMAGE_ROOTFS_EXTRA_SPACE = "4194304"
EOF
}

function make_bblayers_conf() {
cat << EOF > conf/bblayers.conf
LCONF_VERSION = "7"

BBPATH = "\${TOPDIR}"
BSPDIR := "\${@os.path.abspath(os.path.dirname(d.getVar('FILE', True)) + '/../..')}"

BBFILES ?= ""
BBLAYERS = " \\
  \${BSPDIR}/source/poky/meta \\
  \${BSPDIR}/source/poky/meta-poky \\
  \${BSPDIR}/source/poky/meta-yocto-bsp \\
  \\
  \${BSPDIR}/source/meta-openembedded/meta-oe \\
  \${BSPDIR}/source/meta-openembedded/meta-multimedia \\
  \${BSPDIR}/source/meta-openembedded/meta-networking \\
  \${BSPDIR}/source/meta-openembedded/meta-python \\
  \\
  \${BSPDIR}/source/meta-raspberrypi \\
"
BBLAYERS += "\${BSPDIR}/meta-rbp3"

EOF
}

OEROOT=$PWD/source/poky
. $OEROOT/oe-init-build-env build > /dev/null

grep "$MACHINE" conf/local.conf > /dev/null 2>&1
if [ $? -ne 0 ]; then
    make_local_conf
fi

grep "$MACHINE" conf/bblayer.conf > /dev/null 2>&1
if [ $? -ne 0 ]; then
    make_bblayers_conf
fi

cat <<EOF

[[[ MetaThermo-IMX8M Build ]]]

You can build image 
    # bitbake $IMAGE

command:
    cdh    : goto home directory
    cdb    : goto build directory
    cdi    : goto image directory
    cdm    : goto source directory
    cleank : build clean kernel
    buildi : build image
EOF

