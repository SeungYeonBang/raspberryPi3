FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += " \
        file://config.txt \
        file://cmdline.txt \
"

KBUILD_DEFCONFIG = "bcmrpi3_defconfig"

do_deploy:append() {
    install -m 0644 ${WORKDIR}/config.txt ${DEPLOYDIR}/config.txt
    install -m 0644 ${WORKDIR}/cmdline.txt ${DEPLOYDIR}/cmdline.txt
}
