FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://config.txt"

KBUILD_DEFCONFIG = "bcmrpi3_defconfig"


do_configure:append() {
    cat ${WORKDIR}/config.txt >> ${BOOTDIR}/config.txt
}
