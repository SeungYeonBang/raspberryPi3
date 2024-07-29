SUMMARY = "Image for raspberrypi3 image"
  
IMAGE_FEATURES += "splash package-management ssh-server-dropbear hwcodecs weston"

LICENSE = "MIT"

inherit core-image

CORE_IMAGE_BASE_INSTALL += "gtk+3-demo"
CORE_IMAGE_BASE_INSTALL += "${@bb.utils.contains('DISTRO_FEATURES', 'x11', 'weston-xwayland matchbox-terminal', '', d)}"

QB_MEM = "-m 512"

IMAGE_FSTYPES:append = " rpi-sdimg"

# Enable Debug feature
EXTRA_IMAGE_FEATURES:append = " dbg-pkgs tools-debug ssh-server-dropbear"

IMAGE_INSTALL:append = " less procps"
IMAGE_INSTALL:append = " util-linux"

IMAGE_INSTALL:append = " packagegroup-core-boot"
IMAGE_INSTALL:append = " packagegroup-base-extended"
IMAGE_INSTALL:append = " v4l-utils"
IMAGE_INSTALL:append = " libcamera"
IMAGE_INSTALL:append = " wpa-supplicant"
#IMAGE_INSTALL:append = " linux-firmware-rpidistro-bcm43430"

IMAGE_INSTALL:append = " ldd"
IMAGE_INSTALL:append = " dtc"
IMAGE_INSTALL:append = " lrzsz"
IMAGE_INSTALL:append = " i2c-tools"
IMAGE_INSTALL:append = " usbutils"
IMAGE_INSTALL:append = " pciutils"
IMAGE_INSTALL:append = " tcpdump"
IMAGE_INSTALL:append = " libusb1"

IMAGE_INSTALL:append = " gstreamer1.0"
IMAGE_INSTALL:append = " gstreamer1.0-omx"
IMAGE_INSTALL:append = " gstreamer1.0-plugins-good"
IMAGE_INSTALL:append = " gstreamer1.0-plugins-base"

IMAGE_INSTALL:append = " streaming-service"
