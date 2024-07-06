DESCRIPTION = "streaming-service"
LICENSE = "CLOSED"

DEPENDS = "weston gstreamer1.0 gstreamer1.0-plugins-base"

FILESEXTRAPATHS:prepend := "${THISDIR}:${THISDIR}/..:"

INSANE_SKIP:${PN} = "ldflags"
INHIBIT_PACKAGE_DEBUG_SPLIT = "1"
INHIBIT_PACKAGE_STRIP = "1"            
                
SRC_URI = "file://src \
           "

INITSCRIPT_NAME = "streaming-service"
INITSCRIPT_PARAMS = "start 99 5 2 ."

inherit pkgconfig update-rc.d

do_compile() {
   export TOPDIR=${TOPDIR}
   cd ${WORKDIR}/src
   make
}

do_install() {
    mkdir -p ${D}/home/root/streaming
    install ${WORKDIR}/src/out/StreamingService ${D}/home/root/streaming

    cp -rf ${WORKDIR}/src/res/fonts  ${D}/home/root/streaming
    cp -rf ${WORKDIR}/src/res/images  ${D}/home/root/streaming

    install -d ${D}${sysconfdir}/init.d
    install -m 0755 ${WORKDIR}/src/res/${INITSCRIPT_NAME}.init ${D}${sysconfdir}/init.d/${INITSCRIPT_NAME}
}

FILES:${PN} += "/home/root/streaming"
